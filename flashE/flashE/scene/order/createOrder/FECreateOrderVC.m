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
#import "FECreateOrderLogisticModel.h"
#import "FEOrderDetailModel.h"
#import "FECategorysModel.h"
#import "FEHomeWorkModel.h"
#import "FETipModel.h"
#import "FETipSettingView.h"

@interface FECreateOrderLogisticCell:UITableViewCell

@property (nonatomic,strong) FECreateOrderLogisticDetailsModel* model;


@property (strong, nonatomic) UIImageView *flagImage;
@property (strong, nonatomic) UIImageView *flagSubImage;
@property (strong, nonatomic) UILabel *logisticLB;
@property (strong, nonatomic) UILabel *distanceLB;
@property (strong, nonatomic) UILabel *amountLB;
@property (strong, nonatomic) UILabel *realAmountLB;
@property (strong, nonatomic) UIImageView *statusImage;




@end

@implementation FECreateOrderLogisticCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        
        [self.contentView addSubview:self.flagImage];
        [self.contentView addSubview:self.flagSubImage];
        [self.contentView addSubview:self.logisticLB];
        [self.contentView addSubview:self.distanceLB];
        [self.contentView addSubview:self.amountLB];
        [self.contentView addSubview:self.realAmountLB];
        [self.contentView addSubview:self.statusImage];
        self.flagSubImage.image = [UIImage imageNamed:@"logistic_oneToOne"];
        
        
       
        
    }
    return self;
    
    
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.flagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.width.height.mas_equalTo(@(26));
    }];
    
    [self.logisticLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flagImage.mas_right).offset(5);
        make.bottom.equalTo(self.flagImage.mas_centerY);
        make.height.mas_equalTo(20);
    }];
    [self.flagSubImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.logisticLB.mas_right).offset(5);
        make.centerY.equalTo(self.logisticLB.mas_centerY);
        make.height.mas_equalTo(14.5);
        make.width.mas_equalTo(62);
    }];
    
    [self.distanceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logisticLB.mas_bottom);
        make.left.equalTo(self.logisticLB.mas_left);
        make.height.mas_equalTo(20);
    }];
    
    [self.realAmountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logisticLB.mas_centerY);
        make.right.equalTo(self.statusImage.mas_left).offset(-10);
        make.height.mas_equalTo(20);
    }];
    [self.amountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.realAmountLB.mas_bottom);
        make.right.equalTo(self.realAmountLB.mas_right);
        make.height.mas_equalTo(20);
    }];
    
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
        
    }];
}

- (void)setModel:(FECreateOrderLogisticDetailsModel *)model {
    _model = model;
    
    NSString* image = [[FEAccountManager sharedFEAccountManager] getPlatFormInfo:model.logistic type:FEPlatforeKeyFlage];
    self.flagImage.image = [UIImage imageNamed:image];
    self.flagSubImage.hidden = ![model.logistic isEqualToString:@"bingex"];
    
    self.logisticLB.text = [FEPublicMethods SafeString:model.logisticName];
    self.distanceLB.text = [NSString stringWithFormat:@"%0.1f公里",model.distance];
    self.amountLB.attributedText = nil;
    [self.amountLB appendDeleteLineAttriString:@"原价" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:10]];
    [self.amountLB appendDeleteLineAttriString:[NSString stringWithFormat:@"%0.2f",model.amount ] color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:10]];
    [self.amountLB appendDeleteLineAttriString:@"元" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:10]];
    
    self.realAmountLB.attributedText = nil;
    [self.realAmountLB appendAttriString:@"优惠价" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:10]];
    [self.realAmountLB appendAttriString:[NSString stringWithFormat:@"%0.2f",model.realAmount] color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:20]];
    [self.realAmountLB appendAttriString:@"元" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:10]];
    
    
    self.contentView.backgroundColor = UIColor.whiteColor;
    if (model.status == 1) {
        self.statusImage.image = [UIImage imageNamed:@"checkbox_selected"];
        self.contentView.backgroundColor = UIColorFromRGB(0xF6F7F9);
    } else if (model.status == 0) {
        self.statusImage.image = [UIImage imageNamed:@"checkbox_default"];
    } else{
        self.statusImage.image = nil;
    }
    
}



- (UIImageView *)flagImage {
    if (!_flagImage) {
        _flagImage = [[UIImageView alloc] init];
    }
    return _flagImage;
}
- (UIImageView *)flagSubImage {
    if (!_flagSubImage) {
        _flagSubImage = [[UIImageView alloc] init];
    }
    return _flagSubImage;
}
- (UILabel *)logisticLB {
    if (!_logisticLB) {
        _logisticLB = [[UILabel alloc] init];
        _logisticLB.font = [UIFont mediumFont:15];
        _logisticLB.textColor = UIColorFromRGB(0x333333);
    }
    return _logisticLB;
}
- (UILabel *)distanceLB {
    if (!_distanceLB) {
        _distanceLB = [[UILabel alloc] init];
        _distanceLB.font = [UIFont regularFont:10];
        _distanceLB.textColor = UIColorFromRGB(0x777777);
    }
    return _distanceLB;
}
- (UILabel *)amountLB {
    if (!_amountLB) {
        _amountLB = [[UILabel alloc] init];
    }
    return _amountLB;
}
- (UILabel *)realAmountLB {
    if (!_realAmountLB) {
        _realAmountLB = [[UILabel alloc] init];
    }
    return _realAmountLB;
}
- (UIImageView *)statusImage {
    if (!_statusImage) {
        _statusImage = [[UIImageView alloc] init];
    }
    return _statusImage;
}
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
//@property (weak, nonatomic) IBOutlet UILabel *catagroyLB;
@property (weak, nonatomic) IBOutlet UILabel *remarkLB;
@property (weak, nonatomic) IBOutlet UILabel *tipLB;//小费

@property (weak, nonatomic) IBOutlet UIView *platformView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformViewT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformViewH;
@property (weak, nonatomic) IBOutlet UITableView *platformTable;


@property (weak, nonatomic) IBOutlet UIView *platformTipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformTipViewT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *platformTipViewH;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet UILabel *submitInfoLB;


@property (nonatomic,strong) zhPopupController* popupController;
@property (nonatomic,strong) FETipSettingView* tipView;
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
            vc.orderId = routerParameters[@"orderId"];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = NO;
    self.title = @"发单";
    [self.platformTable registerClass:[FECreateOrderLogisticCell class] forCellReuseIdentifier:@"FECreateOrderLogisticCell"];
    if(!self.model) {
        self.model = [FECreateOrderModel new];
        self.model.weight = 3;
        if (self.orderId.length==0) {
            [self getModelDefault];
        }
    }
    
    [self freshSubView];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.model.fromName.length > 0) {
        FEMyStoreModel* store = [[FEAccountManager sharedFEAccountManager]
                                 getStoreWithId:[NSString stringWithFormat:@"%lld",self.model.storeId]];
        if (store) {
            [self updateWithStore:store];
            [self reqestCalculateFee];
        }
        
    }
}
- (void) getModelDefault {
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    [self updateWithStore:acc.selectedStore];
}
- (void) updateWithStore:(FEMyStoreModel*)store {
    self.model.fromLat = store.latitude;
    self.model.fromLng = store.longitude;
    self.model.fromAddress = store.address;
    self.model.fromAddressDetail = store.addressDetail;
    self.model.fromName = store.name;
    self.model.fromMobile = store.mobile;
    self.model.cityId = store.cityId;
    self.model.cityName = store.cityName;
    self.model.storeId = store.ID;
    self.model.storeName = store.name;
    self.model.category = store.category;
    self.model.categoryName = store.categoryName;
}

- (void) freshSubView {
    
    if ( self.model.logistics.details.count > 0) {
        self.platformViewT.constant = 10;
        self.platformViewH.constant = 60 + self.model.logistics.details.count*60;
        
        self.platformTipViewT.constant = 0;
        self.platformTipViewH.constant = 0;
        
    } else {
        self.platformViewT.constant = 0;
        self.platformViewH.constant = 0;
        
        self.platformTipViewT.constant = 10;
        self.platformTipViewH.constant = 130;
    }
    
    self.addressViewT.constant = 10;
    self.addressViewH.constant = 140;
    
    self.infoViewT.constant = 10;
    self.infoViewH.constant = 100;
    
    self.bottomViewT.constant = 10;
    self.bottomViewH.constant = 10 + 48 + 10 + kHomeIndicatorHeight;
    
    CGFloat height = self.addressViewT.constant + self.addressViewH.constant +
        self.infoViewT.constant + self.infoViewH.constant +
        self.platformViewT.constant + self.platformViewH.constant +
        self.platformTipViewT.constant + self.platformTipViewH.constant +
        self.bottomViewT.constant + self.bottomViewH.constant;
    if (height < kScreenHeight - kHomeNavigationHeight) {
        height = kScreenHeight - kHomeNavigationHeight;
    }
    self.scroll.scrollEnabled = YES;
    self.scroll.contentSize = CGSizeMake(kScreenWidth, height);
    
    [self freshSubViewData];
}
- (void) freshSubViewData {
    UIColor* emptyColor = UIColorFromRGB(0x777777);
    UIColor* filledColor = UIColorFromRGB(0x333333);
    self.addressFromTitleLB.text = [FEPublicMethods SafeString:self.model.storeName withDefault:@"请选择店铺"];
    self.addressFromDescLB.text = [NSString stringWithFormat:@"%@ %@",self.model.fromAddress,self.model.fromAddressDetail];
    
//    NSString* tmp = [NSString stringWithFormat:@"%@%@",
//                     [FEPublicMethods SafeString:self.model.toAddress],
//                     [FEPublicMethods SafeString:self.model.toAddressDetail]];
    NSString* tmp = [FEPublicMethods SafeString:self.model.toAddress];
    if (tmp.length > 0) {
        self.addressToTitleLB.text = tmp;
        self.addressToTitleLB.textColor = filledColor;
    } else {
        self.addressToTitleLB.text = @"点击添加收件地址";
        self.addressToTitleLB.textColor = emptyColor;
    }
    
    tmp = [FEPublicMethods SafeString:self.model.toUserName];
    if (self.model.toMobile.length > 0) {
        tmp = [tmp stringByAppendingFormat:@" %@",self.model.toMobile];
    }
    self.addressToDescLB.text = [FEPublicMethods SafeString:tmp];
    
//
//    self.catagroyLB.text = [FEPublicMethods SafeString:self.model.categoryName withDefault:@"选择类型"];
//    self.catagroyLB.textColor = filledColor;
    NSString* weightStr = [FEPublicMethods SafeString:self.model.categoryName];
    if (self.model.weight<=0) {
        weightStr = @"选择重量";
        self.weightLB.textColor = emptyColor;
    } else {
        weightStr = [NSString stringWithFormat:@"%@/%ld公斤",weightStr,self.model.weight];
        self.weightLB.textColor = filledColor;
    }
    self.weightLB.text = weightStr;
    self.remarkLB.text = [FEPublicMethods SafeString:self.model.remark withDefault:@"添加备注信息"];
    self.remarkLB.textColor = self.model.remark.length==0?emptyColor:filledColor;
    
    
    if (self.model.additionFee <= 0) {
        self.tipLB.text = @"加小费更容易被接单";
        self.tipLB.textColor = emptyColor;
    } else {
        self.tipLB.text = [NSString stringWithFormat:@"%ld元",self.model.additionFee];
        self.tipLB.textColor = filledColor;
    }
    
    __block CGFloat realAmount = 0;
    __block CGFloat selectedAmount = 0;
    
    [self.model.logistics.details enumerateObjectsUsingBlock:^
    (FECreateOrderLogisticDetailsModel * obj, NSUInteger idx, BOOL * stop) {
        realAmount = MAX(realAmount, obj.realAmount);
        if (obj.status == 1) {
            selectedAmount = MAX(selectedAmount, obj.realAmount);
        }
    }];
    CGFloat amount = 0;
    if (selectedAmount > 0) {
        amount = selectedAmount;
    } else {
        amount = realAmount;
    }
    self.model.mustPay = amount;
    self.submitInfoLB.text = [NSString stringWithFormat:@"需支付最高金额%0.2f元",amount];
    [self.platformTable reloadData];
    
}

- (void) updataInputModelUserOrderId:(FEOrderDetailModel *)orderDetailModel {
    
    if(!self.model) {
        self.model = [FECreateOrderModel new];
        self.model.weight = 5;
    }

    self.model.appointType = orderDetailModel.appointType;
    self.model.appointDate = orderDetailModel.appointDate;
//    self.model.categoryName = orderDetailModel.goodName;
    self.model.weight = orderDetailModel.weight;
    
    FEMyStoreModel* store = [[FEAccountManager sharedFEAccountManager] getStoreWithId:orderDetailModel.storeId];
    self.model.cityId = store.cityId;//城市ID
    self.model.cityName = store.cityName;
    

    self.model.toAddress = orderDetailModel.toAdress;
    self.model.toAddressDetail = orderDetailModel.toAdressDetail;
    self.model.toUserName = orderDetailModel.toUserName;
    self.model.toMobile = orderDetailModel.toUserMobile;
    self.model.toLng = orderDetailModel.toLongitude;
    self.model.toLat = orderDetailModel.toLatitude;
//    self.model.additionFee = orderDetailModel.tipAmount;//小费

    
    
    self.model.fromLng = orderDetailModel.fromLongitude;
    self.model.fromLat = orderDetailModel.fromLatitude;
    self.model.storeId = orderDetailModel.storeId.integerValue;
    self.model.storeName = orderDetailModel.storeName;
    self.model.fromAddress = orderDetailModel.fromAddress;
    self.model.fromAddressDetail = orderDetailModel.fromAddressDetail;
    
    self.model.fromName = orderDetailModel.storeName;//下单人
    self.model.fromMobile = store.mobile;//下单人手机号


    self.model.category = orderDetailModel.category;//物品类型
    self.model.categoryName = orderDetailModel.goodName;//物品类型名称
    
    self.model.remark = orderDetailModel.remark;//备注
//    self.model.logistics = orderDetailModel.logistic;//选择下单平台
    
    self.model.remark = orderDetailModel.remark;
    [self reqestCalculateFee];
    
    if (!store) {
        [MBProgressHUD showMessage:@"该店铺地址异常，需要更新下单店铺信息"];
    }
    
}

- (void)setOrderId:(NSString*)orderId {
    _orderId = orderId;
    if(orderId.integerValue <= 0) {
        return;
    }
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = orderId;
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/orders/getDetail" parameters:param success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        FEOrderDetailModel* model = [FEOrderDetailModel yy_modelWithDictionary:response[@"data"]];
        [strongSelf updataInputModelUserOrderId:model];
        [strongSelf freshSubView];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{

    }];
}

//- (void) setTipInfo:(NSInteger)tip {
//    //设置小费
//    self.model.additionFee = tip;
//    self.tipLB.text = [NSString stringWithFormat:@"%ld",(long)tip];
//}

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
    [self.reciveAddressInfoVC freshSubViewUseModel];
    [self.navigationController pushViewController:self.reciveAddressInfoVC animated:YES];
}

- (IBAction)weightAction:(id)sender {
    self.weightView.currentWeight = self.model.weight;
    [self.weightView fitterViewHeight];
    self.popupController = [[zhPopupController alloc] initWithView:self.weightView
                                                          size:self.weightView.bounds.size];
    self.popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    self.popupController.layoutType = zhPopupLayoutTypeBottom;
    self.popupController.presentationTransformScale = 1.25;
    self.popupController.dismissonTransformScale = 0.85;
    [self.popupController showInView:self.view.window completion:NULL];
    
//
//    @weakself(self);
//    [self.weightView getCategorysData:^(FECategorysModel * _Nonnull modle) {
//        @strongself(weakSelf);
//        [strongSelf.weightView fitterViewHeight];
//
//        strongSelf.popupController = [[zhPopupController alloc] initWithView:strongSelf.weightView
//                                                              size:strongSelf.weightView.bounds.size];
//        strongSelf.popupController.presentationStyle = zhPopupSlideStyleFromBottom;
//        strongSelf.popupController.layoutType = zhPopupLayoutTypeBottom;
//        strongSelf.popupController.presentationTransformScale = 1.25;
//        strongSelf.popupController.dismissonTransformScale = 0.85;
//        [strongSelf.popupController showInView:strongSelf.view.window completion:NULL];
//
//
//        }];
    
}

- (IBAction)categoryAction:(id)sender {
//    [self weightAction:nil];

    
    
//    NSMutableDictionary* arg = [NSMutableDictionary dictionary];
//    @weakself(self);
//    arg[@"title"] = @"物品类型";
//    arg[@"selectedAction"] =  ^(NSDictionary * _Nonnull item) {
//        @strongself(weakSelf);
//
//        strongSelf.model.category = ((NSNumber*)item[@"code"]).intValue;
//        strongSelf.model.categoryName = item[@"name"];
//        [strongSelf freshSubViewData];
//        [strongSelf reqestCalculateFee];
//    };
//    FEBaseViewController* vc = [FFRouter routeObjectURL:@"store://storeType"
//                                         withParameters:arg];
//    [self.navigationController pushViewController:vc animated:YES];

}

- (IBAction)remarkAction:(id)sender {
    self.remarkVC.remark = self.model.remark;
    [self.navigationController pushViewController:self.remarkVC animated:YES];
}

- (IBAction)tipAction:(id)sender {

    self.popupController = [[zhPopupController alloc] initWithView:self.tipView
                                                          size:self.tipView.bounds.size];
    self.popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    self.popupController.layoutType = zhPopupLayoutTypeBottom;
    self.popupController.presentationTransformScale = 1.25;
    self.popupController.dismissonTransformScale = 0.85;
    [self.popupController showInView:self.view.window completion:NULL];
         
}

- (IBAction)submitAction:(id)sender {
    if (self.model.fromAddress.length == 0) {
        [MBProgressHUD showMessage:@"请选择店铺"];
        return;
    }
    if (self.model.toAddress.length == 0) {
        [MBProgressHUD showMessage:@"请选择收货地址"];
        return;
    }
    if (self.model.weight == 0) {
        [MBProgressHUD showMessage:@"请选择物品重量"];
        return;
    }
    if (self.model.category == 0) {
        [MBProgressHUD showMessage:@"请选择物品类型"];
        return;
    }
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    if (acc.balance < self.model.mustPay) {
        FEAlertView* alert = [[FEAlertView alloc] initWithTitle:@"温馨提示" message:@"账户余额不足，请先充值后再下单"];
        alert.firstAndSecondRatio = 0.588;
        [alert addAction:[FEAlertAction actionWithTitle:@"取消" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
            
        }]];
        [alert addAction:[FEAlertAction actionWithTitle:@"去充值" style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
            UIViewController* vc = [FFRouter routeObjectURL:@"recharge://createRechange"];
            [self.navigationController pushViewController:vc animated:YES];
        }]];
        [alert show];
        
//        账户余额不足，请先充值后再下单
        return;
    }
    NSMutableArray* tmp = [NSMutableArray array];
    for (FECreateOrderLogisticDetailsModel* item in self.model.logistics.details) {
        if (item.status == 1) {
            [tmp addObject:item.logistic];
        }
    }
    if (tmp.count == 0) {
        [MBProgressHUD showMessage:@"请选择下单平台"];
        return;
    }
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    
    param[@"toLng"] = self.model.toLng;
    param[@"toLat"] = self.model.toLat;
    param[@"cityName"] = self.model.cityName;
    param[@"fromAddress"] = self.model.fromAddress;
    param[@"toAddressDetail"] = self.model.fromAddressDetail;
    param[@"additionFee"] = @(self.model.additionFee);
    param[@"cityId"] =  @(self.model.cityId);
    param[@"storeId"] = @(self.model.storeId);
    param[@"toAddress"] = self.model.toAddress;
    param[@"toAddressDetail"] = self.model.toAddressDetail;
    param[@"toUserName"] = self.model.toUserName;
    param[@"toMobile"] =  self.model.toMobile;
    param[@"fromName"] = self.model.fromName;
    param[@"fromMobile"] = self.model.fromMobile;
    param[@"appointType"] = @(0);//   Integer    预约类型0及时单；1预约单    Y
    param[@"fromLng"] = self.model.fromLng;
    param[@"fromLat"] = self.model.fromLat;
    param[@"category"] = @(self.model.category);
    param[@"weight"] = @(self.model.weight);
    param[@"logistics"] = tmp;
    param[@"maxPrice"] = @(self.model.logistics.maxPrice);
    param[@"remarks"] = self.model.remark;
    
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
    
    FECreateOrderLogisticCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FECreateOrderLogisticCell"];
    FECreateOrderLogisticDetailsModel* item = self.model.logistics.details[indexPath.row];
    [cell setModel:item];
//    @weakself(self);
//    cell.cellCommondActoin = ^(FEOrderCommondType type) {
//        @strongself(weakSelf);
//        [strongSelf cellCommond:item type:type view:cell];
//    };
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.logistics.details.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    FECreateOrderLogisticDetailsModel* item = self.model.logistics.details[indexPath.row];
//    [FEHomeWorkCell calculationCellHeight:item];
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FECreateOrderLogisticDetailsModel* item = self.model.logistics.details[indexPath.row];
    item.status = (item.status + 1) %2;
    [self freshSubViewData];
    
}
- (FETipSettingView*) tipView {
    if (!_tipView) {
        _tipView = [[NSBundle mainBundle] loadNibNamed:@"FETipSettingView" owner:self options:nil].firstObject;
        _tipView.frame = CGRectMake(0, 0, kScreenWidth, 330 + kHomeIndicatorHeight);
        [_tipView fitterViewHeight];
        @weakself(self);
        _tipView.sureAction = ^(FETipModel*item) {
            @strongself(weakSelf);
            strongSelf.model.additionFee = item.code;
            strongSelf.tipLB.text = [NSString stringWithFormat:@"%ld",(long)item.code];
            [strongSelf.popupController dismiss];
        };
        _tipView.cancleAction = ^{
            @strongself(weakSelf);
            [strongSelf.popupController dismiss];
        };
    }
    return _tipView;
    
}
-(FEWeightSettingView*) weightView {
    if (!_weightView) {
        _weightView = [[NSBundle mainBundle] loadNibNamed:@"FEWeightSettingView" owner:self options:nil].firstObject;
        _weightView.frame = CGRectMake(0, 0, kScreenWidth, 330 + kHomeIndicatorHeight);
        _weightView.currentWeight = self.model.weight;
        @weakself(self);
//        _weightView.sureWeightAction = ^(NSInteger weight,FECategoryItemModel*item) {
        _weightView.sureWeightAction = ^(NSInteger weight) {
            @strongself(weakSelf);
            strongSelf.model.weight = weight;
            
//            strongSelf.model.category = item.code;
//            strongSelf.model.categoryName = item.name;
            
            [strongSelf freshSubViewData];
            [strongSelf reqestCalculateFee];
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
            [strongSelf updateWithStore:model];
            [strongSelf.popupController dismiss];
            [strongSelf freshSubViewData];
            [strongSelf reqestCalculateFee];
        };
        _storeView.storeManageAction = ^{
            @strongself(weakSelf);
            [strongSelf.popupController dismiss];
            FEBaseViewController* vc = [FFRouter routeObjectURL:@"store://createStoreManager"];
            [strongSelf.navigationController pushViewController:vc animated:YES];
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
            strongSelf.remarkLB.text = remark;
        };
    }
    return _remarkVC;
}

- (FECreateOrderReciveAddressInfoVC*) reciveAddressInfoVC {
    if (!_reciveAddressInfoVC) {
        _reciveAddressInfoVC = [[FECreateOrderReciveAddressInfoVC alloc] initWithNibName:@"FECreateOrderReciveAddressInfoVC" bundle:nil];
        _reciveAddressInfoVC.model.address = self.model.toAddress;
        _reciveAddressInfoVC.model.addressDetail = self.model.toAddressDetail;
        _reciveAddressInfoVC.model.name = self.model.toUserName;
        _reciveAddressInfoVC.model.mobile = self.model.toMobile;
        _reciveAddressInfoVC.model.longitude = self.model.toLng;
        _reciveAddressInfoVC.model.latitude = self.model.toLat;
        
        _reciveAddressInfoVC.model.cityId = self.model.cityId;
        _reciveAddressInfoVC.model.cityName = self.model.cityName;
        
        @weakself(self);
        _reciveAddressInfoVC.infoComplate = ^(FEReciverAddressModel * _Nonnull model) {
            @strongself(weakSelf);
            strongSelf.model.toAddress = model.address;
            strongSelf.model.toAddressDetail = model.addressDetail;
            strongSelf.model.toUserName = model.name;
            strongSelf.model.toMobile = model.mobile;
            strongSelf.model.toLng = model.longitude;
            strongSelf.model.toLat = model.latitude;
            
            [strongSelf freshSubViewData];
            [strongSelf reqestCalculateFee];
        };
    }
    return _reciveAddressInfoVC;
}

- (void) reqestCalculateFee {
    if (self.model.toAddress.length == 0 ||
        self.model.storeId == 0 ||
        self.model.fromAddress.length == 0 ||
        self.model.toUserName.length == 0 ||
        self.model.toMobile.length == 0 ||
        self.model.weight == 0) {
        return;
    }
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"toLng"] = self.model.toLng;//@(self.model.toLng.floatValue);
    param[@"toLat"] = self.model.toLat;//@(self.model.toLat.floatValue);
    param[@"cityName"] = [FEPublicMethods SafeString:self.model.cityName];
    param[@"fromAddress"] = self.model.fromAddress;
    param[@"additionFee"] = @(self.model.additionFee);
    param[@"cityId"] = @(self.model.cityId);
    param[@"storeId"] = @(self.model.storeId);
    param[@"toAddress"] = self.model.toAddress;
    param[@"toAddressDetail"] = self.model.toAddressDetail;
    param[@"toUserName"] = self.model.toUserName;
    param[@"toMobile"] = self.model.toMobile;
    param[@"fromName"] = self.model.fromName;
    param[@"fromMobile"] = self.model.fromMobile;
    param[@"appointType"] = @(self.model.appointType);
    param[@"fromLng"] = self.model.fromLng;//@(self.model.fromLng.floatValue);
    param[@"fromLat"] = self.model.fromLat;//@(self.model.fromLat.floatValue);
    param[@"category"] = @(self.model.category);
    param[@"weight"] = @(self.model.weight);
    param[@"logistics"] = @[@"uupt",@"fengka",@"mtps",@"dada",@"bingex",@"shunfeng"];
    
    @weakself(self);
    [[FEHttpManager defaultClient] POST:@"/deer/orders/calculateFee" parameters:param
                                success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        NSDictionary* data = response[@"data"];
        FECreateOrderLogisticModel* model = strongSelf.model.logistics;
        strongSelf.model.logistics = [FECreateOrderLogisticModel yy_modelWithDictionary:data];
        
        [strongSelf.model.logistics.details enumerateObjectsUsingBlock:
         ^(FECreateOrderLogisticDetailsModel * item, NSUInteger idxItem, BOOL * stopItem) {
            
            [model.details enumerateObjectsUsingBlock:
             ^(FECreateOrderLogisticDetailsModel * obj, NSUInteger idxObj, BOOL * stopObj) {
                if ([item.logistic isEqualToString:obj.logistic]) {
                    item.status = obj.status;
                    *stopObj = YES;
                }
            }];
            if(!model && [item.logisticName isEqualToString:strongSelf.model.logistics.minLogistic]){
                item.status = 1;
            }
        }];
        
        [strongSelf freshSubView];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        @strongself(weakSelf);
        strongSelf.model.logistics = nil;
        [strongSelf freshSubView];
    } cancle:^{
    
    }];
    
}


@end
