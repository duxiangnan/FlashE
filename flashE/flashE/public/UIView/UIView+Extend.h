//
//  UIView+Extend.h
//  wucai
//
//  Created by muxi on 14/10/26.
//  Copyright (c) 2014年 muxi. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CustomViewTranslate(ViewClass, view) (ViewClass *)view;

typedef enum {
    UIViewBorderDirectTop = 0,//上
    UIViewBorderDirectLeft,// 左
    UIViewBorderDirectBottom,//下
    UIViewBorderDirectRight,// 右
} UIViewBorderDirect;

typedef enum :NSInteger{
    UIViewShadowPathLeft,
    UIViewShadowPathRight,
    UIViewShadowPathTop,
    UIViewShadowPathBottom,
    UIViewShadowPathNoTop,
    UIViewShadowPathAllSide
} UIViewShadowPathSide;

@interface UIView (Extend)

@property (nonatomic, assign) CGFloat           x;
@property (nonatomic, assign) CGFloat           y;
@property (nonatomic, assign) CGFloat           width;
@property (nonatomic, assign) CGFloat           height;
@property (nonatomic, assign) CGSize            size;
@property (nonatomic, assign) CGPoint           origin;
@property (nonatomic, assign) CGFloat           radius;
@property (nonatomic, assign, readonly) CGFloat maxWidth;
@property (nonatomic, assign, readonly) CGFloat maxHeight;



/*
 * shadowColor 阴影颜色
 *
 * shadowOpacity 阴影透明度，默认0
 *
 * shadowRadius  阴影半径，默认3
 *
 * shadowPathSide 设置哪一侧的阴影，
 *
 * shadowPathWidth 阴影的宽度，
 *
 * type 1-左上右上 2-全方位 3-左下右下
 */
-(void)setShadowPathWith:(UIColor *)shadowColor shadowOpacity:(CGFloat)shadowOpacity shadowRadius:(CGFloat)shadowRadius shadowSide:(UIViewShadowPathSide)shadowPathSide shadowPathWidth:(CGFloat)shadowPathWidth  radiusLocation:(NSInteger)type;

/**
 *   view的圆角设置
 *
 *   @param view view类控件
 *   @param rectCorner UIRectCorner要切除的圆角
 *   @param borderColor 边框颜色
 *   @param borderWidth 边框宽度
 *   @param viewColor view类控件颜色
 */
- (void)setupRoundedCornersWithView:(UIView *)view cutCorners:(UIRectCorner)rectCorner cornerRadii:(CGSize)cornerSize borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth viewColor:(UIColor *)viewColor;

/**
 *  添加边框：注给scrollView添加会出错
 *
 *  @param direct 方向
 *  @param color  颜色
 *  @param width  线宽
 */
- (void)addSingleBorder:(UIViewBorderDirect)direct color:(UIColor *)color width:(CGFloat)width;

/**
 *  自动从xib创建视图
 */
+ (instancetype)viewFromXIB;

/**
 *  添加一组子view：
 */
- (void)addSubviewsWithArray:(NSArray *)subViews;


/**
 *  批量移除视图
 *
 *  @param views 需要移除的视图数组
 */
+ (void)removeViews:(NSArray *)views;

- (UIViewController *)getViewController;
@end

@interface UIView (MZLayout)
- (void)reCenterX:(CGFloat)x;
- (void)reCenterY:(CGFloat)y;
- (void)resetOrigin_x:(CGFloat)x _y:(CGFloat)y;
- (void)resetOriginX:(CGFloat)x width:(CGFloat)width;
- (void)resetOriginY:(CGFloat)y height:(CGFloat)height;

- (void)resetOriginY:(CGFloat)y;
- (void)resetOriginX:(CGFloat)x;
- (void)resetSizeHeight:(CGFloat)height;
- (void)resetSizeWidth:(CGFloat)width;
- (void)resetSize:(CGSize)size;
- (void)resetOrigin:(CGPoint)origin;
@end
