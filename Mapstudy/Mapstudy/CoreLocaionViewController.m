//
//  CoreLocaionViewController.m
//  Mapstudy
//
//  Created by chenq@kensence.com on 16/6/24.
//  Copyright © 2016年 chenq@kensence.com. All rights reserved.
//

#import "CoreLocaionViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface CoreLocaionViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
}
@property (weak, nonatomic) IBOutlet UITextField *latitude;
@property (weak, nonatomic) IBOutlet UITextField *Logitude;
@property (weak, nonatomic) IBOutlet UITextField *Address;
@property (weak, nonatomic) IBOutlet UITextField *city;
- (IBAction)location:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *course;
@end

@implementation CoreLocaionViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        CoreLocaionViewController *core = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Core"];
        self = core;
    }

    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = [UIColor whiteColor];
    
    locationManager = [[CLLocationManager alloc]init];

}

- (IBAction)location:(id)sender {
    
    //    定位当前位置
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置最小更新位置
    locationManager.distanceFilter = 50;
    locationManager.delegate = self;
    //监听位置信息
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //获取最后一个定位的数据
    CLLocation *location = [locations lastObject];
    
    //依次获取cllocation中的经度纬度，高度 速度 方向信息
    NSLog(@"%f==%f==%f==%f==%f",location.coordinate.latitude,location.coordinate.longitude,location.altitude,location.speed,location.course);
    
    self.latitude.text = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    self.Logitude.text = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = [placemarks objectAtIndex:0];
            self.Address.text = placeMark.name;
            NSLog(@"%@",placemarks);
            
            //获取城市
            NSString *city = placeMark.locality;
            if (!city) {
                city = placeMark.administrativeArea;
            }
            
            NSLog(@"city==%@",city);
            _city.text = city;
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


//定位失败执行的方法
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败:%@",error);
}


- (void)viewDidDisappear:(BOOL)animated
{
    [locationManager stopUpdatingLocation];
    
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
