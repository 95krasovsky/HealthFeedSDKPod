//
//  HFCampaignsUIFactory.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/1/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFCampaignItem.h"
#import "HFPopupCampaignView.h"
#import "HFInfeedCampaingView.h"
#import "HFLeaderboardCampaignView.h"
#import "HFFullScreenCampaignView.h"
#import "HFBottomBannerCampaignView.h"

@interface HFCampaignsUIFactory : NSObject

+ (HFCampaignView *)campaignViewForCampaign:(HFCampaignItem *)campaign;
+ (HFCampaignView *)campaignViewForCampaignIgnorePermission:(HFCampaignItem *)campaign;

@end
