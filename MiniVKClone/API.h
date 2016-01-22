//
//  API.h
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import <Foundation/Foundation.h>

#define baseUrlAPI                       @"http://46.36.221.253"

@interface API : NSObject

+ (API *)sharedAPI;


typedef void (^socialRegisterCompletion)(NSArray *responseRegister, NSError *error);

- (void)socialRegisterWithCompletion:(socialRegisterCompletion)socialRegisterComplete WithClientId:(NSString *)clientId WithSocialType:(NSString *)socialType;

@end
