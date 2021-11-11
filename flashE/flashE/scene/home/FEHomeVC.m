//
//  FEHomeVC.m
//  flashE
//
//  Created by duxiangnan on 2021/11/5.
//

#import "FEHomeVC.h"
#import <FFRouter/FFRouter.h>
@interface FEHomeVC ()

@end

@implementation FEHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"cccc%@",self.navigationController);
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)topLeftAction:(id)sender {
    [FFRouter routeURL:@"deckControl://show"];
    
}




@end
