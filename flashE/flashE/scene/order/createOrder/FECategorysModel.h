//
//Created by ESJsonFormatForMac on 22/01/10.
//

#import <Foundation/Foundation.h>

@class FECategoryItemModel;
@interface FECategorysModel : NSObject

@property (nonatomic, strong) NSArray<FECategoryItemModel*> *data;

@end
@interface FECategoryItemModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) BOOL selected;

@end

