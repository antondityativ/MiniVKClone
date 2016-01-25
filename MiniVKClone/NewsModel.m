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
}

@end
