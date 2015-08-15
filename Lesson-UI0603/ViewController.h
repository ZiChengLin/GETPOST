//
//  ViewController.h
//  Lesson-UI0603
//
//  Created by lin on 15/6/3.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIImageView *imageView;

@property (retain, nonatomic) IBOutlet UIProgressView *progressView;

@end



/*
    异步请求的协议方式总结
   
   常用的代理方法:
   1.收到响应时执行的方法（两点操作；1、对接收数据到可变data进行初始化 2、得到请求数据的总长度 用来制作进度条。）
   2.正在接收时执行的方法（1、对接收数据到拼接 2、在这里可以使用数据 3、设置进度条 4、活动指示器、刷新俗称小菊花）
   3.接收完成时执行的方法（1、对完整数据的使用 2、活动指示器的停止 3、将最终的数据传递给其他类使用）
   4.接收出错时执行的方法（开发当中必须实现的方法。通常是弹出警告框 提示用户未联网或者出错）
 */
