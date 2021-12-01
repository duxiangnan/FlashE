//
//Created by ESJsonFormatForMac on 21/11/30.
//

#import "FEStoreDetailModel.h"
@implementation FEStoreDetailModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"logistics" : [FESoreDetailLogisticModle class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end

@implementation FESoreDetailLogisticModle


@end


@implementation FESoreDetailCellModle


@end


