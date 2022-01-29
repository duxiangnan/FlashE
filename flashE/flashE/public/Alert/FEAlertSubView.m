//
//  FEAlertSubView.m
//
//  Created by Nealon Young on 7/13/15.
//  Copyright (c) 2015 Nealon Young. All rights reserved.
//
//  Changed by rainer_liao

#import "FEAlertSubView.h"
#import <Masonry/Masonry.h>
#import "FEDefineModule.h"
#import "NSString-umbrella.h"


@interface FEAlertSubTextView : UITextView

@end

@implementation FEAlertSubTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    
    self.textContainerInset = UIEdgeInsetsZero;
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGSizeEqualToSize(self.bounds.size, [self intrinsicContentSize])) {
        [self invalidateIntrinsicContentSize];
    }
}

- (CGSize)intrinsicContentSize {
    if ([self.text length]) {
        return self.contentSize;
    } else {
        return CGSizeZero;
    }
}

@end


@implementation FEAlertSubViewButton

+ (id)buttonWithType:(UIButtonType)buttonType {
    
    return [super buttonWithType:UIButtonTypeCustom];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit {
    self.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.layer.shouldRasterize = YES;
    
    self.layer.borderWidth = 1.0f;
    
    self.cornerRadius = 4.0f;
    self.clipsToBounds = YES;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    
    [self tintColorDidChange];
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    [self invalidateIntrinsicContentSize];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
}

- (void)tintColorDidChange {
    [super tintColorDidChange];
    
    if (self.type == FEAlertViewButtonTypeFilled) {
        if (self.enabled) {
            [self setBackgroundColor:self.tintColor];
        }
    } else {
        [self setTitleColor:self.tintColor forState:UIControlStateNormal];
    }
    
    self.layer.borderColor = self.tintColor.CGColor;
    
    [self setNeedsDisplay];
}

- (CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

- (CGSize)intrinsicContentSize {
    if (self.hidden) {
        return CGSizeZero;
    }
    
    return CGSizeMake([super intrinsicContentSize].width + 12.0f, 30.0f);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.layer.borderColor = self.tintColor.CGColor;
    
    if (self.type == FEAlertViewButtonTypeBordered && self.enabled)
    {
        self.layer.borderWidth = 1.0f;
    } else {
        self.layer.borderWidth = 0.0f;
    }
    
    if (self.state == UIControlStateHighlighted)
    {
        
        self.layer.backgroundColor = self.tintColor.CGColor;
    } else {
        if (self.type == FEAlertViewButtonTypeBordered)
        {
            self.layer.backgroundColor = nil;
            [self.layer setMasksToBounds:YES];
            [self.layer setBorderColor:self.tintColor.CGColor];
        }
        else
        {
//            [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

@end

@interface FEAlertSubView ()

@property (nonatomic, strong) UIView *alertBackgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *contentViewContainerView;
@property (nonatomic, strong) UIView *actionButtonContainerView;

@property (nonatomic, assign) CGFloat maximumWidth;
@property (nonatomic, assign) CGFloat maximumHeight;

@property (nonatomic, assign) NSInteger titleTopMargin;
@property (nonatomic, assign) NSInteger messageTopMargin;
@property (nonatomic, assign) NSInteger buttonBottomMargin;
@property (nonatomic, assign) NSInteger contentViewTopMargin;
@property (nonatomic, assign) NSInteger actionTopMargin;


@property (nonatomic, assign) NSInteger titleLeadingAndTrailingPadding;
@property (nonatomic, assign) NSInteger messageLeadingAndTrailingPadding;


@property (nonatomic, assign) CGFloat bgViewH;
@property (nonatomic, assign) CGFloat bgViewW;
@property (nonatomic, assign) CGFloat titleH;
@property (nonatomic, assign) CGFloat messageHeight;
@property (nonatomic, assign) CGFloat contentViewH;
@property (nonatomic, assign) CGFloat actionButtonH;

@end

@implementation FEAlertSubView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
        CGRect backBound = FE_WINDOW.bounds;
        _maximumWidth = MIN(CGRectGetWidth(backBound),CGRectGetHeight(backBound)) * 0.8f;
        _maximumHeight = MAX(CGRectGetHeight(backBound),CGRectGetWidth(backBound)) * 0.8f;
        _bgViewH = _maximumHeight;
        _bgViewW = _maximumWidth;
        _titleTopMargin = 10;
        _messageTopMargin = 10;
        _contentViewTopMargin = 10;
        _actionTopMargin = 10;
        _buttonBottomMargin = 10;
        
        _titleLeadingAndTrailingPadding = 10;
        _messageLeadingAndTrailingPadding = 10;
        
        self.titleFont = [UIFont boldSystemFontOfSize:18];
        self.messageFont = [UIFont systemFontOfSize:15];
        
        self.titleColor = UIColorFromRGB(0x333333);
        self.messageColor = UIColorFromRGB(0x333333);
    }
    
    return self;
}
- (UIView*) alertBackgroundView {
    if (!_alertBackgroundView) {
        _alertBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [_alertBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _alertBackgroundView.backgroundColor = [UIColor colorWithWhite:0.97f alpha:1.0f];
        _alertBackgroundView.layer.cornerRadius = 10;
        [self addSubview:_alertBackgroundView];
    }
    return _alertBackgroundView;
}

- (UILabel*) titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = UIColorFromRGB(0x333333);
        _titleLabel.text = nil;
        [self.alertBackgroundView addSubview:_titleLabel];
    }
    return _titleLabel;
    
}

- (FEAlertSubTextView*) messageTextView {
    if (!_messageTextView) {
        _messageTextView = [[FEAlertSubTextView alloc] initWithFrame:CGRectZero];
        [_messageTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
        _messageTextView.backgroundColor = [UIColor clearColor];
        [_messageTextView setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisVertical];
        [_messageTextView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
        _messageTextView.editable = NO;
        _messageTextView.textAlignment = NSTextAlignmentCenter;
        _messageTextView.textColor = UIColorFromRGB(0x333333);
        _messageTextView.font = [UIFont systemFontOfSize:15];
        _messageTextView.text = nil;
        [self.alertBackgroundView addSubview:_messageTextView];
    }
    return _messageTextView;
}

- (UIView*) contentViewContainerView {
    if (!_contentViewContainerView) {
        _contentViewContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentViewContainerView.backgroundColor = UIColor.clearColor;
        [self.alertBackgroundView addSubview:_contentViewContainerView];
    }
    return _contentViewContainerView;
}


- (UIView*) actionButtonContainerView {
    if (!_actionButtonContainerView) {
        _actionButtonContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [_actionButtonContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_actionButtonContainerView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        _actionButtonContainerView.backgroundColor = UIColor.clearColor;
        [self.alertBackgroundView addSubview:_actionButtonContainerView];
    }
    return _actionButtonContainerView;
}





- (void)layoutSubviews {
    [super layoutSubviews];

     
    [self.alertBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(self.bgViewW);
        make.height.mas_equalTo(@(_bgViewH));
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@(_titleTopMargin));
        make.left.equalTo(self.alertBackgroundView.mas_left).offset(self.titleLeadingAndTrailingPadding);
        make.right.equalTo(self.alertBackgroundView.mas_right).offset(-self.titleLeadingAndTrailingPadding);
        make.height.mas_equalTo(@(self.titleH));
    }];

    [self.messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(self.messageTopMargin);
        make.left.equalTo(self.alertBackgroundView.mas_left).offset(self.messageLeadingAndTrailingPadding);
        make.right.equalTo(self.alertBackgroundView.mas_right).offset(-self.messageLeadingAndTrailingPadding);
        make.height.mas_equalTo(@(self.messageHeight));
    }];
    [self.contentViewContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageTextView.mas_bottom).offset(self.contentViewTopMargin);
        make.left.equalTo(self.alertBackgroundView.mas_left);
        make.right.equalTo(self.alertBackgroundView.mas_right);
        make.height.mas_equalTo(@(self.contentViewH));
    }];
    [self.actionButtonContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentViewContainerView.mas_bottom).offset(self.actionTopMargin);
        make.left.equalTo(self.alertBackgroundView.mas_left).offset(20);
        make.right.equalTo(self.alertBackgroundView.mas_right).offset(-20);
        make.height.mas_equalTo(@(self.actionButtonH));
    }];
}

- (void) reCalculationLayout {
    
    CGRect backBound = FE_WINDOW.bounds;
    CGFloat alWidth = MIN(CGRectGetWidth(backBound),CGRectGetHeight(backBound)) * 0.8f;
    alWidth = MIN(alWidth, self.maximumWidth);
    self.bgViewW = alWidth;
    
    CGFloat h = 10;
    if (self.title.length > 0) {
        self.titleTopMargin = 10;
        
        CGFloat width = alWidth - self.titleLeadingAndTrailingPadding*2;
        CGSize size = [@"a" sizeWithFont:self.titleLabel.font andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
        self.titleH = ceil(size.height);
        
        h += self.titleTopMargin;
        h += self.titleH;
        
    } else {
        self.titleTopMargin = 0;
        self.titleH = 0;
    }
    
    if (self.contentViewH > 0) {
        h += self.contentViewTopMargin;
        h += self.contentViewH;
    } else {
        self.contentViewTopMargin = 0;
    }
    
    if (self.actionButtonH > 0) {
        h += self.actionTopMargin;
        h += self.actionButtonH;
    } else {
        self.actionTopMargin = 0;
    }
    h += self.buttonBottomMargin;
    
    if (self.message.length > 0) {
        self.messageTopMargin = 10;
        CGFloat width = alWidth - self.messageLeadingAndTrailingPadding*2;
        CGSize size = [self.message sizeWithFont:self.messageFont andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
        CGFloat tmpH = self.maximumHeight - self.messageTopMargin - h;
        
        self.messageHeight = MIN(tmpH, ceil(size.height));
        
        h += self.messageTopMargin;
        h += self.messageHeight;
    } else {
        self.messageTopMargin = 0;
        self.messageHeight = 0;
    }
    

    self.bgViewH = h;
}

- (void) setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
- (void) setMessage:(NSString *)message {
    _message = message;
    self.messageTextView.text = message;
}

- (void) setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.titleLabel.textColor = titleColor;
}
- (void) setMessageColor:(UIColor *)messageColor {
    _messageColor = messageColor;
    self.messageTextView.textColor = messageColor;
}

- (void) setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    self.titleLabel.font = titleFont;
}
- (void) setMessageFont:(UIFont *)messageFont {
    _messageFont = messageFont;
    self.messageTextView.font = messageFont;
}
- (CGFloat) getMaxContentViewMaxWidth {
    return CGRectGetMaxX(self.frame);
}
// Pass through touches outside the backgroundView for the presentation controller to handle dismissal
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *subview in self.subviews) {
        if ([subview hitTest:[self convertPoint:point toView:subview] withEvent:event]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)setContentView:(UIView *)contentView width:(NSInteger)width height:(NSInteger)height {
    [self.contentView removeFromSuperview];
    _contentView = contentView;
    self.contentViewH = 0;
    if (contentView) {
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentViewContainerView addSubview:self.contentView];
        
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
            make.top.centerX.equalTo(self.contentViewContainerView);
//            make.center.equalTo(self.contentViewContainerView);
        }];
        self.contentViewH = height;
    }
}

- (void)setActionButtons:(NSArray *)actionButtons
{
    [self.actionButtons makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    _actionButtons = actionButtons;
    if ([actionButtons count] == 2) {
        CGFloat width = self.bgViewW - 20*2-10;
        CGFloat leftW = width/2*self.firstAndSecondRatio;
        CGFloat rightW = width = leftW;
        UIButton *firstButton = actionButtons[0];
        UIButton *lastButton = actionButtons[1];
        [self.actionButtonContainerView addSubview:firstButton];
        [self.actionButtonContainerView addSubview:lastButton];
        
        [firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.actionButtonContainerView.mas_left);
            make.right.equalTo(lastButton.mas_left).offset(-10);
            make.top.equalTo(self.actionButtonContainerView.mas_top).offset(20);
            make.height.mas_equalTo(@(40));
            make.width.mas_equalTo(@(leftW));
        }];
        [lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstButton.mas_right).offset(10);
            make.right.equalTo(self.actionButtonContainerView.mas_right);
            make.top.equalTo(self.actionButtonContainerView.mas_top).offset(20);
            make.height.mas_equalTo(@(40));
            make.width.mas_equalTo(@(rightW));
        }];
        firstButton.layer.cornerRadius = 20;
        lastButton.layer.cornerRadius = 20;
        self.actionButtonH = 40+20;
    } else if ([actionButtons count] == 1) {
        UIButton *theButton = actionButtons[0];
        [self.actionButtonContainerView addSubview:theButton];
        [theButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.actionButtonContainerView.mas_left).offset(20);
            make.right.equalTo(self.actionButtonContainerView.mas_right).offset(-20);
            make.top.equalTo(self.actionButtonContainerView.mas_top).offset(20);
            make.height.mas_equalTo(@(40));
        }];
        theButton.layer.cornerRadius = 20;
        self.actionButtonH = 40+20;
    } else {
        CGFloat offy = 0;
        for (int i = 0; i < [actionButtons count]; i++) {
            UIButton *actionButton = actionButtons[i];
            
            [self.actionButtonContainerView addSubview:actionButton];
            [actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.actionButtonContainerView.mas_left).offset(20);
                make.right.equalTo(self.actionButtonContainerView.mas_right).offset(-20);
                make.top.equalTo(self.actionButtonContainerView.mas_top).offset(offy);
                make.height.mas_equalTo(@(40));
            }];
            actionButton.layer.cornerRadius = 20;
            offy += (40+10);
        }
        if (actionButtons.count > 1) {
            offy -= 10;
        }
        self.actionButtonH = offy;
    }
    
}

@end
