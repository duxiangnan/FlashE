//
//Created by ESJsonFormatForMac on 21/12/04.
//

#import "FECreateOrderLogisticModel.h"


@implementation FECreateOrderModel

@end



@implementation FECreateOrderLogisticModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"details" : [FECreateOrderLogisticDetailsModel class]};
}


@end

@implementation FECreateOrderLogisticDetailsModel


@end


