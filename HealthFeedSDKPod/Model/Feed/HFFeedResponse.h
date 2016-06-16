//
//  HFFeedResponse.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

@interface HFFeedResponse : HFBaseModelObject

@property(nonatomic, strong) NSArray *articles; //Contains an array of "feed" with following elements

@end
