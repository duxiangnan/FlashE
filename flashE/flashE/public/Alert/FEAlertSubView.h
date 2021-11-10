//
//  FEAlertSubView.h
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//
//  Changed by rainer_liao 

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FEAlertViewButtonType) {
    FEAlertViewButtonTypeFilled,
    FEAlertViewButtonTypeBordered
};

@interface FEAlertSubViewButton : UIButton

@property (nonatomic) FEAlertViewButtonType type;

@property (nonatomic) CGFloat cornerRadius;

@end

@interface FEAlertSubView : UIView
@property (nonatomic, copy) NSString * title;
@property (nonatomic) NSString *message;
@property (nonatomic, copy) NSArray *actionButtons;

@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIFont *messageFont;

@property (nonatomic) UIColor *titleColor;
@property (nonatomic) UIColor *messageColor;


- (void)setContentView:(UIView *)contentView width:(NSInteger)width height:(NSInteger)height;

- (void) reCalculationLayout;//重新计算布局

- (CGFloat) getMaxContentViewMaxWidth;

@end
