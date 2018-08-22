//
//  MyScene.h
//  Try_downStage
//

//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "ViewController.h"

const static int INFINITY_LEVEL = 13; // start level:0

@interface MyScene : SKScene

@property (weak) id<gameDelegate> gameDelegate;

@property (nonatomic) NSTimeInterval lastSpawnTimeInterval;
@property (nonatomic) NSTimeInterval lastUpdateTimeInterval;
@property (nonatomic) NSTimeInterval lastSpawnCreateFootboardTimeInterval;

+(id)sceneWihtSize:(CGSize)size withBackground:(SKTexture*)background withHeight:(int)height withWidth:(int) width withLeve:(int)level;

+(void)setNextBackground:(SKTexture*)nextBg;

+(int)LEFT;
+(int)RIGHT;

+(int)gameFlag;
+(void)setGameFlag:(bool)_gameFlag;

+(int)FOOTBOARD_WIDTH_PERSENT;

-(NSString*) getRandomBgResId;

-(void)setAdClickable:(bool)clickable;

@property (nonatomic) SKSpriteNode * timeMinuteTensDigital, *timeMinuteSingalDigital, *timeQmark, *timeScecondTensDigital, *timeSecondSingalDigital, *gameLevelSingleNode, *gameLevelTenNode;

@end
