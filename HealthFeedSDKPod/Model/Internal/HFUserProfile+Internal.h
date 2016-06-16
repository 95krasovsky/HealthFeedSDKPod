//
//  HFUserProfile+Internal.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/19/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFUserProfile.h"

@interface HFUserProfile(Internal)

- (NSDictionary *)convertToDictionary;

+ (HFUserEthnicity)convertEthnicityFromString:(NSString *)ethnicity;
+ (HFUserGender)convertGenderFromString:(NSString *)gender;
+ (HFUserAgeGroup)convertAgeGroupFromString:(NSString *)agegroup;

@end
