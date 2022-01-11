//
//  defines.h
//  TimLine
//
//  Created by hanson on 14-8-28.
//  Copyright (c) 2014年 com.360buy. All rights reserved.
//
//上线检查 debug_mode、GestureEnable、FE_JDPUSHDEBUG 配置

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif


// 弱引用
#define weakself(obj) autoreleasepool {} __weak typeof(obj) weakSelf = obj;
#define weakObj(obj) __weak typeof(obj) weak_##obj = obj;

#define strongself(obj) autoreleasepool {} __strong typeof(self) strongSelf = obj;

// 单例模式
#define SHARED_INSTANCE_DEF(_classname_) + (instancetype)shared##_classname_;
#define SHARED_INSTANCE_REAL(_classname_) + (instancetype)shared##_classname_\
{\
static id shared##_classname_ = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
shared##_classname_ = [[_classname_ alloc] init];\
});\
return shared##_classname_;\
}

#define kScaleWidth(a) ((a) * kScreenWidth / 375.0)
#define kScaleHeight(a) ((a) * kScreenHeight / 667.0)



// G－C－D
#define BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(), block)

// 根据屏幕缩放比例，将像素转换成点
#define POINTS_FROM_PIXELS(__PIXELS) (__PIXELS / [[UIScreen mainScreen] scale])
#define ONE_PIXEL POINTS_FROM_PIXELS(1.0)




#define UIColorFromRGB(rgbValue) [UIColor\
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0\
    green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0\
    blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#define UIColorFromRGBA(rgbValue, a) [UIColor\
    colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0\
    green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0\
    blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:a]



#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

// 判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
// 判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define Height_Indicator ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 34.0 : 0.0)

// 判断iPhoneX系列，刘海屏无指纹键
#define KIsPhoneSeries\
    ({BOOL isPhoneX = NO;\
      if (@available(iOS 11.0, *)) {\
          isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
      }\
      (isPhoneX);})

// 信息栏
#define kHomeInformationBarHeigt (KIsPhoneSeries ? 44.0 : 20.0)
#define kHomeNavigationHeight (KIsPhoneSeries ? 88.0 : 64.0)
// 获取设备HomeIndicator高度
#define kHomeIndicatorHeight ((KIsPhoneSeries) ? 34.0 : 0.0)

#define k_Height_NavBar_WhenHidden(hidden) (KIsPhoneSeries ? (hidden ? 44.0 : 88.0) : (hidden ? 20.0 : 64.0))

#define MyAppDelegate [[UIApplication sharedApplication] delegate]

#define FE_WINDOW [[[UIApplication sharedApplication] delegate] window]

#define AppPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]



#define waitServerSure @“”


#define kWXAPPID @"wx137a4fe10b102af1"
#define kWXUNIVERSAL_LINK @"https://www.xiaoluex.com/shansong/"
