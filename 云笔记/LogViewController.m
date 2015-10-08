//
//  LogViewController.m
//  云笔记
//
//  Created by 079 on 14-11-26.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "LogViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "ActivityIndicator.h"
#import "LogSuccessViewController.h"


#define SERVER_URL @"http://192.168.106.14:8080"

@interface LogViewController () {
    UITextField *nameText;
    UITextField *pswdText;
    NSURLConnection *logConnection;
    NSURLConnection *registConnection;
    ActivityIndicator *activityIndicator;
}

@end

@implementation LogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"登录";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar2.png"];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Login";
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"0.gif"] forBarMetrics:UIBarMetricsDefault];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(40, 150, 240, 150) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.scrollEnabled = NO;
    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"log.png"];
    [self.view insertSubview:imageView atIndex:0];
    
    activityIndicator = [[ActivityIndicator alloc]initWithView:self.view];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    if (pswdText) {
        pswdText.text = @"";
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = [[[NSBundle mainBundle]loadNibNamed:@"logNameCell" owner:self options:nil]lastObject];
            nameText = (UITextField *)[cell viewWithTag:100];
            break;
        case 1:
            cell = [[[NSBundle mainBundle]loadNibNamed:@"logPswdCell" owner:self options:nil]lastObject];
            pswdText = (UITextField *)[cell viewWithTag:101];
            pswdText.secureTextEntry = YES;
            break;
            
        default:
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.layer.borderWidth = 1.0;
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [nameText resignFirstResponder];
    [pswdText resignFirstResponder];
}


- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (IBAction)regist:(id)sender {
    [activityIndicator show];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    
    [[self.navigationController.view layer]addAnimation:animation forKey:@"animation"];
    RegistViewController *viewController = [[RegistViewController alloc]init];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:NO];
}

- (IBAction)login:(id)sender {
    [activityIndicator show];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/userlogin",SERVER_URL]];
    NSString *name = nameText.text;
    NSString *psw = [self md5:pswdText.text];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    NSString *str = [NSString stringWithFormat:@"user_name=%@&user_password=%@",name,psw];
    
    NSData *postdata = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postdata];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d",postdata.length] forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:10.0];
    logConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [activityIndicator miss];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[error.userInfo objectForKey:@"NSLocalizedDescription"] message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [activityIndicator miss];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSRange statusRange = [str rangeOfString:@"<status>"];
    if (statusRange.length <= 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ERROR" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    NSRange range1 = NSMakeRange(statusRange.location+8, 1);
    NSString *str1 = [str substringWithRange:range1];
    if ([str1 isEqualToString:@"1"]) {
        if ([connection isEqual:logConnection]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登录成功" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loginsuccess" object:self userInfo:[NSDictionary dictionaryWithObject:nameText.text forKey:@"name"]];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"注册成功" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }else {
        NSRange messageRange = [str rangeOfString:@"<message>"];
        NSRange messageRange1 = [str rangeOfString:@"</message>"];
        NSRange errorRange = NSMakeRange(messageRange.location+9, messageRange1.location-(messageRange.location+9));
        NSString *errorStr = [str substringWithRange:errorRange];
        if ([connection isEqual:logConnection]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登录失败" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"注册失败" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"登录成功"]) {
        LogSuccessViewController *viewController = [[LogSuccessViewController alloc]init];
        viewController.str = [NSString stringWithFormat:@"当前用户是：%@",nameText.text];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.6f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        
        [[self.navigationController.view layer]addAnimation:animation forKey:@"animation"];
        [self.navigationController pushViewController:viewController animated:NO];
    }
}

#pragma mark - RegistViewControllerDelegate

- (void)registDidEnd:(NSDictionary *)dic {
    [activityIndicator show];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/registeruser",SERVER_URL]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    NSString *str = [NSString stringWithFormat:@"user_name=%@&user_password=%@",[dic objectForKey:@"name"],[dic objectForKey:@"password"]];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d",data.length] forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:10.0];
    registConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}
@end
