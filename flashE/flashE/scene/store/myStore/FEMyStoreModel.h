//
//Created by ESJsonFormatForMac on 21/11/20.
//

#import <Foundation/Foundation.h>

@class FELogisticsModel;
@interface FEMyStoreModel : NSObject

@property (nonatomic, assign) NSInteger status;//状态：状态10待审核；20审核通过；30审核拒绝；



@property (nonatomic, copy) NSString *frontIdcard;//身份证正面
@property (nonatomic, copy) NSString *reverseIdcard;//身份证反面
@property (nonatomic, copy) NSString *facade;//店铺照
@property (nonatomic, copy) NSString *businessLicense;//营业执照



@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger defaultStore;//默认店铺:0否；1是
@property (nonatomic, assign) NSInteger shopId;//商户ID
@property (nonatomic, copy) NSString *name;//名称

@property (nonatomic, copy) NSString *bdCode;

@property (nonatomic, copy) NSString *latitude;//纬度
@property (nonatomic, copy) NSString *longitude;//经度
//品类：1, "食品" 2, "饮品" 3, "鲜花" 4, "票务" 5, "超市" 6, "水果" 7, "医药" 8, "蛋糕" 9, "酒品" 10, "服装"),CAR(11, "汽配" 12, "夜宵烧烤" 99, "其他"
@property (nonatomic, assign) NSInteger category;
@property (nonatomic, strong) NSString *categoryName;


@property (nonatomic, assign) NSInteger delFlag;//删除标书



@property (nonatomic, strong) NSArray *logistics;



@property (nonatomic, assign) NSInteger cityId;// 城市ID
@property (nonatomic, copy) NSString *cityName;//城市名称




@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) NSInteger sources;//来源

@property (nonatomic, copy) NSString *auditTime;//审核时间

@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *updateTime;//更新时间

@property (nonatomic, copy) NSString *thirdStoreId;//第三方ID

@property (nonatomic, copy) NSString *address;//地址

@property (nonatomic, copy) NSString *addressDetail;//地址详情

@end


@interface FELogisticsModel : NSObject

@property (nonatomic, assign) NSInteger status;//审核状态

@property (nonatomic, copy) NSString *logistic;//平台枚举

@property (nonatomic, copy) NSString *logisticName;//平台名称

@property (nonatomic, copy) NSString *statusName;//审核状态名称

@end

