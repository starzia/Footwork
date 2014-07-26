//
//  DraggableLabel.m
//  Footwork
//
//  Created by Stephen Tarzia on 7/23/14.
//  Copyright (c) 2014 Steve Tarzia. All rights reserved.
//

#import "DraggableLabel.h"

@implementation DraggableLabel{
    CGPoint _originalPosition; // position at the time that dragging started
}

// when dragging, show label this many pixels above actual touch point so it is visible
const CGFloat vOffset = 30.0;

-(void)setup{
    // Initialization code
    self.userInteractionEnabled = YES;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if( self ){
        [self setup];
    }
    return self;
}

-(NSNumber*)number{
    // get number from text label
    return [NSNumber numberWithInt:self.text.intValue];
}


#pragma mark - dragging

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    _originalPosition = self.center;
}


-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint position = [touches.anyObject locationInView:self.superview];
    position.y -= vOffset; // show label about actual touch point for visibility
    
    // animate the view's movement so that it doesn't appear jumpy
    [UIView animateWithDuration:.001
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.center = position;
                     }
                     completion:nil];
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint newPosition;
    // ask delegate whether new position is valid
    CGPoint touchPos = [touches.anyObject locationInView:self.superview];
    touchPos.y -= vOffset; // show label about actual touch point for visibility
    if( [self.delegate currentPositionIsValidFor:self] ){
        // accept new position
        newPosition = touchPos;
        // notify delegate
        [self.delegate placedLabelInNewPosition:self];
    }else{
        // reject new position
        newPosition = _originalPosition;
    }
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^ {
                         self.center = newPosition;
                     }
                     completion:nil];
}


@end
