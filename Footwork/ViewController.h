//
//  ViewController.h
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import <UIKit/UIKit.h>
#import "Announcer.h"

// for email
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ViewController : UIViewController <UIActionSheetDelegate, 
    MFMailComposeViewControllerDelegate, AnnouncerDelegate>

@property (strong) Announcer* announcer;
@property (strong) IBOutlet UISlider* rateSlider;
@property (strong) IBOutlet UILabel* rateSliderLabel;
@property (strong) IBOutlet UISlider* warningSlider;
@property (strong) IBOutlet UILabel* warningSliderLabel;
@property (strong) IBOutlet UISlider* numberSlider;
@property (strong) IBOutlet UILabel* numberSliderLabel;

@property (strong) IBOutlet UILabel* randomNumberLabel;

@property (strong) IBOutlet UIBarButtonItem* pauseButton;
@property (strong) IBOutlet UIBarButtonItem* optionsButton;
@property (strong) IBOutlet UIToolbar* toolbar;
@property (strong) IBOutlet UISegmentedControl* modeControl;


-(IBAction)togglePause:(id)sender;
-(IBAction)rateSliderChanged:(id)sender;
-(IBAction)warningSliderChanged:(id)sender;
-(IBAction)numberSliderChanged:(id)sender;
-(IBAction)clickedOptions:(id)sender;
@end
