//
//  FEOrderDetailHeaderCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/25.
//

#import "FEOrderDetailHeaderCell.h"
#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"


@interface FEOrderDetailHeaderCell ()
@property (nonatomic, strong)FEOrderDetailModel* model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BGViewH;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLB;
@property (weak, nonatomic) IBOutlet UILabel *StatusDesLB;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewH;



@end


@implementation FEOrderDetailHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColor.clearColor;//UIColorFromRGB(0xF6F7F9);
    self.backgroundColor = UIColor.clearColor;
   
}


+(CGFloat) calculationCellHeight:(FEOrderDetailModel*)model {
    if (model.orderDetailHeaderCellH != 0) {
        return model.orderDetailHeaderCellH;
    }
    CGFloat width = kScreenWidth - 10*2 - 16*2;
    CGFloat heigt = (25 + 20);
    CGSize size = [model.scheduleInfo sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
    heigt += (4 + ceil(size.height));

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
    if (model.commonds.count > 0) {
        heigt += (10 + 30);
    }
    model.orderDetailHeaderBGH = heigt;
    model.orderDetailHeaderBottomH = model.orderDetailHeaderBGH + 20;
    heigt += 20;
    model.orderDetailHeaderCellH = heigt;
    return model.orderDetailHeaderCellH;
}
- (void) setModel:(FEOrderDetailModel*)model {
    _model = model;
    self.BGViewH.constant = model.orderDetailHeaderBGH;
    self.bottomViewH.constant = model.orderDetailHeaderBottomH;
    self.statusNameLB.text = model.scheduleTitle;
    self.StatusDesLB.text = model.scheduleInfo;

    self.statusView.hidden = model.commonds.count == 0;
    [self resetCommondView:model];

}
- (void) resetCommondView:(FEOrderDetailModel*) model {
    [self.statusView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat offx = 0;
    for (FEOrderCommond* item in model.commonds) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:item.commodName forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont regularFont:13];
        btn.tag = item.commodType;
        [btn addTarget:self action:@selector(commondActoin:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(offx, 0, item.commodWidth, 30);

        
        btn.cornerRadius = 15;
        btn.borderColor = UIColorFromRGB(0xDBDBDB);
        btn.borderWidth = 0.5;
       
        [self.statusView addSubview:btn];
        offx += (10 + item.commodWidth);
    }
}



- (void) commondActoin:(UIButton*)btn {
    !_cellCommondActoin?:_cellCommondActoin(btn.tag);
}



@end
