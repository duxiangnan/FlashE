//
//Created by ESJsonFormatForMac on 21/11/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FEAccountModel : NSObject

@property (nonatomic, assign) NSInteger shopId;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger storeId;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *storeName;

@property (nonatomic, assign) CGFloat balance;

@property (nonatomic, copy) NSString *token;

@end
