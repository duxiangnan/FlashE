//
//  FEAccountManager.m
//  VipServicePlatform
//
//  Created by JD on 6/1/16.
//  Copyright © 2016 JD. All rights reserved.
//

#import "FEAccountManager.h"
#import "FEAESCrypt.h"
#import "FEDefineModule.h"
#import "NSString-umbrella.h"

@interface FEAccountManager ()

@property (nonatomic, strong) FEAccountModel *account;// 登陆信息
@end

@implementation FEAccountManager

+ (instancetype)sharedFEAccountManager
{
    static id sharedManager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManager = [[FEAccountManager alloc] init];
        [sharedManager getLoginInfo];
    });
    return sharedManager;
}

+ (void)saveIuputPin:(NSString *)inputPin{
    NSString *aesInput = @"";
    if (inputPin.length > 0) {
        aesInput = [FEAESCrypt encryptAES:inputPin key:[FEDefineModule JD_DES_NEWKEY]];
    }
    [[NSUserDefaults standardUserDefaults]setObject:aesInput forKey:@"username"];
    
}
+ (NSString *)getPin{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *realUserName = nil;
    if (userName.length > 0) {
        realUserName = [FEAESCrypt decryptAES:userName key:[FEDefineModule JD_DES_NEWKEY]];
    }
    return realUserName;
}

+ (BOOL)isLoginedIn{
    
    return [FEAccountManager getPin];
}


- (BOOL)hasLogin {
    return self.account.token.length > 0;
}

- (void)logout {
    [self logoutBpin:YES];
}
- (void)logoutBpin:(BOOL)sendOtherAciont {
    
    if (sendOtherAciont) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FEWillLogout" object:nil userInfo:nil];
    }
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [self setLoginInfo:nil];
    [user synchronize];
    if (sendOtherAciont) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FEDidLogout" object:nil userInfo:nil];
    }
    
}



#pragma mark -- Login

// 默认地址 1,2816,6667,0  北京密云区城区
- (void)setLoginInfo:(FEAccountModel *)loginModel {
    

    if (loginModel) {
        self.account = loginModel;
        [self archiverLoginInfo:loginModel];
        [FEAccountManager saveIuputPin:loginModel.mobile];
    } else {
        self.account = nil;
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user removeObjectForKey:@"userlogin"];
        [user synchronize];
    }
}

- (FEAccountModel *)getLoginInfo {
    if (_account) {
        return _account;
    }
    @try {
        id udObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"userlogin"];
        if (udObject) {
            FEAccountModel *ret = [NSKeyedUnarchiver unarchiveObjectWithData:udObject];
            [self setLoginInfo:ret];
            return ret;
        }
        return nil;
    }
    @catch(NSException *exception) {
        return nil;
    }
}


- (void) archiverLoginInfo:(FEAccountModel *)loginModel {
    if (loginModel) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginModel];
        [user setObject:data forKey:@"userlogin"];
        [user synchronize];
    }
}


@end
