//
//  FEOrderDetailLogisticsCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/25.
//

#import "FEOrderDetailLogisticsCell.h"

#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"

@interface FEOrderDetailLogisticsCell ()
@property (nonatomic, strong)FEOrderDetailModel* model;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewH;
@property (weak, nonatomic) IBOutlet UILabel *orderInfoLb;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLB;
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLB;


@property (weak, nonatomic) IBOutlet UITableView *table;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;


@end

@implementation FEOrderDetailLogisticsCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorFromRGB(0xF6F7F9);
    
}


+(CGFloat) calculationCellHeight:(FEOrderDetailModel*)model {
    
    return 0;
}
- (void) setModel:(FEOrderDetailModel*)model {
    _model = model;
}
- (IBAction)copyAcion:(id)sender {
}


@end
