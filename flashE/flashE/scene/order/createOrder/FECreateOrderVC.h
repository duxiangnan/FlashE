//
//  FECreateOrderVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FEBaseViewController.h"
@class FEOrderDetailModel,FEHomeWorkOrderModel;
NS_ASSUME_NONNULL_BEGIN

@interface FECreateOrderVC : FEBaseViewController

@property (nonatomic, strong) FEOrderDetailModel* orderDetailModel;
@property (nonatomic, strong) FEHomeWorkOrderModel* orderListModel;
@property (nonatomic, copy) void(^actionComplate)(NSString* orderId);
@end

NS_ASSUME_NONNULL_END
