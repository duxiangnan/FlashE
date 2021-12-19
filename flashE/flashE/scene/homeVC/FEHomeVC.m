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
#import "FEPublicMethods.h"
#import "UIButtonModule-umbrella.h"
#import "FEUIView-umbrella.h"
#import "FEAccountManager.h"

#import <JXPagingView/JXPagerView.h>
#import <JXCategoryView/JXCategoryView.h>

#import "FEHomeWorkView.h"
#import "FEHttpPageManager.h"
#import "FEHomeWorkModel.h"
#import "JVRefresh.h"
#import "MBP-umbrella.h"
#import "FEHomeWorkCell.h"


#import <DateTools/DateTools.h>
@interface FEHomeVC ()<JXCategoryViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIView* naviView;
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UIView* bottomView;

@property (nonatomic,strong) JXCategoryNumberView *categoryView;
@property (nonatomic,copy) NSArray *itemArr;

@property (nonatomic,assign) NSInteger lastIndex;

@property (nonatomic, strong) FEHomeWorkModel* model;
@property (nonatomic, strong) FEHttpPageManager* pagesManager;
@property (nonatomic, assign) FEHomeWorkType currentType;



                       
                       
@end

@implementation FEHomeVC
+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
    
        [FFRouter registerObjectRouteURL:@"home://createhome" handler:^id(NSDictionary *routerParameters) {
            FEHomeVC* vc = [[FEHomeVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
}
- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    self.lastIndex = -1;
    self.model = [[FEHomeWorkModel alloc] init];
    
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.height.mas_equalTo(@(kHomeNavigationHeight));
    }];
    [self.view addSubview:self.categoryView];
    
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.view addSubview:self.table];
    [self.view addSubview:self.bottomView];
    self.currentType = homeWorkWaiting;
    
    @weakself(self);
    self.emptyAction = ^{
        @strongself(weakSelf);
        [strongSelf requestShowData];
    };
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestShowData];
}
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.emptyFrame = self.table.frame;
}
- (void)naviLeftAction:(id)sender {
    [FFRouter routeURL:@"deckControl://show"];
    
    
//    self.countArr = @[@(0),@([self.countArr[1] integerValue]+1),@(99),@(110),@(0)];
//    self.categoryView.counts = self.countArr;
//    [self.categoryView reloadData];
//
//
//    [self.categoryView selectItemAtIndex:4];
}

- (void) creatOrderAction:(UIButton*)btn {

    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    if (acc.storeId == 0) {
        //创建店铺
        FEAlertView* alert = [[FEAlertView alloc] initWithTitle:@"温馨提示" message:@"如需发单请先创建店铺"];
        [alert addAction:[FEAlertAction actionWithTitle:@"取消" style:FEAlertActionStyleCancel handler:^(FEAlertAction *action) {
            
        }]];
        [alert addAction:[FEAlertAction actionWithTitle:@"去创建" style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
            
            FEBaseViewController* vc = [FFRouter routeObjectURL:@"store://createStore"];
            [self.navigationController pushViewController:vc animated:YES];
        }]];
        [alert show];
    } else {
        //创建订单
        @weakself(self);
        NSMutableDictionary* arg = [NSMutableDictionary dictionary];
        arg[@"actionComplate"] = ^(NSString* orderId) {
            @strongself(weakSelf);
            [strongSelf requestShowData];
        };
        FEBaseViewController* vc = [FFRouter routeObjectURL:@"order://createOrder" withParameters:arg];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
}
- (void) addCheckAction:(FEHomeWorkOrderModel*)model view:(UIView*)view{
    UIAlertController* actionView = [UIAlertController alertControllerWithTitle:@"选择小费额度"
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [actionView addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *_Nonnull action) {}]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"2元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:2];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"5元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:5];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"10元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:10];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"15元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:15];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"25元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:25];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"50元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:50];
    }]];
    if (actionView.popoverPresentationController) {

        UIPopoverPresentationController *popover = actionView.popoverPresentationController;
        popover.sourceView = view;
        popover.sourceRect = CGRectMake(0,CGRectGetHeight(view.frame)/2,0,0);
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:actionView animated:YES completion:nil];
    
//    2，5，10，15，25，50
}
- (void) requestAddCheck:(FEHomeWorkOrderModel*) model check:(NSInteger) check {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = model.orderId;
    param[@"amount"] = @(check);
    @weakself(self);
    [[FEHttpManager defaultClient] POST:@"/deer/orders/createTipsOrder" parameters:param
                                success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        [MBProgressHUD showMessage:[FEPublicMethods SafeString:response[@"msg"] withDefault:@"操作成功"]];
        [strongSelf requestShowData];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        
    }];
}
- (void)cellCommond:(FEHomeWorkOrderModel*) model type:(FEOrderCommondType)type view:(UIView*)view {
    @weakself(self);
    switch (type) {
        case FEOrderCommondAddCheck:{
            [self addCheckAction:model view:view];
        }break;
        case FEOrderCommondRetry:{
            FEBaseViewController* vc = [FFRouter routeObjectURL:@"order://createOrder"
                                                 withParameters:@{@"orderId":model.orderId}];
            [self.navigationController pushViewController:vc animated:YES];
        }break;
        case FEOrderCommondCallRider:{
            NSString* phone = [NSString stringWithFormat:@"tel://%@",model.courierMobile];
            [FEPublicMethods openUrlInSafari:phone];
        }break;
        case FEOrderCommondCancel:{
            NSMutableDictionary* param = [NSMutableDictionary dictionary];
            param[@"orderId"] = model.orderId;
            param[@"reason"] = @"不要配送";
            
            [[FEHttpManager defaultClient] POST:@"/deer/orders/cancleOrder" parameters:param
                                        success:^(NSInteger code, id  _Nonnull response) {
                @strongself(weakSelf);
                NSDictionary* dic = response[@"data"];
                NSString* title = [FEPublicMethods SafeString:dic[@"title"] withDefault:@"取消结果"];
                NSString* msg = [FEPublicMethods SafeString:dic[@"cancelTips"] withDefault:@"取消成功"];
                FEAlertView* alter = [[FEAlertView alloc] initWithTitle:title message:msg];
                [alter addAction:[FEAlertAction actionWithTitle:@"知道了" style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
                    [strongSelf requestShowData];
                }]];
                [alter show];
            } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
                [MBProgressHUD showMessage:error.localizedDescription];
            } cancle:^{
            }];
        }
        default:
            break;
    }
};


- (void) requestShowData {
    if (self.pagesManager) {
        [self.pagesManager cancleCurrentRequest];
        self.pagesManager = nil;
    }
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    FEAccountModel* account = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    param[@"storeId"] = [NSString stringWithFormat:@"%ld",account.shopId];
    param[@"orderStatus"] = [NSString stringWithFormat:@"%ld",self.currentType];
    param[@"pageIndex"] = @"1";
    param[@"pageSize"] = @"20";
    
    self.pagesManager = [[FEHttpPageManager alloc] initWithFunctionId:@"/deer/orders/getOrderList"
                                                           parameters:param
                                                            itemClass:[FEHomeWorkOrderModel class]];
    self.pagesManager.resultName = @"data.orders";
    @weakself(self);

    void (^loadMore)(void) = ^{
        @strongself(weakSelf);
        if (strongSelf.pagesManager.hasMore) {
            [strongSelf.pagesManager fetchMoreData:^{
                NSDictionary* dic = strongSelf.pagesManager.wholeDict[@"data"];
                [strongSelf resetCountArr:dic[@"counts"]];
                
                strongSelf.model.orders = strongSelf.pagesManager.dataArr;
                if ([strongSelf.pagesManager hasMore]) {
                    [strongSelf.table.mj_footer endRefreshing];
                } else {
                    [strongSelf.table.mj_footer endRefreshingWithNoMoreData];
                }
                
                [strongSelf.table reloadData];
                if (strongSelf.pagesManager.networkError) {
                    [MBProgressHUD showMessage:strongSelf.pagesManager.networkError.localizedDescription];
                }
            }];
        }
    };

    void (^loadFirstPage)(void) = ^{
        @strongself(weakSelf);
        [strongSelf hiddenEmptyView];
        [strongSelf.pagesManager fetchData:^{
            [strongSelf.table.mj_header endRefreshing];
            NSDictionary* dic = strongSelf.pagesManager.wholeDict[@"data"];
            [strongSelf resetCountArr:dic[@"count"]];
            
            strongSelf.model.orders = strongSelf.pagesManager.dataArr;
            
            if (strongSelf.pagesManager.hasMore) {
                strongSelf.table.mj_footer = [JVRefreshFooterView footerWithRefreshingBlock:loadMore
                                                                           noMoreDataString:@"没有更多数据"];
                
            } else {
                [strongSelf.table.mj_footer endRefreshingWithNoMoreData];
            }
            
            [strongSelf.table reloadData];
            if (strongSelf.pagesManager.networkError) {
                [MBProgressHUD showMessage:weakSelf.pagesManager.networkError.localizedDescription];

                if ([strongSelf.model.orders count] <= 0) {
                    [strongSelf showEmptyViewWithType:NO];
                }
            } else if (strongSelf.model.orders.count == 0) {
                [strongSelf showEmptyViewWithType:YES];
            }
        }];
    };

    self.table.mj_header = [JVRefreshHeaderView headerWithRefreshingBlock:loadFirstPage];
    loadFirstPage();
    
}

- (void) resetCountArr:(NSDictionary*)countDic {
    FEHomeWorkCountModel* contModel = [FEHomeWorkCountModel yy_modelWithDictionary:countDic];
    self.model.count = contModel;
    self.categoryView.counts = [self countArr];
    [self.categoryView reloadData];
}



#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FEHomeWorkCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEHomeWorkCell"];
    FEHomeWorkOrderModel* item = self.model.orders[indexPath.row];
    [cell setModel:item];
    @weakself(self);
    cell.cellCommondActoin = ^(FEOrderCommondType type) {
        @strongself(weakSelf);
        [strongSelf cellCommond:item type:type view:cell];
    };
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.orders.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEHomeWorkOrderModel* item = self.model.orders[indexPath.row];
    [FEHomeWorkCell calculationCellHeight:item];
    return item.workCellH;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEHomeWorkOrderModel* item = self.model.orders[indexPath.row];
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = item.orderId;
    @weakself(self);
    param[@"actionComplate"] = ^(NSString* orderId) {
        @strongself(weakSelf);
        [strongSelf requestShowData];
    };
    
    UIViewController* vc = [FFRouter routeObjectURL:@"order://createOrderDetail" withParameters:param];
    [self.navigationController pushViewController:vc animated:YES];
    
//#waring 订单详情
    
    
}




#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    self.navigationController.interactivePopGestureRecognizer.enabled = (index == 0);
    if (self.lastIndex == index) {
        return;
    }
    switch (index) {
        case 0:
            self.emptyTitle = @"暂无待接订单";
            self.currentType = homeWorkWaiting;
            break;
        case 1:
            self.emptyTitle = @"暂无待取件订单";
            self.currentType = homeWorkWaitFetch;
            break;
        case 2:
            self.emptyTitle = @"暂无配送中订单";
            self.currentType = homeWorkWaitSend;
            break;
        case 3:
            self.emptyTitle = @"暂无已取消订单";
            self.currentType = homeWorkCancel;
            break;
        case 4:
            self.emptyTitle = @"暂无已完成订单";
            self.currentType = homeWorkFinish;
            break;
        default:
            break;
    }

    self.lastIndex = index;
    [self requestShowData];
}

//#pragma mark - JXCategoryListContainerViewDelegate
//- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
//    return self.itemArr.count;
//}
//
//- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
//
//    return self.table;
//}


#pragma mark 懒加载



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
        self.lastIndex = _categoryView.defaultSelectedIndex;
        JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
        lineView.indicatorColor = UIColorFromRGB(0x12B398);
        lineView.indicatorWidth = 36;
        _categoryView.indicators = @[lineView];
//        _categoryView.listContainer = self.pagingView;
        
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



-(NSArray *)itemArr{
    if(!_itemArr){
        _itemArr=@[@"待接单",@"待取单",@"配送中",@"已取消",@"已完成"];
    }
    return _itemArr;
}

- (NSArray*) countArr {
    if (self.model.count) {
        NSMutableArray* count = [NSMutableArray array];
        [count addObject:@(self.model.count.waitGrep)];
        [count addObject:@(self.model.count.waitPickup)];
        [count addObject:@(self.model.count.delivery)];
        [count addObject:@(self.model.count.cancel)];
        [count addObject:@(self.model.count.finish)];
        return count;
    } else {
        return @[@(0),@(0),@(0),@(0),@(0)];
    }
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
- (UITableView *) table
{
    if (_table == nil) {
        CGFloat height = kScreenHeight-CGRectGetMaxY(self.categoryView.frame) - 54 - kHomeIndicatorHeight;
        _table = [[UITableView alloc] initWithFrame:
                  CGRectMake(0, CGRectGetMaxY(self.categoryView.frame),
                             kScreenWidth, height)
                      style:UITableViewStylePlain];
        _table.delegate = self;
        _table.dataSource = self;
        _table.backgroundColor = self.view.backgroundColor;
        _table.tableFooterView = [UIView new];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.separatorColor = [UIColor clearColor];
        
        _table.estimatedRowHeight = 0;
        _table.estimatedSectionHeaderHeight = 0;
        _table.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [_table registerClass:[FEHomeWorkCell class] forCellReuseIdentifier:@"FEHomeWorkCell"];
    }
    return _table;
}
- (UIView*) bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.table.frame), kScreenWidth, 54 + kHomeIndicatorHeight)];
        _bottomView.backgroundColor = UIColor.clearColor;

        UIButton* newBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [newBtn setBackgroundColor:UIColorFromRGB(0x283C50)];
        [newBtn setTitle:@"立即发单" forState:UIControlStateNormal];
        newBtn.titleLabel.font = [UIFont mediumFont:16];
        newBtn.frame = CGRectMake(kScreenWidth/4, 10, kScreenWidth/2, 44);
        newBtn.cornerRadius = 22;
        [newBtn addTarget:self action:@selector(creatOrderAction:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:newBtn];
    }
    return _bottomView;
}
@end
