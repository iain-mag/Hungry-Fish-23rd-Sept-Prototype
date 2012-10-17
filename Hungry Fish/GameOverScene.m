#import "GameOverScene.h"
#import "LevelOneScene.h"
#import "SimpleAudioEngine.h"



#pragma mark - GameOverScene

@implementation GameOverScene
@synthesize layer = _layer;

- (CCScene*)initWithScore : (NSString*)score{
 
    
    if ((self = [super init])) {
        
        self.layer = [[GameOverLayer node]initWithScore:score];
        [self addChild:_layer];
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"Dealloc GameOverScene");    
    
    
    [_layer release];
    _layer = nil;
    [super dealloc];
}

@end
#pragma mark - GameOverLayer


@implementation GameOverLayer
@synthesize label = _label;
@synthesize  tryAgainLabel = _tryAgainLabel;


- (id)initWithScore : (NSString*)score{
    NSLog(@"Init GameOverLayer");    

    
    if ((self = [super init])) {  

        [[SimpleAudioEngine sharedEngine] playEffect:@"ArrowImpactHuman.mp3"];

        finalScore = score;

        winSize = [[CCDirector sharedDirector] winSize];
        
        
        // Placing images, buttons.
        
        [self placeBackground];
        [self placeTrophy];
        [self placeShipButton];
        
        
        self.label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:20];
        _label.color = ccc3(0,0,0);
        _label.position = ccp(winSize.width/3.2, winSize.height/1.4);
        [self addChild:_label];
        [_label setString:[NSString stringWithFormat:@"Game Over!\nScore: %@\n seconds",finalScore]];
        
        self.tryAgainLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:20];
        _tryAgainLabel.color = ccc3(255,255,255);
        _tryAgainLabel.position = ccp(winSize.width/1.29, winSize.height/1.38);
        [self addChild:_tryAgainLabel];
        [_tryAgainLabel setString:@"Tap the ship\n to play again."];
        
        
    }	
    
    
    // Enabling Touch
    self.isTouchEnabled = YES;
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    return self;
}



- (void) placeBackground{
    backGroundPic = [CCSprite spriteWithFile:@"background_water.png"];
    CGSize imageSize = [backGroundPic boundingBox].size;
    [backGroundPic setScaleX:(winSize.width/imageSize.width)];
    [backGroundPic setScaleY:(winSize.height/imageSize.height)];
    backGroundPic.anchorPoint = CGPointMake(0, 0);
    [self addChild:backGroundPic]; 
    
}

- (void) placeTrophy{
    trophyPic = [CCSprite spriteWithFile:@"trophy.png"];
    [trophyPic setScaleX: 330/trophyPic.contentSize.width];
    [trophyPic setScaleY: 300/trophyPic.contentSize.height];
    trophyPic.anchorPoint = CGPointMake(0.05, -0.03);
    [self addChild:trophyPic]; 
    
}

- (void) placeShipButton{
    shipButton = [CCSprite spriteWithFile:@"shipSprite.png"];
    [shipButton setScaleX: 150/shipButton.contentSize.width];
    [shipButton setScaleY: 120/shipButton.contentSize.height];
    shipButton.position = ccp(winSize.width * 0.75, winSize.height * 0.3);
    
    [self addChild:shipButton]; 
}


- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {  
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];    
    if (CGRectContainsPoint(shipButton.boundingBox, touchLocation)) { 
        NSLog(@"touchingButton");
        
        [self gameOverDone];
    }
    return TRUE;    
}

- (void)gameOverDone {

    LevelOneScene *LevelOneScene = [LevelOneLayer node];
    [[CCDirector sharedDirector] replaceScene:LevelOneScene];
 
}

- (void)dealloc {
    NSLog(@"Dealloc GameOverLayer");    
	[_label release];
	_label = nil;
	[_tryAgainLabel release];
	_tryAgainLabel = nil;
    [super dealloc];
    
}

@end