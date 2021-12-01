//
//  FEDefineModule.m
//
//
// 组件输出类, 可引入JDRouter组件, 进行组件间通信

#import <Foundation/Foundation.h>
#import "FEDefineModule.h"
#import "FEAESCrypt.h"


@implementation FEDefineModule

+ (void) load {
    NSInteger number = [[NSUserDefaults standardUserDefaults] integerForKey:@"definePlistNumber"];
    NSString *plistPath = [[NSBundle bundleForClass:self] pathForResource:@"definePlist"ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSNumber* num = dictionary[@"definePlistNumber"];
    if (number != num.integerValue) {
        __block BOOL hasSetedConfig = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasSetedConfig"];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (!hasSetedConfig) {
                 [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
                if ([key isEqualToString:@"debug_mode"]) {
                    hasSetedConfig = YES;
                    [[NSUserDefaults standardUserDefaults] setBool:hasSetedConfig forKey:@"hasSetedConfig"];
                }
            } else if(![key isEqualToString:@"debug_mode"]) {
                [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
            }
        }];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (BOOL)setDebug_mode:(NSString *)debug_mode{
    [[NSUserDefaults standardUserDefaults] setObject:debug_mode forKey:KDEBUGMODE];
    return [[NSUserDefaults standardUserDefaults]synchronize];
}

+ (NSString *)debug_mode{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"debug_mode"];
}

+ (NSString *)JD_DES_KEY{
    NSString *sceret =  [[NSUserDefaults standardUserDefaults] objectForKey:@"JD_DES_KEY"];
    return [FEAESCrypt decryptAES:sceret key:@"114eead8-66f5-fa"] ;
}
+ (NSString *)JD_DES_NEWKEY{
    NSString *sceret =  [[NSUserDefaults standardUserDefaults] objectForKey:@"JD_DES_NEWKEY"];
    return [FEAESCrypt decryptAES:sceret key:@"114eead8-66f5-fa"] ;
}
+ (NSString *)VSP_MD5_KEY{
    NSString *sceret =  [[NSUserDefaults standardUserDefaults] objectForKey:@"VSP_MD5_KEY"];
    return [FEAESCrypt decryptAES:sceret key:@"114eead8-66f5-fa"] ;
}
+ (NSString *)baseUrlKey{
    NSString *dictKey;
    if ([[self debug_mode] isEqualToString:@"1"]) {
        dictKey = @"yufabaseUrl";
    }else{
        dictKey = @"baseUrl";
    }
    return dictKey;
}
+ (NSString *)VSP_BASE_SERVER_URL{
    NSDictionary* param = [[NSUserDefaults standardUserDefaults] objectForKey:[FEDefineModule baseUrlKey]];
   return [param objectForKey:@"VSP_BASE_SERVER_URL"];
}


@end
