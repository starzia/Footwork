//
//  ConfigViewController.m
//  Footwork
//
//  Created by Stephen Tarzia on 7/23/14.
//  Copyright (c) 2014 Steve Tarzia. All rights reserved.
//

#import "ConfigViewController.h"


@implementation ConfigViewController{
    NSArray* _markers;
    NSArray* _targets;
}

@synthesize target0;
@synthesize target1;
@synthesize target2;
@synthesize target3;
@synthesize target4;
@synthesize target5;
@synthesize target6;
@synthesize target7;
@synthesize target8;
@synthesize holdingArea;

@synthesize marker1;
@synthesize marker2;
@synthesize marker3;
@synthesize marker4;
@synthesize marker5;
@synthesize marker6;
@synthesize marker7;
@synthesize marker8;
@synthesize marker9;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _targets = [NSArray arrayWithObjects:target0, target1, target2, target3,
                target4, target5, target6, target7, target8, nil];
    
    _markers = [NSArray arrayWithObjects:marker1, marker2, marker3,
           marker4, marker5, marker6, marker7, marker8, marker9, nil];
    // set delegates for all markers
    for( DraggableLabel* marker in _markers ){
        marker.delegate = self;
    }
}


#pragma mark - DraggingDelegate

-(BOOL)currentPositionIsValidFor:(DraggableLabel *)label{
    // TODO just position validity based on overlap with certain targets
    if( label.center.x > 200 || label.center.x < 100 ){ // arbitrary criterion
        return YES;
    }else{
        return NO;
    }
}

@end
