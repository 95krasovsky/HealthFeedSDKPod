//
//  HFMedication.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCodeStartEndPointTimeName.h"
#import "HFLastPrescription.h"

@interface HFMedication : HFCodeStartEndPointTimeName


@property(nonnull, strong) NSDecimalNumber *strength;
@property(nonnull, strong) NSString *strengthUnit;
@property(nonnull, strong) HFBaseCode *administrationRoute; // for future use
@property(nonnull, strong) NSDecimalNumber *dailyDose;
@property(nonnull, strong) NSNumber *drugStatus;
@property(nonnull, strong) HFLastPrescription *lastPrescription; //(0 = on demand, 1 = continuous)

@end
