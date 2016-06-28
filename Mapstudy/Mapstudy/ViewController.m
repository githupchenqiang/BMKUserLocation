//
//  ViewController.m
//  Mapstudy
//
//  Created by chenq@kensence.com on 16/6/23.
//  Copyright © 2016年 chenq@kensence.com. All rights reserved.
//

#import "ViewController.h"
#import "CoreLocaionViewController.h"
#import "BMKMapViewController.h"


@interface ViewController ()<BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate>
{
//    BMKLocationService *locSeverice;
    
    UITableView *_tableView;
     BMKMapManager *_mapManager;
}
@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    _mapManager  = [[BMKMapManager alloc]init];
    BOOL ret = [_mapManager start:@"0efUBN0fkp3DhAkVdcOH9anqGUAbbMnk"  generalDelegate:nil];
    if (!ret) {
        
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.view =_tableView;

//    BMKMapView *mapview = [[BMKMapView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    self.view = mapview;
//    
//    locSeverice = [[BMKLocationService alloc]init];
//    locSeverice.delegate = self;
//    [locSeverice startUserLocationService];
  
}

//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    NSLog(@"%@",userLocation.heading);
//}
//
////处理位置坐标更新
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//   NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//  
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if (section == 1)
    {
        return 2;
    }else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
//    if (indexPath.section == 0) {
//        cell.textLabel.text = @"百度地图";
//    }else if (indexPath.section == 1)
//    {
//        cell.textLabel.text = @"Corelocation";
//    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                      cell.textLabel.text = @"百度地图";
                    break;
                    
                default:
                    break;
            }
            break;
            
            case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"定位当前位置";
                    break;
                    
                    case 1:
                    cell.textLabel.text = @"位置搜索";
                    break;
                default:
                    break;
            }
            break;
            case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"路线规划";
                    break;
                    case 1:
                    cell.textLabel.text = @"附近";
                    break;
                    case 2:
                    cell.textLabel.text = @"交通";
                    break;
                default:
                    break;
            }
      
        default:
            break;
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BMKMapViewController *bmkMap = [BMKMapViewController new];
    
    CoreLocaionViewController *core = [CoreLocaionViewController new];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    
                    [self.navigationController pushViewController:bmkMap animated:YES];
                    
                    break;
                    
                default:
                    break;
            }
            
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    [self.navigationController pushViewController:core animated:YES];
                    break;
                    
                case 1:
                  
                    break;
                default:
                    break;
            }
        case 2:
            switch (indexPath.row) {
                case 0:
                
                    
                    break;
                case 1:
                  
                    break;
                case 2:
                   
                    break;
                default:
                    break;
            }
            
        default:
            break;
    }

    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
