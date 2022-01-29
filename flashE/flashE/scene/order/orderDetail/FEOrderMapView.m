//
//  FEOrderMapView.m
//  flashE
//
//  Created by duxiangnan on 2022/1/28.
//

#import "FEOrderMapView.h"

#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"

#import "FEMapView.h"


@interface FEOrderMapView ()<MAMapViewDelegate>

#import "FEDefineModule.h"
#import "FEOrderDetailModel.h"

#import "FEMapView.h"


@property (nonatomic, strong) FEOrderDetailModel* model;
@property (nonatomic, strong) NSMutableArray* mapAnnotation;


@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, assign) BOOL makeMapCenter;

@end


@implementation FEOrderMapView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView {
    
    self.mapView = [[MAMapView alloc] init];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.showsCompass = NO;
//    self.mapView.showsScale = YES;
//    self.mapView.scaleOrigin = CGPointMake(16, [self getMaxHeight] - 40);
    [self addSubview:self.mapView];
    
    self.mapAnnotation = [NSMutableArray array];
   

}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.mapView.frame = CGRectMake(0, 0, kScreenWidth, [self getMaxHeight]);
}
- (CGFloat) getMinHeight {
    return kHomeInformationBarHeigt + 44 ;
}
- (CGFloat) getMaxHeight {
    return kScreenHeight/2 ;
}

- (void) setModel:(FEOrderDetailModel*)model {
    _model = model;
    [self updataSubView];
    [self.mapView removeAnnotations:self.mapAnnotation];
    [self.mapAnnotation removeAllObjects];
    if (!self.mapView.hidden && _model) {
        CLLocationCoordinate2D locOne = CLLocationCoordinate2DMake(model.fromLatitude.doubleValue, model.fromLongitude.doubleValue);
        NSDictionary* userInfo = @{@"image":[UIImage imageNamed:@"fe_order_map_fa"],
                                   @"title":model.showStuseTimeStr};
        [self addAnnotationWithCooordinate:locOne userInfo:userInfo];
        if (!self.makeMapCenter) {
            self.makeMapCenter = YES;
            [self.mapView setCenterCoordinate:locOne animated:YES];
            [self.mapView setZoomLevel:12];
        }
        
        
        
        
        CLLocationCoordinate2D locTow = CLLocationCoordinate2DMake(model.toLatitude.doubleValue, model.toLongitude.doubleValue);
        userInfo = @{@"image":[UIImage imageNamed:@"fe_order_map_1"]};
        [self addAnnotationWithCooordinate:locTow userInfo:userInfo];
        
        
        
    }
    
}
- (void) updataSubView {
    if (self.model.status == 10 ||
        self.model.status == 20 ||
        self.model.status == 30||
        self.model.status == 40) {
        self.height = [self getMaxHeight];
        self.mapView.hidden = NO;
    } else {
        self.height = [self getMinHeight];
        self.mapView.hidden = YES;
    }
}
#pragma mark  map function

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate userInfo:(NSDictionary*)userInfo
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.userObject = userInfo;
    [self.mapView addAnnotation:annotation];
    [self.mapAnnotation addObject:annotation];
}



- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"FEMapView";
        FEMapView *annotationView = (FEMapView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[FEMapView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
        }
        NSDictionary* userInfo = ((NSObject*)annotation).userObject;
        annotationView.portrait = userInfo[@"image"];
        annotationView.name = userInfo[@"title"];
        annotationView.centerOffset = CGPointMake(0, -annotationView.bounds.size.height/2);
        
        return annotationView;
    }
    
    return nil;
}

@end
