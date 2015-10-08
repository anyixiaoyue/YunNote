//
//  PicTodoList.h
//  Login
//
//  Created by user on 12-12-4.
//  Copyright (c) 2012年 zyuq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "picTodo.h"

@interface PicTodoList : NSObject<NSCoding>
{
    NSMutableArray* picTodoArray;
}
@property(nonatomic,retain)NSMutableArray* picTodoArray;
-(id)init;
-(void)addToDo:(PicTodo*) aToDo;
-(void)removeToDo:(NSUInteger)aIndex;
-(void)removeAll;
-(void)insertToDo:(PicTodo*) aToDo atIndex:(NSUInteger)aIndex;
-(PicTodo*)todoAtIndex:(NSUInteger)aIndex;
-(NSUInteger)indexOfToDo:(PicTodo*)aToDo;
-(NSUInteger)count;
@end
