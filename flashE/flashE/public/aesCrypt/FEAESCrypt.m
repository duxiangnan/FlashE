//
//  FEAESCrypt.m
//  Gurpartap Singh
//
//  Created by Gurpartap Singh on 06/05/12.
//  Copyright (c) 2012 Gurpartap Singh
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "FEAESCrypt.h"
#import "NSData+FECommonCrypto.h"
#import "NSData+FEBase64.h"
#import "GTMDefines.h"

@implementation FEAESCrypt

+ (NSString *)encrypt:(NSString *)message password:(NSString *)password {
    NSData *encryptedData = [[message dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptedDataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];
    NSString *base64EncodedString = [GTMBase64 stringByEncodingData:encryptedData];
    
//    [NSString base64StringFromData:encryptedData length:[encryptedData length]];

    return base64EncodedString;
}

+ (NSString *)decrypt:(NSString *)base64EncodedString password:(NSString *)password {
    NSData *encryptedData = [NSData base64DataFromString:base64EncodedString];
    NSData *decryptedData = [encryptedData decryptedAES256DataUsingKey:[[password dataUsingEncoding:NSUTF8StringEncoding] SHA256Hash] error:nil];

    return [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
}

+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {
    //    NSString *const kInitVector = @"1234567899876543";
    if (content.length <= 0) {
        return @"";
    }

    Byte            array[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    NSData          *initVector = [NSData dataWithBytes:array length:sizeof(array)];
    size_t const    kKeySize = kCCKeySizeAES128;
    NSData          *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger      dataLength = contentData.length;

    // 为结束符'\0' +1
    char keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

    // 密文长度 <= 明文长度 + BlockSize
    size_t  encryptSize = dataLength + kCCBlockSizeAES128;
    void    *encryptedBytes = malloc(encryptSize);
    size_t  actualOutSize = 0;

    //    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];

    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
            kCCAlgorithmAES,
            kCCOptionPKCS7Padding,                                // 系统默认使用 CBC，然后指明使用 PKCS7Padding
            keyPtr,
            kKeySize,
            initVector.bytes,
            contentData.bytes,
            dataLength,
            encryptedBytes,
            encryptSize,
            &actualOutSize);

    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        return [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }

    free(encryptedBytes);
    return @"";
}

+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key {
    // 把 base64 String 轉換成 Data
    //    NSString *const kInitVector = @"1234567899876543";
    if (content.length <= 0) {
        return @"";
    }

    Byte            array[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
    NSData          *initVector = [NSData dataWithBytes:array length:sizeof(array)];
    size_t const    kKeySize = kCCKeySizeAES128;
    NSData          *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSUInteger      dataLength = contentData.length;
    char            keyPtr[kKeySize + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    size_t  decryptSize = dataLength + kCCBlockSizeAES128;
    void    *decryptedBytes = malloc(decryptSize);
    size_t  actualOutSize = 0;
    //    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
            kCCAlgorithmAES,
            kCCOptionPKCS7Padding,
            keyPtr,
            kKeySize,
            initVector.bytes,
            contentData.bytes,
            dataLength,
            decryptedBytes,
            decryptSize,
            &actualOutSize);

    if (cryptStatus == kCCSuccess) {
        return [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:decryptedBytes length:actualOutSize] encoding:NSUTF8StringEncoding];
    }

    free(decryptedBytes);
    return @"";
}

@end
