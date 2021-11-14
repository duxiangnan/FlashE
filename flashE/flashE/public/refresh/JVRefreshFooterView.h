//
//  JVRefreshFooterView.h
//  oversea_jv
//
//  Created by Ton on 15/7/30.
//  Copyright (c) 2015年 JD.com. All rights reserved.
//
#import <MJRefresh/MJRefresh.h>
//#import <JDTMJRefreshModule/JDTMJRefreshModule-umbrella.h>
//#import "MJRefreshBackNormalFooter.h"

@interface JVRefreshFooterView : MJRefreshAutoStateFooter // MJRefreshBackFooter

/** 创建footer */
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock noMoreDataString:(NSString *)noString;
+ (instancetype)footerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/** 创建footer */
+ (instancetype)footerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/** 提示没有更多的数据 */
- (void)noticeNoMoreData;
/** 重置没有更多的数据（消除没有更多数据的状态） */
- (void)resetNoMoreData;

/** 进入刷新状态 */
- (void)beginRefreshing;
/** 结束刷新状态 */
- (void)endRefreshing;
/** 是否正在刷新 */
- (BOOL)isRefreshing;

@end
