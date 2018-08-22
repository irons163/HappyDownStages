//
//  RankViewController.h
//  Try_downStage
//
//  Created by irons on 2015/9/10.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)rankClick:(id)sender;
- (IBAction)backClick:(id)sender;

@end
