//
//  FESearchCityVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/21.
//

#import "FESearchCityVC.h"

#import "FEDefineModule.h"
#import "FEHttpPageManager.h"
#import "FEStoreCityModel.h"


@interface FESearchCityCell : UITableViewCell
@property (nonatomic,strong) FEStoreCityItemModel* model;
@property (nonatomic, strong) UILabel* name;

@end
@implementation FESearchCityCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
        
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
- (void) setModel:(FEStoreCityItemModel*) model{
    _model = model;
    
    self.name.text = [FEPublicMethods SafeString:model.name];
    
}


- (UILabel*) name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont regularFont:14];
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

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.emptyFrame = self.table.frame;
}
- (IBAction)cancleAvtion:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) requestShowData {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"name"] = [FEPublicMethods SafeString:self.searchKey];
    
    
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/address/queryCity"
                            parameters:param
                               success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        NSDictionary* data = response[@"data"];
        NSArray* keys = data.allKeys;
//        if(keys.count>0){
            keys =  [keys sortedArrayUsingComparator:^NSComparisonResult(NSString* obj1, NSString* obj2) {
                return [obj1 compare:obj2]; // 升序
            }];
//        }
        NSMutableArray* tmp = [NSMutableArray array];
        for (int i = 0; i<keys.count;i++) {
            NSArray* items = data[keys[i]];

            NSArray* citys = [NSArray yy_modelArrayWithClass:[FEStoreCityItemModel class] json:items];
            FEStoreCityModel* model = [FEStoreCityModel new];
            model.key = keys[i];
            model.citys = citys;
            [tmp addObject:model];
        }
        strongSelf.list = tmp;
        [strongSelf.table reloadData];
        if (strongSelf.list.count == 0) {
            [strongSelf showEmptyViewWithType:YES];
        } else{
            [strongSelf hiddenEmptyView];
        }
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
    
        @strongself(weakSelf);
        [MBProgressHUD showMessage:error.localizedDescription];
        if (strongSelf.list.count == 0) {
            [strongSelf showEmptyViewWithType:NO];
        } else{
            [strongSelf hiddenEmptyView];
        }
    } cancle:^{
        
    }];

}

#pragma mark - UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.searchKey = [self.searchTF.text trimWhitespace];
    [self requestShowData];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.list.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.list.count>0?30:0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FEStoreCityModel* item = self.list[section];
    UIView* view = [[UIView alloc] init];
    if (item) {
        view.frame = CGRectMake(0, 0, kScreenWidth, 30);
        view.backgroundColor = UIColorFromRGB(0xF6F7F9);
        
        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kScreenWidth-16*2, 20)];
        lb.text = item.key;
        lb.textColor = UIColorFromRGB(0x777777);
        lb.font = [UIFont regularFont:13];
        [view addSubview:lb];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FESearchCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FESearchCityCell"];
    FEStoreCityModel* item = self.list[indexPath.section];
    if (item) {
        FEStoreCityItemModel* city = item.citys[indexPath.row];
        [cell setModel:city];
    }
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FEStoreCityModel* item = self.list[section];
    return item.citys.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEStoreCityModel* item = self.list[indexPath.section];
    if (item) {
        FEStoreCityItemModel* city = item.citys[indexPath.row];
        !self.selectedAction?:self.selectedAction(city);
    }
    [self cancleAvtion:nil];
}

@end

