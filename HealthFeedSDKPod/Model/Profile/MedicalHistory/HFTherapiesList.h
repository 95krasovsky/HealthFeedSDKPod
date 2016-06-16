//
//  HFTherapiesList.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

#import "HFCodeStartEndPointTimeName.h"

@interface HFTherapiesList : HFBaseModelObject

@property(nonatomic, strong)NSMutableArray *therapies;// list of HFCodeStartEndPointTimeName

@end
