//
//  FEDefineModule.h
//
//
//

/*
 头文件中不需要暴露，或者引入任何资源
 */
#import "defines.h"
#import <Foundation/Foundation.h>

#define KDEBUGMODE @"debug_mode"
#define KAPOLLOMODE @"apollo_mode"
@interface FEDefineModule : NSObject

/// 设置环境
+ (BOOL)setDebug_mode:(NSString *)debug_mode;
+ (NSString *)debug_mode;
+ (NSString *)JD_DES_KEY;
+ (NSString *)JD_DES_NEWKEY;
+ (NSString *)VSP_MD5_KEY;
//baseUrl
+ (NSString *)VSP_BASE_SERVER_URL;
+ (NSString *)VSPCookieDomain;



@end
