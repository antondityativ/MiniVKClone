//
//  API.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "API.h"
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation API

API *sharedAPI = nil;

+ (API *)sharedAPI {
    if (sharedAPI == nil) {
        sharedAPI = [[API alloc] init];
    }
    return sharedAPI;
}

- (NSString *)getUrlAPI {
    return [NSString stringWithFormat:@"%@", baseUrlAPI];
}


-(void)socialRegisterWithCompletion:(socialRegisterCompletion)socialRegisterComplete WithClientId:(NSString *)clientId WithSocialType:(NSString *)socialType {
        AFHTTPRequestOperationManager *currentRequestManager = [AFHTTPRequestOperationManager manager];
        [currentRequestManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
        
        currentRequestManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSString *urlRequest = [NSString stringWithFormat:@"%@/socialauth", [self getUrlAPI]];
        
        NSString *cid = @"clientId";
        NSString *type = @"socialType";
        
        NSMutableString *data = [NSMutableString stringWithString:cid];
        [data appendString:clientId];
        [data appendString:type];
        [data appendString:socialType];
        
        NSString *secret = @"Jh5KlOAOyW95fSi1Gix3";
        
        const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
        const char *cKey = [secret cStringUsingEncoding:NSASCIIStringEncoding];
        
        unsigned char cHMAC[32];
        CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
        
        NSMutableString *key  = [NSMutableString string];
        for (int i=0; i < sizeof cHMAC; i++) {
            [key appendFormat:@"%02hhx", cHMAC[i]];
        }
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setValue:clientId forKey:@"clientId"];
        [dictionary setValue:socialType forKey:@"socialType"];
        [dictionary setValue:key forKey:@"key"];
        
        [currentRequestManager POST:urlRequest parameters:dictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSArray *responseRegister = (NSArray *)responseObject;
            if (socialRegisterComplete) {
                socialRegisterComplete (responseRegister, nil);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            socialRegisterComplete (nil, error);
            NSLog(@"socialRegister %@", error);
        }];
}


@end
