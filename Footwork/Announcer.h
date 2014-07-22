//
//  Announcer.h
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import <Foundation/Foundation.h>

@protocol AnnouncerConfigDelegate <NSObject>

-(BOOL)badmintonMode;
/** return the number of seconds to wait after announcing the given number */
-(float)delayForNumber:(int)number;
/** set of NSNumbers to randomly draw from */
-(NSArray*)numbersToDrawFrom;
/** seconds before the announcement at which time to make a warning beep.
 setting to zero disabled the warning beep. */
-(float)warningBeepTime;

@end


@protocol AnnouncerEventDelegate <NSObject>

/** informs the UI that a number announcement should be shown */
-(void)gotNumber:(int)number;
/** informs the UI that a warning should begin, and the the announcement will occur after @duration. */
-(void)startWarningWithDuration:(float)duration;

@end


@interface Announcer : NSObject

@property (readonly) BOOL isRunning;

@property (strong,nonatomic) id<AnnouncerConfigDelegate> configDelegate;
@property (strong,nonatomic) id<AnnouncerEventDelegate> eventDelegate;

-(void)start;
-(void)stop;
@end
