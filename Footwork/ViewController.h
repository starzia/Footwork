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

-(IBAction)togglePause:(id)sender;

@end
