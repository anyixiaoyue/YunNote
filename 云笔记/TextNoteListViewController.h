//
//  TextNoteListViewController.h
//  云笔记
//
//  Created by 079 on 14-11-26.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoDB.h"

@interface TextNoteListViewController : UITableViewController <UISearchBarDelegate,UIAlertViewDelegate,NSURLConnectionDataDelegate,NSXMLParserDelegate>

@property (retain, nonatomic) ToDoDB *todoDB;

@end
