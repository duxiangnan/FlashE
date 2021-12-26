//
//Created by ESJsonFormatForMac on 21/11/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FEMyStoreModel.h"


@interface FEAccountModel : NSObject<NSCopying,NSCoding>

@property (nonatomic, assign) NSInteger shopId;//商户ID

@property (nonatomic, copy) NSString *mobile;//联系电话

@property (nonatomic, copy) NSString *loginName;//登录名

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, assign) NSInteger storeId;//店铺ID

@property (nonatomic, assign) NSInteger type;//角色,10老板;20店长;30员工

@property (nonatomic, copy) NSString *storeName;//商铺名称

@property (nonatomic, assign) CGFloat balance;//余额

@property (nonatomic, copy) NSString *token;

@property (nonatomic, assign) long status;//商户注册状态：0第一次登陆需提交店铺资料；1

@property (nonatomic, copy) NSArray<FEMyStoreModel*>* storeList;//店铺列表



@end
