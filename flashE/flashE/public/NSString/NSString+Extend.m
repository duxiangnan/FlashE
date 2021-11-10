//
// NSString+Extend.m
// CoreCategory
//
// Created by 成林 on 15/4/6.
// Copyright (c) 2015年 沐汐. All rights reserved.
//

#import "NSString+Extend.h"
#import <Foundation/Foundation.h>

#import <sys/utsname.h>

#import "RegexKitLite.h"

@implementation NSString (Extend)

+ (BOOL)isEmptyString:(NSString *)str
{
    if (!str) {
        return YES;
    }

    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }

    if (!str.length) {
        return YES;
    }

    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmedStr = [str stringByTrimmingCharactersInSet:set];

    if (!trimmedStr.length) {
        return YES;
    }

    return NO;
}


#define REGEX_URL   @"((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((:[0-9]+)?)((?:\\/[\\+~%\\/\\.\\w\\-]*)?\\??(?:[\\-\\+=&;%@\\.\\w]*)#?(?:[\\.\\!\\/\\\\\\w]*))?)"
#define REGEX_email @"^\\w+((-\\w+)|(\\.\\w+))*\\@[A-Za-z0-9]+((\\.|-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$"   // 邮件
#define REGEX_num1  @"^[1-9]\\d*|0$"                                                                    // 正数（正整数 + 0）
//
//// 系统版本大于等于多少 >=
//#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

- (BOOL)isURL {
    return [self isMatchedByRegex:REGEX_URL];
}

- (BOOL)isAdURL {
    // 判断首页广告位网页 URL 是否合法
    return [self hasPrefix:@"http://"] || [self hasPrefix:@"https://"];
}

- (BOOL)isEmail {
    return [self isMatchedByRegex:REGEX_email];
}

- (BOOL)isNum {
    return [self isMatchedByRegex:REGEX_num1];
}

- (BOOL)validPassword {
    //    @"^[A-Za-z0-9]{6,20}$"
    return [self isMatchedByRegex:@"^.{6,20}$"];
}


// * 1. 电话号码字符串从右开始计数，从第4位开始用*代替电话号码
// * 2. 电话号码<=4，不展示*
 // * 3. 4<电话号码 <=9,连续替换3位
 // * 4. 电话号码 =10，连续替换4位
 // * 5. 电话号码=11，连续替换5位
 // * 6. 电话号码=12，连续替换6位
 // * ………………
 // * 10. 电话号码=16，连续替换10位
 // * 如：123 456 789 ，显示为 123 *** 789
 // * 如：123 456 789 012 345 显示为 123 ********* 789
 
- (NSString *)stringToPhoneFormat {
    NSInteger   startLen = 0;   // 星号的长度
    NSInteger   actLen = 0;     // 显示字符长度

    if (self.length <= 4) {
        startLen = 0;
    } else if ((self.length > 4) && (self.length <= 9)) {
        startLen = 3;
        actLen = (self.length - 3) / 2;
    } else {
        startLen = self.length - 6;
        actLen = 3;
    }

    if (startLen == 0) {
        return self;
    } else {
        NSMutableString *ret = [NSMutableString string];
        NSRange         range;
        range.length = actLen;
        range.location = 0;
        [ret appendString:[self substringWithRange:range]];

        for (int i = 0; i < startLen; i++) {
            [ret appendString:@"*"];
        }

        range.location = self.length - actLen;
        [ret appendString:[self substringWithRange:range]];
        return ret;
    }
}

- (NSString *)stringToEmailStarFormat {
    if ([self isEmail]) {
        NSRange atRange = [self rangeOfString:@"@"];

        if (atRange.location != NSNotFound) {
            NSInteger starNum = atRange.location;

            if (starNum > 1) {
                NSMutableString *ret = [NSMutableString string];
                NSRange         range;
                range.length = 1;
                range.location = 0;
                [ret appendString:[self substringWithRange:range]];

                for (int i = 0; i < starNum - 1; i++) {
                    [ret appendString:@"*"];
                }

                range.location = atRange.location;
                range.length = self.length - starNum;
                [ret appendString:[self substringWithRange:range]];
                return ret;
            }
        }

        return self;
    }

    return self;
}


- (BOOL)validString {
    NSString *string = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (string.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)trimWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


+ (BOOL)stringContainsEmoji:(NSString *)string {
    
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    if (returnValue) {
        return returnValue;
    }else{
        NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        BOOL isMatch = [pred evaluateWithObject:string];
        return isMatch;
    }

}

@end
