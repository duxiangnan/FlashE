//
//  FECreateStoreVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/18.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class FEStoreDetailModel;
@interface FECreateStoreVC : FEBaseViewController
@property (nonatomic,strong) FEStoreDetailModel* model;//修改店铺所需
@property (nonatomic,copy) void (^createComplate)(void);
@end

NS_ASSUME_NONNULL_END
