//
//  SavedState.m
//  Footwork
//
//  Created by Stephen Tarzia on 7/24/14.
//  Copyright (c) 2014 Steve Tarzia. All rights reserved.
//

#import "SavedState.h"

@implementation SavedState

BOOL _isInitialized = NO;


// global initialization
+(void)init{
    // if we haven't already initialized
    if( !_isInitialized ){
        // load the defaults
        NSURL *defaultPrefsFile = [[NSBundle mainBundle]
                                   URLForResource:@"DefaultSettings" withExtension:@"plist"];
        NSDictionary *defaultPrefs = [NSDictionary dictionaryWithContentsOfURL:defaultPrefsFile];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultPrefs];
        _isInitialized = YES;
    }
}


+(NSObject*) objectForKey:(NSString*)key{
    [SavedState init];
    // pass through to NSUserDefaults
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}


+(void) setObject:(NSObject*)obj forKey:(NSString*)key{
    [SavedState init];
    // are we removing an object rather than setting a value?
    if( !obj ){
        [self removeObjectForKey:key];
        return;
    }
    // set object
    [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    // save changes
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+(void) removeObjectForKey:(NSString*)key{
    [SavedState init];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    // save changes
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
