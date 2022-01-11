//
//Created by ESJsonFormatForMac on 22/01/10.
//

#import "FECategorysModel.h"
#import <WZLSerializeKit/WZLSerializeKit.h>
@implementation FECategorysModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"data" : [FECategoryItemModel class]};
}


WZLSERIALIZE_CODER_DECODER();
WZLSERIALIZE_COPY_WITH_ZONE();
WZLSERIALIZE_DESCRIPTION();
@end

@implementation FECategoryItemModel

WZLSERIALIZE_CODER_DECODER();
WZLSERIALIZE_COPY_WITH_ZONE();
WZLSERIALIZE_DESCRIPTION();


@end


