//
//  UILabel+AttributedString.m
//  RFlashBuy
//
//  Created by hanson on 16/7/14.
//  Copyright © 2016年 JD. All rights reserved.
//

#import "UILabel+AttributedString.h"

@implementation UILabel (AttributedString)

- (void)appendAttriString:(NSString *)txt color:(UIColor *)color font:(UIFont *)font {
    if (txt.length == 0) {
        return;
    }

    NSAttributedString *attriText = self.attributedText;
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc]init];

    if (attriText.string.length > 0) {
        [ret appendAttributedString:attriText];
    }

    NSDictionary *attriDic = @{NSFontAttributeName:font,
                                NSForegroundColorAttributeName:color};
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:txt attributes:attriDic];
    [ret appendAttributedString:attriString];
    self.attributedText = ret;
}

- (void)appendAttriString:(NSAttributedString *)attrTxt {
    if (attrTxt.length == 0) {
        return;
    }

    NSAttributedString *attriText = self.attributedText;
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc]init];

    if (attriText.string.length > 0) {
        [ret appendAttributedString:attriText];
    }

    [ret appendAttributedString:attrTxt];
    self.attributedText = ret;
}

- (void)appendUnderLineAttriString:(NSString *)attrTxt
                             color:(UIColor *)color
                              font:(UIFont *)font {
    if (attrTxt.length == 0) {
        return;
    }

    NSAttributedString *attriText = self.attributedText;
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc]init];

    if (attriText.string.length > 0) {
        [ret appendAttributedString:attriText];
    }

     NSDictionary *attriDic = @{NSFontAttributeName:font,
                                 NSForegroundColorAttributeName:color,
                                 NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
     };
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:attrTxt attributes:attriDic];
    [ret appendAttributedString:attriString];
    self.attributedText = ret;
}

@end
