//
//  FEStoreCityModel.m
//  flashE
//
//  Created by duxiangnan on 2021/12/3.
//

#import "FEStoreCityModel.h"

@implementation FEStoreCityItemModel


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end




@implementation FEStoreCityModel


+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"cities" : [FEStoreCityItemModel class]};
}


@end
