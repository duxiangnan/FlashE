//
//Created by ESJsonFormatForMac on 21/11/22.
//

#import <Foundation/Foundation.h>


@interface FERechargeModel : NSObject

@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, copy) NSString *tips;

@property (nonatomic, assign) BOOL selected;
@end



@interface FERechargeTotalModel : NSObject

@property (nonatomic, assign) double balance;

@property (nonatomic, copy) NSArray<FERechargeModel*> *list;

@end
