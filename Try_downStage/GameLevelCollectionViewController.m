//
//  GameLevelCollectionViewController.m
//  Try_downStage
//
//  Created by irons on 2015/9/10.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "GameLevelCollectionViewController.h"
#import "BitmapUtil.h"
#import "GameLevelViewController.h"
#import "MyScene.h"

extern const int INFINITY_LEVEL;

@interface GameLevelCollectionViewController ()

@end

@implementation GameLevelCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return INFINITY_LEVEL + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * const reuseIdentifier = @"Cell";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImageView *photoImageView = (UIImageView*)[cell viewWithTag:100];
    
    photoImageView.image = [[BitmapUtil sharedInstance] getNumberImage:(indexPath.item + 1) / 10];
    
    UIImageView* photoImageView2 = (UIImageView*)[cell viewWithTag:200];
    
    photoImageView2.image = [[BitmapUtil sharedInstance] getNumberImage:(indexPath.item + 1) % 10];
    
    int maxLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
    
    UIImageView* photoImageView3 = (UIImageView*)[cell viewWithTag:300];
    if (indexPath.item <= maxLevel) {
        photoImageView3.hidden = YES;
    } else {
        photoImageView3.hidden = NO;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    int maxLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"level"];
    
    GameLevelViewController * gameLevelViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"GameLevelViewController"];
    
    int willPlayLevel = indexPath.item;
    [[NSUserDefaults standardUserDefaults] setInteger:willPlayLevel forKey:@"willPlaylevel"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController pushViewController:gameLevelViewController animated:YES];
}

@end
