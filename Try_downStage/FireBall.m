//
//  FireBall.m
//  Try_downStage
//
//  Created by irons on 2015/6/23.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "FireBall.h"

@implementation FireBall{
    int width;
    int whichForFireBall;
}

-(void)setScreenWidth:(int) screenWidth{
    width = screenWidth;

    whichForFireBall = arc4random_uniform(3);
    
    switch (whichForFireBall) { //出現火球的地方
        case 0:
            self.position = CGPointMake(width/6*1, self.position.y); //螢幕1/6處
            break;
        case 1:
            self.position = CGPointMake(width/6*3, self.position.y); //1/2處
            break;
        case 2:
            self.position = CGPointMake(width/6*5, self.position.y); //5/6處
            break;
    }
}

-(void)moveDy:(float) dy Dx:(float) dx {
    
    float y = self.position.y - dy; //座標y變小，代表圖片往左移
    float x = self.position.x - dx; //座標x變小，代表圖片往上移
    self.position = CGPointMake(x, y );
}

@end
