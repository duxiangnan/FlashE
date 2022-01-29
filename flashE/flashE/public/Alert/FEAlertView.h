//
//  FEAlertView.h
//  FEAlertView
//
//  Created by rainer_liao on 15/11/5.
//  Copyright © 2015年 rainer_liao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FEAlertActionStyle)
{
    FEAlertActionStyleDefault = 0,
    FEAlertActionStyleCancel,
};

@interface FEAlertAction : NSObject

+ (instancetype)actionWithTitle:(NSString *)title style:(FEAlertActionStyle)style handler:(void (^)(FEAlertAction *action))handler;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) FEAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(FEAlertAction *action);
@property (nonatomic, assign) BOOL enabled;

@end

@interface FEAlertView : UIView

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) float firstAndSecondRatio; //default 1.0 
/**
 An array of NYAlertAction objects representing the actions that the user can take in response to the alert view
 */
@property (nonatomic, readonly) NSArray *actions;
- (id)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(FEAlertAction *)action;
/**
 *  设置自定义视图,如果width小于getMaxContentViewMaxWidth尺寸时，自定义视图垂直居中布局
 *
 *  @param contentView The custom view you want to use
 *  @param width       view width
 *  @param height      view height
 */

- (void)setContentView:(UIView *)contentView width:(NSInteger)width height:(NSInteger)height;
/**
*  获取自定义视图可用最大宽
*/
- (CGFloat) getMaxContentViewMaxWidth;


- (void)show;
- (void)close;

@end
