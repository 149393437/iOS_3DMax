//
//  ZCMotionManager.h
//  陀螺仪Demo
//
//  Created by 张诚 on 14-11-20.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
@interface ZCMotionManager : NSObject
{
    CMMotionManager*motionManager;

}
@property(nonatomic,copy)void(^MotionData)(CMDeviceMotion *);
//传感器初始化
+(instancetype)shareManager;
//传感器开始
-(void)starUpdatesBlock:(void(^)(CMDeviceMotion *))a;
//传感器结束
-(void)stopUpdates;
@end
