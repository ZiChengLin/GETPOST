//
//  ViewController.m
//  Lesson-UI0603
//
//  Created by lin on 15/6/3.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "ViewController.h"

#pragma mark -URL都是定义成宏(1.url本身可读性不高，用宏定义可以通过宏的名字让其可读性性变高 2.因为一个URL有可能在一个工程中用到多次)

#define BaseUrl @"http://ia.topit.me/a/01/d7/1192857991bbad701ao.jpg"

#define BASE_URL_2 @"http://ipad-bjwb.bjd.com.cn/DigitalPublication/publish/Handler/APINewsList.ashx"

#define BASE_URL_2_PARAM @"date=20131129&startRecord=1&len=5&udid=1234567890&terminalType=Iphone&cid=213"

@interface ViewController ()<NSURLConnectionDataDelegate>   // 异步POST用到 遵守代理

@property (nonatomic, retain)NSMutableData *receiveData;    // 用来接收每次过来的一点数据
@property (nonatomic, assign)long long length;    // 纪录请求的东西的总长度

@end

@implementation ViewController

-(void)dealloc {
    
    [_receiveData release];
    [_imageView release];
    [_progressView release];
    [super dealloc];
}

#pragma mark - 同步GET方法
- (IBAction)doSynGet:(id)sender {
    
    // 1.封装url对象
    NSURL *url = [NSURL URLWithString:BaseUrl];
    // 2.用url对象封装一个Request请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 3.发送一个同步类型的请求方式 参数:待发送请求对象、服务器的响应、错误信息
    
    NSURLResponse *response = nil;   // 服务器响应对象
    NSError *error = nil;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error]; // 同步卡ui代码
    
    if (!error) {
        UIImage *image = [UIImage imageWithData:data];
        self.imageView.image = image;
    }
}

#pragma mark - 异步GET方法
- (IBAction)doASynGet:(id)sender {
    
    // 如果不设置请求方式,默认就是GET类型
    
    NSURL *url = [NSURL URLWithString:BaseUrl];

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 发送一个异步类型的请求方式 参数:待发送请求对象、创建一个线程用来数据请求、block参数,内部就是子线程
    __block ViewController *v = self;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        // v 即self.用__block修饰防止循环引用
        v.imageView.image = [UIImage imageWithData:data];
        NSLog(@"---%@", response);
    }];
    
    
}

#pragma mark - 同步POST方法
- (IBAction)doSynPost:(id)sender {
    
    // 1.创建url（是一个基础url，并不完整，剩下对参数在请求的body体里面完成）
    NSURL *url = [NSURL URLWithString:BASE_URL_2];
    // 2.创建一个可变的请求对象
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:url];
    // 3.手动的设置为POST请求
    [mRequest setHTTPMethod:@"POST"];
    // 4.将参数设置到body体里面 (因为参数是NSString类型 setHTTPBody需要的是NSData类型 所有要转一下)
    [mRequest setHTTPBody:[BASE_URL_2_PARAM dataUsingEncoding:NSUTF8StringEncoding]];
    // 5.发送一个同步链接
    NSData *data = [NSURLConnection sendSynchronousRequest:mRequest returningResponse:nil error:nil];
    
    // 6.使用请求回来的数据(解析请求回来的json文件)
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"dic = %@", dic);
}

#pragma mark - 异步POST方法
- (IBAction)doASynPost:(id)sender {
    
    // 1.封装url
    NSURL *url = [NSURL URLWithString:BASE_URL_2];
    // 2.创建一个可变的请求对象
    NSMutableURLRequest *mRequest = [NSMutableURLRequest requestWithURL:url];
    // 3.
    [mRequest setHTTPMethod:@"POST"];
    // 4.
    [mRequest setHTTPBody:[BASE_URL_2_PARAM dataUsingEncoding:NSUTF8StringEncoding]];
    // 5.发送一个异步链接 （设置代理人）
    [NSURLConnection connectionWithRequest:mRequest delegate:self];
    
    // 6.遵守代理和实现代理方法
}

#pragma mark -实现异步POST所需要的代理方法
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"刚开始收到响应时执行的方法");
    
    self.receiveData = [[NSMutableData alloc]init];    // 接收数据的可变data在这里alloc
    
    self.length = response.expectedContentLength;
    NSLog(@"-----%lld", _length);
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSLog(@"正在接收数据时执行的方法");
    // 将每次请求回来的data拼接在一起，形成一个完整的数据
    [self.receiveData appendData:data];
    
    // 设置进度条 (注意 progress是浮点型)
    self.progressView.progress = 1.0 * self.receiveData.length / self.length;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSLog(@"接收完成时执行的方法");
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:_receiveData options:NSJSONReadingMutableContainers error:nil];
    NSLog(@"-----%@", dic);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"接收出错时执行的方法");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 设置进度条从0开始
    self.progressView.progress = 0.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
