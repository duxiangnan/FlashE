//
//  FERechargeVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/20.
//

#import "FERechargeVC.h"
#import "FEDefineModule.h"
#import "FERechargeModel.h"
#import "FERechargeRecodeModel.h"

#import "FERechargeHeaderCell.h"
#import "FERechargeRecodeCell.h"


#import "WXApi.h"




@interface FERechargeVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviViewH;

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) FERechargeTotalModel *model;

@end

@implementation FERechargeVC
+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
    
        [FFRouter registerObjectRouteURL:@"recharge://createRechange" handler:^id(NSDictionary *routerParameters) {
            FERechargeVC* vc = [[FERechargeVC alloc] initWithNibName:@"FERechargeVC" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviViewH.constant = kHomeNavigationHeight;
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.table registerNib:[UINib nibWithNibName:@"FERechargeHeaderCell" bundle:nil]
       forCellReuseIdentifier:@"FERechargeHeaderCell"];
    [self.table registerNib:[UINib nibWithNibName:@"FERechargeRecodeCell" bundle:nil]
     forCellReuseIdentifier:@"FERechargeRecodeCell"];
    
    self.model = [FERechargeTotalModel new];
    [self requestRechargeList];
}

- (IBAction)naviBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) requestRechargeList {
    
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/recharge/getRechargeList" parameters:nil
                               success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        NSArray* arr = response[@"data"];
        strongSelf.model.list = [NSArray yy_modelArrayWithClass:[FERechargeModel class] json:arr];
        if (strongSelf.model.list.count>0) {
            FERechargeModel* fisrt = strongSelf.model.list.firstObject;
            fisrt.selected = YES;
        }
        [strongSelf requestRechargeBalance];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        
        [MBProgressHUD showMessage:error.localizedDescription];
        @strongself(weakSelf);
        [strongSelf requestRechargeBalance];
    } cancle:^{
        
    }];
}

- (void) requestRechargeBalance {
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/shop/queryShopBalance" parameters:nil
                               success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        NSDictionary* dic = response[@"data"];
        strongSelf.model.balance = ((NSNumber*)dic[@"balance"]).floatValue;
        [strongSelf.table reloadData];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
        @strongself(weakSelf);
        [strongSelf.table reloadData];
    } cancle:^{
        
    }];
    
}
- (void) rechargeAction:(FERechargeModel *)item type:(NSInteger) type {
    
//    if(![WXApi isWXAppInstalled]){
//        [MBProgressHUD showMessage:@"请安装微信后使用"];
//        return;
//    }
    
    @weakself(self);
    NSMutableDictionary*param = [NSMutableDictionary dictionary];
    param[@"openId"] = @"";//kWXAPPID;//@"wx80e41617f401c3e0";//
    param[@"amount"] = @(item.amount);
    
    
    [[FEHttpManager defaultClient] POST:@"/deer/recharge/userRecharge" parameters:param
                               success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        NSDictionary* dic = response[@"data"];
        switch (type) {
            case 1:
                [strongSelf gotoWeiXinPay:dic];
                break;
            default:
                break;
        }
        
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
        
    } cancle:^{
        
    }];
}
-(void) gotoWeiXinPay:(NSDictionary*)dict {
    if(dict.count > 0){
        [MBProgressHUD showProgress];
        NSMutableString *stamp  = [dict objectForKey:@"timeStamp"];
        PayReq* req = [[PayReq alloc] init];
        req.openID = kWXAPPID;
        req.partnerId = [dict objectForKey:@"partnerId"];
        req.prepayId = [dict objectForKey:@"prepayId"];
        req.nonceStr = [dict objectForKey:@"nonceStr"];
        req.timeStamp = stamp.intValue;
        req.package = [dict objectForKey:@"packageValue"];
        req.sign = [dict objectForKey:@"sign"];
        
        
        [WXApi sendReq:req completion:^(BOOL success) {
            [MBProgressHUD hideProgress];
            NSString* msg = success?@"支付成功":@"支付失败";
            [MBProgressHUD showMessage:msg];
            if (success) {
                [self requestRechargeBalance];
            }
        }];
        //日志输出
        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    }
}
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        FERechargeHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FERechargeHeaderCell"];
        [cell setModel:self.model];
        @weakself(self);
        cell.rechargeAction = ^(FERechargeModel * _Nonnull item,NSInteger type) {
            @strongself(weakSelf);
            [strongSelf rechargeAction:item type:type];
        };
        return cell;
    } else{
        
        FERechargeRecodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FERechargeRecodeCell"];
        [cell setModel];
        return cell;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [FERechargeHeaderCell calculationCellHeight:self.model];
    } else{
        return kScreenHeight/2;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary* item = self.showList[indexPath.row];
//
//    !self.selectedAction?:self.selectedAction(item);
//    [self cancleAvtion:nil];
}


@end
