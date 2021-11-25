//
//  FEOrderDetailAddressCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/25.
//

#import "FEOrderDetailAddressCell.h"

#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"

@interface FEOrderDetailAddressCell ()
@property (nonatomic, strong)FEOrderDetailModel* model;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *fromView;
@property (weak, nonatomic) IBOutlet UILabel *fromNameLB;
@property (weak, nonatomic) IBOutlet UILabel *fromeDescLB;
@property (weak, nonatomic) IBOutlet UIView *toView;
@property (weak, nonatomic) IBOutlet UILabel *toNameLB;
@property (weak, nonatomic) IBOutlet UILabel *toDeasLB;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@end


@implementation FEOrderDetailAddressCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorFromRGB(0xF6F7F9);
    
}


+(CGFloat) calculationCellHeight:(FEOrderDetailModel*)model {
    
    return 150;
}
- (void) setModel:(FEOrderDetailModel*)model {
    _model = model;
    
    self.fromNameLB.text = [FEPublicMethods SafeString:model.storeName];
    self.fromeDescLB.text = [FEPublicMethods SafeString:model.fromAddressDetail];
    
    
    self.toNameLB.text = [NSString stringWithFormat:@"%@　%@",
                              [FEPublicMethods SafeString:model.toAdress],
                              [FEPublicMethods SafeString:model.toAdressDetail]];
    self.toDeasLB.text = [NSString stringWithFormat:@"%@　%@",
                              [FEPublicMethods SafeString:model.toUserName],
                              [FEPublicMethods SafeString:model.toUserMobile]];
    
}
- (IBAction)phoneAcion:(id)sender {
    NSString* phone = [NSString stringWithFormat:@"tel://%@",self.model.toUserMobile];
    [FEPublicMethods openUrlInSafari:phone];
}


@end
