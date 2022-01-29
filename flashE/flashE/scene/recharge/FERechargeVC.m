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
#import "FEHttpPageManager.h"

#import "FERechargeHeaderCell.h"
#import "FERechargeRecodeCell.h"
#import "FERechargeRecodeInfoCell.h"

#import "WXApi.h"




@interface FERechargeVC ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (strong, nonatomic) FERechargeTotalModel *model;

@property (nonatomic,copy) NSArray<FERechargeRecodeModel*>* list;
@property (nonatomic,strong) FEHttpPageManager* pagesManager;
@property (nonatomic,strong) NSNumber* recodeInforType;

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
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.table registerNib:[UINib nibWithNibName:@"FERechargeHeaderCell" bundle:nil]
       forCellReuseIdentifier:@"FERechargeHeaderCell"];
    [self.table registerNib:[UINib nibWithNibName:@"FERechargeRecodeCell" bundle:nil]
     forCellReuseIdentifier:@"FERechargeRecodeCell"];
    
    [self.table registerNib:[UINib nibWithNibName:@"FERechargeRecodeInfoCell" bundle:nil]
     forCellReuseIdentifier:@"FERechargeRecodeInfoCell"];
    
    self.table.mj_header = [JVRefreshHeaderView headerWithRefreshingTarget:self refreshingAction:@selector(requestRechargeList)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePayInfo:)
                                                 name:@"paySuccess" object:nil];
    
    [WXApi registerApp:kWXAPPID universalLink:kWXUNIVERSAL_LINK];
    self.model = [FERechargeTotalModel new];
    [self requestRechargeList];
    self.recodeInforType = @(10);
}

- (void) updatePayInfo:(NSNotification*)noti {
    [self requestRechargeBalance];
    
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
        [strongSelf freshRecodeInfor];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        
        [MBProgressHUD showMessage:error.localizedDescription];
        @strongself(weakSelf);
        [strongSelf requestRechargeBalance];
        [strongSelf freshRecodeInfor];
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
//            NSString* msg = success?@"支付成功":@"支付失败";
//            [MBProgressHUD showMessage:msg];
//            if (success) {
//                [self requestRechargeBalance];
//            }
        }];

//        NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
    }
}


- (void) freshRecodeInfor {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    //类型10 扣款记录；20充值记  录
    param[@"type"] = self.recodeInforType;
    
    self.pagesManager = [[FEHttpPageManager alloc] initWithFunctionId:@"/deer/orders/queryDebitList"
                                                           parameters:param
                                                    itemClass:[FERechargeRecodeModel class]];
    [self.pagesManager setkeyIndex:@"index" size:@"pageSize"];
    self.pagesManager.resultName = @"data";
    self.pagesManager.requestMethod = 1;
    
    @weakself(self);

    void (^loadMore)(void) = ^{
        @strongself(weakSelf);
        if (strongSelf.pagesManager.hasMore) {
            [strongSelf.pagesManager fetchMoreData:^{
                strongSelf.list = strongSelf.pagesManager.dataArr;
                if ([strongSelf.pagesManager hasMore]) {
                    [strongSelf.table.mj_footer endRefreshing];
                } else {
                    [strongSelf.table.mj_footer endRefreshingWithNoMoreData];
                }
                
                if (strongSelf.pagesManager.networkError) {
                    [MBProgressHUD showMessage:strongSelf.pagesManager.networkError.localizedDescription];
                }
                [strongSelf.table reloadData];
            }];
        }
    };

    void (^loadFirstPage)(void) = ^{
        @strongself(weakSelf);
        [strongSelf.pagesManager fetchData:^{
            [strongSelf.table.mj_header endRefreshing];
            [strongSelf hiddenEmptyView];
            strongSelf.list = strongSelf.pagesManager.dataArr;
            
            if (strongSelf.pagesManager.hasMore) {
                strongSelf.table.mj_footer = [JVRefreshFooterView footerWithRefreshingBlock:loadMore
                                                                           noMoreDataString:@""];
            } else {
                [strongSelf.table.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (strongSelf.pagesManager.networkError) {
                [MBProgressHUD showMessage:weakSelf.pagesManager.networkError.localizedDescription];
            }
            if (strongSelf.list.count == 0) {
                [strongSelf showEmptyViewWithType:YES];
            }
            [strongSelf.table reloadData];
        }];
    };

    
    loadFirstPage();
    
    
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
        cell.backAction = ^{
            @strongself(weakSelf);
            [strongSelf backAction];
        };
        return cell;
    } else if (indexPath.row == 1){
        FERechargeRecodeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FERechargeRecodeCell"];
        @weakself(self);
        cell.commondAction = ^(NSNumber * _Nonnull type) {
            @strongself(weakSelf);
            strongSelf.recodeInforType = type;
            [strongSelf freshRecodeInfor];
        };
        
        return cell;
    } else {
        FERechargeRecodeInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FERechargeRecodeInfoCell"];
        if (indexPath.row - 2 < self.list.count) {
            FERechargeRecodeModel* model = self.list[indexPath.row-2];
            [cell setModel:model flag:self.recodeInforType.integerValue==10?-1:1];
        }
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 + self.list.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [FERechargeHeaderCell calculationCellHeight:self.model];
    } else if (indexPath.row == 1) {
        return 60;
    } else {
        return 70;
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
