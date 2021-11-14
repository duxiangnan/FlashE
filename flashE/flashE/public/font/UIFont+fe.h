//
//  UIFont+fe.h
//  flashE
//
//  Created by duxiangnan on 2021/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (fe)
+ (UIFont*)regularFont:(CGFloat)size;
+ (UIFont*)mediumFont:(CGFloat)size;
+ (UIFont*)semiboldFont:(CGFloat)size;
+ (UIFont*)boldFont:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
