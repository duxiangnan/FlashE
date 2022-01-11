//
//  FETipSettingView.m
//  flashE
//
//  Created by duxiangnan on 2022/1/11.
//

#import "FETipSettingView.h"

#import "FEDefineModule.h"
#import "FETipModel.h"
#import <WZLSerializeKit/WZLSerializeKit.h>

@interface FETipCell : UICollectionViewCell
@property (nonatomic,strong) FETipModel* model;
@property (nonatomic, strong) UILabel* name;

@end
@implementation FETipCell

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
- (void) setModel:(FETipModel*) model{
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

@interface FETipSettingView()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleH;


@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitT;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitH;

@property (nonatomic,copy) NSArray<FETipModel*>* models;
@property (nonatomic,strong) FETipModel* selectedTip;

@end

@implementation FETipSettingView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self getTipData];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    layout.minimumLineSpacing = 10;
//    layout.minimumInteritemSpacing = 16;
    CGFloat width = kScreenWidth - 16*2;
    width = (width - 10*3)/3;
    layout.itemSize =CGSizeMake(width, 30);
    self.collection.collectionViewLayout = layout;
    
    self.collection.backgroundColor = [UIColor clearColor];
    
    
    [self.collection registerClass:[FETipCell class] forCellWithReuseIdentifier:@"FETipCell"];
  
    
    
}

- (IBAction)submitAction:(id)sender {
    !self.sureAction?:self.sureAction(self.selectedTip);
}
- (IBAction)closeAction:(id)sender {
    !self.cancleAction?:self.cancleAction();
}
- (NSString*) filePath:(NSString*) fileName {
    NSString *libraryCachePath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    libraryCachePath = [libraryCachePath stringByAppendingPathComponent:fileName];
    
    return libraryCachePath;
}
- (void) getTipData{
    
    
    WZLSERIALIZE_UNARCHIVE(self.models, @"FETipModel", [self filePath:@"FE_Tips"]);
    if (!self.models) {
        NSMutableArray* arr = [NSMutableArray array];
        FETipModel* tip = [[FETipModel alloc] init];
        tip.name = @"不加小费";
        tip.code = 0;
        tip.selected = YES;
        [arr addObject:tip];
        tip = [[FETipModel alloc] init];
        tip.name = @"2元";
        tip.code = 2;
        [arr addObject:tip];
        tip = [[FETipModel alloc] init];
        tip.name = @"5元";
        tip.code = 5;
        [arr addObject:tip];
        tip = [[FETipModel alloc] init];
        tip.name = @"10元";
        tip.code = 10;
        [arr addObject:tip];
        tip = [[FETipModel alloc] init];
        tip.name = @"15元";
        tip.code = 15;
        [arr addObject:tip];
        tip = [[FETipModel alloc] init];
        tip.name = @"25元";
        tip.code = 25;
        [arr addObject:tip];
        tip = [[FETipModel alloc] init];
        tip.name = @"50元";
        tip.code = 50;
        [arr addObject:tip];
        self.models = arr;
        WZLSERIALIZE_ARCHIVE(self.models, @"FETipModel", [self filePath:@"FE_Tips"]);
    }
    [self getDefaultCategory];
}
-(CGFloat) fitterViewHeight {
    
    CGFloat offy = self.titleT.constant + self.titleH.constant;
    offy += self.submitT.constant + self.submitH.constant;
    
    offy += 20 + kHomeIndicatorHeight;
    CGFloat tmp = offy;
    if (self.models.count>0) {
        self.collectionT.constant = 20;
        self.collectionH.constant = (30+10)*(ceil(self.models.count/3.0));
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
    for (FETipModel* item in self.models) {
        if (item.selected) {
            self.selectedTip = item;
            break;
        }
    }
    if (!self.selectedTip && self.models.count>0) {
        self.selectedTip = self.models.firstObject;
        self.selectedTip.selected = YES;
    }
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.models.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FETipCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FETipCell" forIndexPath:indexPath];
    
    cell.model = self.models[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedTip.selected = NO;
    if (self.models.count>indexPath.item) {
        FETipModel* item = self.models[indexPath.item];
        item.selected = YES;
        self.selectedTip = item;
        WZLSERIALIZE_ARCHIVE(self.models, @"FETipModel", [self filePath:@"FE_Tips"]);
    }
    [collectionView reloadData];
    
    
}




@end

