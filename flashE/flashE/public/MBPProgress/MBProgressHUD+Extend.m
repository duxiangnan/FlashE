//
//  MBProgressHUD+Extend.m
//  BlueCollar
//
//  Created by 高兴 on 16/1/19.
//  Copyright © 2016年 Bigday. All rights reserved.
//

#import "MBProgressHUD+Extend.h"
#import "WHToast.h"

#import "FEDefineModule.h"


@implementation MBProgressHUD (Extend)

+ (void)showProgress {
    [self showProgressWithView:nil];
}
+ (void)showProgressWithView:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view?:FE_WINDOW animated:YES];
          UIImageView *animatedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
          animatedImageView.animationImages = [NSArray arrayWithObjects:
          // VSP_loading-ios-
          [UIImage imageNamed:@"VSP_loading-ios-1"],
          [UIImage imageNamed:@"VSP_loading-ios-2"],
          [UIImage imageNamed:@"VSP_loading-ios-3"],
          [UIImage imageNamed:@"VSP_loading-ios-4"],
          [UIImage imageNamed:@"VSP_loading-ios-5"],
          [UIImage imageNamed:@"VSP_loading-ios-6"],
          [UIImage imageNamed:@"VSP_loading-ios-7"],
          [UIImage imageNamed:@"VSP_loading-ios-8"], nil];
          animatedImageView.animationDuration = 1.0f;
          animatedImageView.animationRepeatCount = 0;
          [animatedImageView startAnimating];

          // custom No text
          hud.customView = animatedImageView;
          hud.defaultMotionEffectsEnabled = NO;
          hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
          hud.contentColor = [UIColor clearColor];
          hud.backgroundColor = [UIColor clearColor];
          hud.backgroundView.backgroundColor = [UIColor clearColor];
          hud.backgroundView.color = [UIColor clearColor];
          hud.bezelView.backgroundColor = [UIColor clearColor];
          hud.bezelView.color = [UIColor clearColor];
          hud.label.textColor = [UIColor clearColor];
          hud.detailsLabel.textColor = [UIColor clearColor];
          hud.mode = MBProgressHUDModeCustomView;
          [hud showAnimated:YES];
      });
    
}

+ (void)showOriginalProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHUDAddedTo:FE_WINDOW animated:NO];
    });
}

+ (void)hideProgress {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUDForView:FE_WINDOW animated:NO];
    });
}

+ (void)showMessage:(NSString *)string {
    [self showMessage:string canOperate:YES];
}

+ (void)showMessage:(NSString *)string completionBlock:(MBProgressHUDCompletionBlock)block {
    [self showMessage:string canOperate:YES completionBlock:block];
}

+ (void)showMessage:(NSString *)string hideAfter:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMessage:string canOperate:YES hideAfter:delay completionBlock:block];
    });
}
+ (void)showMessage:(NSString *)string canOperate:(BOOL)operate{
    [self showMessage:string canOperate:operate completionBlock:nil];
}
+ (void)showMessage:(NSString *)string canOperate:(BOOL)operate completionBlock:(MBProgressHUDCompletionBlock)block{
    [self showMessage:string canOperate:operate hideAfter:2.0 completionBlock:block];
}
+ (void)showMessage:(NSString *)string canOperate:(BOOL)operate hideAfter:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)block{
    [self showMessage:string canOperate:operate onView:nil hideAfter:delay completionBlock:block];
    
}
+ (void)showMessage:(NSString *)string canOperate:(BOOL)operate onView:(UIView *)view hideAfter:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)block{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (!operate) {
            [WHToast setShowMask:YES];
            [WHToast setMaskColor:[UIColor clearColor]];
            [WHToast setMaskCoverNav:YES];
        }
       [WHToast setPadding:20];
       [WHToast setCornerRadius:10];
       [WHToast setBackColor:[self whToast_colorFromHexString:@"#E8E8E8" alpha:1]];
       [WHToast setTextColor:[self whToast_colorFromHexString:@"#666666" alpha:1]];
       [WHToast setFontSize:14.];
       [WHToast showMessage:string duration:delay finishHandler:^{
           if (block) {
               block();
           }
           [WHToast resetConfig];
       }];
    });
    
}


/**************************************************************************************************/

/**
 *  加载自定义进度条
 */
+ (void)showProgressOnView:(UIView *)view {
    [self showProgressWithView:view];
}

+ (void)hideProgressOnView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self hideHUDForView:view animated:NO];
    });
}

+ (void)showMessage:(NSString *)string onView:(UIView *)view {
    [self showMessage:string onView:view hideAfter:2. completionBlock:nil];
}

+ (void)showMessage:(NSString *)string onView:(UIView *)view completionBlock:(MBProgressHUDCompletionBlock)block {
    [self showMessage:string onView:view hideAfter:2. completionBlock:block];
}

+ (void)showMessage:(NSString *)string onView:(UIView *)view hideAfter:(NSTimeInterval)delay completionBlock:(MBProgressHUDCompletionBlock)block {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMessage:string canOperate:YES onView:view hideAfter:delay completionBlock:block];
    });
}

+ (void)showOriginalProgressOnView:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showHUDAddedTo:view animated:NO];
    });
}

+ (UIColor *)whToast_colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

@end
