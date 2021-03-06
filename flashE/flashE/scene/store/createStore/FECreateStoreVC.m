//
//  FECreateStoreVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/18.
//

#import "FECreateStoreVC.h"
#import "FEDefineModule.h"
#import "FEStorePartModel.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <TZImagePickerController/TZImagePickerController.h>
#import <zhPopupController/zhPopupController.h>
#import "FESearchAddressVC.h"

#import "FEStoreCityModel.h"
#import "FEStoreDetailModel.h"
#import "FECategorySettingView.h"
#import "FECategorysModel.h"

#import "FESearchCityVC.h"


@interface FECreateStoreVC ()
@property (nonatomic, strong) NSString* defaultName;
@property (nonatomic, strong) NSString* defaultType;

@property (nonatomic, strong) FEStorePartModel* inputModel;

@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;

//cell0
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell0T;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* cell0H;

@property (nonatomic, weak) IBOutlet UITextField* dianNameTF;

@property (nonatomic, weak) IBOutlet UILabel* dianNameLB;

@property (nonatomic, weak) IBOutlet UITextField* dianDetailLB;

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

@property (nonatomic, strong) NSURLSessionDataTask* submitTask;
@property (nonatomic, assign) NSInteger btnType;//??????????????????


@property (nonatomic,strong) zhPopupController* popupController;
@property (nonatomic,strong) FECategorySettingView* categorySettingView;

@end

@implementation FECreateStoreVC
+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
    
        [FFRouter registerObjectRouteURL:@"store://createStore" handler:^id(NSDictionary *routerParameters) {
            FECreateStoreVC* vc = [[FECreateStoreVC alloc] initWithNibName:@"FECreateStoreVC" bundle:nil];
            vc.createComplate = routerParameters[@"createComplate"];
            vc.model = routerParameters[@"model"];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.defaultName = @"????????????????????????";
    self.defaultType = @"??????????????????";
    if(!self.inputModel){
        self.inputModel = [[FEStorePartModel alloc] init];
        self.inputModel.defaultStore = self.defaultAddressSw.on?1:0;
        
    }
    self.btnType = -1;
    self.fd_prefersNavigationBarHidden = NO;
    self.title = @"????????????";
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.dianNameTF.text = [FEPublicMethods SafeString:self.inputModel.name];
    self.dianNameLB.text = [FEPublicMethods SafeString:self.inputModel.address withDefault:self.defaultName];
    self.dianDetailLB.text = [FEPublicMethods SafeString:self.inputModel.addressDetail];
    self.dianTypeLB.text = [FEPublicMethods SafeString:self.inputModel.categoryName withDefault:self.defaultType];
    self.dianPhoneTF.text = [FEPublicMethods SafeString:self.inputModel.mobile];
    [self freshViewColor];
    //    [self.zhengZMBtn setImage:[] forState:(UIControlState)];
    //    self.zhengFMBtn;
    //    self.yingyeBtn;
    //    self.dianBtn;
    self.defaultAddressSw.on = self.inputModel.defaultStore==1;
    
    CGFloat width = (kScreenWidth - 10*2 - 16*2 - 10)/2;
    CGFloat btnH = 106.0/156*width;
    self.cell1H.constant = 16+20+16+btnH+16;
    self.cell2H.constant = self.cell1H.constant;
    
    self.cell1T.constant = 0;
    self.cell1H.constant = 0;
    self.cell2T.constant = 0;
    self.cell2H.constant = 0;
    
    CGFloat height = self.cell0T.constant + self.cell0H.constant +
    self.cell1T.constant + self.cell1H.constant +
    self.cell2T.constant + self.cell2H.constant +
    self.cell3T.constant + self.cell3H.constant +
    self.cell4T.constant + self.cell4H.constant + 20 + kHomeIndicatorHeight;
    
    height = MAX(kScreenHeight-kHomeNavigationHeight-kHomeIndicatorHeight, height);
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, height);
    
    
}
//-(void) resetLbColor:(UILabel*)lb {
//    UIColor* emptyC = UIColorFromRGB(0x777777);
//    UIColor* defaultC = UIColorFromRGB(0x333333);
//    if (lb == self.dianNameLB) {
//        lb.textColor = self.inputModel.address.length>0?defaultC:emptyC;
//    } else if (lb == self.dianTypeLB) {
//        lb.textColor = self.inputModel.category>0?defaultC:emptyC;
//    }
//    
//}
- (void) freshViewColor {
    if (self.dianNameLB.text.length == 0 || [self.dianNameLB.text isEqualToString:self.defaultName]) {
        self.dianNameLB.textColor = UIColorFromRGB(0xC7C7C7);
    } else {
        self.dianNameLB.textColor = UIColorFromRGB(0x333333);
    }

    if (self.dianTypeLB.text.length == 0 || [self.dianTypeLB.text isEqualToString:self.defaultType]) {
        self.dianTypeLB.textColor = UIColorFromRGB(0xC7C7C7);
    } else {
        self.dianTypeLB.textColor = UIColorFromRGB(0x333333);
    }

}
- (void)dealloc
{
    [self.submitTask cancel];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setModel:(FEStoreDetailModel *)model {
    _model = model;
    if (!model) {
        return;
    }
    if (!self.inputModel) {
        self.inputModel = [FEStorePartModel new];
    }
    self.inputModel.ID = model.ID;
    self.inputModel.category = model.category;
    self.inputModel.categoryName = model.categoryName;
    self.inputModel.cityName = model.cityName;
    self.inputModel.mobile = model.mobile;
    self.inputModel.longitude = model.longitude;
    self.inputModel.latitude = model.latitude;
    self.inputModel.defaultStore = model.defaultStore;
    self.inputModel.addressDetail = model.addressDetail;
    self.inputModel.address = model.address;
    self.inputModel.reverseIdcard = model.reverseIdcard;
    self.inputModel.businessLicense = model.businessLicense;
    self.inputModel.shopId = model.shopId;
    self.inputModel.facade = model.facade;
    self.inputModel.cityId = model.cityId;
    self.inputModel.name = model.name;
    self.inputModel.frontIdcard = model.frontIdcard;

 
}



- (IBAction)dianNameAction:(id)sender {
    [self.view endEditing:YES];
    [self gotoSearchAddress];
}
//- (IBAction)dianDetailAction:(id)sender {
//    [self.view endEditing:YES];
//    [self gotoSearchAddress];
//}

- (IBAction)dianTypeAction:(id)sender {
    [self.view endEditing:YES];
    [self showInputType];
}
- (IBAction)zhengZMAction:(id)sender {
    [self.view endEditing:YES];
    self.btnType = 0;
    [self selectPhotoAction:self.zhengZMBtn];
}
- (IBAction)zhengFMAction:(id)sender {
    [self.view endEditing:YES];
    self.btnType = 1;
    [self selectPhotoAction:self.zhengFMBtn];
}
- (IBAction)yingyeAction:(id)sender {
    [self.view endEditing:YES];
    self.btnType = 2;
    [self selectPhotoAction:self.yingyeBtn];
}
- (IBAction)dianAction:(id)sender {
    [self.view endEditing:YES];
    self.btnType = 3;
    [self selectPhotoAction:self.dianBtn];
}
- (IBAction)switchChange:(id)sender {
    self.inputModel.defaultStore = self.defaultAddressSw.on?1:0;
}


- (IBAction)submintAction:(id)sender {
    [self.view endEditing:YES];
    if (self.inputModel.name.length ==0) {
        [MBProgressHUD showMessage:@"?????????????????????"];
        return;
    }
    if (self.inputModel.address.length == 0 ) {
        [MBProgressHUD showMessage:@"?????????????????????"];
        return;
    }
    if (self.inputModel.category == 0 ) {
        [MBProgressHUD showMessage:@"???????????????????????????"];
        return;
    }
    if (self.inputModel.mobile.length == 0 ) {
        [MBProgressHUD showMessage:@"??????????????????????????????"];
        return;
    }
//    if (self.inputModel.frontIdcard.length == 0 || self.inputModel.reverseIdcard.length == 0 ) {
//        [MBProgressHUD showMessage:@"????????????????????????"];
//        return;
//    }
//    if (self.inputModel.facade.length == 0 || self.inputModel.businessLicense.length == 0  ) {
//        [MBProgressHUD showMessage:@"??????????????????????????????????????????"];
//        return;
//    }
    
    FEAlertView* alert = [[FEAlertView alloc] initWithTitle:@"????????????" message:@"???????????????????????????????????????????????????????????????????????????????????????"];
    alert.firstAndSecondRatio = 0.588;
    [alert addAction:[FEAlertAction actionWithTitle:@"??????" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
        
    }]];
    [alert addAction:[FEAlertAction actionWithTitle:@"????????????" style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
        [self submitRequest];
    }]];
    [alert show];
    
    
}
    
- (void) gotoSearchAddress{
    
    
    FESearchCityVC* vc = [[FESearchCityVC alloc] initWithNibName:@"FESearchCityVC" bundle:nil];
    @weakself(self);
    vc.selectedAction = ^(FEStoreCityItemModel*city, FEAddressModel* model) {
        @strongself(weakSelf);
        strongSelf.dianNameLB.text = model.address;
        strongSelf.inputModel.address = model.address;
        strongSelf.inputModel.longitude = model.longitude;
        strongSelf.inputModel.latitude = model.latitude;
        strongSelf.inputModel.cityName = city.name;
        strongSelf.inputModel.cityId = city.ID;
        [strongSelf freshViewColor];
        [strongSelf.navigationController popToViewController:strongSelf animated:YES];
        
    };
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
//    NSMutableDictionary* arg = [NSMutableDictionary dictionary];
//    @weakself(self);
//    arg[@"selectedAction"] = ^(FEAddressModel * _Nonnull model , FEStoreCityItemModel* city,BOOL ignorCity) {
//        @strongself(weakSelf);
//        if(model.name.length > 0 && model.address.length>0){
//            strongSelf.dianNameLB.text = model.name;
//            strongSelf.inputModel.address = model.name;
//            if (strongSelf.dianDetailLB.text.length == 0) {
//                strongSelf.dianDetailLB.text = model.address;
//                strongSelf.inputModel.addressDetail = model.address;
//            }
//            strongSelf.inputModel.longitude = model.longitude;
//            strongSelf.inputModel.latitude = model.latitude;
//            strongSelf.inputModel.cityName = model.cityname;
//            strongSelf.inputModel.cityId = city.ID;
//            [strongSelf freshViewColor];
//        }
//
//    };
//    FEBaseViewController* vc = [FFRouter routeObjectURL:@"store://createSearchAddress" withParameters:arg];
//    [self.navigationController pushViewController:vc animated:YES];

}


- (void) showInputType {
    @weakself(self);
    [self.categorySettingView getCategorysData:^(FECategorysModel * _Nonnull modle) {
        @strongself(weakSelf);
        [strongSelf.categorySettingView fitterViewHeight];

        strongSelf.popupController = [[zhPopupController alloc] initWithView:strongSelf.categorySettingView
                                                              size:strongSelf.categorySettingView.bounds.size];
        strongSelf.popupController.presentationStyle = zhPopupSlideStyleFromBottom;
        strongSelf.popupController.layoutType = zhPopupLayoutTypeBottom;
        strongSelf.popupController.presentationTransformScale = 1.25;
        strongSelf.popupController.dismissonTransformScale = 0.85;
        [strongSelf.popupController showInView:strongSelf.view.window completion:NULL];


        }];
    
    
//    NSMutableDictionary* arg = [NSMutableDictionary dictionary];
//    @weakself(self);
//    arg[@"selectedAction"] =  ^(NSDictionary * _Nonnull item) {
//        @strongself(weakSelf);
//        strongSelf.inputModel.category = ((NSNumber*)item[@"code"]).intValue;
//        strongSelf.dianTypeLB.text = item[@"name"];
//        strongSelf.dianTypeLB.textColor = UIColorFromRGB(0x333333);
//    };
//    FEBaseViewController* vc = [FFRouter routeObjectURL:@"store://storeType"
//                                         withParameters:arg];
//    [self.navigationController pushViewController:vc animated:YES];
}




- (void) submitRequest {
    
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];

    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    if (self.model) {
        param[@"id"] = @(self.inputModel.ID);
        param[@"shopId"] = @(self.inputModel.shopId);
        param[@"thirdStoreId"] = self.model.thirdStoreId;
        param[@"bdCode"] = self.model.bdCode;
        param[@"frontIdcard"] = self.inputModel.frontIdcard;
        param[@"reverseIdcard"] = self.inputModel.reverseIdcard;
        param[@"businessLicense"] = self.inputModel.businessLicense;
        param[@"facade"] = self.inputModel.facade;
    }
    param[@"name"] = self.inputModel.name;
    param[@"userId"] = @(acc.ID);
    param[@"cityId"] = @(self.inputModel.cityId);
    param[@"cityName"] = self.inputModel.cityName;
    param[@"address"] = self.inputModel.address;
    param[@"addressDetail"] = self.dianDetailLB.text;
    param[@"latitude"] = self.inputModel.latitude;
    param[@"longitude"] = self.inputModel.longitude;
    param[@"mobile"] = self.inputModel.mobile;
    param[@"category"] = @(self.inputModel.category);
    param[@"defaultStore"] = @(self.inputModel.defaultStore);
   
    [MBProgressHUD showProgressOnView:self.view];
    NSString* fouction = nil;
    @weakself(self);
    if (self.model) {
        fouction = @"/deer/store/modifyStoreById";
    } else {
        fouction = @"/deer/store/addStore";
        if (acc.storeId == 0) {
            fouction = @"/deer/shop/register";
        } else {
            param[@"shopId"] = @(acc.shopId);
        }
        
    }
    self.submitTask = [[FEHttpManager defaultClient] POST:fouction
                                               parameters:param
      success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        
        if (acc.storeId == 0) {
            [FFRouter routeURL:@"deckControl://updateAccount"];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FEUpdateStore" object:nil];
        }
        [MBProgressHUD hideProgressOnView:strongSelf.view];
        
        !strongSelf.createComplate?:strongSelf.createComplate();
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        @strongself(weakSelf);
        [MBProgressHUD hideProgressOnView:strongSelf.view];
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        @strongself(weakSelf);
        [MBProgressHUD hideProgressOnView:strongSelf.view];
    }];

}
- (void) uploadImageToServer:(UIImage*)image {
    
}


#pragma mark -- ?????????
- (FECategorySettingView*) categorySettingView{
    
    if (!_categorySettingView) {
        _categorySettingView = [[NSBundle mainBundle] loadNibNamed:@"FECategorySettingView" owner:self options:nil].firstObject;
        _categorySettingView.frame = CGRectMake(0, 0, kScreenWidth, 330 + kHomeIndicatorHeight);
        [_categorySettingView setDetaultCategory:self.model.category name:self.model.categoryName];
        @weakself(self);
        _categorySettingView.sureWeightAction = ^(FECategoryItemModel*item) {
    
            @strongself(weakSelf);
            strongSelf.inputModel.category = item.code;
            strongSelf.inputModel.categoryName = item.name;
            strongSelf.dianTypeLB.text = item.name;
            [strongSelf.popupController dismiss];
            [strongSelf freshViewColor];
        };
        _categorySettingView.cancleAction = ^{
            @strongself(weakSelf);
            [strongSelf.popupController dismiss];
        };
    }
    return _categorySettingView;
}

#pragma mark -- UITextField delegate

- (void) textChange:(NSNotification*) noti {
    UITextField* text = noti.object;

    if (text == self.dianNameTF) {
//        self.dianNameTF.text = text.text;
        self.inputModel.name = text.text;
    } else if (text == self.dianPhoneTF) {
//        self.dianPhoneTF.text = text.text;
        self.inputModel.mobile = text.text;
    } else if (text == self.dianDetailLB) {
//        self.dianDetailLB.text = text.text;
        self.inputModel.addressDetail = text.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    return YES;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.dianNameTF && textField.text.length > 50) {
        textField.text = [textField.text substringToIndex:50];
    } else if (textField == self.dianPhoneTF && textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
    self.inputModel.name = self.dianNameTF.text;
    self.inputModel.mobile = self.dianPhoneTF.text;
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
    
    if (textField == self.dianNameTF) {
        return [FEPublicMethods limitTextField:textField replacementText:string max:50 ];
    }
    if (textField == self.dianPhoneTF) {
        return [FEPublicMethods limitTextField:textField replacementText:string max:11];
    }
    
    return YES;
    
}



#pragma mark ---????????????
- (void)selectPhotoAction:(UIView*)view {
    UIAlertController* actionView = [UIAlertController alertControllerWithTitle:nil
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [actionView addAction:[UIAlertAction actionWithTitle:@"??????"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *_Nonnull action) {}]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"??????"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self checkCamera];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"??????"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self checkPhoto];
    }]];
    if (actionView.popoverPresentationController) {

        UIPopoverPresentationController *popover = actionView.popoverPresentationController;
        popover.sourceView = view;
        popover.sourceRect = CGRectMake(0,CGRectGetHeight(view.frame)/2,0,0);
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:actionView animated:YES completion:nil];
}

// ??????????????????
- (void)checkCamera {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (authStatus == AVAuthorizationStatusAuthorized) {
        [self callCamera];
    } else if (authStatus == AVAuthorizationStatusDenied) {
        [self alertPromptToCameraAccessDenied];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        [self alertToEncourageCameraAccessInitially];
    } else {
        [self alertPromptToAllowCameraAccessViaSetting];
    }
}

- (void)callCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;

        if ([self isRearCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        }

        controller.mediaTypes = @[(__bridge NSString *)kUTTypeImage];

        [self presentViewController:controller animated:YES completion:nil];
    } else {
        [MBProgressHUD showMessage:@"?????????????????????" hideAfter:2. completionBlock:nil];
    }
}

- (void)alertToEncourageCameraAccessInitially {
    if ([AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 0) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self checkCamera];
            });
        }];
    } else {
        [MBProgressHUD showMessage:@"?????????????????????" hideAfter:2. completionBlock:nil];
    }
}

- (void)alertPromptToAllowCameraAccessViaSetting {
    NSString *str = [NSString stringWithFormat:@"\"%@\"???????????????????????????", [FEPublicMethods appName]];
    
    FEAlertView* alter = [[FEAlertView alloc] initWithTitle:str message:@"?????? ??????>??????>?????? ?????????"];
    
    [alter addAction:[FEAlertAction actionWithTitle:@"??????" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
        
    }]];
    [alter addAction:[FEAlertAction actionWithTitle:@"??????" style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
        [FEPublicMethods openUrlInSafari:UIApplicationOpenSettingsURLString];
    }]];
    [alter show];
}

- (void)alertPromptToCameraAccessDenied {
    NSString *str = [NSString stringWithFormat:@"\"%@\"???????????????????????????", [FEPublicMethods appName]];
    FEAlertView* alter = [[FEAlertView alloc] initWithTitle:str message:@"?????? ??????>??????>?????? ?????????"];
    
    [alter addAction:[FEAlertAction actionWithTitle:@"??????" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
        
    }]];
    [alter show];
}

// ??????????????????
- (void)checkPhoto {
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];

    if (authStatus == PHAuthorizationStatusAuthorized) {
        [self pushTZImagePickerController];
    } else if (authStatus == PHAuthorizationStatusDenied) {
        [self alertPromptToPhotoAccessDenied];
    } else if (authStatus == PHAuthorizationStatusNotDetermined) {
        [self alertToEncouragePhotoAccessInitially];
    } else {
        [self alertPromptToAllowPhotoAccessViaSetting];
    }
}

- (void)callPhoto {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.delegate = self;
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.mediaTypes = @[(__bridge NSString *)kUTTypeImage];

        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)alertPromptToPhotoAccessDenied {
    NSString *str = [NSString stringWithFormat:@"\"%@\"???????????????????????????", [FEPublicMethods appName]];
    
    FEAlertView* alter = [[FEAlertView alloc] initWithTitle:str message:@"?????? ??????>??????>?????? ?????????"];
    
    [alter addAction:[FEAlertAction actionWithTitle:@"??????" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
        
    }]];
    [alter show];
}

- (void)alertToEncouragePhotoAccessInitially {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self checkPhoto];
        });
    }];
}

- (void)alertPromptToAllowPhotoAccessViaSetting {
    NSString *str = [NSString stringWithFormat:@"\"%@\"???????????????????????????", [FEPublicMethods appName]];
    FEAlertView* alter = [[FEAlertView alloc] initWithTitle:str message:@"?????? ??????>??????>?????? ?????????"];

    [alter addAction:[FEAlertAction actionWithTitle:@"??????" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
        
    }]];
    [alter addAction:[FEAlertAction actionWithTitle:@"??????" style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
        [FEPublicMethods openUrlInSafari:UIApplicationOpenSettingsURLString];
    }]];
    [alter show];
}

#pragma mark - UIImagePickerController

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *originalImage = info[@"UIImagePickerControllerOriginalImage"];

    switch (self.btnType) {
        case 0:{
            [self.zhengZMBtn setImage:originalImage forState:UIControlStateNormal];
        }break;
        case 1:{
            [self.zhengFMBtn setImage:originalImage forState:UIControlStateNormal];
        }break;
        case 2:{
            [self.yingyeBtn setImage:originalImage forState:UIControlStateNormal];
        }break;
        case 3:{
            [self.dianBtn setImage:originalImage forState:UIControlStateNormal];
        }break;
        
        default:
            break;
    }
    [self uploadImageToServer:originalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isRearCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if ((authStatus == AVAuthorizationStatusRestricted) ||
        (authStatus == AVAuthorizationStatusDenied))
    {
        // ??????????????? ????????????????????????
        FEAlertView* alter = [[FEAlertView alloc] initWithTitle:@"??????????????????" message:@"??????iPhone???" "??????-??????-??????" "?????????????????????"];
        
        [alter addAction:[FEAlertAction actionWithTitle:@"??????" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
            
        }]];
        [alter show];
        
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, ??????????????????????????????????????????????????????
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted)
        {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // ???????????????????????????????????????
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // ???????????????????????????????????????????????????????????????
        
        FEAlertView* alter = [[FEAlertView alloc] initWithTitle:@"??????????????????" message:@"??????iPhone???" "??????-??????-??????" "?????????????????????"];
        
        [alter addAction:[FEAlertAction actionWithTitle:@"??????" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
            
        }]];
        [alter show];
        
        
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // ????????????????????????
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushTZImagePickerController];
    }
}

- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]
         initWithMaxImagesCount:1
         columnNumber:4
         delegate:self
         pushPhotoPickerVc:YES];
    imagePickerVc.modalPresentationStyle = UIModalPresentationFullScreen;
//    imagePickerVc.selectedAssets = _selectedAssets; // ?????????????????????????????????
    imagePickerVc.allowTakePicture = NO;    // ???????????????????????????
    imagePickerVc.allowTakeVideo = NO;      // ???????????????????????????
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO;
    imagePickerVc.sortAscendingByModificationDate = YES;
    imagePickerVc.showSelectedIndex = NO;
    [imagePickerVc setDidFinishPickingPhotosHandle:
        ^(NSArray <UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        UIImage*originalImage = photos.firstObject;
        switch (self.btnType) {
            case 0:{
                [self.zhengZMBtn setImage:originalImage forState:UIControlStateNormal];
            }break;
            case 1:{
                [self.zhengFMBtn setImage:originalImage forState:UIControlStateNormal];
            }break;
            case 2:{
                [self.yingyeBtn setImage:originalImage forState:UIControlStateNormal];
            }break;
            case 3:{
                [self.dianBtn setImage:originalImage forState:UIControlStateNormal];
            }break;
            
            default:
                break;
        }
        [self uploadImageToServer:originalImage];
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}





@end
