//
//  FERechargeRecodeInfoCell.h
//  flashE
//
//  Created by duxiangnan on 2022/1/29.
//

#import <UIKit/UIKit.h>
#import "FERechargeRecodeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface FERechargeRecodeInfoCell : UITableViewCell
@property (nonatomic,strong) FERechargeRecodeModel* model;

@property (weak, nonatomic) IBOutlet UILabel *payInfoLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *jineLB;

- (void) setModel:(FERechargeRecodeModel*) model flag:(NSInteger)negative;

@end

NS_ASSUME_NONNULL_END
