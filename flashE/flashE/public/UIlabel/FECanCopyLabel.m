//
//  FECanCopyLabel.m
//  VipServicePlatform
//
//  Created by hx on 2019/5/10.
//  Copyright © 2019 JD. All rights reserved.
//

#import "FECanCopyLabel.h"

@implementation FECanCopyLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self addCopyAbility];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self addCopyAbility];
    }

    return self;
}

- (void)addCopyAbility
{
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(canAddCopy:)]];
}

- (void)canAddCopy:(UITapGestureRecognizer *)gesture
{
    if (self.text.length>0 ) {
        
        UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];

        if ([self.text componentsSeparatedByString:@"："].count > 1) {
            pastBoard.string = [[self.text componentsSeparatedByString:@"："].lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else if ([self.text componentsSeparatedByString:@":"].count > 1) {
            pastBoard.string = [[self.text componentsSeparatedByString:@":"].lastObject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        } else {
            pastBoard.string = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
    }

    if (self.canAddCopy) {
        self.canAddCopy();
    }
}

@end
