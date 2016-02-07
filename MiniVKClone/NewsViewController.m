//
//  NewsViewController.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "NewsViewController.h"
#import <CoreData/CoreData.h>

@interface NewsViewController ()

@property(strong, nonatomic) UIBarButtonItem *logout;
@property(strong, nonatomic) UITableView *newsTableView;
@property(strong, nonatomic) NSMutableArray *newsArray;
@property(strong, nonatomic) NSString *string;
@property(strong, nonatomic) VKResponse *resp;
@property(strong, nonatomic) NewsModel *model;
@property(strong, nonatomic) UIActivityIndicatorView *ai;
@property (nonatomic) BOOL loadMoreNews;
@property (nonatomic) BOOL loadOldNews;

@property(strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NEWS";
    [self.view addSubview:self.ai];
    [self.view addSubview:self.newsTableView];
    self.navigationItem.leftBarButtonItem = self.logout;
    self.navigationController.navigationBar.translucent = NO;
    _newsArray = [NSMutableArray new];
    
    [self loadDataWithStartFrom:[NSNumber numberWithInteger:_newsArray.count]];
}

#pragma mark - loadData

- (void)loadDataWithStartFrom:(NSNumber *)startFrom {
    if([[NetworkMonitoring sharedMonitoring] checkConnection]) {
        [[MainStorage sharedMainStorage] deleteNews];
        VKRequest *callingRequest = [VKRequest requestWithMethod:@"newsfeed.get" parameters:@{VK_API_ACCESS_TOKEN:[[MainStorage sharedMainStorage] returnAccessToken],@"user_id":[MainStorage sharedMainStorage].currentUser.userId,@"count":@50,@"start_from":startFrom,@"filters":@"post"}];
        [callingRequest executeWithResultBlock:^(VKResponse *response)
         {

             if ([response.json isKindOfClass:[NSDictionary class]]) {
                 _newsArray = [NSMutableArray array];
                 NSArray *items = [response.json valueForKey:@"items"];
                 if (items.count > 0) {
                     for(NSDictionary *dict in items) {
                         _model = [NewsModel new];
                         [_model updateWithDictionary:dict];
                         [_newsArray addObject:_model];
                     }
                     _loadMoreNews = NO;
                 }else {
                     _loadMoreNews = YES;
                 }
                 [_ai stopAnimating];
                 [self.refreshControl endRefreshing];
                 for(NewsModel *model in _newsArray) {
                     [[MainStorage sharedMainStorage] createNews:model];
                 }
                 [_newsTableView reloadData];
             }
             else {
                 _newsArray = [[MainStorage sharedMainStorage] returnNews].copy;
                 [self.newsTableView reloadData];
             }
             
         }errorBlock:^(NSError *error) {
             NSLog(@"%@", error);
         }];
    }
    else {
        _newsArray = [[MainStorage sharedMainStorage] returnNews].copy;
        [self.newsTableView reloadData];
    }
}

#pragma mark - SetupUI

- (UIActivityIndicatorView *)ai {
    if (!_ai) {
        _ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_ai setCenter:CGPointMake(screenWidth/2, screenHeight/2)];
        [_ai startAnimating];
    }
    return _ai;
}

-(UIBarButtonItem *)logout {
    if(!_logout) {
        _logout = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone target:self action:@selector(logoutClick)];
    }
    return _logout;
}

-(UITableView *)newsTableView {
    if(!_newsTableView) {
        _newsTableView = [[UITableView alloc] init];
        _newsTableView.delegate = self;
        _newsTableView.dataSource = self;
        [_newsTableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_newsTableView addSubview:self.refreshControl];

    }
    return _newsTableView;
}

-(UIRefreshControl *)refreshControl {
    if(!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        _refreshControl.backgroundColor = [UIColor colorWithRed:0/255. green:165/255. blue:228/255. alpha:1];
        _refreshControl.tintColor = [UIColor whiteColor];
    }
    return _refreshControl;
}

#pragma mark - UITableView delegate


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsModel *model = [_newsArray objectAtIndex:indexPath.row];
    if(model.image == nil) {
        return 200;
    }
    return 350;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    
    NewsTableViewCell *cell = (NewsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setupCellFromNews:[_newsArray objectAtIndex:indexPath.row]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = (NewsTableViewCell*)[self.newsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    cell.alpha = 0.5f;
}
-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = (NewsTableViewCell*)[self.newsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    cell.alpha = 1.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailsViewController *detailsViewController = [DetailsViewController new];
    detailsViewController.model = [_newsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_loadMoreNews && scrollView.contentOffset.y > scrollView.contentSize.height - _newsTableView.bounds.size.height) {
        _loadMoreNews = YES;
        if (_newsArray.count >= 48) {
            [_ai startAnimating];
            [self loadDataWithStartFrom:[NSNumber numberWithInteger:_newsArray.count]];
        }
    }
}

#pragma mark - Actions


-(void)logoutClick {
    [VKSdk forceLogout];
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    [session setValue:nil forKey:@"accessToken"];
    [session synchronize];
    LoginViewController *vc = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - REFRESH

- (void)refresh:(UIRefreshControl *)refreshControl {
    NSArray *array = [NSMutableArray new];
    [self loadDataWithStartFrom:[NSNumber numberWithInteger:array.count]];
    
    if (refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MMM d, h:mm a"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                    forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }
}

#pragma mark - Other

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_newsTableView setFrame:CGRectMake(0, 0, screenWidth, screenHeight - navigationBarHeight - tabBarHeight)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
