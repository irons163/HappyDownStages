//
//  Player.m
//  Try_downStage
//
//  Created by irons on 2015/5/20.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "Player.h"
#import "GameLevelViewController.h"
#import "MyScene.h"

@implementation Player {
    BitmapUtil *bitmapUtil;
    CommonUtil *commonUtil;
    SKTexture *bitmap, *walkBitmap01, *walkBitmap02, *walkBitmap03, *downbitmap, *injureBmp;
    float x, y; //x座標與y座標
    int height, width; //圖片高寬
    int walkCount;
    bool isInjure;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)initPlayerX:(int)x Y:(int)y H:(int)height W:(int)width {
    isInjure = false;
    
    self->y = y;
    self->x = x;
//    this.y =y;//圖片底部座標Y，尚需減圖片高才能得到座標Y
//    this.x =x;//起始座標X
//    this.context=context;
    bitmapUtil = [BitmapUtil sharedInstance];
    //取得人物腳色圖片
    [self setPlayerBmpLeft];
    
    
//    self->height=bitmap.size.height;//圖片高
//    self->width=bitmap.size.width;//圖片寬
    self->height=self.size.height;
    self->width=self.size.width;
    
    self->y -= self->height; //起始座標Y
    
    commonUtil = [CommonUtil sharedInstance];
    
//    [self setPlayerBmpLeft];
//    [self setPlayerBmpRifgt];
}

/**
 * 建構子
 * @param context 呼叫者的context
 * @param x 座標X
 * @param y 圖片底部座標Y，尚需減圖片高才能得到座標Y
 */
//public Player (Context context, int x ,int y, int height, int width){
//    this.y =y;//圖片底部座標Y，尚需減圖片高才能得到座標Y
//    this.x =x;//起始座標X
//    this.context=context;
//    //取得人物腳色圖片
//    setPlayerBmpLeft();
//    
//    
//    this.height=bitmap.getHeight();//圖片高
//    this.width=bitmap.getWidth();//圖片寬
//    
//    this.y -= this.height; //起始座標Y
//}

/**
 * 繪圖動作
 * @param canvas 要繪圖的畫布
 * @param dy 圖片Y軸移動距離
 * @param dx 圖片X軸移動距離
 */
- (void)drawDy:(float)dy Dx:(float)dx {
    
    y += dy; //座標y變小，代表圖片往左移
    x -= dx; //座標x變小，代表圖片往上移
    
    self.position = CGPointMake(x, y);
    
    if (isInjure) {
        x += dx;
        self.position = CGPointMake(x, y);
        self.texture = injureBmp;
        walkCount = 0;
        return;
    }
    
    if (dx == 0 && dy >= 0) {
        bitmap = walkBitmap02;
        self.texture = bitmap;
        walkCount = 0;
    } else if (dy < 0) {
        self.texture = downbitmap;
        walkCount = 0;
        
		//如果位移等於slide速度，代表玩家並沒有移動，只是地板在使人物動，因此要用靜止圖(walkBitmap02)
		//但是此方法的缺點是，SLIDERSPEED不能剛好是MoveSpeed的兩倍，
		//否則當玩家在移動時 MoveSpeed - SLIDERSPEED = SLIDERSPEED 會導致誤判為靜止。
    } else if (commonUtil.SLIDERSPEED == dx || commonUtil.SLIDERSPEED == -dx) {
        bitmap = walkBitmap02;
//        canvas.drawBitmap(bitmap, x, y, nil);
        walkCount = 0;
        self.texture = bitmap;
    } else {
        if(walkCount%2==0){
            bitmap = walkBitmap02;
        }else if(walkCount%3==0){
            bitmap = walkBitmap01;
        }else{
            bitmap = walkBitmap03;
        }
        self.texture = bitmap;
        walkCount++;
    }
}

- (void)drawDy:(float)dy Dx:(float)dx isInjure:(bool)isInjure {
    if (isInjure) {
        self->isInjure = isInjure;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            usleep(300 * 1000);
            self->isInjure = false;
        });
        
        [self drawDy:dy Dx:dx];
    } else {
        [self drawDy:dy Dx:dx];
    }
}

- (void)updateBitmap:(int)type {
    if (type == MyScene.LEFT) {
        [self setPlayerBmpLeft];
    } else if (type == MyScene.RIGHT) {
        [self setPlayerBmpRifgt];
    }
}

- (void)setPlayerBmpLeft {
    if (GameLevelViewController.PLAYER_SEX == GameLevelViewController.GIRL) {
        bitmap = bitmapUtil.player_girl_left02_bitmap;
        walkBitmap01 = bitmapUtil.player_girl_left01_bitmap;
        walkBitmap02 = bitmapUtil.player_girl_left02_bitmap;
        walkBitmap03 = bitmapUtil.player_girl_left03_bitmap;
        downbitmap = bitmapUtil.player_girl_down_left_bitmap;
        injureBmp = bitmapUtil.player_girl_injure_left_bitmap;
    } else {
        bitmap = bitmapUtil.player_boy_left02_bitmap;
        walkBitmap01 = bitmapUtil.player_boy_left01_bitmap;
        walkBitmap02 = bitmapUtil.player_boy_left02_bitmap;
        walkBitmap03 = bitmapUtil.player_boy_left03_bitmap;
        downbitmap = bitmapUtil.player_boy_down_left_bitmap;
        injureBmp = bitmapUtil.player_boy_injure_left_bitmap;
    }
    self.texture = bitmap;
}

- (void)setPlayerBmpRifgt {
    if (GameLevelViewController.PLAYER_SEX==GameLevelViewController.GIRL) {
        bitmap = bitmapUtil.player_girl_right02_bitmap;
        walkBitmap01 = bitmapUtil.player_girl_right01_bitmap;
        walkBitmap02 = bitmapUtil.player_girl_right02_bitmap;
        walkBitmap03 = bitmapUtil.player_girl_right03_bitmap;
        downbitmap = bitmapUtil.player_girl_down_right_bitmap;
        injureBmp = bitmapUtil.player_girl_injure_right_bitmap;
    } else {
        bitmap = bitmapUtil.player_boy_right02_bitmap;
        walkBitmap01 = bitmapUtil.player_boy_right01_bitmap;
        walkBitmap02 = bitmapUtil.player_boy_right02_bitmap;
        walkBitmap03 = bitmapUtil.player_boy_right03_bitmap;
        downbitmap = bitmapUtil.player_boy_down_right_bitmap;
        injureBmp = bitmapUtil.player_boy_injure_right_bitmap;
    }
    
    self.texture = bitmap;
}

- (float)x {
    return x;
}

- (float)y {
    return y;
}

- (int)height {
    return height;
}

- (int)width {
    return width;
}

- (void)setY:(int)inputY {
    y = inputY;
    self.position = CGPointMake(self.position.x, y);
}

- (void)setX:(int)inputX {
    x = inputX;
    self.position = CGPointMake(x, self.position.y);
}

@end
