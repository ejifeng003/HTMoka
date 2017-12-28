//
//  SearchViewController.m
//  HCSortAndSearchDemo
//
//  Created by Caoyq on 16/3/28.
//  Copyright © 2016年 Caoyq. All rights reserved.
//

#import "ProjectSearchVC.h"
#import "ZYPinYinSearch.h"
#import "HCSortString.h"
#import "ProjectSearchModel.h"


@interface ProjectSearchVC ()<UISearchResultsUpdating>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *dataSource;/**<排序前的整个数据源*/
@property (strong, nonatomic) NSDictionary *allDataSource;/**<排序后的整个数据源*/
@property (strong, nonatomic) NSMutableArray *searchDataSource;/**<搜索结果数据源*/
@property (strong, nonatomic) NSArray *indexDataSource;/**<索引数据源*/

@end

@implementation ProjectSearchVC

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"项目列表";
    _dataSource = [NSMutableArray array];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = NO;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    //当前请求的数据
    [self initWithnetWork];

}

-(void)initWithnetWork
{
    [SPSVProgressHUD showWithStatus:@"加载中..."];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSLog(@"usernamsetUserIDe is %@",LLBUserInfo.userName);
   // NSDictionary *loginName = @{@"LoginName":LLBUserInfo.userName};
    [params setValue:LLBUserInfo.userName forKey:@"LoginName"];
  //  [params setJsonDic:loginName key:@"userNameVo"];
    
    [[NetworkManager sharedNetworkManager] requestGetProject:params success:^(id result){
        
        [SPSVProgressHUD dismiss];
        
        if (![result isKindOfClass:[NSDictionary class]]) {
            NSArray * modelArr = [ProjectSearchModel mj_objectArrayWithKeyValuesArray:result];
            
            for (int i=0; i<modelArr.count; i++) {
                [_dataSource addObject:modelArr[i]];
                
            }
            [self initData];

            [self.tableView reloadData];
        }
        [SPSVProgressHUD showSuccessWithStatus:@"加载成功"];
    } fail:^(NSString *errorMsg) {
        //显示网络异常
        [SPSVProgressHUD dismiss];
        
        [SPSVProgressHUD showErrorWithStatus:errorMsg];
        
    }];

}

- (void)dealloc {
    _searchController = nil;
    self.tableView = nil;
}

#pragma mark - Init
- (void)initData {
    _searchDataSource = [NSMutableArray new];
    NSMutableArray *titleArray = [NSMutableArray array];
    
    for (int i =0; i<_dataSource.count; i++) {
        ProjectSearchModel *model = _dataSource[i];
        //将数据的名称和编码拼接起来 到时候用的时候进行截取
        NSString *probjectStr = [NSString stringWithFormat:@"%@+%@",model.ProjectName,model.ProjectCode];
        [titleArray addObject:probjectStr];
    }
    
    _allDataSource = [HCSortString sortAndGroupForArray:titleArray PropertyName:@"name"];
    _indexDataSource = [HCSortString sortForStringAry:[_allDataSource allKeys]];
    
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.placeholder = @"搜索项目";
        _searchController.dimsBackgroundDuringPresentation = SPViewBackColor;
        //设置当前的背景的颜色
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.searchController.active) {
        return _indexDataSource.count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[section]];
        return value.count;
    }else {
        return _searchDataSource.count;
    }
}
//头部索引标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (!self.searchController.active) {
        return _indexDataSource[section];
    }else {
        return nil;
    }
}
//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!self.searchController.active) {
        return _indexDataSource;
    }else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
        NSArray *temp=[value[indexPath.row] componentsSeparatedByString:@"+"];
        cell.textLabel.text = temp[0];
        cell.textLabel.textColor = [UIColor grayColor];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, 2, screen_width-25, cell.contentView.frame.size.height-4)];
        backView.layer.cornerRadius = 3;
        backView.backgroundColor = [UIColor clearColor];
        backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        backView.layer.borderWidth =1;
        [cell.contentView addSubview:backView];
        
    }else{
        cell.textLabel.text = _searchDataSource[indexPath.row];
    }
    return cell;
}
//索引点击事件
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.searchController.active) {
        NSArray *value = [_allDataSource objectForKey:_indexDataSource[indexPath.section]];
        NSArray *temp=[value[indexPath.row] componentsSeparatedByString:@"+"];

        self.block(temp[0],temp[1]);
    }else{
        NSArray *temp=[_searchDataSource[indexPath.row] componentsSeparatedByString:@"+"];

        self.block(temp[0],temp[1]);
    }
    self.searchController.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchDelegate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //删除
    [_searchDataSource removeAllObjects];
    NSArray *ary = [HCSortString getAllValuesFromDict:_allDataSource];
    
    if (searchController.searchBar.text.length == 0) {
        [_searchDataSource addObjectsFromArray:ary];
    }else {
        ary = [ZYPinYinSearch searchWithOriginalArray:ary andSearchText:searchController.searchBar.text andSearchByPropertyName:@"name"];
        [_searchDataSource addObjectsFromArray:ary];
    }
    [self.tableView reloadData];
}

#pragma mark - block
- (void)didSelectedItem:(SelectedItem)block {
    self.block = block;
}

- (void)searchResult: (UISearchController *)searchController {
    //NSPredicate *precidate = [NSPredicate predicateWithFormat:@"displayName CONTAINS[cd] %@", searchController.searchBar.text];
    
}

@end

