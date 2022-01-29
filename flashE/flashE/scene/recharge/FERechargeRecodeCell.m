//
//  FERechargeRecodeCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/22.
//

#import "FERechargeRecodeCell.h"


#import "FEDefineModule.h"






@interface FERechargeRecodeCell ()

@property (weak, nonatomic) IBOutlet UIButton *commondTwoBtn;
@property (weak, nonatomic) IBOutlet UIButton *commondThreeBtn;


@end
@implementation FERechargeRecodeCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self updataSubView];
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        [self updataSubView];
    }
    return self;
}
- (void) updataSubView{
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UIColor* colorS = UIColorFromRGBA(0x12B398, 0.1);
    UIColor* colorN = UIColorFromRGB(0xF7F8F9);
    [self.commondTwoBtn setBackgroundColor:colorS forState:UIControlStateSelected];
    [self.commondTwoBtn setBackgroundColor:colorN forState:UIControlStateNormal];
    
    [self.commondThreeBtn setBackgroundColor:colorS forState:UIControlStateSelected];
    [self.commondThreeBtn setBackgroundColor:colorN forState:UIControlStateNormal];
    self.commondTwoBtn.selected = YES;
    [self freshCommondColor];
}
- (void) freshCommondColor {
    UIColor* colorS = UIColorFromRGBA(0x12B398, 0.1);
    UIColor* colorN = UIColorFromRGB(0xF7F8F9);
    if (self.commondTwoBtn.selected) {
        [self.commondTwoBtn setBackgroundColor:colorN forState:UIControlStateHighlighted];
        [self.commondThreeBtn setBackgroundColor:colorS forState:UIControlStateHighlighted];
    } else if(self.commondThreeBtn.selected) {
        [self.commondTwoBtn setBackgroundColor:colorS forState:UIControlStateHighlighted];
        [self.commondThreeBtn setBackgroundColor:colorN forState:UIControlStateHighlighted];
    }
}

- (IBAction)commondAction:(UIButton *)sender {
    
    self.commondTwoBtn.selected = NO;
    self.commondThreeBtn.selected = NO;
    sender.selected = YES;
    [self freshCommondColor];
    NSNumber* type;
    if (self.commondTwoBtn.selected) {
        type = @(10);
    }else if (self.commondThreeBtn.selected){
        type = @(20);
    }
    !self.commondAction?:self.commondAction(type);
}


@end
