//
//  FEOrderDetailHeaderCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/25.
//

#import "FEOrderDetailHeaderCell.h"
#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"
#import "FEMapAnnotationView.h"


@interface FEOrderDetailHeaderCell ()
@property (nonatomic, strong)FEOrderDetailModel* model;

@property (nonatomic, weak) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewH;
@property (weak, nonatomic) IBOutlet UIButton *freshBtn;


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
    self.contentView.backgroundColor = UIColorFromRGB(0xF6F7F9);
    
}


+(CGFloat) calculationCellHeight:(FEOrderDetailModel*)model {
    if (model.orderDetailHeaderCellH != 0) {
        return model.orderDetailHeaderCellH;
    }
    CGFloat width = kScreenWidth - 10*2 - 16*2;
    CGFloat heigt = 0;
    if (model.status == 10 || model.status == 20 || model.status == 30|| model.status == 40) {
        model.orderDetailHeaderMapH = kScreenHeight/3;
        heigt += model.orderDetailHeaderMapH;
    } else {
        model.orderDetailHeaderMapH = 0;
    }

    heigt += 30;
    CGSize size = [model.orderStatusDescName sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
    heigt += ceil(size.height);

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
        case 60:{
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
    } else {
        
    }
    heigt += 20;
    model.orderDetailHeaderBottomH = heigt - model.orderDetailHeaderMapH + 20;
    model.orderDetailHeaderCellH = heigt;
    return model.orderDetailHeaderCellH;
}
- (void) setModel:(FEOrderDetailModel*)model {
    _model = model;

    self.mapView.hidden = model.orderDetailHeaderMapH == 0;
    self.mapViewH.constant = model.orderDetailHeaderMapH;
    self.bottomViewH.constant = model.orderDetailHeaderBottomH;
    
    self.statusNameLB.text = model.orderStatusTipName;
    self.StatusDesLB.text = model.orderStatusDescName;

    self.statusView.hidden = model.commonds.count == 0;
    [self resetCommondView:model];

}
- (void) resetCommondView:(FEOrderDetailModel*) model {
    [self.statusView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGFloat offx = 0;
    for (FEOrderCommond* item in model.commonds) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:item.commodName forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x12B398) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont regularFont:13];
        btn.tag = item.commodType;
        [btn addTarget:self action:@selector(commondActoin:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(offx, 0, item.commodWidth, 30);

        
        btn.cornerRadius = 15;
        btn.borderColor = UIColorFromRGB(0x12B398);
        btn.borderWidth = 0.5;
       
        [self.statusView addSubview:btn];
        offx += (10 + item.commodWidth);
    }
}



- (IBAction)freshAction:(id)sender {
    
    !_refreshActoin?:_refreshActoin();
    
}
- (void) commondActoin:(UIButton*)btn {
    !_cellCommondActoin?:_cellCommondActoin(btn.tag);
}


@end
