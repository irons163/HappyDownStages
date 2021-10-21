//
//  RankViewController.m
//  Try_downStage
//
//  Created by irons on 2015/9/10.
//  Copyright (c) 2015年 irons. All rights reserved.
//

#import "RankViewController.h"
#import "GameCenterUtil.h"
#import "DatabaseManager.h"
#import "RankTableViewCell.h"
#import "Entity.h"

@interface RankViewController ()

@end

@implementation RankViewController{
    NSArray *items;
    DatabaseManager *manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    items = [NSArray array];
    [self loadData];
}

- (void)loadData {
    manager = [DatabaseManager sharedInstance];
    items = [manager load];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"Cell";
    
    RankTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[RankTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    Entity *item = items[indexPath.row];
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row+1];
    cell.scoreLabel.text = [item.score stringValue];
    cell.nameLabel.text = item.name;
    
    return cell;
}

- (void)showRankView {
    GameCenterUtil * gameCenterUtil = [GameCenterUtil sharedInstance];
    [gameCenterUtil isGameCenterAvailable];
    [gameCenterUtil showGameCenter:self];
    [gameCenterUtil submitAllSavedScores];
}

- (IBAction)rankClick:(id)sender {
    [self showRankView];
}

- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
