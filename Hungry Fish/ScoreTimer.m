//
//  ScoreTimer.m
//  FishGame
//
//  Created by Iain Maguire on 21/09/2012.
//  Copyright 2012 Personal Projects. All rights reserved.
//

#import "ScoreTimer.h"


@implementation ScoreTimer
@synthesize delegate;

-(id) init 

{
    if (self  = [super init]) {
        
        startTime = CACurrentMediaTime();
        
      }
    [self scheduleUpdate];

    return self;
}



-(void) update: (ccTime) dt{

    // Our update sending a timer to the method exposed by this classes protocol.
        
    CFTimeInterval now = CACurrentMediaTime();
    CFTimeInterval elapsed = now - startTime;
      timeScore = [NSString stringWithFormat:@"%.02f", elapsed];
    
    if([self.delegate respondsToSelector:@selector(scoreUpdate:)]){
        [self.delegate scoreUpdate:timeScore];
     }
    
}

// Deallocate our delegate, unschedule our update.

- (void)dealloc {
    NSLog(@"Dealloc Timer");    
    [self unscheduleUpdate];
    [delegate release];
    delegate = nil;
    [super dealloc];
}


@end
