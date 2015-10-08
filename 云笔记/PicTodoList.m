//
//  PicTodoList.m
//  Login
//
//  Created by user on 12-12-4.
//  Copyright (c) 2012年 zyuq. All rights reserved.
//

#import "PicTodoList.h"

@implementation PicTodoList
@synthesize picTodoArray;
-(id)init
{
    if (self=[super init]) {
        picTodoArray=[[NSMutableArray alloc]init];
    }
    return self;
}
-(void) addToDo:(PicTodo*) aToDo
{
    [picTodoArray addObject:aToDo];
}
-(void)removeToDo:(NSUInteger)aIndex
{
    [picTodoArray removeObjectAtIndex:aIndex];
}
-(void)removeAll
{
    [picTodoArray removeAllObjects];
}
-(void) insertToDo:(PicTodo*) aToDo atIndex:(NSUInteger)aIndex
{
    [picTodoArray insertObject:aToDo atIndex:aIndex];
}
-(PicTodo*)todoAtIndex:(NSUInteger)aIndex
{
    return [picTodoArray objectAtIndex:aIndex];
}
-(NSUInteger)indexOfToDo:(PicTodo*)aToDo
{
    return [picTodoArray indexOfObject:aToDo];
}
-(NSUInteger)count
{
    return [picTodoArray count];
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:picTodoArray forKey:@"PICARRAY"];
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        self.picTodoArray=[aDecoder decodeObjectForKey:@"PICARRAY"];
    }
    return self;
}
@end
