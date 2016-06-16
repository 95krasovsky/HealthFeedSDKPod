//
//  Header.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/13/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFModel.h"

@class HFInfeedCampaingView;

@protocol HFCampaignDelegate <NSObject>

@optional
- (BOOL)shouldAutomaticallyShowCampaign:(HFCampaignItem *)campaign;
- (BOOL)showInfeedCampaignView:(HFInfeedCampaingView *)campaignView;

- (void)didShowCampaign:(HFCampaignItem *)campaign;
- (void)didHideCampaign:(HFCampaignItem *)campaign;
- (void)didCloseCampaign:(HFCampaignItem *)campaign;

- (void)didCall2Action:(NSString *)action params:(NSDictionary *)params forCampaign:(HFCampaignItem *)campaign;

@end
