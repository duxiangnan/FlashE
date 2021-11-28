//
//  FECreateOrderVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FECreateOrderVC : FEBaseViewController
@property (nonatomic, copy) void(^actionComplate)(NSString* orderId);
@end

NS_ASSUME_NONNULL_END
