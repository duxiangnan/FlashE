//
//  FERechargeHeaderCell.h
//  flashE
//
//  Created by duxiangnan on 2021/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FERechargeTotalModel;
@class FERechargeModel;

@interface FERechargeHeaderCell : UITableViewCell
@property (nonatomic,copy) void (^backAction)(void);
@property (nonatomic,copy) void (^rechargeAction)(FERechargeModel* item,NSInteger type);

+(CGFloat) calculationCellHeight:(FERechargeTotalModel*)model;
- (void) setModel:(FERechargeTotalModel*) model;
@end

NS_ASSUME_NONNULL_END
