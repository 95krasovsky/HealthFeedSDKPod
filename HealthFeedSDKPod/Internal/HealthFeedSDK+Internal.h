//
//  HealthFeedSDK+Internal.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/23/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HealthFeedSDK.h"

@class AuthService;

@interface HealthFeedSDK(Internal)

- (AuthService *)authService;

@end
