//
//  UIButton+BackgroundColor.m
//  VipServicePlatform
//
//  Created by JD on 11/3/16.
//  Copyright © 2016 JD. All rights reserved.
//

#import "UIButton+BackgroundColor.h"

#import <objc/runtime.h>
@implementation UIButton (BackgroundColor)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(setHighlighted:);
        SEL selB = @selector(swizzlingSetHighlighted:);
        Method methodA = class_getInstanceMethod(self,selA);
        Method methodB = class_getInstanceMethod(self, selB);
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        }else{
            method_exchangeImplementations(methodA, methodB);
        }
    });
}
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    [self setBackgroundImage:[[self imageWithColor:color] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:state];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);

    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (void)swizzlingSetHighlighted:(BOOL)highlighted {
    if (self.isSelected) {
        [self swizzlingSetHighlighted:NO];
    }else {
        [self swizzlingSetHighlighted:highlighted];
    }
}

@end
