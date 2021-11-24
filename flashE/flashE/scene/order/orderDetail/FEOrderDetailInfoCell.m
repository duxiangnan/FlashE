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
@property (weak, nonatomic) IBOutlet UILabel *orderQujianDateLB;
@property (weak, nonatomic) IBOutlet UILabel *goodWeightLB;
@property (weak, nonatomic) IBOutlet UILabel *remarkLB;





@end


@implementation FEOrderDetailInfoCell
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

@end
