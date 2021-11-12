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
    homeWorkWaiting = 1, //待接单
    homeWorkWaitFetch, //待取单
    homeWorkWaitSend,//配送中
    homeWorkCancel,//已取消
    homeWorkFinish,//已完成
} FEHomeWorkType;
@interface FEHomeWorkView : FEBaseViewController <JXPagerViewListViewDelegate>
@property (nonatomic, assign) FEHomeWorkType type;
@end

NS_ASSUME_NONNULL_END
