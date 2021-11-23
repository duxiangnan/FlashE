//
//  FEHttpPageManager.h
//  VipServicePlatform
//
//  Created by Harry on 16/4/21.
//  Copyright © 2016年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FEHttpManager.h"
//@interface FEPageInfoModel : NSObject
//
//@property (nonatomic, assign) NSInteger pageNow;
//@property (nonatomic, assign) NSInteger pageIndex;
//@property (nonatomic, assign) NSInteger pageSize;
//@property (nonatomic, assign) NSInteger totalCount;
//@property (nonatomic, assign) NSInteger totalPage;
//
//@end

@interface FEHttpPageManager : NSObject

@property (nonatomic, copy, readonly) NSArray   *dataArr;
@property (nonatomic, strong, readonly) NSError *networkError;
@property (nonatomic, strong, readonly) Class  itemClass;
@property (nonatomic, copy) NSString*  resultName;
@property (nonatomic, assign) NSInteger requestMethod;//请求方式 0：post  1:get  default 0


@property (nonatomic, assign) NSInteger pageCurrent;
@property (nonatomic, strong) NSDictionary  *wholeDict;// 整体的字典内容
@property (nonatomic, copy) FEHTTPAPICancel cancleBlock;//cance回调

- (BOOL)hasMore;

- (void)fetchData:(void (^)(void))completion;

- (void)fetchMoreData:(void (^)(void))completion;

- (void)resetParameters:(NSDictionary *)parameters;



- (instancetype)initWithFunctionId:(NSString *)functionId parameters:(NSDictionary *)parameters
                         itemClass:(Class)itemClass;

- (void) setkeyIndex:(NSString*)key size:(NSString*)sizeKey;
- (void)cancleCurrentRequest;
@end
