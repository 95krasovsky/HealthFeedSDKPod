//
//  HFAnalyticsEngine.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/10/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFAnalyticsEngine.h"

@implementation HFAnalyticsEngine

+ (instancetype)sharedInstance {
    static HFAnalyticsEngine *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[HFAnalyticsEngine alloc] init];
    });
    return _sharedInstance;
}

@end
