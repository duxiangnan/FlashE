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

//使用默认city参数
@property (nonatomic,assign) BOOL defaultCityid;
@property (nonatomic,strong) NSString* defaultCityName;


@property (nonatomic, copy) void(^selectedAction)(FEAddressModel*model);
@end

NS_ASSUME_NONNULL_END
