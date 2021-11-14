//
//  JVRefreshHeaderView.h
//  TestRefreshView
//
//  Created by Ton on 15/7/28.
//  Copyright (c) 2015年 JD.com. All rights reserved.
//

//#import <JDTMJRefreshModule/JDTMJRefreshModule-umbrella.h>
//#import "MJRefreshHeader.h"
#import <MJRefresh/MJRefresh.h>
@interface JVRefreshHeaderView : MJRefreshHeader

/** 创建header */
+ (instancetype)headerWithRefreshingBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;
/** 创建header */
+ (instancetype)headerWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

// 影藏文字
- (void)hidenTitle:(BOOL)hiden;

/** 进入刷新状态 */
- (void)beginRefreshing;
/** 结束刷新状态 */
- (void)endRefreshing;
/** 是否正在刷新 */
- (BOOL)isRefreshing;

@end

@interface UIViewController (JVRefreshHeaderView)

@end
