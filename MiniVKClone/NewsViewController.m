//
//  NewsViewController.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@property(strong, nonatomic) UIBarButtonItem *logout;
@property(strong, nonatomic) UITableView *newsTableView;
@property(strong, nonatomic) NSMutableArray *newsArray;
@property(strong, nonatomic) NSString *string;
@property(strong, nonatomic) VKResponse *resp;
@property(strong, nonatomic) NewsModel *model;
@property (nonatomic, strong) UIActivityIndicatorView *ai;
@property (nonatomic) BOOL loadMoreNews;
@property (nonatomic) BOOL loadOldNews;

@property(strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.logout;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"NEWS";
    
    [self.view addSubview:self.ai];
    [self.view addSubview:self.newsTableView];
    _newsArray = [NSMutableArray new];
    
    [self loadData];
}

#pragma mark - loadData

- (void)loadData {
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    __weak __typeof(self) welf = self;
        self.callingRequest = [VKRequest requestWithMethod:@"newsfeed.get" parameters:@{@"user_id":[session valueForKey:@"user_id"],@"count":@50,@"start_from":[NSNumber numberWithInteger:_newsArray.count],@"filters":@"post"}];
    [self.callingRequest executeWithResultBlock:^(VKResponse *response)
    {
        if ([response.json isKindOfClass:[NSDictionary class]]) {
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
            [_newsTableView reloadData];
        }

        welf.callingRequest = nil;
    }                                errorBlock:^(NSError *error) {
        welf.callingRequest = nil;
    }];
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
    [cell setupCellFromNews:[_newsArray objectAtIndex:indexPath.row]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailsViewController *detailsViewController = [DetailsViewController new];
    detailsViewController.model = [_newsArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_loadMoreNews && scrollView.contentOffset.y > scrollView.contentSize.height - _newsTableView.bounds.size.height) {
        _loadMoreNews = YES;
        if (_newsArray.count >= 50) {
            [_ai startAnimating];
            [self loadData];
        }
    }
}

#pragma mark - Actions

-(void)logoutClick {
    [VKSdk forceLogout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


#pragma mark - REFRESH

- (void)refresh:(UIRefreshControl *)refreshControl {
    _newsArray = [NSMutableArray new];
    [self loadData];
    
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
    
    [_newsTableView setFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
