//
//  FEStoreSelectedView.m
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FEStoreSelectedView.h"
#import "FEDefineModule.h"
#import "FEHttpPageManager.h"
#import "FEMyStoreModel.h"
#import "FECreateOrderStoreCell.h"

@interface FEStoreSelectedView ()

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableB;
@property (nonatomic, copy) NSArray<FEMyStoreModel*>* list;
@end

@implementation FEStoreSelectedView
- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.tableB.constant = kHomeIndicatorHeight;
    self.table.tableFooterView = [UIView new];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.separatorColor = [UIColor clearColor];
    
    self.table.estimatedRowHeight = 0;
    self.table.estimatedSectionHeaderHeight = 0;
    self.table.estimatedSectionFooterHeight = 0;
    [self.table registerNib:[UINib nibWithNibName:@"FECreateOrderStoreCell" bundle:nil] forCellReuseIdentifier:@"FECreateOrderStoreCell"];
    
}

- (IBAction) closeAction:(id)sender {
    !self.cancleAction?:self.cancleAction();
    
}
- (IBAction) storeManageAction:(id)sender {
    !self.storeManageAction?:self.storeManageAction();
    
}

- (void) freshSubData {
    FEAccountModel* acc = [[FEAccountManager sharedFEAccountManager] getLoginInfo];
    if (acc.storeList.count>0) {
        self.list = acc.storeList;
        [self.table reloadData];
        return;
    }
    @weakself(self);
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"shopId"] = @(acc.shopId);
    [[FEHttpManager defaultClient] GET:@"/deer/store/queryStoresByShopId" parameters:param
      success:^(NSInteger code, id  _Nonnull response)
    {
        @strongself(weakSelf);
        
        strongSelf.list = [NSArray yy_modelArrayWithClass:[FEMyStoreModel class] json:((NSDictionary*)response)[@"data"]];
        [strongSelf.table reloadData];
        
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
    
    FECreateOrderStoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FECreateOrderStoreCell"];
    [cell setModel:self.list[indexPath.row]];
    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    !self.selectedAction?:self.selectedAction(self.list[indexPath.row]);
    
}

@end
