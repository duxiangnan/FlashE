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

@end

@implementation FELogisticsModel


@end


