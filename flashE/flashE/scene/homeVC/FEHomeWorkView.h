//
//  FEHomeWorkView.h
//  flashE
//
//  Created by duxiangnan on 2021/11/12.
//

#import <UIKit/UIKit.h>
#import "FEBaseViewController.h"
#import <JXPagingView/JXPagerView.h>
NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    homeWorkWaiting = 10, //待接单
    homeWorkWaitFetch = 20, //待取单
    homeWorkWaitSend = 40,//配送中
    homeWorkCancel = 50,//已取消
    homeWorkFinish = 60,//已完成
} FEHomeWorkType;

//代接单；20已接单；30已到店；40配送中；50已完成；60已取消；70配送失败

@interface FEHomeWorkView : UIView <JXPagerViewListViewDelegate>
@property (nonatomic, assign) FEHomeWorkType type;
@end

NS_ASSUME_NONNULL_END
