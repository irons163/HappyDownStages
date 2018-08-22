//
//  GameOverViewController.h
//  Try_downStage
//
//  Created by irons on 2015/6/25.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface GameOverViewController : UIViewController<UITextFieldDelegate>

@property (weak) id<gameDelegate> gameDelegate;

@property (nonatomic, assign) id delegate;

@property (strong, nonatomic) IBOutlet UILabel *gameOverTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *gameScoreLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameEditView;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;

- (IBAction)goToMenu:(id)sender;
- (IBAction)sendScore:(id)sender;
- (IBAction)restartClick:(id)sender;
-(void)setScore:(int)score;
@end
