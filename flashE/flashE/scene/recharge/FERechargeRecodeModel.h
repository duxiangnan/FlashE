//
//Created by ESJsonFormatForMac on 21/11/22.
//

#import <Foundation/Foundation.h>


@interface FERechargeRecodeModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, assign) long long createTime;
@property (nonatomic, copy) NSString* createTimeStr;
@end
