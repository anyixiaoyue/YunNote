//
//  PicDetailViewController.m
//  云笔记
//
//  Created by 079 on 14-12-4.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "PicDetailViewController.h"

@interface PicDetailViewController ()

@end

@implementation PicDetailViewController

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
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.layer.cornerRadius = 10.0f;
    self.imageView.layer.borderColor = [[UIColor greenColor]CGColor];
    self.imageView.layer.borderWidth = 1.0f;
    self.imageView.alpha = 0.7;
    self.textView.layer.cornerRadius = 10.0f;
    self.textView.layer.borderColor = [[UIColor redColor]CGColor];
    self.textView.layer.borderWidth = 1.0f;
    self.textView.alpha = 0.5;
    self.textView.editable = NO;
    
    self.imageView.image = [UIImage imageWithData:self.imageData];
    self.textView.text = self.textSting;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
