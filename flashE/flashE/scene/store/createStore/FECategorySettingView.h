//
//  FECategorySettingView.h
//  flashE
//
//  Created by duxiangnan on 2022/1/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FECategorysModel;
@class FECategoryItemModel;
@interface FECategorySettingView : UIView

@property (nonatomic, copy) void(^sureWeightAction)(FECategoryItemModel*item);

@property (nonatomic, copy) void(^cancleAction)(void);

- (void) setDetaultCategory:(NSInteger) code name:(NSString*)name;
- (void) getCategorysData:(void(^)(FECategorysModel* modle))complate;
-(CGFloat) fitterViewHeight;
@end

NS_ASSUME_NONNULL_END


