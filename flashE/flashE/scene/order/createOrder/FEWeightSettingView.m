//
//  FEWeightSettingView.m
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FEWeightSettingView.h"
#import "FEDefineModule.h"



@interface FEWeightSettingView()
@property (nonatomic, strong) FECategorysModel* categorys;
@property (nonatomic,strong) FECategoryItemModel* seletedCategory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;

@property (weak, nonatomic) IBOutlet UILabel *currentWeightLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentWeightT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentWeightH;


@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionBtnT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *actionBtnH;


@end


@implementation FEWeightSettingView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.slider setThumbImage:[UIImage imageNamed:@"fe_silde_center"] forState:UIControlStateNormal];
    self.slider.minimumValue = 3;
    self.slider.maximumValue = 50;
    
}

- (NSString*) filePath:(NSString*) fileName {
    NSString *libraryCachePath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    libraryCachePath = [libraryCachePath stringByAppendingPathComponent:fileName];
    
    return libraryCachePath;
}

- (void)setCurrentWeight:(NSInteger)currentWeight {
    currentWeight = ceil(currentWeight);
    currentWeight = MIN(currentWeight, 50);
    currentWeight = MAX(3, currentWeight);
    _currentWeight = currentWeight;
    self.currentWeightLB.text = [NSString stringWithFormat:@"重量%ldKG",(long)currentWeight];
    
    self.slider.value = currentWeight;
}


- (IBAction)submitAction:(id)sender {
//    !self.sureWeightAction?:self.sureWeightAction(self.slider.value,self.seletedCategory);
    !self.sureWeightAction?:self.sureWeightAction(self.slider.value);
}
- (IBAction)closeAction:(id)sender {
    
    !self.cancleAction?:self.cancleAction();
    
}
- (IBAction)sliderChange:(UISlider*)sender {
    self.currentWeight = ceil(self.slider.value);
    NSLog(@"change  %f",self.slider.value);
}

-(CGFloat) fitterViewHeight {
    
    CGFloat offy = self.titleTop.constant + self.titleH.constant;
    offy += self.currentWeightT.constant + self.currentWeightH.constant;
    offy += self.sliderT.constant + self.sliderH.constant;
    offy += self.descT.constant + self.descH.constant;
    offy += self.actionBtnT.constant + self.actionBtnH.constant;
    offy += 20 + kHomeIndicatorHeight;
    self.height = offy;
    return offy;
}



@end



