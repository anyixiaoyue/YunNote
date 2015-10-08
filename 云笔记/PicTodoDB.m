//
//  picTodoDB.m
//  云笔记
//
//  Created by 079 on 14-12-2.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "PicTodoDB.h"

@implementation PicTodoDB

- (id)initWithFilePath:(NSString *)filePath {
    if (self = [super init]) {
        self.filePath = [NSString stringWithString:filePath];
        self.picTodoList = [[PicTodoList alloc]init];
    }
    return self;
}

- (void)addTodo:(PicTodo *)picTodo withName:(NSString *)name {
    picTodo.imageID = self.picTodoList.count + 1;
    picTodo.pictureName = [NSString stringWithString:name];
    [self.picTodoList addToDo:picTodo];
}

- (void)removePicTodoAtIndex:(NSUInteger)index {
    [self.picTodoList removeToDo:index];
}

- (void)removeAllTodo {
    [self.picTodoList removeAll];
}

- (void)insertPicTodo:(PicTodo *)picTodo atIndex:(NSUInteger)index {
    [self.picTodoList insertToDo:picTodo atIndex:index];
}

- (PicTodo *)picTodoAtIndex:(NSUInteger)index {
    return [self.picTodoList todoAtIndex:index];
}

- (NSUInteger)indexOfPicTodo:(PicTodo *)picTodo {
    return [self.picTodoList indexOfToDo:picTodo];
}

- (NSUInteger)cout {
    return [self.picTodoList count];
}

- (void)write {
    [NSKeyedArchiver archiveRootObject:self.picTodoList toFile:self.filePath];
}

- (void)read {
    PicTodoList *tmpList = [NSKeyedUnarchiver unarchiveObjectWithFile:self.filePath];
    if (tmpList) {
        self.picTodoList = tmpList;
    }
}

@end
