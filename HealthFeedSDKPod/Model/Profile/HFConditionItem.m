//
//  HFConditionItem.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFConditionItem.h"
#import "ApiParams.h"

@implementation HFConditionItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self) {
        
        self.name = dictionary[ApiParamConditionName];
        self.displayName = dictionary[ApiParamConditionDisplayName];
        self.apiParam = dictionary[ApiParamConditionApiParam];
        self.searchTerms = dictionary[ApiParamConditionSearchTerms];
        
        NSArray *groups = dictionary[ApiParamConditionGroupConditions];
        NSArray *categories = dictionary[ApiParamConditionCategories];
        
        NSMutableArray *subitemsDictionaries = [NSMutableArray array];
        NSMutableArray *subitems = [NSMutableArray array];
        
        if(groups.count > 0) {
            [subitemsDictionaries addObjectsFromArray:groups];
        }
        if(categories.count > 0) {
            [subitemsDictionaries addObjectsFromArray:categories];
        }
        
        for(NSDictionary *dict in subitemsDictionaries) {
            [subitems addObject:[HFConditionItem objectWithDictionary:dict]];
        }
        
        self.subConditionItems = subitems;
    }
    return self;
}

+ (instancetype)objectWithDictionary:(NSDictionary *)dictionary {
    HFConditionItem *item = [[HFConditionItem alloc]initWithDictionary:dictionary];
    return item;
}

- (BOOL)isEqual:(id)object {
    if([object isKindOfClass:[self class]]) {
        return [self.apiParam isEqualToString:[(HFConditionItem *)object apiParam]];
    }
    return NO;
}

@end
