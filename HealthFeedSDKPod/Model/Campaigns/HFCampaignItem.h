//
//  HFCampaignItem.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/25/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

typedef NS_ENUM(NSUInteger, HFCampaignRenderingType) {
    HFCampaignRenderingTypeUnknown = 0,
    HFCampaignRenderingTypePopUpCenter = 1,
    HFCampaignRenderingTypeLeaderboard = 1 << 1,
    HFCampaignRenderingTypeBannerBottom = 1 << 2,
    HFCampaignRenderingTypeFullPage = 1 << 3,
    HFCampaignRenderingTypeInfeed = 1 << 4,
};

@interface HFCampaignItem : HFBaseModelObject

@property(nonatomic, strong)NSString *campaignID;
@property(nonatomic)HFCampaignRenderingType renderingType;
@property(nonatomic)NSTimeInterval presetAfter; 
@property(nonatomic, strong)NSString *campaignHTML;
@property(nonatomic, strong)NSString *permissionHTML;

@property(nonatomic)BOOL alreadyDisplayed;
@property(nonatomic)NSTimeInterval loadedTime;

@end
