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
    NSString* ID = [NSString stringWithFormat:@"%ld",acc.ID];
    NSString* shopId = [NSString stringWithFormat:@"%ld",acc.shopId];
    [wrapper addEntriesFromDictionary:body];
    wrapper[@"token"] = token;
    wrapper[@"shopId"] = shopId;
    wrapper[@"userId"] = ID;
    wrapper[@"version"] = version;
    wrapper[@"timeSpan"] = timeSpan;
    wrapper[@"signKey"] = [MD5Encryption md5by32:sig];
    
//    [wrapper enumerateKeysAndObjectsUsingBlock:^(NSString* _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        [[FEHttpManager defaultClient].requestSerializer setValue:obj forHTTPHeaderField:key];
//    }];
    [[FEHttpManager defaultClient].requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [[FEHttpManager defaultClient].requestSerializer setValue:version forHTTPHeaderField:@"version"];
    [[FEHttpManager defaultClient].requestSerializer setValue:timeSpan forHTTPHeaderField:@"timeSpan"];
    [[FEHttpManager defaultClient].requestSerializer setValue:ID forHTTPHeaderField:@"ID"];
    [[FEHttpManager defaultClient].requestSerializer setValue:shopId forHTTPHeaderField:@"shopId"];
    
    
    return wrapper;
}

NSDictionary* correctResponse(NSDictionary* dic) {
    NSMutableDictionary* resp = [NSMutableDictionary dictionaryWithDictionary:dic];
    id data = resp[@"data"];
    if ([data isKindOfClass:[NSNull class]]) {
        [resp removeObjectForKey:@"data"];
        return resp.copy;
    }
    return dic;
}

void FEResponseAnalysis(id responseObject, FEHTTPAPISuccessBlock successBlock, FEHTTPAPIFailBlock failureBlock)
{
    NSDictionary* response = correctResponse((NSDictionary*)responseObject);
    if (response[@"status"] && [response[@"status"] integerValue] != 200) {
        
        int code = [response[@"status"] intValue];
        if (failureBlock) {
            NSString* message = response[@"data"];
            
            if (![message isKindOfClass:[NSString class]] || message.length == 0) {
                
                message = response[@"msg"];
                if (![message isKindOfClass:[NSString class]] || message.length == 0) {
                    message = [NSString stringWithFormat:@"???????????????????????????,???????????????%d",code];
                }
            }
            NSDictionary *userInfo = @{NSLocalizedDescriptionKey:message};
            NSError *error = [NSError errorWithDomain:@"FEHTTPAPIErrorDomain" code:code
                                             userInfo:userInfo];
            failureBlock(error, response);
        }
    } else if (successBlock) {
        successBlock(200, response);
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
    NSString* errorMesg = [NSString stringWithFormat:@"???????????????????????????,????????????%ld", errCode];
//    ???????????????????????????????????????
    switch (errCode) {
        case NSURLErrorUnknown://-1://
            errorMesg = @"?????????URL??????";
            break;
        case NSURLErrorCancelled://-999://
            errorMesg = @"?????????URL??????";
            break;
        case NSURLErrorBadURL://-1000://
            errorMesg = @"?????????URL??????";
            break;
        case NSURLErrorTimedOut://-1001://
            errorMesg = @"?????????????????????????????????";
            break;
        case NSURLErrorUnsupportedURL://-1002://
            errorMesg = @"????????????URL??????";
            break;
        case NSURLErrorCannotFindHost://-1003://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorCannotConnectToHost://-1004://
            errorMesg = @"?????????????????????";
            break;
        case NSURLErrorDataLengthExceedsMaximum://-1103://
            errorMesg = @"????????????????????????????????????";
            break;
        case NSURLErrorNetworkConnectionLost://-1005://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorDNSLookupFailed://-1006://
            errorMesg = @"DNS????????????";
            break;
        case NSURLErrorHTTPTooManyRedirects://-1007://
            errorMesg = @"HTTP???????????????";
            break;
        case NSURLErrorResourceUnavailable://-1008://
            errorMesg = @"???????????????";
            break;
        case NSURLErrorNotConnectedToInternet://-1009://
            errorMesg = @"???????????????";
            break;
        case NSURLErrorRedirectToNonExistentLocation://-1010://
            errorMesg = @"??????????????????????????????";
            break;
        case NSURLErrorBadServerResponse://-1011://
            errorMesg = @"?????????????????????";
            break;
        case NSURLErrorUserCancelledAuthentication://-1012://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorUserAuthenticationRequired://-1013://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorZeroByteResource://-1014://
            errorMesg = @"???????????????";
            break;
        case NSURLErrorCannotDecodeRawData://-1015://
            errorMesg = @"????????????????????????";
            break;
        case NSURLErrorCannotDecodeContentData://-1016://
            errorMesg = @"????????????????????????";
            break;
        case NSURLErrorCannotParseResponse://-1017://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorInternationalRoamingOff://-1018://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorCallIsActive://-1019://
            errorMesg = @"????????????";
            break;
        case NSURLErrorDataNotAllowed://-1020://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorRequestBodyStreamExhausted://-1021://
            errorMesg = @"?????????";
            break;
        case NSURLErrorFileDoesNotExist://-1100://
            errorMesg = @"???????????????";
            break;
        case NSURLErrorFileIsDirectory://-1101://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorNoPermissionsToReadFile://-1102://
            errorMesg = @"?????????????????????";
            break;
        case NSURLErrorSecureConnectionFailed://-1200://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorServerCertificateHasBadDate://-1201://
            errorMesg = @"?????????????????????";
            break;
        case NSURLErrorServerCertificateUntrusted://-1202://
            errorMesg = @"??????????????????????????????";
            break;
        case NSURLErrorServerCertificateHasUnknownRoot://-1203://
            errorMesg = @"??????Root??????????????????";
            break;
        case NSURLErrorServerCertificateNotYetValid://-1204://
            errorMesg = @"????????????????????????";
            break;
        case NSURLErrorClientCertificateRejected://-1205://
            errorMesg = @"?????????????????????";
            break;
        case NSURLErrorClientCertificateRequired://-1206://
            errorMesg = @"?????????????????????";
            break;
        case NSURLErrorCannotLoadFromNetwork://-2000://
            errorMesg = @"?????????????????????";
            break;
        case NSURLErrorCannotCreateFile://-3000://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorCannotOpenFile://-3001://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorCannotCloseFile://-3002://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorCannotWriteToFile://-3003://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorCannotRemoveFile://-3004://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorCannotMoveFile://-3005://
            errorMesg = @"??????????????????";
            break;
        case NSURLErrorDownloadDecodingFailedMidStream://-3006://
            errorMesg = @"????????????????????????";
            break;
        case NSURLErrorDownloadDecodingFailedToComplete://-3007://
            errorMesg = @"????????????????????????";
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
        //????????????
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
//????????????url??????

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
//????????????functionID????????????

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

