//
//  FEAddressModel.m
//  FEAccountManagerModule
//
//  Created by 杜翔楠 on 2019/12/11.
//

#import "FEAddressModel.h"

@implementation FEAddressModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.provinceId forKey:@"provinceId"];
    [aCoder encodeObject:self.provinceName forKey:@"provinceName"];
    [aCoder encodeObject:self.cityId forKey:@"cityId"];
    [aCoder encodeObject:self.cityName forKey:@"cityName"];
    [aCoder encodeObject:self.countyId forKey:@"countyId"];
    [aCoder encodeObject:self.countyName forKey:@"countyName"];
    [aCoder encodeObject:self.townId forKey:@"townId"];
    [aCoder encodeObject:self.townName forKey:@"townName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.provinceId = [aDecoder decodeObjectForKey:@"provinceId"];
        self.provinceName = [aDecoder decodeObjectForKey:@"provinceName"];
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.countyId = [aDecoder decodeObjectForKey:@"countyId"];
        self.countyName = [aDecoder decodeObjectForKey:@"countyName"];
        self.townId = [aDecoder decodeObjectForKey:@"townId"];
        self.townName = [aDecoder decodeObjectForKey:@"townName"];
    }

    return self;
}

- (void)setDictoData:(NSDictionary *)dic {
    self.provinceId = dic[@"provinceId"];
    self.provinceName = dic[@"provinceName"];
    self.cityId = dic[@"cityId"];
    self.cityName = dic[@"cityName"];
    self.countyId = dic[@"countyId"];
    self.countyName = dic[@"countyName"];
    self.townId = dic[@"townId"];
    self.townName = dic[@"townName"];
}

- (id)copyWithZone:(NSZone *)zone {
    FEAddressModel *copy = [[[self class] allocWithZone:zone]init];

    copy.provinceId = self.provinceId;
    copy.provinceName = self.provinceName;
    copy.cityId = self.cityId;
    copy.cityName = self.cityName;
    copy.countyId = self.countyId;
    copy.countyName = self.countyName;
    copy.townId = self.townId;
    copy.townName = self.townName;
    return copy;
}
@end
