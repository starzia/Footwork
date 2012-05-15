//
//  ViewController.m
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize announcer;
@synthesize rateSlider, rateSliderLabel;
@synthesize warningSlider, warningSliderLabel;
@synthesize numberSlider, numberSliderLabel;
@synthesize pauseButton, toolbar;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    announcer = [[Announcer alloc] init];
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

-(IBAction)togglePause:(id)sender{
    if( announcer.isRunning ){
        [announcer stop];
    }else{
        announcer.secondsBetweenAnnouncements = [self rateSliderValue];
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

@end
