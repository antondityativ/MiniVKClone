//
//  NewsTableViewCell.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 23.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderView.h"
#import "WebImageView.h"

@interface NewsTableViewCell : UITableViewCell

-(void)setupCellFromNews:(NewsModel *)model;
@property(strong,nonatomic)WebImageView *imageViewq;

@end
