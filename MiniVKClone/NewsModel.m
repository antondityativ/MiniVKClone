//
//  NewsModel.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 23.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModelObject

@dynamic text;
@dynamic likes;
@dynamic reposts;
@dynamic image;
@dynamic date;
@dynamic profileAvatar;
@dynamic profileName;
@dynamic postID;


@end

@implementation NewsModel

-(void)updateWithDictionary:(NSDictionary *)dict {
 

    
    NSInteger source_id = [[dict valueForKey:@"source_id"] integerValue];
    VKRequest *request;
    if(source_id < 0) {
          request = [[VKApi groups] getById:@{@"group_id":[NSNumber numberWithInteger:-source_id]}];
    }
    else {
        request = [[VKApi users] get:@{@"user_ids":[NSNumber numberWithInteger:source_id]}];
    }
    
    [request executeWithResultBlock:^(VKResponse *response) {
        if([[[response.json objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"group"] || [[[response.json objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"page"]) {
            VKGroup *group = [(VKGroups *) response.parsedModel objectAtIndex:0];
            self.profileName = group.name;
            self.profileAvatar = group.photo_50;
        }
        else {
            VKUser *user = [(VKUsersArray *) response.parsedModel objectAtIndex:0];
            self.profileName = [NSString stringWithFormat:@"%@ %@",user.first_name,user.last_name];
            self.profileAvatar = user.photo_100;
            if(self.profileAvatar == nil) {
                self.profileAvatar = user.photo_50;
            }
            if(self.profileAvatar == nil) {
                self.profileAvatar = user.photo_200;
            }
            if(self.profileAvatar == nil) {
                self.profileAvatar = user.photo_400_orig;
            }
            if(self.profileAvatar == nil) {
                self.profileAvatar = user.photo_max;
            }
            if(self.profileAvatar == nil) {
                self.profileAvatar = user.photo_max_orig;
            }
            if(self.profileAvatar == nil) {
                self.profileAvatar = user.photo_200_orig;
            }
            
        }
//        [[MainStorage sharedMainStorage] createNews:self];
    } errorBlock:^(NSError *error) {
        
    }];
    
    
    self.postID = [dict valueForKey:@"post_id"];
    
    if([[dict valueForKey:@"text"]isKindOfClass:[NSString class]]) {
        self.text = [dict valueForKey:@"text"];
    }
    if(![[dict valueForKey:@"likes"]isKindOfClass:[NSNull class]]) {
        self.likes = [[dict valueForKey:@"likes"] valueForKey:@"count"];
    }
    if(![[dict valueForKey:@"reposts"]isKindOfClass:[NSNull class]]) {
        self.reposts = [[dict valueForKey:@"reposts"] valueForKey:@"count"];
    }
    if(![[dict valueForKey:@"date"]isKindOfClass:[NSNull class]]) {
        self.date = [dict valueForKey:@"date"];
    }
//    if(![[dict valueForKey:@"attachments"]isKindOfClass:[NSNull class]]) {
//        self.photos = [dict valueForKey:@"attachments"];
//    }
    if(![[[[[dict valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"photo"] valueForKey:@"photo_807"] isKindOfClass:[NSNull class]]) {
        self.image = [[[[dict valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"photo"] valueForKey:@"photo_807"];
        if(self.image == nil) {
            self.image = [[[[dict valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"photo"] valueForKey:@"photo_604"];
        }
        if(self.image == nil) {
            self.image = [[[[dict valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"photo"] valueForKey:@"photo_1280"];
        }
        if(self.image == nil) {
            self.image = [[[[dict valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"photo"] valueForKey:@"photo_2056"];
        }
        if(self.image == nil) {
            self.image = [[[[dict valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"video"] valueForKey:@"photo_800"];
        }
        if(self.image == nil) {
            self.image = [[[[dict valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"video"] valueForKey:@"photo_640"];
        }
        if(self.image == nil) {
            self.image = [[[[dict valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"video"] valueForKey:@"photo_320"];
        }
        if(self.image == nil) {
            self.image = [[[[dict valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"video"] valueForKey:@"photo_130"];
        }
    }
    
}

@end
