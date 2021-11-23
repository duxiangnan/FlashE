//
//  FEHomeWorkCell.h
//  flashE
//
//  Created by duxiangnan on 2021/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FEHomeWorkOrderModel;

typedef enum : NSUInteger {
    FEHomeWorkCommodCancel,//取消订单
    FEHomeWorkCommodAddCheck,//加小费
    FEHomeWorkCommodCallRider,//联系骑手
    FEHomeWorkCommodRetry,//重新发送
} FEHomeWorkCommodType;
@interface FEHomeWorkCell : UITableViewCell

@property (nonatomic,copy) void(^cellCommondActoin)(FEHomeWorkCommodType type);

+ (void) calculationCellHeight:(FEHomeWorkOrderModel*)model;
- (void) setModel:(FEHomeWorkOrderModel*) model;


    

@end

NS_ASSUME_NONNULL_END
