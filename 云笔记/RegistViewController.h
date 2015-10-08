//
//  RegistViewController.h
//  云笔记
//
//  Created by 079 on 14-11-28.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegistViewControllerDelegate <NSObject>

- (void)registDidEnd:(NSDictionary *)dic;

@end

@interface RegistViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) UITableView *tableView;

@property (assign, nonatomic) id<RegistViewControllerDelegate> delegate;

- (IBAction)regist:(id)sender;

@end
