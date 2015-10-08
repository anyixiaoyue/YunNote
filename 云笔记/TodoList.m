//
//  TodoList.m
//  Note
//
//  Created by 079 on 14-10-23.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "TodoList.h"

@implementation TodoList
@synthesize todolistArray;
-(id)init
{
	if(self=[super init])
	{
		todolistArray=[[NSMutableArray alloc] initWithCapacity:10];
	}
	return self;
}

-(void)addToDo:(Todo *)aToDo
{
	[todolistArray addObject:aToDo];
	
}

-(void)removeToDo:(NSUInteger)aIndex
{
	[todolistArray  removeObjectAtIndex:aIndex];
}

-(void) removeAll
{
	[todolistArray removeAllObjects];
}

-(void) insertToDo:(Todo *) aToDo atIndex:(NSUInteger)aIndex
{
	[todolistArray insertObject:aToDo atIndex:aIndex];
}

-(Todo *)todoAtIndex:(NSUInteger)aIndex
{
	return [todolistArray objectAtIndex:aIndex];
}

-(NSUInteger)indexOfToDo:(Todo *)aToDo
{
	return [todolistArray indexOfObject:aToDo];
}

-(NSUInteger)count
{
	return [todolistArray count];
}

-(void)sortPriority
{
	SEL msg=@selector(comparePriority:);
	[todolistArray sortUsingSelector:msg];
}

-(void)sortSubject
{
	SEL msg=@selector(compareSubject:);
	[todolistArray sortUsingSelector:msg];
}

-(void)sortDate
{
	SEL msg=@selector(compareDate:);
	[todolistArray sortUsingSelector:msg];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:todolistArray forKey:@"todolistArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if(self=[super init])
		self.todolistArray=[aDecoder decodeObjectForKey:@"todolistArray"];
	return self;
}

-(NSString*) description
{
	return [todolistArray description];
}

@end
