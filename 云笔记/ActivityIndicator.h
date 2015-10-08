//
//  ActivityIndicator.h
//  云笔记
//
//  Created by 079 on 14-12-4.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityIndicator : NSObject

@property (retain, nonatomic) UIActivityIndicatorView *activityIndicator;

- (id)initWithView:(UIView *)view;

- (void)show;

- (void)miss;

@end
