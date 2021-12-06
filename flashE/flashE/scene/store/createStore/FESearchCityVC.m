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
#import <SCIndexView/SCIndexView.h>
#import <SCIndexView/UITableView+SCIndexView.h>
#import <SCIndexView/SCIndexViewConfiguration.h>

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
@property (nonatomic,copy) NSArray<FEStoreCityModel*>* list;
@property (nonatomic,copy) NSArray* indexlist;

@property (nonatomic,copy) NSArray<FEStoreCityModel*>* showList;

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
    
    
    SCIndexViewConfiguration *indexViewConfiguration = [SCIndexViewConfiguration configuration];
    self.table.sc_indexViewConfiguration = indexViewConfiguration;
    self.table.sc_translucentForTableViewInNavigationBar = YES;
    self.table.sc_indexViewDataSource = self.indexlist;

    
    
    @weakself(self);
    self.emptyAction = ^{
        @strongself(weakSelf);
        if (self.list.count == 0) {
            [strongSelf requestShowData];
        }
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
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/address/queryCity"
                            parameters:param
                               success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        NSArray* data = response[@"data"];
        strongSelf.list = [NSArray yy_modelArrayWithClass:[FEStoreCityModel class] json:data];
        
//        strongSelf.list = [strongSelf.list sortedArrayUsingComparator:^NSComparisonResult(FEStoreCityModel* obj1, FEStoreCityModel* obj2) {
//            return [obj1.index compare:obj2.index];
//        }];
//        NSMutableArray* indexArr = [NSMutableArray array];
//        [strongSelf.list enumerateObjectsUsingBlock:^(FEStoreCityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [indexArr addObject:obj.index];
//        }];
//        strongSelf.indexlist = indexArr;
//        strongSelf.table.sc_indexViewDataSource = strongSelf.indexlist;
//        [strongSelf.table reloadData];
        [strongSelf filledShowList];
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

-(void) filledShowList {
    NSMutableArray* tmp = [NSMutableArray array];
    if (self.searchKey.length == 0) {
        tmp = self.list;
    } else {
        [self.list enumerateObjectsUsingBlock:^(FEStoreCityModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableArray* items = [NSMutableArray array];
            [obj.cities enumerateObjectsUsingBlock:^(FEStoreCityItemModel * item, NSUInteger idx, BOOL * _Nonnull stopItem) {
                if ([item.name containsString:self.searchKey]) {
                    [items addObject:item];
                }
            }];
            if (items.count > 0) {
                FEStoreCityModel* newObj = [FEStoreCityModel new];
                newObj.index = obj.index;
                newObj.cities = items;
                [tmp addObject:newObj];
            }
        }];
    }
    
    
    NSMutableArray* indexArr = [NSMutableArray array];
    [tmp enumerateObjectsUsingBlock:^(FEStoreCityModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [indexArr addObject:obj.index];
    }];
    self.showList = tmp;
    self.table.sc_indexViewDataSource = indexArr;
    [self.table reloadData];
}

#pragma mark - UITextField delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.searchKey = [self.searchTF.text trimWhitespace];
    [self filledShowList];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.showList.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.showList.count>0?30:0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    FEStoreCityModel* item = self.showList[section];
    UIView* view = [[UIView alloc] init];
    if (item) {
        view.frame = CGRectMake(0, 0, kScreenWidth, 30);
        view.backgroundColor = UIColorFromRGB(0xF6F7F9);
        
        UILabel* lb = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kScreenWidth-16*2, 20)];
        lb.text = item.index;
        lb.textColor = UIColorFromRGB(0x777777);
        lb.font = [UIFont regularFont:13];
        [view addSubview:lb];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FESearchCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FESearchCityCell"];
    FEStoreCityModel* item = self.showList[indexPath.section];
    if (item) {
        FEStoreCityItemModel* city = item.cities[indexPath.row];
        [cell setModel:city];
    }
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FEStoreCityModel* item = self.showList[section];
    return item.cities.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEStoreCityModel* item = self.showList[indexPath.section];
    if (item) {
        FEStoreCityItemModel* city = item.cities[indexPath.row];
        !self.selectedAction?:self.selectedAction(city);
    }
    [self cancleAvtion:nil];
}

@end

