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
@synthesize slider;
@synthesize sliderLabel;
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
        slider.enabled = YES;
    }else{
        announcer.secondsBetweenAnnouncements = [self sliderValue];
        [announcer start];
        slider.enabled = NO;
    }
    // update toolbar
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

// round slider to 0.1 second precisionß
-(float)sliderValue{
    return round(slider.value*10)/10.0;
}

-(IBAction)sliderChanged:(id)sender{
    sliderLabel.text = [NSString stringWithFormat:@"%.1f",[self sliderValue]];
}

@end
