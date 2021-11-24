//
//  FEOrderDetailVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/24.
//

#import "FEOrderDetailVC.h"
#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"
#import "FEOrderDetailHeaderCell.h"
#import "FEOrderDetailLogisticsCell.h"
#import "FEOrderDetailAddressCell.h"
#import "FEOrderDetailInfoCell.h"


typedef enum : NSUInteger {
    FEOrderDetailCellHeader = 0,
    FEOrderDetailCellLogistics,
    FEOrderDetailCellAddress,
    FEOrderDetailCellInfo,
    
    
} FEOrderDetailCellType;



@interface FEOrderDetailCellModel:NSObject
@property (nonatomic,assign) FEOrderDetailCellType type;
@property (nonatomic,assign) CGFloat cellHeight;


@end
@implementation FEOrderDetailCellModel

@end


@interface FEOrderDetailVC ()
@property (nonatomic,weak) IBOutlet UITableView* table;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint* backBtnTop;

@property (nonatomic, strong) FEOrderDetailModel* model;
@property (nonatomic, copy) NSMutableArray<FEOrderDetailCellModel*>* cellModel;


@end

@implementation FEOrderDetailVC

+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
    
        [FFRouter registerObjectRouteURL:@"order://createOrderDetail" handler:^id(NSDictionary *routerParameters) {
            FEOrderDetailVC* vc = [[FEOrderDetailVC alloc] initWithNibName:@"FEOrderDetailVC" bundle:nil];
            vc.orderId = routerParameters[@"orderId"];
            vc.actionComplate = routerParameters[@"actionComplate"];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.backBtnTop.constant = kHomeInformationBarHeigt + 6;
    
    self.table.tableFooterView = [UIView new];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.separatorColor = [UIColor clearColor];
    
    self.table.estimatedRowHeight = 0;
    self.table.estimatedSectionHeaderHeight = 0;
    self.table.estimatedSectionFooterHeight = 0;
    if (@available(iOS 11.0, *)) {
        self.table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailHeaderCell" bundle:nil]
       forCellReuseIdentifier:@"FEOrderDetailHeaderCell"];
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailLogisticsCell" bundle:nil]
       forCellReuseIdentifier:@"FEOrderDetailLogisticsCell"];
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailAddressCell" bundle:nil]
       forCellReuseIdentifier:@"FEOrderDetailAddressCell"];
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailInfoCell" bundle:nil]
       forCellReuseIdentifier:@"FEOrderDetailInfoCell"];
    
    
    @weakself(self);
    self.emptyAction = ^{
        @strongself(weakSelf);
        [strongSelf requestShowData];
    };
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestShowData];
}
- (void) viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.emptyFrame = self.table.frame;
}

- (IBAction) backBtnAction:(id) sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) requestShowData {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.orderId;
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/orders/getDetail" parameters:param success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        strongSelf.model = [FEOrderDetailModel yy_modelWithDictionary:response[@"data"]];
        
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        
    }];
}
- (void) calculataionModel{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.cellModel = [NSMutableArray array];
        if(self.model) {
            FEOrderDetailCellModel* item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellHeader;
            item.cellHeight = [FEOrderDetailHeaderCell calculationCellHeight:self.model];
            [self.cellModel addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellLogistics;
            item.cellHeight = [FEOrderDetailLogisticsCell calculationCellHeight:self.model];
            [self.cellModel addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellAddress;
            item.cellHeight = [FEOrderDetailAddressCell calculationCellHeight:self.model];
            [self.cellModel addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellInfo;
            item.cellHeight = [FEOrderDetailInfoCell calculationCellHeight:self.model];
            [self.cellModel addObject:item];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if(!self.model) {
                [self showEmptyViewWithType:YES];
            }
            
            [self.table reloadData];
        });
    });
    
}
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEOrderDetailCellModel* item = self.cellModel[indexPath.row];
    if (item) {
        switch (item.type) {
            case FEOrderDetailCellHeader:{
                FEOrderDetailHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailHeaderCell"];
                [cell setModel:self.model];
            }break;
            case FEOrderDetailCellLogistics:{
                FEOrderDetailLogisticsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailLogisticsCell"];
                [cell setModel:self.model];
            }break;
            case FEOrderDetailCellAddress:{
                FEOrderDetailAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailAddressCell"];
                [cell setModel:self.model];
            }break;
            case FEOrderDetailCellInfo:{
                FEOrderDetailInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailInfoCell"];
                [cell setModel:self.model];
            }break;
            default:
                break;
        }
    }
    return nil;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEOrderDetailCellModel* item = self.cellModel[indexPath.row];
    if (item) {
        return item.cellHeight;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FEOrderDetailCellModel* item = self.cellModel[indexPath.row];
    if (item) {
     
    }
}

@end
