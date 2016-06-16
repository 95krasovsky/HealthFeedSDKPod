//
//  HFMeasurementList.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFMeasurement.h"

@interface HFMeasurementList : HFBaseModelObject

@property(nonatomic, strong)NSMutableArray *diagnoses;// HFMeasurement

@end
