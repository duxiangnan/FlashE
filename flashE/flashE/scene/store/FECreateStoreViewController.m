//
//  FECreateStoreViewController.m
//  flashE
//
//  Created by duxiangnan on 2021/11/18.
//

#import "FECreateStoreViewController.h"
#import "FEDefineModule.h"
#import "FEStoreModel.h"
#import <Photos/PHPhotoLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <TZImagePickerController/TZImagePickerController.h>
@interface FECreateStoreViewController ()
@property (nonatomic, strong) FEStoreModel* inputModel;
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

@property (nonatomic, strong) NSURLSessionDataTask* submitTask;
@property (nonatomic, assign) NSInteger btnType;//图片选取索引
@end

@implementation FECreateStoreViewController
+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
    
        [FFRouter registerObjectRouteURL:@"store://createStore" handler:^id(NSDictionary *routerParameters) {
            FECreateStoreViewController* vc = [[FECreateStoreViewController alloc] initWithNibName:@"FECreateStoreViewController" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputModel = [[FEStoreModel alloc] init];
    self.inputModel.defaultStore = self.defaultAddressSw.on?1:0;
    self.btnType = -1;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChange:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
}
-(void) resetLbColor:(UILabel*)lb {
    UIColor* emptyC = UIColorFromRGB(0xC7C7C9);
    UIColor* defaultC = UIColorFromRGB(0x333333);
    if (lb == self.dianDetailLB) {
        lb.textColor = self.inputModel.addressDetail.length>0?defaultC:emptyC;
    } else if (lb == self.dianNameLB) {
        lb.textColor = self.inputModel.address.length>0?defaultC:emptyC;
    } else if (lb == self.dianTypeLB) {
        lb.textColor = self.inputModel.category>0?defaultC:emptyC;
    }
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self.submitTask cancel];
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
- (IBAction)submintAction:(id)sender {
    [self.view endEditing:YES];
    if (self.inputModel.name.length ==0) {
        [MBProgressHUD showMessage:@"请填写店铺名称"];
        return;
    }
    if (self.inputModel.address.length == 0 || self.inputModel.addressDetail.length == 0) {
        [MBProgressHUD showMessage:@"请填写店铺地址"];
        return;
    }
    if (self.inputModel.category == 0 ) {
        [MBProgressHUD showMessage:@"请选择店铺经营品类"];
        return;
    }
    if (self.inputModel.mobile.length == 0 ) {
        [MBProgressHUD showMessage:@"请填写店铺联系手机号"];
        return;
    }
    if (self.inputModel.frontIdcard.length == 0 || self.inputModel.reverseIdcard.length == 0 ) {
        [MBProgressHUD showMessage:@"请上传身份证照片"];
        return;
    }
    if (self.inputModel.facade.length == 0 || self.inputModel.businessLicense.length == 0  ) {
        [MBProgressHUD showMessage:@"请上传店铺营业执照及门面照片"];
        return;
    }
    
    FEAlertView* alert = [[FEAlertView alloc] initWithTitle:@"温馨提示" message:@"新增店铺需提交至配送平台审核，审核中及未通过店铺暂不可发单"];
    [alert addAction:[FEAlertAction actionWithTitle:@"取消" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
        
    }]];
    [alert addAction:[FEAlertAction actionWithTitle:@"我知道了" style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
        [self submitRequest];
    }]];
    [alert show];
    
    
}
- (void) submitRequest {
    


    NSMutableDictionary* param = [NSMutableDictionary dictionaryWithDictionary:[self.inputModel yy_modelToJSONObject]];
    [param removeObjectForKey:@"ID"];
    
    [MBProgressHUD showProgressOnView:self.view];
    @weakself(self);
    NSString* fouction = @"/deer/store/addStore";
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    if (acc.storeId == 0) {
        fouction = @"/deer/shop/register";
    }
    
    
    self.submitTask = [[FEHttpManager defaultClient] POST:fouction parameters:param
      success:^(NSInteger code, id  _Nonnull response)
    {
        @strongself(weakSelf);
        [MBProgressHUD hideProgressOnView:strongSelf.view];
        NSDictionary* dic = ((NSDictionary*)response)[@"data"];
        FEStoreModel* mode = [FEStoreModel yy_modelWithDictionary:dic];
        self.inputModel.ID = mode.ID;
        [FFRouter routeObjectURL:@"store://storeDetail" withParameters:@{@"ID":@(mode.ID)}];
        
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




#pragma mark -- UITextField delegate

- (void) textChange:(NSNotification*) noti {
    UITextField* text = noti.object;

    if (text == self.dianNameTF) {
        self.dianNameTF.text = text.text;
        self.inputModel.name = text.text;
    } else if (text == self.dianPhoneTF) {
        self.dianPhoneTF.text = text.text;
        self.inputModel.mobile = text.text;
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
        return [FEPublicMethods limitTextInput:textField replacementText:string max:50 ];
    }
    if (textField == self.dianPhoneTF) {
        return [FEPublicMethods limitTextInput:textField replacementText:string max:11];
    }
    
    return YES;
    
}



#pragma mark ---选择图片
- (void)selectPhotoAction:(UIView*)view {
    UIAlertController* actionView = [UIAlertController alertControllerWithTitle:nil
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [actionView addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *_Nonnull action) {}]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"相机"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self checkCamera];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"相册"
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

// 开始拍照权限
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
        [MBProgressHUD showMessage:@"不支持所选设备" hideAfter:2. completionBlock:nil];
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
        [MBProgressHUD showMessage:@"不支持所选设备" hideAfter:2. completionBlock:nil];
    }
}

- (void)alertPromptToAllowCameraAccessViaSetting {
    NSString *str = [NSString stringWithFormat:@"\"%@\"访问相机的权限受限", [FEPublicMethods appName]];
    
    FEAlertView* alter = [[FEAlertView alloc] initWithTitle:str message:@"请在 设置>隐私>相机 中开启"];
    
    [alter addAction:[FEAlertAction actionWithTitle:@"取消" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
        
    }]];
    [alter addAction:[FEAlertAction actionWithTitle:@"开启" style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
        [FEPublicMethods openUrlInSafari:UIApplicationOpenSettingsURLString];
    }]];
    [alter show];
}

- (void)alertPromptToCameraAccessDenied {
    NSString *str = [NSString stringWithFormat:@"\"%@\"没有访问相机的权限", [FEPublicMethods appName]];
    FEAlertView* alter = [[FEAlertView alloc] initWithTitle:str message:@"请在 设置>隐私>相机 中开启"];
    
    [alter addAction:[FEAlertAction actionWithTitle:@"确认" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
        
    }]];
    [alter show];
}

// 打开本地相册
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
    NSString *str = [NSString stringWithFormat:@"\"%@\"没有访问相册的权限", [FEPublicMethods appName]];
    
    FEAlertView* alter = [[FEAlertView alloc] initWithTitle:str message:@"请在 设置>隐私>照片 中开启"];
    
    [alter addAction:[FEAlertAction actionWithTitle:@"确认" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
        
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
    NSString *str = [NSString stringWithFormat:@"\"%@\"访问相册的权限受限", [FEPublicMethods appName]];
    FEAlertView* alter = [[FEAlertView alloc] initWithTitle:str message:@"请在 设置>隐私>照片 中开启"];

    [alter addAction:[FEAlertAction actionWithTitle:@"取消" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
        
    }]];
    [alter addAction:[FEAlertAction actionWithTitle:@"开启" style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
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
        // 无相机权限 做一个友好的提示
        FEAlertView* alter = [[FEAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的" "设置-隐私-相机" "中允许访问相机"];
        
        [alter addAction:[FEAlertAction actionWithTitle:@"确认" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
            
        }]];
        [alter show];
        
        
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted)
        {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        
        FEAlertView* alter = [[FEAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的" "设置-隐私-相机" "中允许访问相机"];
        
        [alter addAction:[FEAlertAction actionWithTitle:@"确认" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
            
        }]];
        [alter show];
        
        
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
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
//    imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    imagePickerVc.allowTakePicture = NO;    // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = NO;      // 在内部显示拍视频按
    
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
