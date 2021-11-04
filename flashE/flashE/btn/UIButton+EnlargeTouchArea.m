//
//  UIButton+EnlargeTouchArea.m
//  JDMEForIphone
//
//  Created by jd on 2017/12/8.
//  Copyright © 2017年 jd.com. All rights reserved.
//

#import "UIButton+EnlargeTouchArea.h"

@implementation UIButton (EnlargeTouchArea)
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    NSNumber    *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber    *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber    *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber    *leftEdge = objc_getAssociatedObject(self, &leftNameKey);

    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                   self.bounds.origin.y - topEdge.floatValue,
                   self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                   self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        return self.bounds;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self enlargedRect];

    if (CGRectEqualToRect(rect, self.bounds)) {
        return [super pointInside:point withEvent:event];
    }

    return CGRectContainsPoint(rect, point) ? YES : NO;
}

@end
