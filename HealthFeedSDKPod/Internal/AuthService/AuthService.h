//
//  AuthService.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/17/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AuthService, AFOAuthCredential;
@protocol AuthServiceDelegate <NSObject>

- (void)authService:(AuthService *)service accessTokenDidExpire:(NSString *)expiredAccessToken;
- (void)authService:(AuthService *)service accessTokenDidUpdate:(NSString *)updatedAccessToken;

@end

typedef void (^AuthServiceAuthenticateCompletionHandler)(AFOAuthCredential *credential, NSError *error);

@interface AuthService : NSObject

@property (nonatomic, weak) id<AuthServiceDelegate> delegate;

- (void)configurateWithApiKey:(NSString *)apiKey andApiSecret:(NSString*)apiSecret;
- (void)authenticateWithCompletion:(AuthServiceAuthenticateCompletionHandler) completion;

@end
