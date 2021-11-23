//
//  FEStoreTypeVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/20.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEStoreTypeVC : FEBaseViewController
@property (nonatomic, copy) void(^selectedAction)(NSDictionary*model);
@end

NS_ASSUME_NONNULL_END
