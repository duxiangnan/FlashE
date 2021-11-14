//
//  FEBaseViewController.m
//  flashE
//
//  Created by duxiangnan on 2021/11/4.
//

#import "FEBaseViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>
#import "UIButtonModule-umbrella.h"
#import "FEPublicMethods.h"
#import "FEDefineModule.h"


@interface FEBaseViewController ()

@end

@implementation FEBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_customModalStyle) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    self.view.backgroundColor = UIColorFromRGB(0xF7F8F9);
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    if (!self.isHiddenBackButton) {
        self.isHiddenBackButton = self.navigationController.viewControllers.count == 1;
    }
    self.fd_prefersNavigationBarHidden = YES;
    
    
    self.emptyFrame = self.view.bounds;
    self.emptyImage = @"FEEmpty_icon";
    self.emptyTitle = @"暂无数据";
    self.emptyDesc = @"";
    
    self.errorImage = @"Wifi-Error";;
    self.errorTitle = @"请检查网络后，再次尝试";
    self.errorDesc = @"";
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setIsHiddenBackButton:(BOOL)isHiddenBackButton {
    _isHiddenBackButton = isHiddenBackButton;
    [self freshBackBtn];
}

- (void) freshBackBtn {
    if (!self.isHiddenBackButton) {
        [self createNavigationBackButton];
    }else{
        [self hiddenBackButton];
    }

}

- (void)createNavigationBackButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"FE_defines_arrow_left_dark"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 20, 44);
    NSString *version = [FEPublicMethods OSVersion];
    
    if (version.doubleValue < 11.0) {
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    [btn setEnlargeEdgeWithTop:30 right:30 bottom:30 left:10];
    [btn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)backAction{
//    if (self.flutter) {
//        [self.navigationController.navigationBar setHidden:YES];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hiddenBackButton {
    UIView * emptyView = [UIView new];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:emptyView];
    self.navigationItem.leftBarButtonItem = backItem;
}




- (void)showEmptyViewWithType:(BOOL)isEmpty {
    CGRect frame = self.emptyFrame;
    NSString* imageName = self.errorImage;
    NSString* emptyTitle = self.errorTitle;
    NSString* desc = self.errorDesc;
    if (isEmpty) {
        imageName = self.emptyImage;
        emptyTitle = self.emptyTitle;
        desc = self.emptyDesc;
    }
    self.emptyView = [[FEEmptyView alloc] initWithFrame:frame emptyImage:imageName title:emptyTitle desc:desc];
    [self.emptyView removeFromSuperview];
    [self.view addSubview:self.emptyView];
    self.emptyView.onTapAction = self.emptyAction;
}
- (void) hiddenEmptyView {
    [self.emptyView emptyHidden];
}

@end
