//
//  HFProcedure.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCodeStartEndPointTimeName.h"
#import "HFCodeName.h"

@interface HFProcedure : HFCodeStartEndPointTimeName

@property(nonatomic, strong)HFCodeName *anatomicalTarget;
@property(nonatomic, strong)HFCodeName *material;
@property(nonatomic, strong)HFCodeName *implant;

@end
