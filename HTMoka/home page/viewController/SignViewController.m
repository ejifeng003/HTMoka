//
//  SignViewController.m
//  HTMoka
//
//  Created by SZHuaTo on 2017/11/29.
//  Copyright © 2017年 深圳华图测控. All rights reserved.
//


#import "SignViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ProjectSearchModel.h"

@interface SignViewController()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    NSString *addressStr;//当前的地址
}
@property (weak, nonatomic) IBOutlet UIButton *signBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//地址
@property (weak, nonatomic) IBOutlet UILabel *timeOne;
@property (weak, nonatomic) IBOutlet UILabel *timeTwoLabel;//设置当前的时间
@property (weak, nonatomic) IBOutlet UILabel *projectTitleLabel;//项目名称
@property (weak, nonatomic) IBOutlet UITextField *RemarkTextField;//备注
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;//星期
@property (nonatomic,copy) NSString *CurrentTime;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"签到";
    NSLog(@"签到的宽度对比率是%f",W_UNIT);
    
//    if (W_UNIT>1) {
//        // 当时ipad的时候
//        self.signBtn.frame = CGRectMake(self.signBtn.frame.origin.x, self.signBtn.frame.origin.y, 100, 100);
//        [self.view addSubview:self.signBtn];
//    }else{
//        //当时iphone的时候
//        self.signBtn.frame = CGRectMake(self.signBtn.frame.origin.x, self.signBtn.frame.origin.y, self.signBtn.frame.size.width*W_UNIT, self.signBtn.frame.size.height*W_UNIT);
//        [self.view addSubview:self.signBtn];
//    }
    _signBtn.layer.cornerRadius = _signBtn.frame.size.height/2;
    _signBtn.layer.borderWidth = 1;
    _signBtn.layer.borderColor = [UIColor whiteColor].CGColor;

    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    _CurrentTime = [formatter stringFromDate:[NSDate date]];

    self.timeOne.text = _CurrentTime;
     NSDate *senddate=[NSDate date];
     self.weekLabel.text = [self getWeekDayFordate:senddate];
    self.projectTitleLabel.text = [NSString stringWithFormat:@"当前项目:%@", self.probjectName];
    [self initWithMapView];
    [self initWithlocation];
    
}
-(void)initWithMapView{
    _mapView.showsUserLocation = YES;//设置定位功能
    self.mapView.showsUserLocation = YES;//显示用户的坐标
    self.mapView.delegate = self;//
}
-(void)initWithlocation
{
    //0、 判断用户是否在设置里面打开了定位服务功能
    if ( ![CLLocationManager locationServicesEnabled]) {
        //1.跳出弹出框 提示用户打开步骤
        //2.通过代码调到设置页面
#pragma mark ------1跳出弹出框 提示用户打开步骤

                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请在设置中打开定位服务功能" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"👌" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                }];
                [alert addAction:action1];
        
#pragma mark ----------2通过代码跳到设置页面
        //openURL:用于跳转APP 跳到IOS允许跳到的界面
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]]) {
            //跳转到设置界面
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }

        return;
    }
    _locationManager = [[CLLocationManager alloc]init];
                                          
                                          //设置多少米去更新一次位置信息
                                          _locationManager.distanceFilter = 100;
                                          //设置定位的精准度
                                          _locationManager.desiredAccuracy =
                                          kCLLocationAccuracyBest;
                                          //2.info中添加描述使用定位的目的 并向用户申请授权
                                          [_locationManager requestWhenInUseAuthorization];
                                            [_locationManager requestAlwaysAuthorization];
                                          //3、挂上代理 并实现代理方法
                                          _locationManager.delegate = self;
                                          //4.如果需要使用后台定位服务的功能 需要在info.plist文件里面添加:Required background modes -> App registers for location updates
                                         // _locationManager.allowsBackgroundLocationUpdates = YES;
                                          //5.开始定位
                                          [_locationManager startUpdatingLocation];
    
}
-(void)initWIthNetWork
{
    //[SPSVProgressHUD showWithStatus:@"提交中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setJsonValue:LLBUserInfo.probjectID key:@"ProjectCode"];
    [params setJsonValue:LLBUserInfo.userName key:@"LoginName"];
    [params setJsonValue:_CurrentTime key:@"SigningInDate"];//
    [params setJsonValue:addressStr key:@"SigningInAddres"];
    [params setJsonValue:_RemarkTextField.text key:@"Remark"];
    
    [[NetworkManager sharedNetworkManager] requestSignSubmit:params success:^(id result){
        [SPSVProgressHUD dismiss];
        
        [SPSVProgressHUD showSuccessWithStatus:@"提交成功"];
    } fail:^(NSString *errorMsg) {
        [SPSVProgressHUD dismiss];
        
        [SPSVProgressHUD showErrorWithStatus:errorMsg];
        
    }];
}
- (IBAction)SubmitClick:(id)sender {
    //签到点击事件
    [self initWIthNetWork];
}

- (NSString *)getWeekDayFordate:(NSDate*)date
{
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    //NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:data];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSWeekdayCalendarUnit fromDate:date];
    
    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
}

#pragma -mark -定位代理事件

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)location {
    NSLog(@"定位成功");
    CLLocation* locations = location.lastObject;
    
    [self reverseGeocoder:locations];
      [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位失败");
    [_locationManager stopUpdatingLocation];//关闭定位
}
#pragma mark Geocoder
//反地理编码
- (void)reverseGeocoder:(CLLocation *)currentLocation {
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if(error || placemarks.count == 0){
            NSLog(@"error = %@",error);
        }else{
            
            CLPlacemark* placemark = placemarks.firstObject;
            
            NSString *state=[[placemark addressDictionary] objectForKey:@"State"];
            NSString *city=[[placemark addressDictionary] objectForKey:@"City"];
            NSString *subLocality=[[placemark addressDictionary] objectForKey:@"SubLocality"];
            NSString *street=[[placemark addressDictionary] objectForKey:@"Street"];
            MyLog(@"state is %@ city is %@ sub is %@ street is %@",state,city,subLocality,street);
            addressStr =  [NSString stringWithFormat:@"%@%@%@",city,subLocality,street];
            self.addressLabel.text = [NSString stringWithFormat:@"当前位置:%@",addressStr];
            
        }
        
    }];
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    MKCoordinateSpan span = {0.001,0.001};
    MKCoordinateRegion region = {coordinate,span};
    //设置显示区域
    [self.mapView setRegion:region animated:YES];
    
//    MyAnnotation *annotation = [[MyAnnotation alloc]init];
//    annotation.coordinate = coordinate;
//    annotation.title = @"中国";
//    annotation.subtitle = @"好牛B的地方";
//    //让地图显示标注的区域
//    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

@end
