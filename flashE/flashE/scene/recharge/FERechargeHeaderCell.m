//
//  FERechargeHeaderCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/22.
//

#import "FERechargeHeaderCell.h"
#import "FEDefineModule.h"
#import "FERechargeModel.h"


@interface FERechargeHeaderPageInfoCell : UICollectionViewCell
@property (nonatomic, strong) FERechargeModel * model;
@property (nonatomic, strong) UILabel* titleLabel;

- (void)setModel:(FERechargeModel *)model;
@end

@implementation FERechargeHeaderPageInfoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        
        [self buildView];
    }
    return self;
}

- (void)buildView
{
    _titleLabel = [UILabel new];
    _titleLabel.font = [UIFont mediumFont:14];
    _titleLabel.textColor = UIColorFromRGB(0x333333);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.layer.cornerRadius = 8;
    [self.contentView addSubview:_titleLabel];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.bottom.top.equalTo(self.contentView);
    }];

}

- (void)setModel:(FERechargeModel *)model
{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"%0.2ld元",(long)model.amount];
    
    if (model.selected) {
        self.titleLabel.textColor = UIColorFromRGB(0x12B398);
        self.titleLabel.borderWidth = 0.5;
        self.titleLabel.borderColor = UIColorFromRGB(0x12B398);
        self.titleLabel.backgroundColor = UIColorFromRGBA(0x12B398,0.1);
    } else {
        self.titleLabel.textColor = UIColorFromRGB(0x333333);
        self.titleLabel.borderWidth = 0;
        self.titleLabel.borderColor = nil;
        self.titleLabel.backgroundColor = UIColorFromRGB(0xF7F8F9);
    }
}
@end


@interface FERechargeHeaderCell ()
@property (nonatomic,strong) FERechargeTotalModel* model;

@property (weak, nonatomic) IBOutlet UIView *hearderView;
@property (weak, nonatomic) IBOutlet UILabel *jineLB;

@property (weak, nonatomic) IBOutlet UICollectionView *rechargeCollection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rechargeCollectionH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rechargeCollectionT;

@property (weak, nonatomic) IBOutlet UIButton *payTypeWeixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *argeenBtn;



@end


@implementation FERechargeHeaderCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self updataSubView];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self updataSubView];
    }
    return self;
}
- (void) updataSubView {
    
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.contentView.backgroundColor = UIColorFromRGB(0xF6F7F9);
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    CGFloat width = (kScreenWidth - 16*2 - 10*2 - 10*2)/3;
    layout.itemSize =CGSizeMake(width, 50);
    self.rechargeCollection.collectionViewLayout = layout;
    [self.rechargeCollection registerClass:[FERechargeHeaderPageInfoCell class] forCellWithReuseIdentifier:@"FERechargeHeaderPageInfoCell"];
    self.payTypeWeixinBtn.selected = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}
+(CGFloat) calculationCellHeight:(FERechargeTotalModel*)model {
    if (model.list.count > 0) {
        NSInteger num = ceil(model.list.count/3);
        CGFloat x =  (50+10)*num - 10;
        return 10 + 48 + 20+15+x+ 20 + 20 +10 + 20+10+48+20+44;
    }
    return 10 + 48 + 20 + 20 + 20 +10 + 20+10+48+20+44;
    
}

- (void) setModel:(FERechargeTotalModel*) model{
    _model = model;
    self.jineLB.text = [NSString stringWithFormat:@"%0.2f",model.balance];
    if (model.list.count > 0) {
        NSInteger num = ceil(model.list.count/3);
        CGFloat x =  (50+10)*num - 10;
        self.rechargeCollectionH.constant = x;
        self.rechargeCollectionT.constant = 15;
    } else {
        self.rechargeCollectionH.constant = 0;
        self.rechargeCollectionT.constant = 0;
    }
    [self.rechargeCollection reloadData];
}

- (IBAction)payTypeAction:(UIButton*)sender {
    self.payTypeWeixinBtn.selected = sender==self.payTypeWeixinBtn;
}

- (IBAction)argeenAction:(UIButton*)sender {
    self.argeenBtn.selected = !self.argeenBtn.selected;
}
- (IBAction)argeenInfoAction:(id)sender {
}

- (IBAction)rechargeAction:(id)sender {
    if (!self.argeenBtn.selected) {
        [MBProgressHUD showMessage:@"勾选充值协议"];
        return;
    }
    __block FERechargeModel* item = nil;
    
    [self.model.list enumerateObjectsUsingBlock:^(FERechargeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.selected) {
            item = obj;
            *stop = YES;
        }
    }];
    NSInteger type = 0;
    if (self.payTypeWeixinBtn.selected) {
        type = 1;
    }
    !self.rechargeAction?:self.rechargeAction(item,type);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.model.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FERechargeHeaderPageInfoCell *cell = [collectionView
                                                 dequeueReusableCellWithReuseIdentifier:@"FERechargeHeaderPageInfoCell" forIndexPath:indexPath];
    [cell setModel:self.model.list[indexPath.row]];
    
    return cell;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.model.list enumerateObjectsUsingBlock:^(FERechargeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
        if (idx == indexPath.row) {
            obj.selected = YES;
        }
    }];
    [collectionView reloadData];
    
}


@end
