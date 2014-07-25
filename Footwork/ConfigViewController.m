//
//  ConfigViewController.m
//  Footwork
//
//  Created by Stephen Tarzia on 7/23/14.
//  Copyright (c) 2014 Steve Tarzia. All rights reserved.
//

#import "ConfigViewController.h"
#import "FootworkSavedState.h"


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


// helper function, returning the distance between the centers of two UIView having the same superview
CGFloat viewDistance( UIView* a, UIView* b ){
    float x = (a.center.x - b.center.x);
    float y = (a.center.y - b.center.y);
    return sqrtf( x*x + y*y );
}


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


-(BOOL)isInHoldingArea:(DraggableLabel*)marker{
    return marker.frame.origin.y > holdingArea.frame.origin.y;
}

-(BOOL)isMarker:(DraggableLabel*)marker inTarget:(UIView*)target{
    return viewDistance( marker, target ) < 20;
}


// save the label positions to disk
-(void)savePositions{
    NSMutableDictionary* locationLabels = [NSMutableDictionary dictionary];
    // go through each marker
    for( DraggableLabel* marker in _markers ){
        // ignore markers in the holding area
        if( [self isInHoldingArea:marker] ){
            continue;
        }
        // determine which target the market is in
        for( int i = 0; i<_targets.count; i++ ){
            if( [self isMarker:marker inTarget:_targets[i]] ){
                // save this association
                [locationLabels setObject:[NSNumber numberWithInt:i]
                                   forKey:marker.text];
                break;
            }
        }
    }
    // save dict
    [FootworkSavedState setObject:locationLabels
                           forKey:kDefaultLocationLabels];
}


#pragma mark - DraggingDelegate

-(BOOL)currentPositionIsValidFor:(DraggableLabel *)label{
    // Try to find one target that the label fits within.
    for( UIView* target in _targets ){
        if( [self isMarker:label inTarget:target] ){
            return YES;
            // TODO: return NO if there is a different label in the target already
        }
    }
    // holdingArea is another valid target area
    if( [self isInHoldingArea:label] ) {
        return YES;
    }
    // label does not fit in any targets, so it's not in a valid position
    return NO;
}


-(void)placedLabelInNewPosition:(DraggableLabel *)label{
    [self savePositions];
}

@end
