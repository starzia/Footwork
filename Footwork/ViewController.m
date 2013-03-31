//
//  ViewController.m
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import "ViewController.h"
#import "ActionViewController.h"

@interface ViewController (){
    UINavigationItem* _navItem;
}

@end

@implementation ViewController
@synthesize announcer;
@synthesize rateSlider, rateSliderLabel;
@synthesize warningSlider, warningSliderLabel;
@synthesize numberSlider, numberSliderLabel;
@synthesize pauseButton, toolbar;
@synthesize optionsButton;
@synthesize modeControl;
@synthesize instructions;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    announcer = [[Announcer alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    // stop announcer when returning to this view
    [announcer stop];
}

-(UINavigationItem*)navigationItem{
    if( !_navItem ){
        _navItem = [[UINavigationItem alloc] initWithTitle:@"Footwork Options"];
        pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay
                                                                    target:self
                                                                    action:@selector(start)];
        optionsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                            target:self
                                                            action:@selector(clickedOptions:)];
        [_navItem setRightBarButtonItem:pauseButton];
        [_navItem setLeftBarButtonItem:optionsButton];
    }
    return _navItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(IBAction)clickedOptions:(id)sender{
    UIActionSheet* optionsSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                              delegate:self 
                                                     cancelButtonTitle:@"Cancel" 
                                                destructiveButtonTitle:nil 
                                                     otherButtonTitles:@"Visit the website",
                                                                       @"Email us feedback",nil];
    [optionsSheet showFromBarButtonItem:self.optionsButton animated:YES];
}

-(IBAction)modeChanged:(id)sender{
    // hide instructions when not in badminton mode
    instructions.hidden = !self.badmintonMode;
}

-(void)start{
    // create and setup new view controller
    ActionViewController* actionViewController = [[ActionViewController alloc] init];
    announcer.delegate = actionViewController;
    actionViewController.announcer = announcer;
    actionViewController.badmintonMode = self.badmintonMode;
    actionViewController.announcementDelay = [self rateSliderValue];
    // configure the announcer
    announcer.warningBeepTime = [self warningSliderValue];
    announcer.numberRange = [self numberSliderValue];
    
    // present view controller
    [self.navigationController pushViewController:actionViewController animated:YES];
    
    // start announcer process
    [announcer start];
}

-(BOOL)badmintonMode{
    return modeControl.selectedSegmentIndex == 1;
}
// round rate slider to 0.1 second precision
-(float)rateSliderValue{
    return round(rateSlider.value*10)/10.0;
}
// round warning slider to 0.1 second precision
-(float)warningSliderValue{
    return round(warningSlider.value*10)/10.0;
}
// round number slider to integer value
-(int)numberSliderValue{
    return round(numberSlider.value);
}

-(IBAction)rateSliderChanged:(id)sender{
    rateSliderLabel.text = [NSString stringWithFormat:@"%.1f",[self rateSliderValue]];
}
-(IBAction)warningSliderChanged:(id)sender{
    float val = [self warningSliderValue];
    if( val == 0.0 ){
        warningSliderLabel.text = @"none";
    }else{
        warningSliderLabel.text = [NSString stringWithFormat:@"%.1f",val];
    }
}
-(IBAction)numberSliderChanged:(id)sender{
    numberSliderLabel.text = [NSString stringWithFormat:@"%d",[self numberSliderValue]];
}

-(void)email{
    if( [MFMailComposeViewController canSendMail] ){
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        // email feedback
        [mailer setToRecipients:[NSArray arrayWithObject:@"steve@stevetarzia.com"]];
        [mailer setSubject:[NSString stringWithFormat:@"[Footwork v%@] Feedback", 
                            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
                            ]];
        [mailer setMessageBody:@"" isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
    }else{
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Email unavailable" 
                                                          message:@"Please configure your email settings before trying to use this option." 
                                                         delegate:self 
                                                cancelButtonTitle:@"OK" 
                                                otherButtonTitles:nil];
        [myAlert show];	
    }
    
}


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if( buttonIndex == 0 ){ // zero is the bottom red buttom for cancel confirmation
        // website
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://stevetarzia.com/footwork"]];
    }else if( buttonIndex == 1 ) {
        // feedback
        [self email];
    }else if( buttonIndex == 2 ){
        // dismiss view
    }
}

#pragma mark - MKMailComposeViewControllerDelegate

// finished trying to send email
- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result 
						error:(NSError*)error{
	// make email window disappear
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
