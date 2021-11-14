//
//  FEBaseViewController.h
//  flashE
//
//  Created by duxiangnan on 2021/11/4.
//

#import <UIKit/UIKit.h>
#import "FEHttpManager.h"
#import "FEEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FEBaseViewController : UIViewController

@property (nonatomic, assign) BOOL customModalStyle;
@property (nonatomic, assign) BOOL isHiddenBackButton;//是否隐藏返回按钮

@property (nonatomic, strong) FEEmptyView* emptyView;

@property (nonatomic, assign) CGRect emptyFrame;
@property (nonatomic, copy) NSString* emptyImage;
@property (nonatomic, copy) NSString* emptyTitle;
@property (nonatomic, copy) NSString* emptyDesc;

@property (nonatomic, copy) NSString* errorImage;
@property (nonatomic, copy) NSString* errorTitle;
@property (nonatomic, copy) NSString* errorDesc;

@property (nonatomic, copy) void (^emptyAction)(void);//实现点击回调


- (void) backAction;


- (void)showEmptyViewWithType:(BOOL)isEmpty;
- (void) hiddenEmptyView;
@end

NS_ASSUME_NONNULL_END
