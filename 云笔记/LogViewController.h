//
//  LogViewController.h
//  云笔记
//
//  Created by 079 on 14-11-26.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistViewController.h"

@interface LogViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,RegistViewControllerDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) UITableView *tableView;
- (IBAction)regist:(id)sender;
- (IBAction)login:(id)sender;

@end
