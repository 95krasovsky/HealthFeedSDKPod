//
//  HFAssociatedCampaignObject.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/25/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFAssociatedCampaignObject.h"

@implementation HFAssociatedCampaignObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self) {
        self.campaignIDs = dictionary[@"campaignIDs"];
        self.articleID = dictionary[@"guid"];
        self.contentViewType = [dictionary[@"contentViewType"] integerValue];
        
    }
    
    return self;
}

@end
