//
//  HFUserProfile+Internal.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/19/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFUserProfile+Internal.h"
#import "ApiParams.h"
#import "NSDate+HF.h"
#import "HFExtraData+Internal.h"

@implementation HFUserProfile(Internal)


+ (HFUserEthnicity)convertEthnicityFromString:(NSString *)ethnicity {
    
    if([ethnicity isEqualToString:@"ASIAN"]) return HFUserEthnicityAsian;
    if([ethnicity isEqualToString:@"CHINESE"]) return HFUserEthnicityChinese;
    if([ethnicity isEqualToString:@"HISPANIC"]) return HFUserEthnicityHispanic;
    if([ethnicity isEqualToString:@"CAUCASIAN"]) return HFUserEthnicityCaucasian;
    if([ethnicity isEqualToString:@"ASIAN_INDIANS"]) return HFUserEthnicityAsianIndians;
    if([ethnicity isEqualToString:@"NATIVE_INDIANS"]) return HFUserEthnicityNativeIndians;
    if([ethnicity isEqualToString:@"AFRICAN_AMERICAN"]) return HFUserEthnicityAfricanAmerican;
    return HFUserEthnicityAsian;
}

+ (HFUserGender)convertGenderFromString:(NSString *)gender {
   
    if([gender isEqualToString:@"MALE"]) return HFUserGenderMale;
    if([gender isEqualToString:@"FEMALE"]) return HFUserGenderFemale;
    if([gender isEqualToString:@"UNKNOWN"]) return HFUserGenderUnknown;
    if([gender isEqualToString:@"UNSPECIFIED"]) return HFUserGenderUnspecified;
    return HFUserGenderUnspecified;
}

+ (HFUserAgeGroup)convertAgeGroupFromString:(NSString *)agegroup {
    
    if([agegroup isEqualToString:@"TEEN"]) return HFUserAgeGroupTeen;
    if([agegroup isEqualToString:@"INFANT"]) return HFUserAgeGroupInfant;
    if([agegroup isEqualToString:@"SENIOR"]) return HFUserAgeGroupSenior;
    if([agegroup isEqualToString:@"TODDLER"]) return HFUserAgeGroupToddler;
    if([agegroup isEqualToString:@"UNKNOWN"]) return HFUserAgeGroupUnknown;
    if([agegroup isEqualToString:@"CHILDREN"]) return HFUserAgeGroupChildren;
    if([agegroup isEqualToString:@"MIDDLE_AGE"]) return HFUserAgeGroupMiddleAge;
    if([agegroup isEqualToString:@"YOUNG_ADULT"]) return HFUserAgeGroupYoungAdult;
    if([agegroup isEqualToString:@"UNSPECIFIED"]) return HFUserAgeGroupUnspecified;
    return HFUserAgeGroupUnknown;
}

+ (NSString *)convertEthnicityToString:(HFUserEthnicity)ethnicity {
    switch (ethnicity) {
        case HFUserEthnicityAsian: return @"ASIAN";
        case HFUserEthnicityChinese: return @"CHINESE";
        case HFUserEthnicityHispanic: return @"HISPANIC";
        case HFUserEthnicityCaucasian: return @"CAUCASIAN";
        case HFUserEthnicityAsianIndians: return @"ASIAN_INDIANS";
        case HFUserEthnicityNativeIndians: return @"NATIVE_INDIANS";
        case HFUserEthnicityAfricanAmerican: return @"AFRICAN_AMERICAN";
    }
}

+ (NSString *)convertGenderToString:(HFUserGender)gender {
    switch (gender) {
        case HFUserGenderMale: return @"MALE";
        case HFUserGenderFemale: return @"FEMALE";
        case HFUserGenderUnknown: return @"UNKNOWN";
        case HFUserGenderUnspecified: return @"UNSPECIFIED";
    }
}

+ (NSString *)convertAgeGroupToString:(HFUserAgeGroup)agegroup {
    
    switch (agegroup) {
        case HFUserAgeGroupTeen: return @"TEEN";
        case HFUserAgeGroupInfant: return @"INFANT";
        case HFUserAgeGroupSenior: return @"SENIOR";
        case HFUserAgeGroupToddler: return @"TODDLER";
        case HFUserAgeGroupUnknown: return @"UNKNOWN";
        case HFUserAgeGroupChildren: return @"CHILDREN";
        case HFUserAgeGroupMiddleAge: return @"MIDDLE_AGE";
        case HFUserAgeGroupYoungAdult: return @"YOUNG_ADULT";
        case HFUserAgeGroupUnspecified: return @"UNSPECIFIED";
    }
}

- (NSDictionary *)convertToDictionary {
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[ApiParamEthnicity] = [HFUserProfile convertEthnicityToString:self.ethnicity];
    result[ApiParamAgeGroup] = [HFUserProfile convertAgeGroupToString:self.ageGroup];
    result[ApiParamGender] = [HFUserProfile convertGenderToString:self.gender];
    
    if(self.fullName.length > 0) {
        result[ApiParamFullName] = self.fullName;
    }
    
    if(self.email.length > 0) {
        result[ApiParamEmailAddress] = self.email;
    }
    
    if(self.age > 0) {
        result[ApiParamAge] = @(self.age);
    }
    
    if(self.grade >= 5 && self.grade <= 12) {
        result[ApiParamGrade] = @(self.grade);
    }
    
    if(self.birthday) {
        result[ApiParamBirthDateTime] = @(self.birthday.timeIntervalSince1970inMilliseconds);
    }
    
    if(self.reference) {
        result[ApiParamRef] = self.reference;
    }
    
    result[ApiParamStart] = @(self.start >= 0 ? self.start : 0);
    
    
    if(self.extraDataList.count > 0) {
        NSMutableArray *extraData = [NSMutableArray array];
        for(HFExtraData *data in self.extraDataList) {
            [extraData addObject:[data convertToDictionary]];
        }
        result[ApiParamExtDataList] = extraData;
    }
    
    NSMutableArray *namesParams = [NSMutableArray array];
    for(HFConditionItem *item in self.conditions) {
        if(item.apiParam) {
            [namesParams addObject:item.apiParam];
        }
    }
    
    if(namesParams.count > 0) {
        result[ApiParamNames] = namesParams;
    }
    
    return result;
}

@end
