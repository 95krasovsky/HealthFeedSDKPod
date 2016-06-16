//
//  AuthService.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/17/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "AuthService.h"
#import "AFOAuth2Manager.h"
#import "ApiUrlConfigurator.h"

@interface AuthService(){
    NSString *_serviceProviderIdentifier;
    AFOAuth2Manager *_oauthManager;
}

@end

@implementation AuthService

- (void)configurateWithApiKey:(NSString *)apiKey andApiSecret:(NSString*)apiSecret{
    NSURL *baseURL = [NSURL URLWithString:[ApiUrlConfigurator baseUrl]];
    NSURL *url = baseURL;
    _oauthManager = [AFOAuth2Manager managerWithBaseURL:url clientID:apiKey secret:apiSecret];
    _serviceProviderIdentifier = _oauthManager.serviceProviderIdentifier;
}

- (BOOL)isAuthorized{
    if ([AFOAuthCredential retrieveCredentialWithIdentifier:_serviceProviderIdentifier] == nil){
        return NO;
    }
    return YES;
}

- (BOOL)isExpired{
    AFOAuthCredential * credential = [AFOAuthCredential retrieveCredentialWithIdentifier:_serviceProviderIdentifier];
    if (credential == nil || [credential isExpired]){
        return NO;
    }
    return YES;
}

- (BOOL)isAuthorizedAndValid{
    return ![self isExpired];
}

- (void)authenticateWithCompletion:(AuthServiceAuthenticateCompletionHandler) completion {
    AFOAuthCredential * credential = [AFOAuthCredential retrieveCredentialWithIdentifier:_serviceProviderIdentifier];
    if (credential && ![credential isExpired]) {
        completion(credential, nil);
        return;
    }
    
    NSDictionary *parameters = @{@"grant_type" : kAFOAuthClientCredentialsGrantType};
    
    [_oauthManager authenticateUsingOAuthWithURLString:[ApiUrlConfigurator authUrlPath]
                                            parameters:parameters
                                               success:^(AFOAuthCredential * _Nonnull credential) {
                                                   _serviceProviderIdentifier = _oauthManager.serviceProviderIdentifier;
                                                   [AFOAuthCredential storeCredential:credential withIdentifier:_serviceProviderIdentifier];
                                                   if (completion) {
                                                       completion(credential, nil);
                                                   }
                                               } failure:^(NSError * _Nonnull error) {
                                                   completion(nil, error);
                                               }];
}

@end
