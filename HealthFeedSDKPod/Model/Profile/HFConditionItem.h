//
//  HFConditionItem.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

@interface HFConditionItem : HFBaseModelObject

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *displayName;
@property(nonatomic, strong) NSString *apiParam;
@property(nonatomic, strong) NSString *searchTerms;

@property(nonatomic, strong) NSArray *subConditionItems; //HFConditionItem

@end
