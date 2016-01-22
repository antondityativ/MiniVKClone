//
//  ViewController.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "API.h"

@interface LoginViewController : UIViewController<UIWebViewDelegate, UITextFieldDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>
{
    UIScrollView *SV;
    
    UIButton *okButton;
    UIButton *vkButton;
    UIButton *fbButton;
    UIButton *twitterButton;
    UIButton *login;
    UIButton *registration;
    
    UITextField *email;
    UITextField *pass;
    
    UIWebView *loginWebView;
    
    NSString *user_id;
    NSString *access_token;
    
    BOOL isCaptcha;
    
    CGSize keyboardSize;
}
@property (retain, nonatomic) UIActivityIndicatorView *loaderActivity;

@property (nonatomic, strong) UIWebView *web;
@property (nonatomic, strong) NSData *receivedData;
//@property (nonatomic) ACAccountStore *accountStore;


@end

