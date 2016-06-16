//
//  HFAssociatedCampaignObject.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/25/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

@interface HFAssociatedCampaignObject : HFBaseModelObject

@property(nonatomic, strong)NSArray *campaignIDs;
@property(nonatomic, strong)NSString *articleID;
@property(nonatomic)NSInteger contentViewType;

@end
