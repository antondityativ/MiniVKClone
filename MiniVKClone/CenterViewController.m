//
//  CenterViewController.m
//  Allure
//
//  Created by Evgeniy Orlov on 09.10.13.
//  Copyright (c) 2013 Personal. All rights reserved.
//

#import "CenterViewController.h"

@interface CenterViewController ()



@end

@implementation CenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addGestureRecognizer:self.tap];    
	// Do any additional setup after loading the view.
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    }
    return _tap;
}

#pragma mark Actions
- (void)tapAction {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
