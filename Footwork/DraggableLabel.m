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
    // TODO
    // for now, arbitrarily reject drag if it was for less than 50 points
    CGFloat threshold = 50;
    CGPoint touchPos = [touches.anyObject locationInView:self.superview];
    if( abs(touchPos.x - _originalPosition.x) >= threshold
       && abs(touchPos.y - _originalPosition.y) >= threshold ){
        // accept new position
        newPosition = touchPos;
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
