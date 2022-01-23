//
//  FEOrderDetailVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/24.
//

#import "FEOrderDetailVC.h"
#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"
#import "FEOrderDetailHeaderCell.h"
#import "FEOrderDetailLogisticsCell.h"
#import "FEOrderDetailAddressCell.h"
#import "FEOrderDetailInfoCell.h"
#import "FEOrderDetailLinkCell.h"

#import <zhPopupController/zhPopupController.h>
#import "FETipModel.h"
#import "FETipSettingView.h"

typedef enum : NSUInteger {
    FEOrderDetailCellHeader = 0,
    FEOrderDetailCellLogistics,
    FEOrderDetailCellAddress,
    FEOrderDetailCellInfo,
    FEOrderDetailCellLink,//联系商家客服
    
    
} FEOrderDetailCellType;



@interface FEOrderDetailCellModel:NSObject
@property (nonatomic,assign) FEOrderDetailCellType type;
@property (nonatomic,assign) CGFloat cellHeight;


@end
@implementation FEOrderDetailCellModel

@end


@interface FEOrderDetailVC ()
@property (nonatomic,weak) IBOutlet UIButton* backBtn;
@property (nonatomic,weak) IBOutlet UITableView* table;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* tableB;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* backBtnTop;

@property (nonatomic, strong) FEOrderDetailModel* model;
@property (nonatomic, copy) NSMutableArray<FEOrderDetailCellModel*>* cellModel;


@property (nonatomic,strong) zhPopupController* popupController;
@property (nonatomic,strong) FETipSettingView* tipView;
@end

@implementation FEOrderDetailVC

+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
    
        [FFRouter registerObjectRouteURL:@"order://createOrderDetail" handler:^id(NSDictionary *routerParameters) {
            FEOrderDetailVC* vc = [[FEOrderDetailVC alloc] initWithNibName:@"FEOrderDetailVC" bundle:nil];
            vc.orderId = routerParameters[@"orderId"];
            vc.actionComplate = routerParameters[@"actionComplate"];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"订单详情";
    self.fd_prefersNavigationBarHidden = NO;
    self.backBtn.hidden = YES;
    self.backBtnTop.constant = kHomeInformationBarHeigt + 6;
    
    self.table.tableFooterView = [UIView new];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.separatorColor = [UIColor clearColor];
    
    self.table.estimatedRowHeight = 0;
    self.table.estimatedSectionHeaderHeight = 0;
    self.table.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailHeaderCell" bundle:nil]
       forCellReuseIdentifier:@"FEOrderDetailHeaderCell"];
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailLogisticsCell" bundle:nil]
       forCellReuseIdentifier:@"FEOrderDetailLogisticsCell"];
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailAddressCell" bundle:nil]
       forCellReuseIdentifier:@"FEOrderDetailAddressCell"];
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailInfoCell" bundle:nil]
       forCellReuseIdentifier:@"FEOrderDetailInfoCell"];
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailLinkCell" bundle:nil]
       forCellReuseIdentifier:@"FEOrderDetailLinkCell"];
    
    self.tableB.constant = kHomeIndicatorHeight;
    
    @weakself(self);
    self.emptyAction = ^{
        @strongself(weakSelf);
        [strongSelf requestShowData];
    };
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestShowData];
}
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.emptyFrame = self.table.frame;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
}
- (IBAction) backBtnAction:(id) sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) requestShowData {

    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.orderId;
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/orders/getDetail" parameters:param success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        strongSelf.model = [FEOrderDetailModel yy_modelWithDictionary:response[@"data"]];
        if (strongSelf.model.status == 20 || strongSelf.model.status == 30 || strongSelf.model.status == 40 ){
            strongSelf.fd_prefersNavigationBarHidden = YES;
            [strongSelf.navigationController setNavigationBarHidden:YES];
            strongSelf.backBtn.hidden = NO;
//            10代接单；20已接单；30已到店；40配送中；50已完成；60已取消；70配送失败
            [strongSelf requestCourierLocation];
        } else {
            strongSelf.fd_prefersNavigationBarHidden = NO;
            [strongSelf.navigationController setNavigationBarHidden:NO];
            strongSelf.backBtn.hidden = YES;
            [strongSelf calculataionModel];
            [strongSelf.table reloadData];
        }
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{

    }];
}

- (void) requestCourierLocation {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.orderId;
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/orders/getCourierLocation" parameters:param success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        NSDictionary* data = response[@"data"];
        if (data) {
            strongSelf.model.orderId = ((NSNumber*)data[@"orderId"]).longLongValue;
            strongSelf.model.status = ((NSNumber*)data[@"orderStatus"]).integerValue;
            strongSelf.model.statusName = [FEPublicMethods SafeString:data[@"statusName"]];
            strongSelf.model.courierName = [FEPublicMethods SafeString:data[@"statusName"]];
            strongSelf.model.courierMobile = [FEPublicMethods SafeString:data[@"courierMobile"]];
            strongSelf.model.courierLatitude = [FEPublicMethods SafeString:data[@"latitude"]];
            strongSelf.model.courierLongitude = [FEPublicMethods SafeString:data[@"longitude"]];
            if ([data[@"uploadTime"] isKindOfClass:[NSNumber class]]) {
                strongSelf.model.systemTime = ((NSNumber*)data[@"uploadTime"]).longLongValue;
            }
        }
    
        [strongSelf.model makeUpdaSubKey];
        [strongSelf calculataionModel];
        
        
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
//        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{

    }];
    [self performSelector:@selector(requestCourierLocation) withObject:nil afterDelay:5];
}

- (void) calculataionModel{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray*arr = [NSMutableArray array];
        if(self.model) {
            FEOrderDetailCellModel* item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellHeader;
            item.cellHeight = [FEOrderDetailHeaderCell calculationCellHeight:self.model];
            [arr addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellLogistics;
            item.cellHeight = [FEOrderDetailLogisticsCell calculationCellHeight:self.model];
            [arr addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellAddress;
            item.cellHeight = [FEOrderDetailAddressCell calculationCellHeight:self.model];
            [arr addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellInfo;
            item.cellHeight = [FEOrderDetailInfoCell calculationCellHeight:self.model];
            [arr addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellLink;
            item.cellHeight = self.model.logistic.length>0?80:0;
            [arr addObject:item];
        }
        self.cellModel = arr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if(!self.model) {
                [self showEmptyViewWithType:YES];
            }
            
            [self.table reloadData];
        });
    });
    
}

- (void) addCheckAction:(FEOrderDetailModel*)model view:(UIView*)view{
    self.tipView.userObject = model;
    self.popupController = [[zhPopupController alloc] initWithView:self.tipView
                                                          size:self.tipView.bounds.size];
    self.popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    self.popupController.layoutType = zhPopupLayoutTypeBottom;
    self.popupController.presentationTransformScale = 1.25;
    self.popupController.dismissonTransformScale = 0.85;
    [self.popupController showInView:self.view.window completion:NULL];
}
- (void) requestAddCheck:(FEOrderDetailModel*) model check:(NSInteger) check {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = @(model.orderId);
    param[@"amount"] = @(check);
    @weakself(self);
    [[FEHttpManager defaultClient] POST:@"/deer/orders/createTipsOrder" parameters:param
                                success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        [MBProgressHUD showMessage:[FEPublicMethods SafeString:response[@"msg"] withDefault:@"操作成功"]];
        [strongSelf requestShowData];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        
    }];
}

- (void)cellCommond:(FEOrderDetailModel*) model type:(FEOrderCommondType)type view:(UIView*)view{
    
    switch (type) {
        case FEOrderCommondAddCheck:{
            [self addCheckAction:model view:view];
        }break;
        case FEOrderCommondRetry:{
            NSString* orderId = [NSString stringWithFormat:@"%lld",model.orderId];
            FEBaseViewController* vc = [FFRouter routeObjectURL:@"order://createOrder"
                                                 withParameters:@{@"orderId":orderId}];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case FEOrderCommondCallRider:{
            NSString* phone = [NSString stringWithFormat:@"tel://%@",model.courierMobile];
            [FEPublicMethods openUrlInSafari:phone];
        }break;
        case FEOrderCommondCancel:{
            [self makeSureCancleOrder:model view:view];
            
        }
        default:
            break;
    }
};

- (void) makeSureCancleOrder:(FEOrderDetailModel*) model view:(UIView*)view{
    NSString* msg = nil;
    switch (model.status) {
        case 10://待接单
            msg = @"系统正在为您筛选合适骑手，请您稍等一下～";
            break;
        case 20://待取单
            msg = @"骑手小哥已在来店途中～";
            break;
        case 40://配送中
//        case 30:
            msg = @"骑手小哥已在配送途中啦，如您取消，可能会产生扣款哦～";
        default:
            break;
    }
    FEAlertView* alert = [[FEAlertView alloc] initWithTitle:@"取消提示" message:msg];
    [alert addAction:[FEAlertAction actionWithTitle:@"暂不取消"
                                              style:FEAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[FEAlertAction actionWithTitle:@"确定取消"
                                              style:FEAlertActionStyleDefault
                                            handler:^(FEAlertAction *action) {
        NSMutableDictionary* param = [NSMutableDictionary dictionary];
        param[@"orderId"] = @(model.orderId);
        param[@"reason"] = @"不要配送";
        @weakself(self);
        [[FEHttpManager defaultClient] POST:@"/deer/orders/cancleOrder" parameters:param
                                    success:^(NSInteger code, id  _Nonnull response) {
            @strongself(weakSelf);
            NSDictionary* dic = response[@"data"];
            
            NSString* title = [FEPublicMethods SafeString:dic[@"title"] withDefault:@"取消结果"];
            NSString* msg = [FEPublicMethods SafeString:dic[@"cancelTips"] withDefault:@"取消成功"];
            FEAlertView* alter = [[FEAlertView alloc] initWithTitle:title message:msg];
            [alter addAction:[FEAlertAction actionWithTitle:@"知道了"
                          style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
                [strongSelf requestShowData];
            }]];
            [alter show];
        } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
            [MBProgressHUD showMessage:error.localizedDescription];
        } cancle:^{
        }];
        
    }]];
    [alert show];
    
    
}


#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tmpCell = nil;
    FEOrderDetailCellModel* item = self.cellModel[indexPath.row];
    if (item) {
        switch (item.type) {
            case FEOrderDetailCellHeader:{
                FEOrderDetailHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailHeaderCell"];
                [cell setModel:self.model];
                @weakself(self);
                cell.refreshActoin = ^{
                    @strongself(weakSelf);
                    [strongSelf requestShowData];
                };
                cell.cellCommondActoin = ^(FEOrderCommondType type) {
                    @strongself(weakSelf);
                    [strongSelf cellCommond:self.model type:type view:cell];
                };
                tmpCell = cell;
            }break;
            case FEOrderDetailCellLogistics:{
                FEOrderDetailLogisticsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailLogisticsCell"];
                [cell setModel:self.model];
                tmpCell = cell;
            }break;
            case FEOrderDetailCellAddress:{
                FEOrderDetailAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailAddressCell"];
                [cell setModel:self.model];
                tmpCell = cell;
            }break;
            case FEOrderDetailCellInfo:{
                FEOrderDetailInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailInfoCell"];
                [cell setModel:self.model];
                tmpCell = cell;
            }break;
            case FEOrderDetailCellLink: {
                FEOrderDetailLinkCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailLinkCell"];
                [cell setModel:self.model];
                tmpCell = cell;
            }break;
            default:{
                tmpCell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
                if (!tmpCell) {
                    tmpCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
                }
            }break;
        }
    }
    return tmpCell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.cellModel.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEOrderDetailCellModel* item = self.cellModel[indexPath.row];
    if (item) {
        return item.cellHeight;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEOrderDetailCellModel* item = self.cellModel[indexPath.row];
    if (item) {
     
    }
}


#pragma mark 懒加载
- (FETipSettingView*) tipView {
    if (!_tipView) {
        _tipView = [[NSBundle mainBundle] loadNibNamed:@"FETipSettingView" owner:self options:nil].firstObject;
        _tipView.frame = CGRectMake(0, 0, kScreenWidth, 330 + kHomeIndicatorHeight);
        [_tipView fitterViewHeight];
        @weakself(self);
        _tipView.sureAction = ^(FETipModel*item) {
            @strongself(weakSelf);
            FEOrderDetailModel*model = strongSelf.tipView.userObject;
            [strongSelf requestAddCheck:model check:item.code];
            [strongSelf.popupController dismiss];
        };
        _tipView.cancleAction = ^{
            @strongself(weakSelf);
            [strongSelf.popupController dismiss];
        };
    }
    return _tipView;
    
}

@end
