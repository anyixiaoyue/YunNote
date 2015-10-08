//
//  ActivityIndicator.m
//  云笔记
//
//  Created by 079 on 14-12-4.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "ActivityIndicator.h"

@implementation ActivityIndicator

- (id)initWithView:(UIView *)view {
    if (self = [super init]) {
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:view.frame];
        self.activityIndicator.backgroundColor = [UIColor lightGrayColor];
        self.activityIndicator.alpha = 0.7;
        self.activityIndicator.hidesWhenStopped = YES;
        [view addSubview:self.activityIndicator];
    }
    return self;
}

- (void)show {
    [self.activityIndicator startAnimating];
}

- (void)miss {
    [NSThread sleepForTimeInterval:0.5];
    [self.activityIndicator stopAnimating];
}

@end
