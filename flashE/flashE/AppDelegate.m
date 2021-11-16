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
#import "FEWalletVC.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import <FFRouter/FFRouter.h>
//#import "FEDefineModule.h"

@interface AppDelegate ()

@property (nonatomic) IIViewDeckController *viewDeckController;
@property (nonatomic) UIViewController *currentVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
//    [FEDefineModule setDebug_mode:@"1"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucAction:)
                                                 name:@"FELoginSucced" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutAction:)
                                                 name:@"FEDidLogout" object:nil];
    [self resetRootVC];

    [self.window makeKeyAndVisible];
    return YES;
}

- (void) resetRootVC {

    if ([[FEAccountManager sharedFEAccountManager] hasLogin]) {
        FEHomeVC* homeVC = [[FEHomeVC alloc] init];
        self.currentVC = homeVC;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
        
        menuViewContorller* vc = [[menuViewContorller alloc] initWithNibName:@"menuViewContorller" bundle:nil];
        
        UINavigationController *menu = [[UINavigationController alloc] initWithRootViewController:vc];

        IIViewDeckController *viewDeckController = [[IIViewDeckController alloc] initWithCenterViewController:navigationController leftViewController:menu];
        self.viewDeckController = viewDeckController;
        self.window.rootViewController = viewDeckController;
        
        [FFRouter registerRouteURL:@"deckControl://show" handler:^(NSDictionary *routerParameters) {
            [self.viewDeckController openSide:IIViewDeckSideLeft animated:YES];
        }];
        [FFRouter registerRouteURL:@"deckControl://changeSecen" handler:^(NSDictionary *routerParameters) {
            NSString* vcType = routerParameters[@"vcType"];
            switch (vcType.integerValue) {
                case 1:{
                    if (![self.currentVC isKindOfClass:[FEHomeVC class]]) {
                        FEHomeVC* homeVC = [[FEHomeVC alloc] init];
                        self.currentVC = homeVC;
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:homeVC];
                        self.viewDeckController.centerViewController = navigationController;
                    }
                    [self.viewDeckController closeSide:YES];
                }break;
                case 2:{
                    if (![self.currentVC isKindOfClass:[FEWalletVC class]]) {
                        UIViewController* vc = [[FEWalletVC alloc] init];
                        self.currentVC = vc;
                        vc.view.backgroundColor = UIColor.redColor;
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                        self.viewDeckController.centerViewController = navigationController;
                    }
                    [self.viewDeckController closeSide:YES];
                }break;
                case 3:{}break;
                case 4:{}break;
                case 5:{}break;
                case 6:{}break;
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
    
    
    return YES;
}


- (void) loginSucAction:(NSNotification*)noti {
    [self resetRootVC];
}

- (void) logoutAction:(NSNotification*)noti {
    [self resetRootVC];
}
@end
