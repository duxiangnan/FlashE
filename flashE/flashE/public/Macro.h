//
//  Macro.h
//  oversea_jv
//
//  Created by Harry on 16/4/14.
//  Copyright © 2016年 JD.com. All rights reserved.
//

#import <objc/message.h>

#define kScreenWidth        [UIScreen mainScreen].bounds.size.width
#define kScreenHeight       [UIScreen mainScreen].bounds.size.height

// 判断是否是ipad
#define isPad               ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iPhone4系列
#define kiPhone4            ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone5系列
#define kiPhone5            ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone6系列
#define kiPhone6            ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iphone6+系列
#define kiPhone6Plus        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneX
#define IS_IPHONE_X         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPHoneXr
#define IS_IPHONE_Xr        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs        ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define Height_Indicator    ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 34.0 : 0.0)

// 判断iPhoneX系列，刘海屏无指纹键
#define KIsPhoneSeries                                                                                \
    ({BOOL isPhoneX = NO;                                                                             \
      if (@available(iOS 11.0, *)) {                                                                  \
          isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
      }                                                                                               \
      (isPhoneX);})

// 信息栏
#define kHomeInformationBarHeigt    (KIsPhoneSeries ? 44.0 : 20.0)
#define kHomeNavigationHeight       (KIsPhoneSeries ? 88.0 : 64.0)
// 获取设备HomeIndicator高度
#define kHomeIndicatorHeight        ((KIsPhoneSeries) ? 34.0 : 0.0)

#define k_Height_NavBar_WhenHidden(hidden) (KIsPhoneSeries ? (hidden ? 44.0 : 88.0) : (hidden ? 20.0 : 64.0))

#define VSP_AppDelegate                 [[UIApplication sharedApplication] delegate]

#define AppPath                         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
