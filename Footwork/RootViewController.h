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

@interface RootViewController : UITableViewController <AnnouncerConfigDelegate,
    UIActionSheetDelegate, MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong) Announcer* announcer;
@property (strong) IBOutlet UISlider* rateSlider;
@property (strong) IBOutlet UILabel* rateSliderLabel;
@property (strong) IBOutlet UISlider* warningSlider;
@property (strong) IBOutlet UILabel* warningSliderLabel;
@property (strong) IBOutlet UISlider* numberSlider;
@property (strong) IBOutlet UILabel* numberSliderLabel;

@property (strong) IBOutlet UITableViewCell* instructionsCell;
@property (strong) IBOutlet UITableViewCell* rateCell;
@property (strong) IBOutlet UITableViewCell* warningCell;
@property (strong) IBOutlet UITableViewCell* numberCell;
@property (strong) IBOutlet UITableViewCell* modeCell;
@property (strong) IBOutlet UITableViewCell* startCell;
@property (strong) IBOutlet UITableViewCell* websiteCell;
@property (strong) IBOutlet UITableViewCell* emailCell;
@property (strong) IBOutlet UITableViewCell* recommendCell;
@property (strong) IBOutlet UITableViewCell* reviewCell;
@property (strong) IBOutlet UITableViewCell* configNumbersCell;

@property (strong) IBOutlet UISegmentedControl* modeControl;


-(IBAction)rateSliderChanged:(id)sender;
-(IBAction)warningSliderChanged:(id)sender;
-(IBAction)numberSliderChanged:(id)sender;
-(IBAction)modeChanged:(id)sender;

@end