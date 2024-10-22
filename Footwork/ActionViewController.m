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
@synthesize marker0;
@synthesize marker1;
@synthesize marker2;
@synthesize marker3;
@synthesize marker4;
@synthesize marker5;
@synthesize marker6;
@synthesize marker7;
@synthesize marker8;
@synthesize numberLabel;
@synthesize courtImage;
@synthesize configDelegate;



-(void)viewDidLoad{
    _markers = [NSArray arrayWithObjects:marker0, marker1, marker2, marker3,
                marker4, marker5, marker6, marker7, marker8, nil];
    // set up flash view
    _flash = [[UIView alloc] initWithFrame:self.view.frame];
    _flash.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _flash.alpha = 0;
    _flash.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_flash];
    
    // hide all markers first
    for( UILabel* marker in _markers ){
        marker.hidden = YES;
    }
    // show enabled markers, if in badminton mode
    if( configDelegate.badmintonMode ){
        // iterate through all enabled markers
        for( NSNumber* labelNumber in configDelegate.labelNumbersToDrawFrom ){
            // determine location corresponding to label
            int markerIdx = [configDelegate locationOfLabel:labelNumber];
            UILabel* marker = [_markers objectAtIndex:markerIdx];
            // relabel marker and show it
            marker.text = labelNumber.description;
            marker.hidden = NO;
        }
    }
    courtImage.hidden = !configDelegate.badmintonMode;
    numberLabel.hidden = configDelegate.badmintonMode;
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

#pragma mark - AnnouncerEventDelegate

-(void)startWarningWithDuration:(float)duration{
    // ramp up to a black mask, then go back to clear
    [UIView animateWithDuration:duration
                     animations:^(void){
                         self->_flash.alpha = 1.0;
                     } completion:^(BOOL finished){
                         self->_flash.alpha = 0;
                     }];
}

-(void)gotNumber:(int)labelNumber{
    int locationNumber = [configDelegate locationOfLabel:[NSNumber numberWithInt:labelNumber]];
    
    // clear old marker
    for( UILabel* marker in _markers ){
        marker.backgroundColor = [UIColor clearColor];
    }
    // set new marker
    if( locationNumber <= 8 ){
        UILabel* marker = [_markers objectAtIndex:locationNumber];
        if( locationNumber == 1 || locationNumber == 3 || locationNumber == 5 || locationNumber == 7 ){
            marker.backgroundColor = [UIColor orangeColor];
        }else{
            marker.backgroundColor = [UIColor redColor];
        }
    }
    // set number label (for generic mode)
    numberLabel.text = [NSString stringWithFormat:@"%d",labelNumber];
}


@end
