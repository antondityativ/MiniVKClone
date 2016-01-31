//
//  NetworkMonitoring.h
//  Allure
//
//  Created by Evgeniy Orlov on 27.09.13.
//  Copyright (c) 2013 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import "Reachability.h"
#import "API.h"

@interface NetworkMonitoring : NSObject {
    Reachability *internetConnection;
    Reachability *hostConnection;
    
    NetworkStatus lastInternetConnectionStatus;
    NetworkStatus lastHostConnectionStatus;
    
//    UIAlertView *alertMessage;
}

+ (NetworkMonitoring *) sharedMonitoring;
- (void)startMonitoring;

- (void)receveNotification:(NSNotification *)notification;
- (NSString *)getNotificationInternetStatus;
- (NSString *)getNotificationHostStatus;
- (NSString *)getNotificationStatus;
- (BOOL)checkConnection;
//- (void)showMessage;

@end
