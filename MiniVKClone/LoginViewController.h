//
//  ViewController.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"
#import "NewsViewController.h"
#import "SlideNavigationMainController.h"
#import "MenuViewController.h"
@interface LoginViewController : UIViewController<UIWebViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate,VKSdkUIDelegate,VKSdkDelegate>

@end

