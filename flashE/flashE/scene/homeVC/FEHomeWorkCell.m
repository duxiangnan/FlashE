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



@property (nonatomic, strong) UIImageView* sendImage;
@property (nonatomic, strong) UILabel* sendNameLB;
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
        self.contentView.backgroundColor = UIColorFromRGB(0xEFF1F3);
        [self.contentView addSubview:self.bgView];
        
        [self.bgView addSubview:self.statusTimeLB];
        [self.bgView addSubview:self.statusLB];
        [self.bgView addSubview:self.accessoryImage];
        
        [self.bgView addSubview:self.sendImage];
        [self.bgView addSubview:self.sendNameLB];
        
        [self.bgView addSubview:self.reciveImage];
        [self.bgView addSubview:self.reciveNameLB];
        [self.bgView addSubview:self.reciveDescLB];
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
        make.top.equalTo(self.bgView.mas_top).offset(10);
        make.height.mas_equalTo(@(20));
    }];
    [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.accessoryImage.mas_left).offset(-5);
        make.centerY.equalTo(self.statusTimeLB.mas_centerY);
    }];
    [self.accessoryImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@(12));
        make.height.mas_equalTo(@(12));
        make.centerY.equalTo(self.statusTimeLB.mas_centerY);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
    
    [self.sendImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusTimeLB.mas_left);
        make.width.height.mas_equalTo(@(18));
        make.centerY.equalTo(self.sendNameLB.mas_centerY);
    }];
    [self.sendNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sendImage.mas_right).offset(10);
        make.top.equalTo(self.statusTimeLB.mas_bottom).offset(20);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
    }];
 
    
    
    [self.reciveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusTimeLB.mas_left);
        make.width.height.mas_equalTo(@(18));
        make.centerY.equalTo(self.reciveNameLB.mas_centerY);
    }];
    [self.reciveNameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reciveImage.mas_right).offset(10);
        make.top.equalTo(self.sendNameLB.mas_bottom).offset(15);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
    }];
    [self.reciveDescLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.reciveNameLB);
        make.top.equalTo(self.reciveNameLB.mas_bottom);
    }];
    
    [self.centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView.mas_left).offset(16);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.top.equalTo(self.reciveDescLB.mas_bottom).offset(15);
        make.height.mas_equalTo(@(0.5));
    }];
    
    [self.orderTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.statusTimeLB.mas_left);
        make.centerY.equalTo(self.commondView.mas_centerY);
        make.height.mas_equalTo(@(15));
    }];
    
    [self.commondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerLine.mas_bottom).offset(5);
        make.left.equalTo(self.orderTimeLB.mas_right);
        make.right.equalTo(self.bgView.mas_right).offset(-16);
        make.height.mas_equalTo(@(30));
    }];
    
}
+ (void) calculationCellHeight:(FEHomeWorkOrderModel*)model{
    if (model.workCellH == 0) {
    
        CGFloat width = kScreenWidth - 10*2 - 16*2 - 18 - 10;
        CGFloat heigt = 10;
        heigt += (20 + 10);
        
        CGSize size;
        //send
        heigt += 20;
        if (model.storeName.length > 0){
            size = [model.storeName sizeWithFont:[UIFont mediumFont:15] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
            heigt += (MIN(34, ceil(size.height)));
        }
        
        heigt += 15;
        //recive
        NSString* str = [NSString stringWithFormat:@"%@　%@",
                           [FEPublicMethods SafeString:model.toAdress],
                           [FEPublicMethods SafeString:model.toAdressDetail]];
        if (str.length > 0){
            size = [str sizeWithFont:[UIFont mediumFont:15] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
            heigt += (MIN(34, ceil(size.height)));
        }
        
        str = [NSString stringWithFormat:@"%@　%@",
                           [FEPublicMethods SafeString:model.toUserName],
                           [FEPublicMethods SafeString:model.toUserMobile]];
        if (str.length > 0){
            size = [str sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(CGFLOAT_MAX, 15)];
            heigt += (MIN(34, ceil(size.height)));
        }
        
        heigt += (15 + 0.5);
        
        size = [model.createTimeStr sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(CGFLOAT_MAX, 15)];
        model.orderTimeMaxX = MIN(ceil(size.width), 100) + 16;
//        if (1) {
//            heigt += (10 + 15 + 10);
//        } else {
            heigt += (5 + 30 + 5);
        // 10,//待接单  20, //待取单 //配送中 //已取消 //已完成
        switch (model.status) {
            case 10:{//待接单
                FEOrderCommond* item = [FEOrderCommond new];
                item.commodType = FEOrderCommondCancel;
                item.commodName = @"取消订单";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item.commodWidth = ceil(size.width) + 30;
                
                FEOrderCommond* item1 = [FEOrderCommond new];
                item1.commodType = FEOrderCommondAddCheck;
                item1.commodName = @"加小费";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item1.commodWidth = ceil(size.width) + 30;
                model.commonds = @[item,item1];
            }break;
            case 20:
            case 30:
            case 40:{//待取单
                FEOrderCommond* item = [FEOrderCommond new];
                item.commodType = FEOrderCommondCancel;
                item.commodName = @"取消订单";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item.commodWidth = ceil(size.width) + 30;
                
                FEOrderCommond* item1 = [FEOrderCommond new];
                item1.commodType = FEOrderCommondCallRider;
                item1.commodName = @"联系骑手";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item1.commodWidth = ceil(size.width) + 30;
                model.commonds = @[item,item1];
            }break;
            case 50:
            case 60:
            case 70:{
                FEOrderCommond* item = [FEOrderCommond new];
                item.commodType = FEOrderCommondRetry;
                item.commodName = @"重新发单";
                size = [item.commodName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
                item.commodWidth = ceil(size.width) + 30;
                
                FEOrderCommond* item1 = [FEOrderCommond new];
                item1.commodType = FEOrderCommondCallRider;
                item1.commodName = @"联系骑手";
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
    
    self.reciveNameLB.text = [NSString stringWithFormat:@"%@　%@",
                              [FEPublicMethods SafeString:model.toAdress],
                              [FEPublicMethods SafeString:model.toAdressDetail]];
    self.reciveDescLB.text = [NSString stringWithFormat:@"%@　%@",
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
        [btn setTitleColor:UIColorFromRGB(0x12B398) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont regularFont:13];
        btn.tag = item.commodType;
        [btn addTarget:self action:@selector(commondActoin:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(offW - item.commodWidth, 0, item.commodWidth, 30);

        btn.cornerRadius = 15;
        btn.borderColor = UIColorFromRGB(0x12B398);
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
        _sendNameLB.numberOfLines = 2;
        _sendNameLB.font = [UIFont mediumFont:15];
        _sendNameLB.textColor = UIColorFromRGB(0x333333);
    }
    return _sendNameLB;
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
        _reciveNameLB.numberOfLines = 2;
        _reciveNameLB.font = [UIFont mediumFont:15];
        _reciveNameLB.textColor = UIColorFromRGB(0x333333);
    }
    return _reciveNameLB;
}
-(UILabel*) reciveDescLB{
    if (!_reciveDescLB) {
        _reciveDescLB = [UILabel new];
        
        _reciveDescLB.font = [UIFont regularFont:13];
        _reciveDescLB.numberOfLines = 2;
        _reciveDescLB.textColor = UIColorFromRGB(0x777777);
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] init];
        [tap addTarget:self action:@selector(reciveDescAction:)];
        [_reciveDescLB addGestureRecognizer:tap];
    }
    return _reciveDescLB;
}


-(UIView*) centerLine{
    if (!_centerLine) {
        _centerLine = [UIView new];
        _centerLine.backgroundColor = UIColorFromRGB(0x999999);
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
