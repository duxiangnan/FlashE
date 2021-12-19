//
//  UILabel+AttributedString.h
//  RFlashBuy
//
//  Created by hanson on 16/7/14.
//  Copyright © 2016年 JD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (AttributedString)

- (void)appendAttriString:(NSString *)txt color:(UIColor *)color font:(UIFont *)font;

- (void)appendAttriString:(NSAttributedString *)attrTxt;

- (void)appendDeleteLineAttriString:(NSString *)attrTxt color:(UIColor *)color font:(UIFont *)font;
@end
