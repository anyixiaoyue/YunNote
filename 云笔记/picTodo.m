//
//  picTodo.m
//  Login
//
//  Created by user on 12-11-25.
//  Copyright (c) 2012年 zyuq. All rights reserved.
//

#import "picTodo.h"

@implementation PicTodo
@synthesize imageData,todoDescription;
@synthesize imageID,pictureName;
-(id)initWithImage:(NSData*)newData andDescription:(NSString*)newDescription
{
    if (self=[super init]) {
        self.imageData=newData;
        self.todoDescription=newDescription;
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:todoDescription forKey:@"DESCRIPTION"];
    [aCoder encodeObject:imageData forKey:@"DATA"];
    [aCoder encodeObject:pictureName forKey:@"PICNAME"];
    [aCoder encodeInteger:imageID forKey:@"ID"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.todoDescription=[aDecoder decodeObjectForKey:@"DESCRIPTION"];
        self.imageData=[aDecoder decodeObjectForKey:@"DATA"];
        self.pictureName=[aDecoder decodeObjectForKey:@"PICNAME"];
        self.imageID=[aDecoder decodeIntegerForKey:@"ID"];
    }
    return self;
}
@end
