//
//  SearchViewController.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 07.02.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "SearchViewController.h"
#import "MusicTableViewCell.h"
#import "PlayerViewController.h"

@interface SearchViewController ()

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *musicArray;

@property (nonatomic, strong) UIActivityIndicatorView *ai;

@property (nonatomic) BOOL loadMoreAudio;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.view setBackgroundColor:[UIColor blackColor]];
    _musicArray = [NSMutableArray new];
    [self subscribeToNotifications];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)setupUI {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.ai];
    [_searchBar becomeFirstResponder];
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        [_searchBar setDelegate:self];
        [_searchBar setBackgroundColor:[UIColor blackColor]];
        [_searchBar setTintColor:[UIColor blackColor]];
        [_searchBar setBarTintColor:[UIColor blackColor]];
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame), screenWidth, screenHeight - statusBarOffset - CGRectGetHeight(_searchBar.frame)) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView registerClass:[MusicTableViewCell class] forCellReuseIdentifier:@"cell"];
        [_tableView setSeparatorColor:[UIColor colorWithWhite:1.0 alpha:0.7]];
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }
    return _tableView;
}

- (UIActivityIndicatorView *)ai {
    if (!_ai) {
        _ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _ai;
}

#pragma mark TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 63.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[MusicTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell setupCellWithAudio:[_musicArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PlayerViewController *player = [[PlayerViewController alloc] init];
    player.currentMusicIndex = indexPath.row;
    player.musicArray = _musicArray;
    [self.navigationController presentViewController:player animated:YES completion:^{
        
    }];
}

#pragma mark Search
- (void)searchWithText:(NSString *)text {
    NSDictionary *dict = @{VK_API_ACCESS_TOKEN : [[MainStorage sharedMainStorage] returnAccessToken], VK_API_OWNER_ID : [MainStorage sharedMainStorage].currentUser.userId, @"count" : [NSNumber numberWithInt:100], @"offset" : [NSNumber numberWithInteger:_musicArray.count], @"search_own" : [NSNumber numberWithBool:YES], @"auto_complete" : [NSNumber numberWithBool:YES], @"q" : text};
    VKRequest *audioRequest = [VKRequest requestWithMethod:@"audio.search" parameters:dict];
    [audioRequest executeWithResultBlock:^(VKResponse *response) {
        if ([response.json isKindOfClass:[NSDictionary class]]) {
            NSArray *items = [response.json valueForKey:@"items"];
            if (items.count > 0) {
                for(NSDictionary *dict in items) {
                    AudioObject *audio = [[AudioObject alloc] init];
                    [audio updateWithDictionary:dict];
                    [_musicArray addObject:audio];
                }
                [_tableView reloadData];
                _loadMoreAudio = NO;
            }else {
                _loadMoreAudio = YES;
            }
            [_ai stopAnimating];
            
        }
    } errorBlock:^(NSError *error) {
        
    }];
}

#pragma mark SearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [_musicArray removeAllObjects];
    [_ai startAnimating];
    [self searchWithText:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [_musicArray removeAllObjects];
    [_tableView reloadData];
}

#pragma mark Notifications
- (void)subscribeToNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    [self configureWithKeyboardNotification:notification];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (![self.navigationController.viewControllers containsObject:self]) {
        return;
    }
    [self configureWithKeyboardNotification:notification];
}

- (void)configureWithKeyboardNotification:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];
    
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    [UIView animateKeyframesWithDuration:0.25 delay:0.0 options:458752 animations:^{
        if (notification.name == UIKeyboardWillHideNotification) {
            [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, screenHeight - statusBarOffset - 40)];
        }else {
            [_tableView setFrame:CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, [UIScreen mainScreen].bounds.size.height - keyboardEndFrame.size.height - statusBarOffset - 40)];
        }
    } completion:nil];
}

#pragma mark ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!_loadMoreAudio && scrollView.contentOffset.y > scrollView.contentSize.height - _tableView.bounds.size.height) {
        _loadMoreAudio = YES;
        if (_musicArray.count >= 100) {
            [_ai startAnimating];
            //            [scrollView setContentSize:CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + _ai.frame.size.height*3)];
            [self searchWithText:_searchBar.text];
        }
    }
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [_searchBar setFrame:CGRectMake(0, 20, screenWidth, 40)];
    [_tableView setFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame), screenWidth, screenHeight - statusBarOffset - CGRectGetHeight(_searchBar.frame))];
    [_ai setCenter:CGPointMake(screenWidth/2, screenHeight/2)];
}

#pragma mark Others
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
