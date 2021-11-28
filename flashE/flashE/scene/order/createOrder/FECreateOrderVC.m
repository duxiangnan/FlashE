//
//  FECreateOrderVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FECreateOrderVC.h"
#import "FEDefineModule.h"
#import "FEWeightSettingView.h"
#import "FEStoreSelectedView.h"
#import <zhPopupController/zhPopupController.h>
#import "FEMyStoreModel.h"
#import "FECreateOrderRemarkVC.h"
#import "FECreateOrderReciveAddressInfoVC.h"

@interface FECreateOrderLogisticsModel : NSObject
@property (nonatomic, copy) NSString* logisticId;
@property (nonatomic, copy) NSString* logisticName;
@property (nonatomic, copy) NSString* logisticImage;
@property (nonatomic, copy) NSString* logisticDescImage;

@property (nonatomic, assign) NSInteger status;//cell选择状态 0：未选择，1:选中，-1:无效
@end

@implementation FECreateOrderLogisticsModel

@end



@interface FECreateOrderModel : NSObject
@property (nonatomic, assign) long long storeId;//店铺ID
@property (nonatomic, assign) long long cityId;//城市ID
@property (nonatomic, copy) NSString* cityName;//城市名称

@property (nonatomic, copy) NSString* toAddress;//收件地址
@property (nonatomic, copy) NSString* toAddressDetail;//收件地址详情
@property (nonatomic, copy) NSString* toUserName;//收件人
@property (nonatomic, copy) NSString* toMobile;//收件人手机号
@property (nonatomic, assign) double toLng;//收件经度
@property (nonatomic, assign) double toLat;//收件纬度
@property (nonatomic, assign) NSInteger additionFee;//小费

@property (nonatomic, assign) NSInteger appointType;//预约类型0及时单；1预约单
@property (nonatomic, assign) double fromLng;//下单地址经度
@property (nonatomic, assign) double fromLat;//下单地址纬度
@property (nonatomic, copy) NSString* fromAddress;//发件地址
@property (nonatomic, copy) NSString* fromName;//下单人
@property (nonatomic, copy) NSString* fromMobile;//下单人手机号


@property (nonatomic, assign) NSInteger category;//物品类型
@property (nonatomic, copy) NSString* categoryName;//物品类型名称
@property (nonatomic, assign) NSInteger weight;//重量
@property (nonatomic, copy) NSString* remark;//备注
@property (nonatomic, assign) NSArray<FECreateOrderLogisticsModel*>* logistics;//选择下单平台

@end
@implementation FECreateOrderModel

@end


@interface FECreateOrderVC ()
@property (nonatomic,strong) FECreateOrderModel* model;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;


@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressViewH;
@property (weak, nonatomic) IBOutlet UILabel *addressFromTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *addressFromDescLB;
@property (weak, nonatomic) IBOutlet UILabel *addressToTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *addressToDescLB;

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewH;
@property (weak, nonatomic) IBOutlet UILabel *weightLB;
@property (weak, nonatomic) IBOutlet UILabel *remarkLB;
@property (weak, nonatomic) IBOutlet UILabel *tipLB;//小费

@property (weak, nonatomic) IBOutlet UIView *platformView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformViewT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformViewH;
@property (weak, nonatomic) IBOutlet UITableView *platformTable;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet UILabel *submitInfoLB;


@property (nonatomic,strong) zhPopupController* popupController;
@property (nonatomic,strong) FEWeightSettingView* weightView;
@property (nonatomic,strong) FEStoreSelectedView* storeView;
@property (nonatomic,strong) FECreateOrderRemarkVC* remarkVC;
@property (nonatomic,strong) FECreateOrderReciveAddressInfoVC* reciveAddressInfoVC;

@end

@implementation FECreateOrderVC

+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
    
        [FFRouter registerObjectRouteURL:@"order://createOrder" handler:^id(NSDictionary *routerParameters) {
            FECreateOrderVC* vc = [[FECreateOrderVC alloc] initWithNibName:@"FECreateOrderVC" bundle:nil];
            vc.actionComplate = routerParameters[@"actionComplate"];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = NO;
    self.title = @"发单";
    
    self.model = [FECreateOrderModel new];
    [self freshSubView];
    
}

- (void) freshSubView {
    self.addressViewT.constant = 10;
    self.addressViewH.constant = 140;
    
    self.infoViewT.constant = 10;
    self.infoViewH.constant = 140;
    
    if ( self.model.logistics.count > 0) {
        self.platformViewT.constant = 10;
        self.platformViewH.constant = 60 + self.model.logistics.count*30;
    } else {
        self.platformViewT.constant = 0;
        self.platformViewH.constant = 0;
    }
    
    self.bottomViewT.constant = 10;
    self.bottomViewH.constant = 10 + 48 + 10 + kHomeIndicatorHeight;
    
    CGFloat height = self.addressViewT.constant + self.addressViewH.constant +
    self.infoViewT.constant + self.infoViewH.constant +
    self.platformViewT.constant + self.platformViewH.constant +
    self.bottomViewT.constant + self.bottomViewH.constant;
    if (height < kScreenHeight - kHomeNavigationHeight) {
        self.scroll.scrollEnabled = NO;
        height = kScreenHeight - kHomeNavigationHeight;
    }else {
        self.scroll.scrollEnabled = YES;
    }
    self.scroll.contentSize = CGSizeMake(kScreenWidth, height);
    
    
}
- (void) freshSubViewData {
    
    UIColor* emptyColor = UIColorFromRGB(0x777777);
    UIColor* filledColor = UIColorFromRGB(0x333333);
    if (self.model.fromName.length > 0) {
        self.addressFromTitleLB.textColor = filledColor;
        self.addressFromTitleLB.text = self.model.fromName;
    }
    
    
    self.weightLB.text = [NSString stringWithFormat:@"%ld",self.model.weight];
//    @property (weak, nonatomic) IBOutlet UILabel *addressFromTitleLB;
//    @property (weak, nonatomic) IBOutlet UILabel *addressFromDescLB;
//    @property (weak, nonatomic) IBOutlet UILabel *addressToTitleLB;
//    @property (weak, nonatomic) IBOutlet UILabel *addressToDescLB;
//
//    @property (weak, nonatomic) IBOutlet UIView *infoView;
//    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewT;
//    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *infoViewH;
//    @property (weak, nonatomic) IBOutlet UILabel *weightLB;
//    @property (weak, nonatomic) IBOutlet UILabel *remarkLB;
//    @property (weak, nonatomic) IBOutlet UILabel *tipLB;//小费
//
//    @property (weak, nonatomic) IBOutlet UIView *platformView;
//    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformViewT;
//    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformViewH;
//    @property (weak, nonatomic) IBOutlet UITableView *platformTable;
//
//    @property (weak, nonatomic) IBOutlet UIView *bottomView;
//    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewT;
//    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
//    @property (weak, nonatomic) IBOutlet UILabel *submitInfoLB;
//
    
    
}
- (void) setTipInfo:(NSInteger)tip {
    //设置小费
    self.model.additionFee = tip;
    self.tipLB.text = [NSString stringWithFormat:@"%ld",(long)tip];
}
- (IBAction)fromAddressAction:(id)sender {
    [self.storeView freshSubData];
    _popupController = [[zhPopupController alloc] initWithView:self.storeView
                                                          size:self.storeView.bounds.size];
    _popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    _popupController.layoutType = zhPopupLayoutTypeBottom;
    _popupController.presentationTransformScale = 1.25;
    _popupController.dismissonTransformScale = 0.85;
    [_popupController showInView:self.view.window completion:NULL];
    
    
}
- (IBAction)toAddressAction:(id)sender {
    [self.navigationController pushViewController:self.reciveAddressInfoVC animated:YES];
}

- (IBAction)weightAction:(id)sender {
    
    self.weightView.currentWeight = self.model.weight;
    _popupController = [[zhPopupController alloc] initWithView:self.weightView
                                                          size:self.weightView.bounds.size];
    _popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    _popupController.layoutType = zhPopupLayoutTypeBottom;
    _popupController.presentationTransformScale = 1.25;
    _popupController.dismissonTransformScale = 0.85;
    [_popupController showInView:self.view.window completion:NULL];
    
}
- (IBAction)remarkAction:(id)sender {
    self.remarkVC.remark = self.model.remark;
    [self.navigationController pushViewController:self.remarkVC animated:YES];
}
- (IBAction)tipAction:(id)sender {
    
    UIAlertController* actionView = [UIAlertController alertControllerWithTitle:@"选择小费额度"
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [actionView addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *_Nonnull action) {}]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"2元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self setTipInfo:2];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"5元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self setTipInfo:5];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"10元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self setTipInfo:10];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"15元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self setTipInfo:15];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"25元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self setTipInfo:25];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"50元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self setTipInfo:50];
    }]];
    if (actionView.popoverPresentationController) {

        UIPopoverPresentationController *popover = actionView.popoverPresentationController;
        popover.sourceView = self.infoView;
        popover.sourceRect = CGRectMake(0,CGRectGetHeight(self.infoView.frame)/2,0,0);
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:actionView animated:YES completion:nil];
}

- (IBAction)submitAction:(id)sender {
    
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    
    param[@"toLng"] = @(self.model.toLng);
    param[@"toLat"] = @(self.model.toLat);
    param[@"cityName"] = self.model.cityName;
    param[@"fromAddress"] = self.model.fromAddress;
    param[@"additionFee"] = @(self.model.additionFee);
    param[@"cityId"] =  @(self.model.cityId);
    param[@"storeId"] = @(acc.storeId);
    param[@"toAddress"] = self.model.toAddress;
    param[@"toAddressDetail"] = self.model.toAddressDetail;
    param[@"toUserName"] = self.model.toUserName;
    param[@"toMobile"] =  self.model.toMobile;
    param[@"fromName"] = self.model.fromName;
    param[@"fromMobile"] = self.model.fromMobile;
    param[@"appointType"] = @(0);//   Integer    预约类型0及时单；1预约单    Y
    param[@"fromLng"] = @(self.model.fromLng);
    param[@"fromLat"] = @(self.model.fromLat);
    param[@"category"] = @(self.model.category);
    param[@"weight"] = @(self.model.weight);
    NSMutableArray* tmp = [NSMutableArray array];
    for (FECreateOrderLogisticsModel* item in self.model.logistics) {
        if (item.status == 1) {
            [tmp addObject:item.logisticName];
        }
        
    }
    param[@"logistics"] = tmp;
    
    
    @weakself(self);
    [MBProgressHUD showProgress];
    [[FEHttpManager defaultClient] POST:@"/deer/orders/create" parameters:param success:^(NSInteger code, id  _Nonnull response) {
        [MBProgressHUD hideProgress];
        [MBProgressHUD showMessage:@"下单成功"];
        @strongself(weakSelf);
        NSDictionary* data = response[@"data"];
        !strongSelf.actionComplate?:strongSelf.actionComplate(data[@"orderId"]);
        
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD hideProgress];
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        [MBProgressHUD hideProgress];
    }];
    
}


#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
//    FEHomeWorkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEHomeWorkCell"];
//    FEHomeWorkOrderModel* item = self.model.orders[indexPath.row];
//    [cell setModel:item];
//    @weakself(self);
//    cell.cellCommondActoin = ^(FEOrderCommondType type) {
//        @strongself(weakSelf);
//        [strongSelf cellCommond:item type:type view:cell];
//    };
//    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.logistics.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FECreateOrderLogisticsModel* item = self.model.logistics[indexPath.row];
//    [FEHomeWorkCell calculationCellHeight:item];
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(FEWeightSettingView*) weightView {
    if (!_weightView) {
        _weightView = [[NSBundle mainBundle] loadNibNamed:@"FEWeightSettingView" owner:self options:nil].firstObject;
        _weightView.frame = CGRectMake(0, 0, kScreenWidth, 230 + kHomeIndicatorHeight);
        _weightView.currentWeight = self.model.weight;
        @weakself(self);
        _weightView.sureWeightAction = ^(NSInteger weight) {
            @strongself(weakSelf);
            strongSelf.model.weight = weight;
            [strongSelf freshSubViewData];
            [strongSelf.popupController dismiss];
        };
        _weightView.cancleAction = ^{
            @strongself(weakSelf);
            [strongSelf.popupController dismiss];
        };
    }
    return _weightView;
}
-(FEStoreSelectedView*) storeView {
    if (!_storeView) {
        _storeView = [[NSBundle mainBundle] loadNibNamed:@"FEStoreSelectedView" owner:self options:nil].firstObject;
        _storeView.frame = CGRectMake(0, 0, kScreenWidth, 360+kHomeIndicatorHeight);
        @weakself(self);
        _storeView.selectedAction = ^(FEMyStoreModel* model) {
            @strongself(weakSelf);
            strongSelf.model.fromLat = model.latitude.doubleValue;
            strongSelf.model.fromLng = model.longitude.doubleValue;
            strongSelf.model.fromAddress = model.address;
            strongSelf.model.fromName = model.name;
            strongSelf.model.fromMobile = model.mobile;
            strongSelf.model.cityId = model.cityId;
            strongSelf.model.cityName = model.cityName;
            strongSelf.model.category = model.category;
            strongSelf.model.categoryName = model.categoryName;
#warning  店铺id使用问题
            strongSelf.model.storeId = model.shopId;
            
            strongSelf.addressFromTitleLB.text = strongSelf.model.fromName;
            strongSelf.addressFromDescLB.text = [NSString stringWithFormat:@"%@ %@",model.address,model.addressDetail];
            [strongSelf.popupController dismiss];
        };
        _storeView.cancleAction = ^{
            @strongself(weakSelf);
            [strongSelf.popupController dismiss];
        };
    }
    return _storeView;
}

- (FECreateOrderRemarkVC*) remarkVC {
    if (!_remarkVC) {
        _remarkVC = [[FECreateOrderRemarkVC alloc] initWithNibName:@"FECreateOrderRemarkVC" bundle:nil];
        @weakself(self);
        _remarkVC.remarkAction = ^(NSString * _Nonnull remark) {
            @strongself(weakSelf);
            strongSelf.model.remark = remark;
        };
    }
    return _remarkVC;
}

- (FECreateOrderReciveAddressInfoVC*) reciveAddressInfoVC {
    if (!_reciveAddressInfoVC) {
        _reciveAddressInfoVC = [[FECreateOrderReciveAddressInfoVC alloc] initWithNibName:@"FECreateOrderReciveAddressInfoVC" bundle:nil];
        @weakself(self);
        _reciveAddressInfoVC.infoComplate = ^(FEReciverAddressModel * _Nonnull model) {
            @strongself(weakSelf);
            strongSelf.model.toAddress = model.address;
            strongSelf.model.toAddressDetail = model.addressDetail;
            strongSelf.model.toUserName = model.name;
            strongSelf.model.toMobile = model.mobile;
            strongSelf.model.toLng = model.longitude.doubleValue;
            strongSelf.model.toLat = model.latitude.doubleValue;
            strongSelf.addressToTitleLB.text = [NSString stringWithFormat:@"%@ %@",model.address,model.addressDetail];
            strongSelf.addressToDescLB.text = [NSString stringWithFormat:@"%@ %@",model.name,model.mobile];
            
        };
    }
    return _reciveAddressInfoVC;
}


@end
