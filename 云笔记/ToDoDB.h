//
//  ToDoDB.h
//  todoMain
//
//  Created by cuihuiqin on 12-6-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TodoList.h"

@interface ToDoDB : NSObject <NSCoding,NSCopying>{
	NSString* fileName; //文件名
	TodoList* todoList; //todoList对象
}
@property(nonatomic,copy)NSString* fileName;
@property(nonatomic,retain)TodoList* todoList;

-(id)initWithFileName:(NSString*)aFileName;
-(void)addToDo:(Todo*)aToDo;
-(void)write;
-(NSMutableArray* )read;
-(Todo*)todoAtIndex:(NSUInteger)aIndex;
-(void)insertToDo:(Todo*)aToDo atIndex:(NSUInteger)aIndex;
-(NSUInteger)indexOfToDo:(Todo*)aToDo;
-(NSUInteger)count;
-(void)removeToDo:(NSUInteger)aIndex;
-(void)removeAll;
-(void)sortPriority;
-(void)sortSubject;
-(void)sortDate;
@end
