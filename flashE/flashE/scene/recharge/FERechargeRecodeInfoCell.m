//
//  FERechargeRecodeInfoCell.m
//  flashE
//
//  Created by duxiangnan on 2022/1/29.
//

#import "FERechargeRecodeInfoCell.h"
#import "FEDefineModule.h"

@implementation FERechargeRecodeInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(0xF6F7F9);
        
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
- (void) setModel:(FERechargeRecodeModel*) model flag:(NSInteger)negative{
    _model = model;
    self.payInfoLB.text = [FEPublicMethods SafeString:model.title];
    self.timeLB.text = [FEPublicMethods SafeString:model.createTimeStr];
    self.jineLB.text = [NSString stringWithFormat:@"%0.2f",model.amount*negative];
}


@end


