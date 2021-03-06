//
//  FEStoreCityModel.h
//  flashE
//
//  Created by duxiangnan on 2021/12/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FEStoreCityItemModel : NSObject<NSCopying,NSCoding>

@property(nonatomic,assign) NSInteger ID;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* abbr;
@end

@interface FEStoreCityModel : NSObject
@property(nonatomic,copy) NSString* index;
@property(nonatomic,copy) NSArray<FEStoreCityItemModel*>* cities;
@end

NS_ASSUME_NONNULL_END
