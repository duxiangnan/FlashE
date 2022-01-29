//
//Created by ESJsonFormatForMac on 21/11/22.
//

#import "FERechargeRecodeModel.h"
#import <DateTools/DateTools.h>

@implementation FERechargeRecodeModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic  {
   
    double tmpLong = ((NSNumber*)dic[@"createTime"]).longValue/1000;
    if(tmpLong > 0) {
        NSDate* tmpData = [[NSDate alloc] initWithTimeIntervalSince1970:tmpLong];
        _createTimeStr = [tmpData formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
    }
    return YES;
}

@end

