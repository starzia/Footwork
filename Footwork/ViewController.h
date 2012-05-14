//
//  ViewController.h
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import <UIKit/UIKit.h>
#import "Announcer.h"

@interface ViewController : UIViewController

@property (strong) Announcer* announcer;
@property (strong) IBOutlet UISlider* slider;
@property (strong) IBOutlet UILabel* sliderLabel;
@property (strong) IBOutlet UIBarButtonItem* pauseButton;
@property (strong) IBOutlet UIToolbar* toolbar;

-(IBAction)togglePause:(id)sender;
-(IBAction)sliderChanged:(id)sender;
@end
