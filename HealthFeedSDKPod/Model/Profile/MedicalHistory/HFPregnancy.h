//
//  HFPregnancy.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/11/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

@interface HFPregnancy : HFBaseModelObject

@property(nonatomic) bool pregnant; // true false
@property(nonatomic, strong) NSDate *expectedDeliveryDate;

@end
