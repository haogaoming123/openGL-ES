//
//  ViewController.m
//  LearnOpenGLES_1
//
//  Created by haogaoming on 2017/10/16.
//  Copyright © 2017年 郝高明. All rights reserved.
//

#import "ViewController.h"

typedef struct {
    GLKVector3 positionCoords;  //保存3个坐标：x,y,z
}SceneVertex;

//初始化C数组，vertices变量用来定义一个三角形
static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0}}, // x,y,x坐标
    {{ 0.5f, -0.5f, 0.0}}, // x,y,x坐标
    {{-0.5f,  0.5f, 0.0}}  // x,y,x坐标
};

@interface ViewController ()

@end

@implementation ViewController
@synthesize baseEffect;

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
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    //step1:为缓存生成一个唯一标识符(第一个参数为：生成的缓存标识符的数量)
    glGenBuffers(1, &vertexBufferID);
    //step2:为接下来的运算绑定缓存（第一参数为：指定要绑定的缓存类型，第二个参数：要绑定的缓存标识符）
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    //step3:复制数据到缓存中（第一参数：缓存类型，第二参数：缓存的字节数量，第三参数：复制字节的地址，第四参数：提示缓存在未来的计算中可能将会被怎样使用）
    //GL_STATIC_DRAW:告诉上下文，缓存内的数据不会频繁更改；GL_DYNAMIC_DRAW：缓存内的数据会频繁的更改
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
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
