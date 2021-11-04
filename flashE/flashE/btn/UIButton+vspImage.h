//
//  UIButton+vspImage.h
//  Pods-VSPUIButtonModule_Example
//
//  Created by duxiangnan on 2020/9/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, ZJButtonImageStyle){
    ZJButtonImageStyleTop = 0,  //图片在上，文字在下
    ZJButtonImageStyleLeft,     //图片在左，文字在右
    ZJButtonImageStyleBottom,   //图片在下，文字在上
    ZJButtonImageStyleRight     //图片在右，文字在左
};


@interface UIButton(vspImage)


/**
 设置button的imageView和titleLabel的布局样式及它们的间距
 @param style imageView和titleLabel的布局样式
 @param space imageView和titleLabel的间距
 */
- (void)layoutButtonWithImageStyle:(ZJButtonImageStyle)style
                   imageTitleToSpace:(CGFloat)space;

@end

NS_ASSUME_NONNULL_END
