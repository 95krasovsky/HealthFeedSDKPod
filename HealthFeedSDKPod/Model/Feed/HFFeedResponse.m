//
//  HFFeedResponse.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFFeedResponse.h"
#import "ApiParams.h"
#import "HFFeedItem.h"

@implementation HFFeedResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self) {
        
        NSMutableArray *feedPosts = [NSMutableArray array];
        NSArray *data = dictionary[ApiParamData];
        
        for(NSDictionary *itemDictionary in data) {
            HFFeedItem *feedItem = [HFFeedItem objectWithDictionary:itemDictionary];
            [feedPosts addObject:feedItem];
        }
        
        self.articles = feedPosts;
    }
    return self;
}

@end
