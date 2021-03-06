//
//  FEHomeWorkCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/14.
//

#import "FEHomeWorkCell.h"
#import "FEHomeWorkModel.h"
#import <Masonry/Masonry.h>
#import "FEDefineModule.h"


@interface FEHomeWorkCell ()
@property (nonatomic, strong) FEHomeWorkOrderModel* model;

@property (nonatomic,strong) UIView* bgView;

@property (nonatomic, strong) UILabel* statusTimeLB;
@property (nonatomic, strong) UILabel* statusLB;
@property (nonatomic, strong) UIImageView* accessoryImage;


@property (nonatomic,strong) UIView* sendBgView;
@property (nonatomic, strong) UIImageView* sendImage;
@property (nonatomic, strong) UILabel* sendNameLB;
@property (nonatomic, strong) UILabel* sendDescLB;

@property (nonatomic,strong) UIView* reciveBgView;
@property (nonatomic, strong) UIImageView* reciveImage;
@property (nonatomic, strong) UILabel* reciveNameLB;
@property (nonatomic, strong) UILabel* reciveDescLB;


@property (nonatomic, strong) UIView* centerLine;
@property (nonatomic, strong) UILabel* orderTimeLB;
@property (nonatomic, strong) UIScrollView* commondView;
@end


@implementation FEHomeWorkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xF6F7F9);
        [self.contentView addSubview:self.bgView];
        
        [self.bgView addSubview:self.statusTimeLB];
        [self.bgView addSubview:self.statusLB];
        [self.bgView addSubview:self.accessoryImage];
        
        [self.bgView addSubview:self.sendBgView];
        [self.sendBgView addSubview:self.sendImage];
        [self.sendBgView addSubview:self.sendNameLB];
        [self.sendBgView addSubview:self.sendDescLB];
        
        [self.bgView addSubview:self.reciveBgView];
        [self.reciveBgView addSubview:self.reciveImage];
        [self.reciveBgView addSubview:self.reciveNameLB];
        [self.reciveBgView addSubview:self.reciveDescLB];
        
        [self.bgView addSubview:self.centerLine];
        
        [self.bgView addSubview:self.orderTimeLB];
        [self.bgView addSubview:self.commondView];
    }
        
    return self;
}
- (void) layoutSubviews{
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.statusTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.top.equalTo(self.bgView.mas_top).offset(16);
        make.height.mas_equalTo(@(18));
    }];
    [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accessoryImage.mas_left).offset(-5);
        make.centerY.equalTo(self.statusTimeLB.mas_centerY);
    }];
    [self.accessoryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(12));
        make.height.mas_equalTo(@(12));
        make.centerY.equalTo(self.statusTimeLB.mas_centerY);
        make.right.equalTo(self.bgView.mas_right).offset(-14);
    }];
    
    [self.sendBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.top.equalTo(self.statusTimeLB.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
    }];
    
    [self.sendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendBgView.mas_left);
        make.width.height.mas_equalTo(@(18));
        make.centerY.equalTo(self.sendBgView.mas_centerY);
    }];
    [self.sendNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendImage.mas_right).offset(10);
        make.top.equalTo(self.sendBgView.mas_top);
        make.right.equalTo(self.sendBgView.mas_right);
        make.height.mas_equalTo(21);
    }];
    [self.sendDescLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.sendNameLB);
        make.top.equalTo(self.sendNameLB.mas_bottom).offset(2);
        make.height.mas_equalTo(17);
        
    }];
    
    
    [self.reciveBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.top.equalTo(self.sendBgView.mas_bottom).offset(18);
        make.height.mas_equalTo(40);
    }];
    [self.reciveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reciveBgView.mas_left);
        make.width.height.mas_equalTo(@(18));
        make.centerY.equalTo(self.reciveBgView.mas_centerY);
    }];
    [self.reciveNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reciveImage.mas_right).offset(10);
        make.top.equalTo(self.reciveBgView.mas_top);
        make.right.equalTo(self.reciveBgView.mas_right);
        make.height.mas_equalTo(21);
    }];
    [self.reciveDescLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.reciveNameLB);
        make.top.equalTo(self.reciveNameLB.mas_bottom).offset(2);
        make.height.mas_equalTo(17);
    }];
    
    [self.centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.top.equalTo(self.reciveDescLB.mas_bottom).offset(16);
        make.height.mas_equalTo(@(0.5));
    }];
    
    [self.orderTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.centerY.equalTo(self.commondView.mas_centerY);
        make.height.mas_equalTo(@(18));
    }];
    
    [self.commondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerLine.mas_bottom).offset(10);
        make.left.equalTo(self.orderTimeLB.mas_right);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.height.mas_equalTo(@(26));
    }];
    
}
+ (void) calculationCellHeight:(FEHomeWorkOrderModel*)model{
    if (model.workCellH == 0) {
    
        CGFloat width = kScreenWidth - 10*2 - 16*2 - 18 - 10;
        CGFloat heigt = 10;
        heigt += (16 + 18);
        heigt += (20 + 40);//send
        heigt += (18 + 40);//recive
        heigt += (16 + 0.5);//line
        heigt += (26 + 20);//Commond
        CGSize size = [model.createTimeStr sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(CGFLOAT_MAX, 15)];
        model.orderTimeMaxX = MIN(ceil(size.width), 100) + 16;
        // 10,//?????????  20, //????????? //????????? //????????? //?????????
        switch (model.status) {
            case 10:{//?????????
                FEOrderCommond* item = [FEOrderCommond new];
                item.commodType = FEOrderCommondCancel;
                item.commodName = @"????????????";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item.commodWidth = ceil(size.width) + 30;
                
                FEOrderCommond* item1 = [FEOrderCommond new];
                item1.commodType = FEOrderCommondAddCheck;
                item1.commodName = @"?????????";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item1.commodWidth = ceil(size.width) + 30;
                model.commonds = @[item,item1];
            }break;
            case 20:
            case 30:
            case 40:{//?????????
                FEOrderCommond* item = [FEOrderCommond new];
                item.commodType = FEOrderCommondCancel;
                item.commodName = @"????????????";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item.commodWidth = ceil(size.width) + 30;
                
                FEOrderCommond* item1 = [FEOrderCommond new];
                item1.commodType = FEOrderCommondCallRider;
                item1.commodName = @"????????????";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item1.commodWidth = ceil(size.width) + 30;
                model.commonds = @[item,item1];
            }break;
            case 50:
            case 60:
            case 70:{
                FEOrderCommond* item = [FEOrderCommond new];
                item.commodType = FEOrderCommondRetry;
                item.commodName = @"????????????";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item.commodWidth = ceil(size.width) + 30;
                
                FEOrderCommond* item1 = [FEOrderCommond new];
                item1.commodType = FEOrderCommondCallRider;
                item1.commodName = @"????????????";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item1.commodWidth = ceil(size.width) + 30;
                model.commonds = @[item,item1];
            }break;
            default:
                break;
        }
        
        model.workCellH = heigt;
    }
}


- (void) setModel:(FEHomeWorkOrderModel*) model {
    _model = model;
    
    self.statusTimeLB.text = model.showStuseTimeStr;
    self.statusLB.text = [FEPublicMethods SafeString:model.statusName];
    
    self.sendNameLB.text = model.storeName;
    self.sendDescLB.text = [NSString stringWithFormat:@"%@ %@",model.fromAddress,model.fromAddressDetail];
    self.reciveNameLB.text = [FEPublicMethods SafeString:model.toAdress];
    self.reciveDescLB.text = [NSString stringWithFormat:@"%@???%@",
                              [FEPublicMethods SafeString:model.toUserName],
                              [FEPublicMethods SafeString:model.toUserMobile]];
    
    self.orderTimeLB.text = [FEPublicMethods SafeString:model.createTimeStr];
    
    [self resetCommondView:model];

}
- (void) resetCommondView:(FEHomeWorkOrderModel*) model {
    [self.commondView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat offx = kScreenWidth - 10*2 - 16;
    CGFloat offW = offx - model.orderTimeMaxX;
    for (FEOrderCommond* item in model.commonds) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:item.commodName forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont regularFont:13];
        btn.tag = item.commodType;
        [btn addTarget:self action:@selector(commondActoin:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(offW - item.commodWidth, 0, item.commodWidth, 26);

        btn.cornerRadius = 13;
        btn.borderColor = UIColorFromRGB(0xDBDBDB);
        btn.borderWidth = 0.5;
        offW -= item.commodWidth;
        offW -= 10;
        [self.commondView addSubview:btn];
        
    }
    
    
    
}
- (void) commondActoin:(UIButton*)btn {
    !_cellCommondActoin?:_cellCommondActoin(btn.tag);
}


-(UIView*) bgView {
    if(!_bgView){
        _bgView = [UIView new];
        _bgView.backgroundColor = UIColor.whiteColor;
        _bgView.cornerRadius = 15;
    }
    return _bgView;
}

-(UILabel*) statusTimeLB{
    if (!_statusTimeLB) {
        _statusTimeLB = [UILabel new];
        _statusTimeLB.font = [UIFont mediumFont:13];
        _statusTimeLB.textColor = UIColorFromRGB(0x555555);
    }
    return _statusTimeLB;
}
-(UILabel*) statusLB{
    if (!_statusLB) {
        _statusLB = [UILabel new];
        _statusLB.font = [UIFont regularFont:13];
        _statusLB.textColor = UIColorFromRGB(0x12B398);
    }
    return _statusLB;
}
-(UIImageView*) accessoryImage{
    if (!_accessoryImage) {
        _accessoryImage = [UIImageView new];
        _accessoryImage.image = [UIImage imageNamed:@"cell_more"];
    }
    return _accessoryImage;
}




-(UIView*) sendBgView {
    if(!_sendBgView){
        _sendBgView = [UIView new];
        _sendBgView.backgroundColor = UIColor.whiteColor;
        _sendBgView.cornerRadius = 15;
    }
    return _sendBgView;
}


-(UIImageView*) sendImage{
    if (!_sendImage) {
        _sendImage = [UIImageView new];
        _sendImage.image = [UIImage imageNamed:@"home_dian"];
    }
    return _sendImage;
}
-(UILabel*) sendNameLB{
    if (!_sendNameLB) {
        _sendNameLB = [UILabel new];
        _sendNameLB.font = [UIFont mediumFont:15];
        _sendNameLB.textColor = UIColorFromRGB(0x333333);
    }
    return _sendNameLB;
}
-(UILabel*) sendDescLB{
    if (!_sendDescLB) {
        _sendDescLB = [UILabel new];
        _sendDescLB.font = [UIFont regularFont:12];
        _sendDescLB.textColor = UIColorFromRGB(0x777777);
    }
    return _sendDescLB;
}


-(UIView*) reciveBgView {
    if(!_reciveBgView){
        _reciveBgView = [UIView new];
        _reciveBgView.backgroundColor = UIColor.whiteColor;
        _reciveBgView.cornerRadius = 15;
    }
    return _reciveBgView;
}

-(UIImageView*) reciveImage{
    if (!_reciveImage) {
        _reciveImage = [UIImageView new];
        _reciveImage.image = [UIImage imageNamed:@"home_recive"];
    }
    return _reciveImage;
}
-(UILabel*) reciveNameLB{
    if (!_reciveNameLB) {
        _reciveNameLB = [UILabel new];
        _reciveNameLB.font = [UIFont mediumFont:15];
        _reciveNameLB.textColor = UIColorFromRGB(0x333333);
    }
    return _reciveNameLB;
}
-(UILabel*) reciveDescLB{
    if (!_reciveDescLB) {
        _reciveDescLB = [UILabel new];
        _reciveDescLB.font = [UIFont regularFont:12];
        _reciveDescLB.textColor = UIColorFromRGB(0x777777);
    }
    return _reciveDescLB;
}


-(UIView*) centerLine{
    if (!_centerLine) {
        _centerLine = [UIView new];
        _centerLine.backgroundColor = UIColorFromRGBA(0x000000,0.06);
    }
    return _centerLine;
}

-(UILabel*) orderTimeLB{
    if (!_orderTimeLB) {
        _orderTimeLB = [UILabel new];
        _orderTimeLB.font = [UIFont regularFont:13];
        _orderTimeLB.textColor = UIColorFromRGB(0x777777);
        
    }
    return _orderTimeLB;
}

-(UIScrollView*) commondView{
    if (!_commondView) {
        _commondView = [UIScrollView new];
        _commondView.backgroundColor = UIColor.whiteColor;
        _commondView.showsVerticalScrollIndicator = NO;
        _commondView.showsHorizontalScrollIndicator = NO;
        _commondView.scrollEnabled = NO;
        
    }
    return _commondView;
}

@end
