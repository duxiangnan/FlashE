//
//  UIButton+EnlargeTouchArea.h
//  JDMEForIphone
//
//  Created by jd on 2017/12/8.
//  Copyright © 2017年 jd.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (EnlargeTouchArea)
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
