//
//  NSDate+HF.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/19/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "NSDate+HF.h"

@implementation NSDate(HF)

- (long)timeIntervalSince1970inMilliseconds {
    return (long)(self.timeIntervalSince1970 * 1000);
}

@end
