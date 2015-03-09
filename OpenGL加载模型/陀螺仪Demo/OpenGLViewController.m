//
//  OpenGLViewController.m
//  陀螺仪Demo
//
//  Created by 张诚 on 14-11-20.
//  Copyright (c) 2014年 zhangcheng. All rights reserved.
//

#import "OpenGLViewController.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "AGLKContext.h"
#import "xx.h"
#import "ZCMotionManager.h"
/*
 iOS研究院 305044955
 本工程是加载3D模型使用，需要改的地方有几个
 1、需要从3DMax中导出obj的模型，之后转换为.h文件，需要在windows本上完成这个操作，之后你会有一个。h文件，这个文件非常大，里面记录4个数据，分别是顶点坐标，法线、纹理，以及还有记录一共多少数据
 2、把这个。h文件加入到工程内，如果电脑不好，你电脑在之后，会写代码完全没提示
 3、替换几个地方  替换xxVierts、xxNormals、xxTexCoords 、xxNumVerts  这4个数据是你导入的。h文件获得的
 //加载顶点坐标
 self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc]
 initWithAttribStride:(3 * sizeof(GLfloat))
 numberOfVertices:sizeof(xxVerts) /
 (3 * sizeof(GLfloat))
 bytes:xxVerts
 usage:GL_STATIC_DRAW];
 //加载法线
 self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc]
 initWithAttribStride:(3 * sizeof(GLfloat))
 numberOfVertices:sizeof(xxNormals) /
 (3 * sizeof(GLfloat))
 bytes:xxNormals
 usage:GL_STATIC_DRAW];
 //加载纹理
 self.vertexTexCoordsBuffer=[[AGLKVertexAttribArrayBuffer alloc]
 initWithAttribStride:(3 * sizeof(GLfloat))
 numberOfVertices:sizeof(xxTexCoords) /
 (3 * sizeof(GLfloat))
 bytes:xxTexCoords
 usage:GL_STATIC_DRAW];
 
 [AGLKVertexAttribArrayBuffer
 drawPreparedArraysWithMode:GL_TRIANGLES
 startVertexIndex:0
 numberOfVertices:xxNumVerts];


 
 */


static GLKMatrix4 SceneMatrixForTransform(
                                          SceneTransformationSelector type,
                                          SceneTransformationAxisSelector axis,
                                          float value);
@interface OpenGLViewController ()
{
    ZCMotionManager*manager;
}
@end

@implementation OpenGLViewController

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
    //声明
    GLKView *view = (GLKView *)self.view;

    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    view.context = [[AGLKContext alloc]
                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    
    // Configure a light to simulate the Sun
    self.baseEffect.light0.enabled = GL_TRUE;
    //可以移动的模型本身的颜色
    self.baseEffect.light0.ambientColor = GLKVector4Make(
                                                         0.8f, // Red
                                                         0.4f, // Green
                                                         0.4f, // Blue
                                                         1.0f);// Alpha
    
    //阴影颜色
    self.baseEffect.light0.position = GLKVector4Make(
                                                     1.0f, 
                                                     0.8f, 
                                                     0.4f,  
                                                     0.0f);
    
    //设置背景颜色
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(
                                                              0.0f, // Red
                                                              0.5f, // Green
                                                              0.0f, // Blue
                                                              1.0f);// Alpha
    
//加载顶点坐标
    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                                 initWithAttribStride:(3 * sizeof(GLfloat))
                                 numberOfVertices:sizeof(xxVerts) /
                                 (3 * sizeof(GLfloat))
                                 bytes:xxVerts
                                 usage:GL_STATIC_DRAW];
//加载法线
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                               initWithAttribStride:(3 * sizeof(GLfloat))
                               numberOfVertices:sizeof(xxNormals) /
                               (3 * sizeof(GLfloat))
                               bytes:xxNormals
                               usage:GL_STATIC_DRAW];
//加载纹理
    self.vertexTexCoordsBuffer=[[AGLKVertexAttribArrayBuffer alloc]
                                initWithAttribStride:(3 * sizeof(GLfloat))
                                numberOfVertices:sizeof(xxTexCoords) /
                                (3 * sizeof(GLfloat))
                                bytes:xxTexCoords
                                usage:GL_STATIC_DRAW];
    
    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
    
    GLKMatrix4 modelviewMatrix = GLKMatrix4MakeRotation(
                                                        GLKMathDegreesToRadians(30.0f),
                                                        1.0,  // Rotate about X axis
                                                        0.0, 
                                                        0.0);
    modelviewMatrix = GLKMatrix4Rotate(
                                       modelviewMatrix,
                                       GLKMathDegreesToRadians(-30.0f),
                                       0.0,  
                                       1.0,  // Rotate about Y axis
                                       0.0);
    modelviewMatrix = GLKMatrix4Translate(
                                          modelviewMatrix,
                                          -0.25, 
                                          0.0, 
                                          -0.20);
    
    self.baseEffect.transform.modelviewMatrix = modelviewMatrix;
    
    [((AGLKContext *)view.context) enable:GL_BLEND];
    [((AGLKContext *)view.context)
     setBlendSourceFunction:GL_SRC_ALPHA
     destinationFunction:GL_ONE_MINUS_SRC_ALPHA];

    
    /*********************/
    //设置转换模式R 按照中心点进行旋转
    transform1Type=0;
    transform2Type=1;
    transform3Type=2;
    //设置xyz
    transform1Axis=0;
    transform2Axis=1;
    transform3Axis=2;
    
    
    manager=[ZCMotionManager shareManager];
    [manager starUpdatesBlock:^(CMDeviceMotion *motion) {
        
        transform1Value=motion.attitude.pitch;
        transform2Value=motion.attitude.yaw;
        transform3Value=motion.attitude.roll;
        
    }];
    /*********************/
    //添加捏合手势，模型的放大和缩小
    UIPinchGestureRecognizer*pinch=[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchClick:)];
    [self.view addGestureRecognizer:pinch];
    /*对于移动3D模型x为左右移动  y为上下移动  */
    //添加移动手势，控制模型的移动
    
    UIPanGestureRecognizer*pan=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panClick:)];
    [self.view addGestureRecognizer:pan];
    
}

-(void)panClick:(UIPanGestureRecognizer*)pan{
//记录上一个点 然后下一个点之间的x轴和y轴
    if (pan.state==UIGestureRecognizerStateBegan) {
        panPoint=[pan locationInView:pan.view];
        return;
    }else{
        CGPoint location = [pan locationInView:pan.view];
        //计算x和y的偏差
        float x=location.x-panPoint.x;
        float y=panPoint.y-location.y;
        panPoint=location;
        panX=x/100.0+panX;
        panY=y/100.0+panY;
        
        
        NSLog(@"%f~~%f",panX,panY);
    
    }
    
    
  
}
-(void)pinchClick:(UIPinchGestureRecognizer*)pinch{
    
    //放大范围控制在-0.05~2之间
    float x=transformScale+(pinch.scale-1);
    if (x<-0.5) {
        transformScale=-0.5;
    }else{
        if (x>2.0) {
            x=2;
        }
        transformScale=x;
        
    }
}
//这里开始绘制模型,该方法会一直调用
-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    const GLfloat  aspectRatio =
    (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;
    
    //旋转角度
    self.baseEffect.transform.projectionMatrix =
    GLKMatrix4MakeOrtho(
                        -0.5 * aspectRatio,
                        0.5 * aspectRatio,
                        -0.5,
                        0.5,
                        -5.0,
                        5.0);
    
    // Clear back frame buffer (erase previous drawing)
    [((AGLKContext *)view.context)
     clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];
    
  

    [self.vertexPositionBuffer
     prepareToDrawWithAttrib:GLKVertexAttribPosition
     numberOfCoordinates:3
     attribOffset:0
     shouldEnable:YES];
    [self.vertexNormalBuffer
     prepareToDrawWithAttrib:GLKVertexAttribNormal
     numberOfCoordinates:3
     attribOffset:0
     shouldEnable:YES];
    [self.vertexTexCoordsBuffer
     prepareToDrawWithAttrib:GLKVertexAttribTexCoord1
     numberOfCoordinates:3
     attribOffset:0
     shouldEnable:YES];

    //读取之前的默认位置
    GLKMatrix4 savedModelviewMatrix =
    self.baseEffect.transform.modelviewMatrix;
    
    
    
    //设置空间位置移动 SceneMatrixForTransform代表空间位置  1Axis代表x  2Axis代表y 3Axis代表z
    /*********************************/
    //修改按照中心点进行旋转的,也就是依照陀螺仪进行旋转
    GLKMatrix4 newModelviewMatrix =
    GLKMatrix4Multiply(savedModelviewMatrix,
                       SceneMatrixForTransform(
                                               transform2Type,
                                               transform1Axis,
                                               transform1Value));
    newModelviewMatrix =
    GLKMatrix4Multiply(newModelviewMatrix,
                       SceneMatrixForTransform(
                                               transform2Type,
                                               transform2Axis,
                                               transform2Value));
    newModelviewMatrix =
    GLKMatrix4Multiply(newModelviewMatrix,
                       SceneMatrixForTransform(
                                               transform2Type,
                                               transform3Axis,
                                               transform3Value));
    
    //修改模型放大和缩小
    newModelviewMatrix =
GLKMatrix4Multiply(newModelviewMatrix,
                       SceneMatrixForTransform(
                                               transform3Type,
                                               transform1Axis,
                                               transformScale));
    newModelviewMatrix =
    GLKMatrix4Multiply(newModelviewMatrix,
                       SceneMatrixForTransform(
                                               transform3Type,
                                               transform2Axis,
                                               transformScale));
    newModelviewMatrix =
    GLKMatrix4Multiply(newModelviewMatrix,
                       SceneMatrixForTransform(
                                               transform3Type,
                                               transform3Axis,
                                               transformScale));
    
    //修改模型移动的位置
    newModelviewMatrix =
    GLKMatrix4Multiply(newModelviewMatrix,
                       SceneMatrixForTransform(
                                               transform1Type,
                                               transform1Axis,
                                               panX));
    newModelviewMatrix =
    GLKMatrix4Multiply(newModelviewMatrix,
                       SceneMatrixForTransform(
                                               transform1Type,
                                               transform2Axis,
                                               panY));
//    newModelviewMatrix =
//    GLKMatrix4Multiply(newModelviewMatrix,
//                       SceneMatrixForTransform(
//                                               transform1Type,
//                                               transform3Axis,
//                                               transformScale));
    
    
    
    
    // Set the Modelview matrix for drawing
    self.baseEffect.transform.modelviewMatrix = newModelviewMatrix;
    
    //设置模型颜色
//    self.baseEffect.light0.diffuseColor = GLKVector4Make(
//                                                         0.8f, // Red
//                                                         0.4f, // Green
//                                                         1.0f, // Blue
//                                                         1.0f);// Alpha

    
    [self.baseEffect prepareToDraw];
    
    // Draw triangles using vertices in the prepared vertex
    // buffers
    [AGLKVertexAttribArrayBuffer
     drawPreparedArraysWithMode:GL_TRIANGLES
     startVertexIndex:0
     numberOfVertices:xxNumVerts];
    
    // Restore the saved Modelview matrix
    self.baseEffect.transform.modelviewMatrix = 
    savedModelviewMatrix;
    

    //prepareToDraw会在重复绘制一个新的Draw
    //[self.baseEffect prepareToDraw];
//   [AGLKVertexAttribArrayBuffer
//     drawPreparedArraysWithMode:GL_TRIANGLES
//     startVertexIndex:0
//     numberOfVertices:xxNumVerts];
}
static GLKMatrix4 SceneMatrixForTransform(
                                          SceneTransformationSelector type,
                                          SceneTransformationAxisSelector axis,
                                          float value)
{
    GLKMatrix4 result = GLKMatrix4Identity;
    
    switch (type) {
        case SceneRotate:
            switch (axis) {
                case SceneXAxis:
                    result = GLKMatrix4MakeRotation(
                                                    GLKMathDegreesToRadians(180.0 * value),
                                                    1.0,
                                                    0.0,
                                                    0.0);
                    break;
                case SceneYAxis:
                    result = GLKMatrix4MakeRotation(
                                                    GLKMathDegreesToRadians(180.0 * value),
                                                    0.0,
                                                    1.0,
                                                    0.0);
                    break;
                case SceneZAxis:
                default:
                    result = GLKMatrix4MakeRotation(
                                                    GLKMathDegreesToRadians(180.0 * value),
                                                    0.0,
                                                    0.0,
                                                    1.0);
                    break;
            }
            break;
        case SceneScale:
            switch (axis) {
                case SceneXAxis:
                    result = GLKMatrix4MakeScale(
                                                 1.0 + value,
                                                 1.0,
                                                 1.0);
                    break;
                case SceneYAxis:
                    result = GLKMatrix4MakeScale(
                                                 1.0,
                                                 1.0 + value,
                                                 1.0);
                    break;
                case SceneZAxis:
                default:
                    result = GLKMatrix4MakeScale(
                                                 1.0, 
                                                 1.0, 
                                                 1.0 + value);
                    break;
            }
            break;
        default:
            switch (axis) {
                case SceneXAxis:
                    result = GLKMatrix4MakeTranslation(
                                                       0.3 * value, 
                                                       0.0, 
                                                       0.0);
                    break;
                case SceneYAxis:
                    result = GLKMatrix4MakeTranslation(
                                                       0.0, 
                                                       0.3 * value, 
                                                       0.0);
                    break;
                case SceneZAxis:
                default:
                    result = GLKMatrix4MakeTranslation(
                                                       0.0, 
                                                       0.0, 
                                                       0.3 * value);
                    break;
            }
            break;
    }
    
    return result;
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
