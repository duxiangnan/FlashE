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

#import "FEUIView-umbrella.h"

#import <JXPagingView/JXPagerView.h>
#import <JXCategoryView/JXCategoryView.h>

#import "FEHomeWorkView.h"

@interface FEHomeVC ()<JXCategoryListContainerViewDelegate,JXCategoryViewDelegate>
@property (nonatomic, strong) UIView* naviView;
/**
 菜单项View
 */
@property (nonatomic,strong) JXCategoryNumberView *categoryView;
/**
 内容View
 */
@property (nonatomic, strong) JXCategoryListContainerView *pagingView;

@property (nonatomic, strong) NSArray <FEHomeWorkView *> *listViewArray;
@property (nonatomic,copy) NSArray *itemArr;
@property (nonatomic,copy) NSArray *countArr;

@end

@implementation FEHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@(kHomeNavigationHeight));
    }];
    [self.view addSubview:self.categoryView];
    [self.view addSubview:self.pagingView];
}
- (void) viewDidLayoutSubviews {
    
    
}
- (void)naviLeftAction:(id)sender {
    [FFRouter routeURL:@"deckControl://show"];
    
    
    self.countArr = @[@(0),@([self.countArr[1] integerValue]+1),@(99),@(110),@(0)];
    self.categoryView.counts = self.countArr;
    [self.categoryView reloadData];
    
    
    [self.categoryView selectItemAtIndex:4];
}




#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    NSLog(@"滚动索引 %d",index);
}

#pragma mark - JXCategoryListContainerViewDelegate
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.itemArr.count;
}

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {

    return self.listViewArray[index];
}


#pragma mark 懒加载
/**
总视图
 */
-(JXCategoryListContainerView *)pagingView{
    if(!_pagingView){
        //
        _pagingView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
        _pagingView.frame = CGRectMake(0, kHomeNavigationHeight + 40,
                                       kScreenWidth, kScreenHeight - kHomeNavigationHeight - 40);
        _pagingView.backgroundColor = self.view.backgroundColor;
        _pagingView.defaultSelectedIndex = 0;
    }
    return _pagingView;
}

/**
 菜单项视图View
 */
-(JXCategoryNumberView *)categoryView{
    if(!_categoryView){
        _categoryView = [[JXCategoryNumberView alloc] initWithFrame:CGRectMake(0, kHomeNavigationHeight, kScreenWidth, 40)];
        _categoryView.delegate = self;
        _categoryView.titles = self.itemArr;
        _categoryView.backgroundColor = [UIColor whiteColor];
    
        _categoryView.titleColor = UIColorFromRGB(0x555555);
        _categoryView.titleSelectedColor = UIColorFromRGB(0x12B398);
        _categoryView.titleFont = [UIFont systemFontOfSize:14];
        _categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:16];
        _categoryView.titleColorGradientEnabled = YES;
        _categoryView.defaultSelectedIndex = 0;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = UIColorFromRGB(0x12B398);
        lineView.indicatorWidth = 36;
        _categoryView.indicators = @[lineView];
        _categoryView.listContainer = self.pagingView;
        
        self.navigationController.interactivePopGestureRecognizer.enabled = (_categoryView.selectedIndex == 0);
        
        
        _categoryView.counts = self.countArr;
        _categoryView.numberStringFormatterBlock = ^NSString *(NSInteger number) {
            NSString* str = nil;
            if (number>99) {
                str = @"99+";
            } else {
                str = [NSString stringWithFormat:@"%ld",(long)number];
            }
            return str;
        };
        _categoryView.numberLabelFont = [UIFont systemFontOfSize:10];
        _categoryView.numberBackgroundColor = UIColorFromRGB(0xFF5238);
        [_categoryView setupRoundedCornersWithView:_categoryView
                                        cutCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight
                                       cornerRadii:CGSizeMake(15, 15)
                                       borderColor:nil
                                       borderWidth:0
                                         viewColor:_categoryView.backgroundColor];
        _categoryView.clipsToBounds = YES;
        _categoryView.layer.masksToBounds = YES;
    }
    
    return _categoryView;
}

-(NSArray<UIView *> *)listViewArray{
    if(!_listViewArray){
        // 内容视图（通过PageType属性区分页面）
//        CGRect rect=CGRectMake(0, 0, kScreenWidth, kScreenHeight-CGRectGetMaxY(self.naviView.frame)-40);
        FEHomeWorkView *work1 = [[FEHomeWorkView alloc] init];
        work1.type = homeWorkWaiting;
        work1.view.backgroundColor = UIColor.redColor;
        FEHomeWorkView *work2 = [[FEHomeWorkView alloc] init];
        work2.type = homeWorkWaitFetch;
        work2.view.backgroundColor = UIColor.blueColor;
        FEHomeWorkView *work3 = [[FEHomeWorkView alloc] init];
        work3.type = homeWorkWaitSend;
        work3.view.backgroundColor = UIColor.yellowColor;
        FEHomeWorkView *work4 = [[FEHomeWorkView alloc] init];
        work4.type = homeWorkCancel;
        work4.view.backgroundColor = UIColor.greenColor;
        FEHomeWorkView *work5 = [[FEHomeWorkView alloc] init];
        work5.type = homeWorkFinish;
        work5.view.backgroundColor = UIColor.cyanColor;
        
        _listViewArray = @[work1, work2,work3,work4,work5];
    }
    return _listViewArray;
}

-(NSArray *)itemArr{
    if(!_itemArr){
        _itemArr=@[@"待接单",@"待取单",@"配送中",@"已取消",@"已完成"];
    }
    return _itemArr;
}

- (NSArray*) countArr {
    if (!_countArr) {
        _countArr = @[@(0),@(1),@(99),@(110),@(0)];
    }
    return _countArr;
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
            make.centerY.equalTo(bgView.mas_centerY);
            make.left.equalTo(bgView.mas_left).offset(10);
        }];
        
        UIImageView* image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navi_logo"]];
        [_naviView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(@(111));
            make.height.mas_equalTo(@(22));
            make.centerX.equalTo(bgView.mas_centerX);
            make.centerY.equalTo(bgView.mas_centerY);
            
        }];
    }
    return _naviView;
}

@end
