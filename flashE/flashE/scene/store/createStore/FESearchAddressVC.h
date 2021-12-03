//
//  FESearchAddressVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/20.
//

#import "FEBaseViewController.h"
#import "FEAddressModel.h"

NS_ASSUME_NONNULL_BEGIN
@class FEStoreCityItemModel;
@interface FESearchAddressVC : FEBaseViewController

@property (nonatomic, copy) void(^selectedAction)(FEAddressModel*model,FEStoreCityItemModel* city);
@end

NS_ASSUME_NONNULL_END
