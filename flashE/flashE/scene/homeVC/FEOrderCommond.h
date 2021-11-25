//
//  FEOrderCommond.h
//  flashE
//
//  Created by duxiangnan on 2021/11/26.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    FEOrderCommondCancel,//取消订单
    FEOrderCommondAddCheck,//加小费
    FEOrderCommondCallRider,//联系骑手
    FEOrderCommondRetry,//重新发送
} FEOrderCommondType;

@interface FEOrderCommond : NSObject
@property(nonatomic, assign) int commodType;
@property(nonatomic, copy) NSString* commodName;
@property(nonatomic, assign) CGFloat commodWidth;

@end
NS_ASSUME_NONNULL_END
