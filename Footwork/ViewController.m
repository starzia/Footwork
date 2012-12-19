//
//  ViewController.m
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import "ViewController.h"

@interface ViewController (){
    UIView* _flash;
}

@end

@implementation ViewController
@synthesize announcer;
@synthesize rateSlider, rateSliderLabel;
@synthesize warningSlider, warningSliderLabel;
@synthesize numberSlider, numberSliderLabel;
@synthesize pauseButton, toolbar;
@synthesize optionsButton;
@synthesize randomNumberLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    announcer = [[Announcer alloc] init];
    announcer.delegate = self;
    
    // set up flash view
    _flash = [[UIView alloc] initWithFrame:self.view.frame];
    _flash.alpha = 0;
    _flash.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_flash];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
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

-(IBAction)togglePause:(id)sender{
    if( announcer.isRunning ){
        [announcer stop];
    }else{
        announcer.warningBeepTime = [self warningSliderValue];
        announcer.numberRange = [self numberSliderValue];
        [announcer start];
    }
    rateSlider.enabled = warningSlider.enabled = numberSlider.enabled = !announcer.isRunning;
    
    // update toolbar pause/start button
    UIBarButtonSystemItem style = !announcer.isRunning? UIBarButtonSystemItemPlay : UIBarButtonSystemItemPause;
    UIBarButtonItem* newPauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:style
                                                                                    target:self
                                                                                    action:@selector(togglePause:)];
    newPauseButton.style = UIBarButtonItemStyleBordered;
    pauseButton = newPauseButton;
    NSMutableArray* toolbarItems = [NSMutableArray arrayWithArray:toolbar.items];
    [toolbarItems replaceObjectAtIndex:0 withObject:newPauseButton];
    [toolbar setItems:toolbarItems];
    [toolbar setNeedsLayout];

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
        [self presentModalViewController:mailer animated:YES];
    }else{
        UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Email unavailable" 
                                                          message:@"Please configure your email settings before trying to use this option." 
                                                         delegate:self 
                                                cancelButtonTitle:@"OK" 
                                                otherButtonTitles:nil];
        [myAlert show];	
    }
    
}

-(void)flash{
    [UIView animateWithDuration:0.1
                     animations:^(void){
                         _flash.alpha = 1.0;
                     } completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1
                                          animations:^(void){
                                              _flash.alpha = 0;
                                          }];
                     }];
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
	[controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - AnnouncerDelegate

-(void)gotNumber:(int)number{
    [self flash];
    randomNumberLabel.text = [NSString stringWithFormat:@"%d",number];
}

-(float)delayForNumber:(int)number{
    return [self rateSliderValue];
}

@end
