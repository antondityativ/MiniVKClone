//
//  CenterViewController.h
//  Allure
//
//  Created by Evgeniy Orlov on 09.10.13.
//  Copyright (c) 2013 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CenterViewDelegate <NSObject>

@optional
- (void)showRightPanel;
- (void)showLeftPanel;
- (BOOL)isShowingRightPanel;
- (BOOL)isShowingLeftPanel;

@required
- (void)movePanelToOriginalPosition;

@end

@interface CenterViewController : UIViewController

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, assign) id<CenterViewDelegate> delegate;
@property (assign, nonatomic)BOOL isMine;
@property(strong, nonatomic) NSString *typeScreen;

@end
