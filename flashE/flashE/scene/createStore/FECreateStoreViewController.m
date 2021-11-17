//
//  FECreateStoreViewController.m
//  flashE
//
//  Created by duxiangnan on 2021/11/18.
//

#import "FECreateStoreViewController.h"
#import "FEDefineModule.h"

@interface FECreateStoreViewController ()

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;

//cell0
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell0T;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell0H;

@property (nonatomic, weak) IBOutlet UITextField* dianNameTF;

@property (nonatomic, weak) IBOutlet UILabel* dianNameLB;

@property (nonatomic, weak) IBOutlet UILabel* dianDetailLB;

@property (nonatomic, weak) IBOutlet UILabel* dianTypeLB;

@property (nonatomic, weak) IBOutlet UITextField* dianPhoneTF;

//cell1
@property (nonatomic, weak) IBOutlet UIButton* zhengZMBtn;

@property (nonatomic, weak) IBOutlet UIButton* zhengFMBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell1T;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell1H;


//cell2
@property (nonatomic, weak) IBOutlet UIButton* yingyeBtn;

@property (nonatomic, weak) IBOutlet UIButton* dianBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell2T;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell2H;

//cell3
@property (nonatomic, weak) IBOutlet UISwitch* defaultAddressSw;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell3T;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell3H;

//cell4
@property (nonatomic, weak) IBOutlet UIButton* submintBtn;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell4T;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell4H;
@end

@implementation FECreateStoreViewController
+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
        
        [FFRouter registerObjectRouteURL:@"createStore://newStoreVC" handler:^id(NSDictionary *routerParameters) {
            FECreateStoreViewController* vc = [[FECreateStoreViewController alloc] initWithNibName:@"FECreateStoreViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = NO;
    self.title = @"添加店铺";
    CGFloat width = (kScreenWidth - 10*2 - 16*2 - 10)/2;
    CGFloat btnH = 106.0/156*width;
    self.cell1H.constant = 16+20+16+btnH+16;
    self.cell2H.constant = self.cell1H.constant;
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    CGFloat height = self.cell0T.constant + self.cell0H.constant +
    self.cell1T.constant + self.cell1H.constant +
    self.cell2T.constant + self.cell2H.constant +
    self.cell3T.constant + self.cell3H.constant +
    self.cell4T.constant + self.cell4H.constant + 20 + kHomeIndicatorHeight;
    
    height = MAX(kScreenHeight-kHomeNavigationHeight-kHomeIndicatorHeight, height);
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, height);
}

- (IBAction)dianNameAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)dianDetailAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)dianTypeAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)zhengZMAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)zhengFMAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)yingyeAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)dianAction:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)submintAction:(id)sender {
    [self.view endEditing:YES];
}

@end
