//
//  ViewController.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "LoginViewController.h"
#import "MyMusicViewController.h"

#define VKid @"5237517"
static NSArray *SCOPE = nil;

@interface LoginViewController ()

@property(strong,nonatomic) UIButton *vkButton;
@property(strong,nonatomic) UIActivityIndicatorView *loaderActivity;
@property(strong,nonatomic) VKRequest *callingRequest;
@property(strong,nonatomic) UILabel *upTitle;
@end

@implementation LoginViewController

int i = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    self.title = @"LOGIN";
    self.navigationController.navigationBar.translucent = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - SetupUI

-(UILabel *)upTitle {
    if(!_upTitle) {
        _upTitle = [[UILabel alloc] init];
        [_upTitle setText:@"Войдите через социальную сеть"];
        [_upTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
        [_upTitle setTextColor:[UIColor colorWithRed:109/255. green:109/255. blue:114/255. alpha:1.0]];
        [_upTitle sizeToFit];
    }
    return _upTitle;
}

-(UIButton *)vkButton {
    if(!_vkButton) {
        _vkButton = [[UIButton alloc] init];
        [_vkButton setImage:[UIImage imageNamed:@"ic_vk"] forState:UIControlStateNormal];
        [_vkButton setImage:[UIImage imageNamed:@"ic_vk_fitback"] forState:UIControlStateHighlighted];
        [_vkButton setImage:[UIImage imageNamed:@"ic_vk_fitback"] forState:UIControlStateSelected];
        [_vkButton addTarget:self action:@selector(vkAuth) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vkButton;
}

-(UIActivityIndicatorView *)loaderActivity {
    if(!_loaderActivity) {
        _loaderActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loaderActivity.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2-self.navigationController.navigationBar.frame.size.height/2);
    }
    return _loaderActivity;
}

-(void)setupUI
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.upTitle];
    
    [self.view addSubview:self.vkButton];
    
    [self.view addSubview:self.loaderActivity];
}

#pragma mark - VK delegate

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    [self vkAuth];
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:result.token.accessToken forKey:@"accessToken"];
        [userDefaults synchronize];
        UserObject *user = [[UserObject alloc] init];
        [user updateWithUser:result.user];
        [[MainStorage sharedMainStorage] createNewUser:user];
        [self startWorking];
    } else if (result.error) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Access denied\n%@", result.error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)vkSdkUserAuthorizationFailed {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Actions

-(void)startWorking {
    
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    MyMusicViewController *musicVC = [[MyMusicViewController alloc] init];
    
    UINavigationController *navigationControllerNews = [[UINavigationController alloc]initWithRootViewController:newsVC];
    UINavigationController *navigationControllerMusic = [[UINavigationController alloc]initWithRootViewController:musicVC];
    UITabBarController *tabBar = [[UITabBarController alloc] init];
    tabBar.viewControllers = @[navigationControllerNews,navigationControllerMusic];
    UITabBarItem *tabNews = [[UITabBarItem alloc] initWithTitle:@"News" image:[UIImage imageNamed:@"tenantTabBarActive"] tag:1];
    UITabBarItem *tabMusic = [[UITabBarItem alloc] initWithTitle:@"My Music" image:[UIImage imageNamed:@"contactsIcon"] tag:2];
    [navigationControllerNews setTabBarItem:tabNews];
    [navigationControllerMusic setTabBarItem:tabMusic];
    [self.navigationController pushViewController:tabBar animated:YES];
}

-(void)vkAuth
{
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_NOTES,VK_PER_DOCS];
    [[VKSdk initializeWithAppId:VKid] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk authorize:SCOPE];
}

#pragma mark - Others

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_upTitle sizeToFit];
    [_upTitle setFrame:CGRectMake(self.view.frame.size.width/2 - _upTitle.frame.size.width/2, 20, _upTitle.frame.size.width, _upTitle.frame.size.height)];
    [_vkButton setFrame:CGRectMake(screenWidth/2 - 31, _upTitle.frame.origin.y + _upTitle.frame.size.height + 20, 62, 62)];
}


@end
