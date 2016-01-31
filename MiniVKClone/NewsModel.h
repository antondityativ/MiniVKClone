//
//  NewsModel.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 23.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewsModelObject : NSManagedObject

@property(copy,nonatomic)NSString *postID;
@property(copy,nonatomic)NSString *text;
@property(copy,nonatomic)NSString *likes;
@property(copy,nonatomic)NSString *reposts;
@property(copy,nonatomic)NSString *image;
@property(copy,nonatomic)NSString *date;
@property(copy,nonatomic)NSString *profileName;
@property(copy,nonatomic)NSString *profileAvatar;
//@property(copy,nonatomic)NSArray *photos;

@end

@interface NewsModel : NSObject

@property(strong,nonatomic)NSString *postID;
@property(strong,nonatomic)NSString *text;
@property(strong,nonatomic)NSString *likes;
@property(strong,nonatomic)NSString *reposts;
@property(strong,nonatomic)NSString *image;
@property(strong,nonatomic)NSString *date;
@property(strong,nonatomic)NSString *profileName;
@property(strong,nonatomic)NSString *profileAvatar;
//@property(strong,nonatomic)NSArray *photos;


-(void)updateWithDictionary:(NSDictionary *)dict;


@end
