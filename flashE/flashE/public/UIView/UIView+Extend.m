//
//  UIView+Extend.m
//  wucai
//
//  Created by muxi on 14/10/26.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import "UIView+Extend.h"

@implementation UIView (Extend)


-(void)setShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(UIViewShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth  radiusLocation:(NSInteger)type {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       UIRectCorner corner ;
       if (type == 1) {
           corner = UIRectCornerTopLeft|UIRectCornerTopRight;
       }else if (type == 2) {
           corner = UIRectCornerAllCorners;
       }else{
           corner = UIRectCornerBottomLeft|UIRectCornerBottomRight;
       }
       if (@available(iOS 11.0,*)) {
           self.layer.cornerRadius = shadowRadius;
           self.layer.maskedCorners = (CACornerMask)corner;
       }else{
           UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(shadowRadius, shadowRadius)];
           CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
           self.frame = self.bounds;
           maskLayer.path = path.CGPath;
           self.layer.mask = maskLayer;
       }
       self.layer.masksToBounds = NO;
       self.clipsToBounds = NO;
       self.layer.shadowColor = shadowColor.CGColor;
       self.layer.shadowOpacity = shadowOpacity;
       //设置抗锯齿边缘
       self.layer.rasterizationScale = [UIScreen mainScreen].scale;
       self.layer.shadowOffset = CGSizeZero;
       CGRect shadowRect;
       CGFloat originX = 0;
       CGFloat originY = 0;
       CGFloat originW = self.bounds.size.width;
       CGFloat originH = self.bounds.size.height;
       switch (shadowPathSide) {
           case UIViewShadowPathTop:
               shadowRect = CGRectMake(originX, originY - shadowPathWidth/2, originW,  shadowPathWidth);
               break;
           case UIViewShadowPathBottom:
               shadowRect = CGRectMake(originX, originH -shadowPathWidth/2, originW, shadowPathWidth);
               break;
           case UIViewShadowPathLeft:
               shadowRect = CGRectMake(originX - shadowPathWidth/2, originY, shadowPathWidth, originH);
               break;
           case UIViewShadowPathRight:
               shadowRect = CGRectMake(originW - shadowPathWidth/2, originY, shadowPathWidth, originH);
               break;
           case UIViewShadowPathNoTop:
               shadowRect = CGRectMake(originX -shadowPathWidth/2, originY +1, originW +shadowPathWidth,originH + shadowPathWidth/2 );
               break;
           case UIViewShadowPathAllSide:
               shadowRect = CGRectMake(originX - shadowPathWidth/2, originY - shadowPathWidth/2, originW +  shadowPathWidth, originH + shadowPathWidth);
               break;
       }
       UIBezierPath *path =[UIBezierPath bezierPathWithRect:shadowRect];
       self.layer.shadowPath = path.CGPath;
   });
}
/**
 *   view的圆角设置
 *
 *   @param view view类控件
 *   @param rectCorner UIRectCorner要切除的圆角
 *   @param cornerSize 切圆角的角度
 *   @param borderColor 边框颜色
 *   @param borderWidth 边框宽度
 *   @param viewColor view类控件颜色
 */
- (void)setupRoundedCornersWithView:(UIView *)view cutCorners:(UIRectCorner)rectCorner cornerRadii:(CGSize )cornerSize borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth viewColor:(UIColor *)viewColor {
   
    UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:cornerSize];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
//    maskLayer.fillColor = viewColor.CGColor;
    view.layer.mask = maskLayer;
    if (borderColor!=nil && borderWidth!=0 && viewColor != nil) {
        UIBezierPath * maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:cornerSize];
        CAShapeLayer *layer = [[CAShapeLayer alloc]init] ;
        layer.path = maskPath.CGPath;
        
        layer.lineWidth = borderWidth;
        
        layer.fillColor  = viewColor.CGColor;
        layer.strokeColor = borderColor.CGColor;;
        layer.frame = view.bounds;
        [view.layer insertSublayer:layer atIndex:1];
//        [view.layer addSublayer:layer];
    }
    [maskPath closePath];
    
}
/**
 *  添加边框：注给scrollView添加会出错
 *
 *  @param direct 方向
 *  @param color  颜色
 *  @param width  线宽
 */
- (void)addSingleBorder:(UIViewBorderDirect)direct color:(UIColor *)color width:(CGFloat)width {
    UIView *line = [[UIView alloc] init];

    // 设置颜色
    line.backgroundColor = color;

    // 添加
    [self addSubview:line];

    // 禁用ar
    line.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary    *views = NSDictionaryOfVariableBindings(line);
    NSDictionary    *metrics = @{@"w":@(width), @"y":@(self.height - width), @"x":@(self.width - width)};

    NSString    *vfl_H = @"";
    NSString    *vfl_W = @"";

    //上
    if (UIViewBorderDirectTop == direct) {
        vfl_H = @"H:|-0-[line]-0-|";
        vfl_W = @"V:|-0-[line(==w)]";
    }

    // 左
    if (UIViewBorderDirectLeft == direct) {
        vfl_H = @"H:|-0-[line(==w)]";
        vfl_W = @"V:|-0-[line]-0-|";
    }

    //下
    if (UIViewBorderDirectBottom == direct) {
        vfl_H = @"H:|-0-[line]-0-|";
        vfl_W = @"V:[line(==w)]-0-|";
    }

    // 右
    if (UIViewBorderDirectRight == direct) {
        vfl_H = @"H:[line(==w)]-0-|";
        vfl_W = @"V:|-0-[line]-0-|";
    }

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_H options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_W options:0 metrics:metrics views:views]];
}

- (CGFloat)maxWidth {
    return self.frame.origin.x + self.bounds.size.width;
}

- (CGFloat)maxHeight
{
    return self.frame.origin.y + self.bounds.size.height;
}

/**
 *  自动从xib创建视图
 */
+ (instancetype)viewFromXIB {
    NSString *name = NSStringFromClass(self);

    UIView *xibView = [[[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil] firstObject];

    if (xibView == nil) {
        
    }

    return xibView;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;

    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;

    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;

    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;

    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;

    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;

    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

#pragma mark  添加一组子view：
- (void)addSubviewsWithArray:(NSArray *)subViews {
    for (UIView *view in subViews) {
        [self addSubview:view];
    }
}

#pragma mark  圆角处理
- (void)setRadius:(CGFloat)r {
    if (r <= 0) {
        r = self.bounds.size.width * .5f;
    }

    // 圆角半径
    self.layer.cornerRadius = r;

    // 强制
    self.layer.masksToBounds = YES;
}

- (CGFloat)radius {
    return 0;
}

/**
 *  添加底部的边线
 */
- (void)setBottomBorderColor:(UIColor *)bottomBorderColor {}

- (UIColor *)bottomBorderColor {
    return nil;
}



/**
 *  批量移除视图
 *
 *  @param views 需要移除的视图数组
 */
+ (void)removeViews:(NSArray *)views {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (UIView *view in views) {
            [view removeFromSuperview];
        }
    });
}

- (UIViewController *)getViewController {
    id target = self;

    while (target) {
        target = ((UIResponder *)target).nextResponder;

        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }

    return target;
}

@end

@implementation UIView (MZLayout)
- (void)reCenterX:(CGFloat)x {
    CGPoint c = self.center;

    c.x = x;
    self.center = c;
}

- (void)reCenterY:(CGFloat)y {
    CGPoint c = self.center;

    c.y = y;
    self.center = c;
}

- (void)resetOriginY:(CGFloat)y {
    CGRect rect = self.frame;

    rect.origin.y = y;
    self.frame = rect;
}

- (void)resetOrigin_x:(CGFloat)x _y:(CGFloat)y {
    CGRect rect = self.frame;

    rect.origin.x = x;
    rect.origin.y = y;
    self.frame = rect;
}

- (void)resetOriginX:(CGFloat)x width:(CGFloat)width {
    CGRect rect = self.frame;

    rect.origin.x = x;
    rect.size.width = width;
    self.frame = rect;
}

- (void)resetOriginY:(CGFloat)y height:(CGFloat)height {
    CGRect rect = self.frame;

    rect.origin.y = y;
    rect.size.height = height;
    self.frame = rect;
}

- (void)resetOriginX:(CGFloat)x {
    CGRect rect = self.frame;

    rect.origin.x = x;
    self.frame = rect;
}

- (void)resetSizeHeight:(CGFloat)height {
    CGRect rect = self.frame;

    rect.size.height = height;
    self.frame = rect;
}

- (void)resetSizeWidth:(CGFloat)width {
    CGRect rect = self.frame;

    rect.size.width = width;
    self.frame = rect;
}

- (void)resetSize:(CGSize)size {
    CGRect rect = self.frame;

    rect.size = size;
    self.frame = rect;
}

- (void)resetOrigin:(CGPoint)origin {
    CGRect rect = self.frame;

    rect.origin = origin;
    self.frame = rect;
}

@end
