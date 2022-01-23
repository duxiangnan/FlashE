//
//  FERechargeRecodeCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/22.
//

#import "FERechargeRecodeCell.h"
#import "FERechargeRecodeModel.h"

#import "FEDefineModule.h"
#import "FEHttpPageManager.h"
#import "FEEmptyView.h"


@interface FERechargeRecodeInfoCell : UITableViewCell
@property (nonatomic,strong) FERechargeRecodeModel* model;

@property (weak, nonatomic) IBOutlet UILabel *payInfoLB;
@property (weak, nonatomic) IBOutlet UILabel *timeLB;
@property (weak, nonatomic) IBOutlet UILabel *jineLB;

- (void) setModel:(FERechargeRecodeModel*) model;

@end
@implementation FERechargeRecodeInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
- (void) setModel:(FERechargeRecodeModel*) model{
    _model = model;
    self.payInfoLB.text = [FEPublicMethods SafeString:model.title];
    self.timeLB.text = [FEPublicMethods SafeString:model.createTimeStr];
    self.jineLB.text = [NSString stringWithFormat:@"%0.2ld",(long)model.amount];
}


@end




@interface FERechargeRecodeCell ()
@property (nonatomic,copy) NSArray<FERechargeRecodeModel*>* list;
@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIButton *commondTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *commondThreeBtn;

@property (nonatomic,strong) FEHttpPageManager* pagesManager;

@property (nonatomic, strong) FEEmptyView* emptyView;

@property (nonatomic, assign) CGRect emptyFrame;
@property (nonatomic, copy) NSString* emptyImage;
@property (nonatomic, copy) NSString* emptyTitle;
@property (nonatomic, copy) NSString* emptyDesc;

@property (nonatomic, copy) NSString* errorImage;
@property (nonatomic, copy) NSString* errorTitle;
@property (nonatomic, copy) NSString* errorDesc;

@property (nonatomic, copy) void (^emptyAction)(void);//实现点击回调

@end
@implementation FERechargeRecodeCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self updataSubView];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self updataSubView];
    }
    return self;
}
- (void) updataSubView{
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
    
    [self.commondTwoBtn setBackgroundColor:UIColorFromRGBA(0x12B398, 0.1) forState:UIControlStateSelected];
    [self.commondTwoBtn setBackgroundColor:UIColorFromRGB(0xF7F8F9) forState:UIControlStateNormal];
    
    [self.commondThreeBtn setBackgroundColor:UIColorFromRGBA(0x12B398, 0.1) forState:UIControlStateSelected];
    [self.commondThreeBtn setBackgroundColor:UIColorFromRGB(0xF7F8F9) forState:UIControlStateNormal];
    
    [self.table registerNib:[UINib nibWithNibName:@"FERechargeRecodeInfoCell" bundle:nil]
     forCellReuseIdentifier:@"FERechargeRecodeInfoCell"];
    self.table.rowHeight = 70;
    self.commondTwoBtn.selected = YES;
    
    
    
//    self.emptyFrame = self.bounds;
//    self.emptyImage = @"FEEmpty_icon";
//    self.emptyTitle = @"暂无数据";
//    self.emptyDesc = @"";
//
//    self.errorImage = @"Wifi-Error";;
//    self.errorTitle = @"请检查网络连接后，再次尝试";
//    self.errorDesc = @"";
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    self.emptyFrame = self.table.frame;
}
- (void) setModel{
    [self freshdata];
}
- (IBAction)commondAction:(UIButton *)sender {
    
    self.commondTwoBtn.selected = NO;
    self.commondThreeBtn.selected = NO;
    
    sender.selected = YES;
    [self freshdata];
}
- (void) freshdata {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    //类型10 扣款记录；20充值记  录
    if (self.commondTwoBtn.selected) {
        param[@"type"] = @(10);
    }else if (self.commondThreeBtn.selected){
        param[@"type"] = @(20);
    }
    
    self.pagesManager = [[FEHttpPageManager alloc] initWithFunctionId:@"/deer/orders/queryDebitList" parameters:param
                                                    itemClass:[FERechargeRecodeModel class]];
    [self.pagesManager setkeyIndex:@"index" size:@"pageSize"];
    self.pagesManager.resultName = @"data";
    self.pagesManager.requestMethod = 1;
    
    @weakself(self);

    void (^loadMore)(void) = ^{
        @strongself(weakSelf);
        if (strongSelf.pagesManager.hasMore) {
            [strongSelf.pagesManager fetchMoreData:^{
                strongSelf.list = strongSelf.pagesManager.dataArr;
                if ([strongSelf.pagesManager hasMore]) {
                    [strongSelf.table.mj_footer endRefreshing];
                } else {
                    [strongSelf.table.mj_footer endRefreshingWithNoMoreData];
                }
                
                if (strongSelf.pagesManager.networkError) {
                    [MBProgressHUD showMessage:strongSelf.pagesManager.networkError.localizedDescription];
                }
                [strongSelf.table reloadData];
            }];
        }
    };

    void (^loadFirstPage)(void) = ^{
        @strongself(weakSelf);
        [strongSelf.pagesManager fetchData:^{
            [strongSelf.table.mj_header endRefreshing];
            [strongSelf hiddenEmptyView];
            strongSelf.list = strongSelf.pagesManager.dataArr;
            
            if (strongSelf.pagesManager.hasMore) {
                strongSelf.table.mj_footer = [JVRefreshFooterView footerWithRefreshingBlock:loadMore
                                                                           noMoreDataString:@"没有更多数据"];
            } else {
                [strongSelf.table.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (strongSelf.pagesManager.networkError) {
                [MBProgressHUD showMessage:weakSelf.pagesManager.networkError.localizedDescription];
            }
            if (strongSelf.list.count == 0) {
                [strongSelf showEmptyViewWithType:YES];
            }
            [strongSelf.table reloadData];
        }];
    };

    self.table.mj_header = [JVRefreshHeaderView headerWithRefreshingBlock:loadFirstPage];
    loadFirstPage();
    
    
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FERechargeRecodeInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FERechargeRecodeInfoCell"];
    [cell setModel:self.list[indexPath.row]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}





- (void)showEmptyViewWithType:(BOOL)isEmpty {
//    CGRect frame = self.emptyFrame;
//    NSString* imageName = self.errorImage;
//    NSString* emptyTitle = self.errorTitle;
//    NSString* desc = self.errorDesc;
//    if (isEmpty) {
//        imageName = self.emptyImage;
//        emptyTitle = self.emptyTitle;
//        desc = self.emptyDesc;
//    }
//    self.emptyView = [[FEEmptyView alloc] initWithFrame:frame emptyImage:imageName title:emptyTitle desc:desc];
//    [self.emptyView removeFromSuperview];
//    [self addSubview:self.emptyView];
//    self.emptyView.onTapAction = self.emptyAction;
}
- (void) hiddenEmptyView {
//    [self.emptyView emptyHidden];
}
//- (void)setEmptyTitle:(NSString *)emptyTitle {
//    _emptyTitle = emptyTitle;
//    self.emptyView.title = emptyTitle;
//}
//- (void)setEmptyDesc:(NSString *)emptyDesc{
//    _emptyDesc = emptyDesc;
//    self.emptyView.desc = emptyDesc;
//}
//- (void)setEmptyImage:(NSString *)emptyImage{
//    _emptyImage = emptyImage;
//
//    self.emptyView.imageName = emptyImage;
//}
@end
