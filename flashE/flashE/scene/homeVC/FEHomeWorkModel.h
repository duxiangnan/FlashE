//
//Created by ESJsonFormatForMac on 21/11/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FEOrderCommond.h"

@class FEHomeWorkCountModel,FEHomeWorkOrderModel,FEOrderCommond;

@interface FEHomeWorkModel : NSObject

@property (nonatomic, strong) NSArray<FEHomeWorkOrderModel*> *orders;

@property (nonatomic, strong) FEHomeWorkCountModel *count;

@end

@interface FEHomeWorkCountModel : NSObject

@property (nonatomic, assign) NSInteger waitGrep;

@property (nonatomic, assign) NSInteger waitPickup;

@property (nonatomic, assign) NSInteger delivery;

@property (nonatomic, assign) NSInteger cancel;

@property (nonatomic, assign) NSInteger finish;

@end

@interface FEHomeWorkOrderModel : NSObject

@property (nonatomic, copy) NSString *orderId;


@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger status;// 10:待接单  20:待取单 40:配送中 60:已取消 50:已完成
@property (nonatomic, copy) NSString *statusName;

@property (nonatomic, copy) NSString *toAdress;
@property (nonatomic, copy) NSString *toAdressDetail;
@property (nonatomic, copy) NSString *toUserName;
@property (nonatomic, copy) NSString *toUserMobile;

@property (nonatomic, copy) NSString *fromAddress;
@property (nonatomic, copy) NSString *fromAddressDetail;

@property (nonatomic, copy) NSString *goodName;



@property (nonatomic, copy) NSString *storeId;
@property (nonatomic, copy) NSString *storeName;




@property (nonatomic, copy) NSString *logistics;


@property (nonatomic, copy) NSString *courierName;
@property (nonatomic, copy) NSString *courierMobile;

@property (nonatomic, assign) NSInteger appointType;
@property (nonatomic, assign) NSInteger appointDate;

@property (nonatomic, assign) long long grebTime;
@property (nonatomic, assign) long long cancelTime;
@property (nonatomic, assign) long long pickupTime;
@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString *  createTimeStr;

@property (nonatomic, assign) long long finishTime;
@property (nonatomic, copy) NSString *  finishTimeStr;

@property (nonatomic, assign) long long systemTime;
@property (nonatomic, copy) NSString * showStuseTimeStr;




@property (nonatomic, assign) CGFloat workCellH;
@property (nonatomic, assign) CGFloat orderTimeMaxX;
@property (nonatomic, copy) NSArray<FEOrderCommond*>* commonds;
@end



