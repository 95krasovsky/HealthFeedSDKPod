//
//  HFUserProfile.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/19/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFConditionItem.h"

typedef NS_ENUM(NSUInteger, HFUserEthnicity) {
    HFUserEthnicityAsian,
    HFUserEthnicityAsianIndians,
    HFUserEthnicityChinese,
    HFUserEthnicityAfricanAmerican,
    HFUserEthnicityCaucasian,
    HFUserEthnicityNativeIndians,
    HFUserEthnicityHispanic
};

typedef NS_ENUM(NSUInteger, HFUserAgeGroup) {
    HFUserAgeGroupInfant,
    HFUserAgeGroupToddler,
    HFUserAgeGroupChildren,
    HFUserAgeGroupTeen,
    HFUserAgeGroupYoungAdult,
    HFUserAgeGroupMiddleAge,
    HFUserAgeGroupSenior,
    HFUserAgeGroupUnknown,
    HFUserAgeGroupUnspecified
};

typedef NS_ENUM(NSUInteger, HFUserGender) {
    HFUserGenderMale,
    HFUserGenderFemale,
    HFUserGenderUnknown,
    HFUserGenderUnspecified
};

@interface HFUserProfile : HFBaseModelObject

@property(nonatomic, strong) NSString *userID;
@property(nonatomic, strong) NSString *reference;
@property(nonatomic, strong) NSString *fullName; //User’s Full Name
@property(nonatomic, strong) NSString *email; //User’s email address
@property(nonatomic, strong) NSMutableArray *extraDataList; //User’s email address
@property(nonatomic) NSUInteger grade; //Max readability grade, [integer  5 – 12 (both inclusive) ]
@property(nonatomic) NSUInteger age;
@property(nonatomic) NSInteger start;
@property(nonatomic) HFUserEthnicity ethnicity;
@property(nonatomic) HFUserAgeGroup ageGroup;
@property(nonatomic) HFUserGender gender;
@property(nonatomic, strong) NSDate *birthday;

@property(nonatomic, strong) NSMutableArray *conditions;

@end
