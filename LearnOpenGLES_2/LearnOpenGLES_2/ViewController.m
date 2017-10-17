//
//  ViewController.m
//  LearnOpenGLES_2
//
//  Created by haogaoming on 2017/10/17.
//  Copyright © 2017年 郝高明. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"

typedef struct {
    GLKVector3 positionCoords;  //保存3个坐标：x,y,z
    GLKVector2 textureCoords;   //纹理操作
}SceneVertex;

//初始化C数组，vertices变量用来定义一个三角形
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}, {0.0f, 0.0f}}, // x,y,x坐标, 纹理坐标
    {{ 0.5f, -0.5f, 0.0}, {1.0f, 0.0f}}, // x,y,x坐标, 纹理坐标
    {{-0.5f,  0.5f, 0.0}, {0.0f, 1.0f}}  // x,y,x坐标, 纹理坐标
};

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    //声明一个上下文,kEAGLRenderingAPIOpenGLES2:默认优先使用2.0版
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    //是否使用恒定不变的颜色渲染三角形
    self.baseEffect.useConstantColor = GL_TRUE;
    //颜色使用：GLKVector4Make(red, green, bluee, 透明值)
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    //清除颜色，用于在上下文的帧缓存被清除时初始化每个像素的颜色
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithAttribStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices) / sizeof(SceneVertex) bytes:vertices usage:GL_STATIC_DRAW];
    
    CGImageRef imageRef = [UIImage imageNamed:@"leaves.gif"].CGImage;
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:nil error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    //准备好绘图
    [self.baseEffect prepareToDraw];
    
    //设置当前绑定的帧缓存使用前边glclearcolor()函数设定的值
    glClear(GL_COLOR_BUFFER_BIT);
    
    //step4:启动顶点缓存渲染操作
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    //step5:寻找、解释顶点数据（第一次参数：当前缓存包含顶点的位置信息，第二参数：每个位置有三个部分，第三参数：每个部分都保存为一个浮点类型值，第四参数：第四参数：小数点固定位置是否可以改变，第五参数：叫做步幅，指定了每个顶点的保存需要多少字节，第六参数：从顶点缓存的开始位置访问顶点数据）
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(SceneVertex), NULL);
    
    //step6:执行绘图（第一参数：告诉GPU如何处理顶点数据，渲染三角形，第二参数：缓存内需要渲染的第一个顶点的位置，第三参数：需要渲染的顶点的数量）
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

-(void)dealloc
{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if (vertexBufferID != 0) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
