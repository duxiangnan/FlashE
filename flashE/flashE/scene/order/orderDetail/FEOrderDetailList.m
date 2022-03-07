//
//  FEOrderDetailList.m
//  shansong
//
//  Created by wangjian on 2020/2/26.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import "FEOrderDetailList.h"
#import "FEDefineModule.h"
//#import "SSMainAdvertizementCell.h"
//#import "SSMainAdvertizementFooterView.h"
//#import "SSMainAdvertizementEmptyView.h"
//#import "SSDistributeManager.h"
//#import "SSAdvertViewModel.h"



#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"
#import "FEOrderMapView.h"
#import "FEOrderDetailHeaderCell.h"
#import "FEOrderDetailLogisticsCell.h"
#import "FEOrderDetailAddressCell.h"
#import "FEOrderDetailInfoCell.h"
#import "FEOrderDetailLinkCell.h"

#import <zhPopupController/zhPopupController.h>
#import "FETipModel.h"
#import "FETipSettingView.h"


@interface FEOrderDetailCellModel:NSObject
@property (nonatomic,assign) FEOrderDetailCellType type;
@property (nonatomic,assign) CGFloat cellHeight;


@end

@implementation FEOrderDetailCellModel

@end




@interface FEOrderDetailList()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>


@property (nonatomic, copy) NSMutableArray<FEOrderDetailCellModel*>* cellModel;



@end


@implementation FEOrderDetailList

//
//-(RACSubject *)getDataSubject {
//    if (!_getDataSubject) {
//        _getDataSubject = [RACSubject new];
//    }
//    return _getDataSubject;
//}
//
//-(NSMutableArray *)lastAdInfoItemIds {
//    if (!_lastAdInfoItemIds) {
//        _lastAdInfoItemIds = [NSMutableArray array];
//    }
//    return _lastAdInfoItemIds;
//}
//
//-(RACSubject *)didLayoutSubViewSubject {
//    if (!_didLayoutSubViewSubject) {
//        _didLayoutSubViewSubject = [RACSubject new];
//    }
//    return _didLayoutSubViewSubject;
//}

#pragma mark - initilize

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
//        self.bounces = NO;
        self.backgroundColor = UIColor.clearColor;
        self.showsVerticalScrollIndicator = NO;
        self.userInteractionEnabled = YES;
        self.clipsToBounds = NO;

//        self.estimatedRowHeight = 120;
                
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        [self registerNib:[UINib nibWithNibName:@"FEOrderDetailHeaderCell" bundle:nil]
           forCellReuseIdentifier:@"FEOrderDetailHeaderCell"];
        [self registerNib:[UINib nibWithNibName:@"FEOrderDetailLogisticsCell" bundle:nil]
           forCellReuseIdentifier:@"FEOrderDetailLogisticsCell"];
        [self registerNib:[UINib nibWithNibName:@"FEOrderDetailAddressCell" bundle:nil]
           forCellReuseIdentifier:@"FEOrderDetailAddressCell"];
        [self registerNib:[UINib nibWithNibName:@"FEOrderDetailInfoCell" bundle:nil]
           forCellReuseIdentifier:@"FEOrderDetailInfoCell"];
        [self registerNib:[UINib nibWithNibName:@"FEOrderDetailLinkCell" bundle:nil]
           forCellReuseIdentifier:@"FEOrderDetailLinkCell"];
        
    }
    return self;
}


- (void)cellCommond:(FEOrderDetailModel*) model type:(FEOrderCommondType)type{
    
    switch (type) {
        case FEOrderCommondAddCheck:{
            !self.tipAcion?:self.tipAcion();
            
        }break;
        case FEOrderCommondRetry:{
            NSString* orderId = [NSString stringWithFormat:@"%lld",model.orderId];
            FEBaseViewController* vc = [FFRouter routeObjectURL:@"order://createOrder"
                                                 withParameters:@{@"orderId":orderId}];
            [self.vc.navigationController pushViewController:vc animated:YES];
        }break;
        case FEOrderCommondCallRider:{
            NSString* phone = [NSString stringWithFormat:@"tel://%@",model.courierMobile];
            [FEPublicMethods openUrlInSafari:phone];
        }break;
        case FEOrderCommondCancel:{
            [self makeSureCancleOrder:model];
            
        }
        default:
            break;
    }
};

- (void) makeSureCancleOrder:(FEOrderDetailModel*) model{
    NSString* msg = nil;
    switch (model.status) {
        case 10://待接单
            msg = @"系统正在为您筛选合适骑手，请您稍等一下～";
            break;
        case 20://待取单
            msg = @"骑手小哥已在来店途中～";
            break;
        case 40://配送中
        case 30:
            msg = @"骑手小哥已在配送途中啦，如您取消，可能会产生扣款哦～";
        default:
            break;
    }
    FEAlertView* alert = [[FEAlertView alloc] initWithTitle:@"取消提示" message:msg];
    alert.firstAndSecondRatio = 0.588;
    [alert addAction:[FEAlertAction actionWithTitle:@"暂不取消"
                                              style:FEAlertActionStyleCancel
                                            handler:nil]];
    [alert addAction:[FEAlertAction actionWithTitle:@"确定取消"
                                              style:FEAlertActionStyleDefault
                                            handler:^(FEAlertAction *action) {
        NSMutableDictionary* param = [NSMutableDictionary dictionary];
        param[@"orderId"] = @(model.orderId);
        param[@"reason"] = @"不要配送";
        @weakself(self);
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
        
    }]];
    [alert show];
    
    
}

#pragma mark --- request


- (void) requestShowData {
    [self.vc hiddenEmptyView];
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = self.orderId;
    @weakself(self);
    [[FEHttpManager defaultClient] GET:@"/deer/orders/getDetail" parameters:param success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        strongSelf.model = [FEOrderDetailModel yy_modelWithDictionary:response[@"data"]];
        [strongSelf setTestModel:strongSelf.model];
        if (strongSelf.model.status == 20 || strongSelf.model.status == 30 || strongSelf.model.status == 40 ){
            strongSelf.panGesture.enabled = YES;
//            10代接单；20已接单；30已到店；40配送中；50已完成；60已取消；70配送失败
            [strongSelf requestCourierLocation];
        } else {
            strongSelf.panGesture.enabled = NO;
            [strongSelf calculataionModel];
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
            if ([data[@"uploadTime"] isKindOfClass:[NSNumber class]]) {
                strongSelf.model.systemTime = ((NSNumber*)data[@"uploadTime"]).longLongValue;
            }
        }
        [strongSelf setTestModel:strongSelf.model];
        [strongSelf.model makeUpdaSubKey];
        [strongSelf calculataionModel];
        
        
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
//        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{

    }];
    [self performSelector:@selector(requestCourierLocation) withObject:nil afterDelay:5];
}




- (void) requestAddCheck:(NSInteger) check {
    NSMutableDictionary* param = [NSMutableDictionary dictionary];
    param[@"orderId"] = @(self.model.orderId);
    param[@"amount"] = @(check);
    @weakself(self);
    [[FEHttpManager defaultClient] POST:@"/deer/orders/createTipsOrder" parameters:param
                                success:^(NSInteger code, id  _Nonnull response) {
        @strongself(weakSelf);
        [MBProgressHUD showMessage:[FEPublicMethods SafeString:response[@"msg"] withDefault:@"操作成功"]];
        [strongSelf requestShowData];
    } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
        [MBProgressHUD showMessage:error.localizedDescription];
    } cancle:^{
        
    }];
}




- (void) calculataionModel{
    dispatch_async(dispatch_get_main_queue(), ^{
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
            
//            for (int i = 0; i< 10; i++) {
//                item = [FEOrderDetailCellModel new];
//                item.type = FEOrderDetailCellInfo;
//                item.cellHeight = [FEOrderDetailInfoCell calculationCellHeight:self.model];
//                [arr addObject:item];
//            }
            
            item = [FEOrderDetailCellModel new];
            item.type = FEOrderDetailCellLink;
            item.cellHeight = self.model.logistic.length>0?80:0;
            [arr addObject:item];
        }
        self.cellModel = arr;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            !self.loadModelAction?:self.loadModelAction();
            [self setModel:self.model];
            [self reloadData];
        });
    });
    
}


#pragma mark - tableview datasource & delegate
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
                 
                 cell.cellCommondActoin = ^(FEOrderCommondType type) {
                     @strongself(weakSelf);
                     [strongSelf cellCommond:self.model type:type];
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

#pragma mark - scrollView delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.mainDelegate respondsToSelector:@selector(mainScrollViewDidScroll:)]) {
        [self.mainDelegate mainScrollViewDidScroll:scrollView];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.mainDelegate respondsToSelector:@selector(mainScrollViewWillBeginDragging:)]) {
        [self.mainDelegate mainScrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if ([self.mainDelegate respondsToSelector:@selector(mainScrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.mainDelegate mainScrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.mainDelegate respondsToSelector:@selector(mainScrollViewDidEndDragging:willDecelerate:)]) {
        [self.mainDelegate mainScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.mainDelegate respondsToSelector:@selector(mainScrollViewDidEndDecelerating:)]) {
        [self.mainDelegate mainScrollViewDidEndDecelerating:scrollView];
    }
}
// 是否允许支持多个手势,默认是不支持:NO
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setTestModel:(FEOrderDetailModel*)model{
//    model.status = 10;
    
}

@end


