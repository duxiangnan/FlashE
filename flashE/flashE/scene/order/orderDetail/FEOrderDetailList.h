//
//  FEOrderDetailList.h
//  shansong
//
//  Created by wangjian on 2020/2/26.
//  Copyright © 2020 ishansong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FEOrderDetailModel.h"
#import "FEBaseViewController.h"


typedef enum : NSUInteger {
    FEOrderDetailCellHeader = 0,
    FEOrderDetailCellLogistics,
    FEOrderDetailCellAddress,
    FEOrderDetailCellInfo,
    FEOrderDetailCellLink,//联系商家客服
    
    
} FEOrderDetailCellType;

typedef enum : NSUInteger {
    FEOrderDetailStateTop = 0,
    FEOrderDetailStateBottom,
    
} FEOrderDetailTableState;

typedef enum : NSUInteger {
    FEOrderDetailDirectionUnknow = 0,
    FEOrderDetailDirectionUp,
    FEOrderDetailDirectionDown
    
} FEOrderDetailTableDirection;


NS_ASSUME_NONNULL_BEGIN
@protocol FEOrderDetailListDelegate <NSObject>

- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)mainScrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)mainScrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;

- (void)mainScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)mainScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

@end


@interface FEOrderDetailList : UITableView

@property (nonatomic, assign) FEOrderDetailTableDirection direction;

@property (nonatomic, assign) FEOrderDetailTableState listState;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, weak) id<FEOrderDetailListDelegate> mainDelegate;



@property (nonatomic, assign) NSInteger lastZPosition;
@property (nonatomic, copy) NSString* orderId;
@property (nonatomic, weak) FEBaseViewController* vc;
@property (nonatomic, strong) FEOrderDetailModel* model;


@property (nonatomic, copy) void(^tipAcion)(void);
@property (nonatomic, copy) void(^loadModelAction)(void);
- (void) calculataionModel;

- (void) requestShowData;
- (void) requestCourierLocation;
- (void) requestAddCheck:(NSInteger) check;


@end




NS_ASSUME_NONNULL_END
