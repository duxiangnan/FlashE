//
//  FEVerticalAlignmentLabel.h
//  VipServicePlatform
//
//  Created by 杜翔楠 on 2019/5/23.
//  Copyright © 2019年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} FEVerticalAlignment;

@interface FEVerticalAlignmentLabel : UILabel

@property (nonatomic, assign) FEVerticalAlignment verticalAlignment;

@end

NS_ASSUME_NONNULL_END
