//
//  HFFeedMetadataElement.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFFeedMetadataElement.h"
#import "ApiParams.h"

@implementation HFFeedMetadataElement

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self) {
        self.type = [dictionary[ApiParamType] integerValue];
        self.message = dictionary[ApiParamMSG];
        self.response = dictionary[ApiParamResp];
    }
    
    return self;
}

@end
