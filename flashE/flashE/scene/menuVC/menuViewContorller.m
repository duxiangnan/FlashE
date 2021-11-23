//
//  menuViewContorller.m
//  flashE
//
//  Created by duxiangnan on 2021/11/3.
//

#import "menuViewContorller.h"
#import "FEDefineModule.h"
#import "FEAccountManager.h"
#import <Masonry/Masonry.h>
#import "FEPublicMethods.h"
#import <FFRouter/FFRouter.h>


@interface menuCell:UITableViewCell
@property(nonatomic,strong) UIImageView* icon;
@property(nonatomic,strong) UILabel* titleLB;
@property(nonatomic,strong) UILabel* desc;
@end

@implementation menuCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        
        self.contentView.backgroundColor = UIColor.whiteColor;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.desc];
    }
        
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(20));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(30);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(16);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.desc.mas_left).offset(-5);
    }];
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.left.equalTo(self.titleLB.mas_right).offset(5);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}
- (UIImageView*) icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        
    }
    return _icon;
}
- (UILabel*) titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = [UIFont systemFontOfSize:16];
        _titleLB.textColor = UIColorFromRGB(0x333333);
    }
    return _titleLB;
}
- (UILabel*) desc {
    if (!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.textAlignment = NSTextAlignmentRight;
        _desc.font = [UIFont systemFontOfSize:13];
        _desc.textColor = UIColorFromRGB(0x888888);
    }
    return _desc;
}
@end


@interface menuViewContorller ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerT;
@property (weak, nonatomic) IBOutlet UILabel *userNameLB;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoutBtnB;

@property (nonatomic, strong) NSMutableArray* showArr;
@end

@implementation menuViewContorller

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.preferredContentSize = CGSizeMake(MAX(kScreenWidth/3, 260), kScreenHeight);
    self.headerT.constant = kHomeNavigationHeight;
    self.userNameLB.text = [[FEAccountManager sharedFEAccountManager] getLoginInfo].mobile;
    
    self.bottomViewH.constant = kHomeIndicatorHeight + 50;
    self.logoutBtnB.constant = kHomeIndicatorHeight;
    
    UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:blur];
    self.tableView.backgroundView = backgroundView;
    self.tableView.backgroundColor = UIColor.clearColor;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    [self.tableView registerClass:[menuCell class] forCellReuseIdentifier:@"menuCell"];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
        
    
    self.showArr = [NSMutableArray array];
    [self.showArr addObject:[self createItem:@"menu_shop" name:@"我的店铺" desc:@"" type:1]];
    [self.showArr addObject:[self createItem:@"menu_wallet" name:@"我的钱包" desc:@"" type:2]];
//    [self.showArr addObject:[self createItem:@"menu_audi_order" name:@"订单语音播报" desc:@"" type:3]];
    [self.showArr addObject:[self createItem:@"menu_user_private" name:@"用户协议" desc:@"" type:4]];
    [self.showArr addObject:[self createItem:@"menu_private" name:@"隐私协议" desc:@"" type:5]];
    [self.showArr addObject:[self createItem:@"menu_version" name:@"版本号"
                desc:[NSString stringWithFormat:@"V%@",[FEPublicMethods clientVersion]] type:6]];
}
- (NSDictionary*) createItem:(NSString*)icon name:(NSString*)name desc:(NSString*)desc type:(NSInteger)type{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    dic[@"icon"] = icon;
    dic[@"name"] = name;
    dic[@"desc"] = desc;
    dic[@"type"] = @(type);
    return dic.copy;
}
- (IBAction)logoutAction:(id)sender {
    [[FEAccountManager sharedFEAccountManager] logout];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    menuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    NSDictionary* item = self.showArr[indexPath.row];
    cell.icon.image = [UIImage imageNamed:item[@"icon"]];
    cell.titleLB.text = item[@"name"];
    cell.desc.text = item[@"desc"];
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return .1;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return nil;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return .1;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return nil;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showArr.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* item = self.showArr[indexPath.row];
    NSNumber* type = item[@"type"];
    
    NSString* url = [NSString stringWithFormat:@"deckControl://changeSecen?vcType=%d",type.integerValue];
    [FFRouter routeURL:url];
    
}




@end
