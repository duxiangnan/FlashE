//
//  MBProgressHUD+Extend.h
//  BlueCollar
//
//  Created by 高兴 on 16/1/19.
//  Copyright © 2016年 Bigday. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Extend)

/**
 *  加载自定义进度条
 */
+ (void)showProgress;
+ (void)hideProgress;

/*!
 *  显示提示语, 2秒后消失
 */
+ (void)showMessage:(NSString *)string;
+ (void)showMessage:(NSString *)string completionBlock:(MBProgressHUDCompletionBlock)block;
+ (void)showMessage:(NSString *)string hideAfter:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)block;

+ (void)showMessage:(NSString *)string canOperate:(BOOL)operate;
+ (void)showMessage:(NSString *)string canOperate:(BOOL)operate completionBlock:(MBProgressHUDCompletionBlock)block;
+ (void)showMessage:(NSString *)string canOperate:(BOOL)operate hideAfter:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)block;

/**
 *  加载默认进度条
 */
+ (void)showOriginalProgress;

// MBProgressHUD 显示在指定的view中，self.view.window/self.navigationController.view/self.view
// 需要让导航栏上的按钮不可点击的时候，可以选择使用 方式 1 或 方式 2 显示 MBProgressHUD。反之，可以选择 方式 3。
/**************************************************************************************************/

/**
 *  加载自定义进度条
 */
+ (void)showProgressOnView:(UIView *)view;
+ (void)hideProgressOnView:(UIView *)view;

/*!
 *  显示提示语, 2秒后消失
 */
+ (void)showMessage:(NSString *)string onView:(UIView *)view;
+ (void)showMessage:(NSString *)string onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)block;
+ (void)showMessage:(NSString *)string onView:(UIView *)view hideAfter:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)block;

/**
 *  加载默认进度条
 */
+ (void)showOriginalProgressOnView:(UIView *)view;

@end
