//
//  HFDataManager.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/1/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFDataManager.h"
#import "ApiUrlConfigurator.h"

@interface HFDataManager() {
    HFAPIClient *_apiClient;
}

@end

@implementation HFDataManager

+ (instancetype)sharedInstance {
    static HFDataManager *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[HFDataManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _apiClient = [[HFAPIClient alloc]init];
        [self loadDataFromStorage];
    }
    return self;
}

#pragma mark - Internal
- (void)loadDataFromStorage {
    
    NSString *reference = [[NSUserDefaults standardUserDefaults]objectForKey:@"ref"];
    NSString *userID = [[NSUserDefaults standardUserDefaults]objectForKey:@"uid"];
    if(reference && userID) {
        HFUserProfile *profile = [[HFUserProfile alloc]init];
        profile.reference = reference;
        profile.userID = userID;
        _userProfile = profile;
    }
}

- (void)saveDataToStorage {
    if(self.userProfile.reference && self.userProfile.userID) {
        [[NSUserDefaults standardUserDefaults]setObject:self.userProfile.reference forKey:@"ref"];
        [[NSUserDefaults standardUserDefaults]setObject:self.userProfile.userID forKey:@"uid"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

#pragma mark - Public
- (void)loadManagerWithComplition:(void(^)(HFUserProfile *profile))complition {
    [self loadDataFromStorage];
    
    if(!self.userProfile) {
        [self loadAvailableConditionsWithComplition:^(NSError *error) {
            if(complition) {
                complition(nil);
            }
        }];
        return;
    }
    
    [self loadApplicationSettingsWithComplition:^(NSError *error) {
        if(complition) {
            complition(self.userProfile);
        }
    }];
}

- (void)pushMemberHealthProfileInEnglish:(HFUserProfile *)profile withCompletion:(UpdateProfileCompletionHandler)completion {
    HFDataManager __weak *weakSelf = self;
    
    [_apiClient pushMemberHealthProfileInEnglish:profile withCompletion:^(HFUserProfile *profile, NSError *error) {
        if(!error) {
            _userProfile = profile;
            [weakSelf saveDataToStorage];
        }
        if(completion) {
            completion(profile, error);
        }
    }];
}

- (void)pushMemberHealthProfileInCodes:(HFMedicalUserProfile *)medicalProfile withCompletion:(UpdateProfileCompletionHandler)completion {
    HFDataManager __weak *weakSelf = self;
    [_apiClient pushMemberHealthProfileInCodes:medicalProfile withCompletion:^(HFUserProfile *profile, NSError *error) {
        if(!error) {
            _userProfile = profile;
            [weakSelf saveDataToStorage];
        }
        if(completion) {
            completion(profile, error);
        }
    }];
}

- (void)pushMemberID:(NSString *)memberID andExtarDataList:(NSMutableArray *)extarDataList withCompletion:(UpdateProfileCompletionHandler)completion {
    HFDataManager __weak *weakSelf = self;
    [_apiClient pushMemberID:memberID andExtraDataList:extarDataList withCompletion:^(HFUserProfile *profile, NSError *error) {
        if(!error) {
            _userProfile = profile;
            [weakSelf saveDataToStorage];
        }
        if(completion) {
            completion(profile, error);
        }
    }];
}

- (void)loadApplicationSettingsWithComplition:(CompletionHandler)completion {
    if(self.availableConditions.count == 0) {
        [self loadAvailableConditionsWithComplition:^(NSError *error) {
            [_apiClient getUserSettings:self.userProfile withCompletion:^(HFUserGender gender, HFUserAgeGroup ageGroup, HFUserEthnicity ethnicity, NSMutableArray *selectedConditions, NSError *error) {
                _userProfile.ageGroup = ageGroup;
                _userProfile.ethnicity = ethnicity;
                _userProfile.gender = gender;
                
                _userProfile.conditions = [self conditionsBySelectedConditions:selectedConditions];
                if(completion) {
                    completion(error);
                }
            }];
        }];
    } else {
        [_apiClient getUserSettings:self.userProfile withCompletion:^(HFUserGender gender, HFUserAgeGroup ageGroup, HFUserEthnicity ethnicity, NSMutableArray *selectedConditions, NSError *error) {
            _userProfile.ageGroup = ageGroup;
            _userProfile.ethnicity = ethnicity;
            _userProfile.gender = gender;
            
            _userProfile.conditions = [self conditionsBySelectedConditions:selectedConditions];
            
            if(completion) {
                completion(error);
            }
        }];
    }
}

- (void)loadAvailableConditionsWithComplition:(CompletionHandler)completion {
    [_apiClient loadApplicationOptionsWithCompletion:^(NSArray *conditions, NSInteger appID, NSInteger availableFeatures, NSDictionary *webResources, NSError *error) {
        if(conditions.count > 0) {
            _availableConditions = conditions;
        }
        
        _applicationID = appID;
        _availableFeaturesMask = availableFeatures;
        
        if(completion) {
            completion(error);
        }
        
        [self downoadAllWebResourcesFilesFromDictionary:webResources];
    }];
}

#pragma mark - Internal
- (NSMutableArray *)conditionsBySelectedConditions:(NSArray *)selectedConditions {
    NSMutableArray *result = [NSMutableArray array];
    for(HFConditionItem *selectedItem in selectedConditions) {
        for(HFConditionItem *availableItem in self.availableConditions) {
            if([availableItem isEqual:selectedItem]) {
                [result addObject:availableItem];
            }
        }
    }
    return result;
}

- (void)downoadAllWebResourcesFilesFromDictionary:(NSDictionary *)resources {
    NSString *folderPath = [ApiUrlConfigurator pathToWebResourcesFolder];
    
    for(NSString *key in resources.allKeys) {
        if(![self checkIsResourceFileExist:key inFolder:folderPath]) {
            NSString *fileUrl = resources[key];
            [_apiClient downloadFileWithUrl:fileUrl andFileName:key intoFolderWithPath:folderPath];
        }
    }
}

- (BOOL)checkIsResourceFileExist:(NSString *)fileName inFolder:(NSString *)folderPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:[folderPath stringByAppendingPathComponent:fileName]];
}

@end
