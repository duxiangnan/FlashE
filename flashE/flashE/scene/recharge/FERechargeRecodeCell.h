//
//  FERechargeRecodeCell.h
//  flashE
//
//  Created by duxiangnan on 2021/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FERechargeRecodeCell : UITableViewCell
@property (nonatomic,copy) void(^commondAction)(NSNumber* type);
@end

NS_ASSUME_NONNULL_END
