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
//    waitServerSure phoneDic
    NSDictionary* phoneDic = @{
        @"1":@"4006126688",//闪送
        @"2":@"顺丰同城：9533868",//顺丰同城
        @"3":@"10107888",//美团跑腿
        @"4":@"4008827777",//蜂鸟即配
        @"5":@"4009919512",//达达
        @"6":@"4006997999",//UU跑腿
    };
    NSString* phone = [NSString stringWithFormat:@"tel://%@",phoneDic[@"1"]];
    [FEPublicMethods openUrlInSafari:phone];
}

@end
