//
//  FEVerticalAlignmentLabel.m
//  VipServicePlatform
//
//  Created by 杜翔楠 on 2019/5/23.
//  Copyright © 2019年 JD. All rights reserved.
//

#import "FEVerticalAlignmentLabel.h"

@implementation FEVerticalAlignmentLabel
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.verticalAlignment = VerticalAlignmentMiddle;
    }
    return self;
}

- (void)setVerticalAlignment:(FEVerticalAlignment)aVerticalAlignment {
    _verticalAlignment = aVerticalAlignment;
    [self setNeedsDisplay];
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    CGRect textRect = [super textRectForBounds:bounds limitedToNumberOfLines:numberOfLines];
    if (self.verticalAlignment == VerticalAlignmentTop) {
        textRect.origin.y = bounds.origin.y;
    }else if(self.verticalAlignment == VerticalAlignmentBottom){
        textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height;
    }else{
         textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0;
    }
    return textRect;
}

- (void)drawTextInRect:(CGRect)requestedRect {
    CGRect actualRect = [self textRectForBounds:requestedRect
                         limitedToNumberOfLines:self.numberOfLines];

    [super drawTextInRect:actualRect];
}

@end
