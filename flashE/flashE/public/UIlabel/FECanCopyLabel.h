//
//  FECanCopyLabel.h
//  VipServicePlatform
//
//  Created by hx on 2019/5/10.
//  Copyright © 2019 JD. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface FECanCopyLabel : UILabel
@property (nonatomic, copy) void (^canAddCopy) ();
@end

NS_ASSUME_NONNULL_END
