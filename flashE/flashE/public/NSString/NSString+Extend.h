//
//  NSString+Extend.h
//  CoreCategory
//
//  Created by 成林 on 15/4/6.
//  Copyright (c) 2015年 沐汐. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface NSString (Extend)

// 判断字符串是否为空
+ (BOOL)isEmptyString:(NSString *)str;


- (BOOL)isURL;
- (BOOL)isAdURL;
- (BOOL)isEmail;
- (BOOL)isNum;
- (BOOL)validPassword;


- (NSString *)stringToPhoneFormat;
- (NSString *)stringToEmailStarFormat;

- (BOOL)validString;

- (NSString *)trimWhitespace;
//判断是否含有emoji
+ (BOOL)stringContainsEmoji:(NSString *)string;

@end
