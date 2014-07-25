//
//  ConfigViewController.h
//  Footwork
//
//  Created by Stephen Tarzia on 7/23/14.
//  Copyright (c) 2014 Steve Tarzia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableLabel.h"

@interface ConfigViewController : UIViewController <DraggingDelegate>

@property (strong) IBOutlet UIView* target0;
@property (strong) IBOutlet UIView* target1;
@property (strong) IBOutlet UIView* target2;
@property (strong) IBOutlet UIView* target3;
@property (strong) IBOutlet UIView* target4;
@property (strong) IBOutlet UIView* target5;
@property (strong) IBOutlet UIView* target6;
@property (strong) IBOutlet UIView* target7;
@property (strong) IBOutlet UIView* target8;
@property (strong) IBOutlet UIView* holdingArea;

@property (strong) IBOutlet DraggableLabel* marker1;
@property (strong) IBOutlet DraggableLabel* marker2;
@property (strong) IBOutlet DraggableLabel* marker3;
@property (strong) IBOutlet DraggableLabel* marker4;
@property (strong) IBOutlet DraggableLabel* marker5;
@property (strong) IBOutlet DraggableLabel* marker6;
@property (strong) IBOutlet DraggableLabel* marker7;
@property (strong) IBOutlet DraggableLabel* marker8;
@property (strong) IBOutlet DraggableLabel* marker9;

@end
