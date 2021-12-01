//
//  FECreateStoreVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/18.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FECreateStoreVC : FEBaseViewController

@property (nonatomic,copy) void (^createComplate)(void);
@end

NS_ASSUME_NONNULL_END
