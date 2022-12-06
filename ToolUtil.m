//
//  ToolUtil.m
//  Try_downStage
//
//  Created by irons on 2015/6/18.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "ToolUtil.h"
#import "Footboard.h"
#import "BitmapUtil.h"

@implementation ToolUtil {
    float tool_x;
    float tool_y;
    int tool_width;
    SKTexture *bitmap;
    int _type;
    NSTimer* bombExplodeThread;
    BOOL isEated;
    int count;
    NSTimer* eatThraed;
}

- (void)setToolUtilWithX:(float)x Y:(float)y type:(int)type {
    if (type == Footboard.BOMB) {
        bitmap = ((BitmapUtil *)[BitmapUtil sharedInstance]).tool_bomb_bitmap;
    } else if(type == Footboard.BOMB_EXPLODE) {
        bitmap = ((BitmapUtil *)[BitmapUtil sharedInstance]).tool_bomb_explosion_bitmap;
        
        if (bombExplodeThread != nil) {
            [bombExplodeThread invalidate];
        }
        
        self.isExploding = true;
        bombExplodeThread = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(bombExploding) userInfo:nil repeats:NO];
    } else if(type == Footboard.EAT_MAN_TREE) {
        bitmap = ((BitmapUtil *)[BitmapUtil sharedInstance]).toll_eat_man_tree2_bitmap;
    } else {
        bitmap = ((BitmapUtil *)[BitmapUtil sharedInstance]).toll_cure_bitmap;
    }
    tool_width = 30;
    tool_x = x - tool_width/2;
    tool_y = y;
    _type = type;
    self.texture = bitmap;
    self.size = CGSizeMake(tool_width, tool_width);
    self.position = CGPointMake(tool_x, tool_y);
    self.anchorPoint = CGPointMake(0, 0);
}

- (void)bombExploding {
    self.isExploding=false;
}

- (void)draw:(float)dy {
    tool_y += dy;
    self.position = CGPointMake(tool_x, tool_y);
}

- (float)tool_x {
    return tool_x;
}

- (int)tool_width {
    return tool_width;
}

- (void)doEat {
    if(_type == Footboard.EAT_MAN_TREE){
        if (eatThraed == nil) {
            eatThraed = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(eating) userInfo:nil repeats:YES];
        }
    }
}

- (void)eating {
    if (count == 0) {
        bitmap = ((BitmapUtil *)[BitmapUtil sharedInstance]).toll_eat_man_tree_bitmap;
        count++;
    } else if (count == 1) {
        bitmap = ((BitmapUtil *)[BitmapUtil sharedInstance]).toll_eat_man_tree3_bitmap;
        isEated = true;
        count++;
    } else {
        bitmap = ((BitmapUtil *)[BitmapUtil sharedInstance]).toll_eat_man_tree2_bitmap;
        count = 0;
        isEated = false;
        [eatThraed invalidate];
        eatThraed = nil;
    }
    self.texture = bitmap;
}

- (BOOL)isEated {
    if (isEated) {
        isEated = false;
        return true;
    }
    return isEated;
}

@end
