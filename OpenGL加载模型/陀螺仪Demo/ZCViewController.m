//
//  ZCViewController.m
//  陀螺仪Demo
//
//  Created by 张诚 on 14-11-5.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "ZCViewController.h"
#import "OpenGLViewController.h"
@interface ZCViewController ()
{

}
@end

@implementation ZCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    label.text=@"2秒后开始开始";
    label.center=self.view.center;
    [self.view addSubview:label];
    [self performSelector:@selector(startClick) withObject:nil afterDelay:2];
    
}
-(void)startClick{

    OpenGLViewController*vc=[[OpenGLViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
