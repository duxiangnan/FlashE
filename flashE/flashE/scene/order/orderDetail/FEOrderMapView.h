//
//  FEOrderMapView.h
//  flashE
//
//  Created by duxiangnan on 2022/1/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FEOrderDetailModel;
@interface FEOrderMapView : UIView


- (void) setModel:(FEOrderDetailModel*)model;


- (CGFloat) getMinHeight;
- (CGFloat) getMaxHeight;
@end

NS_ASSUME_NONNULL_END
