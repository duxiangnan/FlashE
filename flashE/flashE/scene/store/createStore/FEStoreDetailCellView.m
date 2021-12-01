//
//  FEStoreDetailCellView.m
//  flashE
//
//  Created by duxiangnan on 2021/11/30.
//

#import "FEStoreDetailCellView.h"
#import "FEDefineModule.h"
#import "FEMyStoreModel.h"

@interface FEStoreDetailAddressCell()

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
@end
@implementation FEStoreDetailAddressCell


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
        make.top.equalTo(self.bgView).offset(10);
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
}
- (void) setModel:(FEMyStoreModel*) model{
    _model = model;
    self.nameLB.text = model.name;
    self.addressLB.text = [NSString stringWithFormat:@"%@ %@",model.address,model.addressDetail];
    self.phoneLB.text = model.mobile;
    CGSize size = [model.categoryName sizeWithFont:self.categoryLB.font andMaxSize:CGSizeMake(CGFLOAT_MAX, 15)];
    
    self.categoryLBW = MAX(ceil(size.width)+15, 34);
    [self.categoryLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.categoryLBW);
    }];
    
    self.isDefaultLB.hidden = model.defaultStore==0;
    
}

- (UIView*) bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.cornerRadius = 15;
    }
    return _bgView;
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
        _categoryLB.cornerRadius = 7.5;
        _categoryLB.borderWidth = 1;
        _categoryLB.borderColor = UIColorFromRGB(0x12B398);
        _categoryLB.backgroundColor = UIColorFromRGBA(0x12B398,0.1);
    }
    return _nameLB;
}
- (UILabel*) isDefaultLB {
    if (!_isDefaultLB) {
        _isDefaultLB = [[UILabel alloc] init];
        _isDefaultLB.frame = CGRectMake(0, 0, 34, 15);
        _isDefaultLB.cornerRadius = 7.5;
        _isDefaultLB.textColor = UIColorFromRGB(0x000000);
        _isDefaultLB.font = [UIFont regularFont:10];
        _isDefaultLB.text = @"默认";
        _isDefaultLB.backgroundColor = UIColorFromRGB(0x12B398);
    }
    return _isDefaultLB;
}

@end

@interface FEStoreDetailZhengjianCell()

@property (nonatomic, strong) FEMyStoreModel* model;
@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UILabel* titleLB;
@property (nonatomic, strong) UIImageView* zmImage;
@property (nonatomic, strong) UIImageView* fmImage;
@end
@implementation FEStoreDetailZhengjianCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLB];
        [self.bgView addSubview:self.zmImage];
        [self.bgView addSubview:self.fmImage];
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
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.top.equalTo(self.bgView).offset(10);
        make.height.mas_equalTo(@(20));
    }];
    CGFloat width = (kScreenWidth - 16*2 - 10*2 - 10)/2 ;
    CGFloat height = width*106/156;
    [self.zmImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(width));
        make.height.mas_equalTo(@(height));
        make.top.equalTo(self.titleLB.mas_bottom).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        
    }];
    
    [self.fmImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(width));
        make.height.mas_equalTo(@(height));
        make.top.equalTo(self.titleLB.mas_bottom).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(16);
    }];
    
}
- (void) setModel:(FEMyStoreModel*) model{
    _model = model;
    NSURL* url = [NSURL URLWithString:[FEPublicMethods SafeString:model.frontIdcard]];
    [self.zmImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"fe_store_zm"]];
    url = [NSURL URLWithString:[FEPublicMethods SafeString:model.reverseIdcard]];
    [self.fmImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"fe_store_fm"]];
    
}
- (UIView*) bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.cornerRadius = 15;
    }
    return _bgView;
}
- (UILabel*) titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = UIColorFromRGB(0x333333);
        _titleLB.font = [UIFont mediumFont:15];
        _titleLB.attributedText = nil;
        [_titleLB appendAttriString:@"负责人身份证照片" color:UIColorFromRGB(0x333333) font:[UIFont regularFont:13]];
        [_titleLB appendAttriString:@"*" color:UIColorFromRGB(0xF56C6C) font:[UIFont regularFont:13]];
    }
    return _titleLB;
}
- (UIImageView*) zmImage {
    if (!_zmImage) {
        _zmImage = [[UIImageView alloc] init];
    }
    return _zmImage;
}
- (UIImageView*) fmImage {
    if (!_fmImage) {
        _fmImage = [[UIImageView alloc] init];
    }
    return _fmImage;
}
@end


@interface FEStoreDetailDianInfoCell()

@property (nonatomic, strong) FEMyStoreModel* model;
@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UILabel* titleLB;
@property (nonatomic, strong) UIImageView* dianImage;
@property (nonatomic, strong) UIImageView* licenseImage;
@end
@implementation FEStoreDetailDianInfoCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.titleLB];
        [self.bgView addSubview:self.dianImage];
        [self.bgView addSubview:self.licenseImage];
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
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.top.equalTo(self.bgView).offset(10);
        make.height.mas_equalTo(@(20));
    }];
    CGFloat width = (kScreenWidth - 16*2 - 10*2 - 10)/2 ;
    CGFloat height = width*106/156;
    [self.dianImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(width));
        make.height.mas_equalTo(@(height));
        make.top.equalTo(self.titleLB.mas_bottom).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        
    }];
    
    [self.licenseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(width));
        make.height.mas_equalTo(@(height));
        make.top.equalTo(self.titleLB.mas_bottom).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(16);
    }];
    
}
- (void) setModel:(FEMyStoreModel*) model{
    _model = model;
    NSURL* url = [NSURL URLWithString:[FEPublicMethods SafeString:model.frontIdcard]];
    [self.dianImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"fe_store_facade"]];
    url = [NSURL URLWithString:[FEPublicMethods SafeString:model.reverseIdcard]];
    [self.licenseImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"fe_store_license"]];
    
}
- (UIView*) bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.cornerRadius = 15;
    }
    return _bgView;
}
- (UILabel*) titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = UIColorFromRGB(0x333333);
        _titleLB.font = [UIFont mediumFont:15];
        _titleLB.attributedText = nil;
        [_titleLB appendAttriString:@"营业执照与店铺门面照片" color:UIColorFromRGB(0x333333) font:[UIFont regularFont:13]];
        [_titleLB appendAttriString:@"*" color:UIColorFromRGB(0xF56C6C) font:[UIFont regularFont:13]];
    }
    return _titleLB;
}
- (UIImageView*) licenseImage {
    if (!_licenseImage) {
        _licenseImage = [[UIImageView alloc] init];
    }
    return _licenseImage;
}
- (UIImageView*) dianImage {
    if (!_dianImage) {
        _dianImage = [[UIImageView alloc] init];
    }
    return _dianImage;
}

@end


@interface FEStoreDetailCommondCell()

@property (nonatomic, strong) UIButton* modifyBtn;
@property (nonatomic, strong) UIButton* deletedBtn;

@end
@implementation FEStoreDetailCommondCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
        [self.contentView addSubview:self.modifyBtn];
        [self.contentView addSubview:self.deletedBtn];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    CGFloat width = (kScreenWidth - 16*2 - 10)/2 ;
    [self.modifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(width));
        make.height.mas_equalTo(40);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(-16);
        
    }];
    
    [self.deletedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(width));
        make.height.mas_equalTo(40);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-16);
    }];
    
}
-(void) modifyAcion:(UIButton*)btn {
    !self.modifyActionBlock?:self.modifyActionBlock();
}
-(void) deleteAcion:(UIButton*)btn {
    !self.deleteActionBlock?:self.deleteActionBlock();
}
- (UIButton*) modifyBtn {
    if (!_modifyBtn) {
        _modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _modifyBtn.backgroundColor = UIColorFromRGB(0x283C50);
        [_modifyBtn setTitle:@"修改店铺信息" forState:UIControlStateNormal];
        _modifyBtn.titleLabel.font = [UIFont mediumFont:16];
        [_modifyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _modifyBtn.cornerRadius = 20;
        [_modifyBtn addTarget:self action:@selector(modifyAcion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _modifyBtn;
}
- (UIButton*) deletedBtn {
    if (!_deletedBtn) {
        _deletedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deletedBtn.backgroundColor = UIColorFromRGB(0x283C50);
        [_deletedBtn setTitle:@"删除店铺" forState:UIControlStateNormal];
        _deletedBtn.titleLabel.font = [UIFont mediumFont:16];
        [_deletedBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _deletedBtn.cornerRadius = 20;
        [_deletedBtn addTarget:self action:@selector(deleteAcion:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletedBtn;
}

@end



@interface FEStoreDetailPingtaiTitleCell()
@property(nonatomic,strong) UILabel* titleLB;
@end
@implementation FEStoreDetailPingtaiTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
        [self.contentView addSubview:self.titleLB];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(20);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(26);
        make.right.equalTo(self.contentView.mas_right).offset(-26);
        
    }];
    
}
- (UILabel*) titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = UIColorFromRGB(0x333333);
        _titleLB.font = [UIFont mediumFont:15];
        _titleLB.attributedText = nil;
        
        _titleLB.text = @"配送平台审核状态";
    }
    return _titleLB;
}


@end


@interface FEStoreDetailPingtaiCell()

@property (nonatomic, strong) FELogisticsModel* model;
@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UIImageView* flagImage;
@property (nonatomic, strong) UILabel* titleLB;
@property (nonatomic, strong) UIButton* modifuBtn;
@property (nonatomic, strong) UIView* statusView;
@property (nonatomic, strong) UIView* statusImage;
@property (nonatomic, strong) UILabel* statusLB;
@end
@implementation FEStoreDetailPingtaiCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.flagImage];
        [self.bgView addSubview:self.titleLB];
        [self.bgView addSubview:self.modifuBtn];
        [self.bgView addSubview:self.statusView];
        [self.statusView addSubview:self.statusImage];
        [self.statusView addSubview:self.statusLB];
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
    [self.flagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(26);
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.centerY.equalTo(self.bgView.mas_centerY);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flagImage.mas_left).offset(10);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.height.mas_equalTo(@(20));
    }];
    
    
    [self.modifuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.statusView.mas_left).offset(-10);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.height.mas_equalTo(@(25));
        make.width.mas_equalTo(@(50));
        
    }];
    
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(self.statusLB.width + 30));
        make.height.mas_equalTo(@(25));
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.right.equalTo(self.statusLB.mas_right).offset(10);
    }];
    
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(6));
        make.height.mas_equalTo(@(6));
        make.centerY.equalTo(self.statusImage.mas_centerY);
        make.right.equalTo(self.statusLB.mas_left).offset(-5);
    }];
    
    [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@(25));
        make.centerY.equalTo(self.statusImage.mas_centerY);
        make.right.equalTo(self.statusLB.mas_right).offset(-16);
    }];
    
}
- (void) setModel:(FELogisticsModel*) model{
    _model = model;
//    self.flagImage.image = [UIImage imageNamed:@""];
    self.titleLB.text = model.logisticName;
    self.statusLB.text = model.statusName;
#warning 需要修正cell参数
    
//    @property (nonatomic, assign) NSInteger status;//审核状态
//
//    @property (nonatomic, copy) NSString *logistic;//平台枚举
//
//    @property (nonatomic, copy) NSString *logisticName;//平台名称
//
//    @property (nonatomic, copy) NSString *statusName;//审核状态名称
    
    
}
- (void) modifyAcion:(UIButton*) btn {
    !self.modifyAcionBlock?:self.modifyAcionBlock(self.model);
    
}
- (UIView*) bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.cornerRadius = 15;
    }
    return _bgView;
}
- (UILabel*) titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.textColor = UIColorFromRGB(0x333333);
        _titleLB.font = [UIFont mediumFont:14];
        
    }
    return _titleLB;
}
- (UIImageView*) flagImage {
    if (!_flagImage) {
        _flagImage = [[UIImageView alloc] init];
    }
    return _flagImage;
}
- (UIButton*) modifuBtn {
    if (!_modifuBtn) {
        _modifuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_modifuBtn setTitle:@"修改" forState:UIControlStateNormal];
        [_modifuBtn setBackgroundColor:UIColorFromRGB(0x000000)];
        [_modifuBtn addTarget:self action:@selector(modifyAcion:) forControlEvents:UIControlEventTouchUpInside];
        [_modifuBtn setTitleColor:UIColorFromRGB(0x12B398) forState:UIControlStateNormal];
        _modifuBtn.cornerRadius = 12.5;
        _modifuBtn.borderColor = UIColorFromRGB(0x12B398);
        _modifuBtn.borderWidth = 1;
    }
    return _modifuBtn;
}


- (UIView*) statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] init];
        _statusView.backgroundColor = UIColorFromRGB(0xEFF3F8);
        _statusView.cornerRadius = 12.5;
    }
    return _statusView;
}

//[self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.width.mas_equalTo(@(self.statusLB.width + 30));
//    make.height.mas_equalTo(@(25));
//    make.centerY.equalTo(self.bgView.mas_centerY);
//    make.right.equalTo(self.statusLB.mas_right).offset(10);
//}];
//
//[self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
//    make.width.mas_equalTo(@(6));
//    make.height.mas_equalTo(@(6));
//    make.centerY.equalTo(self.statusImage.mas_centerY);
//    make.right.equalTo(self.statusLB.mas_left).offset(-5);
//}];
//
//[self.statusLB ma
//
- (UIView*) statusImage {
    if (!_statusImage) {
        _statusImage = [[UIView alloc] init];
        _statusImage.backgroundColor = UIColor.whiteColor;
        _statusImage.cornerRadius = 3;
    }
    return _statusImage;
}
- (UILabel*) statusLB {
    if (!_statusLB) {
        _statusLB = [[UILabel alloc] init];
        _statusLB.textColor = UIColorFromRGB(0x283C50);
        _statusLB.font = [UIFont regularFont:12];
    }
    return _statusLB;
}
@end
