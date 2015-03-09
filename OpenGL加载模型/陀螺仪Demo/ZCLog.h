/*
名词解释
 accelerometer 加速度传感器测量一个设备的加速度(加速度是因为重力或用户的 加速运动而产生的)。通过加速度可以获取设备的当前朝向以及当前的移动情况
 gyroscope     陀螺仪测量设备在每一个轴上的旋转速率。
 magnetometer  磁力计提供的数据表示了穿过设备的磁场情况,通常来说这个磁场包 含了地磁场也包含了设备附近的其他磁场。要记住,在测试这个功能的时候要特别小 心,因为设备附近任何其他强磁场都会对磁力计的读数产生影响。
 
原始数据会收到多个力量的影响
 加速计会受到地球重力的影响
 磁力计会受到地球磁场的影响
 
 
 
Core Motion里面提供了一个叫做CMDeviceMotion的类
 主要用来表达数据的
 1、attitude 用来表达手机在当前空间的位置和姿势
 2、gravity 重力信息，不在需要滤波来提取这个信息了
 3、userAcceleration 加速度信息 同样不在需要滤波了
 4、rotaionRate 即时的旋转速率，陀螺仪的输出
 
 
 attitude由下面几种数学表达式定义
 1、一个四元数 (没找到这个数值)
 2、一个变化的rotation矩阵
 3、3个欧拉角 roll pitch yaw
 http://blog.sina.com.cn/s/blog_558042a70100krlg.html
 
 参考帧
  1、CMAttitudeReferenceFrameXArbitraryZVertical:表示这样一个参考帧:z 轴垂直,x
 轴方向任意,简单地说,表示设备处于水平且正面朝上的方向。
  2、CMAttitudeReferenceFrameXArbitraryCorrectedZVertical:This:和前一个值一样,但 是通过磁力计提供更高的精确度。这个选项会增加 CPU 的使用率,而且还要求磁
 力计处于可用且校准的状态。
  3、CMAttitudeReferenceFrameXMagneticNorthZVertical:和前面的值一样,这个参考
 帧的 z 轴是垂直的,但是 x 轴朝向的是“地磁北极”。这个选项要求磁力计处于可 用且校准的状态,也就是为了在应用程序中能够得到读数,可能需要晃动设备一 阵子。
 4、CMAttitudeReferenceFrameXTrueNorthZVertical:这个参考帧和前一个帧一样,但 是 x 轴指向的是“地理北极”而不是“地磁北极”。为了计算两个位置之间的差 异,这个值要求能够访问当前设备的位置。
 

 */

/*
小游戏，重力感应球
 if ([self.motionManager isDeviceMotionAvailable] &&
 ![self.motionManager isDeviceMotionActive])
 {
 [self.motionManager setDeviceMotionUpdateInterval:1.0/50.0];
 [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:
 CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
 toQueue:[NSOperationQueue mainQueue]
 withHandler:
 ^(CMDeviceMotion *motion, NSError *error)
 第5章 Motion攻略
 ￼195
 ￼196
 iOS 6 开发范例代码大全 {
 CGRect labelRect = self.myLabel.frame;
 double scale = 5.0;
 // Calculate movement on the x-axis
 double dx = motion.gravity.x * scale;
 labelRect.origin.x += dx;
 // Don't move outside the view's x bounds
 if (labelRect.origin.x < 0)
 {
 labelRect.origin.x = 0;
 }
 else if (labelRect.origin.x + labelRect.size.width >
 self.view.bounds.size.width)
 {
 labelRect.origin.x =
 self.view.bounds.size.width – labelRect.size.width;
 }
 // Calculate movement on the y-axis
 double dy = motion.gravity.y * scale;
 labelRect.origin.y -= dy;
 // Don't move outside the view's y bounds
 if (labelRect.origin.y < 0)
 {
 labelRect.origin.y = 0;
 }
 else if (labelRect.origin.y + labelRect.size.height >
 self.view.bounds.size.height)
 {
 labelRect.origin.y =
 self.view.bounds.size.height - labelRect.size.height;
 }
 [self.myLabel setFrame:labelRect];
 }];
 } }
 - (void)stopUpdates
 {
 if ([self.motionManager isDeviceMotionAvailable] &&
 [self.motionManager isDeviceMotionActive])
 {
 [self.motionManager stopDeviceMotionUpdates];
 }
 }
 
 //添加加速度
 - (void)startUpdates
 {
 if ([self.motionManager isDeviceMotionAvailable] &&
 ![self.motionManager isDeviceMotionActive])
 {
 __block double accumulatedDx = 0;
 __block double accumulatedDy = 0;
 [self.motionManager setDeviceMotionUpdateInterval:1.0/50.0]; [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:
 CMAttitudeReferenceFrameXArbitraryCorrectedZVertical
 toQueue:[NSOperationQueue mainQueue]
 withHandler:
 ^(CMDeviceMotion *motion, NSError *error)
 {
 CGRect labelRect = self.myLabel.frame; double scale = 1.5;
 double dx = motion.gravity.x * scale;
 accumulatedDx += dx; labelRect.origin.x += accumulatedDx;
 if (labelRect.origin.x < 0)
 {
 labelRect.origin.x = 0;
 accumulatedDx = 0;
 }
 else if (labelRect.origin.x + labelRect.size.width >
 self.view.bounds.size.width)
 {
 labelRect.origin.x =
 self.view.bounds.size.width - labelRect.size.width;
 accumulatedDx = 0;
 }
 double dy = motion.gravity.y * scale; accumulatedDy += dy; labelRect.origin.y -= accumulatedDy;
 if (labelRect.origin.y < 0)
 {
 labelRect.origin.y = 0;
 accumulatedDy = 0;
 197
 ￼198
 iOS 6 开发范例代码大全
 }
 else if (labelRect.origin.y + labelRect.size.height >
 self.view.bounds.size.height)
 {
 labelRect.origin.y = self.view.bounds.size.height -
 labelRect.size.height;
 accumulatedDy = 0;
 }
 [self.myLabel setFrame:labelRect];
 }];
 } }
 
 
 */


