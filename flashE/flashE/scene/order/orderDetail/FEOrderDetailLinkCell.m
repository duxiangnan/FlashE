//
//  FEOrderDetailLinkCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/26.
//

#import "FEOrderDetailLinkCell.h"


#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"

@interface FEOrderDetailLinkCell ()
@property (nonatomic, strong)FEOrderDetailModel* model;

@property (weak, nonatomic) IBOutlet UIButton *linkBtn;

@end



@implementation FEOrderDetailLinkCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorFromRGB(0xF6F7F9);
    
}


- (void) setModel:(FEOrderDetailModel*)model {
    _model = model;
}


- (IBAction)phoneAcion:(id)sender {
//    NSString* phone = @"";
//    for (FEOrderDtailLogisticModel* item in self.model.logistics) {
//        if (item.logistic == self.model.logistic) {
//            phone = item.phone;
//        }
//    }
//    if (phone.length == 0) {
//        NSDictionary* phoneDic = @{
//            @"bingex":@"4006126688",//闪送
//            @"shunfeng":@"9533868",//顺丰同城
//            @"mtps":@"10107888",//美团跑腿
//            @"fengka":@"4008827777",//蜂鸟即配
//            @"dada":@"4009919512",//达达
//            @"uupt":@"4006997999",//UU跑腿
//        };
//        phone = phoneDic[self.model.logistic];
//    }
    [FEPublicMethods openUrlInSafari:@"tel://18511253751"];
}

@end
