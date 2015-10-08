//
//  ToDoDB.m
//  todoMain
//
//  Created by cuihuiqin on 12-6-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "ToDoDB.h"


@implementation ToDoDB
@synthesize fileName;
@synthesize todoList;
//-(void) setTodoList:(ToDoList* ) list{
//	[todoList release];
//	todoList = [list retain];
//}
-(id)initWithFileName:(NSString*)aFileName
{
	if(self=[super init])
	{
		fileName=[[NSString alloc] initWithString:aFileName];
		todoList=[[TodoList alloc] init];
	}
	return self;
}

-(void)addToDo:(Todo*)aToDo
{
	[todoList addToDo:aToDo];
}


//存入文件,进行归档
-(void)write
{
	[NSKeyedArchiver archiveRootObject:todoList toFile:fileName];
} 

//从文件中进行读取(解档),返回备忘数组
-(NSMutableArray *)read
{
	TodoList* list=[NSKeyedUnarchiver unarchiveObjectWithFile:fileName];
	if(list != nil)
	{
		self.todoList = list;
	}
	
	return self.todoList.todolistArray;
}

- (id)copyWithZone:(NSZone *)zone
{
	ToDoDB* db=[[ToDoDB allocWithZone:zone] init
                ];
	[db setTodoList:todoList];
	return db;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:fileName forKey:@"FileName"];
	[aCoder encodeObject:todoList forKey:@"todolist"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
	if(self=[super init])
	{
		self.fileName=[aDecoder decodeObjectForKey:@"FileName"] ;
		self.todoList=[aDecoder decodeObjectForKey:@"todolist"];
	}
	return self;
}
-(Todo*)todoAtIndex:(NSUInteger)aIndex
{
	return [todoList todoAtIndex:aIndex];
}
- (void) insertToDo:(Todo*)aToDo atIndex:(NSUInteger)aIndex
{
	[todoList insertToDo:aToDo atIndex:aIndex];
}

- (NSUInteger)indexOfToDo:(Todo*)aToDo
{
	return [todoList indexOfToDo:aToDo];
}
- (NSUInteger)count
{
	return [todoList count];
}
- (void)removeToDo:(NSUInteger)aIndex
{
	[todoList removeToDo:aIndex];
}
- (void)removeAll
{
	[todoList removeAll];
}
- (void)sortPriority
{
	[todoList sortPriority];
}
- (void)sortSubject
{
	[todoList sortSubject];
}
- (void)sortDate
{
	[todoList sortDate];
}
-(NSString*) description
{
	NSString* temp=[NSString stringWithFormat:@"FileName:  %@,  contents:%@",fileName,todoList];
	return temp;
}
@end
