//
//  FEStoreDetailVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/19.
//

#import "FEStoreDetailVC.h"
#import "FEDefineModule.h"
#import "FEStoreDetailModel.h"
#import "FEStoreDetailCellView.h"

@interface FEStoreDetailVC ()
@property (nonatomic,strong) FEStoreDetailModel* model;
@property (nonatomic,weak) IBOutlet UITableView* table;
@end

@implementation FEStoreDetailVC
+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
        
        [FFRouter registerObjectRouteURL:@"store://storeDetail" handler:^id(NSDictionary *routerParameters) {
            FEStoreDetailVC* vc = [[FEStoreDetailVC alloc] initWithNibName:@"FEStoreDetailVC" bundle:nil];
            vc.ID = ((NSNumber*)routerParameters[@"ID"]).integerValue;
            
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"店铺详情";
    self.fd_prefersNavigationBarHidden = NO;
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
    [self.table registerClass:[FEStoreDetailAddressCell class] forCellReuseIdentifier:@"FEStoreDetailAddressCell"];
    [self.table registerClass:[FEStoreDetailZhengjianCell class] forCellReuseIdentifier:@"FEStoreDetailZhengjianCell"];
    [self.table registerClass:[FEStoreDetailDianInfoCell class] forCellReuseIdentifier:@"FEStoreDetailDianInfoCell"];
    [self.table registerClass:[FEStoreDetailCommondCell class] forCellReuseIdentifier:@"FEStoreDetailCommondCell"];
    [self.table registerClass:[FEStoreDetailPingtaiTitleCell class] forCellReuseIdentifier:@"FEStoreDetailPingtaiTitleCell"];
    [self.table registerClass:[FEStoreDetailPingtaiCell class] forCellReuseIdentifier:@"FEStoreDetailPingtaiCell"];
    
    @weakself(self);
    self.emptyAction = ^{
        @strongself(weakSelf);
        [strongSelf requestData];
    };
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.emptyFrame = self.table.frame;
}

- (void) gotoModifyStore{
    
    FEBaseViewController* vc = [FFRouter routeObjectURL:@"store://createStore" withParameters:@{@"model":self.model}];

    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void) requestData {
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/store/queryStoreById"
                             parameters:@{@"id":@(self.ID)}
                                success:^(NSInteger code, id  _Nonnull response) {
        NSDictionary* data = response[@"data"];
        @strongself(weakSelf);
        strongSelf.model = [FEStoreDetailModel yy_modelWithDictionary:data];
        NSMutableArray* arr = [NSMutableArray array];
        FESoreDetailCellModle*item = [FESoreDetailCellModle new];
        item.type = FESoreDetailCellTypeAddress;
        item.cellHeight = 110;
        [arr addObject:item];
        
        item = [FESoreDetailCellModle new];
        item.type = FESoreDetailCellTypeZJ;
        CGFloat width = (kScreenWidth - 16*2 - 10*2 - 10)/2 ;
        CGFloat height = width*106/156;
        item.cellHeight = 0;//60+height;
        [arr addObject:item];
        
        item = [FESoreDetailCellModle new];
        item.type = FESoreDetailCellTypeZH;
        item.cellHeight = 0;//60+height;
        [arr addObject:item];
        
        item = [FESoreDetailCellModle new];
        item.type = FESoreDetailCellTypeCommond;
        item.cellHeight = 70;
        [arr addObject:item];
        
        [strongSelf.model.logistics enumerateObjectsUsingBlock:
         ^(FESoreDetailLogisticModle* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FESoreDetailCellModle*item = [FESoreDetailCellModle new];
            item.type = FESoreDetailCellTypeLocgist;
            item.cellHeight = 0;//60;
            [arr addObject:item];
        }];
        strongSelf.model.cells = arr.copy;
        [strongSelf.table reloadData];
        if (!strongSelf.model) {
            [strongSelf showEmptyViewWithType:YES];
        }
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
        @strongself(weakSelf);
        [strongSelf showEmptyViewWithType:NO];
    } cancle:^{
        
    }];
}

- (void) deleteRequest{
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"id"] = @(self.model.ID);
    @weakself(self);
    [[FEHttpManager defaultClient] POST:@"/deer/store/deleteStoreById" parameters:param
                                success:^(NSInteger code, id  _Nonnull response) {
        [MBProgressHUD showMessage:@"删除成功"];
        @strongself(weakSelf);
        [strongSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        
    }];
}
#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FESoreDetailCellModle* item = self.model.cells[indexPath.row];
    UITableViewCell* tmpCell = nil;
    switch (item.type) {
        case FESoreDetailCellTypeAddress:{
            FEStoreDetailAddressCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEStoreDetailAddressCell"];
            [cell setModel:self.model];
            tmpCell = cell;
        }break;
        case FESoreDetailCellTypeZJ:{
            FEStoreDetailZhengjianCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEStoreDetailZhengjianCell"];
            [cell setModel:self.model];
            tmpCell = cell;
        }break;
        case FESoreDetailCellTypeZH:{
            FEStoreDetailDianInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEStoreDetailDianInfoCell"];
            [cell setModel:self.model];
            tmpCell = cell;
        }break;
        case FESoreDetailCellTypeCommond:{
            FEStoreDetailCommondCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEStoreDetailCommondCell"];
            
            @weakself(self);
            cell.modifyActionBlock = ^{
                @strongself(weakSelf);
                [strongSelf gotoModifyStore];
            };
            cell.deleteActionBlock = ^{
                @strongself(weakSelf);
                [strongSelf deleteRequest];
            };
            tmpCell = cell;
        }break;
        case FESoreDetailCellTypeLogistTitle:{
            FEStoreDetailPingtaiTitleCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEStoreDetailPingtaiTitleCell"];
            tmpCell = cell;
        }break;
        case FESoreDetailCellTypeLocgist:{
            FEStoreDetailPingtaiCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FEStoreDetailPingtaiCell"];
            [cell setModel:self.model.logistics[indexPath.row - 5]];
            @weakself(self);
            cell.modifyAcionBlock = ^(FELogisticsModel * _Nonnull model) {
                @strongself(weakSelf);
            };
            tmpCell = cell;
        }break;
        default:{
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"defaultcell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultcell" ];
            }
            tmpCell = cell;
            
        }break;
    }

    return tmpCell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.cells.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FESoreDetailCellModle* item = self.model.cells[indexPath.row];
    
    return item.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    
}



@end
