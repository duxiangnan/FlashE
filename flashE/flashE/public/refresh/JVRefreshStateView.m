//
//  JVRefreshStateView.m
//  oversea_jv
//
//  Created by Ton on 16/1/21.
//  Copyright © 2016年 JD.com. All rights reserved.
//

#import "JVRefreshStateView.h"

@interface JVRefreshStateView ()

@property (strong, nonatomic) NSMutableDictionary *stateTitles;

@property (weak, nonatomic) IBOutlet UILabel    *startLabel;
@property (weak, nonatomic) IBOutlet UILabel    *releaseLabel;

@property (weak, nonatomic) IBOutlet UIView             *noDataView;
@property (weak, nonatomic) IBOutlet UIView             *noDataDashView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cstrNoDataDashHeight;
@property (weak, nonatomic) IBOutlet UILabel            *noDataLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cstrNoDataLabelWidth;

@property (weak, nonatomic) IBOutlet UIView                     *loadingView;
@property (weak, nonatomic) IBOutlet UILabel                    *loadingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView    *indicatorView;

@end

@implementation JVRefreshStateView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self setupWithFrame:self.bounds];
    }

    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setupWithFrame:frame];
    }

    return self;
}

- (void)setupWithFrame:(CGRect)frame
{
    UIView *containerView = [[[UINib nibWithNibName:@"JVRefreshStateView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];

    containerView.frame = frame;
    [self addSubview:containerView];
    [self.noDataDashView setBackgroundColor:[UIColor lightGrayColor]];
    self.cstrNoDataDashHeight.constant = 0.5;

    [self setTitle:@"上拉加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"放开加载更多" forState:MJRefreshStatePulling];
    [self setTitle:@"正在加载中" forState:MJRefreshStateRefreshing];
    [self setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];

    [self setState:MJRefreshStateIdle];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self.noDataLabel setBackgroundColor:backgroundColor];
}

#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles
{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }

    return _stateTitles;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state
{
    if (title == nil) {
        return;
    }

    self.stateTitles[@(state)] = title;

    switch (state) {
        case MJRefreshStateIdle:
            self.startLabel.text = title;
            break;

        case MJRefreshStatePulling:
            self.releaseLabel.text = title;
            break;

        case MJRefreshStateRefreshing:
            {
                self.loadingLabel.text = title;
            } break;

        case MJRefreshStateWillRefresh:

            break;

        case MJRefreshStateNoMoreData:
            {
                self.noDataLabel.text = title;
                CGFloat w = [self caWidthWithLabel:self.noDataLabel];

                if (w < 35) {
                    w = 35;
                }

                w = w + 20;
                self.cstrNoDataLabelWidth.constant = w;
            } break;

        default:
            break;
    }
}

- (CGFloat)caWidthWithLabel:(UILabel *)label
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];

    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;

    NSDictionary *attributes = @{NSFontAttributeName : label.font,
                                 NSParagraphStyleAttributeName : paragraphStyle};

    NSString *text = label.text;

    CGSize contentSize = [text boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, label.frame.size.height)
        options     :(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
        attributes  :attributes
        context     :nil].size;
    return contentSize.width;
}

- (void)setState:(MJRefreshState)state
{
    switch (state) {
        case MJRefreshStateIdle:
            {
                self.startLabel.hidden = NO;
                self.releaseLabel.hidden = YES;
                self.noDataView.hidden = YES;
                self.loadingView.hidden = YES;
                [self.indicatorView stopAnimating];
            } break;

        case MJRefreshStatePulling:
            {
                self.startLabel.hidden = YES;
                self.releaseLabel.hidden = NO;
                self.noDataView.hidden = YES;
                self.loadingView.hidden = YES;
                [self.indicatorView stopAnimating];
            } break;

        case MJRefreshStateWillRefresh:
            {} break;

        case MJRefreshStateRefreshing:
            {
                self.startLabel.hidden = YES;
                self.releaseLabel.hidden = YES;
                self.noDataView.hidden = YES;
                self.loadingView.hidden = NO;
                [self.indicatorView startAnimating];
            } break;

        case MJRefreshStateNoMoreData:
            {
                self.startLabel.hidden = YES;
                self.releaseLabel.hidden = YES;
                self.noDataView.hidden = NO;
                self.loadingView.hidden = YES;
                [self.indicatorView stopAnimating];
            } break;

        default:
            break;
    }
}

@end
