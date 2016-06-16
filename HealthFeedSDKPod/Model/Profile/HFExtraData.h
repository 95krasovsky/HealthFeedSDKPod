//
//  HFExtraData.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/19/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

@interface HFExtraData : HFBaseModelObject

@property(nonnull, strong) NSString *codeSystem; //Code System, passed ‘CUSTOM’ if not provided
@property(nonnull, strong) NSString *name; //Name of the param e.g ‘Height’
@property(nonnull, strong) NSNumber *value; //Value of the param e.g ‘72’
@property(nonnull, strong) NSString *unit; //Unit of the param e.g ‘in’ for height
@property(nonnull, strong) NSDate *pointDateTime; //Time for the event
@property(nonnull, strong) NSDate *startDateTime; //Time for the event start
@property(nonnull, strong) NSDate *endDateTime; //Time for the event end

@end
