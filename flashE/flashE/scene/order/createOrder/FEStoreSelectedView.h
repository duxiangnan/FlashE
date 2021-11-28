//
//  FEStoreSelectedView.h
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FEMyStoreModel;
@interface FEStoreSelectedView : UIView

@property (nonatomic,copy) void (^selectedAction)(FEMyStoreModel* model);
@property (nonatomic, copy) void(^cancleAction)(void);
@property (nonatomic,copy) void (^storeManageAction)();

- (void) freshSubData;
@end

NS_ASSUME_NONNULL_END
