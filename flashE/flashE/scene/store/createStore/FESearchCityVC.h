//
//  FESearchCityVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/21.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class FEStoreCityItemModel ;
@interface FESearchCityVC : FEBaseViewController


@property (nonatomic, copy) void(^selectedAction)(FEStoreCityItemModel*model);
@end

NS_ASSUME_NONNULL_END
