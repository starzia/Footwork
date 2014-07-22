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
    UIAlertView* _waitAlert;
}

@end

@implementation ViewController
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

-(id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if( self ){
        // initialize controls
        rateSlider = [[UISlider alloc] initWithFrame:CGRectMake(0,0,100,30)];
        rateSlider.minimumValue = 1;
        rateSlider.maximumValue = 5;
        rateSlider.value = 3;
        rateSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        
        warningSlider = [[UISlider alloc] initWithFrame:CGRectMake(0,0,100,30)];
        warningSlider.minimumValue = 0;
        warningSlider.maximumValue = 2;
        warningSlider.value = .6;
        warningSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        
        numberSlider = [[UISlider alloc] initWithFrame:CGRectMake(0,0,100,30)];
        numberSlider.minimumValue = 1;
        numberSlider.maximumValue = 10;
        numberSlider.value = 6;
        numberSliderLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        
        modeControl = [[UISegmentedControl alloc] initWithItems:@[@"Generic", @"Badminton"]];
        modeControl.selectedSegmentIndex = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    announcer = [[Announcer alloc] init];
    announcer.configDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    // stop announcer when returning to this view
    [announcer stop];
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
    return ( indexPath.section == 0 || indexPath.section == 3 );
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

-(float)delayForNumber:(int)number{
    float baseDelay = [self rateSliderValue];
    // when in badminton mode, alter base delay based on the distance to the number
    if( self.badmintonMode ){
        if( number == 5 || number == 6 || number == 7 ){
            return baseDelay * 0.8;
        }else if( number == 3 || number == 4 ){
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


-(NSArray*)numbersToDrawFrom{
    NSMutableArray* numbers = [NSMutableArray array];
    for( int i=0; i < [self numberSliderValue]; i++ ){
        [numbers addObject:[NSNumber numberWithInt:i+1]];
    }
    return numbers;
}

-(int)locationOfNumber:(NSNumber *)numberLabel{
    // TODO: for now, return a dummy value
    return numberLabel.intValue;
}

@end

