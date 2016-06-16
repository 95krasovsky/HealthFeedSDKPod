//
//  HFCampaignsUIFactory.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/1/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCampaignsUIFactory.h"

@implementation HFCampaignsUIFactory

+ (HFCampaignView *)campaignViewForCampaignIgnorePermission:(HFCampaignItem *)campaign {
    if(!campaign){
        return nil;
    }
    
    switch (campaign.renderingType) {
        case HFCampaignRenderingTypeUnknown:
            return nil;
        case HFCampaignRenderingTypeInfeed:
            return [[HFInfeedCampaingView alloc]initWithCampaing:campaign];
        case HFCampaignRenderingTypeBannerBottom:
            return [[HFBottomBannerCampaignView alloc]initWithCampaing:campaign];
        case HFCampaignRenderingTypePopUpCenter:
            return [[HFPopupCampaignView alloc]initWithCampaing:campaign];
        case HFCampaignRenderingTypeFullPage:
            return [[HFFullScreenCampaignView alloc]initWithCampaing:campaign];
        case HFCampaignRenderingTypeLeaderboard:
            return [[HFLeaderboardCampaignView alloc]initWithCampaing:campaign];
    }
}

+ (HFCampaignView *)campaignViewForCampaign:(HFCampaignItem *)campaign {
    if(campaign.permissionHTML) {
        HFLeaderboardCampaignView *campaignView = [[HFLeaderboardCampaignView alloc]initWithCampaing:campaign];
        campaignView.showPermissionCampaign = YES;
        return campaignView;
    }
    
    return [self campaignViewForCampaignIgnorePermission:campaign];
}

@end
