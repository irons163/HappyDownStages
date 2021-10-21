//
//  MainMenuViewController.m
//  Try_downStage
//
//  Created by irons on 2015/6/25.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "MainMenuViewController.h"
#import "GameLevelCollectionViewController.h"
#import "GameCenterUtil.h"
#import "RankViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GameCenterUtil *gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil submitAllSavedScores];
}

- (IBAction)startGameClick:(id)sender {
    GameLevelCollectionViewController *gameLevelCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameLevelCollectionViewController"];
    
    [self.navigationController pushViewController:gameLevelCollectionViewController animated:YES];
}

- (IBAction)rankClick:(id)sender {
    RankViewController *rankViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RankViewController"];
    
    [self.navigationController pushViewController:rankViewController animated:YES];
}

@end
