//
//Created by ESJsonFormatForMac on 21/11/17.
//

#import <Foundation/Foundation.h>
#import "FEOrderCommond.h"

@class FEOrderDtailLogisticModel,FEOrderDtailRouteModel;
@interface FEOrderDetailModel : NSObject

@property (nonatomic, assign) long long orderId;//订单ID

//状态：10代接单；20已接单；30已到店；40配送中；50已完成；60已取消；70配送失败
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *statusName;//订单状态名称
@property (nonatomic, assign) NSInteger appointType;//0及时单；1预约单
@property (nonatomic, assign) NSInteger appointDate;//预约时间
@property (nonatomic, copy) NSString* appointDateStr;
@property (nonatomic, copy) NSString *scheduleTitle;//订单进度
@property (nonatomic, copy) NSString *scheduleInfo;//进度内容

@property (nonatomic, copy) NSString *goodName;//物品类型
@property (nonatomic, assign) NSInteger weight;//重量

@property (nonatomic, copy) NSString *storeId;//店铺ID
@property (nonatomic, copy) NSString *storeName;//店铺地址

@property (nonatomic, copy) NSString *fromAddress;//发件地址
@property (nonatomic, copy) NSString *fromAddressDetail;//发件地址详情
@property (nonatomic, copy) NSString *fromLatitude;
@property (nonatomic, copy) NSString *fromLongitude;

@property (nonatomic, copy) NSString *toAdress;//收件地址
@property (nonatomic, copy) NSString *toAdressDetail;//收件地址详情
@property (nonatomic, copy) NSString *toLatitude;
@property (nonatomic, copy) NSString *toLongitude;

@property (nonatomic, copy) NSString *toUserName;//收件人
@property (nonatomic, copy) NSString *toUserMobile;//收件人电话

@property (nonatomic, copy) NSString *courierName;//骑手姓名
@property (nonatomic, copy) NSString *courierMobile;//骑手电话
@property (nonatomic, copy) NSString *courierLatitude;//骑手
@property (nonatomic, copy) NSString *courierLongitude;//骑手


@property (nonatomic, assign) long long createTime;//下单时间
@property (nonatomic, copy) NSString *createTimeStr;//下单时间文案

@property (nonatomic, assign) long long grebTime;//接单时间
@property (nonatomic, assign) long long pickupTime;//取件时间
@property (nonatomic, assign) long long cancelTime;//取消时间
@property (nonatomic, assign) long long finishTime;//完成时间
@property (nonatomic, assign) long long systemTime;//系统时间



@property (nonatomic, copy) NSString *logistic;//配送平台
@property (nonatomic, copy) NSString *logisticName;//配送平台名称
@property (nonatomic, assign) double backAmount;//接单后退款金额
@property (nonatomic, assign) double tipAmount;//小费
@property (nonatomic, copy) NSString *remark;//备注

@property (nonatomic, strong) NSArray<FEOrderDtailLogisticModel*> *logistics;
@property (nonatomic, strong) NSArray<FEOrderDtailRouteModel*> *routes;


@property (nonatomic, copy) NSString *showStuseTimeStr;//状态时间
//@property (nonatomic, copy) NSString *orderStatusTipName;//状态提示
//@property (nonatomic, copy) NSString *orderStatusDescName;//状态详细提示
@property (nonatomic, copy) NSArray<FEOrderCommond*>* commonds;//订单cell命令按钮

@property (nonatomic, assign) CGFloat orderDetailHeaderCellH;
@property (nonatomic, assign) CGFloat orderDetailHeaderMapH;
@property (nonatomic, assign) CGFloat orderDetailHeaderBottomH;

@property (nonatomic, assign) CGFloat orderDetailLogisticCellH;
@property (nonatomic, assign) CGFloat orderDetailLogisticTableH;
@property (nonatomic, assign) CGFloat orderDetailLogisticHeaderH;
@property (nonatomic, assign) CGFloat orderDetailLogisticBottomH;

-(void) makeUpdaSubKey;//更新model 展示信息
@end


@interface FEOrderDtailLogisticModel : NSObject

@property (nonatomic, copy) NSString *logistic;//配送平台
@property (nonatomic, copy) NSString *logisticName;//配送平台名称

@property (nonatomic, assign) long long distance;//距离
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger orderStatus;//状态
@property (nonatomic, copy) NSString *orderStatusName;//状态名称
@property (nonatomic, assign) double amount;//配送金额
@property (nonatomic, assign) double coupon;//优惠金额
@property (nonatomic, copy) NSString *phone;//客服电话


@end


@interface FEOrderDtailRouteModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;

@end
