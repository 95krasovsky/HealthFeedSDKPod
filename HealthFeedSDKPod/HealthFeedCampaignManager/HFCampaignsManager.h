//
//  HFCampaignsManager.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/26/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFApiClient.h"
#import "HFModel.h"
#import "HFCampaignsUIFactory.h"
#import "HFCampaignItem.h"
#import "HFCampaignDelegate.h"

@class HFFeedItem;

@interface HFCampaignsManager : NSObject

@property(readonly)NSArray *allQualifiedCampaigns;
@property(readonly)NSArray *allAlreadyShowedCampaigns;

@property(readonly)NSArray *lastQualifiedCampaigns;

@property(readonly)NSArray *currentDisplayedCampaigns;

@property(nonatomic)HFCampaignRenderingType allowedQualifiedCampaigns; //Default is all types expect Unknown,
@property(nonatomic)BOOL showQualifiedCampaignsAutomattically; //Default NO
@property(nonatomic)BOOL showOnlyLastLoadedQualifiedCampaigns; //Default YES

@property(nonatomic, weak) id<HFCampaignDelegate> delegate;

+ (instancetype)sharedInstance;

- (void)loadCampaigns;
- (void)loadCampaignsWithCompletion:(CompletionHandler)completion;
- (void)loadCampaignsForFeedResponse:(HFFeedResponse *)feedresponse completion:(CompletionHandler)completion;
- (void)loadCampaignsForFeedResponse:(HFFeedResponse *)feedresponse withCompletion:(CampaignsCompletionHandler)completion;

- (HFCampaignView *)showNextQualifiedCampaign;
- (HFCampaignView *)showNextQualifiedCampaignForType:(HFCampaignRenderingType)type;
- (HFCampaignView *)showQualifiedCampaign:(HFCampaignItem *)campaign;

- (HFCampaignView *)viewForCampaign:(HFCampaignItem *)campaign;

@end
