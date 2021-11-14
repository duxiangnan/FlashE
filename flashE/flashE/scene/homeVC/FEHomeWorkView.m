//
//  FEHomeWorkView.m
//  flashE
//
//  Created by duxiangnan on 2021/11/12.
//

#import "FEHomeWorkView.h"
@interface FEHomeWorkView()

@property (nonatomic,strong) UITableView* table;

@end


@implementation FEHomeWorkView




//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




/**
 返回listView。如果是vc包裹的就是vc.view；如果是自定义view包裹的，就是自定义view自己。

 @return UIView
 */
- (UIView *)listView {
    return self;
}

/**
 返回listView内部持有的UIScrollView或UITableView或UICollectionView
 主要用于mainTableView已经显示了header，listView的contentOffset需要重置时，内部需要访问到外部传入进来的listView内的scrollView

 @return listView内部持有的UIScrollView或UITableView或UICollectionView
 */
- (UIScrollView *)listScrollView {
    return self.table;
}



/**
 当listView内部持有的UIScrollView或UITableView或UICollectionView的代理方法`scrollViewDidScroll`回调时，需要调用该代理方法传入的callback

 @param callback `scrollViewDidScroll`回调时调用的callback
 */
- (void)listViewDidScrollCallback:(void (^)(UIScrollView *scrollView))callback {
    callback(self.table);
}

@end
