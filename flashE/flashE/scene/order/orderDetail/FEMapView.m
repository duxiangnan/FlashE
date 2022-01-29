//
//  FEMapView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "FEMapView.h"
#import "FEDefineModule.h"


#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0
#import "FEOrderDetailModel.h"

@interface FEMapView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation FEMapView
#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 0, 0);
        self.backgroundColor = [UIColor clearColor];
        
        self.portraitImageView = [[UIImageView alloc] init];
        [self addSubview:self.portraitImageView];
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.cornerRadius = 15;
        self.nameLabel.backgroundColor  = [UIColor whiteColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = UIColorFromRGB(0x333333);
        self.nameLabel.font             = [UIFont mediumFont:13];
        [self addSubview:self.nameLabel];
    }
    
    return self;
}


- (void) freshSubView {
    UIImage* image = self.portraitImageView.image;
    CGSize size = [self.nameLabel.text sizeWithFont:self.nameLabel.font andMaxSize:CGSizeMake(CGFLOAT_MAX, 30)];
    CGFloat nameW = ceill(size.width) + 30;
    CGFloat nameH = self.nameLabel.text.length > 0?30:0;
    self.bounds = CGRectMake(0, 0,  nameW, image.size.height + (nameH>0?(nameH+5):0));
    self.nameLabel.frame = CGRectMake(0, 0, nameW, nameH);
    self.portraitImageView.frame = CGRectMake((self.bounds.size.width - image.size.width)/2,
                                              CGRectGetMaxY(self.nameLabel.frame)+5,
                                              image.size.width,
                                              image.size.height);
}
#pragma mark - Handle Action


- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
}

#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.hidden = name.length == 0;
    if (![self.nameLabel.text isEqualToString:name]) {
        self.nameLabel.text = name;
        [self freshSubView];
    }
}

- (UIImage *)portrait
{
    
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    
    
    self.portraitImageView.image = portrait;
    [self freshSubView];
    
}




- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    return;
//    if (self.selected == selected)
//    {
//        return;
//    }
//
//    if (selected)
//    {
//        if (self.calloutView == nil)
//        {
//            /* Construct custom callout. */
//            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
//
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//            btn.frame = CGRectMake(10, 10, 40, 40);
//            [btn setTitle:@"Test" forState:UIControlStateNormal];
//            [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
//            [btn setBackgroundColor:[UIColor whiteColor]];
//            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
//
//            [self.calloutView addSubview:btn];
//
//            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
//            name.backgroundColor = [UIColor clearColor];
//            name.textColor = [UIColor whiteColor];
//            name.text = @"Hello Amap!";
//            [self.calloutView addSubview:name];
//        }
//
//        [self addSubview:self.calloutView];
//    }
//    else
//    {
//        [self.calloutView removeFromSuperview];
//    }
//
//    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
//    if (!inside && self.selected)
//    {
//        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
//    }
    
    return inside;
}



@end
