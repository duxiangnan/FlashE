//
//Created by ESJsonFormatForMac on 21/11/17.
//

#import "FEOrderDetailModel.h"
@implementation FEOrderDetailModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"logistics" : [FEOrderDtailLogisticModel class], @"routes" : [FEOrderDtailRouteModel class]};
}


@end

@implementation FEOrderDtailLogisticModel


@end


@implementation FEOrderDtailRouteModel


@end


