//
//  FEPublicMethods.h
//  JD_AboutUs
//
//  Created by 刘斯基 on 14-6-28.
//  Copyright (c) 2014年 Json--(ljjwj36@gmail.com). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FEDefineModule.h"

NS_ASSUME_NONNULL_BEGIN


struct HWTitleInfo {
    NSInteger   length;
    NSInteger   number;
};
typedef struct HWTitleInfo HWTitleInfo;

@interface FEPublicMethods : NSObject


// 系统版本: [UIDevice currentDevice].systemVersion
+ (NSString *)getOsVersion;
// 系统名: [UIDevice currentDevice].systemName
+ (NSString *)getOsName;
// 国家代码: [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]
+ (NSString *)getCountryCode;
// 语言:    [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode]
+ (NSString *)getLanguage;

#pragma mark ---ID
// openudid
+ (NSString *)getOpenUDID;


#pragma mark device info
+ (NSString *_Nullable)deviceModelName;

/**
 *    获取设备名
 *
 *    @return    设备名
 */
+ (NSString *)deviceName;

/**
 *    获取设备模型
 *
 *    @return    设备模型
 */
+ (NSString *)deviceModel;

/**
 *    系统版本号
 *
 *    @return    系统版本号
 */
+ (NSString *)OSVersion;

/**
 *   获取client
 *
 *   @return client
 */
+ (NSString *)client;

/**
 *    客户端版本号
 *
 *    @return    客户端版本号
 */
+ (NSString *)clientVersion;

/**
 *    客户端build号
 *
 *    @return    客户端build号
 */
+ (NSString *)clientBuild;
/**
 *
 *    app名称
 *
 *    @return    app名称
 */
+ (NSString *)appName;

/**
 *    屏幕分辨率
 *
 *    @return    屏幕分辨率
 */
+ (NSString *)resolution;

/**
 *    屏幕缩放比例
 *
 *    @return    屏幕缩放比
 */
+ (CGFloat)screenScale;

//判断是否是pad设备
+ (BOOL) isPadDeveice;
//判断是否是iphone和pod设备
+ (BOOL) isPhoneAndPodDeveice;
+ (NSDictionary *)specialParams;



//数据安全处理
+ (NSString *) SafeString:(NSString *)object withDefault:(NSString*)defaultStr;
+ (NSString *) SafeString:(NSString *)object;
+ (NSInteger) SafeGetIntValue:(NSString *)object;
+ (CGFloat) SafeGetFloatValue:(NSString *)object;
+ (NSDictionary *) SafeGetDictionaryValue:(NSDictionary *)object;
+ (NSDate *) SafeGetDateValue:(NSDate *)object;
+ (NSArray *) SafeGetArrayValue:(NSArray *)object;
+ (NSString *) SafeGetStringValue:(NSString *)object;
+ (BOOL) SafeGetBOOLValue:(NSString *)object;
// 判断汉字 字符长度
+ (HWTitleInfo)getInfoWithText:(NSString *)text maxLength:(NSInteger)maxLength;

// 数字串格式转换
+ (NSString *)changeNumberFormate:(double)numStr;
+ (NSString *)changeNumberStringFormate:(NSString *)numStr;
// emil脱敏处理
+ (NSString *)makeEmailDesensitization:(NSString *)email;
// 手机号脱敏
+ (NSString *)makeTelephoneDesensitization:(NSString *)telePhone;


// 解析url string 中的元素
+ (NSDictionary *)getURLFromStr:(NSString *)string;
+ (NSDictionary *)getURLFromStr:(NSString *)string queryDeCode:(BOOL) queryDecode;
// 获取当前视图上层vc
+ (nullable UIViewController *)topmostViewController;
//系统方法打开连接
+ (void)openUrlInSafari:(NSString *_Nullable)url ;

/** 渐变色 */
+ (void)setGradualChangingColor:(UIView *)view
                      fromColor:(NSInteger)fromHexColorStr
                        toColor:(NSInteger)toHexColorStr;
+ (void)setGradualChangingColor:(UIView *)view sColor:(UIColor*)sColor eColor:(UIColor*)eColor;


//兼容url中//不进行转义  现只兼容一层字典 不支持多级嵌套
+ (NSString *)dictToStrWithDict:(NSDictionary *)dict;
//判断object是否可以remove kvo 的key 监听
+ (BOOL) canRemoveKVO:(NSObject*)object forKey:(NSString *)key;


/**
 获取通用UA数据数组
 webUA：浏览器内核自带部分
 */
+ (NSArray*) getUniversallyUA:(NSString*)webUA;

//限定文本最大字长
+ (BOOL) limitTextField:(UITextField*) textView replacementText:(NSString *)text max:(NSInteger)limtNum;

+ (BOOL) limitTextView:(UITextView*) textView replacementText:(NSString *)text max:(NSInteger)limtNum;
@end
NS_ASSUME_NONNULL_END
