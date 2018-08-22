//
//  GameLevelCollectionViewController.h
//  Try_downStage
//
//  Created by irons on 2015/9/10.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameLevelCollectionViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
