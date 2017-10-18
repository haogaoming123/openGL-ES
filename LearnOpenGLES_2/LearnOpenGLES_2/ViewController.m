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

@interface ViewController ()

@property (nonatomic,strong) GLKTextureInfo *textureInfo0;
@property (nonatomic,strong) GLKTextureInfo *textureInfo1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]],
             @"View controller's view is not a GLKView");
    
    //声明一个上下文,kEAGLRenderingAPIOpenGLES2:默认优先使用2.0版
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
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
    
    //创建一个新的包含CGImageRef的像素数据的OpenGL ES 纹理缓存
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:@{@(1):GLKTextureLoaderOriginBottomLeft} error:NULL];
    self.textureInfo0 = textureInfo;
    
    CGImageRef imageRef1 = [UIImage imageNamed:@"beetle"].CGImage;
    GLKTextureInfo *textureInfo1 = [GLKTextureLoader textureWithCGImage:imageRef1 options:@{@(1):GLKTextureLoaderOriginBottomLeft} error:NULL];
    self.textureInfo1 = textureInfo1;
    
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    self.baseEffect.texture2d0.name = self.textureInfo0.name;
    self.baseEffect.texture2d0.target = self.textureInfo0.target;
    //准备好绘图
    [self.baseEffect prepareToDraw];
    
    //设置当前绑定的帧缓存使用前边glclearcolor()函数设定的值
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textureCoords) shouldEnable:YES];
    [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertices:6];
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
