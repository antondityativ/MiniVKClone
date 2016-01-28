//
//  ViewController.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "LoginViewController.h"

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
    self.navigationController.navigationBar.translucent = YES;
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_NOTES,VK_PER_DOCS];
    [super viewDidLoad];
    [[VKSdk initializeWithAppId:VKid] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
//            [self startWorking];
        } else if (error) {
            [[[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}


#pragma mark - SetupUI

-(UILabel *)upTitle {
    if(!_upTitle) {
        _upTitle = [[UILabel alloc] init];
        [_upTitle setFrame:CGRectMake(28, 20, 300, 20)];
        [_upTitle setText:@"Войдите через социальную сеть"];
        [_upTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
        [_upTitle setTextColor:[UIColor colorWithRed:109/255. green:109/255. blue:114/255. alpha:1.0]];
        [_upTitle sizeToFit];
        [_upTitle setFrame:CGRectMake(self.view.frame.size.width/2 - _upTitle.frame.size.width/2, 20, _upTitle.frame.size.width, _upTitle.frame.size.height)];
    }
    return _upTitle;
}

-(UIButton *)vkButton {
    if(!_vkButton) {
        _vkButton = [[UIButton alloc] initWithFrame:CGRectMake(100, _upTitle.frame.origin.y + _upTitle.frame.size.height + 20, 62, 62)];
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
    [self.view addSubview:self.upTitle];
    
    [self.view addSubview:self.vkButton];
    
    [self.view addSubview:self.loaderActivity];
}

#pragma mark - VK delegate

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    [self vkAuth];
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:result.token.accessToken forKey:@"accessToken"];
        [userDefaults setObject:result.user.id forKey:@"user_id"];
        [userDefaults synchronize];
        UserObject *user = [[UserObject alloc] init];
        [user updateWithUser:result.user];
        [self startWorking];
    } else if (result.error) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Access denied\n%@", result.error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
}

- (void)vkSdkUserAuthorizationFailed {
    [[[UIAlertView alloc] initWithTitle:nil message:@"Access denied" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [self.navigationController.topViewController presentViewController:controller animated:YES completion:nil];
}

- (void)callMethod:(VKRequest *)method {

    [self performSegueWithIdentifier:@"API_CALL" sender:self];
}

#pragma mark - Actions

-(void)startWorking {
    self->_callingRequest = [VKRequest requestWithMethod:@"newsfeed.get" parameters:@{@"user_id":@45898586,@"count":@100}];
    UINavigationController* nc = [[UINavigationController alloc] init];
    SlideNavigationMainController *snc = [[SlideNavigationMainController alloc]init];
    [snc setCenteralView:nc];
    MenuViewController* mvc;
    mvc = [[MenuViewController alloc]init];
    
    mvc.mainViewController = snc;
    
    [snc setLeftView:mvc];
    [self.navigationController pushViewController:snc animated:YES];
}

-(void)vkAuth
{
    [VKSdk authorize:SCOPE];
}

#pragma mark - Others

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
