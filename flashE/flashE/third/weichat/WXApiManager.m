//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
#import "FEDefineModule.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

#pragma mark - WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = @"支付结果";
        
        switch (resp.errCode) {
            case WXSuccess:
                strMsg = @"支付成功";
                [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
                break;
            case WXErrCodeCommon:
                strMsg = @"普通错误类型";
                break;
            case WXErrCodeUserCancel:
                strMsg = @"支付取消";
                break;
            case WXErrCodeSentFail:
                strMsg = @"发送失败";
                break;
            case WXErrCodeAuthDeny:
                strMsg = @"授权失败";
                break;
            case WXErrCodeUnsupport:
                strMsg = @"微信不支持";
                break;
            default:
                strMsg = @"支付失败";
                break;
        }
        [MBProgressHUD showMessage:strMsg];
    }else {
        
    }
}

- (void)onReq:(BaseReq *)req {

}

@end
