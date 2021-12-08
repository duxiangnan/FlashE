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
#import "FEHomeWorkModel.h"

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
    self.distanceLB.text = [NSString stringWithFormat:@"%f公里",model.distance];
    self.amountLB.attributedText = nil;
    [self.amountLB appendAttriString:@"优惠价" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:10]];
    [self.amountLB appendAttriString:[NSString stringWithFormat:@"%f",model.realAmount - model.coupon] color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:20]];
    [self.amountLB appendAttriString:@"元" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:10]];
    
    self.realAmountLB.attributedText = nil;
    [self.realAmountLB appendUnderLineAttriString:@"原价" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:10]];
    [self.realAmountLB appendUnderLineAttriString:[NSString stringWithFormat:@"%f",model.amount] color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:20]];
    [self.realAmountLB appendUnderLineAttriString:@"元" color:UIColorFromRGB(0x333333) font:[UIFont systemFontOfSize:10]];
    
    
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
@property (weak, nonatomic) IBOutlet UILabel *catagroyLB;
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
    [self.platformTable registerClass:[FECreateOrderLogisticCell class] forCellReuseIdentifier:@"FECreateOrderLogisticCell"];
    if(!self.model) {
        self.model = [FECreateOrderModel new];
    }
    [self freshSubView];
    
}

- (void) freshSubView {
    self.addressViewT.constant = 10;
    self.addressViewH.constant = 140;
    
    self.infoViewT.constant = 10;
    self.infoViewH.constant = 180;
    
    
    
    self.bottomViewT.constant = 10;
    self.bottomViewH.constant = 10 + 48 + 10 + kHomeIndicatorHeight;
    
    CGFloat height = self.addressViewT.constant + self.addressViewH.constant +
    self.infoViewT.constant + self.infoViewH.constant +
    self.platformViewT.constant + self.platformViewH.constant +
    self.platformTipViewT.constant + self.platformTipViewH.constant +
    self.bottomViewT.constant + self.bottomViewH.constant;
    if (height < kScreenHeight - kHomeNavigationHeight) {
        self.scroll.scrollEnabled = NO;
        height = kScreenHeight - kHomeNavigationHeight;
    }else {
        self.scroll.scrollEnabled = YES;
    }
    self.scroll.contentSize = CGSizeMake(kScreenWidth, height);
    
    [self freshSubViewData];
}
- (void) freshSubViewData {
    
    if ( self.model.logistics.details.count > 0) {
        self.platformViewT.constant = 10;
        self.platformViewH.constant = 60 + self.model.logistics.details.count*60;
        
        self.platformTipViewT.constant = 10;
        self.platformTipViewH.constant = 130;
        
    } else {
        self.platformViewT.constant = 0;
        self.platformViewH.constant = 0;
        
        self.platformTipViewT.constant = 0;
        self.platformTipViewH.constant = 0;
    }
    
    UIColor* emptyColor = UIColorFromRGB(0x777777);
    UIColor* filledColor = UIColorFromRGB(0x333333);
    self.addressFromTitleLB.text = [FEPublicMethods SafeString:self.model.fromName withDefault:@"请选择店铺"];
    self.addressFromDescLB.text = [FEPublicMethods SafeString:self.model.fromName withDefault:@"请选择店铺地址"];
    
    NSString* tmp = [NSString stringWithFormat:@"%@%@",[FEPublicMethods SafeString:self.model.toAddress],[FEPublicMethods SafeString:self.model.toAddressDetail]];
    self.addressToTitleLB.text = [FEPublicMethods SafeString:tmp withDefault:@"请选择店铺"];
    tmp = [FEPublicMethods SafeString:self.model.toUserName];
    if (self.model.toMobile.length > 0) {
        tmp = [tmp stringByAppendingFormat:@" %@",self.model.toMobile];
    }
    self.addressToDescLB.text = [FEPublicMethods SafeString:tmp withDefault:@"收件人"];
    
    
    self.catagroyLB.text = [FEPublicMethods SafeString:self.model.categoryName withDefault:@"选择类型"];
    self.catagroyLB.textColor = self.model.category<=0?emptyColor:filledColor;

    if (self.model.weight<=0) {
        self.weightLB.text = @"选择重量";
        self.weightLB.textColor = emptyColor;
    } else {
        self.weightLB.text = [NSString stringWithFormat:@"%ld公斤",self.model.weight];
        self.weightLB.textColor = filledColor;
    }

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
    if (amount > 0) {
        self.submitInfoLB.text = [NSString stringWithFormat:@"需支付最高金额%f元",amount + self.model.accessibilityTraits];
    } else {
        self.submitInfoLB.text = @"";
    }
    [self.platformTable reloadData];
    
}

- (void)setOrderDetailModel:(FEOrderDetailModel *)orderDetailModel {
    _orderDetailModel = orderDetailModel;
    if(!self.model) {
        self.model = [FECreateOrderModel new];
    }

    self.model.appointType = orderDetailModel.appointType;
    self.model.appointDate = orderDetailModel.appointDate;
//    self.model.categoryName = orderDetailModel.goodName;
    self.model.weight = orderDetailModel.weight;
    

    self.model.storeId = orderDetailModel.storeId.integerValue;
//    self.model.cityId = orderDetailModel.;//城市ID
//    @property (nonatomic, copy) NSString* cityName;//城市名称

    self.model.toAddress = orderDetailModel.toAdress;
    self.model.toAddressDetail = orderDetailModel.toAdressDetail;
    self.model.toUserName = orderDetailModel.toUserName;
    self.model.toMobile = orderDetailModel.toUserMobile;
    self.model.toLng = orderDetailModel.toLongitude.doubleValue;
    self.model.toLat = orderDetailModel.toLatitude.doubleValue;
    self.model.additionFee = orderDetailModel.tipAmount;//小费

    
    self.model.fromLng = orderDetailModel.fromLongitude.doubleValue;
    self.model.fromLat = orderDetailModel.fromLatitude.doubleValue;
    self.model.fromAddress = orderDetailModel.fromAddress;
//    self.model.fromName = orderDetailModel.;//下单人
//    self.model.fromMobile = orderDetailModel.;//下单人手机号


//    self.model.category = orderDetailModel.;//物品类型
//    self.model.categoryName = orderDetailModel.;//物品类型名称
    
    self.model.remark = orderDetailModel.remark;//备注
//    self.model.logistics = orderDetailModel.logistic;//选择下单平台
    
    
    
    
}
- (void)setOrderListModel:(FEHomeWorkOrderModel *)orderListModel {
    _orderListModel = orderListModel;
    if(!self.model) {
        self.model = [FECreateOrderModel new];
    }
    
//    
//    self.model.appointType = orderListModel.appointType;
//    self.model.appointDate = orderListModel.appointDate;
////    self.model.categoryName = orderListModel.goodName;
//    self.model.weight = orderListModel.weight;
//    
//
//    self.model.storeId = orderListModel.storeId.integerValue;
////    self.model.cityId = orderListModel.;//城市ID
////    @property (nonatomic, copy) NSString* cityName;//城市名称
//
//    self.model.toAddress = orderListModel.toAdress;
//    self.model.toAddressDetail = orderListModel.toAdressDetail;
//    self.model.toUserName = orderListModel.toUserName;
//    self.model.toMobile = orderListModel.toUserMobile;
//    self.model.toLng = orderListModel.toLongitude.doubleValue;
//    self.model.toLat = orderListModel.toLatitude.doubleValue;
//    self.model.additionFee = orderListModel.tipAmount;//小费
//
//    
//    self.model.fromLng = orderListModel.fromLongitude.doubleValue;
//    self.model.fromLat = orderListModel.fromLatitude.doubleValue;
//    self.model.fromAddress = orderListModel.fromAddress;
////    self.model.fromName = orderListModel.;//下单人
////    self.model.fromMobile = orderListModel.;//下单人手机号
//
//
////    self.model.category = orderListModel.;//物品类型
////    self.model.categoryName = orderListModel.;//物品类型名称
//    
//    self.model.remark = orderListModel.remark;//备注
////    self.model.logistics = orderDetailModel.logistic;//选择下单平台
//    
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

- (IBAction)categoryAction:(id)sender {
    
    NSMutableDictionary* arg = [NSMutableDictionary dictionary];
    @weakself(self);
    arg[@"title"] = @"物品类型";
    arg[@"selectedAction"] =  ^(NSDictionary * _Nonnull item) {
        @strongself(weakSelf);
        
        strongSelf.model.category = ((NSNumber*)item[@"code"]).intValue;
        strongSelf.model.categoryName = item[@"name"];
        [strongSelf freshSubViewData];
        [strongSelf reqestCalculateFee];
    };
    FEBaseViewController* vc = [FFRouter routeObjectURL:@"store://storeType"
                                         withParameters:arg];
    [self.navigationController pushViewController:vc animated:YES];

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
    param[@"toAddressDetail"] = self.model.fromAddressDetail;
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
    for (FECreateOrderLogisticDetailsModel* item in self.model.logistics.details) {
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
            strongSelf.model.fromLat = model.latitude.doubleValue;
            strongSelf.model.fromLng = model.longitude.doubleValue;
            strongSelf.model.fromAddress = model.address;
            strongSelf.model.fromAddressDetail = model.addressDetail;
            strongSelf.model.fromName = model.name;
            strongSelf.model.fromMobile = model.mobile;
            strongSelf.model.cityId = model.cityId;
            strongSelf.model.cityName = model.cityName;
//            strongSelf.model.category = model.category;
//            strongSelf.model.categoryName = model.categoryName;
            strongSelf.model.storeId = model.shopId;
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
        @weakself(self);
        _reciveAddressInfoVC.infoComplate = ^(FEReciverAddressModel * _Nonnull model) {
            @strongself(weakSelf);
            strongSelf.model.toAddress = model.address;
            strongSelf.model.toAddressDetail = model.addressDetail;
            strongSelf.model.toUserName = model.name;
            strongSelf.model.toMobile = model.mobile;
            strongSelf.model.toLng = model.longitude.doubleValue;
            strongSelf.model.toLat = model.latitude.doubleValue;
            
            [strongSelf freshSubViewData];
            [strongSelf reqestCalculateFee];
        };
    }
    return _reciveAddressInfoVC;
}

- (void) reqestCalculateFee {
    if (self.model.toAddress.length == 0 ||
        self.model.cityId == 0 ||
        self.model.storeId == 0 ||
        self.model.fromAddress.length == 0 ||
        self.model.toUserName.length == 0 ||
        self.model.toMobile.length == 0 ) {
        return;
    }
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"toLng"] = @(self.model.toLat);
    param[@"toLat"] = @(self.model.toLat);
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
    param[@"fromLng"] = @(self.model.fromLng);
    param[@"fromLat"] = @(self.model.fromLat);
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
        }];
        [strongSelf freshSubViewData];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
    
    } cancle:^{
    
    }];
    
}

@end
