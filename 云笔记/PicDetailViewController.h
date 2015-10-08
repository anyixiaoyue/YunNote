//
//  PicDetailViewController.h
//  云笔记
//
//  Created by 079 on 14-12-4.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (retain, nonatomic) NSData *imageData;
@property (retain, nonatomic) NSString *textSting;

@end
