//
//  FEHttpDataManager.m
//  flashE
//
//  Created by duxiangnan on 2021/11/8.
//

#import "FEHttpManager.h"
#include "FEPublicMethods.h"
#import "MD5Encryption.h"
#import "FEDefineModule.h"
#import "FEAccountManager.h"
NSString *const FEHTTPAPIErrorDomain = @"FEHTTPAPIErrorDomain";



NSDictionary *FERequestEncryption(NSDictionary *body,NSMutableDictionary* wrapper)
{
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    NSString* token = [FEPublicMethods SafeString:acc.token];
    NSString* version = [FEPublicMethods clientVersion];
    NSString* timeSpan = [NSString stringWithFormat:@"%0.f",[[NSDate date] timeIntervalSince1970]*1000];
    NSString* sig = [NSString stringWithFormat:@"token=%@&version=%@&timeSpan=%@",
                    token,version,timeSpan];
    [wrapper addEntriesFromDictionary:body];
    wrapper[@"token"] = token;
    wrapper[@"version"] = version;
    wrapper[@"timeSpan"] = timeSpan;
    wrapper[@"signKey"] = [MD5Encryption md5by32:sig];
    
//    [wrapper enumerateKeysAndObjectsUsingBlock:^(NSString* _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        [[FEHttpManager defaultClient].requestSerializer setValue:obj forHTTPHeaderField:key];
//    }];
    [[FEHttpManager defaultClient].requestSerializer setValue:token forHTTPHeaderField:@"token"];
//    [[FEHttpManager defaultClient].requestSerializer setValue:version forHTTPHeaderField:@"version"];
//    [[FEHttpManager defaultClient].requestSerializer setValue:timeSpan forHTTPHeaderField:@"timeSpan"];
    
    
    return wrapper;
}


void FEResponseAnalysis(id responseObject, FEHTTPAPISuccessBlock successBlock, FEHTTPAPIFailBlock failureBlock)
{
    
//    "status": 200,
//       "msg": null,
//       "data"
//    "

    if ([responseObject isKindOfClass:[NSDictionary class]] &&
        responseObject[@"status"] && [responseObject[@"status"] integerValue] != 200) {
        NSDictionary *resultDict = (NSDictionary *)responseObject;
        int code = [resultDict[@"status"] intValue];
        if (failureBlock) {
            NSString* message = @"";
            if (resultDict && [resultDict isKindOfClass:[NSDictionary class]]) {
                NSString* tmp = resultDict[@"msg"];
                if ([tmp isKindOfClass:[NSString class]] && (tmp.length > 0)) {
                    message = tmp;
                }
            } else {
                message = [NSString stringWithFormat:@"请检查您的网络环境,稍后重试～%d",code];
            }
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:message};
            NSError *error = [NSError errorWithDomain:@"FEHTTPAPIErrorDomain" code:code
                                             userInfo:userInfo];
            failureBlock(error, resultDict);
        }
    } else if (successBlock) {
        successBlock(200, responseObject);
    }
}

@implementation FEHttpDataManager

+ (instancetype)shared;
{
    static FEHttpDataManager* sharedManager = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedManager = [[FEHttpDataManager alloc] init];
        
    });
    return sharedManager;
}

+ (void)makeErrWithFinish:(NSError **)err {
    NSError *error = ((NSError *)*err);
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:error.userInfo];
    NSInteger code = error.code;
    NSString *domain = error.domain;
    [userInfo setObject:[FEHttpDataManager getServiceErrMsg:code] forKey:NSLocalizedDescriptionKey];
    error = [NSError errorWithDomain:domain code:code userInfo:userInfo];
    *err = error;
}
+ (NSString*) getServiceErrMsg:(NSInteger)errCode {
    NSString* errorMesg = [NSString stringWithFormat:@"请检查您的网络环境,稍后重试%ld", errCode];
//    有关于网络请求失败的解释：
    switch (errCode) {
        case NSURLErrorUnknown://-1://
            errorMesg = @"无效的URL地址";
            break;
        case NSURLErrorCancelled://-999://
            errorMesg = @"无效的URL地址";
            break;
        case NSURLErrorBadURL://-1000://
            errorMesg = @"无效的URL地址";
            break;
        case NSURLErrorTimedOut://-1001://
            errorMesg = @"网络不给力，请稍后再试";
            break;
        case NSURLErrorUnsupportedURL://-1002://
            errorMesg = @"不支持的URL地址";
            break;
        case NSURLErrorCannotFindHost://-1003://
            errorMesg = @"找不到服务器";
            break;
        case NSURLErrorCannotConnectToHost://-1004://
            errorMesg = @"连接不上服务器";
            break;
        case NSURLErrorDataLengthExceedsMaximum://-1103://
            errorMesg = @"请求数据长度超出最大限度";
            break;
        case NSURLErrorNetworkConnectionLost://-1005://
            errorMesg = @"网络连接异常";
            break;
        case NSURLErrorDNSLookupFailed://-1006://
            errorMesg = @"DNS查询失败";
            break;
        case NSURLErrorHTTPTooManyRedirects://-1007://
            errorMesg = @"HTTP请求重定向";
            break;
        case NSURLErrorResourceUnavailable://-1008://
            errorMesg = @"资源不可用";
            break;
        case NSURLErrorNotConnectedToInternet://-1009://
            errorMesg = @"无网络连接";
            break;
        case NSURLErrorRedirectToNonExistentLocation://-1010://
            errorMesg = @"重定向到不存在的位置";
            break;
        case NSURLErrorBadServerResponse://-1011://
            errorMesg = @"服务器响应异常";
            break;
        case NSURLErrorUserCancelledAuthentication://-1012://
            errorMesg = @"用户取消授权";
            break;
        case NSURLErrorUserAuthenticationRequired://-1013://
            errorMesg = @"需要用户授权";
            break;
        case NSURLErrorZeroByteResource://-1014://
            errorMesg = @"零字节资源";
            break;
        case NSURLErrorCannotDecodeRawData://-1015://
            errorMesg = @"无法解码原始数据";
            break;
        case NSURLErrorCannotDecodeContentData://-1016://
            errorMesg = @"无法解码内容数据";
            break;
        case NSURLErrorCannotParseResponse://-1017://
            errorMesg = @"无法解析响应";
            break;
        case NSURLErrorInternationalRoamingOff://-1018://
            errorMesg = @"国际漫游关闭";
            break;
        case NSURLErrorCallIsActive://-1019://
            errorMesg = @"被叫激活";
            break;
        case NSURLErrorDataNotAllowed://-1020://
            errorMesg = @"数据不被允许";
            break;
        case NSURLErrorRequestBodyStreamExhausted://-1021://
            errorMesg = @"请求体";
            break;
        case NSURLErrorFileDoesNotExist://-1100://
            errorMesg = @"文件不存在";
            break;
        case NSURLErrorFileIsDirectory://-1101://
            errorMesg = @"文件是个目录";
            break;
        case NSURLErrorNoPermissionsToReadFile://-1102://
            errorMesg = @"无读取文件权限";
            break;
        case NSURLErrorSecureConnectionFailed://-1200://
            errorMesg = @"安全连接失败";
            break;
        case NSURLErrorServerCertificateHasBadDate://-1201://
            errorMesg = @"服务器证书失效";
            break;
        case NSURLErrorServerCertificateUntrusted://-1202://
            errorMesg = @"不被信任的服务器证书";
            break;
        case NSURLErrorServerCertificateHasUnknownRoot://-1203://
            errorMesg = @"未知Root的服务器证书";
            break;
        case NSURLErrorServerCertificateNotYetValid://-1204://
            errorMesg = @"服务器证书未生效";
            break;
        case NSURLErrorClientCertificateRejected://-1205://
            errorMesg = @"客户端证书被拒";
            break;
        case NSURLErrorClientCertificateRequired://-1206://
            errorMesg = @"需要客户端证书";
            break;
        case NSURLErrorCannotLoadFromNetwork://-2000://
            errorMesg = @"无法从网络获取";
            break;
        case NSURLErrorCannotCreateFile://-3000://
            errorMesg = @"无法创建文件";
            break;
        case NSURLErrorCannotOpenFile://-3001://
            errorMesg = @"无法打开文件";
            break;
        case NSURLErrorCannotCloseFile://-3002://
            errorMesg = @"无法关闭文件";
            break;
        case NSURLErrorCannotWriteToFile://-3003://
            errorMesg = @"无法写入文件";
            break;
        case NSURLErrorCannotRemoveFile://-3004://
            errorMesg = @"无法删除文件";
            break;
        case NSURLErrorCannotMoveFile://-3005://
            errorMesg = @"无法移动文件";
            break;
        case NSURLErrorDownloadDecodingFailedMidStream://-3006://
            errorMesg = @"下载解码数据失败";
            break;
        case NSURLErrorDownloadDecodingFailedToComplete://-3007://
            errorMesg = @"下载解码数据失败";
            break;
        default:
            break;
    }

    return errorMesg;
}
 


@end

@implementation FEHttpManager

+ (instancetype)manager {
    return [self defaultClient];
}

+ (instancetype)defaultClient {
    static dispatch_once_t onceToken;
    static FEHttpManager *apiClient;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        config.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        config.URLCache = nil;
        apiClient = [[self alloc] initWithBaseURL:nil sessionConfiguration:config];
        apiClient.requestSerializer = [[AFJSONRequestSerializer alloc] init];
        [apiClient.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        apiClient.requestSerializer.timeoutInterval = 30.0;
        [apiClient.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        apiClient.responseSerializer = [[AFJSONResponseSerializer alloc] init];
        NSMutableSet *acceptableCTs = [NSMutableSet setWithSet:[apiClient.responseSerializer acceptableContentTypes]];
        [acceptableCTs addObject:@"application/json"];
        [apiClient.responseSerializer setAcceptableContentTypes:acceptableCTs];
    });
    
    
    return apiClient;
}

- (NSURLSessionDataTask *)GET:(NSString *)functionID
                   parameters:(NSDictionary *)para
                      success:(FEHTTPAPISuccessBlock)success
                      failure:(FEHTTPAPIFailBlock)failure
                       cancle:(FEHTTPAPICancel)cancle
{
    NSString *url = [[FEDefineModule VSP_BASE_SERVER_URL] stringByAppendingString:functionID];
    NSDictionary* param = [self wrapParameters:para];
    NSURLSessionDataTask *task = [super GET:url parameters:param progress:nil success:
                              ^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject)
    {
        [self analysisResponse:responseObject succ:success fail:failure];
    }
    failure:^(NSURLSessionDataTask *_Nullable task, NSError *error) {
        if (error.code == kCFURLErrorCancelled) {
            !cancle?:cancle();
        } else {
            [FEHttpDataManager makeErrWithFinish:&error];
            !failure?:failure(error, nil);
        }
    }];
    
    return task;
}



- (NSURLSessionDataTask *)POST:(NSString *)functionID
                    parameters:(NSDictionary *)params
                       success:(FEHTTPAPISuccessBlock)success
                       failure:(FEHTTPAPIFailBlock)failure
                        cancle:(FEHTTPAPICancel)cancle
{
    NSString *url = [[FEDefineModule VSP_BASE_SERVER_URL] stringByAppendingString:functionID];
    NSDictionary* param = [self wrapParameters:params];
    NSURLSessionDataTask *task = [super POST:url parameters:param progress:nil
                         success:^(NSURLSessionDataTask *_Nonnull task, id _Nonnull responseObject)
    {
        [self analysisResponse:responseObject succ:success fail:failure];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (error.code != kCFURLErrorCancelled){
            [FEHttpDataManager makeErrWithFinish:&error];
            !failure?:failure(error, nil);
        } else {
            !cancle?:cancle();
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)upload:(NSString *)functionID
                           image:(UIImage *)image
                      parameters:(NSDictionary *)para
                         success:(FEHTTPAPISuccessBlock)success
                         failure:(FEHTTPAPIFailBlock)failure
                        progress:(FEHTTPAPIProgress)progress
                          cancle:(FEHTTPAPICancel)cancle {
    
    NSString *url = [[FEDefineModule VSP_BASE_SERVER_URL] stringByAppendingString:functionID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                         @"multipart/form-data",
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json", nil];

    NSDictionary* param = [self wrapParameters:para];
    NSURLSessionDataTask* task = [manager POST:url parameters:param constructingBodyWithBlock:
                                  ^(id <AFMultipartFormData> _Nonnull formData)
    {
        NSString *fileName = [NSString stringWithFormat:@"%ld.jpg", (long)[[NSDate date] timeIntervalSince1970] * 1000];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imageData name:fileName fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * downloadProgress) {
        [self sendBlock:progress progress:downloadProgress];
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        [self analysisResponse:responseObject succ:success fail:failure];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (error.code == kCFURLErrorCancelled) {
            !cancle?:cancle();
        } else {
            [FEHttpDataManager makeErrWithFinish:&error];
            !failure?:failure(error, nil);
        }
    }];
    return task;
}

- (NSURLSessionDataTask *)uploadService:(NSString *)url
                                  image:(UIImage *)image
                          imageFileName:(NSString *)fileName
                             parameters:(NSDictionary *)para
                               progress:(FEHTTPAPIProgress)progress
                                success:(FEHTTPAPISuccessBlock)success
                                failure:(FEHTTPAPIFailBlock)failure
                                 cancle:(FEHTTPAPICancel)cancle {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes =
    [NSSet setWithObjects:@"text/plain", @"multipart/form-data",
                         @"application/json", @"text/html",
                         @"image/jpeg", @"image/png",
                         @"application/octet-stream",
                         @"text/json", nil];
    NSURLSessionDataTask* task = [manager POST:url parameters:para constructingBodyWithBlock:
                                  ^(id <AFMultipartFormData> _Nonnull formData)
    {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imageData name:fileName fileName:fileName mimeType:@"image/jpeg"];
    } progress:^(NSProgress * downloadProgress) {
        [self sendBlock:progress progress:downloadProgress];
    }
    success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        !success?:success(0,responseObject);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (error.code == kCFURLErrorCancelled) {
            !cancle?:cancle();
        } else {
            [FEHttpDataManager makeErrWithFinish:&error];
            !failure?:failure(error, nil);
        }
    }];
    return task;
}


- (NSURLSessionDataTask *)upload:(NSString *)functionID
                          images:(NSArray *)images
                      parameters:(NSDictionary *)para
                         success:(FEHTTPAPISuccessBlock)success
                         failure:(FEHTTPAPIFailBlock)failure
                        progress:(FEHTTPAPIProgress)progress
                          cancle:(FEHTTPAPICancel)cancle {
    NSString *url = [[FEDefineModule VSP_BASE_SERVER_URL] stringByAppendingString:functionID];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",
                                                         @"multipart/form-data",
                                                         @"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json", nil];
    [manager.requestSerializer setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];

    NSDictionary* param = [self wrapParameters:para];
    NSURLSessionDataTask* task = [manager POST:url parameters:param constructingBodyWithBlock:
                                  ^(id <AFMultipartFormData> _Nonnull formData)
    {
        NSInteger count = 0;
        for (UIImage *image in images) {
            count++;
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSString *fileName = [NSString stringWithFormat:@"%ld.jpg", (long)count];
            [formData appendPartWithFileData:imageData name:fileName fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * downloadProgress) {
        [self sendBlock:progress progress:downloadProgress];
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [self analysisResponse:responseObject succ:success fail:failure];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        if (error.code == kCFURLErrorCancelled) {
            !cancle?:cancle();
        } else {
            [FEHttpDataManager makeErrWithFinish:&error];
            !failure?:failure(error, nil);
        }
    }];
    return task;
}
//下行指定url文件

- (NSURLSessionDownloadTask *)download:(NSString *)downloadUrl
                            fileFolder:(NSString *)fileFolder
                              fileName:(NSString *)fileName
                               success:(FEHTTPAPIDownSuccessBlock)success
                              progress:(FEHTTPAPIProgress)progress
                               failure:(FEHTTPAPIFailBlock)failure
                                cancle:(FEHTTPAPICancel)cancle
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc]initWithSessionConfiguration:configuration];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadUrl]];
    

    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request
    progress:^(NSProgress * downloadProgress) {
        [self sendBlock:progress progress:downloadProgress];
    } destination:^NSURL *_Nonnull (NSURL *_Nonnull targetPath, NSURLResponse *_Nonnull response) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", fileFolder]];
        if (![fileManager fileExistsAtPath:fullPath]) {
            [fileManager createDirectoryAtPath:fullPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        fullPath = [fullPath stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]];
    
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error) {
        if (error) {
            if (error.code == kCFURLErrorCancelled) {
                !cancle?:cancle();
            } else {
                !failure?:failure(error, response);
            }
            
        } else if (filePath) {
            !success?:success(filePath, response);
        }
    }];
    
    [task resume];
    return task;
}
//下行指定functionID下的文件

- (NSURLSessionDownloadTask *)download:(NSString *)functionID
                            fileFolder:(NSString *)fileFolder
                            parameters:(NSDictionary *)para
                               success:(FEHTTPAPIDownSuccessBlock)success
                              progress:(FEHTTPAPIProgress)progress
                               failure:(FEHTTPAPIFailBlock)failure
                                cancle:(FEHTTPAPICancel)cancle
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:[self userAgent] forHTTPHeaderField:@"User-Agent"];
    NSString *url = [[FEDefineModule VSP_BASE_SERVER_URL] stringByAppendingString:functionID];
    NSDictionary* param = [self wrapParameters:para ];
    
    for (int i = 0; i < param.allKeys.count; i++) {
        NSString *key = param.allKeys[i];
        url = [url stringByAppendingFormat:@"&%@=%@", key, param[key]].mutableCopy;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPMethod = @"GET";

    
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request
    progress:^(NSProgress *_Nonnull downloadProgress) {
        [self sendBlock:progress progress:downloadProgress];
    } destination:^NSURL *_Nonnull (NSURL *_Nonnull targetPath, NSURLResponse *_Nonnull response) {
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse *_Nonnull response, NSURL *_Nullable filePath, NSError *_Nullable error) {
        if (error) {
            if (error.code == kCFURLErrorCancelled) {
                !cancle?:cancle();
            } else {
                !failure?:failure(error, response);
            }
        } else {

            NSString* ContentType = ((NSHTTPURLResponse*)response).allHeaderFields[@"Content-Type"];
            if ([ContentType containsString:@"application/json"]) {
                NSData* data = [NSData dataWithContentsOfURL:filePath];
                if (data.length > 0) {
                    NSDictionary* sp = [NSJSONSerialization JSONObjectWithData:data
                                           options:NSJSONReadingMutableContainers error:nil];
                    NSString* code = sp[@"status"];
                    
                    NSError* err = [[NSError alloc] initWithDomain:@"donwload"
                              code:NSURLErrorDownloadDecodingFailedMidStream userInfo:sp];
                    [FEHttpDataManager makeErrWithFinish:&err];
                    !failure?:failure(err, response);
                
                } else {
                    NSError* err = [[NSError alloc] initWithDomain:@"donwload"
                                      code:NSURLErrorDownloadDecodingFailedMidStream userInfo:@{}];
                    [FEHttpDataManager makeErrWithFinish:&err];
                    !failure?:failure(err, response);
                }
            } else {
                !success?:success(filePath, response);
            }
        }
    }];
    [task resume];
    return task;
}

- (void) sendBlock:(FEHTTPAPIProgress)pro progress:(NSProgress*)downloadPro
{
    __weak typeof(pro)weakP = pro;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong typeof(weakP) strongp = weakP;
        if (strongp) {
            strongp(downloadPro);
        }
    });
}

- (NSString *) userAgent {
    return @"appName/fe";
}


- (NSDictionary *) wrapParameters:(NSDictionary*)parameters
{
    NSMutableDictionary *wrapper = [NSMutableDictionary dictionary];
    NSDictionary* dic = FERequestEncryption(parameters,wrapper);
    
    return dic;
    
}

- (void) analysisResponse:(id)responseObject succ:(FEHTTPAPISuccessBlock)successBlock fail:(FEHTTPAPIFailBlock)failureBlock
{
    FEResponseAnalysis(responseObject, successBlock, failureBlock);
    
}
@end

