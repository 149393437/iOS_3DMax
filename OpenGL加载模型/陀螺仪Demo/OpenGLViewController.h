//
//  OpenGLViewController.h
//  陀螺仪Demo
//
//  Created by 张诚 on 14-11-20.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import <GLKit/GLKit.h>
@class AGLKVertexAttribArrayBuffer;
typedef enum
{
	SceneTranslate = 0,
	SceneRotate,
	SceneScale,
} SceneTransformationSelector;

typedef enum
{
	SceneXAxis = 0,
	SceneYAxis,
	SceneZAxis,
} SceneTransformationAxisSelector;
@interface OpenGLViewController : GLKViewController
{
    SceneTransformationSelector      transform1Type;
    SceneTransformationAxisSelector  transform1Axis;
    float                            transform1Value;
    SceneTransformationSelector      transform2Type;
    SceneTransformationAxisSelector  transform2Axis;
    float                            transform2Value;
    SceneTransformationSelector      transform3Type;
    SceneTransformationAxisSelector  transform3Axis;
    float                            transform3Value;
    
    //放大的倍率
    float                            transformScale;
    //记录上一个中心点的坐标
    CGPoint                          panPoint;
    float                            panX;
    float                            panY;
    
}
@property (strong, nonatomic) GLKBaseEffect
*baseEffect;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
*vertexPositionBuffer;
@property (strong, nonatomic) AGLKVertexAttribArrayBuffer
*vertexNormalBuffer;
@property (strong,nonatomic)  AGLKVertexAttribArrayBuffer
*vertexTexCoordsBuffer;
@end
