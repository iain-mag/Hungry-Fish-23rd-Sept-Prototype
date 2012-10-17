//
//  PavlogDog.h
//  Hungry Fish
//
//  Created by Iain Maguire on 19/09/2012.
//  Copyright 2012 Personal Projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface FishyFish : CCNode {
    
    CCSprite* fish;
    CCSprite* playerShip;
    
    float goSpeed;
    float fishSpeed;
    float newSpeed;
    float shipX;
    float shipY;
    float fMovement_X;
    float fMovement_Y;
    float firstDirectionChange;
    float randomDirectionChange;

    BOOL moveFish;
    BOOL changeScene;
    BOOL firstPos;
    
    CGRect fishRect;
    CGRect shipRect;
    
    CGPoint shipPos;  
    CGPoint fishPos;  

}

@property (assign, nonatomic) CCSprite *playerShip;

-(id) initWithObjectType: (float)passWidth : (float)passHeight : (float)speed;
-(bool) nextScene;

@end
