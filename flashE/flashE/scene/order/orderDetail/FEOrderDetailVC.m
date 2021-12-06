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
#import "FEOrderDetailLinkCell.h"

typedef enum : NSUInteger {
    FEOrderDetailCellHeader = 0,
    FEOrderDetailCellLogistics,
    FEOrderDetailCellAddress,
    FEOrderDetailCellInfo,
    FEOrderDetailCellLink,//联系商家客服
    
    
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
    [self.table registerNib:[UINib nibWithNibName:@"FEOrderDetailLinkCell" bundle:nil]
       forCellReuseIdentifier:@"FEOrderDetailLinkCell"];
    
    
    
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
//- (void) defalutModel{
//    NSString* str = @"{\"status\": 200,\
//    \"msg\": null,\
//    \"data\": {\
//        \"orderId\": 299270617637594130,\
//        \"storeId\": \"1477\",\
//        \"storeName\": \"小鹿奶茶1\",\
//        \"fromAddress\": \"海淀区中关村软件园\",\
//        \"fromAddressDetail\": \"1号楼\",\
//        \"status\": 10,\
//        \"toAdress\": \"西二旗地铁\",\
//        \"toAdressDetail\": null,\
//        \"toUserName\": null,\
//        \"toUserMobile\": null,\
//        \"createTime\": 1628477918000,\
//        \"systemTime\": 1628391518000,\
//        \"courierName\": null,\
//        \"courierMobile\": \"18601227599\",\
//        \"appointType\": 0,\
//        \"appointDate\": 0,\
//        \"grebTime\": null,\
//        \"pickupTime\": 1628391640000,\
//        \"cancelTime\": 0,\
//        \"finishTime\": 1628391760000,\
//        \"goodName\": \"食品\",\
//        \"weight\": 1,\
//        \"fromLongitude\": \"116.411168\",\
//        \"fromLatitude\": \"40.051158\",\
//        \"toLongitude\": \"116.521268\",\
//        \"toLatitude\": \"40.051258\",\
//        \"scheduleTitle\": \"\",\
//        \"scheduleInfo\": \"\",\
//      \"tipAmount\":2.00,\
//      \"backAmount\":1.00,\
//        \"logistics\": [\
//            {\
//                \"logistic\": \"达达\",\
//                \"distance\": 211232,\
//                \"coupon\": 0,\
//                \"amount\": 1200,\
//                \"status\": 50,\
//                \"phone\": \"400-991-9512\"\
//            }\
//        ],\
//        \"routes\": [\
//            {\
//                \"name\": \"下单时间\",\
//                \"time\": \"04:19\"\
//            },\
//            {\
//                \"name\": \"接单时间\",\
//                \"time\": \"04:19\"\
//            },\
//            {\
//                \"name\": \"取件时间\",\
//                \"time\": \"04:19\"\
//            },\
//            {\
//                \"name\": \"完单时间\",\
//                \"time\": \"04:19\"\
//            }\
//        ]}}";
//    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//    self.model = [FEOrderDetailModel yy_modelWithDictionary:dic[@"data"]];
//    [self calculataionModel];
//
//}
- (void) requestShowData {

    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.orderId;
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/orders/getDetail" parameters:param success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        strongSelf.model = [FEOrderDetailModel yy_modelWithDictionary:response[@"data"]];
        if (strongSelf.model.status == 20 || strongSelf.model.status == 30 || strongSelf.model.status == 40 ){
//            10代接单；20已接单；30已到店；40配送中；50已完成；60已取消；70配送失败
            [strongSelf requestCourierLocation];
        } else {
            [strongSelf calculataionModel];
            [strongSelf.table reloadData];
        }
        
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{

    }];
}

- (void) requestCourierLocation {
    
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.orderId;
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/orders/getCourierLocation" parameters:param success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        NSDictionary* data = response[@"data"];
        if (data) {
            strongSelf.model.orderId = ((NSNumber*)data[@"orderId"]).longLongValue;
            strongSelf.model.status = ((NSNumber*)data[@"orderStatus"]).integerValue;
            strongSelf.model.statusName = [FEPublicMethods SafeString:data[@"statusName"]];
            strongSelf.model.courierName = [FEPublicMethods SafeString:data[@"statusName"]];
            strongSelf.model.courierMobile = [FEPublicMethods SafeString:data[@"courierMobile"]];
            strongSelf.model.courierLatitude = [FEPublicMethods SafeString:data[@"latitude"]];
            strongSelf.model.courierLongitude = [FEPublicMethods SafeString:data[@"longitude"]];
            strongSelf.model.systemTime = ((NSNumber*)data[@"uploadTime"]).longLongValue;
        }
    
        [strongSelf.model makeUpdaSubKey];
        [strongSelf calculataionModel];
        
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{

    }];
    
}

- (void) calculataionModel{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray*arr = [NSMutableArray array];
        if(self.model) {
            FEOrderDetailCellModel* item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellHeader;
            item.cellHeight = [FEOrderDetailHeaderCell calculationCellHeight:self.model];
            [arr addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellLogistics;
            item.cellHeight = [FEOrderDetailLogisticsCell calculationCellHeight:self.model];
            [arr addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellAddress;
            item.cellHeight = [FEOrderDetailAddressCell calculationCellHeight:self.model];
            [arr addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellInfo;
            item.cellHeight = [FEOrderDetailInfoCell calculationCellHeight:self.model];
            [arr addObject:item];
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellLink;
            item.cellHeight = self.model.logistic.length>0?80:0;
            [arr addObject:item];
        }
        self.cellModel = arr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if(!self.model) {
                [self showEmptyViewWithType:YES];
            }
            
            [self.table reloadData];
        });
    });
    
}

- (void) addCheckAction:(FEOrderDetailModel*)model view:(UIView*)view{
    UIAlertController* actionView = [UIAlertController alertControllerWithTitle:@"选择小费额度"
                                        message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    [actionView addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction *_Nonnull action) {}]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"2元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:2];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"5元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:5];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"10元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:10];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"15元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:15];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"25元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:25];
    }]];
    [actionView addAction:[UIAlertAction actionWithTitle:@"50元"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
        [self requestAddCheck:model check:50];
    }]];
    if (actionView.popoverPresentationController) {

        UIPopoverPresentationController *popover = actionView.popoverPresentationController;
        popover.sourceView = view;
        popover.sourceRect = CGRectMake(0,CGRectGetHeight(view.frame)/2,0,0);
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [self presentViewController:actionView animated:YES completion:nil];
}
- (void) requestAddCheck:(FEOrderDetailModel*) model check:(NSInteger) check {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = @(model.orderId);
    param[@"amount"] = @(check);
    @weakself(self);
    [[FEHttpManager defaultClient] POST:@"/deer/orders/createTipsOrder" parameters:param
                                success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        [MBProgressHUD showMessage:response[@"msg"]];
        [strongSelf requestShowData];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        
    }];
}

- (void)cellCommond:(FEOrderDetailModel*) model type:(FEOrderCommondType)type view:(UIView*)view{
    @weakself(self);
    switch (type) {
        case FEOrderCommondAddCheck:{
            [self addCheckAction:model view:view];
        }break;
        case FEOrderCommondRetry:{
            
        }break;
        case FEOrderCommondCallRider:{
            NSString* phone = [NSString stringWithFormat:@"tel://%@",model.courierMobile];
            [FEPublicMethods openUrlInSafari:phone];
        }break;
        case FEOrderCommondCancel:{
            NSMutableDictionary* param = [NSMutableDictionary dictionary];
            param[@"orderId"] = @(model.orderId);
            param[@"reason"] = @"不要配送";
            
            [[FEHttpManager defaultClient] POST:@"/deer/orders/cancleOrder" parameters:param
                                        success:^(NSInteger code, id  _Nonnull response) {
                @strongself(weakSelf);
                NSDictionary* dic = response[@"data"];
                
                NSString* title = [FEPublicMethods SafeString:dic[@"title"] withDefault:@"取消结果"];
                NSString* msg = [FEPublicMethods SafeString:dic[@"cancelTips"] withDefault:@"取消成功"];
                FEAlertView* alter = [[FEAlertView alloc] initWithTitle:title message:msg];
                [alter addAction:[FEAlertAction actionWithTitle:@"知道了"
                              style:FEAlertActionStyleDefault handler:^(FEAlertAction *action) {
                    [strongSelf requestShowData];
                }]];
                [alter show];
            } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
                [MBProgressHUD showMessage:error.localizedDescription];
            } cancle:^{
            }];
        }
        default:
            break;
    }
};



#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* tmpCell = nil;
    FEOrderDetailCellModel* item = self.cellModel[indexPath.row];
    if (item) {
        switch (item.type) {
            case FEOrderDetailCellHeader:{
                FEOrderDetailHeaderCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailHeaderCell"];
                [cell setModel:self.model];
                @weakself(self);
                cell.refreshActoin = ^{
                    @strongself(weakSelf);
                    [strongSelf requestCourierLocation];
                };
                cell.cellCommondActoin = ^(FEOrderCommondType type) {
                    @strongself(weakSelf);
                    [strongSelf cellCommond:self.model type:type view:cell];
                };
                tmpCell = cell;
            }break;
            case FEOrderDetailCellLogistics:{
                FEOrderDetailLogisticsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailLogisticsCell"];
                [cell setModel:self.model];
                tmpCell = cell;
            }break;
            case FEOrderDetailCellAddress:{
                FEOrderDetailAddressCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailAddressCell"];
                [cell setModel:self.model];
                tmpCell = cell;
            }break;
            case FEOrderDetailCellInfo:{
                FEOrderDetailInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailInfoCell"];
                [cell setModel:self.model];
                tmpCell = cell;
            }break;
            case FEOrderDetailCellLink: {
                FEOrderDetailLinkCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FEOrderDetailLinkCell"];
                [cell setModel:self.model];
                tmpCell = cell;
            }break;
            default:{
                tmpCell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"];
                if (!tmpCell) {
                    tmpCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultCell"];
                }
            }break;
        }
    }
    return tmpCell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.cellModel.count;
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
