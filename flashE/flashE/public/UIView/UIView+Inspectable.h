//
//  UIView+Inspectable.h
//  VipServicePlatform
//
//  Created by 杜翔楠 on 2019/4/1.
//  Copyright © 2019年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Inspectable)

@property(nonatomic, assign) IBInspectable CGFloat  cornerRadius;
@property(nonatomic, assign) IBInspectable CGFloat  borderWidth;
@property(nonatomic, assign) IBInspectable UIColor  *borderColor;

@end

NS_ASSUME_NONNULL_END
