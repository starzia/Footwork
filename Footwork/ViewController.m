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
@synthesize pauseButton;
@synthesize optionsButton;
@synthesize modeControl;
@synthesize instructions;
@synthesize rateCell, warningCell, numberCell;
@synthesize instructionsCell, modeCell;
@synthesize startCell;
@synthesize emailCell, websiteCell;

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

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if( section == 0 ){
        return 1;
    }else if( section == 3 ){
        return 3;
    }else{
        return 2;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 0 ){
        return startCell;
    }else if( indexPath.section == 1 ){
        if( indexPath.row == 0 ){
            return rateCell;
        }else{
            return warningCell;
        }
    }else if( indexPath.section == 2 ){
        if( indexPath.row == 0 ){
            return numberCell;
        }else{
            return modeCell;
        }
    }else if( indexPath.section == 3 ){
        if( indexPath.row == 0 ){
            return instructionsCell;
        }else if( indexPath.row == 1 ){
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
    }
    else return @"";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if( indexPath.section == 2 && indexPath.row == 1 ){
        return 60;
    }else return 40;
}

#pragma mark - UITableViewDelegate

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return ( indexPath.section == 0 || indexPath.section == 3 );
}
@end
