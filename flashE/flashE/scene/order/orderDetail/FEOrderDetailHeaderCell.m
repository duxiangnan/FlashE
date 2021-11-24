//
//  FEOrderDetailHeaderCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/25.
//

#import "FEOrderDetailHeaderCell.h"
#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"
#import "FEMapAnnotationView.h"


@interface FEOrderDetailHeaderCell ()
@property (nonatomic, strong)FEOrderDetailModel* model;

@property (nonatomic, weak) IBOutlet MAMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *freshBtn;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLB;
@property (weak, nonatomic) IBOutlet UILabel *StatusDesLB;

@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusViewH;



@end


@implementation FEOrderDetailHeaderCell

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
- (IBAction)freshAction:(id)sender {
    
}



@end
