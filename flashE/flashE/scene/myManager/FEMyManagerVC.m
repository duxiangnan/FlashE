//
//  FEMyManagerVC.m
//  flashE
//
//  Created by duxiangnan on 2022/1/22.
//

#import "FEMyManagerVC.h"
#import "FEDefineModule.h"


@interface FEMyManagerVC ()
@property (weak, nonatomic) IBOutlet UITextField *myManagerTF;

@end

@implementation FEMyManagerVC

+(void)load {
    static NSObject* obj = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        obj = [[NSObject alloc] init];
        
    
        [FFRouter registerObjectRouteURL:@"manger://createMy" handler:^id(NSDictionary *routerParameters) {
            FEMyManagerVC* vc = [[FEMyManagerVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            return vc;
        }];
    });
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = NO;
    
    
}

- (IBAction)submitAction:(id)sender {
}

@end
