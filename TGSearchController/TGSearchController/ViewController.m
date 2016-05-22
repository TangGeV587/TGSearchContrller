//
//  ViewController.m
//  TGSearchController
//
//  Created by tangge on 16/5/22.
//  Copyright © 2016年 tangge. All rights reserved.
//

#import "ViewController.h"
#import "TGResultViewController.h"
@interface ViewController ()<UISearchResultsUpdating,UISearchBarDelegate>
/** 数据源 */
@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UISearchController *searchController;
/** 显示搜索结果 */
@property(nonatomic,strong)TGResultViewController *resultVC;
@end

@implementation ViewController
#pragma mark - 懒加载
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        
        _dataArray = [NSMutableArray arrayWithArray:@[@"jack",@"lucy",@"tom",@"truck",@"lily"]];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    TGResultViewController *resultVC = [[TGResultViewController alloc] init];
    self.resultVC = resultVC;
    //初始化  负责显示搜索后的结果
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:resultVC];
    //负责更新resultViewController的对象，必须实现UISearchResultsUpdating协议
    self.searchController.searchResultsUpdater =self;
    //展示的时候，背景变暗。如果是在同一个view 中，则设为NO。默认为YES
    self.searchController.dimsBackgroundDuringPresentation = YES;
    //是否隐藏导航栏，默认为YES
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //表示UISearchController在present时，可以覆盖当前controller
    self.searchController.definesPresentationContext = YES;
    
    self.searchController.searchBar.delegate = self;
    self.resultVC.tableView.delegate = self;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    //去除多余行
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
}

#pragma mark - UISearchResultUpdating
//每次当SearchBar的成为firstResponser，或者searchBar的内容改变的时候，就会调用
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchText = searchController.searchBar.text;
    NSArray *searchResults = [self.dataArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        BOOL reuslt = NO;
        if ([(NSString *)evaluatedObject hasPrefix:searchText]) {
            
            return reuslt = YES;
        }
        return reuslt;
    }]];
    TGResultViewController *resultVC = (TGResultViewController *)searchController.searchResultsController;
    resultVC.resultArr = searchResults;
    [resultVC.tableView reloadData];
    
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self resignFirstResponder];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row] ;
    return cell;
}
- (IBAction)editClick {
    
    if (self.tableView.isEditing) {
        [self.tableView beginUpdates];
        //获取选中的cell
        NSArray *selectRows = [self.tableView indexPathsForSelectedRows];
        NSMutableIndexSet *indexPaths = [NSMutableIndexSet indexSet];
        for (NSIndexPath *path in selectRows) {
            
            [indexPaths addIndex:path.row];
            
        }
        [self.dataArray removeObjectsAtIndexes:indexPaths];
        [self.tableView deleteRowsAtIndexPaths:selectRows withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView setEditing:NO];
    }else
    {
        [self.tableView setEditing:YES];
    }
    
}

//实现这个方法就有左滑移除效果
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (tableView == self.tableView) {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }

}

- (NSString *) tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

@end
