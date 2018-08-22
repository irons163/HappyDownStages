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
//#import "GameCenterUtil.h"
#import "TextureHelper.h"

extern const int INFINITY_LEVEL;

@implementation ViewController{
    ADBannerView * adBannerView;
    
    WinDialogViewController * winDialogViewController;
    int level;
    MyScene * scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    int willPlayLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"willPlaylevel"];
    level = willPlayLevel;
    
    [TextureHelper initTextures];

    // Create and configure the scene.
    scene = [MyScene sceneWihtSize:skView.bounds.size withBackground:[TextureHelper bgTextures][willPlayLevel] withHeight:skView.bounds.size.height withWidth:skView.bounds.size.width withLeve:willPlayLevel];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Present the scene.
    [skView presentScene:scene];
    
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, -50, 200, 30)];
    adBannerView.delegate = self;
    adBannerView.alpha = 1.0f;
    [self.view addSubview:adBannerView];
    
    
}

-(void)showWinDialog{
    winDialogViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WinDialogViewController"];
    winDialogViewController.gameDelegate = self;
    
    //    gameOverDialogViewController.gameLevelTensDigitalLabel = time;
    
//    winDialogViewController.gameLevel = gameLevel;
    
    //    [self.navigationController popToViewController:gameOverDialogViewController animated:YES];
    
    //    [self.delegate BviewcontrollerDidTapButton:self];
    
    self.navigationController.providesPresentationContextTransitionStyle = YES;
    self.navigationController.definesPresentationContext = YES;
    [winDialogViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    
    /* //before ios8
     self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
     */
    
//    [self.navigationController presentViewController:winDialogViewController animated:YES completion:^{
//        //        [reset];
//    }];
    
    winDialogViewController.view.backgroundColor = [UIColor blackColor];
    winDialogViewController.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
//    winDialogViewController.view.alpha = 0.5;
//    [self.navigationController pushViewController:winDialogViewController animated:YES];
    [self.navigationController presentViewController:winDialogViewController animated:YES completion:nil];
    
    if (level == 2) {
//        winDialogViewController.goToNextLevel.rank_level;
    }
}

-(void)showLoseDialog:(int)score{
    GameOverViewController* gameOverViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameOverViewController"];
    gameOverViewController.gameDelegate = self;
    [gameOverViewController setScore:score];
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    [gameOverViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    gameOverViewController.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
    
    [self.navigationController presentViewController:gameOverViewController animated:YES completion:nil];
}

-(void)goToMenu{
//    gameFlag = false;
    if(winDialogViewController!=nil){
        [winDialogViewController dismissViewControllerAnimated:true completion:nil];
//        [self dismissViewControllerAnimated:YES completion:nil];
//        [self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)goToNextLevel{
    SKTexture* nextBackground;
    
    if (level + 1 < INFINITY_LEVEL) {
        nextBackground = [TextureHelper bgTextures][level + 1];
    } else if (level + 1 == INFINITY_LEVEL) {
        nextBackground = [TextureHelper bgTextures][level + 1];
    }
    
//    if (level + 1 == 1) {
//        nextBackground = [SKTexture textureWithImageNamed:@"new_bg2"];
//    } else if (level + 1 == 2) {
//        nextBackground = [SKTexture textureWithImageNamed:@"new_bg3"];
//    } else if (level + 1 == 3) {
//        nextBackground = [SKTexture textureWithImageNamed:((NSString*)[self getRandomBgResId])];
//    }
    
    SKView * skView = (SKView *)self.view;
    
    // Create and configure the scene.
    scene = [MyScene sceneWihtSize:skView.bounds.size withBackground:nextBackground withHeight:skView.bounds.size.height withWidth:skView.bounds.size.width withLeve:level + 1];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.gameDelegate = self;
    
    skView.showsFPS = NO;
    skView.showsNodeCount = NO;
    
    // Present the scene.
    [skView presentScene:scene];
    
    [winDialogViewController dismissViewControllerAnimated:true completion:nil];
    
    level++;
    
    /*
    GameView rv = new GameView(context,
                               nextBackground, height, width,
                               level + 1);
    GameLevel activity = (GameLevel) context;
    activity.setContentView(rv);
    dialog.dismiss();*/
}

-(void)restart{
    level--;
    [self goToNextLevel];
}

-(NSString*)getRandomBgResId{
    return [scene getRandomBgResId];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner{
    [self layoutAnimated:true];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    //    [adBannerView removeFromSuperview];
    //    adBannerView.delegate = nil;
    //    adBannerView = nil;
    [self layoutAnimated:true];
}

-(BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave{
    //    [MyScene setAllGameRun:NO];
    return true;
}

- (void)layoutAnimated:(BOOL)animated
{
    //    CGRect contentFrame = self.view.bounds;
    
    CGRect contentFrame = self.view.bounds;
    //    contentFrame.origin.y = -50;
    CGRect bannerFrame = adBannerView.frame;
    if (adBannerView.bannerLoaded)
    {
        //        contentFrame.size.height -= adBannerView.frame.size.height;
        contentFrame.size.height = 0;
        bannerFrame.origin.y = contentFrame.size.height;
        [scene setAdClickable:false];
    } else {
        //        bannerFrame.origin.y = contentFrame.size.height;
        bannerFrame.origin.y = -50;
        [scene setAdClickable:true];
    }
    
    [UIView animateWithDuration:animated ? 0.25 : 0.0 animations:^{
        adBannerView.frame = contentFrame;
        [adBannerView layoutIfNeeded];
        adBannerView.frame = bannerFrame;
    }];
}

@end
