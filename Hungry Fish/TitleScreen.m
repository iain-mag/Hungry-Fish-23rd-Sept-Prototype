#import "TitleScreen.h"
#import "LevelOneScene.h"
#import "SimpleAudioEngine.h"


#pragma mark - GameOverScene

@implementation TitleScreenScene
@synthesize layer = _layer;

- (CCScene*)init{
    
    
    if ((self = [super init])) {
        
        self.layer = [TitleScreenLayer node];
        [self addChild:_layer];
        
    }
    return self;
}

- (void)dealloc {
    NSLog(@"Dealloc TitleScreenScene");    
    
    
    [_layer release];
    _layer = nil;
    [super dealloc];
}

@end
#pragma mark - GameOverLayer


@implementation TitleScreenLayer
@synthesize label = _label;
@synthesize  startGame = _tryAgainLabel;


- (id)init{
    NSLog(@"Init TitleScreenLayer");    
    
    
    if ((self = [super init])) {  
        
        
        // Playing a sound effect when the title screen first initialises.
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"RecordDjScratch.mp3"];

        // Placing our background, start button, and welcome text.
         winSize = [[CCDirector sharedDirector] winSize];
        [self placeBackground];
        [self placeShipButton];
        
                
        self.startGame = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:20];
        _tryAgainLabel.color = ccc3(255,255,255);
        _tryAgainLabel.position = ccp(winSize.width/2, winSize.height/1.38);
        [self addChild:_tryAgainLabel];
        [_tryAgainLabel setString:@"Welcome to Hungry Fish!\n\nDrag your sunken ship away from the Hungry Fish.\n Survive for as long as possible before they eat you!"];
     
        
         self.label = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:12];
         _label.color = ccc3(225,225,225);
         _label.position = ccp(winSize.width/2, winSize.height/14);
         [self addChild:_label];
         [_label setString:[NSString stringWithFormat:@"Iain Maguire programming test\n for Super Boise / App Partner Development"]];
       
        
    }	
    
    // Enabling touch.
    
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



- (void) placeShipButton{
    shipButton = [CCSprite spriteWithFile:@"shipSprite.png"];
    [shipButton setScaleX: 150/shipButton.contentSize.width];
    [shipButton setScaleY: 120/shipButton.contentSize.height];   
    shipButton.position = ccp(winSize.width /2, winSize.height * 0.35);
    [self addChild:shipButton]; 
}


// Detecting touch on our start button (our ship sprite.

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {  
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];    
    if (CGRectContainsPoint(shipButton.boundingBox, touchLocation)) { 
        NSLog(@"touchingButton");
        
        [self gameOverDone];
    }
    return TRUE;    
}

- (void)gameOverDone {
    
     
    // Loading our level when the button is pressed, and  calling dealloc.
    LevelOneScene *LevelOneScene = [LevelOneLayer node];
    [[CCDirector sharedDirector] replaceScene:LevelOneScene];
    
        
}

// Dealloc releasing our labels.

- (void)dealloc {
    NSLog(@"Dealloc GameOverLayer");    
	[_label release];
	_label = nil;
	[_tryAgainLabel release];
	_tryAgainLabel = nil;
    [super dealloc];
    
}

@end