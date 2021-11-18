//
//  FEStoreDetailVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/19.
//

#import "FEStoreDetailVC.h"
#import "FEDefineModule.h"

@interface FEStoreDetailVC ()

@end

@implementation FEStoreDetailVC
+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
        
        [FFRouter registerObjectRouteURL:@"store://storeDetail" handler:^id(NSDictionary *routerParameters) {
            FEStoreDetailVC* vc = [[FEStoreDetailVC alloc] initWithNibName:@"FEStoreDetailVC" bundle:nil];
            vc.ID = ((NSNumber*)routerParameters[@"ID"]).integerValue;
            
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
