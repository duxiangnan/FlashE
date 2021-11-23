//
//  FESearchAddressVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/20.
//

#import "FEBaseViewController.h"
#import "FEAddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FESearchAddressVC : FEBaseViewController

@property (nonatomic, copy) void(^selectedAction)(FEAddressModel*model,NSDictionary* city);
@end

NS_ASSUME_NONNULL_END
