//
//  picTodo.h
//  Login
//
//  Created by user on 12-11-25.
//  Copyright (c) 2012年 zyuq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicTodo : NSObject<NSCoding>
{
    NSInteger imageID;
    NSString* pictureName;
    NSString* todoDescription;
    NSData* imageData;
}
@property(nonatomic,retain)NSString* todoDescription;
@property(nonatomic,retain)NSData* imageData;
@property(nonatomic,retain)NSString* pictureName;
@property(nonatomic,assign)NSInteger imageID;
-(id)initWithImage:(NSData*)newData andDescription:(NSString*)newDescription;
@end
