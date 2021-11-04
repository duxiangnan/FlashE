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
#import "defines.h"


@interface FEBaseViewController ()

@end

@implementation FEBaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_customModalStyle) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor]};
    
    if (!self.isHiddenBackButton) {
        self.isHiddenBackButton = self.navigationController.viewControllers.count == 1;
    }
    self.fd_prefersNavigationBarHidden = YES;
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
    [btn setImage:[UIImage imageNamed:@"vsp_defines_arrow_left_dark"] forState:UIControlStateNormal];
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


@end
