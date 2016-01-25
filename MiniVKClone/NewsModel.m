//
//  NewsModel.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 23.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

-(void)updateWithDictionary:(NSDictionary *)dict {
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
            self.image = [[[[dict valueForKey:@"attachments"] objectAtIndex:0] valueForKey:@"video"] valueForKey:@"photo_640"];
        }
    }

    
    NSInteger source_id = [[dict valueForKey:@"source_id"] integerValue];
    NSLog(@"%li", (long)source_id);
    VKRequest *request;
    if(source_id < 0) {
          request = [[VKApi groups] getById:@{@"group_id":[NSNumber numberWithInteger:-source_id]}];
    }
    else {
        request = [[VKApi users] get:@{@"user_ids":[NSNumber numberWithInteger:source_id]}];
    }
    
    [request executeWithResultBlock:^(VKResponse *response) {
        if([[[response.json objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"group"]) {
            self.profileName = [[response.json objectAtIndex:0]valueForKey:@"name"];
            self.profileAvatar = [[response.json objectAtIndex:0]valueForKey:@"photo_50"];
        }
        else if ([[[response.json objectAtIndex:0]valueForKey:@"type"]isEqualToString:@"page"]) {
            self.profileName = [[response.json objectAtIndex:0]valueForKey:@"name"];
            self.profileAvatar = [[response.json objectAtIndex:0]valueForKey:@"photo_50"];
        }
        else {
            self.profileName = [NSString stringWithFormat:@"%@ %@", [[response.json objectAtIndex:0]valueForKey:@"first_name"],[[response.json objectAtIndex:0]valueForKey:@"last_name"]];
            self.profileAvatar = [[response.json objectAtIndex:0]valueForKey:@"photo_100"];
            if(self.profileAvatar == nil) {
                self.profileAvatar = [[response.json objectAtIndex:0]valueForKey:@"photo_50"];
            }
            if(self.profileAvatar == nil) {
                self.profileAvatar = [[response.json objectAtIndex:0]valueForKey:@"photo_200"];
            }
            
        }
    } errorBlock:^(NSError *error) {
        
    }];
    
}

@end
