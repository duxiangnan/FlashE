//
//  FEReciverAddressModel.h
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEReciverAddressModel : NSObject

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *addressDetail;

@property (nonatomic, assign) NSInteger cityId;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *latitude;

@end

NS_ASSUME_NONNULL_END
