//
//  ActionViewController.m
//  Footwork
//
//  Created by Stephen Tarzia on 12/19/12.
//  Copyright (c) 2012 VaporStream, Inc. All rights reserved.
//

#import "ActionViewController.h"

@interface ActionViewController ()

@end

@implementation ActionViewController{
    UIView* _flash;
    NSArray* _markers;
    NSTimer* _clockTimer;
    int _clockTicks;
}

@synthesize timeLabel;
@synthesize badmintonMode;
@synthesize announcementDelay;
@synthesize marker1;
@synthesize marker2;
@synthesize marker3;
@synthesize marker4;
@synthesize marker5;
@synthesize marker6;
@synthesize marker7;
@synthesize marker8;
@synthesize courtImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set default values
        self.announcementDelay = 2.0;
        self.badmintonMode = NO;
    }
    return self;
}

-(void)viewDidLoad{
    _markers = [NSArray arrayWithObjects:marker1, marker2, marker3,
                marker4, marker5, marker6, marker7, marker8, nil];
    // set up flash view
    _flash = [[UIView alloc] initWithFrame:self.view.frame];
    _flash.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _flash.alpha = 0;
    _flash.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_flash];
    
    // clear badminton features, if disabled
    for( int i=0; i<_markers.count; i++ ){
        UILabel* marker = [_markers objectAtIndex:i];
        marker.hidden = !(badmintonMode && self.announcer.numberRange >= i+1);
    }
    courtImage.hidden = !badmintonMode;
}

-(void)viewDidAppear:(BOOL)animated{
    // cancel old timer
    _clockTicks = 0;
    if( _clockTimer ) [_clockTimer invalidate];
    // create new timer
    _clockTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(tick)
                                                 userInfo:nil
                                                  repeats:YES];
    [self tick]; // reset to 0:00
}

// update timer display
-(void)tick{
    timeLabel.text = [NSString stringWithFormat:@"%d:%02d",
                      _clockTicks/60, _clockTicks%60 ];
    _clockTicks++;
}

#pragma mark - AnnouncerDelegate

-(void)startWarningWithDuration:(float)duration{
    // ramp up to a black mask, then go back to clear
    [UIView animateWithDuration:duration
                     animations:^(void){
                         _flash.alpha = 1.0;
                     } completion:^(BOOL finished){
                         _flash.alpha = 0;
                     }];
}

-(void)gotNumber:(int)number{
    
    // clear old marker
    for( UILabel* marker in _markers ){
        marker.backgroundColor = [UIColor clearColor];
    }
    // set new marker
    if( number <= 8 ){
        UILabel* marker = [_markers objectAtIndex:number-1];
        if( number > 4 ){
            marker.backgroundColor = [UIColor orangeColor];
        }else{
            marker.backgroundColor = [UIColor redColor];
        }
    }
}

-(float)delayForNumber:(int)number{
    if( self.badmintonMode ){
        if( number == 5 || number == 6 || number == 7 ){
            return self.announcementDelay * 0.8;
        }else if( number == 3 || number == 4 ){
            return self.announcementDelay * 1.3;
        }else{
            return self.announcementDelay;
        }
    }else{
        return self.announcementDelay;
    }
}


@end
