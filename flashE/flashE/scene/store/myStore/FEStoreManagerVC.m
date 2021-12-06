//
//  FEStoreManagerVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/20.
//

#import "FEStoreManagerVC.h"
#import "FEDefineModule.h"
#import "FEMyStoreModel.h"



@interface FEStoreManagerCell : UITableViewCell
@property (nonatomic, strong) FEMyStoreModel* model;
@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UILabel* nameLB;
@property (nonatomic, strong) UIImageView* addressImage;
@property (nonatomic, strong) UILabel* addressLB;
@property (nonatomic, strong) UIImageView* phoneImage;
@property (nonatomic, strong) UILabel* phoneLB;

@property (nonatomic, strong) UILabel* categoryLB;
@property (nonatomic, assign) CGFloat categoryLBW;
@property (nonatomic, strong) UILabel* isDefaultLB;

@property (nonatomic, strong) UIView* line;
@property (nonatomic, strong) UIButton* defaultBtn;
@property (nonatomic, strong) UILabel* defaultTip;

@property (nonatomic, copy) void (^defaultAction)(FEMyStoreModel* model);


- (void) setModel:(FEMyStoreModel*) model ;

@end
@implementation FEStoreManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.nameLB];
        [self.bgView addSubview:self.addressImage];
        [self.bgView addSubview:self.addressLB];
        [self.bgView addSubview:self.phoneImage];
        [self.bgView addSubview:self.phoneLB];
        [self.bgView addSubview:self.categoryLB];
        [self.bgView addSubview:self.isDefaultLB];
        [self.bgView addSubview:self.line];
        [self.bgView addSubview:self.defaultBtn];
        [self.bgView addSubview:self.defaultTip];
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.top.equalTo(self.bgView.mas_top).offset(10);
        make.height.mas_equalTo(@(20));
    }];
    [self.addressImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(18));
        make.centerY.equalTo(self.addressLB.mas_centerY);
        make.left.equalTo(self.bgView.mas_left).offset(16);
    }];
    [self.addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLB.mas_bottom);
        make.left.equalTo(self.addressImage.mas_right).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.height.equalTo(@20);
    }];
    
    [self.phoneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(18));
        make.centerY.equalTo(self.phoneLB.mas_centerY);
        make.left.equalTo(self.bgView.mas_left).offset(16);
    }];
    [self.phoneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressLB.mas_bottom);
        make.left.equalTo(self.phoneImage.mas_right).offset(10);
        make.height.equalTo(@20);
    }];
    
    [self.categoryLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneLB.mas_right).offset(10);
        make.centerY.equalTo(self.phoneLB.mas_centerY);
        make.width.mas_equalTo(self.categoryLBW);
        make.height.mas_equalTo(15);
    }];
    [self.isDefaultLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.categoryLB.mas_right).offset(10);
        make.centerY.equalTo(self.categoryLB.mas_centerY);
        make.width.mas_equalTo(34);
        make.height.mas_equalTo(15);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.top.equalTo(self.phoneLB.mas_bottom).offset(10);
        make.height.mas_equalTo(1);
    }];
    
    [self.defaultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.centerY.equalTo(self.defaultTip.mas_centerY);
        make.width.mas_equalTo(20);
        make.height.mas_equalTo(20);
    }];
    [self.defaultTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(10);
        make.left.equalTo(self.defaultBtn.mas_right).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.height.mas_equalTo(15);
    }];
}
- (void) setModel:(FEMyStoreModel*) model{
    _model = model;
    self.nameLB.text = model.name;
    self.addressLB.text = [NSString stringWithFormat:@"%@ %@",model.address,model.addressDetail];
    self.phoneLB.text = model.mobile;
    CGSize size = [model.categoryName sizeWithFont:self.categoryLB.font andMaxSize:CGSizeMake(CGFLOAT_MAX, 15)];
    
    self.categoryLBW = MAX(ceil(size.width)+15, 34);
    self.categoryLB.text = model.categoryName;
    [self.categoryLB mas_updateConstraints:^(MASConstraintMaker *make) {
        
//        make.left.equalTo(self.phoneLB.mas_right).offset(10);
//        make.centerY.equalTo(self.phoneLB.mas_centerY);
        make.width.mas_equalTo(self.categoryLBW);
//        make.height.mas_equalTo(15);
    }];
    
    self.isDefaultLB.hidden = model.defaultStore==0;
    self.defaultBtn.selected = model.defaultStore!=0;
    
}
- (void) defaultBtnAcion:(UIButton*)sender {
    !self.defaultAction?:self.defaultAction(self.model);
}

- (UILabel*) nameLB {
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.textColor = UIColorFromRGB(0x333333);
        _nameLB.font = [UIFont mediumFont:15];
    }
    return _nameLB;
}
- (UIImageView*) addressImage {
    if (!_addressImage) {
        _addressImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fe_address_icon"]];
    }
    return _addressImage;
}
- (UILabel*) addressLB {
    if (!_addressLB) {
        _addressLB = [[UILabel alloc] init];
        _addressLB.textColor = UIColorFromRGB(0x777777);
        _addressLB.font = [UIFont regularFont:12];
    }
    return _addressLB;
}
- (UIImageView*) phoneImage {
    if (!_phoneImage) {
        _phoneImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"fe_store_phone"]];
    }
    return _phoneImage;
}
- (UILabel*) phoneLB {
    if (!_phoneLB) {
        _phoneLB = [[UILabel alloc] init];
        _phoneLB.textColor = UIColorFromRGB(0x333333);
        _phoneLB.font = [UIFont regularFont:12];
    }
    return _phoneLB;
}
- (UILabel*) categoryLB {
    if (!_categoryLB) {
        _categoryLB = [[UILabel alloc] init];
        _categoryLB.textColor = UIColorFromRGB(0x12B398);
        _categoryLB.font = [UIFont regularFont:10];
        _categoryLB.frame = CGRectMake(0, 0, 34, 15);
        _categoryLB.textAlignment = NSTextAlignmentCenter;
        _categoryLB.cornerRadius = 7.5;
        _categoryLB.borderWidth = 1;
        _categoryLB.borderColor = UIColorFromRGB(0x12B398);
        _categoryLB.backgroundColor = UIColorFromRGBA(0x12B398,0.1);
    }
    return _categoryLB;
}
- (UILabel*) isDefaultLB {
    if (!_isDefaultLB) {
        _isDefaultLB = [[UILabel alloc] init];
        _isDefaultLB.frame = CGRectMake(0, 0, 34, 15);
        _isDefaultLB.cornerRadius = 7.5;
        _isDefaultLB.textColor = UIColorFromRGB(0xffffff);
        _isDefaultLB.font = [UIFont regularFont:10];
        _isDefaultLB.text = @"默认";
        _isDefaultLB.textAlignment = NSTextAlignmentCenter;
        _isDefaultLB.backgroundColor = UIColorFromRGB(0x12B398);
    }
    return _isDefaultLB;
}
- (UIView*) line {
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = UIColorFromRGB(0xF6F7F9);
    }
    return _line;
}
- (UIButton*) defaultBtn {
    if (!_defaultBtn) {
        _defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_defaultBtn setImage:[UIImage imageNamed:@"fe_icon_check"] forState:UIControlStateNormal];
        [_defaultBtn setImage:[UIImage imageNamed:@"fe_icon_check_selected"] forState:UIControlStateSelected];
        [_defaultBtn addTarget:self action:@selector(defaultBtnAcion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _defaultBtn;
}
- (UILabel*) defaultTip {
    if (!_defaultTip) {
        _defaultTip = [[UILabel alloc] init];
        _defaultTip.textColor = UIColorFromRGB(0x777777);
        _defaultTip.font = [UIFont regularFont:12];
        _defaultTip.text = @"设为默认地址";
    }
    return _defaultTip;
}
- (UIView*) bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.cornerRadius = 15;
    }
    return _bgView;
}



@end


@interface FEStoreManagerVC ()

@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;

@property(nonatomic, copy) NSArray<FEMyStoreModel*>*list;
@end

@implementation FEStoreManagerVC
+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
        [FFRouter registerObjectRouteURL:@"store://createStoreManager" handler:^id(NSDictionary *routerParameters) {
            FEStoreManagerVC* vc = [[FEStoreManagerVC alloc] initWithNibName:@"FEStoreManagerVC" bundle:nil];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺管理";
    self.fd_prefersNavigationBarHidden = NO;
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.table registerClass:[FEStoreManagerCell class] forCellReuseIdentifier:@"FEStoreManagerCell"];
    
    self.bottomViewH.constant = kHomeIndicatorHeight + 54;
    
    @weakself(self);
    self.emptyAction = ^{
        @strongself(weakSelf);
        [strongSelf requestShowData];
    };
    self.emptyTitle = @"尚未创建店铺";
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    self.emptyFrame = self.table.frame;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestShowData];
}
- (IBAction)addStoreAction:(id)sender {
    @weakself(self);
    NSMutableDictionary* arg = [NSMutableDictionary dictionary];
//    arg[@"createComplate"] = ^(){
//        @strongself(weakSelf);
//        [strongSelf requestShowData];
//    };
    UIViewController* vc = [FFRouter routeObjectURL:@"store://createStore" withParameters:arg];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void) requestShowData{
    
    [MBProgressHUD showProgressOnView:self.view];
    @weakself(self);
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"shopId"] = @(acc.shopId);
    [[FEHttpManager defaultClient] GET:@"/deer/store/queryStoresByShopId" parameters:param
      success:^(NSInteger code, id  _Nonnull response)
    {
        @strongself(weakSelf);
        [MBProgressHUD hideProgressOnView:strongSelf.view];
        strongSelf.list = [NSArray yy_modelArrayWithClass:[FEMyStoreModel class] json:((NSDictionary*)response)[@"data"]];
        if (strongSelf.list.count == 0) {
            [strongSelf showEmptyViewWithType:YES];
        } else {
            [strongSelf hiddenEmptyView];
            [strongSelf.table reloadData];
        }
        
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        @strongself(weakSelf);
        [strongSelf hiddenEmptyView];
        [MBProgressHUD hideProgressOnView:strongSelf.view];
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        @strongself(weakSelf);
        [MBProgressHUD hideProgressOnView:strongSelf.view];
    }];

}

- (void) requestDefaultStore:(FEMyStoreModel*)model {
    
    @weakself(self);
    [[FEHttpManager defaultClient] POST:@"/deer/store/setDefaultStore"
                             parameters:@{@"id":@(model.shopId)}
                                success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        [strongSelf.list enumerateObjectsUsingBlock:
         ^(FEMyStoreModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.defaultStore = NO;
            if (obj.shopId == model.shopId) {
                obj.defaultStore = YES;
            }
        }];
        [strongSelf.table reloadData];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        
    }];
    
}
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FEStoreManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEStoreManagerCell"];
    
    [cell setModel:self.list[indexPath.row]];
    @weakself(self);
    cell.defaultAction = ^(FEMyStoreModel *model) {
        @strongself(weakSelf);
        [strongSelf requestDefaultStore:model];
    };
    return cell;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    FEMyStoreModel* item = self.list[indexPath.row];
    NSMutableDictionary* arg = [NSMutableDictionary dictionary];
    arg[@"ID"] = @(item.ID);
    
    FEBaseViewController* vc = [FFRouter routeObjectURL:@"store://storeDetail" withParameters:arg];
    [self.navigationController pushViewController:vc animated:YES];
}


@end

