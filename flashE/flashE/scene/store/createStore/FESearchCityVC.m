//
//  FESearchCityVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/21.
//

#import "FESearchCityVC.h"

#import "FEDefineModule.h"
#import "FEHttpPageManager.h"


@interface FESearchCityCell : UITableViewCell
@property (nonatomic,strong) NSDictionary* model;
@property (nonatomic, strong) UILabel* name;

- (void) setModel:(NSDictionary*) model search:(NSString*)key;
@end
@implementation FESearchCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
        
        [self.contentView addSubview:self.name];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(16);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];
}
- (void) setModel:(NSDictionary*) model{
    _model = model;
    
    self.name.text = [FEPublicMethods SafeString:model[@"name"]];
    
}


- (UILabel*) name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont regularFont:12];
        _name.textColor = UIColorFromRGB(0x333333);
    }
    return _name;
}

@end

@interface FESearchCityVC ()


@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerH;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (nonatomic, strong) NSString* searchKey;
@property (nonatomic,copy) NSArray<NSDictionary*>* list;
@property (nonatomic,copy) NSArray<NSDictionary*>* showList;
@property (nonatomic,strong) FEHttpPageManager* pagesManager;

@end

@implementation FESearchCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.headerH.constant = kHomeNavigationHeight;
    self.searchKey = @"";
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.table registerClass:[FESearchCityCell class] forCellReuseIdentifier:@"FESearchCityCell"];
    @weakself(self);
    self.emptyAction = ^{
        @strongself(weakSelf);
        [strongSelf requestShowData];
    };
    [self requestShowData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (IBAction)cancleAvtion:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) requestShowData {
//    if (self.searchTF.text.length == 0) {
//        [MBProgressHUD showMessage:@"先输入搜索关键字"];
//        return;
//    }
    if (self.pagesManager) {
        [self.pagesManager cancleCurrentRequest];
        self.pagesManager = nil;
    }
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"name"] = [FEPublicMethods SafeString:self.searchKey];
    
    self.pagesManager = [[FEHttpPageManager alloc] initWithFunctionId:@"/deer/address/queryCity"
                                                           parameters:param
                                                            itemClass:nil];
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
                [strongSelf filtCitys];
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
            
            strongSelf.list = strongSelf.pagesManager.dataArr;
            
            if (strongSelf.pagesManager.hasMore) {
                strongSelf.table.mj_footer = [JVRefreshFooterView footerWithRefreshingBlock:loadMore
                                                                           noMoreDataString:@"没有更多数据"];
                [strongSelf.table.mj_header endRefreshing];
            } else {
                [strongSelf.table.mj_footer endRefreshingWithNoMoreData];
            }
            [strongSelf filtCitys];
            [strongSelf.table reloadData];
            if (strongSelf.pagesManager.networkError) {
                [MBProgressHUD showMessage:weakSelf.pagesManager.networkError.localizedDescription];

                if ([strongSelf.list count] <= 0) {
                    [strongSelf showEmptyViewWithType:NO];
                }
            } else if (strongSelf.list.count == 0) {
                [strongSelf showEmptyViewWithType:YES];
            }
        }];
    };

    self.table.mj_header = [JVRefreshHeaderView headerWithRefreshingBlock:loadFirstPage];
    loadFirstPage();
    
}
    
- (void) filtCitys {
    NSMutableArray* list = [NSMutableArray array];
    if (self.searchTF.text.length > 0) {
        [self.list enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString* name = obj[@"name"];
            
            if ([name containsString:self.searchTF.text ]) {
                [list addObject:obj];
            }
        }];
        self.showList = list.copy;
    } else {
        self.showList = self.list;
    }
    
}


#pragma mark - UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.searchKey = [self.searchTF.text trimWhitespace];
    [self requestShowData];
//    [self.table reloadData];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FESearchCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FESearchCityCell"];
    NSDictionary* item = self.list[indexPath.row];
    [cell setModel:item];
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = self.list[indexPath.row];
    
    !self.selectedAction?:self.selectedAction(item);
    [self cancleAvtion:nil];
}

@end

