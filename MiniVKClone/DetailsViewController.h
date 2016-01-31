//
//  DetailsViewController.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 25.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController <UIScrollViewDelegate>

@property(strong, nonatomic)NewsModel *model;

@end
