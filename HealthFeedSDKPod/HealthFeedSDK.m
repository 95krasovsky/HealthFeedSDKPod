//
//  HealthFeedSDK.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/23/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HealthFeedSDK.h"
#import "AFOAuthCredential.h"
#import "AuthService.h"
#import "HealthFeedApiClient/HFAPIClient.h"

@class AFOAuth2Client;

@interface HealthFeedSDK() {
    NSString *_apiKey;
    NSString *_apiSecret;
    
    AFOAuthCredential *_credential;
    AuthService *_authService;
}

@end

@implementation HealthFeedSDK

+ (instancetype)sharedInstance {
    static HealthFeedSDK *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[HealthFeedSDK alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _authService = [[AuthService alloc]init];
    }
    return self;
}

#pragma mark - Public
- (void)configurateWithApiKey:(NSString *)apiKey andApiSecret:(NSString *)apiSecret {
    _apiKey = apiKey;
    _apiSecret = apiSecret;
    [_authService configurateWithApiKey:apiKey andApiSecret:_apiSecret];
}

@end

@implementation HealthFeedSDK(Internal)

- (AuthService *)authService {
    return _authService;
}

@end
