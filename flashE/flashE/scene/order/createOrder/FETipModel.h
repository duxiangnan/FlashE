//
//  FETipModel.h
//  flashE
//
//  Created by duxiangnan on 2022/1/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FETipModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) BOOL selected;
@end

NS_ASSUME_NONNULL_END

