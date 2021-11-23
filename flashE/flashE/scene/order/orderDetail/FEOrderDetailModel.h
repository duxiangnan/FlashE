//
//Created by ESJsonFormatForMac on 21/11/17.
//

#import <Foundation/Foundation.h>

@class FEOrderDtailLogisticModel,FEOrderDtailRouteModel;
@interface FEOrderDetailModel : NSObject

@property (nonatomic, assign) long long cancelTime;

@property (nonatomic, copy) NSString *fromAddressDetail;

@property (nonatomic, assign) NSInteger weight;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *toAdress;

@property (nonatomic, copy) NSString *toUserMobile;

@property (nonatomic, copy) NSString *goodName;

@property (nonatomic, assign) long long grebTime;

@property (nonatomic, copy) NSString *fromLatitude;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *fromLongitude;

@property (nonatomic, copy) NSString *toLatitude;

@property (nonatomic, copy) NSString *scheduleTitle;

@property (nonatomic, copy) NSString *fromAddress;

@property (nonatomic, copy) NSString *courierName;

@property (nonatomic, assign) long long pickupTime;

@property (nonatomic, assign) double backAmount;

@property (nonatomic, strong) NSArray *routes;

@property (nonatomic, strong) NSArray<FEOrderDtailLogisticModel*> *logistics;

@property (nonatomic, copy) NSString *scheduleInfo;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *courierMobile;

@property (nonatomic, assign) double tipAmount;

@property (nonatomic, assign) NSInteger appointType;

@property (nonatomic, copy) NSString *toUserName;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, copy) NSString *toAdressDetail;

@property (nonatomic, assign) long long finishTime;

@property (nonatomic, copy) NSString *toLongitude;

@property (nonatomic, assign) long long orderId;

@property (nonatomic, assign) NSInteger appointDate;

@property (nonatomic, assign) long long systemTime;

@property (nonatomic, copy) NSString *statusName;
@property (nonatomic, copy) NSString *remark;


@end
@interface FEOrderDtailLogisticModel : NSObject

@property (nonatomic, assign) double amount;

@property (nonatomic, assign) double coupon;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *phone;

@property (nonatomic, copy) NSString *logistic;
@property (nonatomic, copy) NSString *logisticName;

@property (nonatomic, assign) long long distance;

@property (nonatomic, assign) NSInteger orderStatus;
@property (nonatomic, copy) NSString *orderStatusName;
@end

@interface FEOrderDtailRouteModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *time;

@end

