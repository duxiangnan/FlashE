//
//  FEStoreCityModel.m
//  flashE
//
//  Created by duxiangnan on 2021/12/3.
//

#import "FEStoreCityModel.h"
#import <WZLSerializeKit/WZLSerializeKit.h>

@implementation FEStoreCityItemModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}


WZLSERIALIZE_CODER_DECODER();
WZLSERIALIZE_COPY_WITH_ZONE();
WZLSERIALIZE_DESCRIPTION();//(NOT NECESSARY)

@end




@implementation FEStoreCityModel


+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"cities" : [FEStoreCityItemModel class]};
}


@end
