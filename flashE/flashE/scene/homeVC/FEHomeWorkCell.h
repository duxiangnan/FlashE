//
//  FEHomeWorkCell.h
//  flashE
//
//  Created by duxiangnan on 2021/11/14.
//

#import <UIKit/UIKit.h>
#import "FEOrderCommond.h"
NS_ASSUME_NONNULL_BEGIN
@class FEHomeWorkOrderModel;


@interface FEHomeWorkCell : UITableViewCell

@property (nonatomic,copy) void(^cellCommondActoin)(FEOrderCommondType type);

+ (void) calculationCellHeight:(FEHomeWorkOrderModel*)model;
- (void) setModel:(FEHomeWorkOrderModel*) model;


    

@end

NS_ASSUME_NONNULL_END
