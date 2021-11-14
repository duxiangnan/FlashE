//
//Created by ESJsonFormatForMac on 21/11/14.
//

#import "FEHomeWorkModel.h"
#import <DateTools/DateTools.h>
@implementation FEHomeWorkModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"orders" : [FEHomeWorkOrderModel class]};
}


@end


@implementation FEHomeWorkCountModel


@end


@implementation FEHomeWorkOrderModel

- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic  {
    
    double tmpLong = ((NSNumber*)dic[@"cancelTime"]).longValue/1000;
    NSDate* tmpData = [[NSDate alloc] initWithTimeIntervalSince1970:tmpLong];
    _cancelTimeStr = [tmpData formattedDateWithFormat:@"MM-dd HH:mm"];
    
    tmpLong = ((NSNumber*)dic[@"grebTime"]).longValue/1000;
    tmpData = [[NSDate alloc] initWithTimeIntervalSince1970:tmpLong];
    _grebTimeStr = [tmpData formattedDateWithFormat:@"MM-dd HH:mm"];
    
    tmpLong = ((NSNumber*)dic[@"pickupTime"]).longValue/1000;
    tmpData = [[NSDate alloc] initWithTimeIntervalSince1970:tmpLong];
    _pickupTimeStr = [tmpData formattedDateWithFormat:@"MM-dd HH:mm"];
    
    tmpLong = ((NSNumber*)dic[@"createTime"]).longValue/1000;
    tmpData = [[NSDate alloc] initWithTimeIntervalSince1970:tmpLong];
    _createTimeStr = [tmpData formattedDateWithFormat:@"MM-dd HH:mm"];
    
    tmpLong = ((NSNumber*)dic[@"finishTime"]).longValue/1000;
    tmpData = [[NSDate alloc] initWithTimeIntervalSince1970:tmpLong];
    _finishTimeStr = [tmpData formattedDateWithFormat:@"MM-dd HH:mm"];
    
    tmpLong = ((NSNumber*)dic[@"systemTime"]).longValue/1000;
    tmpData = [[NSDate alloc] initWithTimeIntervalSince1970:tmpLong];
    _systemTimeStr = [tmpData formattedDateWithFormat:@"MM-dd HH:mm"];
    
    
    return YES;
}

@end


@implementation FEHomeWorkCellCommond


@end
