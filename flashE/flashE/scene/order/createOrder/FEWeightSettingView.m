//
//  FEWeightSettingView.m
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FEWeightSettingView.h"
@interface FEWeightSettingView()
@property (weak, nonatomic) IBOutlet UILabel *currentWeightLB;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end


@implementation FEWeightSettingView
- (void)awakeFromNib {
    [super awakeFromNib]
    ;
    [self.slider setThumbImage:[UIImage imageNamed:@"fe_silde_center"] forState:UIControlStateNormal];
    self.slider.minimumValue = 5;
    self.slider.maximumValue = 50;
}

- (void)setCurrentWeight:(NSInteger)currentWeight {
    currentWeight = ceil(currentWeight);
    currentWeight = MIN(currentWeight, 50);
    currentWeight = MAX(5, currentWeight);
    _currentWeight = currentWeight;
    self.currentWeightLB.text = [NSString stringWithFormat:@"重量%ldKG",(long)currentWeight];
    
    self.slider.value = currentWeight;
}


- (IBAction)submitAction:(id)sender {
    !self.sureWeightAction?:self.sureWeightAction(self.slider.value);
}
- (IBAction)closeAction:(id)sender {
    
    !self.cancleAction?:self.cancleAction();
    
}
- (IBAction)sliderChange:(UISlider*)sender {
    self.currentWeight = ceil(self.slider.value);
    NSLog(@"change  %f",self.slider.value);
}

@end
