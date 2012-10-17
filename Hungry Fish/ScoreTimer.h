//
//  ScoreTimer.h
//  FishGame
//
//  Created by Iain Maguire on 21/09/2012.
//  Copyright 2012 Personal Projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


// Exposing out score through the Protocol - Delegate design pattern. Implemented by our level.

@protocol scoreDelegate 
@required
- (void)scoreUpdate:(NSString*)score; 
@end


@interface ScoreTimer : CCNode {
   
    float startTime;
    NSString* timeScore;
    id delegate;
}

@property (retain) id delegate;

@end

