//
//  ViewController.m
//  OAuth
//
//  Created by hollylord on 15/5/8.
//  Copyright (c) 2015年 com.hollylord. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController () <UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //创建webview
    UIWebView *webView = [[UIWebView alloc]init];
    webView.frame = self.view.bounds;
    webView.delegate = self;
    [self.view addSubview:webView];
    
    //创建URL
    NSURL *URL = [NSURL URLWithString:@"https://api.weibo.com/oauth2/authorize?client_id=657627209&redirect_uri=http://www.baidu.com"];
    
    
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    
    
    //webView加载了request 仅仅只是做了网页跳转 不存在发送请求一说
    [webView loadRequest:request];
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        if (connectionError == nil) {//成功返回
//            NSLog(@"%@",response);
//        }
//    }];
    
}

- (void)test
{
 
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //获取url
    NSString *urlStr = request.URL.absoluteString;
//    NSLog(@"%@",urlStr);
    //判断url是不是点击授权后的回调地址
    NSRange range = [urlStr rangeOfString:@"code="];
    if (range.length !=0) {//是回调地址
        int fromIndex =  range.location + range.length;
        NSString *code = [urlStr substringFromIndex:fromIndex];
        NSLog(@"%@",code);
        //用code换accessToken (发送请求并接受accessToken)
        [self accessToken:code];
    }
    return YES;
    
}

- (void)accessToken:(NSString *)code{
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://api.weibo.com/oauth2/access_token"]];
    
    //拼接参数
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"client_id"] = @"657627209";
    param[@"client_secret"] = @"0ec5a929c20990565fd75d34763b3f18";
    param[@"grant_type"] = @"authorization_code";
    param[@"redirect_uri"] = @"http://www.baidu.com";
    param[@"code"] = code;
    
    [mgr POST:@"https://api.weibo.com/oauth2/access_token" parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@",responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
    }];
    
}
@end
