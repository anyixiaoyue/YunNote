//
//  LogSuccessViewController.m
//  云笔记
//
//  Created by 079 on 14-11-29.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "LogSuccessViewController.h"

@interface LogSuccessViewController ()

@end

@implementation LogSuccessViewController

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
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.label.text = self.str;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionFade;
    
    [[self.navigationController.view layer]addAnimation:animation forKey:@"animation"];
    [self.navigationController popViewControllerAnimated:NO];
}
@end
