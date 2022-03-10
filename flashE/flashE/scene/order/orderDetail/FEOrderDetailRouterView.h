//
//  FEOrderDetailRouterView.h
//  flashE
//
//  Created by duxiangnan on 2022/3/9.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class FEOrderDtailRouteModel;
@interface FEOrderDetailRouterView : UIView
@property (nonatomic, copy) void (^closeAction)(void);
@property (nonatomic,copy) NSArray<FEOrderDtailRouteModel*>* model;
@end

NS_ASSUME_NONNULL_END
