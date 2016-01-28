//
//  RightViewController.h
//  Allure
//
//  Created by Evgeniy Orlov on 11.10.13.
//  Copyright (c) 2013 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RightViewDelegate <NSObject>

@end

@interface RightViewController : UIViewController

@property (nonatomic, assign) id<RightViewDelegate> delegate;

@end
