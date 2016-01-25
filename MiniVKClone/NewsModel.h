//
//  NewsModel.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 23.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

-(void)updateWithDictionary:(NSDictionary *)dict;

@property(strong,nonatomic)NSString *text;
@property(strong,nonatomic)NSString *likes;
@property(strong,nonatomic)NSString *reposts;
@property(strong,nonatomic)NSString *image;
@property(strong,nonatomic)NSString *date;


@end
