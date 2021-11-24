//
//Created by ESJsonFormatForMac on 21/11/17.
//

#import "FEOrderDetailModel.h"
@implementation FEOrderDetailModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"logistics" : [FEOrderDtailLogisticModel class]};
}
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end

@implementation FEOrderDtailLogisticModel


@end




