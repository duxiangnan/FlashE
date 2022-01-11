//
//  FETipSettingView.h
//  flashE
//
//  Created by duxiangnan on 2022/1/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class FETipModel;
@interface FETipSettingView : UIView

@property (nonatomic, copy) void(^sureAction)(FETipModel*item);
@property (nonatomic, copy) void(^cancleAction)(void);

-(CGFloat) fitterViewHeight;


@end

NS_ASSUME_NONNULL_END
