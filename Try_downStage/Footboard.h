//
//  Footboard.h
//  Try_downStage
//
//  Created by irons on 2015/6/18.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ToolUtil.h"

static const int NOTOOL =0;
static const int BOMB =1;
static const int CURE =2;
static const int BOMB_EXPLODE =3;
static const int EAT_MAN_TREE = 4;

@interface Footboard : SKSpriteNode

@property (nonatomic) ToolUtil* tool;

-(void)setFrameX:(int) x y:(int) y h:(int) height w:(int) width;
-(void)drawDy:(float) dy;

-(void) setWhich:(int) witch;
-(void) setToolNum:(int) num;
-(void) setCount;

-(int)toolNum;

-(float)x;
-(float)y;

-(int)which;

-(SKTexture*)bitmap;

+(int)NOTOOL;
+(int)BOMB;
+(int)CURE;
+(int)BOMB_EXPLODE;
+(int)EAT_MAN_TREE;

@end
