
//
//  OldViewController.m
//  陀螺仪Demo
//
//  Created by 张诚 on 14-11-5.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "OldViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface OldViewController ()<UIAccelerometerDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
    //设置小球
    UIImageView*_ball;
    CGPoint _ballVelocity;
    //加速计
    UIAccelerometer *acc;

}
@end

@implementation OldViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //苹果建议在iOS5以后不要在使用UIAccelerometer，需要使用CoreMotion做替代
    _ball=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    _ball.backgroundColor=[UIColor redColor];
    [self.view addSubview:_ball];
    _ballVelocity=CGPointZero;
    
    //加速计的单例
    acc = [UIAccelerometer sharedAccelerometer];
    acc.delegate = self;
    //更新频率
    acc.updateInterval = 1.0/60.0;
    
    
    /*
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 100.0f;
    locationManager.headingFilter = 0.1;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
*/
    // Do any additional setup after loading the view.
}
-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    NSLog(@"%f~~%f~~%f",acceleration.x,acceleration.y,acceleration.z);
    _ballVelocity.x+=acceleration.x;
    _ballVelocity.y-=acceleration.y;
    [self updateLocation];
    
}
-(void)updateLocation{
    //设置小球的位置
    CGPoint center=_ball.center;
    CGSize size=self.view.bounds.size;
    //解决小球出界的问题，碰撞检测
    //水平方向左边右边
    if (CGRectGetMidX(_ball.frame)<=0||CGRectGetMidX(_ball.frame)>=size.width) {
        //修改小球的速度方向
        _ballVelocity.x *=-1;
        //修复位置<0
        if (CGRectGetMidX(_ball.frame)<=0) {
            center.x=_ball.bounds.size.width/2.0;
        }else{
            center.x=size.width-_ball.bounds.size.width/2.0;
        }
        
    }
    //垂直方面
    if (CGRectGetMidY(_ball.frame)<=0||CGRectGetMidY(_ball.frame)>=size.height) {
        //修改小球速度方向
        _ballVelocity.y *=-1;
    }
    if (CGRectGetMidY(_ball.frame)<=0) {
        center.y=_ball.bounds.size.height/2.0;
    }else{
        center.y=size.height-_ball.bounds.size.height/2.0;
    }
    center.x+=_ballVelocity.x;
    center.y+=_ballVelocity.y;
    _ball.center=center;
}
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if(newHeading.headingAccuracy > 0)
    {
        NSLog(@"didUpdateHeading%f",newHeading.magneticHeading);

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
