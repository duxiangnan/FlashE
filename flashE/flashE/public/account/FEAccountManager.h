//
//  FEAccountManager.h
//  VipServicePlatform
//
//  Created by JD on 6/1/16.
//  Copyright © 2016 JD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FEAccountModel.h"
#import "FEAddressModel.h"


typedef enum : NSUInteger {
    FEPlatforeKeyPhone = 0,//平台客服电话
    FEPlatforeKeyFlage,//平台图片
    
} FEPlatforeKey;
@interface FEAccountManager : NSObject
+ (instancetype)sharedFEAccountManager;

+ (void)saveIuputPin:(NSString *)inputPin;
+ (NSString *)getPin;

+ (BOOL)isLoginedIn;

- (BOOL)hasLogin;
- (void)logout;
// 登录信息
- (void)setLoginInfo:(FEAccountModel *)model;
- (FEAccountModel *)getLoginInfo;


- (NSString*) getPlatFormInfo:(NSString*)plat type:(FEPlatforeKey)type;
- (FEMyStoreModel*) getStoreWithId:(NSString*)storeId;
@end
