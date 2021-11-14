//
//  FEEmptyView.h
//  VipServicePlatform
//
//  Created by JD on 11/7/16.
//  Copyright © 2016 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FEEmptyView : UIView
@property(nonatomic, assign) CGFloat imageW;
@property(nonatomic, assign) CGFloat imageH;

@property (nonatomic, copy) void (^onTapAction)();

- (instancetype)initWithFrame:(CGRect)frame emptyImage:(NSString *)imageName title:(NSString *)title desc:(NSString *)desc;

- (void)emptyHidden;


@end
