//
//  ViewController.m
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import "RootViewController.h"
#import "ActionViewController.h"
#import "ConfigViewController.h"
#import "FootworkSavedState.h"

@interface RootViewController (){
    UINavigationItem* _navItem;
    UIAlertView* _waitAlert;
}

@end

@implementation RootViewController
@synthesize announcer;
@synthesize rateSlider, rateSliderLabel;
@synthesize warningSlider, warningSliderLabel;
@synthesize numberSlider, numberSliderLabel;
@synthesize modeControl;
@synthesize rateCell, warningCell, numberCell;
@synthesize instructionsCell, modeCell;
@synthesize startCell;
@synthesize emailCell, websiteCell;
@synthesize recommendCell, reviewCell;
@synthesize configNumbersCell;

@synthesize marker0;
@synthesize marker1;
@synthesize marker2;
@synthesize marker3;
@synthesize marker4;
@synthesize marker5;
@synthesize marker6;
@synthesize marker7;
@synthesize marker8;


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    announcer = [[Announcer alloc] init];
    announcer.configDelegate = self;
    
    // load defaults
    { // - rateSlider
        NSNumber* savedRateSliderVal = [FootworkSavedState objectForKey:kDefaultRateSlider];
        rateSlider.value = savedRateSliderVal.floatValue;
        [self rateSliderChanged:nil];
    }
    { // - warningSlider
        NSNumber* savedWarningSliderVal = [FootworkSavedState objectForKey:kDefaultWarningSlider];
        warningSlider.value = savedWarningSliderVal.floatValue;
        [self warningSliderChanged:nil];
    }
    { // - numberSlider
        NSNumber* savedNumberSliderVal = [FootworkSavedState objectForKey:kDefaultNumberSlider];
        numberSlider.value = savedNumberSliderVal.floatValue;
        [self numberSliderChanged:nil];
    }
    { // - modeControl
        NSNumber* savedModeControlVal = [FootworkSavedState objectForKey:kDefaultSelectedModeIndex];
        modeControl.selectedSegmentIndex = savedModeControlVal.intValue;
        [self modeChanged:nil];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    // stop announcer when returning to this view
    [announcer stop];
    // arrange numbers on configNumbersCell
    {
        NSArray* markers = [NSArray arrayWithObjects:marker0, marker1, marker2, marker3,
                                        marker4, marker5, marker6, marker7, marker8, nil];
        // hide all markers first
        for( UILabel* marker in markers ){
            marker.hidden = YES;
        }
        // iterate through all enabled markers
        for( NSNumber* labelNumber in self.labelNumbersToDrawFrom ){
            // determine location corresponding to label
            int markerIdx = [self locationOfLabel:labelNumber];
            UILabel* marker = [markers objectAtIndex:markerIdx];
            // relabel marker and show it
            marker.text = labelNumber.description;
            marker.hidden = NO;
        }
    }
}

-(UINavigationItem*)navigationItem{
    if( !_navItem ){
        _navItem = [[UINavigationItem alloc] initWithTitle:@"Footwork Options"];
    }
    return _navItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(IBAction)modeChanged:(id)sender{
    // reload table to show/hide configNumbersCell
    [self.tableView reloadData];
    // save new value (but only if this was called by a GUI event, not by viewDidLoad
    if( sender ){
        [FootworkSavedState setObject:[NSNumber numberWithInteger:modeControl.selectedSegmentIndex]
                               forKey:kDefaultSelectedModeIndex];
    }
}

// throw up UIAlert and wait for a few seconds before really starting
-(void)preStart{
    // alert user that fingerprint is not yet ready
	_waitAlert = [[UIAlertView alloc] initWithTitle:@"Training will begin in 3 seconds."
                                            message:nil
                                           delegate:nil
                                  cancelButtonTitle:nil
                                  otherButtonTitles:nil];
	[_waitAlert show];
	// add spinning activity indicator
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]
										  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	indicator.center = CGPointMake(140, 90);
	[indicator startAnimating];
	[_waitAlert addSubview:indicator];
    
    // start timer
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(start)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)start{
    // dismiss "wait" alert
    [_waitAlert dismissWithClickedButtonIndex:0 animated:YES];
    
    // create and setup new view controller
    ActionViewController* actionViewController = [[ActionViewController alloc] init];
    actionViewController.configDelegate = self;
    announcer.eventDelegate = actionViewController;
    actionViewController.announcer = announcer;
    
    // present view controller
    [self.navigationController pushViewController:actionViewController animated:YES];
    
    // start announcer process
    //  delay before starting so it occurs after the viewController push animation completes
    [announcer performSelector:@selector(start) withObject:nil afterDelay:0.3];
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
    // update text label in GUI
    rateSliderLabel.text = [NSString stringWithFormat:@"%.1f",[self rateSliderValue]];
    // save new value (but only if this was called by a GUI event, not by viewDidLoad
    if( sender ){
        [FootworkSavedState setObject:[NSNumber numberWithFloat:rateSlider.value]
                               forKey:kDefaultRateSlider];
    }
}

-(IBAction)warningSliderChanged:(id)sender{
    float val = [self warningSliderValue];
    // update text label in GUI
    if( val == 0.0 ){
        warningSliderLabel.text = @"none";
    }else{
        warningSliderLabel.text = [NSString stringWithFormat:@"%.1f",val];
    }
    // save new value (but only if this was called by a GUI event, not by viewDidLoad
    if( sender ){
        [FootworkSavedState setObject:[NSNumber numberWithFloat:val]
                               forKey:kDefaultWarningSlider];
    }
}

-(IBAction)numberSliderChanged:(id)sender{
    // update text label in GUI
    numberSliderLabel.text = [NSString stringWithFormat:@"%d",[self numberSliderValue]];
    // save new value (but only if this was called by a GUI event, not by viewDidLoad
    if( sender ){
        [FootworkSavedState setObject:[NSNumber numberWithFloat:numberSlider.value]
                               forKey:kDefaultNumberSlider];
    }
}

-(void)emailFailed{
    UIAlertView *myAlert = [[UIAlertView alloc] initWithTitle:@"Email unavailable"
                                                      message:@"Please configure your email settings before trying to use this option."
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [myAlert show];
}

-(void)emailMe{
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
        [self emailFailed];
    }
}

-(void)emailFriend{
    if( [MFMailComposeViewController canSendMail] ){
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        // email feedback
        [mailer setSubject:@"Badminton Footwork Trainer for iPhone & iPad"];
        [mailer setMessageBody:@"I thought you might want to try a free app for badminton singles training.  It's called <a href=\"http://itunes.apple.com/app/badminton-footwork-trainer/id530904252?mt=8\">Badminton Footwork Trainer.</a>" isHTML:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    }else{
        [self emailFailed];
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

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( section == 3 ){
        return 4;
    }else{
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0 ){
        if( indexPath.row == 0 ){
            return startCell;
        }else{
            return instructionsCell;
        }
    }else if( indexPath.section == 1 ){
        if( indexPath.row == 0 ){
            return rateCell;
        }else{
            return warningCell;
        }
    }else if( indexPath.section == 2 ){
        if( indexPath.row == 0 ){
            return modeCell;
        }else if( indexPath.row == 1 ){
            // in badminton mode, give the option to arrange numbers
            if( self.badmintonMode ){
                return configNumbersCell;
            }
            // in generic mode, simple give a choice of the quantity of numbers
            else{
                return numberCell;
            }
        }else{
            return configNumbersCell;
        }
    }else if( indexPath.section == 3 ){
        if( indexPath.row == 0 ){
            return recommendCell;
        }else if( indexPath.row == 1 ){
            return reviewCell;
        }else if( indexPath.row == 2 ){
            return websiteCell;
        }else{
            return emailCell;
        }
    }
    else return nil;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if( section == 1 ){
        return @"Timing";
    }else if( section == 2 ){
        return @"Numbers";
    }else if( section == 3 ){
        return @" ";
    }
    else return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 2 && indexPath.row == 0 ){ /* make toggle row larger */
        return 100;
    }else if( indexPath.section == 0 && indexPath.row == 0 /* make the "start" row larger */ ){
        return 50;
    }else if( indexPath.section == 2 && indexPath.row == 1 && self.badmintonMode ){ // make configNumbersCell row larger
        return 87;
    }else return 40;
}

#pragma mark - UITableViewDelegate

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return ( indexPath.section == 0 || indexPath.section == 3
            || (indexPath.section == 2 && indexPath.row == 1));
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // take the appropriate action
    if( indexPath.section == 0 ){
        if( indexPath.row == 0 ){
            // start
            [self preStart];
        }else{
            // instructions
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://youtu.be/1wEPz7s-n5w"]];
        }
    }else if( indexPath.section == 2 ){
        if( indexPath.row == 1 ){
            // customize numbers
            ConfigViewController* configViewController = [ConfigViewController new];
            [self.navigationController pushViewController:configViewController
                                                 animated:YES];
        }
    
    }else if( indexPath.section == 3 ){
        if( indexPath.row == 0 ){
            // email friend
            [self emailFriend];
        }else if( indexPath.row == 1 ){
            // write an app review
            NSString* url = [NSString stringWithFormat: @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=530904252"];
            [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        }else if( indexPath.row == 2 ){
            // website
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://stevetarzia.com/footwork"]];
        }else{
            // email me
            [self emailMe];
        }
    }
    
    // unselect
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - AnnouncerConfigDelegate

-(float)delayForLabel:(int)label{
    int location = [self locationOfLabel:[NSNumber numberWithInt:label]];
    
    float baseDelay = [self rateSliderValue];
    // when in badminton mode, alter base delay based on the distance to the number
    if( self.badmintonMode ){
        if( location == 1 || location == 3 || location == 5 ){
            return baseDelay * 0.8;
        }else if( location == 6 || location == 8 ){
            return baseDelay * 1.3;
        }else{
            return baseDelay;
        }
    }else{
        return baseDelay;
    }
}


-(float)warningBeepTime{
    return [self warningSliderValue];
}


-(NSArray*)labelNumbersToDrawFrom{
    NSDictionary* labelsDict = [FootworkSavedState objectForKey:kDefaultLocationLabels];
    // plist dicts must have NSString keys, so we convert to NSNumbers here
    NSMutableArray* numbers = [NSMutableArray array];
    for( NSString* numString in labelsDict.allKeys ){
        [numbers addObject:[NSNumber numberWithInt:[numString intValue]]];
    }
    return numbers;
}

-(int)locationOfLabel:(NSNumber *)numberLabel{
    NSDictionary* labelsDict = [FootworkSavedState objectForKey:kDefaultLocationLabels];
    NSNumber* locNum = labelsDict[numberLabel.description]; // remember, that labelsDict is keyed with number strings
    return locNum.intValue;
}

@end

