//
//  Player.h
//  Try_downStage
//
//  Created by irons on 2015/5/20.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameLevelViewController.h"
#import "BitmapUtil.h"
#import "CommonUtil.h"

@interface Player : SKSpriteNode

-(void)initPlayerX:(int)x Y:(int)y H:(int)height W:(int)width;

-(float)x;
-(float)y;
-(int)height;
-(int)width;

-(void)setY:(int)inputY;
-(void)setX:(int)inputX;

-(void) drawDy:(float) dy Dx:(float) dx isInjure:(bool) isInjure;

-(void)updateBitmap:(int) type;
@end
