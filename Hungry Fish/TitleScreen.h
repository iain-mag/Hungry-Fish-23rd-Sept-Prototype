//
//  GameOverScene.h
//  Hungry Fish
//
//  Created by Iain Maguire on 20/09/2012.
//  Copyright 2012 Personal Projects. All rights reserved.
//

#import "cocos2d.h"
#import <GameKit/GameKit.h>


@interface TitleScreenLayer : CCLayer {
    CCLabelTTF *_label;
    CCLabelTTF *_tryAgainLabel;
    
    CCSprite* backGroundPic;
    CCSprite* trophyPic;
    CCSprite* shipButton;
    
    NSString* finalScore;
    CGSize winSize;
    
}

@property (nonatomic, retain) CCLabelTTF *label;
@property (nonatomic, retain) CCLabelTTF *startGame;

@end 


@interface TitleScreenScene :CCScene {
    TitleScreenLayer *_layer;
}

- (id)initWithScore : (NSString*)score;

@property (nonatomic, retain) TitleScreenLayer *layer;

@end


