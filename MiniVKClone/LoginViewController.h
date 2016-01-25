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
@interface LoginViewController : UIViewController<UIWebViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate,VKSdkUIDelegate,VKSdkDelegate>

@property (nonatomic, strong) UIScrollView *SV;
@property (nonatomic, strong) UIButton *vkButton;
@property (retain, nonatomic) UIActivityIndicatorView *loaderActivity;

@property (nonatomic, strong) UIWebView *web;
@property (nonatomic, strong) NSData *receivedData;
//@property (nonatomic) ACAccountStore *accountStore;


@end

