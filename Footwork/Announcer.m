//
//  Announcer.m
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import "Announcer.h"
#import <AVFoundation/AVFoundation.h>

@implementation Announcer{
    NSTimer* _mainTimer;
    NSTimer* _warningTimer;
    BOOL _isRunning;
    AVAudioPlayer* audioPlayer;
}

@synthesize configDelegate, eventDelegate;


-(id)init{
    self = [super init];
    if( self ){
        _isRunning = NO;
    }
    return self;
}

-(void)dealloc{
    [self stop];
}

-(void)playSoundFile:(NSString*)filename{
    // note that this stops any previously-running audio
    NSString *path = [[NSBundle mainBundle]
                      pathForResource:filename ofType:@"wav"];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]
                                                                   error:nil];
    [audioPlayer play];
}

/** return random number from configDelegate.numbersToDrawFrom */
-(int)getRandom{
    NSArray* numbers = configDelegate.labelNumbersToDrawFrom;
    int randIdx = ( arc4random() % numbers.count );
    return ((NSNumber*)numbers[randIdx]).intValue;
}

-(void)announce{
    int randomNum = [self getRandom];
    NSLog( @"goto %d", randomNum );
    NSString* filename = [NSString stringWithFormat:@"%d",randomNum];
    [self playSoundFile:filename];
    
    if( eventDelegate ) [eventDelegate gotNumber:randomNum];
    
    // set up timers for next announcement
    float delay = [configDelegate delayForLabel:randomNum];
    _mainTimer = [NSTimer scheduledTimerWithTimeInterval:delay
                                                  target:self
                                                selector:@selector(announce)
                                                userInfo:nil
                                                 repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_mainTimer forMode:NSDefaultRunLoopMode];
    if( configDelegate.warningBeepTime > 0 ){
        _warningTimer = [[NSTimer alloc] initWithFireDate:
                            [NSDate dateWithTimeIntervalSinceNow:delay - configDelegate.warningBeepTime]
                                              interval:delay
                                                target:self 
                                              selector:@selector(warn)
                                              userInfo:nil 
                                               repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:_warningTimer forMode:NSDefaultRunLoopMode];
    }
    
}
-(void)warn{
    NSLog( @"ready..." );
    // play tone
    [self playSoundFile:@"GB"];
    // show warning animation
    [eventDelegate startWarningWithDuration:configDelegate.warningBeepTime];
}

-(void)start{
    NSLog( @"started announcer" );
    // start with a warning
    if( configDelegate.warningBeepTime > 0 ){
        [self warn];
    }
    // then follow-up with announcement
    [NSTimer scheduledTimerWithTimeInterval:configDelegate.warningBeepTime
                                     target:self
                                   selector:@selector(announce)
                                   userInfo:nil
                                    repeats:NO];
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
