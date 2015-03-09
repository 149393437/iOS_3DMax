//
//  ZCMotionManager.m
//  陀螺仪Demo
//
//  Created by 张诚 on 14-11-20.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "ZCMotionManager.h"

@implementation ZCMotionManager
static ZCMotionManager*_manager=nil;
+(instancetype)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager=[[ZCMotionManager alloc]init];
       
        
    });
    return _manager;
}
-(instancetype)init{

    if (self=[super init]) {
        motionManager=[[CMMotionManager alloc]init];
    }
    return self;
}
-(void)starUpdatesBlock:(void(^)(CMDeviceMotion *))a;
{
    
    NSLog(@"开始设置");
    self.MotionData=a;
    //    /*
    //     10 ms (1/100)  检测高频率移动
    //     20 ms (1/50)   适合于使用实时用户输入的游戏
    //     100 ms (1/10)  适合于确定当前的设备方向
    //    */
    //    //以下为获取传感器原始数据
    //
    //
    //#pragma mark  读取加速计
    //    //开始读取加速计，按照1/60的速率进行回调
    //    if ([motionManager isAccelerometerAvailable]) {
    //        //判定可用的情况下调用
    //        //设定加速计更新频率
    //        motionManager.accelerometerUpdateInterval=1.0/60.0;
    //        [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
    //           // NSLog(@"加速计：   x~~%f y~~%f  z~~%f",accelerometerData.acceleration.x,accelerometerData.acceleration.y,accelerometerData.acceleration.z);
    //        }];
    //
    //    }
    //    //获取四元数和欧拉角的一个属性
    //    //motionManager.deviceMotion.attitude;
    //
    //
    //#pragma mark 读取陀螺仪
    //
    //    if ([motionManager isGyroAvailable]) {
    //        //判定可用的情况下进行调用
    //        [motionManager setGyroUpdateInterval:1.0/2.0];
    //        [motionManager startGyroUpdatesToQueue:
    //         [NSOperationQueue mainQueue]
    //                              withHandler:
    //         ^(CMGyroData *data, NSError *error)
    //         {
    //             //x->Pitch y->Roll z->Yaw 也叫做欧拉角
    //            // NSLog(@"陀螺仪：  %lf~~%lf~~%lf",data.rotationRate.x,data.rotationRate.y,data.rotationRate.z);
    //
    //
    //         }];
    //    }
    //#pragma mark 读取磁力计
    //    if ([motionManager isMagnetometerAvailable]) {
    //        [motionManager setMagnetometerUpdateInterval:1.0/2.0];
    //        [motionManager
    //         startMagnetometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMagnetometerData *data,NSError *error)
    //         {
    //            // NSLog(@"磁力计：  %lf~~%lf~~%lf",data.magneticField.x,data.magneticField.y,data.magneticField.z);
    //
    //         }];
    //    }
    //以上是加速计陀螺仪磁力计的原始数据，但是和我们实际的差异有很大，因为会受到多个力量的影响，需要使用高低过滤器来进行处理CoreMotion很好的处理了这些问题
    
    //motionManager.deviceMotion来自于移动管理器的数据，可以获得apple帮你处理好的各种数据，这些数据都是去除干扰了
#pragma mark 读取修正过的参数
    if ([motionManager isDeviceMotionAvailable]) {
        [motionManager setDeviceMotionUpdateInterval:1.0/100.0];
        //另外的方法可以设置参考帧，就是相对当前的
        [motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            //motion提供去除干扰的各种传感器真实数据
            /*
             (1) attitude 属性是 CMAttitude 类的实例,通过这个属性可以获得设备在给定时间相对 参考帧非常详细的朝向信息。在这个类中可以访问 roll、pitch 和 yaw 这些属性。这些值的 单位都是弧度,通过这些值可以非常准确地判定设备的朝向。
             (2) rotationRate 旋转速率这个值的单位为弧度每秒(也叫做欧拉角),但是这个值能够减少设备的偏差(偏差会导致精致的设备得到非零的旋转值),从而提供更准确的读数。
             (3) gravity 属性表示完全由对设备施加的重力而产生的加速度。
             (4) userAcceleration 表示用户对设备产生的物理加速度,其中排除了因重力产生的加 速度。
             (5) magneticField 这个值移除了所有的设备偏差, 因此这个值比之前读到的值精确得多
             */
            if (self.MotionData) {
                self.MotionData(motion);
            }
            
        }];
        
    }
    
    
}

#pragma mark 停止更新传感器
-(void)stopUpdates
{
//    if ([motion isAccelerometerAvailable] &&
//        [motion isAccelerometerActive])
//    {
//        [motion stopAccelerometerUpdates];
//    }
//    if ([motion isGyroAvailable] &&
//        [motion isGyroActive])
//    {
//        [motion stopGyroUpdates];
//    }
//    if ([motion isMagnetometerAvailable] &&
//        [motion isMagnetometerActive])
//    {
//        [motion stopMagnetometerUpdates];
//    }
    /********/
    if ([motionManager isDeviceMotionAvailable] &&
        [motionManager isDeviceMotionActive])
    {
        [motionManager stopDeviceMotionUpdates];
        self.MotionData=nil;
    }
    
    
}

@end
