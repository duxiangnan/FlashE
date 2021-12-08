//
//Created by ESJsonFormatForMac on 21/12/04.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class FECreateOrderLogisticDetailsModel,FECreateOrderLogisticModel;

@interface FECreateOrderModel : NSObject
@property (nonatomic, assign) long long storeId;//店铺ID
@property (nonatomic, assign) long long cityId;//城市ID
@property (nonatomic, copy) NSString* cityName;//城市名称

@property (nonatomic, copy) NSString* toAddress;//收件地址
@property (nonatomic, copy) NSString* toAddressDetail;//收件地址详情
@property (nonatomic, copy) NSString* toUserName;//收件人
@property (nonatomic, copy) NSString* toMobile;//收件人手机号
@property (nonatomic, assign) double toLng;//收件经度
@property (nonatomic, assign) double toLat;//收件纬度
@property (nonatomic, assign) NSInteger additionFee;//小费

@property (nonatomic, assign) NSInteger appointType;//预约类型0及时单；1预约单
@property (nonatomic, assign) NSInteger appointDate;//预约时间
@property (nonatomic, assign) double fromLng;//下单地址经度
@property (nonatomic, assign) double fromLat;//下单地址纬度
@property (nonatomic, copy) NSString* fromAddress;//发件地址
@property (nonatomic, copy) NSString* fromAddressDetail;//发件地址
@property (nonatomic, copy) NSString* fromName;//下单人
@property (nonatomic, copy) NSString* fromMobile;//下单人手机号


@property (nonatomic, assign) NSInteger category;//物品类型
@property (nonatomic, copy) NSString* categoryName;//物品类型名称
@property (nonatomic, assign) NSInteger weight;//重量
@property (nonatomic, copy) NSString* remark;//备注
@property (nonatomic, strong) FECreateOrderLogisticModel* logistics;//选择下单平台

@end





@interface FECreateOrderLogisticModel : NSObject

@property (nonatomic, assign) NSInteger coupon;

@property (nonatomic, copy) NSString *minLogistic;

@property (nonatomic, assign) CGFloat minPrice;

@property (nonatomic, assign) NSInteger maxPrice;

@property (nonatomic, strong) NSArray<FECreateOrderLogisticDetailsModel*> *details;



@end
@interface FECreateOrderLogisticDetailsModel : NSObject

@property (nonatomic, assign) CGFloat amount;

@property (nonatomic, assign) NSInteger coupon;

@property (nonatomic, assign) CGFloat realAmount;

@property (nonatomic, copy) NSString *logistic;

@property (nonatomic, copy) NSString *logisticName;

@property (nonatomic, assign) float distance;

@property (nonatomic, assign) NSInteger status;//cell选择状态 0：未选择，1:选中，-1:无效
@end

