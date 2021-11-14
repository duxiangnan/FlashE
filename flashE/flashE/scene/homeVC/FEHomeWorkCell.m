//
//  FEHomeWorkCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/14.
//

#import "FEHomeWorkCell.h"
#import "FEHomeWorkModel.h"
@interface FEHomeWorkCell ()
@property (nonatomic, strong) FEHomeWorkOrderModel* model;

@end


@implementation FEHomeWorkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
        
    return self;
}
+ (void) calculationCellHeighti:(FEHomeWorkOrderModel*)model{
    
    
}


- (void) setModel:(FEHomeWorkOrderModel*) model {
    _model = model;
    
}
@end
