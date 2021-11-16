//
//  VSPBaseService.m
//  VipServicePlatform
//  刷新服务
//  Created by Harry on 16/4/21.
//  Copyright © 2016年 JD. All rights reserved.
//

#import "FEHttpPageManager.h"
#import "FEDefineModule.h"
#import "FEPublicMethods.h"
#import "FEAccountManager.h"

#import <YYModel/YYModel.h>


@interface FEHttpPageManager ()
@property (nonatomic, copy) NSString            *functionId;
@property (nonatomic, weak) NSURLSessionTask    *urlTask;
@property (nonatomic, copy) NSArray             *dataArr;

@property (nonatomic, strong) NSError           *networkError;
@property (nonatomic, copy) NSMutableDictionary *parameters;
@property (nonatomic, assign) BOOL haveMore;
@end

@implementation FEHttpPageManager
- (instancetype)initWithFunctionId:(NSString *)functionId parameters:(NSDictionary *)parameters
                         itemClass:(Class)itemClass
{
    if (self = [self init]) {
        _haveMore = YES;
        
        _pageCurrent = 1;
        _functionId = functionId;
        _parameters = [NSMutableDictionary dictionary];
        [_parameters addEntriesFromDictionary:parameters];
        _itemClass = itemClass;
    }

    return self;
}

- (void)dealloc
{
    [_urlTask cancel];
}

- (BOOL)hasMore
{
    return self.dataArr.count > 0 && _haveMore;
}

- (void)fetchData:(void (^)(void))completion
{
    [self _fetchDataList:1 completion:completion];
}

- (void)fetchMoreData:(void (^)(void))completion
{
    [self _fetchDataList:_pageCurrent + 1 completion:completion];
}

- (void)resetParameters:(NSDictionary *)parameters {
    _parameters = parameters.copy;
}

- (void)_fetchDataList:(NSInteger)page completion:(void (^)(void))completion
{
    @weakself(self)
    FEHTTPAPIFailBlock failure = ^(NSError *error, id response) {
        @strongself(weakSelf);
        strongSelf.networkError = error;

        if (error.code != kCFURLErrorCancelled) {
            !completion ? : completion();
        } else {
            !strongSelf.cancleBlock?:strongSelf.cancleBlock();
        }
    };

    FEHTTPAPISuccessBlock success = ^(NSInteger code, NSDictionary *responseObject) {
        // trackMyOrder 物流信息做特殊处理
        @strongself(weakSelf);
        strongSelf.wholeDict = responseObject;
        
        NSArray* arr = [responseObject valueForKeyPath:strongSelf.resultName];
        NSArray* items = [NSArray yy_modelArrayWithClass:strongSelf.itemClass json:arr];
        self.haveMore = arr.count > 0;
        strongSelf.pageCurrent = page;
        if (page <= 1) {
            strongSelf.pageCurrent = 1;
            strongSelf.dataArr = items;
        } else {
            NSMutableArray *loaded = [NSMutableArray arrayWithArray:strongSelf.dataArr];
            [loaded addObjectsFromArray:items];
            strongSelf.dataArr = loaded.copy;
        }
        strongSelf.networkError = nil;
        !completion ? : completion();
        
    };

    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:_parameters];
    param[@"pageIndex"] = @(page);
    if (!param[@"pageSize"]) {
        param[@"pageSize"] = @(20);
    }
    
    _urlTask = [[FEHttpManager defaultClient] POST:self.functionId
            parameters:param
               success:success
               failure:failure
                cancle:self.cancleBlock];

    
  
}

- (void)setResultName:(NSString *)resultName {
    _resultName = resultName.copy;
}


- (void)cancleCurrentRequest {
    if (_urlTask) {
        [_urlTask cancel];
    }
}

@end
