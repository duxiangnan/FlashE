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
//@property (nonatomic,assign) NSInteger cityCode;
@property (copy, nonatomic) NSString *defaultName;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UITextField *detailTF;
@property (weak, nonatomic) IBOutlet UITextField *reciveUserTF;
@property (weak, nonatomic) IBOutlet UITextField *reciveMobileTF;
@property (weak, nonatomic) IBOutlet UITextField *reciveMobilePartTF;

@end

@implementation FECreateOrderReciveAddressInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"收件信息";
    self.defaultName = @"收件地址(必填)";
    self.fd_prefersNavigationBarHidden = NO;
    [self freshSubViewUseModel];
    [self fillNameLB:self.model.address];
}
- (void) fillNameLB:(NSString*)name {
    if(name.length == 0 || [name isEqualToString:self.defaultName]) {
        self.nameLB.text = self.defaultName;
        self.nameLB.textColor = UIColorFromRGB(0xC7C7C7);
    } else {
        self.nameLB.text = name;
        self.nameLB.textColor = UIColorFromRGB(0x333333);
    }
}
- (IBAction)nameAction:(id)sender {
    NSMutableDictionary* arg = [NSMutableDictionary dictionary];
    @weakself(self);
    arg[@"selectedAction"] = ^(FEAddressModel*model) {
        @strongself(weakSelf);
        strongSelf.item = model;
        strongSelf.model.address = model.name;
        [strongSelf fillNameLB:strongSelf.model.address];
//        if (strongSelf.detailTF.text.length == 0) {
//            strongSelf.model.addressDetail = model.address;
//            strongSelf.detailTF.text = strongSelf.model.addressDetail;
//        }
        strongSelf.model.longitude = model.longitude;
        strongSelf.model.latitude = model.latitude;
        
        [strongSelf.navigationController popToViewController:strongSelf animated:YES];
        
    };

    arg[@"defaultCityid"] = @(self.model.cityId);
    arg[@"defaultCityName"] = self.model.cityName;
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
    if (self.reciveMobilePartTF.text.length > 0) {
        self.model.mobile = [self.model.mobile stringByAppendingFormat:@"-%@",self.reciveMobilePartTF.text];
    }
    
    !self.infoComplate?:self.infoComplate(self.model);
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (FEReciverAddressModel*)model {
    if (!_model) {
        _model = [FEReciverAddressModel new];
    }
    return _model;
}

- (void) textChange:(NSNotification*) noti {
    UITextField* text = noti.object;

//    if (text == self.reciveMobileTF && text.text.length > 11) {
//        text.text = [text.text substringToIndex:11];
//    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    return YES;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.reciveMobileTF && textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
 
    if ([string isEqualToString:@"\n"]){
        [textField resignFirstResponder];
        return NO;
    }
     if ([[textField.textInputMode primaryLanguage] isEqualToString:@"emoji"] ||
         [textField.textInputMode primaryLanguage] == nil) {
         return NO;
    }
    
    if (textField == self.reciveMobileTF) {
        return [FEPublicMethods limitTextField:textField replacementText:string max:11 ];
    }
    return YES;
}




- (void) freshSubViewUseModel {
    [self fillNameLB:self.model.address];
//    self.nameLB.text = [FEPublicMethods SafeString:self.model.address withDefault:@""];
    self.detailTF.text = [FEPublicMethods SafeString:self.model.addressDetail];
    self.reciveUserTF.text = [FEPublicMethods SafeString:self.model.name];
    
    NSArray* arr = [self.model.mobile componentsSeparatedByString:@"-"];
    self.reciveMobileTF.text = [FEPublicMethods SafeString:arr.firstObject];
    if (arr.count > 1) {
        self.reciveMobilePartTF.text = [FEPublicMethods SafeString:arr.lastObject];
    }
    
}
@end
