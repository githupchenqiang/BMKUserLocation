//
//  BMKMapViewController.m
//  Mapstudy
//
//  Created by chenq@kensence.com on 16/6/24.
//  Copyright © 2016年 chenq@kensence.com. All rights reserved.
//

#import "BMKMapViewController.h"
#define SuperWith self.view.frame.size.width
#define SuperHeight self.view.frame.size.height
@interface BMKMapViewController ()<BMKLocationServiceDelegate,BMKMapViewDelegate,BMKGeneralDelegate,CLLocationManagerDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService *locSeverice;
    BMKMapManager *_mapManager;
    BMKPointAnnotation *_annotation;
    BMKMapView *mapview;
    CLLocationManager *locationManager;
    BMKGeoCodeSearch  *GeoCoderSearch;
}
@property (nonatomic ,assign)CGFloat latation;
@property (nonatomic ,assign)CGFloat LongStation;
@property (nonatomic)CLLocationCoordinate2D coordinate;
@property (nonatomic ,strong)NSMutableArray *poiListArray;

@end

@implementation BMKMapViewController



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_mapManager stop];
    mapview.delegate = nil;
    GeoCoderSearch.delegate = nil;
    locationManager.delegate = nil;
    locationManager.delegate = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
      locationManager = [[CLLocationManager alloc]init];
    
    mapview = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64,SuperWith/2,SuperHeight/2)];
    [mapview setShowsUserLocation:YES];
    mapview.delegate = self;
    [self.view addSubview:mapview];
//    locSeverice = [[BMKLocationService alloc]init];
//    locSeverice.delegate = self;
//    [locSeverice startUserLocationService];
    //在地图中添加一个pointAnnotation
    _annotation = [[BMKPointAnnotation alloc]init];
    _annotation.title = @"test";
    _annotation.subtitle = @"this is a test";
    [mapview addAnnotation:_annotation];
    
    GeoCoderSearch = [[BMKGeoCodeSearch alloc]init];
    GeoCoderSearch.delegate = self;

}


- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"%@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
   NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    
    float zoomLevel = 0.02;
    BMKCoordinateRegion region = BMKCoordinateRegionMake(userLocation.location.coordinate,BMKCoordinateSpanMake(zoomLevel, zoomLevel));
    [mapview setRegion:[mapview regionThatFits:region] animated:YES];
    
    //大头针的坐标
    CLLocationCoordinate2D coor;
    coor.latitude = userLocation.location.coordinate.latitude;
    coor.longitude = userLocation.location.coordinate.longitude;
    _annotation.coordinate = coor;
}

//返回错误信息
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error

{
    if (error != nil)
        NSLog(@"locate failed: %@", [error localizedDescription]);
    else {
        NSLog(@"locate failed");
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MyAnnotation"];
        newAnnotation.pinColor = BMKPinAnnotationColorPurple;
        newAnnotation.animatesDrop = YES;
        newAnnotation.draggable = YES;
        return newAnnotation;
        
    }
    return nil;
}

- (void)setuserLocation
{
    //    定位当前位置
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置最小更新位置
    locationManager.distanceFilter = 50;
    locationManager.delegate = self;
    //监听位置信息
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setuserLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //获取最后一个定位的数据
    CLLocation *location = [locations lastObject];
    
    //依次获取cllocation中的经度纬度，高度 速度 方向信息
    NSLog(@"%f==%f==%f==%f==%f",location.coordinate.latitude,location.coordinate.longitude,location.altitude,location.speed,location.course);
    
    BMKPointAnnotation *point = [[BMKPointAnnotation alloc]init];
    point.coordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    point.title = @"北京";
    
    [mapview addAnnotation:point];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
//            NSLog(@"%@",placeMark);
            point.subtitle = [placeMark.name substringFromIndex:2];
            //获取城市
            NSString *city = placeMark.locality;
            if (!city) {
                city = placeMark.administrativeArea;
            }
            
//            NSLog(@"city==%@",city);
        
        }else if (error == nil && [placemarks count] == 0)
        {
            NSLog(@"No results were ");
        }else if (error != nil)
        {
            NSLog(@"An error occurred = %@",error);
        }
    }];
    
    [locationManager stopUpdatingLocation];
    
    
    
    
}

//反地理编码
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:mapview.annotations];
    [mapview removeAnnotations:array];
    array = [NSArray arrayWithArray:mapview.overlays];
    [mapview removeOverlays:array];
    
    [_poiListArray removeAllObjects];
    for(BMKPoiInfo *poiInfo in result.poiList)
    {
        NSLog(@"%@",poiInfo.address);
        [_poiListArray addObject:poiInfo.address];
    }
}

















- (void)dealloc
{
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
