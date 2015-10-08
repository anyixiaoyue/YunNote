//
//  LogSuccessViewController.h
//  云笔记
//
//  Created by 079 on 14-11-29.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogSuccessViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) NSString *str;
- (IBAction)logout:(id)sender;

@end
