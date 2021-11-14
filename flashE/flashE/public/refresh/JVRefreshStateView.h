//
//  JVRefreshStateView.h
//  oversea_jv
//
//  Created by Ton on 16/1/21.
//  Copyright © 2016年 JD.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
@interface JVRefreshStateView : UIView

- (void)setTitle:(NSString *)title forState:(MJRefreshState)state;

- (void)setState:(MJRefreshState)state;

@end
