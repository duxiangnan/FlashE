//
//  FECreateOrderReciveAddressInfoVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FEBaseViewController.h"
#import "FEReciverAddressModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FECreateOrderReciveAddressInfoVC : FEBaseViewController
@property (nonatomic,strong) FEReciverAddressModel* model;
@property (nonatomic,copy) void(^infoComplate)(FEReciverAddressModel*model);

- (void) freshSubViewUseModel;
@end

NS_ASSUME_NONNULL_END
