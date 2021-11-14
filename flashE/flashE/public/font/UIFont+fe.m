//
//  UIFont+fe.m
//  flashE
//
//  Created by duxiangnan on 2021/11/14.
//

#import "UIFont+fe.h"

@implementation UIFont (fe)


+ (UIFont*)regularFont:(CGFloat)size {

    UIFont *font = [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
    return font;
}
+ (UIFont*)mediumFont:(CGFloat)size {

    UIFont *font = [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    return font;
}
+ (UIFont*)semiboldFont:(CGFloat)size {

    UIFont *font = [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
    return font;
}

+ (UIFont*)boldFont:(CGFloat)size {
    UIFont *font = [UIFont boldSystemFontOfSize:size];
    return font;
}

@end
