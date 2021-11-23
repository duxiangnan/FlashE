//
//Created by ESJsonFormatForMac on 21/11/18.
//

#import <Foundation/Foundation.h>


@interface FEStorePartModel : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger category;

@property (nonatomic, copy) NSString *businessLicense;

@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *longitude;

@property (nonatomic, copy) NSString *latitude;

@property (nonatomic, assign) NSInteger defaultStore;

@property (nonatomic, copy) NSString *addressDetail;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *reverseIdcard;

@property (nonatomic, assign) NSInteger shopId;

@property (nonatomic, copy) NSString *facade;

@property (nonatomic, assign) NSInteger cityId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *frontIdcard;

@end
