//
//  FEOrderDetailRouterView.m
//  flashE
//
//  Created by duxiangnan on 2022/3/9.
//

#import "FEOrderDetailRouterView.h"
#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"

typedef enum : NSUInteger {
    FEOrderDetailRouterIndexStart = 0,
    FEOrderDetailRouterIndexCenter,
    FEOrderDetailRouterIndexEnd,
    FEOrderDetailRouterIndexStartEnd,
    
} FEOrderDetailRouterViewCellIndex;

@interface FEOrderDetailRouterViewCell:UITableViewCell

@property (nonatomic,assign) FEOrderDetailRouterViewCellIndex type;
@property (nonatomic,strong) FEOrderDtailRouteModel* model;
@property (nonatomic, strong) UILabel* name;
@property (nonatomic, strong) UILabel* desc;
@property (nonatomic, strong) UIImageView* flagImage;
@property (nonatomic, strong) UIView* topLine;
@property (nonatomic, strong) UIView* bottomLine;


@end

@implementation FEOrderDetailRouterViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.desc];
        [self.contentView addSubview:self.topLine];
        [self.contentView addSubview:self.bottomLine];
        [self.contentView addSubview:self.flagImage];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.flagImage.mas_top);
        make.width.mas_equalTo(1);
        make.centerX.equalTo(self.flagImage.mas_centerX);
    }];
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.top.equalTo(self.flagImage.mas_top);
        make.width.mas_equalTo(1);
        make.centerX.equalTo(self.flagImage.mas_centerX);
    }];
    [self.flagImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(11);
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(6);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.flagImage.mas_right).offset(19);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    
}
- (void)setModel:(FEOrderDtailRouteModel *)model {
    _model = model;
    
    self.name.text = [FEPublicMethods SafeString:model.name];
    self.desc.text = [FEPublicMethods SafeString:model.time];
    
    switch (self.type) {
        case FEOrderDetailRouterIndexStart:{
            self.topLine.hidden = YES;
            self.bottomLine.hidden = NO;
            self.flagImage.image = [UIImage imageNamed:@"fe_order_detail_router_end"];
        }break;
        case FEOrderDetailRouterIndexEnd:{
            self.topLine.hidden = NO;
            self.bottomLine.hidden = YES;
            self.flagImage.image = [UIImage imageNamed:@"fe_order_detail_router_disable"];
        }break;
        case FEOrderDetailRouterIndexCenter:{
            self.topLine.hidden = NO;
            self.bottomLine.hidden = NO;
            self.flagImage.image = [UIImage imageNamed:@"fe_order_detail_router_disable"];
        }break;
        case FEOrderDetailRouterIndexStartEnd:
        default:{
            self.topLine.hidden = YES;
            self.bottomLine.hidden = YES;
            self.flagImage.image = [UIImage imageNamed:@"fe_order_detail_router_end"];
            
            
        }break;
    }
}

-(UILabel*) name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont regularFont:15];
        _name.textColor = UIColorFromRGB(0x333333);
    }
    return _name;
}
-(UILabel*) desc {
    if (!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.font = [UIFont regularFont:14];
        _desc.textColor = UIColorFromRGB(0x777777);
        _desc.textAlignment = NSTextAlignmentRight;
    }
    return _desc;
}
-(UIImageView*) flagImage {
    if (!_flagImage) {
        _flagImage = [[UIImageView alloc] init];
    }
    return _flagImage;
}
-(UIView*) topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = UIColorFromRGB(0xD8D9DE);
    }
    return _topLine;
}
-(UIView*) bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = UIColorFromRGB(0xD8D9DE);
    }
    return _bottomLine;
}

@end



@interface FEOrderDetailRouterView ()


@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableB;

@end

@implementation FEOrderDetailRouterView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.table registerClass:[FEOrderDetailRouterViewCell class] forCellReuseIdentifier:@"FEOrderDetailRouterViewCell"];
    
    self.table.tableFooterView = [UIView new];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.separatorColor = [UIColor clearColor];
    
    self.table.estimatedRowHeight = 0;
    self.table.estimatedSectionHeaderHeight = 0;
    self.table.estimatedSectionFooterHeight = 0;
    self.tableB.constant = kHomeIndicatorHeight;
}
    

- (void)setModel:(NSArray<FEOrderDtailRouteModel*> *)model {
    _model = model;
    
    
    [self.table reloadData];
    
}

-(IBAction)closeAction:(id)sender {
    
    !_closeAction?:_closeAction();
}



#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
        
    FEOrderDetailRouterViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailRouterViewCell"];
    
    
    FEOrderDetailRouterViewCellIndex type = FEOrderDetailRouterIndexStartEnd;
    
    if (self.model.count == 2) {
        type = (row == 0?
                FEOrderDetailRouterIndexStart:
                FEOrderDetailRouterIndexEnd);
    } else if (self.model.count > 2){
        if (row == 0) {
            type = FEOrderDetailRouterIndexStart;
        } else if (row == self.model.count - 1) {
            type = FEOrderDetailRouterIndexEnd;
        } else {
            type = FEOrderDetailRouterIndexCenter;
        }
    }
    cell.type = type;
    [cell setModel:self.model[indexPath.row]];
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

@end
