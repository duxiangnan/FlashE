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
@property(nonatomic,assign) CGFloat descW;
@property(nonatomic,strong) UIColor* descColor;
@property(nonatomic,strong) UILabel* statusLB;
@property(nonatomic,assign) CGFloat statusLBW;
@property(nonatomic,strong) UILabel* statusLBColor;
@property(nonatomic,strong) UILabel* statusBorderColor;
@property(nonatomic,strong) UIImageView* arrawRightImage;

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
        [self.contentView addSubview:self.statusLB];
        [self.contentView addSubview:self.arrawRightImage];
    }
        
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(@(20));
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(25);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(8);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusLB.mas_left).offset((self.statusLBW>0?-4:0));
        make.width.mas_equalTo(self.descW);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrawRightImage.mas_left).offset(-5);
        make.width.mas_equalTo(self.statusLBW);
        make.height.mas_equalTo(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [self.arrawRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.height.mas_equalTo(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (void) freshCell:(NSDictionary*)param {
    self.icon.image = [UIImage imageNamed:param[@"icon"]];
    self.titleLB.text = param[@"name"];
    self.desc.text = param[@"desc"];
    
    if (self.desc.text.length > 0) {
        CGFloat statusW = ceil([self.desc.text sizeWithFont:self.desc.font andMaxSize:CGSizeMake(CGFLOAT_MAX, 20)].width);
        self.descW = statusW;
    } else {
        self.descW = 0;
    }
    self.desc.textColor = param[@"descC"];
    self.statusLB.text = param[@"status"];
    self.statusLB.textColor = param[@"sCorlor"];
    if (self.statusLB.text.length > 0) {
        CGFloat statusW = ceil([self.statusLB.text sizeWithFont:self.statusLB.font andMaxSize:CGSizeMake(CGFLOAT_MAX, 20)].width) + 20;
        self.statusLBW = statusW;
    } else {
        self.statusLBW = 0;
    }
    
    [self.desc mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.descW);
    }];
    [self.statusLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.statusLBW);
    }];
    self.statusLB.borderColor = param[@"statusBC"];
    self.statusLB.borderWidth = self.statusLB.text.length > 0?1:0;
    self.statusLB.cornerRadius = 10;
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
        _titleLB.font = [UIFont regularFont:16];
        _titleLB.textColor = UIColorFromRGB(0x333333);
    }
    return _titleLB;
}
- (UILabel*) desc {
    if (!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.textAlignment = NSTextAlignmentRight;
        _desc.font = [UIFont regularFont:12];
        _desc.textColor = UIColorFromRGB(0x555555);
    }
    return _desc;
}
- (UILabel*) statusLB {
    if (!_statusLB) {
        _statusLB = [[UILabel alloc] init];
        _statusLB.textAlignment = NSTextAlignmentCenter;
        _statusLB.font = [UIFont regularFont:12];
        _statusLB.textColor = UIColorFromRGB(0xF58423);
    }
    return _statusLB;
}
- (UIImageView*) arrawRightImage {
    if (!_arrawRightImage) {
        _arrawRightImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_more"]];
    }
    return _arrawRightImage;
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
    self.preferredContentSize = CGSizeMake(275, kScreenHeight);
    
    self.headerT.constant = 0;
    self.userNameLB.text = [[FEAccountManager sharedFEAccountManager] getLoginInfo].mobile;
    
    self.bottomViewH.constant = kHomeIndicatorHeight + 50;
    self.logoutBtnB.constant = kHomeIndicatorHeight;
    
//    UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:blur];
//    self.tableView.backgroundView = backgroundView;
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
    
        
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    NSString* balance = @"暂无余额";
    if (acc.balance > 0) {
        balance = [NSString stringWithFormat:@"%.2f",acc.balance];
    }
    self.showArr = [NSMutableArray array];
    [self.showArr addObject:[self createItem:@"menu_shop" name:@"我的店铺"
                                        desc:@""
                                       descC:UIColorFromRGB(0x555555)
                                      status:@""
                                 statusColor:UIColorFromRGB(0xF58423) statusBC:UIColorFromRGB(0xF58423)
                                        type:1]];
    
    [self.showArr addObject:[self createItem:@"menu_wallet" name:@"我的钱包"
                                        desc:@""
                                       descC:UIColorFromRGB(0x555555)
                                      status:@""
                                 statusColor:UIColorFromRGB(0xF58423) statusBC:UIColorFromRGB(0xF58423)
                                        type:2]];
    
//    [self.showArr addObject:[self createItem:@"menu_wallet" name:@"我的钱包"
//                                        desc:balance
//                                       descC:UIColorFromRGB(0x555555)
//                                      status:@"去充值"
//                                 statusColor:UIColorFromRGB(0xF58423) statusBC:UIColorFromRGB(0xF58423)
//                                        type:2]];
//    [self.showArr addObject:[self createItem:@"menu_audi_order" name:@"订单语音播报" desc:@"" descC:UIColorFromRGB(0x555555) status:@"" statusColor:UIColorFromRGB(0xF58423) statusBC:UIColorFromRGB(0xF58423) type:3]];
//    [self.showArr addObject:[self createItem:@"menu_user_private" name:@"用户协议" desc:@"" descC:UIColorFromRGB(0x555555) status:@"" statusColor:UIColorFromRGB(0xF58423) statusBC:UIColorFromRGB(0xF58423) type:4]];
//    [self.showArr addObject:[self createItem:@"menu_private" name:@"隐私协议" desc:@"" descC:UIColorFromRGB(0x555555) status:@"" statusColor:UIColorFromRGB(0xF58423) statusBC:UIColorFromRGB(0xF58423) type:5]];
    [self.showArr addObject:[self createItem:@"menu_version" name:@"版本号"
                                        desc:[NSString stringWithFormat:@"V%@",[FEPublicMethods clientVersion]]
                                       descC:UIColorFromRGB(0x555555)
                                      status:@""
                                 statusColor:UIColorFromRGB(0xF58423) statusBC:UIColorFromRGB(0xF58423)
                                        type:6]];
    
    
//    [self.showArr addObject:[self createItem:@"menu_audio" name:@"语音设置"
//                                        desc:@""
//                                       descC:UIColorFromRGB(0x555555)
//                                      status:@""
//                                 statusColor:UIColorFromRGB(0xF58423) statusBC:UIColorFromRGB(0xF58423)
//                                        type:7]];
//
//    [self.showArr addObject:[self createItem:@"menu_manager" name:@"客户经理"
//                                        desc:@""
//                                       descC:UIColorFromRGB(0x555555)
//                                      status:@""
//                                 statusColor:UIColorFromRGB(0xF58423) statusBC:UIColorFromRGB(0xF58423)
//                                        type:8]];
    [self.tableView reloadData];
}

- (NSDictionary*) createItem:(NSString*)icon name:(NSString*)name
                        desc:(NSString*)desc descC:(UIColor*)descC
                      status:(NSString*)status statusColor:(UIColor*)sCorlor
                      statusBC:(UIColor*)statusBC type:(NSInteger)type{
    NSMutableDictionary* dic = [NSMutableDictionary dictionary];
    dic[@"icon"] = icon;
    dic[@"name"] = name;
    dic[@"desc"] = desc;
    dic[@"descC"] = descC;
    dic[@"status"] = status;
    dic[@"sCorlor"] = sCorlor;
    dic[@"statusBC"] = statusBC;
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
    [cell freshCell:item];
    return cell;
}

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
