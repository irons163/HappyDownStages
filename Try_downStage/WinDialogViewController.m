//
//  WinDialogViewController.m
//  Try_downStage
//
//  Created by irons on 2015/6/24.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "WinDialogViewController.h"

@interface WinDialogViewController ()

@end

@implementation WinDialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToMenuClick:(id)sender {
    [self.gameDelegate goToMenu];
}

- (IBAction)goToNextLevelClick:(id)sender {
    [self.gameDelegate goToNextLevel];
}

@end
