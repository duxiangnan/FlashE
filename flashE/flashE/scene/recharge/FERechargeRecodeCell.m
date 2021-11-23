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

@property (weak, nonatomic) IBOutlet UIButton *commondOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *commondTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *commondThreeBtn;

@property (nonatomic,strong) FEHttpPageManager* pagesManager;

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
    
    [self.commondOneBtn setBackgroundColor:UIColorFromRGBA(0x12B398, 0.1) forState:UIControlStateSelected];
    [self.commondOneBtn setBackgroundColor:UIColorFromRGB(0xF7F8F9) forState:UIControlStateNormal];
    
    [self.commondTwoBtn setBackgroundColor:UIColorFromRGBA(0x12B398, 0.1) forState:UIControlStateSelected];
    [self.commondTwoBtn setBackgroundColor:UIColorFromRGB(0xF7F8F9) forState:UIControlStateNormal];
    
    [self.commondThreeBtn setBackgroundColor:UIColorFromRGBA(0x12B398, 0.1) forState:UIControlStateSelected];
    [self.commondThreeBtn setBackgroundColor:UIColorFromRGB(0xF7F8F9) forState:UIControlStateNormal];
    
    [self.table registerNib:[UINib nibWithNibName:@"FERechargeRecodeInfoCell" bundle:nil] forCellReuseIdentifier:@"FERechargeRecodeInfoCell"];
    self.table.rowHeight = 70;
    self.commondOneBtn.selected = YES;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}
- (void) setModel{
    [self freshdata];
}
- (IBAction)commondAction:(UIButton *)sender {
    self.commondOneBtn.selected = NO;
    self.commondTwoBtn.selected = NO;
    self.commondThreeBtn.selected = NO;
    
    sender.selected = YES;
    [self freshdata];
}
- (void) freshdata {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    //类型10 扣款记录；20充值记  录
    if (self.commondOneBtn.selected) {
        param[@"type"] = @(10);
    } else if (self.commondTwoBtn.selected) {
        param[@"type"] = @(20);
    }else if (self.commondThreeBtn.selected){
        param[@"type"] = @(30);
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
            
            strongSelf.list = strongSelf.pagesManager.dataArr;
            
            if (strongSelf.pagesManager.hasMore) {
                strongSelf.table.mj_footer = [JVRefreshFooterView footerWithRefreshingBlock:loadMore
                                                                           noMoreDataString:@"没有更多数据"];
                [strongSelf.table.mj_header endRefreshing];
            } else {
                [strongSelf.table.mj_footer endRefreshingWithNoMoreData];
            }
            
            
            if (strongSelf.pagesManager.networkError) {
                [MBProgressHUD showMessage:weakSelf.pagesManager.networkError.localizedDescription];
                strongSelf.list = nil;
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


@end
