//
//  FEHttpDataManager.h
//  flashE
//
//  Created by duxiangnan on 2021/11/8.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//#import <AFNetworking/AFNetworking.h>
NS_ASSUME_NONNULL_BEGIN

static NSInteger FEHttpLogout1Code = 201;//pin身份过期
static NSInteger FEHttpLogout2Code = 202;//pin身份过期


extern NSString *const FEHTTPAPIErrorDomain;

typedef enum : NSUInteger {
    FEHTTPResponeSuccess,
    FEHTTPResponeErr,//通用错误
    FEHTTPResponeLogout,//pin过去，登出
    
} FEHTTPResponeType;



typedef void (^FEHTTPAPISuccessBlock)(NSInteger code, id response);
typedef void (^FEHTTPAPIDownSuccessBlock)(NSURL* targetPath, NSURLResponse* response);
typedef void (^FEHTTPAPIFailBlock)(NSError *error, id response);
typedef void (^FEHTTPAPIProgress)(NSProgress* progress);
typedef void (^FEHTTPAPICancel)(void);


//处理发送报文
NSDictionary *FERequestEncryption(NSDictionary *body,NSMutableDictionary* wrapper);
//处理响应报文
void FEResponseAnalysis(id responseObject, FEHTTPAPISuccessBlock successBlock, FEHTTPAPIFailBlock failureBlock);






@interface FEHttpDataManager : NSObject

+ (instancetype)shared;
+ (void)makeErrWithFinish:(NSError **)err;
@end


/**
请不要直接使用FEHTTPBase
使用其继承类
 */
@interface FEHttpManager : AFHTTPSessionManager
+ (instancetype) defaultClient;
#pragma mark get
//get网管服务以function=functionID的形式获取数据
- (NSURLSessionDataTask *) GET:(NSString *)functionID
                        parameters:(NSDictionary *)parameters
                        success:(FEHTTPAPISuccessBlock)success
                        failure:(FEHTTPAPIFailBlock)failure
                        cancle:(FEHTTPAPICancel)cancle;

#pragma mark post
//post网管服务以function=functionID的形式获取数据
- (NSURLSessionDataTask *) POST:(NSString *)functionID
                        parameters:(NSDictionary *)parameters
                        success:(FEHTTPAPISuccessBlock)success
                        failure:(FEHTTPAPIFailBlock)failure
                        cancle:(FEHTTPAPICancel)cancle;

#pragma mark 上传

- (NSURLSessionDataTask *)upload:(NSString *)functionID
        images:(NSArray *)images
        parameters:(NSDictionary *)para
        success:(FEHTTPAPISuccessBlock)success
        failure:(FEHTTPAPIFailBlock)failure
        progress:(FEHTTPAPIProgress)progress
        cancle:(FEHTTPAPICancel)cancle;

- (NSURLSessionDataTask *)upload:(NSString *)functionID
        image:(UIImage *)image
        parameters:(NSDictionary *)para
        success:(FEHTTPAPISuccessBlock)success
        failure:(FEHTTPAPIFailBlock)failure
        progress:(FEHTTPAPIProgress)progress
        cancle:(FEHTTPAPICancel)cancle;
//上传image至url地址，不做任何格式校验
- (NSURLSessionDataTask *)uploadService:(NSString *)url
                image:(UIImage *)image
        imageFileName:(NSString *)fileName
           parameters:(NSDictionary *)para
             progress:(FEHTTPAPIProgress)progress
              success:(FEHTTPAPISuccessBlock)success
              failure:(FEHTTPAPIFailBlock)failure
               cancle:(FEHTTPAPICancel)cancle;


#pragma mark 下载

- (NSURLSessionDownloadTask *)download:(NSString *)downloadUrl
        fileFolder:(NSString *)fileFolder
        fileName:(NSString *)fileName
        success:(FEHTTPAPIDownSuccessBlock)success
        progress:(FEHTTPAPIProgress)progress
        failure:(FEHTTPAPIFailBlock)failure
        cancle:(FEHTTPAPICancel)cancle;


- (NSURLSessionDownloadTask *)download:(NSString*)functionID
        fileFolder:(NSString*)fileFolder
        parameters:(NSDictionary*)para
        success:(FEHTTPAPIDownSuccessBlock)success
        progress:(FEHTTPAPIProgress)progress
        failure:(FEHTTPAPIFailBlock)failure
        cancle:(FEHTTPAPICancel)cancle;


- (NSString*) userAgent;
//处理报文入参
- (NSDictionary *) wrapParameters:(NSDictionary*)parameters;

//处理响应报文
- (void) analysisResponse:(id)responseObject succ:(FEHTTPAPISuccessBlock) successBlock fail:(FEHTTPAPIFailBlock)failureBlock;

@end


NS_ASSUME_NONNULL_END
