//
//  SavedState.m
//  Footwork
//
//  Created by Stephen Tarzia on 7/24/14.
//  Copyright (c) 2014 Steve Tarzia. All rights reserved.
//

#import "SavedState.h"

@implementation SavedState

SavedState* _globalSharedSavedState;

// hidden, shared singleton instance
+(SavedState*)sharedState{
    // initialize the singleton if it has not been used yet
    if( !_globalSharedSavedState ){
        // load the defaults
        NSURL *defaultPrefsFile = [[NSBundle mainBundle]
                                   URLForResource:@"DefaultSettings" withExtension:@"plist"];
        NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
    }
    return _globalSharedSavedState;
}


-(NSObject*) objectForKey:(NSString*)key{
    // pass through to NSUserDefaults
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


-(void) setObject:(NSObject*)obj forKey:(NSString*)key{
    // are we removing an object rather than setting a value?
    if( !obj ){
        [self removeObjectForKey:key];
        return;
    }
    // set object
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
}


-(void) removeObjectForKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
}

@end
