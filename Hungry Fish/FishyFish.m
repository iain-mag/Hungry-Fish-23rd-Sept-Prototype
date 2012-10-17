//
//  PavlogDog.m
//  Hungry Fish
//
//  Created by Iain Maguire on 19/09/2012.
//  Copyright 2012 Personal Projects. All rights reserved.
//

#import "FishyFish.h"

@implementation FishyFish
@synthesize playerShip;

-(id) initWithObjectType : (float)passWidth : (float)passHeight : (float)speed 

{
    if (self  = [super init]) {
        
        // Setting some initial values our fish will use, speed and similar.
       
        changeScene = false;
        goSpeed = 0.2;
        newSpeed = speed;
        fishSpeed = goSpeed;
        firstPos = TRUE;
      
        /*
         Setting a selector to update the ship's position after 0.3 seconds, The fish know where the ship is when the level first loads. When the game starts, each fish will swim in the same direction for a third of a second. Gives the player a moment to move out of the way without them following. 
         
         The fish then find the ship again after a random amount of time, then again, then again, and so on. 
         
         */
        
        firstDirectionChange = 0.3;
        randomDirectionChange = [self randFloatBetween :(float)0 and:(float)2];
        [self schedule:@selector(shipPosition :) interval:firstDirectionChange];
        
        // Setting the size of our fish (again, slightly random size fish, keeps things interesting each time.
        
        fish = [CCSprite spriteWithFile:@"fish.png"];
        float randomScale = [self randFloatBetween :(float)50 and:(float)100];
        [fish setScaleX: ((60/100.0f)*randomScale)/fish.contentSize.width];
        [fish setScaleY: ((45/100.0f)*randomScale)/fish.contentSize.height];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        fish.position = ccp(winSize.width * passWidth, winSize.height * passHeight);    
        [self addChild:fish];
         moveFish = true;
        
    }
    [self scheduleUpdate];
    return self;
}




-(void) update: (ccTime) dt{
    
    // The fish movement and direction is calculated in the update. It's slightly different and randomised for each fish.
    
    if (moveFish == true){
     
        if (firstPos == true){
        shipPos =[self initialPos];
            firstPos = false;
        }           
        
        CGPoint vectorDistance = ccpSub(shipPos , fish.position);
        fMovement_X = 0.0f;
        fMovement_Y = 0.0f;
        dt = dt * fishSpeed;
                
        if (fabsf(vectorDistance.x) > 0) {
            fMovement_X += vectorDistance.x * dt;
        }
        if (fabsf(vectorDistance.y) > 0) {                        
            fMovement_Y += vectorDistance.y * dt;
        }
        
        
        CGPoint moveVector = ccp(fMovement_X, fMovement_Y);
        fish.position = ccpAdd(fish.position, moveVector );
        
        // Flipping our fish back to front, depending on which direction they face.
        
        [self setPosition:fishPos];
        fishPos = fish.position;

        // Calculating the location of both our fish and our ship, and detecting a collision between them should one occur.
        
        
        CGRect rect1 = [self positionRect:fish];
        CGRect rect2 = [self positionRect:playerShip];
        if (!CGRectIsNull(CGRectIntersection(rect1, rect2))) {
            
            moveFish = false;            
            changeScene = true;
        }
        
    }
}


- (void)setPosition:(CGPoint)aPosition
{
    
    // If our fish are moving left, flip -180 degrees. Otherwise remain 180.
	CGPoint newPosition = [fish position];
    if (aPosition.x > newPosition.x)
    {
        fish.flipX = 0;
    } 
        else {
            fish.flipX = 180;     
        }

}

-(void)shipPosition : (ccTime) dt{
    
    /*
     At the start of the game, finds our ships position after 0.3 of game time for each fish. Then Updates randomly from then on.
    */
    
    [self schedule:@selector(newShipPosition :) interval:randomDirectionChange];

    [self unschedule:@selector(shipPosition :)];

}

// New ship position, initial position.

-(void)newShipPosition : (ccTime) dt{
    shipPos = playerShip.position;
    fishSpeed = newSpeed;
}

-(CGPoint)initialPos{
    
    shipPos = playerShip.position;
    return shipPos;
}


// Helper detecting sprite sizes and location, used for collision detection (intersect rect).


-(CGRect) positionRect: (CCSprite*)sprite {
	CGSize contentSize = [sprite contentSize];
    contentSize.height  = contentSize.height  /3.5;
    contentSize.width  = contentSize.width  /3.5;

    CGPoint contentPosition = [sprite position];
	CGRect result = CGRectOffset(CGRectMake(0, 0, contentSize.width, contentSize.height), contentPosition.x-contentSize.width/2, contentPosition.y-contentSize.height/2);
	return result;
}


// Called by LevelOne class, returns true if a collision has happened. Level one then loads the game over screen. 

-(bool) nextScene{
    if (changeScene == true){
        return true;
        
    } else {
        return false;
    }
}

// Just a randomiser.

-(float) randFloatBetween:(float)low and:(float)high
{
    float diff = high - low;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + low;
}


/*
 Dealloc called when parent level class deallocates this instance of our fish, unschedules our update. 
*/

- (void) dealloc
{
    [self unscheduleUpdate];
    
    NSLog(@"Deallocating Fish Object");
    [super dealloc];
}
@end
