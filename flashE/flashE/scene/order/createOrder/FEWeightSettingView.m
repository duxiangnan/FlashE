//
//  FEWeightSettingView.m
//  flashE
//
//  Created by duxiangnan on 2021/11/28.
//

#import "FEWeightSettingView.h"
#import "FEDefineModule.h"
#import "FEHttpManager.h"
#import "FECategorysModel.h"
#import <WZLSerializeKit/WZLSerializeKit.h>



@interface FECategroyCell : UICollectionViewCell
@property (nonatomic,strong) FECategoryItemModel* model;
@property (nonatomic, strong) UILabel* name;

@end
@implementation FECategroyCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        [self.contentView addSubview:self.name];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.name.frame = self.contentView.bounds;
    
//    [self freshCellView];
}
- (void) setModel:(FECategoryItemModel*) model{
    _model = model;
    CGFloat width = kScreenWidth - 16*2;
    width = (width - 10*3)/3;
    self.name.frame = CGRectMake(0,0,width, 30);
    self.name.text = [FEPublicMethods SafeString:model.name];
    
    self.name.textColor = model.selected?UIColorFromRGB(0x12B398):UIColorFromRGB(0x333333);
    self.name.backgroundColor = model.selected?UIColorFromRGBA(0x12B398,0.1):UIColor.whiteColor;
    self.name.cornerRadius = self.name.frame.size.height/2;
    self.name.borderColor = self.model.selected?UIColorFromRGB(0x12B398):UIColorFromRGB(0xD8D8D8);
    
    
}

- (UILabel*) name {
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.font = [UIFont regularFont:14];
        _name.textAlignment = NSTextAlignmentCenter;
        _name.textColor = UIColorFromRGB(0x333333);
        
        _name.borderWidth = 1;
    }
    return _name;
}

@end



@interface FEWeightSettingView()
@property (nonatomic, strong) FECategorysModel* categorys;
@property (nonatomic,strong) FECategoryItemModel* seletedCategory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;

@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH;

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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 16;
    CGFloat width = kScreenWidth - 16*2;
    width = (width - 10*3)/3;
    layout.itemSize =CGSizeMake(width, 30);
    self.collection.collectionViewLayout = layout;
    
    self.collection.backgroundColor = [UIColor clearColor];
    
    
    [self.collection registerClass:[FECategroyCell class] forCellWithReuseIdentifier:@"FECategroyCell"];
    WZLSERIALIZE_UNARCHIVE(self.categorys, @"FECategorysModel", [self filePath:@"FE_categorys"]);
    [self.slider setThumbImage:[UIImage imageNamed:@"fe_silde_center"] forState:UIControlStateNormal];
    self.slider.minimumValue = 5;
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
    currentWeight = MAX(5, currentWeight);
    _currentWeight = currentWeight;
    self.currentWeightLB.text = [NSString stringWithFormat:@"重量%ldKG",(long)currentWeight];
    
    self.slider.value = currentWeight;
}


- (IBAction)submitAction:(id)sender {
    !self.sureWeightAction?:self.sureWeightAction(self.slider.value,self.seletedCategory);
}
- (IBAction)closeAction:(id)sender {
    
    !self.cancleAction?:self.cancleAction();
    
}
- (IBAction)sliderChange:(UISlider*)sender {
    self.currentWeight = ceil(self.slider.value);
    NSLog(@"change  %f",self.slider.value);
}
- (void) getCategorysData:(void(^)(FECategorysModel* modle))complate {
    
    @weakself(self);
    WZLSERIALIZE_UNARCHIVE(self.categorys, @"FECategorysModel", [self filePath:@"FE_categorys"]);
    if (self.categorys) {
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongself(weakSelf);
            [strongSelf getDefaultCategory];
            complate(strongSelf.categorys);
        });
    } else {
        [MBProgressHUD showProgressOnView:self];
        
        [[FEHttpManager defaultClient] GET:@"/deer/store/queryCategorys" parameters:nil
          success:^(NSInteger code, id  _Nonnull response)
        {
            @strongself(weakSelf);
            [MBProgressHUD hideProgressOnView:strongSelf];
            strongSelf.categorys = [FECategorysModel yy_modelWithDictionary:response];
            [strongSelf getDefaultCategory];
            WZLSERIALIZE_ARCHIVE(strongSelf.categorys, @"FECategorysModel", [strongSelf filePath:@"FE_categorys"]);
            complate(self.categorys);
        } failure:^(NSError * _Nonnull error, id  _Nonnull response) {
            @strongself(weakSelf);
            [MBProgressHUD hideProgressOnView:strongSelf];
            [MBProgressHUD showMessage:error.localizedDescription];
            complate(self.categorys);
        } cancle:^{
            @strongself(weakSelf);
            [MBProgressHUD hideProgressOnView:strongSelf];
            complate(self.categorys);
        }];
    }
}
-(CGFloat) fitterViewHeight {
    
    CGFloat offy = self.titleTop.constant + self.titleH.constant;
    offy += self.currentWeightT.constant + self.currentWeightH.constant;
    offy += self.sliderT.constant + self.sliderH.constant;
    offy += self.descT.constant + self.descH.constant;
    offy += self.actionBtnT.constant + self.actionBtnH.constant;
    offy += 20 + kHomeIndicatorHeight;
    CGFloat tmp = offy;
    if (self.categorys.data.count>0) {
        self.collectionT.constant = 20;
        self.collectionH.constant = (30+10)*(ceil(self.categorys.data.count/3.0));
    } else {
        self.collectionT.constant = 0;
        self.collectionH.constant = 0;
    }
    offy += self.collectionT.constant + self.collectionH.constant;
    if (offy > kScreenHeight-100) {
        self.collectionT.constant = 20;
        self.collectionH.constant = kScreenHeight-100 - tmp - self.collectionT.constant;
        offy = self.collectionT.constant + self.collectionH.constant + tmp;
    }
    
    self.height = offy;
    return offy;
}
- (void) getDefaultCategory {
    for (FECategoryItemModel* item in self.categorys.data) {
        if (item.selected) {
            self.seletedCategory = item;
            break;
        }
    }
    if (!self.seletedCategory && self.categorys.data.count>0) {
        self.seletedCategory = self.categorys.data.firstObject;
        self.seletedCategory.selected = YES;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.categorys.data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FECategroyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FECategroyCell" forIndexPath:indexPath];
    
    cell.model = self.categorys.data[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.seletedCategory.selected = NO;
    if (self.categorys.data.count>indexPath.item) {
        FECategoryItemModel* item = self.categorys.data[indexPath.item];
        item.selected = YES;
        self.seletedCategory = item;
        WZLSERIALIZE_ARCHIVE(self.categorys, @"FECategorysModel", [self filePath:@"FE_categorys"]);
    }
    
    
    [collectionView reloadData];
    
    
}



@end



