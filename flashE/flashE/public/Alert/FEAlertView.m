//
//  FEAlertView.m
//  FEAlertView
//
//  Created by rainer_liao on 15/11/5.
//  Copyright © 2015年 rainer_liao. All rights reserved.
//

#import "FEAlertView.h"
#import "FEAlertSubView.h"
#import "UIButtonModule-umbrella.h"
#import "FEDefineModule.h"



@interface FEAlertAction ()

@property (nonatomic, weak) UIButton *actionButton;

@end

@implementation FEAlertAction



+ (instancetype)actionWithTitle:(NSString *)title style:(FEAlertActionStyle)style handler:(void (^)(FEAlertAction *action))handler
{
    FEAlertAction *action = [[FEAlertAction alloc] init];
    action.title = title;
    action.style = style;
    action.handler = handler;
    
    return action;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _enabled = YES;
    }
    
    return self;
}

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    self.actionButton.enabled = enabled;
}

@end

@interface FEAlertView ()

@property (nonatomic, strong) FEAlertSubView *alertView;

@end

@implementation FEAlertView
- (void)show
{
    [self createActionButtons];
    [self.alertView reCalculationLayout];
    
    [[[[UIApplication sharedApplication] windows] firstObject] addSubview:self];
    
    self.alertView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.alertView.alpha = 0.0f;
    
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
                         self.alertView.transform = CGAffineTransformMakeScale(1, 1);
                         self.alertView.alpha = 1.0f;
                         
                     }
                     completion:nil
     ];
}

- (void)close
{
    [UIView animateWithDuration:0.2f delay:0.0 options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
                         self.alertView.alpha = 0.0f;
                         self.alpha = 0.0f;
                     }
                     completion:^(BOOL finished) {
                        
                         for (UIView *v in [self subviews]) {
                             [v removeFromSuperview];
                         }
                         [self removeFromSuperview];
                     }
     ];
}

- (id)init
{
    return [self initWithTitle:nil message:nil];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message;
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
        _actions = [NSArray array];
        self.firstAndSecondRatio = 1.0;
        
        self.alertView = [[FEAlertSubView alloc]
                          initWithFrame:CGRectMake(0, 0,
                                                   [UIScreen mainScreen].bounds.size.width,
                                                   [UIScreen mainScreen].bounds.size.height)];
        [self setTitle:title];
        [self setMessage:message];
        [self addSubview:self.alertView];
    }
    return self;
}


- (void)createActionButtons
{
    NSMutableArray *buttons = [NSMutableArray array];
    for (int i = 0; i < [self.actions count]; i++) {
        FEAlertAction *action = self.actions[i];
        
        FEAlertSubViewButton *button = [FEAlertSubViewButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        button.enabled = action.enabled;
        button.cornerRadius = 10;
        button.type = FEAlertViewButtonTypeBordered;
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button setTitle:action.title forState:UIControlStateNormal];
        
        if (action.style == FEAlertActionStyleCancel) {
            
            button.tintColor = UIColorFromRGB(0xDEDEDE);
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.backgroundColor = UIColor.whiteColor;
        }
        else {
            button.type = FEAlertViewButtonTypeFilled;
            button.tintColor = UIColorFromRGB(0x283C50);
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
            button.backgroundColor = UIColorFromRGB(0x283C50);
        }
        [buttons addObject:button];
        
        action.actionButton = button;
    }
    
    self.alertView.actionButtons = buttons;
}

- (void)actionButtonPressed:(UIButton *)button
{
    [self close];
    FEAlertAction *action = self.actions[button.tag];
    if (action.handler) {
        action.handler(action);
    }
}


- (void)setContentView:(UIView *)contentView width:(NSInteger)width height:(NSInteger)height
{
    [self.alertView setContentView:contentView width:width height:height];
}
- (CGFloat) getMaxContentViewMaxWidth {
    return [self.alertView getMaxContentViewMaxWidth];
}
#pragma mark - Getters/Setters
- (void)setTitle:(NSString *)title
{
    _title = title;
    self.alertView.title = title;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    self.alertView.message = message;
}

- (void)addAction:(FEAlertAction *)action {
    _actions = [self.actions arrayByAddingObject:action];
}

- (void)setFirstAndSecondRatio:(float)firstAndSecondRatio {
    _firstAndSecondRatio = firstAndSecondRatio;
    self.alertView.firstAndSecondRatio = firstAndSecondRatio;
}


@end
