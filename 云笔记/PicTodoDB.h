//
//  picTodoDB.h
//  云笔记
//
//  Created by 079 on 14-12-2.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PicTodoList.h"

@interface PicTodoDB : NSObject

@property (retain, nonatomic) NSString *filePath;
@property (retain, nonatomic) PicTodoList *picTodoList;

- (id)initWithFilePath:(NSString *)filePath;

- (void)addTodo:(PicTodo *)picTodo withName:(NSString *)name;

- (void)removePicTodoAtIndex:(NSUInteger)index;

- (void)removeAllTodo;

- (void)insertPicTodo:(PicTodo *)picTodo atIndex:(NSUInteger)index;

- (PicTodo *)picTodoAtIndex:(NSUInteger)index;

- (NSUInteger)indexOfPicTodo:(PicTodo *)picTodo;

- (NSUInteger)cout;

- (void)write;

- (void)read;

@end
