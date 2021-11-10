//
//  FEBaseViewController.h
//  flashE
//
//  Created by duxiangnan on 2021/11/4.
//

#import <UIKit/UIKit.h>
#import "FEHttpManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEBaseViewController : UIViewController

@property (nonatomic, assign) BOOL customModalStyle;
@property (nonatomic, assign) BOOL isHiddenBackButton;//是否隐藏返回按钮

- (void) backAction;
@end

NS_ASSUME_NONNULL_END
