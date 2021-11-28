//
//  NSObject+userObject.m
//  VipServicePlatform
//
//  Created by 杜翔楠 on 2019/5/24.
//  Copyright © 2019年 JD. All rights reserved.
//

#import "NSObject+userObject.h"
#import <objc/runtime.h>

static NSString *nameWithKey = @"vspUserObject";   // 定义一个key值

@implementation NSObject (userObject)

// 运行时实现setter方法
- (void)setUserObject:(id)obj {
    objc_setAssociatedObject(self, &nameWithKey,
                             obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 运行时实现getter方法
- (id)userObject {
    return objc_getAssociatedObject(self, &nameWithKey);
}

@end
