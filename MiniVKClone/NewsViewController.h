//
//  NewsViewController.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsTableViewCell.h"


@interface NewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UILabel *methodName;

@property(nonatomic, strong) VKRequest *callingRequest;

@end
