//
//  Announcer.m
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import "Announcer.h"

@implementation Announcer{
    NSTimer* _mainTimer;
    NSTimer* _warningTimer;
    BOOL _isRunning;
}

@synthesize secondsBetweenAnnouncements;
@synthesize warningBeepTime;
@synthesize numberRange;


-(id)init{
    self = [super init];
    if( self ){
        // set property defaults
        secondsBetweenAnnouncements = 4;
        warningBeepTime = 1;
        numberRange = 4;
        _isRunning = NO;
    }
    return self;
}

-(void)dealloc{
    [self stop];
}

/** return random number between 1 and numberRange (inclusive) */
-(NSInteger)getRandom{
    return 1 + ( arc4random() % numberRange );
}

-(void)announce{
    NSLog( @"goto %d", [self getRandom] );
}
-(void)warn{
    NSLog( @"ready..." );
}

-(void)start{
    NSLog( @"started announcer" );
    // set up timers
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:secondsBetweenAnnouncements
                                                  target:self
                                                selector:@selector(announce)
                                                userInfo:nil
                                                 repeats:YES];
    _warningTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:secondsBetweenAnnouncements-warningBeepTime]
                                          interval:secondsBetweenAnnouncements
                                            target:self 
                                          selector:@selector(warn)
                                          userInfo:nil 
                                           repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_warningTimer forMode:NSDefaultRunLoopMode];
    _isRunning = YES;
}

-(void)stop{
    NSLog( @"stopped announcer" );
    [_mainTimer invalidate];
    [_warningTimer invalidate];
    _isRunning = NO;
}

-(BOOL)isRunning{
    return _isRunning;
}
@end
