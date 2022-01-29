//
//  FEOrderDetailVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/24.
//

#import "FEOrderDetailVC.h"
#import "FEDefineModule.h"
//#import "FEOrderDetailModel.h"
#import "FEOrderMapView.h"
//#import "FEOrderDetailHeaderCell.h"
//#import "FEOrderDetailLogisticsCell.h"
//#import "FEOrderDetailAddressCell.h"
//#import "FEOrderDetailInfoCell.h"
//#import "FEOrderDetailLinkCell.h"

#import <zhPopupController/zhPopupController.h>
#import "FETipModel.h"
#import "FETipSettingView.h"

#import "FEOrderDetailList.h"




@interface FEOrderDetailVC ()<UIGestureRecognizerDelegate,FEOrderDetailListDelegate>
@property (nonatomic,strong)  FEOrderMapView* mapView;
@property (nonatomic,strong) FEOrderDetailList* table;

@property (nonatomic,strong) zhPopupController* popupController;
@property (nonatomic,strong) FETipSettingView* tipView;

@property (nonatomic,assign) CGFloat scrollViewOriginalY;
@property (nonatomic,strong) UIButton *freshBtn;
@property (nonatomic,strong) UIButton *backBtn;

@end

@implementation FEOrderDetailVC

+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
    
        [FFRouter registerObjectRouteURL:@"order://createOrderDetail" handler:^id(NSDictionary *routerParameters) {
            FEOrderDetailVC* vc = [[FEOrderDetailVC alloc] init];
            vc.orderId = routerParameters[@"orderId"];
            vc.actionComplate = routerParameters[@"actionComplate"];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"订单详情";
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.table];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.freshBtn];
    @weakself(self);
    self.emptyAction = ^{
        @strongself(weakSelf);
        [strongSelf.table requestShowData];
    };
    [self addGesture];
    
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.table requestShowData];
}
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.emptyFrame = self.view.frame;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
}

- (void) freshAction:(id)sender {
    [self.table requestShowData];
}
- (void) addCheckAction {
    self.popupController = [[zhPopupController alloc] initWithView:self.tipView
                                                          size:self.tipView.bounds.size];
    self.popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    self.popupController.layoutType = zhPopupLayoutTypeBottom;
    self.popupController.presentationTransformScale = 1.25;
    self.popupController.dismissonTransformScale = 0.85;
    [self.popupController showInView:self.view.window completion:NULL];
}

- (void) updateSubViewFrame {
    CGFloat topy = self.backBtn.center.y - self.freshBtn.height/2;
    
    self.freshBtn.y = MAX(self.table.y - 16 - self.freshBtn.height, topy) ;

}


#pragma mark - scrollview delegate
- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[self.table class]]) {
        if (scrollView.contentOffset.y <= 0) {
            self.table.panGesture.enabled = YES;
        }else {
            self.table.panGesture.enabled = NO;
        }
    }
}


-(void)mainScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (!decelerate) {
//        BOOL dragToDragStop = scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
//        if (dragToDragStop) {
//            [self scrollViewDidEndScroll];
//        }
//    }
}

-(void)mainScrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
//    if (scrollToScrollStop) {
//        [self scrollViewDidEndScroll];
//    }
}


#pragma mark scrollView 滚动停止
- (void)scrollViewDidEndScroll {
    
    //记录之前已曝光的cell
//    NSMutableArray *lastAdInfoIds = [self.mainAdListView.lastAdInfoItemIds copy];
//    //清空，重新记录
//    [self.mainAdListView.lastAdInfoItemIds removeAllObjects];
//    
//    
//    for (NSIndexPath *index in self.mainAdListView.indexPathsForVisibleRows) {
//        
//        UITableViewCell *cell = [self.mainAdListView cellForRowAtIndexPath:index];
//        CGRect cellRect = [cell convertRect:cell.bounds toView:nil];
//        CGRect visibleWindowRect = CGRectMake(0, self.MainTopDropView.bottom+8, ScreenWidth, ScreenHeight-self.MainTopDropView.height-8);
//        
//        //只有漏出来的cell才打点，如果想全部漏出来改为CGRectContainsRect即可
//        if (CGRectIntersectsRect(visibleWindowRect, cellRect)) {
//            
//            if (self.mainAdListView.dataArray.count > 0 && index.row < self.mainAdListView.dataArray.count) {
//                SSAdvertInfoModel *item = self.mainAdListView.dataArray[index.row];
//                
//                
//                if (![lastAdInfoIds containsObject:[SSTool convertNull:item.advertId]]) {//做下已曝光的item记录，避免重复曝光
//                    kStatisticsProperties(StatisticsEventAdvertizement, (@{StatisticsTag:Statistics_AdShow,Statistics_Adv_Id:[SSTool convertNull:item.advertId],Statistics_Adv_Contact_Position:ADTYPE_HOME_LIST,Statistics_Adv_Launch_City:[SSTool convertNull:getCurrentCityName],Statistics_Adv_Operation:Statistics_Adv_Operation_Name,Statistics_Adv_Platform:Statistics_Adv_Platform_Name,Statistics_Adv_Page:Statistics_Adv_HomePage}));
//                    BEIDOU_VIEW_RIST_MANAGEMENT_BURIEDPOINT(BEIDOU_ADV_CONTENT_VIEW, (@{BEIDOU_ADV_ID:[SSTool convertNull:item.advertId],BEIDOU_ADV_CONTENT_POSITION:ADTYPE_HOME_LIST,BEIDOU_ADV_LAUNCH_CITY:[SSTool convertNull:getCurrentCityName],BEIDOU_ADV_OPERATION:BEIDOU_ADV_OPERATION_NAME,BEIDOU_ADV_PLATFORM:BEIDOU_ADV_PLATFORM_NAME,BEIDOU_ADV_PAGE:BEIDOU_ADV_HOMEPAGE}));
//                }
//                
//                [self.mainAdListView.lastAdInfoItemIds addObject:[SSTool convertNull:item.advertId]];
//
//            }
//        }
//        
//    }
}





#pragma mark - 滑动相关
- (void)addGesture {
    
    UIPanGestureRecognizer *pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self.table addGestureRecognizer:pan1];
    pan1.delegate = self;
    self.table.panGesture = pan1;
    [self.table addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:nil];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        //106 blue 644/2 clear
        [self updateSubViewFrame];
//        CGFloat minY = 106 * (kScreenHeight/812);
//        CGFloat maxY = 644/2 * (kScreenHeight/812);
//
//        CGFloat alpha = ( self.table.y - minY) / (maxY - minY);
//
//        alpha = MIN(alpha, 1);
//        alpha = MAX(alpha, 0);
//
//        self.topAdvertisementView.alpha = alpha;
//
//        self.mainAdListBgView.alpha = 1 - alpha;
//
//        //滑动到dropView底下时，将dropView显示出来
//        if (self.table.top < self.MainTopDropView.height) {
//            self.MainTopDropView.hidden = NO;
//        }else {
//            self.MainTopDropView.hidden = YES;
//        }
//
//
//        CGFloat alpha1 = (self.table.y - [self maxListViewTop]/2)/([self maxListViewTop]/2);
//       //644 alpha = 1 644/2 alpha = 0
//        self.mainAdListShadowView.alpha = alpha1;

          
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture {
//    NSLog(@"%s gesture.state %d \n\n,self.panGesture.enabled %d",__func__,gesture.state,self.panGesture.enabled);
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.scrollViewOriginalY = CGRectGetMinY(self.table.frame);
        } break;
        case UIGestureRecognizerStateChanged:
        {
            if (self.table.y <= [self minListViewTop]) {//滑动到最顶部，可以滑动
                self.table.scrollEnabled = YES;
            }else {
                self.table.scrollEnabled = NO;
            }
            UIPanGestureRecognizer * pan = gesture;
            CGPoint offset = [pan translationInView:pan.view];
            if (offset.y < 0) {//up
                self.table.direction = FEOrderDetailDirectionUp;
                if (self.table.listState == FEOrderDetailStateTop) {

                }else if (self.table.listState == FEOrderDetailStateBottom) {
                    //从底下往上滑，需要scrollView跟手指移动
                    [self.table setY:self.scrollViewOriginalY + offset.y];
                }
            }else {//down
                self.table.direction = FEOrderDetailDirectionDown;
                if (self.table.y <= kScreenHeight - 100) {
                    //从上往下滑，需要scrollView跟手指移动
                    [self.table setY:self.scrollViewOriginalY + offset.y];
                }
            }
        } break;
        case UIGestureRecognizerStateEnded:
        {
            [self scrollAdList:self.table];
            self.table.direction = FEOrderDetailDirectionUnknow;
        }break;
        case UIGestureRecognizerStateCancelled:
            break;
        default:
            break;
    }
}


- (void)scrollAdList:(UIScrollView *)scrollView {
    
    if (self.table.scrollEnabled == NO) {
        
        if (self.table.direction == FEOrderDetailDirectionDown) {
            if (self.table.y > [self.mapView getMinHeight]) {
                // 向下滚动
                [self scrollToBottom];
            }else {
                [self scrollToTop];
            }
        } else if (self.table.direction == FEOrderDetailDirectionUp) {
            if (self.scrollViewOriginalY - self.table.y > 50 ) {
                // 向上滚动
                [self scrollToTop];
            } else {
                [self scrollToBottom];
            }
        }
    }
}

/// 广告可滑动的最顶
- (CGFloat)minListViewTop {
    return [self.mapView getMinHeight];
}

/// 广告可滑动的最底
- (CGFloat)maxListViewTop {
    return kScreenHeight-[self.mapView getMaxHeight] - 20;
}


- (void)scrollToTop {
    [UIView animateWithDuration:0.35 animations:^{
        //隐藏首次显示的提示条
        [self.table setY:[self minListViewTop]];
        self.table.listState = FEOrderDetailStateTop;
    } completion:^(BOOL finished) {
        if (self.table.y <= [self minListViewTop]) {
            self.table.scrollEnabled = YES;
        }else {
            self.table.scrollEnabled = NO;
        }
    }];
    
}


- (void)scrollToBottom {

    [UIView animateWithDuration:0.35 animations:^{
        [self.table setY:[self maxListViewTop]];
        self.table.listState = FEOrderDetailStateBottom;
        //setContentOffset是因为在上面时有可能滑动过tableView。
        [self.table setContentOffset:CGPointZero animated:NO];

    }completion:^(BOOL finished) {
        self.table.scrollEnabled = NO;
    }];
}



#pragma mark 懒加载
- (FEOrderDetailList*) table {
    if (!_table) {
        @weakself(self);
        CGRect frame = CGRectMake(0, self.mapView.height, kScreenWidth, kScreenHeight - self.mapView.height);
        _table = [[FEOrderDetailList alloc] initWithFrame:frame style:UITableViewStylePlain];
        _table.vc = self;
        _table.mainDelegate = self;
        _table.orderId = self.orderId;
        _table.tipAcion = ^{
            @strongself(weakSelf);
            [strongSelf addCheckAction];
        };
        _table.loadModelAction = ^{
            @strongself(weakSelf);
            if (strongSelf.table.model) {
                if (strongSelf.table.model.status == 10 ||
                    strongSelf.table.model.status == 20 ||
                    strongSelf.table.model.status == 30||
                    strongSelf.table.model.status == 40) {
                    strongSelf.freshBtn.hidden = NO;
                } else {
                    strongSelf.freshBtn.hidden = YES;
                }
            } else {
                [strongSelf showEmptyViewWithType:YES];
                [strongSelf.view bringSubviewToFront:strongSelf.backBtn];
                [strongSelf.view bringSubviewToFront:strongSelf.freshBtn];
            }
            
            [strongSelf.mapView setModel:strongSelf.table.model];
        };
        if (@available(iOS 11.0, *)) {
            _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _table.backgroundColor = UIColor.clearColor;
        _table.tableFooterView = [UIView new];
        _table.separatorStyle = UITableViewCellSeparatorStyleNone;
        _table.separatorColor = [UIColor clearColor];
        
        _table.estimatedRowHeight = 0;
        _table.estimatedSectionHeaderHeight = 0;
        _table.estimatedSectionFooterHeight = 0;
    }
    return _table;
}

- (FETipSettingView*) tipView {
    if (!_tipView) {
        _tipView = [[NSBundle mainBundle] loadNibNamed:@"FETipSettingView" owner:self options:nil].firstObject;
        _tipView.frame = CGRectMake(0, 0, kScreenWidth, 330 + kHomeIndicatorHeight);
        [_tipView fitterViewHeight];
        @weakself(self);
        _tipView.sureAction = ^(FETipModel*item) {
            @strongself(weakSelf);
            [strongSelf.table requestAddCheck:item.code];
            [strongSelf.popupController dismiss];
        };
        _tipView.cancleAction = ^{
            @strongself(weakSelf);
            [strongSelf.popupController dismiss];
        };
    }
    return _tipView;
    
}
- (FEOrderMapView*) mapView{
    if (!_mapView) {
        _mapView = [[FEOrderMapView alloc] init];
        _mapView.frame = CGRectMake(0, 0, kScreenWidth, [_mapView getMinHeight]);
        [_mapView setModel:nil];
    }
    return _mapView;
}


- (UIButton* ) freshBtn {
    if (!_freshBtn) {
        _freshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _freshBtn.frame = CGRectMake(kScreenWidth - 16 - 42, 0, 42, 42);
        [_freshBtn setImage:[UIImage imageNamed:@"fe_order_fresh"] forState:UIControlStateNormal];
        [_freshBtn addTarget:self action:@selector(freshAction:) forControlEvents:UIControlEventTouchUpInside];
//        _freshBtn.hidden = YES;
    }
    return _freshBtn;
}

- (UIButton*) backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(16, kHomeInformationBarHeigt + (44-34)/2, 34, 34);
        [_backBtn setImage:[UIImage imageNamed:@"back_item_white_circle"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBtn;
}




@end
