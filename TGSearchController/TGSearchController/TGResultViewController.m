//
//  TGResultViewController.m
//  TGSearchController
//
//  Created by tangge on 16/5/22.
//  Copyright © 2016年 tangge. All rights reserved.
//

#import "TGResultViewController.h"

@interface TGResultViewController ()

@end

@implementation TGResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return self.resultArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    cell.textLabel.text = self.resultArr[indexPath.row];
    
    return cell;
}




@end
