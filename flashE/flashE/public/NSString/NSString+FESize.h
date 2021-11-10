//
//  NSString+VSPSize.h
//  Pods-VSPNSStringModule_Example
//
//  Created by 杜翔楠 on 2020/4/9.
//

#import  <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString(FESize)

+ (CGSize)sizeWithString:(NSString*)str andFont:(UIFont*)font andMaxSize:(CGSize)size;

- (CGSize)sizeWithFont:(UIFont*)font andMaxSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
