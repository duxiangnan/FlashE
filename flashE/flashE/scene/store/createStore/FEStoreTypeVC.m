//
//  FEStoreTypeVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/20.
//

#import "FEStoreTypeVC.h"
#import "FEDefineModule.h"

@interface FEStoreTypeCell : UITableViewCell
@property (nonatomic, strong) UILabel* name;



- (void) setModel:(NSDictionary*) model ;
@end
@implementation FEStoreTypeCell

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





@interface FEStoreTypeVC ()
@property(nonatomic, weak) IBOutlet UITableView* table;
@property(nonatomic, copy) NSArray<NSDictionary*>*list;
@end

@implementation FEStoreTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择店铺类型";
    self.fd_prefersNavigationBarHidden = NO;
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.table registerClass:[FEStoreTypeCell class] forCellReuseIdentifier:@"FEStoreTypeCell"];
    @weakself(self);
    self.emptyAction = ^{
        @strongself(weakSelf);
        [strongSelf requestShowData];
    };
    [self requestShowData];
}
- (void) requestShowData{
    
    [MBProgressHUD showProgressOnView:self.view];
    @weakself(self);
    
    [[FEHttpManager defaultClient] GET:@"/deer/store/queryCategorys" parameters:nil
      success:^(NSInteger code, id  _Nonnull response)
    {
        @strongself(weakSelf);
        [MBProgressHUD hideProgressOnView:strongSelf.view];
        strongSelf.list = ((NSDictionary*)response)[@"data"];
        [strongSelf.table reloadData];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        @strongself(weakSelf);
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
    
    FEStoreTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEStoreTypeCell"];
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
    !self.selectedAction?:self.selectedAction(self.list[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
