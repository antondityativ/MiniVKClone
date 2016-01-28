//
//  SlideNavigationMainController.h
//  Allure
//
//  Created by Evgeniy Orlov on 09.10.13.
//  Copyright (c) 2013 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CenterViewController.h"
#import "RightViewController.h"
#import "LeftViewController.h"

@interface SlideNavigationMainController : UIViewController {
    BOOL allowStopSliding;
}

- (void)setCenteralView:(CenterViewController *)view;
- (void)setLeftView:(LeftViewController *)viewController;
- (void)setRightView:(RightViewController *)viewController;

- (void)showControllerByAlpha;

- (void)hideControllers:(NSNotification *)notification;

@end
