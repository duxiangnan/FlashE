//
//  FECreateOrderRemarkVC.h
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FEBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FECreateOrderRemarkVC : FEBaseViewController
@property (nonatomic,strong) NSString* remark;
@property (nonatomic,copy) void(^remarkAction)(NSString* remark);
@end

NS_ASSUME_NONNULL_END
