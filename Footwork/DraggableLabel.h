//
//  DraggableLabel.h
//  Footwork
//
//  Created by Stephen Tarzia on 7/23/14.
//  Copyright (c) 2014 Steve Tarzia. All rights reserved.
//

#import <UIKit/UIKit.h>


@class DraggableLabel; // forward declaration


@protocol DraggingDelegate <NSObject>

/** return YES if the label is in a valid position 
    (otherwise the label will be snapped back to its prior position). */
-(BOOL)currentPositionIsValidFor:(DraggableLabel*)label;

-(void)placedLabelInNewPosition:(DraggableLabel*)label;

@end


@interface DraggableLabel : UILabel

@property (readonly,strong) NSNumber* number;
@property (assign) id<DraggingDelegate> delegate;

@end
