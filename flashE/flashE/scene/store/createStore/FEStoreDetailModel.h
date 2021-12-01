//
//Created by ESJsonFormatForMac on 21/11/30.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FESoreDetailCellTypeAddress = 0, //地址层
    FESoreDetailCellTypeZJ,//证件层
    FESoreDetailCellTypeZH,//执照层
    FESoreDetailCellTypeCommond,//指令按妞
    FESoreDetailCellTypeLogistTitle,//平台标题
    FESoreDetailCellTypeLocgist,
} FESoreDetailCellType;


@class FESoreDetailLogisticModle;
@class FESoreDetailCellModle;
@interface FEStoreDetailModel : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *businessLicense;

@property (nonatomic, copy) NSString *frontIdcard;

@property (nonatomic, copy) NSString *reverseIdcard;

@property (nonatomic, copy) NSString *updateTime;

@property (nonatomic, assign) NSInteger shopId;

@property (nonatomic, copy) NSString *bdCode;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, assign) NSInteger category;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger delFlag;

@property (nonatomic, assign) NSInteger defaultStore;

@property (nonatomic, strong) NSArray<FESoreDetailLogisticModle*> *logistics;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger cityId;

@property (nonatomic, copy) NSString *facade;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, assign) NSInteger sources;

@property (nonatomic, copy) NSString *auditTime;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *thirdStoreId;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *addressDetail;

@property (nonatomic, copy) NSArray<FESoreDetailCellModle*> *cells;

@end
@interface FESoreDetailLogisticModle : NSObject

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *logistic;

@property (nonatomic, copy) NSString *logisticName;

@property (nonatomic, copy) NSString *statusName;

@end


@interface FESoreDetailCellModle : NSObject



@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) CGFloat cellHeight;


@end
