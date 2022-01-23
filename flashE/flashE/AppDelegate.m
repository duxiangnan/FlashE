//
//  AppDelegate.m
//  flashE
//
//  Created by duxiangnan on 2021/10/28.
//

#import "AppDelegate.h"
#import "FEAccountManager.h"
#import "FELoginVC.h"

#import <ViewDeck/ViewDeck.h>
#import "menuViewContorller.h"
#import "FEHomeVC.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <FFRouter/FFRouter.h>
#import "FEDefineModule.h"



#import "WXApiManager.h"



@interface AppDelegate ()<WXApiDelegate>

@property (nonatomic) IIViewDeckController *viewDeckController;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [FEDefineModule setDebug_mode:@"1"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucAction:)
                                                 name:@"FELoginSucced" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutAction:)
                                                 name:@"FEDidLogout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateStoreNoti:)
                                                 name:@"FEUpdateStore" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePayInfo:)
                                                 name:@"paySuccess" object:nil];
    [self resetRootVC];

    [self.window makeKeyAndVisible];
    
    
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
        NSLog(@"WeChatSDK log : %@", log);
    }];
    

//    //调用自检函数
//    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
//        NSLog(@"%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
//    }];

    
    
    
    
    return YES;
}
- (UINavigationController*) getViewDeckNavi {
    return self.viewDeckController.centerViewController;
}
- (void) resetRootVC {

    if ([[FEAccountManager sharedFEAccountManager] hasLogin]) {
        UIViewController* homeVC = [FFRouter routeObjectURL:@"home://createhome"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
        
        menuViewContorller* vc = [[menuViewContorller alloc] initWithNibName:@"menuViewContorller" bundle:nil];
        UINavigationController *menu = [[UINavigationController alloc] initWithRootViewController:vc];
        

        IIViewDeckController *viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:navigationController leftViewController:menu];
        self.viewDeckController = viewDeckController;
        self.window.rootViewController = viewDeckController;
        
        [FFRouter registerRouteURL:@"deckControl://show" handler:^(NSDictionary *routerParameters) {
            [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
        }];
        [FFRouter registerRouteURL:@"deckControl://updateAccount" handler:^(NSDictionary *routerParameters) {
            [self requestUpdateAccount];
        }];
        [FFRouter registerRouteURL:@"deckControl://changeSecen" handler:^(NSDictionary *routerParameters) {
            NSString* vcType = routerParameters[@"vcType"];
            switch (vcType.integerValue) {
                case 1:{//我的店铺
                    [self.viewDeckController closeSide:YES];
                    UIViewController* vc = [FFRouter routeObjectURL:@"store://createStoreManager"];
                    [[self getViewDeckNavi] pushViewController:vc animated:YES];
                    
                }break;
                case 2:{//我的钱包
                    [self.viewDeckController closeSide:YES];
                    UIViewController* vc = [FFRouter routeObjectURL:@"recharge://createRechange"];
                    [[self getViewDeckNavi] pushViewController:vc animated:YES];
                }break;
                case 3:{//订单语音播报
                    
                }break;
                case 4:{//用户隐私
                    
                        
                }break;
                case 5:{//隐私协议
                    
                }break;
                case 6:{//版本号
                    
                }break;
                case 7:{//语音设置
                    
                }break;
                case 8:{//客户经理
//                    [self.viewDeckController closeSide:YES];
//                    UIViewController* vc = [FFRouter routeObjectURL:@"manger://createMy"];
//                    [[self getViewDeckNavi] pushViewController:vc animated:YES];
                    
                }break;
                default:
                    break;
            }
        }];

    } else {
        FELoginVC* vc = [[FELoginVC alloc] initWithNibName:@"FELoginVC" bundle:nil];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
        self.window.rootViewController = navi;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
//    [[SDImageCache sharedImageCache]setValue:nil forKey:@"memCache"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application {

    if ([[FEAccountManager sharedFEAccountManager] hasLogin]) {
        [self requestUpdateAccount];
        [self requestUpdateStoreList];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
//    //上报device token
//    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//
//    [JDPushService sendDeviceToken:deviceToken completion:^(NSString *_Nullable token, NSError *_Nullable error) {
//        if (!error) {} else {}
//    }];
//     NSLog(@"%@=====",[JDPushService latestCacheDeviceToken]);
//    //
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(nonnull UIUserNotificationSettings *)notificationSettings
{
    // register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //上报最新查看Push方法
    // 注意在前台收到推送也会进入该方法，不要调用上报方法
//    [JDPushService handleNotification:userInfo completion:nil];
//    if (application.applicationState != UIApplicationStateActive) {
//        [self pushMessageJumpWithAppState:NO WithMessageDict:userInfo];
//    }
}

#pragma mark--分享回调
#if __IPHONE_OS_VERSION_MAX_ALLOWED <__IPHONE_9_0
    - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
      sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation
{
    BOOL flag = NO;

    @try {
        flag = [self myApplication:application openURL:url];
    } @catch(NSException *exception) {} @finally {}

    return flag;
}

#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
        options:(nonnull NSDictionary <NSString *, id> *)options
{
    BOOL flag = NO;

    @try {
        flag = [self myApplication:application openURL:url];
    } @catch(NSException *exception) {} @finally {}

    return flag;
}

#endif




- (BOOL)myApplication:(UIApplication *)application openURL:(NSURL *)url {
    
    
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler {
    NSLog(@"收到webpageURL 链接 %@",userActivity.webpageURL.absoluteString);
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb]) {
        NSURL *url = userActivity.webpageURL;
       // TODO 根据需求进行处理
    }
      // TODO 根据需求进行处理
//    return YES;
    
    
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}
#pragma mark Universal Link



- (void) loginSucAction:(NSNotification*)noti {
    [self resetRootVC];
    [self requestUpdateStoreList];
}

- (void) logoutAction:(NSNotification*)noti {
    [self resetRootVC];
}

- (void) requestUpdateAccount {
    
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    [[FEHttpManager defaultClient] GET:@"/deer/user/queryUserById?"
                            parameters:@{@"id":@(acc.ID)} success:^(NSInteger code, id  _Nonnull response) {
        NSDictionary* data = response[@"data"];
        FEAccountModel* model = [FEAccountModel yy_modelWithDictionary:data];
        FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
        acc.type = model.type;
        acc.shopId = model.shopId;
        acc.storeId = model.storeId;
        acc.loginName = model.loginName;
        acc.storeName = model.storeName;
        acc.mobile = model.mobile;
        acc.balance = model.balance;
        [[FEAccountManager sharedFEAccountManager] setLoginInfo:acc];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        
    } cancle:^{
    
    }];
}


- (void) requestUpdateStoreList {
    
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"shopId"] = @(acc.shopId);
    [[FEHttpManager defaultClient] GET:@"/deer/store/queryStoresByShopId" parameters:param
      success:^(NSInteger code, id  _Nonnull response)
    {
        acc.storeList = [NSArray yy_modelArrayWithClass:[FEMyStoreModel class] json:((NSDictionary*)response)[@"data"]];
        [self updateStoreNoti:nil];
        [[FEAccountManager sharedFEAccountManager] setLoginInfo:acc];
        
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        
    } cancle:^{
        
    }];

}
-(void)updateStoreNoti:(NSNotification*)noti {
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    FEMyStoreModel* notiStore = noti.userInfo[@"store"];
    
    acc.selectedStore = notiStore;
    [acc updataSelectedStore];
//    if (!notiStore) {
//        __block BOOL userDefault = YES;
//        if (acc.selectedStore) {
//            [acc.storeList enumerateObjectsUsingBlock:
//             ^(FEMyStoreModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (obj.ID == acc.selectedStore.ID) {
//                    userDefault = NO;
//                    *stop = YES;
//                }
//            }];
//        }
//        if (userDefault) {
//            acc.selectedStore = acc.storeList.firstObject;
//        }
//    } else {
//        acc.selectedStore = notiStore;
        [[FEAccountManager sharedFEAccountManager] setLoginInfo:acc];
//    }
}
- (void) updatePayInfo:(NSNotification*)noti {
    [self requestUpdateAccount];
}
@end
