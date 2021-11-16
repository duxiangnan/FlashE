//
//  FEEmptyView.m
//  VipServicePlatform
//
//  Created by JD on 11/7/16.
//  Copyright © 2016 JD. All rights reserved.
//

#import "FEEmptyView.h"

#define EMOTION_WIDTH       120
#define EMOTION_HEIGHT      110
#define NOTICE1_WIDTH       300
#define NOTICE2_WIDTH       190
#define RELOADBTN_WIDTH     130
#define RELOADBTN_HEIGHT    46
#define BUTTON_WIDTH        120


#import "FEDefineModule.h"
#import "FEUIView-umbrella.h"
#import <Masonry/Masonry.h>

@interface FEEmptyView ()

@end

@implementation FEEmptyView

- (instancetype)initWithFrame:(CGRect)frame emptyImage:(NSString *)imageName title:(NSString *)title desc:(NSString *)desc {
    if (self = [super initWithFrame:frame]) {
        _imageName = imageName;
        _title = title;
        _desc = desc;
        self.frame = frame;
        [self initUI];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tap];
    }

    return self;
}

- (void)initUI {
    self.backgroundColor = UIColorFromRGB(0xF3F3F3);

    UIImageView *headerImg = [[UIImageView alloc]init];
    headerImg.clipsToBounds = YES;
    headerImg.tag = 10;
    headerImg.image = [UIImage imageNamed:_imageName];
    headerImg.contentMode = UIViewContentModeCenter;
    [self addSubview:headerImg];

    UILabel *titleLB = [[UILabel alloc]init];
    titleLB.tag = 11;
    titleLB.text = _title;
    titleLB.numberOfLines = 0;
    titleLB.textColor = UIColorFromRGB(0x666666);
    titleLB.font = [UIFont systemFontOfSize:16];
    [titleLB setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:titleLB];

    UILabel *descLB = [[UILabel alloc]init];
    descLB.tag = 12;
    descLB.numberOfLines = 0;
    descLB.text = _desc;
    descLB.textColor = UIColorFromRGB(0x666666);
    descLB.font = [UIFont systemFontOfSize:16];
    [descLB setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:descLB];
}

-(void) layoutSubviews {
    [super layoutSubviews];
    UIView* headerImg = [self viewWithTag:10];
    UIView* titleLB = [self viewWithTag:11];
    UIView* descLB = [self viewWithTag:12];
    [headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(120);
        make.centerX.equalTo(self.mas_centerX);
        if (self.imageW != 0) {
            make.width.mas_equalTo(@(self.imageW));
        }
        if (self.imageH != 0) {
            make.height.mas_equalTo(@(self.imageH));
        }
    }];
    [titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerImg.mas_bottom).offset(16);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    [descLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLB.mas_bottom).offset(16);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}
- (void)emptyHidden {
    [self removeFromSuperview];
}

- (void) tapAction:(UITapGestureRecognizer*)tap {
    !self.onTapAction?:self.onTapAction();
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    UIImageView* view = [self viewWithTag:10];
    view.image = [UIImage imageNamed:imageName];
}

- (void)setTitle:(NSString *)title{
    _title = title;
    UILabel* lb = [self viewWithTag:11];
    lb.text = title;
    
}
- (void)setDesc:(NSString *)desc {
    _desc = desc;
    UILabel* lb = [self viewWithTag:12];
    lb.text = desc;
}
@end
