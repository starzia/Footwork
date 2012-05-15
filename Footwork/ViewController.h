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
@property (strong) IBOutlet UISlider* rateSlider;
@property (strong) IBOutlet UILabel* rateSliderLabel;
@property (strong) IBOutlet UISlider* warningSlider;
@property (strong) IBOutlet UILabel* warningSliderLabel;
@property (strong) IBOutlet UISlider* numberSlider;
@property (strong) IBOutlet UILabel* numberSliderLabel;

@property (strong) IBOutlet UIBarButtonItem* pauseButton;
@property (strong) IBOutlet UIToolbar* toolbar;

-(IBAction)togglePause:(id)sender;
-(IBAction)rateSliderChanged:(id)sender;
-(IBAction)warningSliderChanged:(id)sender;
-(IBAction)numberSliderChanged:(id)sender;
@end
