//
//  AddTextNoteViewController.h
//  云笔记
//
//  Created by 079 on 14-11-27.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoDB.h"

@interface AddTextNoteViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>

@property (retain, nonatomic) ToDoDB *todoDB;
@property (retain, nonatomic) Todo *todo;
@property (retain, nonatomic) UITableView *tableView;

@end
