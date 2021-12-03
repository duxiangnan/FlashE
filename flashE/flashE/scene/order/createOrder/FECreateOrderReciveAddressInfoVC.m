//
//  FECreateOrderReciveAddressInfoVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FECreateOrderReciveAddressInfoVC.h"
#import "FEDefineModule.h"
#import "FEAddressModel.h"
#import "FEStoreCityModel.h"

@interface FECreateOrderReciveAddressInfoVC ()

@property (nonatomic,strong) FEAddressModel* item;
@property (nonatomic,assign) NSInteger cityCode;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UITextField *detailTF;
@property (weak, nonatomic) IBOutlet UITextField *reciveUserTF;
@property (weak, nonatomic) IBOutlet UITextField *reciveMobileTF;

@end

@implementation FECreateOrderReciveAddressInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收件信息";
    self.fd_prefersNavigationBarHidden = NO;
    [self fillNameLB:@""];
}
- (void) fillNameLB:(NSString*)name {
    if(name.length == 0) {
        self.nameLB.text = @"请选择收件地址";
        self.nameLB.textColor = UIColorFromRGB(0x777777);
    } else {
        self.nameLB.text = name;
        self.nameLB.textColor = UIColorFromRGB(0x333333);
    }
}
- (IBAction)nameAction:(id)sender {
    NSMutableDictionary* arg = [NSMutableDictionary dictionary];
    @weakself(self);
    arg[@"selectedAction"] = ^(FEAddressModel * _Nonnull model , FEStoreCityItemModel* city) {
        @strongself(weakSelf);
        strongSelf.item = model;
        strongSelf.cityCode = city.ID;
        
        strongSelf.model.address = model.name;
        strongSelf.model.cityId = strongSelf.cityCode;
        strongSelf.model.cityName = model.cityname;
        strongSelf.model.longitude = model.longitude;
        strongSelf.model.latitude = model.latitude;
        [strongSelf fillNameLB:model.name];
        
    };
    FEBaseViewController* vc = [FFRouter routeObjectURL:@"store://createSearchAddress" withParameters:arg];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)submitAcion:(id)sender {
    if (self.model.address.length == 0) {
        [MBProgressHUD showMessage:@"请选择收件地址"];
        return;
    }
    if (self.detailTF.text.length == 0) {
        [MBProgressHUD showMessage:@"请输入详细地址"];
        return;
    }
    if (self.reciveUserTF.text.length == 0) {
        [MBProgressHUD showMessage:@"请输入收件人"];
        return;
    }
    if (self.reciveMobileTF.text.length == 0) {
        [MBProgressHUD showMessage:@"请输入联系方式"];
        return;
    }
    self.model.addressDetail = self.detailTF.text;
    self.model.name = self.reciveUserTF.text;
    self.model.mobile = self.reciveMobileTF.text;
    
    !self.infoComplate?:self.infoComplate(self.model);
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (FEReciverAddressModel*)model {
    if (!_model) {
        _model = [FEReciverAddressModel new];
    }
    return _model;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view endEditing:YES];
    
}
@end
