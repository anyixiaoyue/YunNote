//
//  RegistViewController.m
//  云笔记
//
//  Created by 079 on 14-11-28.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "RegistViewController.h"

@interface RegistViewController () {
    UITextField *nameText;
    UITextField *pswdText1;
    UITextField *pswdText2;
}

@end

@implementation RegistViewController

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
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"log.png"];
    [self.view insertSubview:imageView atIndex:0];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(40, 150, 240, 180) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)backButton {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    
    [[self.navigationController.view layer]addAnimation:animation forKey:@"animation"];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"registCell" owner:self options:nil]lastObject];
    UILabel *label = nil;
    switch (indexPath.row) {
        case 0:
            label = (UILabel *)[cell viewWithTag:100];
            label.text = @"帐号";
            nameText = (UITextField *)[cell viewWithTag:101];
            break;
        case 1:
            label = (UILabel *)[cell viewWithTag:100];
            label.text = @"密码";
            pswdText1 = (UITextField *)[cell viewWithTag:101];
            pswdText1.secureTextEntry = YES;
            break;
        case 2:
            label = (UILabel *)[cell viewWithTag:100];
            label.text = @"确认";
            pswdText2 = (UITextField *)[cell viewWithTag:101];
            pswdText2.secureTextEntry = YES;
            break;
            
        default:
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.layer.borderColor = [[UIColor grayColor]CGColor];
    cell.layer.borderWidth = 1.0f;
    return cell;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [nameText resignFirstResponder];
    [pswdText1 resignFirstResponder];
    [pswdText2 resignFirstResponder];
}

- (IBAction)regist:(id)sender {
    if ([pswdText1.text isEqualToString:pswdText2.text]) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:nameText.text,@"name",pswdText1.text,@"password", nil];
        [self.delegate registDidEnd:dic];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.5f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = kCATransitionFade;
        
        [[self.navigationController.view layer]addAnimation:animation forKey:@"animation"];
        [self.navigationController popViewControllerAnimated:NO];
    }else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"两次输入的密码不一致" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}
@end
