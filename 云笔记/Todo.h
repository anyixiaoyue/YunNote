//
//  Todo.h
//  Note
//
//  Created by 079 on 14-10-22.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface Todo : NSObject <NSCoding,NSCopying> {
    NSString *subject;//待办事务
    NSString * todoDescription;//备注
    NSInteger priority;//优先级
    NSString *date;//日期
}
@property (nonatomic, retain) NSString *subject;
@property (nonatomic, retain) NSString *todoDescription;
@property (nonatomic,assign) NSInteger _priority;
@property (nonatomic, retain) NSString *_date;
/*******************************************
 函数名称：initWithTodo
 函数功能：初始化类的数据成员
 传入参数：_subject       待办事务
 ，_description  备注
 ，_priority     优先级
 ，_date         日期
 返回值：id  返回初始化完成的类对象
 ********************************************/
- (id)initWithTodo:(NSString *)newsubject
andtodoDescription : (NSString *)newtodoDescription
      andpriority : (NSInteger)newpriority
          anddate : (NSString *)newdate;
/*****************************************
 函数名称：compareSubject
 函数功能：对象的待办事务比较
 传入参数：element
 返回值：NSComparisonResult
 *****************************************/
- (NSComparisonResult) compareSubject : (id) element;
/*****************************************
 函数名称：comparePriority
 函数功能：对象的优先级比较
 传入参数：element
 返回值：NSComparisonResult
 *****************************************/
- (NSComparisonResult) comparePriority : (id) element;
/*****************************************
 函数名称：compareDate
 函数功能：对象的日期比较
 传入参数：element
 返回值：NSComparisonResult
 *****************************************/
- (NSComparisonResult) compareDate : (id) element;

@end
