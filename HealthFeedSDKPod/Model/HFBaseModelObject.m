//
//  HFBaseModelObject.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

@implementation HFBaseModelObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    HFBaseModelObject *object = [[self alloc]initWithDictionary:dictionary];
    return object;
}

@end
