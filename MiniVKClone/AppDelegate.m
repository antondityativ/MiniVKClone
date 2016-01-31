//
//  AppDelegate.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "NewsViewController.h"
#import "MyMusicViewController.h"

@interface AppDelegate ()

@property(strong, nonatomic) LoginViewController *vc;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setBackgroundColor:[UIColor whiteColor]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"accessToken"] == nil) {
        _vc = [[LoginViewController alloc] init];
        UINavigationController *navigationControllerForAuth = [[UINavigationController alloc]initWithRootViewController:_vc];
        self.window.rootViewController = navigationControllerForAuth;
    }
    else {
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
        self.window.rootViewController = tabBar;
    }
    
    [VKSdk initializeWithAppId:VKid];
    
    [self.window makeKeyAndVisible];

    // Override point for customization after application launch.
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [VKSdk processOpenURL:url fromApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

@end
