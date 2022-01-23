//
//  FECreateOrderStoreCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FECreateOrderStoreCell.h"
#import "FEMyStoreModel.h"
#import "FEDefineModule.h"
@interface FECreateOrderStoreCell()
@property (weak, nonatomic) IBOutlet UILabel *addressLB;
@property (weak, nonatomic) IBOutlet UILabel *addressDescLB;
@property (weak, nonatomic) IBOutlet UILabel *addressPhoneLB;

@property (weak, nonatomic) IBOutlet UIButton *categoryBtn;
@property (weak, nonatomic) IBOutlet UIButton *isDefaultBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *categoryBtnW;

@end


@implementation FECreateOrderStoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) setModel:(FEMyStoreModel*) model{
 
    self.addressLB.text = model.name;
    self.addressDescLB.text = [NSString stringWithFormat:@"%@ %@",model.address,model.addressDetail];
    self.addressPhoneLB.text = model.mobile;
    
    [self.categoryBtn setTitle:model.categoryName forState:UIControlStateNormal];
    CGSize size = [model.categoryName sizeWithFont:self.categoryBtn.titleLabel.font andMaxSize:CGSizeMake(CGFLOAT_MAX, 15)];
    self.categoryBtnW.constant = MAX(45, ceil(size.width+15));
    self.isDefaultBtn.hidden = model.defaultStore == 0;
    
}

@end
