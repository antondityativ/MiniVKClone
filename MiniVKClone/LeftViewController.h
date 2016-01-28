//
//  LeftViewController.h
//  Allure
//
//  Created by Evgeniy Orlov on 11.10.13.
//  Copyright (c) 2013 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftViewDelegate <NSObject>

@end

@interface LeftViewController : UIViewController

@property (nonatomic, assign) id<LeftViewDelegate> delegate;

@end
