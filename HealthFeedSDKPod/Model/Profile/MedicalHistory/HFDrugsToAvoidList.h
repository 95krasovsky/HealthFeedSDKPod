//
//  HFDrugsToAvoidList.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFReasonForAvoiding.h"

@interface HFDrugsToAvoidList : HFBaseModelObject

@property(nonatomic, strong)NSMutableArray *drugsToAvoid;// list of HFReasonForAvoiding

@end
