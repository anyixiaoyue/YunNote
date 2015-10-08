                           //
//  Todo.m
//  Note
//
//  Created by 079 on 14-10-22.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "Todo.h"

@implementation Todo
@synthesize subject;
@synthesize todoDescription;
@synthesize _priority = priority;
@synthesize _date = date;

- (id)initWithTodo:(NSString *)newsubject andtodoDescription:(NSString *)newtodoDescription andpriority:(NSInteger)newpriority anddate:(NSString *)newdate{
    if (self = [super init]) {
        self.subject = newsubject;
        self.todoDescription = newtodoDescription;
        self._priority = newpriority;
        //priority = newpriority;
        self._date = newdate;
    }
    return self;
}

- (NSComparisonResult)compareSubject:(id)element {
    return [subject compare:[element subject]];
}

- (NSComparisonResult)comparePriority:(id)element {
    NSNumber *num1 = [NSNumber numberWithInteger:priority]; 
    NSNumber *num2 = [NSNumber numberWithInteger:[element _priority]];
    return [num1 compare:num2];
}

- (NSComparisonResult)compareDate:(id)element {
    return [date compare:[element _date]];
}

- (id)copyWithZone:(NSZone *)zone {
    Todo *newTodo = [[Todo allocWithZone:zone]initWithTodo:subject andtodoDescription:todoDescription andpriority:priority anddate:date];
    return newTodo;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:subject forKey:@"subject"];
    [aCoder encodeObject:todoDescription forKey:@"todoDescription"];
    [aCoder encodeInteger:priority forKey:@"priority"];
    [aCoder encodeObject:date forKey:@"date"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.subject = [aDecoder decodeObjectForKey:@"subject"];
        self.todoDescription = [aDecoder decodeObjectForKey:@"todoDescription"];
        self._priority = [aDecoder decodeIntegerForKey:@"priority"];
        self._date = [aDecoder decodeObjectForKey:@"date"];
    }
    return self;
}

- (NSString *)description {
    NSString *tmp = [NSString stringWithFormat:@"subject :%@\ndescription :%@\npriority : %d date : %@\n====================",subject,todoDescription,priority,date];
    return tmp;
}

@end
