//
//Created by ESJsonFormatForMac on 21/11/10.
//

#import "FEAccountModel.h"
#import <YYModel/YYModel.h>
#import <WZLSerializeKit/WZLSerializeKit.h>

@implementation FEAccountModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}


WZLSERIALIZE_CODER_DECODER();
WZLSERIALIZE_COPY_WITH_ZONE();
WZLSERIALIZE_DESCRIPTION();//(NOT NECESSARY)


//- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeInteger:_shopId forKey:@"shopId"];
//    [aCoder encodeObject:_mobile forKey:@"mobile"];
//    [aCoder encodeObject:_loginName forKey:@"loginName"];
//    [aCoder encodeInteger:_ID forKey:@"ID"];
//    [aCoder encodeInteger:_storeId forKey:@"storeId"];
//    [aCoder encodeInteger:_type forKey:@"type"];
//    [aCoder encodeObject:_storeName forKey:@"storeName"];
//    [aCoder encodeFloat:_balance forKey:@"balance"];
//    [aCoder encodeObject:_token forKey:@"token"];
//    [aCoder encodeInteger:_status forKey:@"status"];
//    [aCoder encodeObject:_storeList forKey:@"storeList"];
//}
//
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super init]) {
//        
//        self.shopId = [aDecoder decodeIntegerForKey:@"shopId"];
//        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
//        self.loginName = [aDecoder decodeObjectForKey:@"loginName"];
//        self.ID = [aDecoder decodeIntegerForKey:@"ID"];
//        self.storeId = [aDecoder decodeIntegerForKey:@"storeId"];
//        self.type = [aDecoder decodeIntegerForKey:@"type"];
//        self.storeName = [aDecoder decodeObjectForKey:@"storeName"];
//        self.balance = [aDecoder decodeFloatForKey:@"balance"];
//        self.token = [aDecoder decodeObjectForKey:@"token"];
//        self.status = [aDecoder decodeIntegerForKey:@"status"];
//        self.storeList = [aDecoder decodeObjectForKey:@"storeList"];
//    }
//
//    return self;
//}
//
//- (id)copyWithZone:(NSZone *)zone {
//    FEAccountModel *copy = [[[self class] allocWithZone:zone]init];
//    copy.shopId = self.shopId;
//    copy.mobile = self.mobile;
//    copy.loginName = self.loginName;
//    copy.ID = self.ID;
//    copy.storeId = self.storeId;
//    copy.type = self.type;
//    copy.storeName = self.storeName;
//    copy.balance = self.balance;
//    copy.token = self.token;
//    copy.status = self.status;
//    copy.storeList = self.storeList;
//    return copy;
//}


@end

