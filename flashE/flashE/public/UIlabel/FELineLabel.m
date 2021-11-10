//
//  FELineLabel.m
//  VipServicePlatform
//
//  Created by JD on 9/7/16.
//  Copyright © 2016 JD. All rights reserved.
//

#import "FELineLabel.h"

@implementation FELineLabel

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        self.strikeThroughEnabled = YES;
    }

    return self;
}

- (void)setText:(NSString *)text {
    CGFloat fontSize = self.font ?[self.font pointSize] :[UIFont systemFontSize];
    UIFont  *font = [UIFont fontWithName:@"Heiti SC" size:fontSize];
    UIColor *textColor = self.textColor ? : [UIColor blackColor];
    UIColor *strikeColor = self.strikeThroughColor ? :[textColor colorWithAlphaComponent:0.84];

    NSDictionary *attributes0 = @{NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : textColor,
                                  NSStrikethroughStyleAttributeName : @(NSUnderlineStyleSingle),
                                  NSStrikethroughColorAttributeName : strikeColor};

    NSDictionary *attributes1 = @{NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : textColor,
                                  NSStrikethroughColorAttributeName : strikeColor};

    if (self.strikeThroughEnabled) {
        self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes0];
    } else {
        self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes1];
    }
}

@end
