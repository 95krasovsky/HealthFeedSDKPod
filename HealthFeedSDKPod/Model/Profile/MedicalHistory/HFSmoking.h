//
//  HFSmoking.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/11/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFBaseCode.h"


@interface HFSmoking : HFBaseModelObject

@property(nonatomic, strong)  HFBaseCode *smokingStatus;

@property(nonatomic) NSUInteger dailyCigaretteConsumption;

@end
