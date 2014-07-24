//
//  SavedState.h
//  Footwork
//
//  Created by Stephen Tarzia on 7/24/14.
//  Copyright (c) 2014 Steve Tarzia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavedState : NSObject

-(NSObject*) objectForKey:(NSString*)key;
/** if obj==nil then we treat this as a removeObject:forKey: call */
-(void) setObject:(NSObject*)obj forKey:(NSString*)key;
-(void) removeObjectForKey:(NSString*)key;

@end
