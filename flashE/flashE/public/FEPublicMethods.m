//
//  FEPublicMethods.m
//  JD_AboutUs
//
//  Created by 刘斯基 on 14-6-28.
//  Copyright (c) 2014年 Json--(ljjwj36@gmail.com). All rights reserved.
//

#import "FEPublicMethods.h"
#import "OpenUDID.h"
#import <sys/utsname.h>
#import <objc/message.h>


@implementation FEPublicMethods

// 系统版本:
+ (NSString *)getOsVersion{
    return [UIDevice currentDevice].systemVersion;
}
// 系统名:
+ (NSString *)getOsName{
    return [UIDevice currentDevice].systemName;
}
// 国家代码:
+ (NSString *)getCountryCode{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}
// 语言:
+ (NSString *)getLanguage{
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}




#pragma mark ---ID
// openudid
+ (NSString *)getOpenUDID {
    return [OpenUDID  value];
}


#pragma mark ---磁盘



+ (NSString *)deviceName {
    return [UIDevice currentDevice].name;
}

+ (NSString *)deviceModel {
    return [UIDevice currentDevice].model;
}

+ (NSString *)OSVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)resolution {
    NSInteger screenScale = [self screenScale];
    int width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    int height = CGRectGetHeight([[UIScreen mainScreen] bounds]);

    return [NSString stringWithFormat:@"%d*%d", height *screenScale, width *screenScale];
}

+ (CGFloat)screenScale {
    return [[UIScreen mainScreen] scale];
}

+ (NSString *)deviceModelName {
    struct utsname systemInfo;

    uname(&systemInfo);

    NSString *code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return code;
}

+ (NSString *)clientVersion {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)clientBuild {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)client {
    return @"fe_ios";
}

+ (NSString *)channelID {
    return @"appstore";
}


+ (BOOL) isPadDeveice {
    return [[FEPublicMethods deviceModel] containsString:@"iPad"];
}

+ (BOOL) isPhoneAndPodDeveice {
    NSString* str = [FEPublicMethods deviceModel];
    return [str containsString:@"iPhone"] || [str containsString:@"iPod"];
}

+ (NSDictionary *)specialParams {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client"] = [FEPublicMethods client];
    params[@"clientVersion"] = [FEPublicMethods clientVersion];

    params[@"uuid"] = [FEPublicMethods getOpenUDID];
    params[@"osVersion"] =  [FEPublicMethods OSVersion];
    params[@"deviceName"] = [UIDevice currentDevice].name;
    params[@"deviceModel"] = [UIDevice currentDevice].model;
    params[@"lang"] = [[NSLocale currentLocale] localeIdentifier];
    params[@"screen"] = [FEPublicMethods SafeString:[FEPublicMethods resolution]];
    params[@"partner"] = [FEPublicMethods SafeString:[FEPublicMethods channelID]];
   
    return params;
}


+ (NSString *)delSpace:(NSString *)oldStr {
    NSString *newStr;

    if (oldStr.length == 0) {
        newStr = @"";
    } else {
        newStr = [oldStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    }

    return newStr;
}
+ (NSString *)SafeString:(NSString *)object withDefault:(NSString*)defaultStr {
    if ([object isKindOfClass:[NSString class]]) {
        if (object.length == 0 && ![object isEqualToString:defaultStr]) {
            return defaultStr;
        }
        return object;
    }
    return defaultStr;
}
+ (NSString *)SafeString:(NSString *)object {
    return [FEPublicMethods SafeString:object withDefault:@""];
}
+ (NSInteger)SafeGetIntValue:(NSString *)object {
    if (object != nil && [object respondsToSelector:@selector(intValue)]) {
        return [object intValue];
    }
    return 0;
}
+ (CGFloat)SafeGetFloatValue:(NSString *)object {
    if (object != nil && [object respondsToSelector:@selector(floatValue)]) {
        return [object floatValue];
    }
    return 0.0;
}
+ (NSDictionary *)SafeGetDictionaryValue:(NSDictionary *)object {
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    }
    return nil;
}
+ (NSDate *)SafeGetDateValue:(NSDate *)object {
    if ([object isKindOfClass:[NSDate class]]) {
        return object;
    }
    return nil;
}
+ (NSArray *)SafeGetArrayValue:(NSArray *)object {
    if ([object isKindOfClass:[NSArray class]] ) {
        return object;
    }
    return nil;
}
+ (NSString *)SafeGetStringValue:(NSString *)object {
    if (object != nil && ![object isKindOfClass:[NSNull class]]) {
        
        if ([object isKindOfClass:[NSString class]]) {
            return  object;
        } else if([object respondsToSelector:@selector(stringValue)]){
            return [object performSelector:@selector(stringValue)];
        }
        return @"";
    }
    return @"";
}
+ (BOOL)SafeGetBOOLValue:(NSString *)object {
    if (object != nil && [object respondsToSelector:@selector(stringValue)]) {
        return [object boolValue];
    }
    return NO;
}



// 判断中英混合的的字符串长度及字符个数
+ (HWTitleInfo)getInfoWithText:(NSString *)text maxLength:(NSInteger)maxLength
{
    HWTitleInfo title;
    int length = 0;
    int singleNum = 0;
    int totalNum = 0;
    char *textChar = (char *)[text cStringUsingEncoding:NSUnicodeStringEncoding];

    for (int i = 0; i < [text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding]; i++) {
        if (*textChar) {
            length++;
            if (length <= maxLength) {
                totalNum++;
            }
        } else {
            if (length <= maxLength) {
                singleNum++;
            }
        }
        textChar++;
    }
    title.length = length;
    title.number = (totalNum - singleNum) / 2 + singleNum;
    return title;
}

// 数字串格式转换
+ (NSString *)changeNumberFormate:(double)number {
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.formatWidth = 20;// 格式宽度
    numberFormatter.paddingCharacter = @"";
    // 填充位置
    numberFormatter.decimalSeparator = @".";        // 小数点样式
    numberFormatter.zeroSymbol = @"0.00";           // 零的样式
    numberFormatter.positivePrefix = @"";           // 正数
    numberFormatter.positiveSuffix = @"";
    numberFormatter.negativePrefix = @"-";          // 负数
    numberFormatter.negativeSuffix = @"";
    numberFormatter.maximumIntegerDigits = 10;      // 整数最多位数
    numberFormatter.minimumIntegerDigits = 1;       // 整数最少位数
    numberFormatter.maximumFractionDigits = 2;      // 小数位最多位数
    numberFormatter.minimumFractionDigits = 2;      // 小数位最少位数
    numberFormatter.groupingSize = 3;               // 数字分割的尺寸
    numberFormatter.secondaryGroupingSize = 3;      // 除了groupingSize决定的尺寸外,其他数字位分割的尺寸
    numberFormatter.maximumSignificantDigits = 18;  // 最大有效数字个数
    numberFormatter.minimumSignificantDigits = 3;   // 最少有效数字个数
    NSString *string = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:number]];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *arr = [string componentsSeparatedByString:@"."];

    if (arr.count == 1) {
        string = [string stringByAppendingString:@".00"];
    } else {
        NSString *integerDigitsStr = arr.firstObject;
        NSString *fractionDigitsStr = arr.lastObject;
        fractionDigitsStr = [fractionDigitsStr stringByAppendingString:@"00000"];
        fractionDigitsStr = [fractionDigitsStr substringToIndex:2];
        string = [NSString stringWithFormat:@"%@.%@", integerDigitsStr, fractionDigitsStr];
    }

    return string;
}

+ (NSString *)changeNumberStringFormate:(NSString *)numStr {
    if (numStr.length == 0) {
        return @"0.00";
    }

    NSString *string = numStr;
    NSArray *arr = [string componentsSeparatedByString:@"."];

    if (arr.count == 1) {
        string = [string stringByAppendingString:@".00"];
    } else {
        NSString *integerDigitsStr = arr.firstObject;
        NSString *fractionDigitsStr = arr.lastObject;
        fractionDigitsStr = [fractionDigitsStr stringByAppendingString:@"00000"];
        fractionDigitsStr = [fractionDigitsStr substringToIndex:2];
        string = [NSString stringWithFormat:@"%@.%@", integerDigitsStr, fractionDigitsStr];
    }

    double numberSrc = string.doubleValue;
    return [self changeNumberFormate:numberSrc];
}



+ (NSString *)makeEmailDesensitization:(NSString *)email {
    NSInteger length = email.length;
    NSString *string = @"";
    NSInteger lengthRange = length;

    if (lengthRange > 7) {
        lengthRange = 7;
    }

    if (length >= 4) {
        string = [email stringByReplacingCharactersInRange:NSMakeRange(3, lengthRange - 4)
                                                withString:@"****"];
    } else if (length >= 2) {//不足四位邮箱  前一位
        string = [email stringByReplacingCharactersInRange:NSMakeRange(1, length - 1)
                                                withString:@"****"];
    }

    return string;
}

+ (NSString *)makeTelephoneDesensitization:(NSString *)telePhone
{
    NSString *telePhoneNumber = @"";

    // 保证7位数字能被替换
    if (telePhone.length >= 7) {
        telePhoneNumber = [telePhone stringByReplacingCharactersInRange:
                           NSMakeRange(3, 4) withString:@"****"];
    }

    return telePhoneNumber;
}



+ (NSDictionary *)getURLFromStr:(NSString *)string {
    return [self getURLFromStr:string queryDeCode:NO];
}
+ (NSDictionary *)getURLFromStr:(NSString *)string queryDeCode:(BOOL) queryDecode{

    if (string.length == 0) {
        return @{};
    }

    BOOL schemeFlag = [string containsString:@"://"];
    BOOL pathFlag = [string containsString:@"?"];

    if (!schemeFlag && !pathFlag) {
        return @{@"scheme":string};
    }

    NSMutableDictionary *queryParams = [[NSMutableDictionary alloc] init];
    // scheme
    NSArray *scheme = [string componentsSeparatedByString:@"://"];

    if ((scheme.count > 0) && schemeFlag) {
        queryParams[@"scheme"] = scheme[0];
    }

    NSString *unScheme = string;

    if (scheme.count > 1) {
        unScheme = [string substringFromIndex:((NSString *)scheme[0]).length + 3];
    }

    //    path

    if (unScheme.length == 0) {
        return queryParams;
    }

    NSArray *path = [unScheme componentsSeparatedByString:@"?"];

    if (path.count > 0) {
        queryParams[@"hostAndPath"] = path[0];
    }

    //    query
    if (path.count > 1) {
        NSArray *queryArr = [path[path.count - 1] componentsSeparatedByString:@"&"];
        NSMutableArray *queryResult = [NSMutableArray arrayWithCapacity:1];
        queryParams[@"query"] = queryResult;
        [queryArr enumerateObjectsUsingBlock:
         ^(NSString *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:1];
            NSArray *arr = [obj componentsSeparatedByString:@"="];

            if (arr.count > 1) {
                NSString *key = arr[0];
                dic[@"key"] = key;
                NSString* value = [obj substringFromIndex:key.length + 1];
                if (queryDecode) {
                    value = [value stringByRemovingPercentEncoding];
                }
                dic[@"value"] = value;//[obj substringFromIndex:key.length + 1];
            } else if (arr.count > 0) {
                dic[@"key"]=arr[0];
                dic[@"value"] = @"";
            }

            [queryResult addObject:dic];
        }];
    }

    return queryParams.copy;
}
+ (nullable UIViewController *)topmostViewController {
    UIViewController *rootViewContoller =
        [UIApplication sharedApplication].delegate.window.rootViewController;

    if (!rootViewContoller ||
        (![rootViewContoller isKindOfClass:[UITabBarController class]] &&
         ![rootViewContoller isKindOfClass:[UINavigationController class]])) {
        return nil;
    }

    UINavigationController *rootNavController =
        (UINavigationController *)[self topmostPresentedController:rootViewContoller];

    if (rootNavController == nil) {
        rootNavController = (UINavigationController *)rootViewContoller;
    }

    if ([rootNavController isKindOfClass:[UITabBarController class]]) {
        UIViewController *selectedViewController =
            [(UITabBarController *)rootNavController selectedViewController];

        rootNavController =
            (UINavigationController *)[self topmostPresentedController:selectedViewController];

        if (rootNavController == nil) {
            rootNavController = (UINavigationController *)selectedViewController;
        }
    }

    if (!rootNavController) {
        return nil;
    }

    UINavigationController *navController = rootNavController;

    while ([navController isKindOfClass:[UINavigationController class]]) {
        UIViewController *topViewController = [navController topViewController];

        UIViewController *presentedController = [self topmostPresentedController:topViewController];

        if (presentedController != nil) {
            topViewController = presentedController;
        }

        navController = (UINavigationController *)topViewController;
    }

    return (UIViewController *)navController;
}

+ (nullable UIViewController *)topmostPresentedController:(UIViewController *)baseController {
    UIViewController    *presentedViewController = baseController.presentedViewController;
    UIViewController    *topmostPresentedController = nil;

    while (presentedViewController) {
        topmostPresentedController = presentedViewController;
        presentedViewController = topmostPresentedController.presentedViewController;
    }

    return topmostPresentedController;
}

+ (void)openUrlInSafari:(NSString *)url {
    if ((url.length < 0) || ![url isKindOfClass:[NSString class]]) {
        return;
    }
    NSURL *URL = [NSURL URLWithString:url];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:URL options:@{}
                                 completionHandler:^(BOOL success) {}];
    } else {
        // Fallback on earlier versions
    }
#else
        [[UIApplication sharedApplication] openURL:URL];
#endif
}

/** 渐变色 */
+ (void)setGradualChangingColor:(UIView *)view fromColor:(NSInteger)fromHexColorStr toColor:(NSInteger)toHexColorStr{
    //    CAGradientLayer类对其绘制渐变背景颜色、填充层的形状(包括圆角)
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[
           (__bridge id)UIColorFromRGB(fromHexColorStr).CGColor,
           (__bridge id)UIColorFromRGB(toHexColorStr).CGColor
       ];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0.0,@1.0];
    [view.layer insertSublayer:gradientLayer atIndex:0];

    
}
/** 渐变色 */
+ (void)setGradualChangingColor:(UIView *)view sColor:(UIColor*)sColor eColor:(UIColor*)eColor{
    if (!sColor || !eColor) {
        return;
    }
    __block CAGradientLayer* oldLayer = nil;
    [view.layer.sublayers enumerateObjectsUsingBlock:
     ^(__kindof CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"FE_gradualChanging"]) {
            oldLayer = obj;
        }
    }];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.name = @"FE_gradualChanging";
    gradientLayer.frame = view.bounds;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[
           (__bridge id)sColor.CGColor,
           (__bridge id)eColor.CGColor
       ];
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    //  设置颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@0.0,@1.0];
    if (oldLayer) {
        [view.layer replaceSublayer:oldLayer with:gradientLayer];
    } else {
        [view.layer insertSublayer:gradientLayer atIndex:0];
    }
    

    
}


//兼容url中//不进行转义  现只兼容一层字典 不支持多级嵌套
+ (NSString *)dictToStrWithDict:(NSDictionary *)dict{
   
    return [self dictToStr:dict];
}
+ (NSString * )dictToStr:(NSDictionary *)dict{
    
    if ([dict isKindOfClass:[NSString class]]) {
        return (NSString*)dict;
    }
    if (dict.allKeys.count == 0) {
           return @"{}";
       }
       NSMutableString * mStr = [[NSMutableString alloc]initWithString:@"{"];
       for (NSString * strTem in dict.allKeys) {
           if ([dict[strTem] isKindOfClass:[NSString class]]) {
               [mStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",
                                   strTem,[self dictToStr:dict[strTem]]]];
           }else if ([dict[strTem] isKindOfClass:[NSArray class]]){
               NSArray * arrTem  = dict[strTem];
               [mStr appendString:[NSString stringWithFormat:@"\"%@\":[",strTem]];
               for (NSDictionary * temdict in arrTem) {
                  [mStr appendString:[NSString stringWithFormat:@"%@,",
                                      [self dictToStr:temdict]]];
               }
               mStr = [mStr substringWithRange:NSMakeRange(0, [mStr length] - 1)].mutableCopy;
               [mStr appendString:@"],"];
           }else if ([dict[strTem] isKindOfClass:[NSDictionary class] ]){
               [mStr appendString:[NSString stringWithFormat:@"\"%@\":%@,",
                                   strTem,[self dictToStr:dict[strTem]]]];
           }else if ([dict[strTem] isKindOfClass:[NSNumber class]]){
               [mStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",
                                   strTem,dict[strTem]]];
           }
       }
       mStr = [mStr substringWithRange:NSMakeRange(0, [mStr length] - 1)].mutableCopy;
       [mStr appendString:@"}"];
       NSString * str = mStr.copy;
       return str;
}


+ (BOOL) canRemoveKVO:(NSObject*)object forKey:(NSString *)key
{
    id info = object.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([key isEqualToString:keyPath]) {
            return YES;
        }
    }
    return NO;
}

/**
 获取通用UA数据数组
 webUA：浏览器内核自带部分
 */
+ (NSArray*) getUniversallyUA:(NSString*)webUA {
    NSMutableArray* uas = [[NSMutableArray alloc] init];
    [uas addObject:@"FEapp"];
    [uas addObject:@"jdlog"];
    [uas addObject:[FEPublicMethods deviceModel]];
    [uas addObject:[FEPublicMethods clientVersion]];
    [uas addObject:[FEPublicMethods OSVersion]];
    [uas addObject:[FEPublicMethods getOpenUDID]];
    if (webUA.length>0) {
        [uas addObject:webUA];
    }
    return uas.copy;
}

@end
