//
//  UIButton+Frequentclicks.h
//  LiqForDoctors
//
//  Created by StriEver on 16/3/10.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval .5  //默认时间间隔
@interface UIButton (Frequentclicks)
/**设置点击时间间隔*/
@property (nonatomic, assign) NSTimeInterval he_timeInterval;
/**
 *  用于设置单个按钮不需要被hook
 */
@property (nonatomic, assign) BOOL isIgnore;
@end
