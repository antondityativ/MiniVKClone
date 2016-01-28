//
//  MenuViewController.m
//  Triathlon
//
//  Created by Aleksandr on 07/12/15.
//  Copyright © 2015 LiveTyping. All rights reserved.
//

#import "MenuViewController.h"
#import "NewsViewController.h"
#import "MenuTableViewCell.h"
#import "MyMusicViewController.h"
@interface MenuViewController ()

@property (nonatomic,strong) NSArray* titles;
@property (nonatomic,strong) NSArray* classes;

@end

@implementation MenuViewController

-(instancetype)init {
    self = [super init];
    if (self) {
        [self updateMenu];
    }
    return self;
}

-(void)updateMenu{
    _titles = @[@"News",
                @"Musics",
                @"Logout"];
    _classes = @[[NewsViewController class],
                 [MyMusicViewController class],
                 [UIButton class]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableView registerClass:[MenuTableViewCell class] forCellReuseIdentifier:@"menuCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"menuCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    if (_classes.count>0) {
        Class class = _classes[[NSIndexPath indexPathForRow:0 inSection:0].row];
        CenterViewController* vc = [(CenterViewController*)[class alloc] init];
        UINavigationController* nc = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.delegate=_mainViewController;
        [_mainViewController setCenteralView:nc];
//        [self openViewControllerWithIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableViewCell* ret = [tableView dequeueReusableCellWithIdentifier:@"menuCell" forIndexPath:indexPath];
    [ret.titleLabel setText:_titles[indexPath.row]];
    if (indexPath.row>1&&indexPath.section==0) {
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

    }
    return ret;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self openViewControllerWithIndexPath:indexPath];
}


-(void)openViewControllerWithIndexPath:(NSIndexPath*)index{
    if(index.row != 2) {
        Class class = _classes[index.row];
        CenterViewController* vc = [(CenterViewController*)[class alloc] init];
        UINavigationController* nc = [[UINavigationController alloc]initWithRootViewController:vc];
        vc.delegate=_mainViewController;
        [_mainViewController setCenteralView:nc];
        [vc.delegate showLeftPanel];
    }
    else {
        [VKSdk forceLogout];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}

@end
