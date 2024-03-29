//
//  MyUtils.m
//  Try_Cat_Shoot
//
//  Created by irons on 2015/4/21.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "MyUtils.h"
#import <AVFoundation/AVFoundation.h>

@implementation MyUtils

AVAudioPlayer *backgroundMusicPlayer;

static NSArray *musicLevelId = nil;

+ (void)initialize {
    // do not run for derived classes
    if (self != [MyUtils class])
        return;

    musicLevelId = @[@"level_one_music", @"level_two_music", @"level_three_music"];
}

+ (void)playBackgroundMusic:(NSString *)filename {
    NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
    
    if (url == nil) {
        NSLog(@"Could not find file:%@",filename);
        return;
    }
    
    NSError *error;
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (backgroundMusicPlayer == nil) {
        NSLog(@"Could not create audio player:%@",error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    backgroundMusicPlayer.numberOfLoops = -1;
    [backgroundMusicPlayer prepareToPlay];
    [backgroundMusicPlayer play];
}

+ (void)playBackgroundMusicLevel:(int)level {
    NSURL *url = [[NSBundle mainBundle] URLForResource:musicLevelId[level] withExtension:nil];
    
    if (url == nil) {
        NSLog(@"Could not find file:%@",musicLevelId[level]);
        return;
    }
    
    NSError *error;
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (backgroundMusicPlayer == nil) {
        NSLog(@"Could not create audio player:%@",error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    backgroundMusicPlayer.numberOfLoops = -1;
    [backgroundMusicPlayer prepareToPlay];
    [backgroundMusicPlayer play];
}

+ (void)playRamdonMusic {
    int level = arc4random_uniform(3);
    NSURL *url = [[NSBundle mainBundle] URLForResource:musicLevelId[level] withExtension:nil];
    
    if (url == nil) {
        NSLog(@"Could not find file:%@",musicLevelId[level]);
        return;
    }
    
    NSError *error;
    backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (backgroundMusicPlayer == nil) {
        NSLog(@"Could not create audio player:%@",error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    backgroundMusicPlayer.numberOfLoops = -1;
    [backgroundMusicPlayer prepareToPlay];
    [backgroundMusicPlayer play];
}

+ (void)backgroundMusicPlayerStop {
    [backgroundMusicPlayer stop];
}

+ (void)backgroundMusicPlayerPause {
    [backgroundMusicPlayer pause];
}

+ (void)backgroundMusicPlayerPlay {
    [backgroundMusicPlayer play];
}

@end
