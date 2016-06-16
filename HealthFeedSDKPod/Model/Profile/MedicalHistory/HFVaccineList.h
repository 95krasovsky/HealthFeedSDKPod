//
//  HFVaccineList.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFVaccine.h"

@interface HFVaccineList : HFBaseModelObject

@property(nonatomic, strong)NSMutableArray *vaccines;// list of HFVaccine

@end
