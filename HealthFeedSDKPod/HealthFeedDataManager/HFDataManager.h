//
//  HFDataManager.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/1/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFModel.h"
#import "HFAPIClient.h"

@interface HFDataManager : NSObject

@property(nonatomic, readonly)HFUserProfile *userProfile;
@property(nonatomic, readonly)NSArray *availableConditions;
@property(nonatomic, readonly)NSInteger availableFeaturesMask;
@property(nonatomic, readonly)NSInteger applicationID;

+ (instancetype)sharedInstance;

- (void)loadManagerWithComplition:(void(^)(HFUserProfile *profile))complition;

- (void)pushMemberHealthProfileInEnglish:(HFUserProfile *)profile withCompletion:(UpdateProfileCompletionHandler)completion;
- (void)pushMemberHealthProfileInCodes:(HFMedicalUserProfile *)medicalProfile withCompletion:(UpdateProfileCompletionHandler)completion;
- (void)pushMemberID:(NSString *)memberID andExtarDataList:(NSMutableArray *)extarDataList withCompletion:(UpdateProfileCompletionHandler)completion;

- (void)loadApplicationSettingsWithComplition:(CompletionHandler)completion;
- (void)loadAvailableConditionsWithComplition:(CompletionHandler)completion;

- (NSMutableArray *)conditionsBySelectedConditions:(NSArray *)selectedConditions;

@end
