//
//  TodoList.h
//  Note
//
//  Created by 079 on 14-10-23.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Todo.h"

@interface TodoList : NSObject <NSCoding> {
	NSMutableArray* todolistArray;
}
@property (nonatomic,retain) NSMutableArray* todolistArray;
-(id)init;
-(void) addToDo:(Todo*) aToDo;
-(void)removeToDo:(NSUInteger)aIndex;
-(void)removeAll;
-(void) insertToDo:(Todo*) aToDo atIndex:(NSUInteger)aIndex;
-(Todo*)todoAtIndex:(NSUInteger)aIndex;
-(NSUInteger)indexOfToDo:(Todo*)aToDo;
-(NSUInteger)count;
-(void)sortPriority;
-(void)sortSubject;
-(void)sortDate;
@end
