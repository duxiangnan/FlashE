//
//  FELineLabel.h
//  VipServicePlatform
//
//  Created by JD on 9/7/16.
//  Copyright © 2016 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FELineLabel : UILabel
@property(nonatomic, assign) BOOL       strikeThroughEnabled;   // 是否画线
@property(nonatomic, strong) UIColor    *strikeThroughColor;    // 画线颜色
@end
