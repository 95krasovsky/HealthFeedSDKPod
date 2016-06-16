//
//  HFCampaignItem.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/25/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCampaignItem.h"
#import "ApiParams.h"

@implementation HFCampaignItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self) {
        
        self.campaignID = dictionary[ApiParamCampaignID];
        self.campaignHTML = dictionary[ApiParamCampaignHTML];
        self.permissionHTML = dictionary[ApiParamCampaignPermissionHTML];
        double timeInMilliseconds = [dictionary[ApiParamCampaignPresetAfter] doubleValue];
        if(timeInMilliseconds > 0.0) {
            self.presetAfter = timeInMilliseconds / 1000.0;
        } else {
            self.presetAfter = 0;
        }
        self.renderingType = [dictionary[ApiParamCampaignRenderingType] integerValue];
    }
    
    return self;
}

- (id)copy {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if(self.campaignID) {
    dict[ApiParamCampaignID] = self.campaignID;
    }
    if(self.campaignHTML) {
        dict[ApiParamCampaignHTML] = self.campaignHTML;
    }
    if(self.permissionHTML) {
        dict[ApiParamCampaignPermissionHTML] = self.permissionHTML;
    }
    dict[ApiParamCampaignRenderingType] = @(self.renderingType);
    
    HFCampaignItem *item = [HFCampaignItem objectWithDictionary:dict];
    item.presetAfter = self.presetAfter;
    return item;
}

- (BOOL)isEqual:(id)object {
    if([object isKindOfClass:[self class]]) {
        return [self.campaignID isEqualToString:[(HFCampaignItem *)object campaignID]];
    }
    return NO;
}

@end
