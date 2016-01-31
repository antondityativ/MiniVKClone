//
//  MainStorage.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 31.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserManagedObject.h"
#import <CoreData/CoreData.h>

@interface MainStorage : NSObject

+(MainStorage *)sharedMainStorage;

- (void)createNewUser:(UserObject *)user;
- (NSString *)returnAccessToken;
-(void)createNews:(NewsModel *)model;

-(NSArray *)returnNews;
-(void)deleteNews;

-(NewsModel *)currentNewsObj:(NSString *)postID;

@property (nonatomic, strong, readonly) NewsModel *currentNewsObj;
@property (nonatomic, strong, readonly) UserObject *currentUser;

@end
