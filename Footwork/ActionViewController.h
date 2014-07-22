//
//  ActionViewController.h
//  Footwork
//
//  Created by Stephen Tarzia on 12/19/12.
//  Copyright (c) 2012 VaporStream, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Announcer.h"

@interface ActionViewController : UIViewController <AnnouncerEventDelegate>

@property (strong) Announcer* announcer;
@property (strong) IBOutlet UILabel* timeLabel;
@property (strong) IBOutlet UILabel* numberLabel;
@property (strong) IBOutlet UILabel* marker0;
@property (strong) IBOutlet UILabel* marker1;
@property (strong) IBOutlet UILabel* marker2;
@property (strong) IBOutlet UILabel* marker3;
@property (strong) IBOutlet UILabel* marker4;
@property (strong) IBOutlet UILabel* marker5;
@property (strong) IBOutlet UILabel* marker6;
@property (strong) IBOutlet UILabel* marker7;
@property (strong) IBOutlet UILabel* marker8;
@property (strong) IBOutlet UIImageView* courtImage;

@property (assign) id<AnnouncerConfigDelegate> configDelegate;

@end
