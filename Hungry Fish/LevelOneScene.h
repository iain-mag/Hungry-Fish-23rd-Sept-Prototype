//
//  LevelOneLayer.h
//  Hungry Fish
//
//  Created by Iain Maguire on 19/09/2012.
//  Copyright Personal Projects 2012. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "FishyFish.h"
#import "ScoreTimer.h"


@interface LevelOneLayer : CCLayer <scoreDelegate>
{
    
    ScoreTimer *_scoreTimer;
    CCLabelTTF *_scoreLabel;
    
    FishyFish *fish1;
    FishyFish *fish2;
    FishyFish *fish3;
    FishyFish *fish4;
    
    CCSprite* backGroundWater;
    CCSprite* backGroundFence;
    CCSprite* backgroundKelp;
    CCSprite* playerShip;
    
    
    NSArray *fishArray;
    NSString *pScore;
    CGSize winSize;
    
}

@property (assign, nonatomic) ScoreTimer *scoreTimer;
@property (retain, nonatomic) CCLabelTTF *scoreLabel;
@property (assign, nonatomic) FishyFish *fish1;
@property (assign, nonatomic) FishyFish *fish2;
@property (assign, nonatomic) FishyFish *fish3;
@property (assign, nonatomic) FishyFish *fish4;



+(CCScene *) scene;

@end

@interface LevelOneScene :CCScene {
    LevelOneLayer *_layer;
}

@property (nonatomic, retain) LevelOneLayer *layer;
-(void) gameOver;
@end



