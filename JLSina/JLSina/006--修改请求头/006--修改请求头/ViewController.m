//
//  ViewController.m
//  006--修改请求头
//
//  Created by 盘赢 on 2017/10/17.
//  Copyright © 2017年 JinLong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:@"https://m.baidu.com"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //告诉服务器一些附加信息
    //User-Agent 告诉服务器客户端的类型
    //forHTTPHeaderField 所有访问服务器前，要额外告诉服务器的附加信息
    [request setValue:@"iPhone AppleWebKit" forHTTPHeaderField:@"User-Agent"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@" , html);
        //让webview现实html
        [self.webView loadHTMLString:html baseURL:nil];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
