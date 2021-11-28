//
//  FEWeightSettingView.h
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEWeightSettingView : UIView

@property (nonatomic, assign) NSInteger currentWeight;
@property (nonatomic, copy) void(^sureWeightAction)(NSInteger weight);
@property (nonatomic, copy) void(^cancleAction)(void);
@end

NS_ASSUME_NONNULL_END
