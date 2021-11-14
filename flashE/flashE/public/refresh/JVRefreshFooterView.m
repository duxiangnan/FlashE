//
//  JVRefreshFooterView.m
//  oversea_jv
//
//  Created by Ton on 15/7/30.
//  Copyright (c) 2015年 JD.com. All rights reserved.
//

#import "JVRefreshFooterView.h"
#import "JVRefreshStateView.h"
@interface JVRefreshFooterView ()

@property (nonatomic, strong) JVRefreshStateView    *stateView;
@property (nonatomic, strong) NSString              *noMoreDataStateTitle;
@end

@implementation JVRefreshFooterView

#pragma mark - Note Method

+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock
{
    //    return [super footerWithRefreshingBlock:refreshingBlock];
    return [self footerWithRefreshingBlock:refreshingBlock noMoreDataString:@"没有更多数据"];
}

+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock noMoreDataString:(NSString *)noString {
    JVRefreshFooterView *footer = [super footerWithRefreshingBlock:refreshingBlock];

    footer.noMoreDataStateTitle = noString;
    [footer setupStateView];
    return footer;
}

+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action
{
    return [super footerWithRefreshingTarget:target refreshingAction:action];
}

- (void)noticeNoMoreData
{
    [super endRefreshingWithNoMoreData];
}

- (void)resetNoMoreData
{
    [super resetNoMoreData];
}

- (void)beginRefreshing
{
    [super beginRefreshing];
}

- (void)endRefreshing
{
    [super endRefreshing];
}

- (void)endRefreshingWithNoMoreData {
    dispatch_async(dispatch_get_main_queue(), ^{
        [super endRefreshingWithNoMoreData];
    });
}

- (BOOL)isRefreshing
{
    return [super isRefreshing];
}

- (void)setupStateView {
    _stateView = [[JVRefreshStateView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
    [_stateView setTitle:self.noMoreDataStateTitle forState:MJRefreshStateNoMoreData];
    [_stateView setBackgroundColor:[UIColor colorWithRed:237/255.5 green:237/255.5 blue:237/255.5 alpha:1.0]];
    [self addSubview:_stateView];
}

#pragma mark - 懒加载
// - (JVRefreshStateView *)stateView
// {
//    if (!_stateView) {
//        _stateView = [[JVRefreshStateView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
//        [_stateView setTitle:self.noMoreDataStateTitle forState:MJRefreshStateNoMoreData];
//        [_stateView setBackgroundColor:ColorTableViewBackGround];
//        [self addSubview:_stateView];
//    }
//    return _stateView;
// }

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];

    if (_stateView) {
        [_stateView setBackgroundColor:backgroundColor];
    }
}

#pragma makr - 重写父类的方法
- (void)prepare
{
    [super prepare];

    self.mj_h = self.stateView.frame.size.height;
}

- (void)placeSubviews
{
    [super placeSubviews];

    if (self.superview) {
        [_stateView setBackgroundColor:self.superview.backgroundColor];
    }
}

- (void)setState:(MJRefreshState)state
{
    [self.stateView setState:state];

    MJRefreshCheckState
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
}

@end
