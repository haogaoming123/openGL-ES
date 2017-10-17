//
//  ViewController.h
//  LearnOpenGLES_2
//
//  Created by haogaoming on 2017/10/17.
//  Copyright © 2017年 郝高明. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface ViewController : GLKViewController
{
    GLuint vertexBufferID;
}

@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@end

