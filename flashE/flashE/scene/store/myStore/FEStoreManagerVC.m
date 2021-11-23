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
@property (nonatomic, strong) UILabel* name;
- (void) setModel:(NSDictionary*) model ;
@end
@implementation FEStoreManagerCell

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
        make.top.bottom.right.equalTo(self.contentView);
    }];
    
}
- (void) setModel:(NSDictionary*) model{
    
    self.name.text = model[@"name"];
    
}


- (UILabel*) name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.numberOfLines = 2;
        _name.textColor = UIColorFromRGB(0x333333);
        _name.font = [UIFont regularFont:14];
    }
    return _name;
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
    
    UIViewController* vc = [FFRouter routeObjectURL:@"store://createStore"];
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
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FEStoreManagerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEStoreManagerCell"];
    [cell setModel:self.list[indexPath.row]];
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    !self.selectedAction?:self.selectedAction(self.list[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}


@end

