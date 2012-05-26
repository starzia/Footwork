//
//  Announcer.h
//  Footwork
//
//  Created by Stephen Tarzia on 5/13/12.
//

#import <Foundation/Foundation.h>

@protocol AnnouncerDelegate <NSObject>
-(void)gotNumber:(int)number;
@end

@interface Announcer : NSObject

/** random numbers between 1 and numberRange will be announced */
@property int numberRange;
@property float secondsBetweenAnnouncements;
/** seconds before the announcement at which time to make a warning beep.
 setting to zero disabled the warning beep. */
@property float warningBeepTime;
@property (readonly) BOOL isRunning;

@property (strong,nonatomic) id<AnnouncerDelegate> delegate; 

-(void)start;
-(void)stop;
@end
