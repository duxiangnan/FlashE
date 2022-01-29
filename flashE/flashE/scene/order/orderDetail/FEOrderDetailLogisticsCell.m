//
//  FEOrderDetailLogisticsCell.m
//  flashE
//
//  Created by duxiangnan on 2021/11/25.
//

#import "FEOrderDetailLogisticsCell.h"

#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"
@interface FEOrderDetailLogisticsItemCell : UITableViewCell
@property (nonatomic, strong) FEOrderDtailLogisticModel* model;

@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *priceLB;
@property (weak, nonatomic) IBOutlet UILabel *tipLB;

@property (weak, nonatomic) IBOutlet UILabel *StatusLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *StatusLBW;


- (void) setModel:(FEOrderDtailLogisticModel*)model;
@end

@implementation FEOrderDetailLogisticsItemCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) setModel:(FEOrderDtailLogisticModel*)model {
    _model = model;
    NSString* image = [[FEAccountManager sharedFEAccountManager] getPlatFormInfo:model.logistic type:FEPlatforeKeyFlage];
    self.statusImage.image = [UIImage imageNamed:image];
    self.nameLB.text = [FEPublicMethods SafeString:model.logisticName];
    self.lineView.hidden = NO;
    self.priceLB.text = [NSString stringWithFormat:@"%.2f元",model.amount];
    self.tipLB.text = @"";
    self.StatusLB.text = [FEPublicMethods SafeString:model.orderStatusName];
    CGSize size = [self.StatusLB.text sizeWithFont:self.StatusLB.font andMaxSize:CGSizeMake(CGFLOAT_MAX, 20)];
    self.StatusLBW.constant = ceil(size.width);
}

@end


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
@property (weak, nonatomic) IBOutlet UILabel *bottomTipLB;

@end

@implementation FEOrderDetailLogisticsCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = UIColorFromRGB(0xF6F7F9);//UIColor.clearColor;//
//    self.backgroundColor = UIColor.clearColor;
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailLogisticsItemCell" bundle:nil] forCellReuseIdentifier:@"FEOrderDetailLogisticsItemCell"];
    
//    self.table.selection = UITableViewCellSelectionStyleNone;
    self.table.tableFooterView = [UIView new];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.separatorColor = [UIColor clearColor];
    
    self.table.scrollEnabled = NO;
    self.table.estimatedRowHeight = 0;
    self.table.estimatedSectionHeaderHeight = 0;
    self.table.estimatedSectionFooterHeight = 0;
}


+(CGFloat) calculationCellHeight:(FEOrderDetailModel*)model {
    
    if (model.orderDetailLogisticCellH > 0) {
        return model.orderDetailLogisticCellH;
    }
    
    if (model.status == 10) {
        model.orderDetailLogisticHeaderH = 0;
    } else {
        model.orderDetailLogisticHeaderH = 50;
    }
    model.orderDetailLogisticTableH = model.logistics.count * 30;
    
    model.orderDetailLogisticBottomH = model.backAmount > 0?34:0;
    model.orderDetailLogisticCellH = 10+22+model.orderDetailLogisticHeaderH+model.orderDetailLogisticTableH+model.orderDetailLogisticBottomH+20;
    
    return model.orderDetailLogisticCellH;
}
- (void) setModel:(FEOrderDetailModel*)model {
    _model = model;
    
    self.headerView.hidden = model.orderDetailLogisticHeaderH==0;
    self.headerViewH.constant = model.orderDetailLogisticHeaderH;
    self.orderInfoLb.text = [NSString stringWithFormat:@"本单由“%@”为您配送",model.logisticName];
    self.orderNumLB.text = [NSString stringWithFormat:@"单号：%lld",model.orderId];
    self.totalAmountLB.text = @"";//@"未知字段";
    self.table.hidden = model.orderDetailLogisticTableH == 0;

    self.bottomView.hidden = model.orderDetailLogisticBottomH==0;
    self.bottomViewH.constant = model.orderDetailLogisticBottomH;
    self.bottomTipLB.text = [NSString stringWithFormat:@"超出费用%0.2f元已退至您的账户余额",model.backAmount];
    
    [self.table reloadData];
}
- (IBAction)copyAcion:(id)sender {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%lld",self.model.orderId];
    [MBProgressHUD showMessage:@"复制成功"];
}


#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FEOrderDetailLogisticsItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailLogisticsItemCell"];
    
    [cell setModel:self.model.logistics[indexPath.row]];
                
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.model.logistics.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
