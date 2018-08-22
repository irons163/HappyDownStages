//
//  MainMenuViewController.m
//  Try_downStage
//
//  Created by irons on 2015/6/25.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "MainMenuViewController.h"
//#import "GameLevelViewController.h"
#import "GameLevelCollectionViewController.h"
#import "GameCenterUtil.h"
#import "RankViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    //    gameCenterUtil.delegate = self;
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil authenticateLocalUser:self];
    [gameCenterUtil submitAllSavedScores];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)startGameClick:(id)sender {
//    GameLevelViewController * gameLevelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameLevelViewController"];
    GameLevelCollectionViewController * gameLevelCollectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameLevelCollectionViewController"];
    
    
//    gameLevelViewController.gameDelegate = self;
    
    //    gameOverDialogViewController.gameLevelTensDigitalLabel = time;
    
    //    winDialogViewController.gameLevel = gameLevel;
    
    //    [self.navigationController popToViewController:gameOverDialogViewController animated:YES];
    
    //    [self.delegate BviewcontrollerDidTapButton:self];
    
//    self.navigationController.providesPresentationContextTransitionStyle = YES;
//    self.navigationController.definesPresentationContext = YES;
//    [gameLevelViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    
    /* //before ios8
     self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
     */
    
    [self.navigationController pushViewController:gameLevelCollectionViewController animated:YES];
    
//    [self presentViewController:gameLevelViewController animated:YES completion:nil];
}

- (IBAction)rankClick:(id)sender {
    RankViewController * rankViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RankViewController"];
    
    [self.navigationController pushViewController:rankViewController animated:YES];
}
@end
