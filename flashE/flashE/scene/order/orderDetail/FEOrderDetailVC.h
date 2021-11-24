//
//  FEOrderDetailVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/24.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEOrderDetailVC : FEBaseViewController
@property (nonatomic, copy) NSString* orderId;


@property (nonatomic, copy) void(^actionComplate)(NSString* orderId);
@end

NS_ASSUME_NONNULL_END
