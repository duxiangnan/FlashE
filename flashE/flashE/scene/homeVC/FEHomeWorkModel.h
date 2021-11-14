//
//Created by ESJsonFormatForMac on 21/11/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class FEHomeWorkCountModel,FEHomeWorkOrderModel,FEHomeWorkCellCommond;

@interface FEHomeWorkModel : NSObject

@property (nonatomic, strong) NSArray<FEHomeWorkOrderModel*> *orders;

@property (nonatomic, strong) FEHomeWorkCountModel *counts;

@end

@interface FEHomeWorkCountModel : NSObject

@property (nonatomic, assign) NSInteger waitGrep;

@property (nonatomic, assign) NSInteger waitPickup;

@property (nonatomic, assign) NSInteger delivery;

@property (nonatomic, assign) NSInteger cancel;

@property (nonatomic, assign) NSInteger finish;

@end

@interface FEHomeWorkOrderModel : NSObject

@property (nonatomic, assign) long long  cancelTime;
@property (nonatomic, copy) NSString *  cancelTimeStr;

@property (nonatomic, copy) NSString *fromAddressDetail;

@property (nonatomic, assign) NSInteger weight;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *statusName;

@property (nonatomic, copy) NSString *toAdress;

@property (nonatomic, copy) NSString *toUserMobile;

@property (nonatomic, copy) NSString *goodName;

@property (nonatomic, assign) long long  grebTime;
@property (nonatomic, copy) NSString *  grebTimeStr;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, copy) NSString *fromAddress;

@property (nonatomic, copy) NSString *courierName;

@property (nonatomic, assign) long long  pickupTime;
@property (nonatomic, copy) NSString *  pickupTimeStr;

@property (nonatomic, copy) NSString *logistics;

@property (nonatomic, copy) NSString *storeId;

@property (nonatomic, copy) NSString *courierMobile;

@property (nonatomic, assign) NSInteger appointType;

@property (nonatomic, copy) NSString *toUserName;

@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *  createTimeStr;

@property (nonatomic, copy) NSString *toAdressDetail;

@property (nonatomic, assign) long long  finishTime;
@property (nonatomic, copy) NSString *  finishTimeStr;

@property (nonatomic, assign) long long  systemTime;
@property (nonatomic, copy) NSString *  systemTimeStr;

@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, assign) NSInteger appointDate;


@property (nonatomic, assign) CGFloat workCellH;
@property (nonatomic, assign) CGFloat orderTimeMaxX;
@property (nonatomic, copy) NSArray<FEHomeWorkCellCommond*>* commonds;
@end


@interface FEHomeWorkCellCommond : NSObject
@property(nonatomic, assign) int commodType;
@property(nonatomic, copy) NSString* commodName;
@property(nonatomic, assign) CGFloat commodWidth;

@end
