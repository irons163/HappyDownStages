//
//  GameLevel.m
//  Try_downStage
//
//  Created by irons on 2015/5/20.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameLevelViewController.h"
#import "ViewController.h"

@implementation GameLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(PLAYER_SEX==GIRL){
        self.girlCheckView.hidden = NO;
        self.boyCheckVIew.hidden = YES;
    }else{
        self.girlCheckView.hidden = YES;
        self.boyCheckVIew.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)girlClick:(id)sender {
    PLAYER_SEX = GIRL;
    self.girlCheckView.hidden = NO;
    self.boyCheckVIew.hidden = YES;
}

- (IBAction)boyClick:(id)sender {
    PLAYER_SEX = BOY;
    self.girlCheckView.hidden = YES;
    self.boyCheckVIew.hidden = NO;
}

- (IBAction)playClick:(id)sender {
//    ViewController * viewController = [ViewController new];
//    winDialogViewController.gameDelegate = self;

    ViewController * viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
//    [self presentViewController:viewController animated:YES completion:^{
//        //[reset];
//    }];
    
    
    
//    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController presentViewController:viewController animated:YES completion:^{
//        //        [reset];
//    }];
//    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController pushViewController:viewController animated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
}

+(int)PLAYER_SEX{
    return PLAYER_SEX;
}

+(int)GIRL{
    return GIRL;
}

+(int)BOY{
    return BOY;
}

@end
