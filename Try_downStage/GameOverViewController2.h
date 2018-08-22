//
//  GameOverViewController2.h
//  Try_downStage
//
//  Created by irons on 2015/6/26.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface GameOverViewController2 : UIViewController

@property (weak) id<gameDelegate> gameDelegate;

- (IBAction)goToMenu:(id)sender;


@end
