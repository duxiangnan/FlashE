//
//Created by ESJsonFormatForMac on 21/11/17.
//

#import "FEOrderDetailModel.h"
#import <DateTools/DateTools.h>

@implementation FEOrderDetailModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"logistics" : [FEOrderDtailLogisticModel class], @"routes" : [FEOrderDtailRouteModel class]};
}


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic  {
   
//    waitServerSure orderStatusTipName orderStatusDescName tmpL

    double systemL = ((NSNumber*)dic[@"systemTime"]).longValue/1000;
    NSDate* systemD = [[NSDate alloc] initWithTimeIntervalSince1970:systemL];
    switch (self.status) {
        case 10: {//待接单
            self.orderStatusTipName = @"等待骑手接单";
            self.orderStatusDescName = @"正在为您呼叫以下平台，请耐心等待。";
            double tmpL = ((NSNumber*)dic[@"createTime"]).longValue/1000;
            NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
            
            NSString* timeStr = [self makeMinutesAndSecond:tmpD toDate:systemD];
            self.showStuseTimeStr = [NSString stringWithFormat:@"已呼叫 %@",timeStr];
        }break;
        case 20:{//已接单
                self.orderStatusTipName = @"骑手已到店";
                self.orderStatusDescName = @"正在为您呼叫以下平台，请耐心等待。";
           
            double tmpL = ((NSNumber*)dic[@"grebTime"]).longValue/1000;
            NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
            NSString* timeStr = [self makeMinutesAndSecond:tmpD toDate:systemD];
            self.showStuseTimeStr = [NSString stringWithFormat:@"已到店 %@",timeStr];
        }break;
        case 30:{//已到店 waitServerSure 已等待 %@",timeStr  配送员位置
            
            self.orderStatusTipName = @"骑手已到店";
            self.orderStatusDescName = [NSString stringWithFormat:@"骑手“%@”已到店，请尽快配合骑手完成取件。",self.courierName];
            double tmpL = ((NSNumber*)dic[@"grebTime"]).longValue/1000;
            NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
            NSString* timeStr = [self makeMinutesAndSecond:tmpD toDate:systemD];
            self.showStuseTimeStr = [NSString stringWithFormat:@"已等待 %@",timeStr];
        }break;
        case 40:{//配送中
                self.orderStatusTipName = @"骑手送件中";
                self.orderStatusDescName = @"骑手正在为努力送件中，请您耐心等待。";
            double tmpL = ((NSNumber*)dic[@"pickupTime"]).longValue/1000;
            NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
            NSString* timeStr = [self makeMinutesAndSecond:tmpD toDate:systemD];
            self.showStuseTimeStr = [NSString stringWithFormat:@"已配送 %@",timeStr];
        }break;
//        case 50:{//已完成
//            double tmpL = ((NSNumber*)dic[@"finishTime"]).longValue/1000;
//            NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
//            self.showStuseTimeStr = [NSString stringWithFormat:@"%@已完成",[tmpD formattedDateWithFormat:@"MM-dd HH:mm"]];
//        }break;
//        case 60:{//已取消
//                double tmpL = ((NSNumber*)dic[@"cancelTime"]).longValue/1000;
//                NSDate* tmpD = [[NSDate alloc] initWithTimeIntervalSince1970:tmpL];
//                self.showStuseTimeStr = [NSString stringWithFormat:@"%@已取消",[tmpD formattedDateWithFormat:@"MM-dd HH:mm"]];
//        }break;
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
- (NSString*) makeMinutesAndSecond:(NSDate*)sourceData toDate:(NSDate*) toDate {
    NSInteger num = [sourceData secondsFrom:toDate];
    NSInteger second = num%60;
    NSInteger minutes = num/60;
    NSString* str = [NSString stringWithFormat:@"%02d:%02d",minutes,second];
    
    return str;
}
@end

@implementation FEOrderDtailLogisticModel


@end


@implementation FEOrderDtailRouteModel


@end
