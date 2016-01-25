//
//  ViewController.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "LoginViewController.h"


#define APP_DELEGATE            (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define ROOT_VIEW_CONTROLLER    (PRootViewController *)[APP_DELEGATE rootViewController]
#define SIDE_MENU_CONTROLLER    ((PZSideMenuViewController *)[(PRootViewController *)ROOT_VIEW_CONTROLLER sideMenuViewController])

#define VKid @"5237517"
static NSArray *SCOPE = nil;

@interface LoginViewController ()
@property(strong,nonatomic) VKRequest *callingRequest;
@end

@implementation LoginViewController

@synthesize loaderActivity = _loaderActivity;
int i = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES, VK_PER_NOTES,VK_PER_DOCS];
    [super viewDidLoad];
    [[VKSdk initializeWithAppId:VKid] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self startWorking];
        } else if (error) {
            [[[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
}

-(void)setupUI
{
    _SV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [_SV setBackgroundColor:[UIColor colorWithRed:239/255. green:239/255. blue:244/255. alpha:1.0]];
    [_SV setUserInteractionEnabled:YES];
    [_SV setScrollEnabled:YES];
    _SV.scrollsToTop = YES;
    [self.view addSubview:_SV];
    
    UILabel *upTitle = [[UILabel alloc] init];
    [upTitle setFrame:CGRectMake(28, 20, 300, 20)];
    [upTitle setText:@"Войдите через социальную сеть"];
    [upTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [upTitle setTextColor:[UIColor colorWithRed:109/255. green:109/255. blue:114/255. alpha:1.0]];
    [upTitle sizeToFit];
    [upTitle setFrame:CGRectMake(self.view.frame.size.width/2 - upTitle.frame.size.width/2, 20, upTitle.frame.size.width, upTitle.frame.size.height)];
    [_SV addSubview:upTitle];
    
    _vkButton = [[UIButton alloc] initWithFrame:CGRectMake(100, upTitle.frame.origin.y + upTitle.frame.size.height + 20, 62, 62)];
    [_vkButton setImage:[UIImage imageNamed:@"ic_vk"] forState:UIControlStateNormal];
    [_vkButton setImage:[UIImage imageNamed:@"ic_vk_fitback"] forState:UIControlStateHighlighted];
    [_vkButton setImage:[UIImage imageNamed:@"ic_vk_fitback"] forState:UIControlStateSelected];
    [_vkButton addTarget:self action:@selector(vkAuth) forControlEvents:UIControlEventTouchUpInside];
    [_SV addSubview:_vkButton];
    
    UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, CGRectGetMaxY(_vkButton.frame) + 30, 100, 50)];
    [changeBtn setTitle:@"Change user" forState:UIControlStateNormal];
    [changeBtn addTarget:self action:@selector(changeUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeBtn];
    
    _loaderActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loaderActivity.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2-self.navigationController.navigationBar.frame.size.height/2);
    [self.view addSubview:_loaderActivity];
}

-(void)changeUser {
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    [VKAccessToken delete:[session valueForKey:@"accessToken"]];
    [VKSdk authorize:SCOPE];
}

-(void)vkAuth
{
    [VKSdk authorize:SCOPE];
}


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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"API_CALL"]) {

    }
}

- (void)callMethod:(VKRequest *)method {

    [self performSegueWithIdentifier:@"API_CALL" sender:self];
}

-(void)startWorking {
    self->_callingRequest = [VKRequest requestWithMethod:@"newsfeed.get" parameters:@{@"user_id":@45898586,@"count":@100}];
    NewsViewController *vc = [[NewsViewController alloc] init];
    vc.callingRequest = self->_callingRequest;
    [self.navigationController pushViewController:vc animated:YES];
    self->_callingRequest = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
