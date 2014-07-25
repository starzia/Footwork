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
