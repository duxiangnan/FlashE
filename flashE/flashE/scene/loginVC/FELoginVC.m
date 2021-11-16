//
//  FELoginVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/9.
//

#import "FELoginVC.h"
#import "FEDefineModule.h"
#import <YBAttributeTextTapAction/UILabel+YBAttributeTextTapAction.h>
#import "NSString-umbrella.h"
#import "UILabel+AttributedString.h"
#import "MBP-umbrella.h"
#import <YYModel/YYModel.h>
#import "FEUIView-umbrella.h"
#import "FEAccountManager.h"

@interface FELoginVC ()


@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UIButton * sendAuthCodeBtn;//发送验证码

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;


@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkAgreementBtn;
@property (weak, nonatomic) IBOutlet UILabel *agreementLB;



@end

@implementation FELoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* tmpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sendAuthCodeBtn.width + 10, self.sendAuthCodeBtn.height)];
    tmpView.backgroundColor = UIColor.clearColor;
    [tmpView addSubview:self.sendAuthCodeBtn];
    self.codeTF.rightView = tmpView;
    self.codeTF.rightViewMode = UITextFieldViewModeAlways;
    
    self.agreementLB.attributedText = nil;
    UIFont* font = [UIFont systemFontOfSize:14];
    [self.agreementLB appendAttriString:@"我已阅读并同意" color:UIColorFromRGB(0x777777) font:font];
    [self.agreementLB appendAttriString:@"用户服务协议" color:UIColorFromRGB(0x12B398) font:font];
    [self.agreementLB appendAttriString:@"及" color:UIColorFromRGB(0x777777) font:font];
    [self.agreementLB appendAttriString:@"隐私协议" color:UIColorFromRGB(0x12B398) font:font];
    
    [self.agreementLB yb_addAttributeTapActionWithStrings:@[@"用户服务协议",@"隐私协议"] tapClicked:
     ^(UILabel *label, NSString *string, NSRange range, NSInteger index)
    {
        if(index == 0){
            //用户服务协议
        } else if (index == 1) {
            //隐私协议
        }
    }];
    
    self.checkAgreementBtn.selected = YES;

}


- (IBAction)loginSubmitAction:(id)sender {
    
    if (self.nameTF.text.length == 0) {
        [MBProgressHUD showMessage:@"输入手机号"];
        return;
    }
    if (self.codeTF.text.length == 0) {
        [MBProgressHUD showMessage:@"输入验证码"];
        return;
    }
    if (!self.checkAgreementBtn.selected) {
        [MBProgressHUD showMessage:@"请勾选用户服务协议、隐私协议"];
        return;
    }
    @weakself(self)
    [MBProgressHUD showProgress];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mobile"] = self.nameTF.text;
    parameters[@"code"] = self.codeTF.text;
    [[FEHttpManager defaultClient] POST:@"/deer/user/loginBySms"
                     parameters:parameters success:^(NSInteger code, NSDictionary *responseDict) {
        @strongself(weakSelf);
        [MBProgressHUD hideProgress];
        FEAccountModel* account = [FEAccountModel yy_modelWithDictionary:responseDict[@"data"]];
        account.token = @"b12fd1f16d7a0a976d4bbd0f1c90a2f3e69a6d4d79b3a0da2ca655b3df1bcf0f9cac5cbd0ddc81322f54e1b887e3a7fc7a8aa23d6fe856e0";
        [FEAccountManager saveIuputPin:account.mobile];
        [[FEAccountManager sharedFEAccountManager] setLoginInfo:account];
        [strongSelf stopTimer];//停止倒计时
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FELoginSucced" object:nil];
    } failure:^(NSError *error, id response) {
        [MBProgressHUD hideProgress];
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        [MBProgressHUD hideProgress];
    }];
}




- (UIButton*) sendAuthCodeBtn{
    if (!_sendAuthCodeBtn) {
        _sendAuthCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendAuthCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [_sendAuthCodeBtn setTitleColor:UIColorFromRGB(0x12B398)
                                      forState:UIControlStateNormal];
        [_sendAuthCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_sendAuthCodeBtn addTarget:self action:@selector(sendAuthCodeBtnClick:)
                          forControlEvents:UIControlEventTouchUpInside];
 
        _sendAuthCodeBtn.frame = CGRectMake(0, 0, 90, 50);
        _sendAuthCodeBtn.backgroundColor = [UIColor clearColor];
    }
    return _sendAuthCodeBtn;
}


- (void)sendAuthCodeBtnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (self.nameTF.text.length == 0) {
        [MBProgressHUD showMessage:@"输入手机号"];
        return;
    }
    @weakself(self)
    [MBProgressHUD showProgress];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"mobile"] = self.nameTF.text;
    [[FEHttpManager defaultClient] POST:@"/deer/user/sendSmsCode"
                             parameters:parameters success:^(NSInteger code, NSDictionary *responseDict) {
        @strongself(weakSelf);
        [MBProgressHUD hideProgress];
        [MBProgressHUD showMessage:responseDict[@"msg"]];
        
        [strongSelf timerButtonAction:60];//倒计时
    } failure:^(NSError *error, id response) {
        [MBProgressHUD hideProgress];
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        [MBProgressHUD hideProgress];
    }];
}

- (void)timerButtonAction:(int)time {
    __block int         timeout = time; // 倒计时时间
    dispatch_queue_t    queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); // 每秒执行
    @weakself(self);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout == 0) {
            [weakSelf stopTimer];
            [weakSelf changeAuthCodeButtonDisable];
        } else {
            NSString *strTime = [NSString stringWithFormat:@"%.1d秒", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.sendAuthCodeBtn setTitle:
                 [NSString stringWithFormat:@"重新发送(%@)", strTime]
                                             forState:UIControlStateNormal];
                [weakSelf.sendAuthCodeBtn setTitleColor:
                 UIColorFromRGB(0x999999) forState:UIControlStateNormal];
                
                weakSelf.sendAuthCodeBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)changeAuthCodeButtonDisable
{
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.sendAuthCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.sendAuthCodeBtn setTitleColor:[UIColor colorWithRed:240.0 / 255
                                                           green:37.0 / 255
                                                            blue:15.0 / 255
                                                           alpha:1.0]
                                  forState:UIControlStateNormal];
    self.sendAuthCodeBtn.enabled = YES;
        });

}

- (void)stopTimer
{
    if (_timer) {
        dispatch_source_cancel(_timer);
        self.timer = nil;
    }
    [self changeAuthCodeButtonDisable];
}

@end
