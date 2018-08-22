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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goToMenu:(id)sender {
    [self.gameDelegate goToMenu];
    MyScene.gameFlag = false;
}
@end
