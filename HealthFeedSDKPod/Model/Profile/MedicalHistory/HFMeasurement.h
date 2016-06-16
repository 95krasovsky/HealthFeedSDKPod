//
//  HFMeasurement.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCodeStartEndPointTimeName.h"

@interface HFMeasurement : HFCodeStartEndPointTimeName

@property(nonnull, strong) NSString *value;
@property(nonnull, strong) NSString *unit;
@property(nonnull, strong) NSDecimalNumber *upperNormalLimit;
@property(nonnull, strong) NSDecimalNumber *lowerNormalLimit;

@end
