//
//  HFBaseModelObject.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HFBaseModelObject : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary;

@end
