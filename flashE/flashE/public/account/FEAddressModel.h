//
//  FEAddressModel.h
//  FEAccountManagerModule
//
//  Created by 杜翔楠 on 2019/12/11.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEAddressModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString    *provinceId;
@property (nonatomic, copy) NSString    *provinceName;
@property (nonatomic, copy) NSString    *cityId;
@property (nonatomic, copy) NSString    *cityName;
@property (nonatomic, copy) NSString    *countyId;
@property (nonatomic, copy) NSString    *countyName;
@property (nonatomic, copy) NSString    *townId;
@property (nonatomic, copy) NSString    *townName;
@property (nonatomic, copy) NSString    *addressDetail;
@property (nonatomic, copy) NSString    *consigneePhoneNo;  // 手机号
@property (nonatomic, copy) NSString    *areaCode;          // 地区编码
@end

NS_ASSUME_NONNULL_END


