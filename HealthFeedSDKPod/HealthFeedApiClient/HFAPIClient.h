//
//  HFAPIClient.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFModel.h"

typedef void (^UpdateProfileCompletionHandler)(HFUserProfile *profile, NSError *error);
typedef void (^ContentCompletionHandler)(HFFeedResponse *feedResponse, NSInteger start, NSString *referense, HFError *feedError, NSError *error);
typedef void (^CompletionHandler)(NSError *error);
typedef void (^CampaignsCompletionHandler)(NSArray *qualifiedCampaigns, NSArray *associatedCampaigns, NSError *error);
typedef void (^MetadataCompletionHandler)(NSArray *favoritesArticles, NSArray *likedArticles, NSArray *commentedArticles, NSArray *questionsArticles, NSError *error);
typedef void (^LoadOptionsCompletionHandler)(NSArray *conditions, NSInteger appID, NSInteger availableFeatures, NSDictionary *webResources, NSError *error);
typedef void (^LoadSettingsCompletionHandler)(HFUserGender gender, HFUserAgeGroup ageGroup, HFUserEthnicity ethnicity, NSMutableArray *selectedConditions, NSError *error);
typedef void (^LoadDemographicCompletionHandler)(HFUserGender gender, HFUserAgeGroup ageGroup, HFUserEthnicity ethnicity, NSError *error);
typedef void (^LoadMedicalCompletionHandler)(NSMutableArray *selectedConditions, NSError *error);
typedef void (^SearchCompletionHandler)(NSArray *articles, NSInteger totalFoundArticles, NSInteger currentArticleOffset, NSError *error);

@interface HFAPIClient : NSObject

//Profile
- (void)pushMemberHealthProfileInEnglish:(HFUserProfile *)profile withCompletion:(UpdateProfileCompletionHandler)completion;
- (void)pushMemberHealthProfileInCodes:(HFMedicalUserProfile *)medicalProfile withCompletion:(UpdateProfileCompletionHandler)completion;
- (void)pushMemberID:(NSString *)memberID andExtraDataList:(NSMutableArray *)extraDataList withCompletion:(UpdateProfileCompletionHandler)completion;


//Getting Options and Settings
- (void)loadApplicationOptionsWithCompletion:(LoadOptionsCompletionHandler)completion;
- (void)getUserSettings:(HFUserProfile *)profile withCompletion:(LoadSettingsCompletionHandler)completion;
- (void)getUserDemographicInfo:(HFUserProfile *)profile withCompletion:(LoadDemographicCompletionHandler)completion;
- (void)getUserMedicalConditions:(HFUserProfile *)profile withCompletion:(LoadMedicalCompletionHandler)completion;

//Getting Content By Conditions
- (void)contentByConditions:(NSArray *)conditionItems
                 completion:(ContentCompletionHandler)completion;

- (void)contentByConditions:(NSArray *)conditionItems
                userProfile:(HFUserProfile *)profile
                 completion:(ContentCompletionHandler)completion;

- (void)contentByConditions:(NSArray *)conditionItems
                userProfile:(HFUserProfile *)profile
              extraDataList:(NSArray *)extraDataList
                 completion:(ContentCompletionHandler)completion;

//Getting Content By Reference
- (void)contentByProfile:(HFUserProfile *)profile
                completion:(ContentCompletionHandler)completion;

- (void)contentByReference:(NSString *)reference
           andStartArticle:(NSInteger)startArticleNumber completion:(ContentCompletionHandler)completion;

//Getting Content By Medical History
- (void)contentByMedicalHistory:(HFMedicalHistory *)history
                    userProfile:(HFUserProfile *)profile
                  extraDataList:(NSArray *)extraDataList
                     completion:(ContentCompletionHandler)completion;

//Add Metadata
- (void)markArticleAsFavorite:(HFFeedItem *)article withUserProfile:(HFUserProfile *)profile completion:(CompletionHandler)completion;

- (void)markArticleAsLiked:(HFFeedItem *)article withUserProfile:(HFUserProfile *)profile completion:(CompletionHandler)completion;

- (void)addComment:(NSString *)text toArticle:(HFFeedItem *)article withUserProfile:(HFUserProfile *)profile completion:(CompletionHandler)completion;

- (void)addQuestion:(NSString *)text toArticle:(HFFeedItem *)article withUserProfile:(HFUserProfile *)profile completion:(CompletionHandler)completion;

- (void)addFeedMetadataForArticleID:(NSString *)articleID
                     userProfile:(HFUserProfile *)profile
                               type:(HFFeedMetadataType)type
                         sourceType:(NSInteger)sourceType
                           viewType:(NSInteger)viewType
                               text:(NSString *)text
                         completion:(CompletionHandler)completion;

//Favorits, comments, likes, questions
- (void)getPersonalFolderItemsForUserProfile:(HFUserProfile *)profile andCompletion:(MetadataCompletionHandler)completion;

//Search Content
- (void)getSearchResultsWithText:(NSString *)searchText resultsOffset:(NSInteger)resultOffset andCompletion:(SearchCompletionHandler)completion;

//Campaigns
- (void)campaignsForFeed:(HFFeedResponse *)feedResponce andUserProfile:(HFUserProfile *)profile completion:(CampaignsCompletionHandler)completion;
- (void)campaignsForArticles:(NSArray *)articles andUserProfile:(HFUserProfile *)profile completion:(CampaignsCompletionHandler)completion;

//Analitics
- (void)reportActionAnalyticsWithAppID:(NSString *)appID
                                 role:(HFAPIRoleType)role
                            entSiteID:(NSInteger)entSiteID
                             entGroID:(NSInteger)entGroID
                                track:(NSString *)track
                            visitorID:(NSString *)visitorID
                                  ref:(NSString *)ref
                                 type:(NSString *)type
                                 uids:(NSArray *)uids
                             viewType:(NSInteger)viewType
                           sourceType:(NSInteger)sourceType
                         searchString:(NSString *)searchString
                           conditions:(NSArray *)conditions
                    openCloseTimeDiff:(NSInteger)openCloseTimeDiff
                          extDataList:(NSArray *)extDataList;

- (void)reportVisitAnalyticsWithAppID:(NSString *)appID
                                 role:(HFAPIRoleType)role
                            entSiteID:(NSInteger)entSiteID
                             entGroID:(NSInteger)entGroID
                                track:(NSString *)track
                            visitorID:(NSString *)visitorID
                                  ref:(NSString *)ref
                                 type:(NSString *)type
                                  uids:(NSArray *)uids
                         searchString:(NSString *)searchString
                           conditions:(NSArray *)conditions
                          extDataList:(NSArray *)extDataList;

- (void)reportAnalyticsForCampaignID:(NSString *)campaignID
                 userProfile:(HFUserProfile *)profile
                        type:(HFFeedMetadataType)type
                        text:(NSString *)text
                  completion:(CompletionHandler)completion;

//Downloading
- (void)downloadFileWithUrl:(NSString *)url andFileName:(NSString *)fileName intoFolderWithPath:(NSString *)folderPath;

@end
