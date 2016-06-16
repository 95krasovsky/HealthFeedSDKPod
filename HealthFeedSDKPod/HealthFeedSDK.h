//
//  HealthFeedSDK.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/23/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HFModel.h"
#import "HFContentManager.h"
#import "HFCampaignsManager.h"
#import "HFAPIClient.h"
#import "HFDataManager.h"
#import "HealthFeedViewController.h"

@interface HealthFeedSDK : NSObject

+ (instancetype)sharedInstance;

- (void)configurateWithApiKey:(NSString *)apiKey andApiSecret:(NSString*)apiSecret;

@end
