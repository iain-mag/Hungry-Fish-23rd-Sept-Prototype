//
//  LevelOneLayer.m
//  Hungry Fish
//
//  Created by Iain Maguire on 19/09/2012.
//  Copyright Personal Projects 2012. All rights reserved.
//


#import "LevelOneScene.h"
#import "GameOverScene.h"
#import "AppDelegate.h"


#pragma mark - HelloScene

//Our scene initialises the layer

@implementation LevelOneScene
@synthesize layer = _layer;

- (CCScene*)init {
    
    if ((self = [super init])) {
        self.layer = [LevelOneLayer node];
        [self addChild:_layer];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"Dealloc HelloScene");    
    
    
    [_layer release];
    _layer = nil;
    [super dealloc];
}

@end


#pragma mark - HelloWorldLayer

@implementation LevelOneLayer

@synthesize fish1;
@synthesize fish2;
@synthesize fish3;
@synthesize fish4;
@synthesize scoreTimer;
@synthesize scoreLabel = _scoreLabel;

-(id) init
{
    
    if( (self=[super init] )) {
        
        winSize = [CCDirector sharedDirector].winSize;

        // Adding our background grass, fences, trees.
        // We call the methods to spwan and place our background image, our sprites and other graphics objects as our layer is created.
        
        [self placeBackground];
        [self placeKelp];
        [self placeFence]; 
        [self placePlayerShip]; 
        
        // Spawning 4 fish
        [self spawnFish]; 
        
        // Spawning our score / timer
        [self placeTimer];
        [self scheduleUpdate];
        
        
    }
    
    // enable touches so we can move our ship around the aquarium
    self.isTouchEnabled = YES;
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        return self;
}



-(void)placeBackground{
    
    backGroundWater = [CCSprite spriteWithFile:@"background_water.png"];
    CGSize imageSize = [backGroundWater boundingBox].size;
    [backGroundWater setScaleX:(winSize.width/imageSize.width)];
    [backGroundWater setScaleY:(winSize.height/imageSize.height)];
    backGroundWater.anchorPoint = CGPointMake(0, 0);
    [self addChild:backGroundWater]; 
    
}

-(void)placeFence{ 
    
    /* The fence is being placed in the bottom of the screen. Rather than work out the exact location of each sprite, we're creating a loop to place them programatically a specific distance away from each other, one after the other. Saves time and memory.
     
     */
    
    float width = 0.075;
    for (int i = 0; i < 9; i++){  
        backGroundFence = [CCSprite spriteWithFile:@"picket_fence.png"];
        [backGroundFence setScaleX: 80/backGroundFence.contentSize.width];
        [backGroundFence setScaleY: 80/backGroundFence.contentSize.height];
        backGroundFence.position = ccp(winSize.width * width, winSize.height * 0.05);
        width = width + 0.115;
        [self addChild:backGroundFence]; 
        
        
    } 
    
}

-(void)placeKelp{
    
    /* The kelp are being positioned randomly, but each kelp has a limited area to spawn next to the last that way they don't overlap. No impact on the game, just for decoration. */
    
    NSString* randomW1 = [NSString stringWithFormat:@"%f",[self randFloatBetween :(float)0.1 and:(float)0.3]];
    NSString* randomW2 = [NSString stringWithFormat:@"%f", [self randFloatBetween :(float)0.4 and:(float)0.6]];
    NSString* randomW3 = [NSString stringWithFormat:@"%f",[self randFloatBetween :(float)0.7 and:(float)0.9]];
    NSArray* kelpX = [NSArray arrayWithObjects:randomW1,randomW2,randomW3,nil];
        
    for (int i = 0; i < 3; i++){  
        
        float randomh = [self randFloatBetween :(float)0.2 and:(float)0.8];
        backgroundKelp = [CCSprite spriteWithFile:@"kelp.png"];
        [backgroundKelp setScaleX: 80/backgroundKelp.contentSize.width];
        [backgroundKelp setScaleY: 120/backgroundKelp.contentSize.height];
        backgroundKelp.position = ccp(winSize.width * [[kelpX objectAtIndex:i]floatValue], winSize.height * randomh);
        [self addChild:backgroundKelp]; 
    }
    
    
}


-(void) placePlayerShip {
    
    /* Our player ship is placed in the right of the screen. Initially I placed this in the center, with fish on each side, but testing this proved it wasn't a good starting position- the player would often get gobbled up before they had time to react! */
    
    playerShip = [CCSprite spriteWithFile:@"shipSprite.png"];
    [playerShip setScaleX: 65/playerShip.contentSize.width];
    [playerShip setScaleY: 49/playerShip.contentSize.height];
    playerShip.position = ccp(winSize.width * 0.8, winSize.height * 0.5);
    [self addChild:playerShip]; 

    
}

-(void) spawnFish{
    
    /* Creating 4 fish objects and creating thier class instances to the scene. I could spawn these by iterating through a for loop,  diferentiating between them with tags, but this is just as effective on the smaller scale. If the prototype became scalable in future I'd take the alternative approach. 
        */
    
    fish1 = [[FishyFish alloc] initWithObjectType : 0.15 :0.8 : 0.9];   
    fish2 = [[FishyFish alloc] initWithObjectType : 0.15 :0.6 : 1.1];   
    fish3 = [[FishyFish alloc] initWithObjectType : 0.15 :0.4 : 1.3];   
    fish4 = [[FishyFish alloc] initWithObjectType : 0.15 :0.2 : 1.5];   
    [self addChild:fish1];   
    [self addChild:fish2];   
    [self addChild:fish3];   
    [self addChild:fish4];   
    
    [self followShip];
    
    // Not using this right now, but it might be useful to store our fish later.
    
    fishArray = [NSArray arrayWithObjects:fish1,fish2,fish3,fish4,nil];
}


-(void)placeTimer{

    /* Allocating and setting the delegate of the timer class (using the Protocol - Delegate pattern, as seen in the updateTimer method. Placing our timer on Screen.
     */
     
     
    scoreTimer =  [[ScoreTimer alloc] init];
    [scoreTimer setDelegate:self];
    [self addChild:scoreTimer];
    
    self.scoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:20];
    _scoreLabel.color = ccc3(225,225,225);
    _scoreLabel.position = ccp(winSize.width/1.35, winSize.height/1.15);
    [self addChild:_scoreLabel];
    
}



-(void) followShip {    
    
    // Sending our fish instances our ship sprite, so they can decide what to do with it.
    
    [fish1 setPlayerShip:playerShip];
    [fish2 setPlayerShip:playerShip];
    [fish3 setPlayerShip:playerShip];
    [fish4 setPlayerShip:playerShip];

     }





-(float) randFloatBetween:(float)low and:(float)high
{
    
    // Method t calculate a random float.
    
    float diff = high - low;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + low;
}




- (void)rotatePlayer:(CGPoint)touchLocation {

    /* When the game detects a touch on the ship (earlier in the program flow), it rotates the sprite. A nice wee animation.
     */
     
     
    [playerShip stopAllActions];
    [playerShip runAction:[CCRotateTo actionWithDuration:0.1 angle:0]];
    CCRotateTo * rotLeft = [CCRotateBy actionWithDuration:0.05 angle:-10.0];
    CCSequence * rotSeq = [CCSequence actions:rotLeft, nil];            
    [playerShip runAction:[CCRepeatForever actionWithAction:rotSeq]];            
    
}


    // Detecting start of touch on ship.

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {  
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];    
    if (CGRectContainsPoint(playerShip.boundingBox, touchLocation)) { 
        
        [self followShip];
        [self rotatePlayer:touchLocation];      
    
    }
    return TRUE;    
}


- (void)panForTranslation:(CGPoint)translation {    
   
        CGPoint newPos = ccpAdd(playerShip.position, translation);
        playerShip.position = newPos;
    
}

// Detecting touch movement, or drag, on the ship.

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {       
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    if (CGRectContainsPoint(playerShip.boundingBox, touchLocation)) {            
        
        CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
        oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
        oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
        
        CGPoint translation = ccpSub(touchLocation, oldTouchLocation);    
        [self panForTranslation:translation];   
        [self followShip];
        
        
    }
    
}



- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    [playerShip stopAllActions];
}  


-(void)scoreUpdate:(NSString *)score{
    
    
/*  Updating our timer through the method exposed by it's protocol. While we could just call an istance of timer class and place it on the label (it's just an update method and doesn't have much to hide),  this gives us a good oppertunity for a working example of the Protocol - Delegate design pattern.
*/
    
    pScore= score;
    NSString* timer = [NSString stringWithFormat:@"Score: %@",pScore];
    [_scoreLabel setString:timer];

}


// Our update just detects if our fish are sending a "true" when they've intersected (collided) with our ship...

-(void) update: (ccTime) dt{
       
    //    NSLog(@"UPDATE!!!");
    if ([fish1 nextScene] == true || 
        [fish2 nextScene] == true ||
        [fish3 nextScene] == true || 
        [fish4 nextScene] == true) {
        [self gameOver]; 
        
    }
}

// ... and it's game over. Calling our new scene (GameOverScene), and sending it our score. Calling dealloc in the process... 

-(void)gameOver{
    GameOverScene *gameOverScene = [GameOverScene node];
    [[CCDirector sharedDirector] replaceScene:[gameOverScene initWithScore:pScore]];
     
}


// ... calling dealloc, unscheduling the udpate, releasing our retains.

- (void) dealloc
{
    NSLog(@"Dealloc HelloLayer Called");    
    
    
    [self unscheduleUpdate];
    [_scoreLabel release];
	_scoreLabel = nil;
    [fish1 release];
    fish1 = nil;
    [fish2 release];
    fish2 = nil;
    [fish3 release];
    fish3 = nil;
    [fish4 release];
    fish4 = nil;
    [scoreTimer release];
    scoreTimer = nil;
    [super dealloc];
}
@end
