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
@end
