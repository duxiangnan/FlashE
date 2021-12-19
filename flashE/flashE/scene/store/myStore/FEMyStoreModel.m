//
//Created by ESJsonFormatForMac on 21/11/20.
//

#import "FEMyStoreModel.h"
@implementation FEMyStoreModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"logistics" : [FELogisticsModel class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_status forKey:@"status"];
    [aCoder encodeObject:_frontIdcard forKey:@"frontIdcard"];
    [aCoder encodeObject:_reverseIdcard forKey:@"reverseIdcard"];
    [aCoder encodeObject:_facade forKey:@"facade"];
    [aCoder encodeObject:_businessLicense forKey:@"businessLicense"];
    [aCoder encodeInteger:_ID forKey:@"ID"];
    [aCoder encodeInteger:_defaultStore forKey:@"defaultStore"];
    [aCoder encodeInteger:_shopId forKey:@"shopId"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_bdCode forKey:@"bdCode"];
    [aCoder encodeObject:_latitude forKey:@"latitude"];
    [aCoder encodeObject:_longitude forKey:@"longitude"];
    [aCoder encodeInteger:_category forKey:@"category"];
    [aCoder encodeObject:_categoryName forKey:@"categoryName"];
    [aCoder encodeInteger:_delFlag forKey:@"delFlag"];
    [aCoder encodeObject:_logistics forKey:@"logistics"];
    [aCoder encodeInteger:_cityId forKey:@"cityId"];
    [aCoder encodeObject:_cityName forKey:@"cityName"];
    [aCoder encodeObject:_mobile forKey:@"mobile"];
    [aCoder encodeInteger:_sources forKey:@"sources"];
    [aCoder encodeObject:_auditTime forKey:@"auditTime"];
    [aCoder encodeObject:_createTime forKey:@"createTime"];
    [aCoder encodeObject:_updateTime forKey:@"updateTime"];
    [aCoder encodeObject:_thirdStoreId forKey:@"thirdStoreId"];
    [aCoder encodeObject:_address forKey:@"address"];
    [aCoder encodeObject:_addressDetail forKey:@"addressDetail"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        self.status = [aDecoder decodeIntegerForKey:@"status"];
        self.frontIdcard = [aDecoder decodeObjectForKey:@"frontIdcard"];
        self.reverseIdcard = [aDecoder decodeObjectForKey:@"reverseIdcard"];
        self.facade = [aDecoder decodeObjectForKey:@"facade"];
        self.businessLicense = [aDecoder decodeObjectForKey:@"businessLicense"];
        self.ID = [aDecoder decodeIntegerForKey:@"ID"];
        self.defaultStore = [aDecoder decodeIntegerForKey:@"defaultStore"];
        self.shopId = [aDecoder decodeIntegerForKey:@"shopId"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.bdCode = [aDecoder decodeObjectForKey:@"bdCode"];
        self.latitude = [aDecoder decodeObjectForKey:@"latitude"];
        self.longitude = [aDecoder decodeObjectForKey:@"longitude"];
        self.category = [aDecoder decodeIntegerForKey:@"category"];
        self.categoryName = [aDecoder decodeObjectForKey:@"categoryName"];
        self.delFlag = [aDecoder decodeIntegerForKey:@"delFlag"];
        self.logistics = [aDecoder decodeObjectForKey:@"logistics"];
        self.cityId = [aDecoder decodeIntegerForKey:@"cityId"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.sources = [aDecoder decodeIntegerForKey:@"sources"];
        self.auditTime = [aDecoder decodeObjectForKey:@"auditTime"];
        self.createTime = [aDecoder decodeObjectForKey:@"createTime"];
        self.updateTime = [aDecoder decodeObjectForKey:@"updateTime"];
        self.thirdStoreId = [aDecoder decodeObjectForKey:@"thirdStoreId"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.addressDetail = [aDecoder decodeObjectForKey:@"addressDetail"];
    }

    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    FEMyStoreModel *copy = [[[self class] allocWithZone:zone]init];
    copy.status = self.status;
    copy.frontIdcard = self.frontIdcard;
    copy.reverseIdcard = self.reverseIdcard;
    copy.facade = self.facade;
    copy.businessLicense = self.businessLicense;
    copy.ID = self.ID;
    copy.defaultStore = self.defaultStore;
    copy.shopId = self.shopId;
    copy.name = self.name;
    copy.bdCode = self.bdCode;
    copy.latitude = self.latitude;
    copy.longitude = self.longitude;
    copy.category = self.category;
    copy.categoryName = self.categoryName;
    copy.delFlag = self.delFlag;
    copy.logistics = self.logistics;
    copy.cityId = self.cityId;
    copy.cityName = self.cityName;
    copy.mobile = self.mobile;
    copy.sources = self.sources;
    copy.auditTime = self.auditTime;
    copy.createTime = self.createTime;
    copy.updateTime = self.updateTime;
    copy.thirdStoreId = self.thirdStoreId;
    copy.address = self.address;
    copy.addressDetail = self.addressDetail;
    
    return copy;
}


//@property (nonatomic, strong) NSArray<FELogisticsModel*> *logistics;

@end

@implementation FELogisticsModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInteger:_status forKey:@"status"];
    [aCoder encodeObject:_logistic forKey:@"logistic"];
    [aCoder encodeObject:_logisticName forKey:@"logisticName"];
    [aCoder encodeObject:_statusName forKey:@"statusName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.status = [aDecoder decodeIntegerForKey:@"status"];
        self.logistic = [aDecoder decodeObjectForKey:@"logistic"];
        self.logisticName = [aDecoder decodeObjectForKey:@"logisticName"];
        self.statusName = [aDecoder decodeObjectForKey:@"statusName"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    FELogisticsModel *copy = [[[self class] allocWithZone:zone]init];
    copy.status = self.status;
    copy.logistic = self.logistic;
    copy.logisticName = self.logisticName;
    copy.statusName = self.statusName;
    return copy;
}

@end


