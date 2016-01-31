//
//  NetworkMonitoring.m
//  Allure
//
//  Created by Evgeniy Orlov on 27.09.13.
//  Copyright (c) 2013 Personal. All rights reserved.
//

#import "NetworkMonitoring.h"

@implementation NetworkMonitoring

NetworkMonitoring *sharedNetworkMonitoring = nil;

+ (NetworkMonitoring *) sharedMonitoring {
	if (sharedNetworkMonitoring == nil) {
		sharedNetworkMonitoring = [[NetworkMonitoring alloc] init];
        [sharedNetworkMonitoring startMonitoring];
	}
	return sharedNetworkMonitoring;
}

- (BOOL)checkConnection {
    if (lastInternetConnectionStatus != NotReachable && lastHostConnectionStatus != NotReachable) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)receveNotification:(NSNotification *)notification {
    if ([notification.name isEqualToString:kReachabilityChangedNotification]) {
        NetworkStatus internetStatus = [internetConnection currentReachabilityStatus];
        NetworkStatus hostStatus = [hostConnection currentReachabilityStatus];
        
        if ((lastInternetConnectionStatus == NotReachable && internetStatus != NotReachable) ||
            (lastHostConnectionStatus == NotReachable && hostStatus != NotReachable)) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationNetworkStatusChanged" object:nil];
        }
        if (lastInternetConnectionStatus != NotReachable && internetStatus == NotReachable) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationInternetStatusChanged" object:nil];
        }
        else if (lastHostConnectionStatus != NotReachable && hostStatus == NotReachable) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationHostStatusChanged" object:nil];
        }
        
        lastInternetConnectionStatus = internetStatus;
        lastHostConnectionStatus = hostStatus;
    }
}

- (void)startMonitoring {
    internetConnection = [Reachability reachabilityForInternetConnection];
    lastInternetConnectionStatus = [internetConnection currentReachabilityStatus];
    [internetConnection startNotifier];
    
    hostConnection = [Reachability reachabilityWithHostName:[[API sharedAPI] getPingUrl]];
    lastHostConnectionStatus = [hostConnection currentReachabilityStatus];
    [hostConnection startNotifier];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receveNotification:) name:kReachabilityChangedNotification object:nil];
}

- (NSString *)getNotificationInternetStatus {
    return @"NotificationInternetStatusChanged";
}

- (NSString *)getNotificationHostStatus {
    return @"NotificationHostStatusChanged";
}

- (NSString *)getNotificationStatus {
    return @"NotificationNetworkStatusChanged";
}

//- (void)showMessage {
//    UIAlertView *messageView = [[UIAlertView alloc] init];
//    
//    [messageView setTitle:@"Внимание"];
//    [messageView addButtonWithTitle:@"OK"];
//    [messageView setCancelButtonIndex:0];
//    
//    if ([internetConnection currentReachabilityStatus] == NotReachable) {
//        [messageView setMessage:@"Внимание! Для получение актуальной информации, подключите ваше устройство к интернету."];
//    }
//    else {
//        if ([hostConnection currentReachabilityStatus] == NotReachable) {
//            [messageView setMessage:@"Сервер не отвечает"];
//        }
//        else {
//            [messageView setMessage:@"Не удалось загрузить данные"];
//        }
//    }
//    [messageView show];
//}

@end
