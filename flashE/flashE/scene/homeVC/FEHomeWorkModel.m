//
//Created by ESJsonFormatForMac on 21/11/14.
//

#import "FEHomeWorkModel.h"
#import <DateTools/DateTools.h>
@implementation FEHomeWorkModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"orders" : [FEHomeWorkOrderModel class],
             @"count" : [FEHomeWorkCountModel class]
    };
}


@end


@implementation FEHomeWorkCountModel


@end


@implementation FEHomeWorkOrderModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic  {
   
    double systemL = ((NSNumber*)dic[@"systemTime"]).longValue/1000;
    NSDate* systemD = [[NSDate alloc] initWithTimeIntervalSince1970:systemL];
    // 10,//待接单  20, //待取单 //配送中 //已取消 //已完成
    switch (self.status) {
        case 10: {//待接单
            double tmpL = ((NSNumber*)dic[@"createTime"]).longValue/1000;
            NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
            NSInteger date = [systemD minutesFrom:tmpD];
            self.showStuseTimeStr = [NSString stringWithFormat:@"已呼叫%ld分钟",date];
        }break;
        case 20:{
            double tmpL = ((NSNumber*)dic[@"grebTime"]).longValue/1000;
            NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
            NSInteger date = [systemD minutesFrom:tmpD];
            self.showStuseTimeStr = [NSString stringWithFormat:@"已等待%ld分钟",date];
        }break;
//        case 30:{
//            double tmpL = ((NSNumber*)dic[@"grebTime"]).longValue/1000;
//            NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
//            NSInteger date = [systemD minutesFrom:tmpD];
//            self.showStuseTimeStr = [NSString stringWithFormat:@"已到店%ld分钟",date];
//        }break;
        case 40:{
            double tmpL = ((NSNumber*)dic[@"pickupTime"]).longValue/1000;
            NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
            NSInteger date = [systemD minutesFrom:tmpD];
            self.showStuseTimeStr = [NSString stringWithFormat:@"已配送%ld分钟",date];
        }break;
        case 50:{
            double tmpL = ((NSNumber*)dic[@"finishTime"]).longValue/1000;
            NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
            self.showStuseTimeStr = [NSString stringWithFormat:@"%@已完成",[tmpD formattedDateWithFormat:@"MM-dd HH:mm"]];
        }break;
        case 60:{
                double tmpL = ((NSNumber*)dic[@"cancelTime"]).longValue/1000;
                NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
                self.showStuseTimeStr = [NSString stringWithFormat:@"%@已取消",[tmpD formattedDateWithFormat:@"MM-dd HH:mm"]];
        }break;
        default:
            break;
    }
    
    double tmpLong = ((NSNumber*)dic[@"createTime"]).longValue/1000;
    if(tmpLong > 0) {
        NSDate* tmpData = [[NSDate alloc] initWithTimeIntervalSince1970:tmpLong];
        _createTimeStr = [tmpData formattedDateWithFormat:@"MM-dd HH:mm"];
    }
    return YES;
}

@end


@implementation FEHomeWorkCellCommond


@end
