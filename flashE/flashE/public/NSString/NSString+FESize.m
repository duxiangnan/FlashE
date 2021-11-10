//
//  NSString+FESize.m
//  Pods-VSPNSStringModule_Example
//
//  Created by 杜翔楠 on 2020/4/9.
//

#import "NSString+FESize.h"

@implementation NSString (FESize)
//用对象的方法计算文本的大小
- (CGSize)sizeWithFont:(UIFont*)font
            andMaxSize:(CGSize)size {
    
       //特殊的格式要求都写在属性字典中
      NSDictionary*attrs =@{NSFontAttributeName: font};
      //返回一个矩形，大小等于文本绘制完占据的宽和高。
      return  [self  boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin
                               attributes:attrs
                                  context:nil].size;
}

+ (CGSize)sizeWithString:(NSString*)str
                 andFont:(UIFont*)font
              andMaxSize:(CGSize)size {
    
      NSDictionary*attrs =@{NSFontAttributeName: font};
      return  [str boundingRectWithSize:size
                                options:NSStringDrawingUsesLineFragmentOrigin
                             attributes:attrs
                                context:nil].size;
}
@end
