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
@property (nonatomic, strong) NSDictionary* platFormInfo;

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
        aesInput = [FEAESCrypt encryptAES:inputPin key:[FEDefineModule FE_DES_NEWKEY]];
    }
    [[NSUserDefaults standardUserDefaults]setObject:aesInput forKey:@"username"];
    
}
+ (NSString *)getPin{
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *realUserName = nil;
    if (userName.length > 0) {
        realUserName = [FEAESCrypt decryptAES:userName key:[FEDefineModule FE_DES_NEWKEY]];
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
            if (!ret.selectedStore) {
                ret.selectedStore = ret.storeList.firstObject;
            }
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
- (NSString*) getPlatFormInfo:(NSString*)plat type:(FEPlatforeKey)type {
    
    if (!_platFormInfo) {
        
    
        _platFormInfo = @{
            @"bingex":@{@"phone":@"4006126688",@"flage":@"logistic_shansong"},//闪送
            @"shunfeng":@{@"phone":@"9533868",@"flage":@"logistic_shunfeng"},//顺丰同城
            @"mtps":@{@"phone":@"10107888",@"flage":@"logistic_meituan"},//美团跑腿
            @"fengka":@{@"phone":@"4008827777",@"flage":@"logistic_fengxiao"},//蜂鸟即配
            @"dada":@{@"phone":@"4009919512",@"flage":@"logistic_dada"},//达达
            @"uupt":@{@"phone":@"4006997999",@"flage":@"logistic_uu"}//UU跑腿
        };
    }
    NSDictionary* tmp = _platFormInfo[plat];
    switch (type) {
        case FEPlatforeKeyPhone:
            return tmp[@"phone"];
            break;
        case FEPlatforeKeyFlage:
            return tmp[@"flage"];
            break;
        default:
            break;
    }
    return @"";
    
}


- (FEMyStoreModel*) getStoreWithId:(NSString*)storeId {
    FEMyStoreModel* store = nil;
    for (FEMyStoreModel* item in self.account.storeList) {
        if (item.ID == storeId.integerValue) {
            store = item;
            break;
        }
    }
    return store;
}

- (void) updateSeletedStore {
    
    
}
@end
