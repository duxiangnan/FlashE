//
//  FEHomeVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/5.
//

#import "FEHomeVC.h"
#import <FFRouter/FFRouter.h>
#import <Masonry/Masonry.h>
#import "FEDefineModule.h"
#import "UIButtonModule-umbrella.h"

@interface FEHomeVC ()
@property (nonatomic, strong) UIView* naviView;
@end

@implementation FEHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@(kHomeNavigationHeight));
    }];
}
- (void) viewDidLayoutSubviews {
    
    
}
- (void)naviLeftAction:(id)sender {
    [FFRouter routeURL:@"deckControl://show"];
    
}


- (UIView*) naviView {
    if (!_naviView) {
        _naviView = [[UIView alloc] init];
        _naviView.backgroundColor = [UIColor whiteColor];
        UIView* bgView = [[UIView alloc] init];
        bgView.backgroundColor = UIColor.clearColor;
        [_naviView addSubview:bgView];
        [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(_naviView);
            make.height.mas_equalTo(@(44));
        }];
        
        UIButton* leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
        [_naviView addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(naviLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setImage:[UIImage imageNamed:@"navi_left_me"] forState:UIControlStateNormal];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(@(22));
            make.centerY.equalTo(_naviView.mas_centerY);
            make.left.equalTo(_naviView.mas_left).offset(10);
        }];
        
        UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_logo"]];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(111));
            make.height.mas_equalTo(@(22));
            make.centerX.equalTo(_naviView.mas_centerX);
            make.centerY.equalTo(_naviView.mas_centerY);
            
        }];
    }
    return _naviView;
}

@end
