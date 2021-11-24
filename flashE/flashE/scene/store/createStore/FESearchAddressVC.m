//
//  FESearchAddressVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/20.
//

#import "FESearchAddressVC.h"
#import "FEDefineModule.h"
#import "FEHttpPageManager.h"
#import "FESearchCityVC.h"


@interface FESearchAddressCell : UITableViewCell
@property (nonatomic,strong) FEAddressModel* model;
@property (nonatomic, strong) UILabel* name;
@property (nonatomic, strong) UILabel* desc;
@property (nonatomic, strong) UIImageView* flageImage;

- (void) setModel:(FEAddressModel*) model search:(NSString*)key;
@end
@implementation FESearchAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
        
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.desc];
        [self.contentView addSubview:self.flageImage];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.flageImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(20));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(16);
    }];
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flageImage.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-3);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flageImage.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_centerY).offset(3);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];
    
}
- (void) setModel:(FEAddressModel*) model search:(NSString*)key{
    _model = model;
    NSRange range = [model.name rangeOfString:key];
    if (range.length > 0) {
        NSArray* arr = [model.name componentsSeparatedByString:key];
        
        self.name.attributedText = nil;
        if (arr.count == 1) {
            [self.name appendAttriString:arr[0]
                                   color:UIColorFromRGB(0x333333)
                                    font:[UIFont regularFont:14]];
            [self.name appendAttriString:key
                                   color:UIColorFromRGB(0x12B398)
                                    font:[UIFont regularFont:14]];
        } else {
            [self.name appendAttriString:arr[0]
                                   color:UIColorFromRGB(0x333333)
                                    font:[UIFont regularFont:14]];
            [self.name appendAttriString:key
                                   color:UIColorFromRGB(0x12B398)
                                    font:[UIFont regularFont:14]];
            NSString* tmp = [model.name substringFromIndex:range.location + range.length];
            [self.name appendAttriString:tmp
                                   color:UIColorFromRGB(0x333333)
                                    font:[UIFont regularFont:14]];
            
        }
    } else {
        self.name.text = [FEPublicMethods SafeString:model.name];
    }
        
    NSString* desc = @"";
    if (model.type.length > 0) {
        desc = [NSString stringWithFormat:@"%@ | ",model.type];
    }
    if (model.pname.length > 0) {
        desc = [desc stringByAppendingString:model.pname];
    }
    if (model.cityname.length > 0) {
        desc = [desc stringByAppendingString:model.cityname];
    }
    if (model.adname.length > 0) {
        desc = [desc stringByAppendingString:model.adname];
    }
    if (model.address.length > 0) {
        desc = [desc stringByAppendingString:model.address];
    }
    self.desc.text = desc;
}


- (UILabel*) name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.numberOfLines = 2;
    }
    return _name;
}
- (UILabel*) desc {
    if (!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.font = [UIFont regularFont:12];
        _desc.textColor = UIColorFromRGB(0x888888);
        _desc.numberOfLines = 2;
    }
    return _desc;
}
- (UIImageView*) flageImage {
    if (!_flageImage) {
        _flageImage = [[UIImageView alloc] init];
        _flageImage.image = [UIImage imageNamed:@"fe_address_icon"];
    }
    return _flageImage;
}
@end

@interface FESearchAddressVC ()


@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerH;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (nonatomic, strong) NSString* searchKey;
@property (nonatomic,copy) NSArray<FEAddressModel*>* list;
    
@property (nonatomic,strong) FEHttpPageManager* pagesManager;

@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (nonatomic ,copy) NSDictionary* cityDic;
@end

@implementation FESearchAddressVC

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
    [self.table registerClass:[FESearchAddressCell class] forCellReuseIdentifier:@"FESearchAddressCell"];
    @weakself(self);
    self.emptyAction = ^{
        @strongself(weakSelf);
        [strongSelf requestShowData];
    };
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(textChange:)
//                                                 name:UITextFieldTextDidChangeNotification
//                                               object:nil];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (IBAction)cancleAvtion:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) requestShowData {
    if (self.searchTF.text.length == 0) {
        [MBProgressHUD showMessage:@"先输入搜索关键字"];
        return;
    }
        if (self.pagesManager) {
            [self.pagesManager cancleCurrentRequest];
            self.pagesManager = nil;
        }
        NSMutableDictionary* param = [NSMutableDictionary dictionary];
        param[@"content"] = self.searchKey;
        param[@"index"] = @"1";
        param[@"pageSize"] = @"20";
        param[@"cityName"] = [FEPublicMethods SafeString:self.cityDic[@"name"]];
        
        
        self.pagesManager = [[FEHttpPageManager alloc] initWithFunctionId:@"/deer/address/searchAddress"
                                                               parameters:param
                                                                itemClass:[FEAddressModel class]];
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
    
- (IBAction)cityAction:(id)sender {
    FESearchCityVC* vc = [[FESearchCityVC alloc] initWithNibName:@"FESearchCityVC" bundle:nil];
    @weakself(self);
    vc.selectedAction = ^(NSDictionary * _Nonnull model) {
        @strongself(weakSelf);
        self.cityDic = model;
    };
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark - UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.searchKey = [self.searchTF.text trimWhitespace];
    if (self.searchKey.length > 0) {
        [self requestShowData];
    }
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
    
    FESearchAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FESearchAddressCell"];
    FEAddressModel* item = self.list[indexPath.row];
    [cell setModel:item search:self.searchKey];
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEAddressModel* item = self.list[indexPath.row];
    
    !self.selectedAction?:self.selectedAction(item,_cityDic);
    [self cancleAvtion:nil];
}

@end