//
//  HFVaccine.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCodeStartEndPointTimeName.h"

@interface HFVaccine : HFCodeStartEndPointTimeName


@property(nonnull, strong) NSDecimalNumber *strength;
@property(nonnull, strong) NSString *strengthUnit;
@property(nonnull, strong) NSDecimalNumber *dose;
@property(nonnull, strong) NSNumber *vaccinationStatus; //(0 = on demand, 1 = continuous)

@end
