//
//  FEStoreDetailCellView.h
//  flashE
//
//  Created by duxiangnan on 2021/11/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class FEMyStoreModel;
@class FELogisticsModel;
@interface FEStoreDetailAddressCell : UITableViewCell

- (void) setModel:(FEMyStoreModel*) model;
@end


@interface FEStoreDetailZhengjianCell : UITableViewCell
- (void) setModel:(FEMyStoreModel*) model;
@end


@interface FEStoreDetailDianInfoCell : UITableViewCell
- (void) setModel:(FEMyStoreModel*) model;
@end


@interface FEStoreDetailCommondCell : UITableViewCell
@property(nonatomic,copy) void(^modifyActionBlock)(void);
@property(nonatomic,copy) void(^deleteActionBlock)(void);
@end



@interface FEStoreDetailPingtaiTitleCell : UITableViewCell

@end


@interface FEStoreDetailPingtaiCell : UITableViewCell

@property (nonatomic,copy) void(^modifyAcionBlock)(FELogisticsModel* model);
- (void) setModel:(FELogisticsModel*) model;
@end
NS_ASSUME_NONNULL_END
