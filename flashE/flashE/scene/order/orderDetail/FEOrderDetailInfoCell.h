//
//  FEOrderDetailInfoCell.h
//  flashE
//
//  Created by duxiangnan on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FEOrderDetailModel;
@interface FEOrderDetailInfoCell : UITableViewCell

+(CGFloat) calculationCellHeight:(FEOrderDetailModel*)model;
- (void) setModel:(FEOrderDetailModel*)model;
@end

NS_ASSUME_NONNULL_END
