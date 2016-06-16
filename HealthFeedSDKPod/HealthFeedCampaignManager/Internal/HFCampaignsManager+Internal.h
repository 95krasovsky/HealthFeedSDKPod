//
//  HFCampaignsManager+Internal.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/14/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCampaignsManager.h"

@interface HFCampaignsManager(Internal)

- (void)addToCurrentDisplayCampaigns:(HFCampaignItem *)campaign;
- (void)removeFromCurrentDisplayCampaigns:(HFCampaignItem *)campaign;

@end
