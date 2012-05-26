//
//  Announcer.m
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import "Announcer.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation Announcer{
    NSTimer* _mainTimer;
    NSTimer* _warningTimer;
    BOOL _isRunning;
}

@synthesize secondsBetweenAnnouncements;
@synthesize warningBeepTime;
@synthesize numberRange;
@synthesize delegate;


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

-(void)playSoundFile:(NSString*)filename{
    SystemSoundID soundID;
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:filename ofType:@"wav"];    
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&soundID);
    AudioServicesPlaySystemSound (soundID);
}

/** return random number between 1 and numberRange (inclusive) */
-(NSInteger)getRandom{
    return 1 + ( arc4random() % numberRange );
}

-(void)announce{
    int randomNum = [self getRandom];
    NSLog( @"goto %d", randomNum );
    NSString* filename = [NSString stringWithFormat:@"%d",randomNum];
    [self playSoundFile:filename];
    
    if( delegate ) [delegate gotNumber:randomNum];
}
-(void)warn{
    NSLog( @"ready..." );
    // play tone
    [self playSoundFile:@"GB"];
}

-(void)start{
    NSLog( @"started announcer" );
    // set up timers
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:secondsBetweenAnnouncements
                                                  target:self
                                                selector:@selector(announce)
                                                userInfo:nil
                                                 repeats:YES];
    if( warningBeepTime > 0 ){
        _warningTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:secondsBetweenAnnouncements-warningBeepTime]
                                              interval:secondsBetweenAnnouncements
                                                target:self 
                                              selector:@selector(warn)
                                              userInfo:nil 
                                               repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_warningTimer forMode:NSDefaultRunLoopMode];
    }
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
