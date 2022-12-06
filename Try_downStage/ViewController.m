//
//  ViewController.m
//  Try_downStage
//
//  Created by irons on 2015/4/22.
//  Copyright (c) 2015年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "MyScene.h"
#import "WinDialogViewController.h"
#import "GameLevelViewController.h"
#import "GameOverViewController.h"
#import "TextureHelper.h"

extern const int INFINITY_LEVEL;

@implementation ViewController {
    WinDialogViewController *winDialogViewController;
    int level;
    MyScene *scene;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SKView *skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    int willPlayLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"willPlaylevel"];
    level = willPlayLevel;
    
    [TextureHelper initTextures];

    scene = [MyScene sceneWihtSize:skView.bounds.size withBackground:[TextureHelper bgTextures][willPlayLevel] withHeight:skView.bounds.size.height withWidth:skView.bounds.size.width withLeve:willPlayLevel];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    [skView presentScene:scene];
}

- (void)showWinDialog {
    winDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WinDialogViewController"];
    winDialogViewController.gameDelegate = self;
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [winDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    winDialogViewController.view.backgroundColor = [UIColor blackColor];
    winDialogViewController.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    
    [self.navigationController presentViewController:winDialogViewController animated:YES completion:nil];
}

- (void)showLoseDialog:(int)score {
    GameOverViewController *gameOverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
    gameOverViewController.gameDelegate = self;
    [gameOverViewController setScore:score];
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [gameOverViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    gameOverViewController.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    
    [self.navigationController presentViewController:gameOverViewController animated:YES completion:nil];
}

- (void)goToMenu {
    if (winDialogViewController != nil) {
        [winDialogViewController dismissViewControllerAnimated:true completion:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)goToNextLevel {
    SKTexture *nextBackground;
    
    if (level + 1 < INFINITY_LEVEL) {
        nextBackground = [TextureHelper bgTextures][level + 1];
    } else if (level + 1 == INFINITY_LEVEL) {
        nextBackground = [TextureHelper bgTextures][level + 1];
    }
    
    SKView *skView = (SKView *)self.view;
    scene = [MyScene sceneWihtSize:skView.bounds.size withBackground:nextBackground withHeight:skView.bounds.size.height withWidth:skView.bounds.size.width withLeve:level + 1];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    [skView presentScene:scene];
    
    [winDialogViewController dismissViewControllerAnimated:true completion:nil];
    
    level++;
}

- (void)restart {
    level--;
    [self goToNextLevel];
}

- (NSString *)getRandomBgResId {
    return [scene getRandomBgResId];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

@end
