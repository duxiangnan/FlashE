//
//Created by ESJsonFormatForMac on 21/11/17.
//

#import <Foundation/Foundation.h>

@class FEOrderDtailLogisticModel;
@interface FEOrderDetailModel : NSObject

@property (nonatomic, assign) long long ID;
@property (nonatomic, copy) NSString *name;//名称
@property (nonatomic, assign) long long shopId;//商户ID
@property (nonatomic, assign) long long cityId;//城市ID
@property (nonatomic, copy) NSString *cityName;//城市名称

@property (nonatomic, copy) NSString *address;//地址
@property (nonatomic, copy) NSString *addressDetail;//地址详情
@property (nonatomic, copy) NSString *latitude;//纬度
@property (nonatomic, copy) NSString *longitude;//经度
@property (nonatomic, copy) NSString *mobile;//联系电话
/**
 FOODS(1, "食品"),
DRINK(2, "饮品"),
FLOWERS(3, "鲜花"),
TICKETS(4, "票务"),
MARKET(5, "超市"),
FRUIT(6, "水果"),
MEDICINE(7, "医药"),
CAKE(8, "蛋糕"),
WINE(9, "酒品"),
CLOTHING(10, "服装"),
CAR(11, "汽配"),
SUPPER(12, "夜宵烧烤"),
OTHERS(99, "其他");
 */
@property (nonatomic, assign) long long category;//品类：
@property (nonatomic, copy) NSString *categoryName;//汽配
@property (nonatomic, copy) NSString *thirdStoreId;//第三方ID
@property (nonatomic, copy) NSString *bdCode;//bdcode
@property (nonatomic, copy) NSString *frontIdcard;//身份证正面
@property (nonatomic, copy) NSString *reverseIdcard;//身份证反面
@property (nonatomic, copy) NSString *businessLicense;//营业执照
@property (nonatomic, copy) NSString *facade;//店铺照
@property (nonatomic, assign) long long status;//状态：状态10待审核；20审核通过；30审核拒绝；
@property (nonatomic, assign) long long defaultStore;//默认店铺:0否；1是
@property (nonatomic, assign) long long auditTime;//审核时间
@property (nonatomic, assign) long long sources;//来源
@property (nonatomic, assign) long long delFlag;//删除标书
@property (nonatomic, assign) long long createTime;//创建时间
@property (nonatomic, assign) long long updateTime;//修复时间
@property (nonatomic, copy) NSArray<FEOrderDtailLogisticModel*>* logistics;

@end


@interface FEOrderDtailLogisticModel : NSObject
@property (nonatomic, copy) NSString *logistic;//平台枚举
@property (nonatomic, copy) NSString *logisticName;//平台名称
@property (nonatomic, assign) NSInteger status;//状态
@property (nonatomic, copy) NSString *statusName;
@end


