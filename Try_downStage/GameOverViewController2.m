//
//  GameOverViewController2.m
//  Try_downStage
//
//  Created by irons on 2015/6/26.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameOverViewController2.h"
#import "MyScene.h"

@interface GameOverViewController2 ()

@end

@implementation GameOverViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goToMenu:(id)sender {
    [self.gameDelegate goToMenu];
    MyScene.gameFlag = false;
}

@end
