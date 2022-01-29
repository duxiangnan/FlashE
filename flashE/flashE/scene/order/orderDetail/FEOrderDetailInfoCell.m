//
//  FEOrderDetailInfoCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/25.
//

#import "FEOrderDetailInfoCell.h"

#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"

@interface FEOrderDetailInfoCell ()
@property (nonatomic, strong)FEOrderDetailModel* model;

@property (weak, nonatomic) IBOutlet UILabel *orderCreatTimeLB;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLB;
@property (weak, nonatomic) IBOutlet UILabel *orderQujianDateLB;
@property (weak, nonatomic) IBOutlet UILabel *goodWeightLB;
@property (weak, nonatomic) IBOutlet UILabel *remarkLB;





@end


@implementation FEOrderDetailInfoCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorFromRGB(0xF6F7F9);//UIColor.clearColor;//
//    self.backgroundColor = UIColor.clearColor;
    UITapGestureRecognizer*tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(orderNumAction:)];
    tap.delegate = self;
    [self.orderNumberLB addGestureRecognizer:tap];
    self.orderNumberLB.userInteractionEnabled = YES;
}


+(CGFloat) calculationCellHeight:(FEOrderDetailModel*)model {
    CGFloat height = 160;
    if(model.remark.length > 0){
        CGFloat width = kScreenWidth - 16*2 - 10*2 - 70 - 5;
        CGSize size = [model.remark sizeWithFont:[UIFont regularFont:13] andMaxSize:CGSizeMake(width, CGFLOAT_MAX)];
        height += 10;
        height += MAX(ceil(size.height), 20);
    } else {
        height += 30;
    }
    
    return height;
}
- (void) setModel:(FEOrderDetailModel*)model {
    _model = model;
    self.orderCreatTimeLB.text = [FEPublicMethods SafeString:self.model.createTimeStr];
    self.orderNumberLB.text = [NSString stringWithFormat:@"%lld | 复制",self.model.orderId];
    if (self.model.appointType == 1) {
        self.orderQujianDateLB.text = self.model.appointDateStr;
    } else {
        self.orderQujianDateLB.text = @"立即下单";
    }
    
    self.goodWeightLB.text = [NSString stringWithFormat:@"%@/%ld公斤",self.model.goodName,(long)self.model.weight];
    self.remarkLB.text = [FEPublicMethods SafeString:self.model.remark];
    
    
}


- (IBAction)orderNumAction:(id)sender {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    pab.string = [NSString stringWithFormat:@"%lld",self.model.orderId];
    if (pab == nil) {
        [MBProgressHUD showMessage:@"复制失败"];
    } else {
        [MBProgressHUD showMessage:@"复制成功"];
    }
    
}

@end
