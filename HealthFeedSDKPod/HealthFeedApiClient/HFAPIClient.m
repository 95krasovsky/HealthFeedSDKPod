//
//  HFAPIClient.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFAPIClient.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "HealthFeedSDK+Internal.h"
#import "ApiUrlConfigurator.h"
#import "AFHTTPRequestSerializer+OAuth2.h"
#import "ApiParams.h"
#import "HFModel+Internal.h"
#import "AuthService.h"

@interface HFAPIClient() {
    AFHTTPSessionManager *_sessionManager;
}

@end

@implementation HFAPIClient

- (instancetype)init{
    self = [super init];
    if (self) {
        _sessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:[ApiUrlConfigurator baseUrl]]];
        
        [self setupHTTPRequestSerializerWithCompletion: nil];
    }
    return self;
}

- (void)checkAuthCredentialWithCompletion:(void (^)(AFOAuthCredential *credential))completion {
    AuthService *authService = [[HealthFeedSDK sharedInstance] authService];
    
    [authService authenticateWithCompletion:^(AFOAuthCredential *credential, NSError *error) {
        if(completion) {
            completion(credential);
        }
    }];
}

- (void)setupJSONRequestSerializerWithCompletion:(void (^)())completion {
    [self checkAuthCredentialWithCompletion:^(AFOAuthCredential *credential) {
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        if(credential) {
            [_sessionManager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        }
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        if(completion) {
            completion();
        }
    }];
}

- (void)setupHTTPRequestSerializerWithCompletion:(void (^)())completion {
    [self checkAuthCredentialWithCompletion:^(AFOAuthCredential *credential) {
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        if(credential) {
            [_sessionManager.requestSerializer setAuthorizationHeaderFieldWithCredential:credential];
        }
        [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        if(completion) {
            completion();
        }
    }];
}

#pragma mark - Private Requests
- (void)contentWithRequestURLPath:(NSString *)urlPath andParams:(NSDictionary *)params completion:(ContentCompletionHandler)completion {
    [self setupJSONRequestSerializerWithCompletion:^{
        [_sessionManager POST:urlPath
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          if([responseObject isKindOfClass:[NSDictionary class]]){
                              NSDictionary *response = [(NSDictionary *)responseObject objectForKey:ApiParamResponse];
                              if(!response) {
                                  if(completion) {
                                      completion(nil, 0, nil, nil, nil);
                                  }
                                  return;
                              }
                              
                              HFError *feedError = nil;
                              if(response[ApiParamError]) {
                                  feedError = [HFError objectWithDictionary:response[ApiParamError]];
                              }
                              
                              HFFeedResponse *feedResponse = [HFFeedResponse objectWithDictionary:response];
                              NSInteger startParam = [response[ApiParamStart] integerValue];
                              NSString *reference =response[ApiParamRef];
                              
                              if(completion) {
                                  completion(feedResponse, startParam, reference, feedError, nil);
                              }
                          } else {
                              if(completion) {
                                  completion(nil, 0, nil, nil, nil);
                              }
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if(completion) {
                              completion(nil, 0, nil, nil, nil);
                          }
                      }];
    }];
}

#pragma mark - Publlic
#pragma mark User Profile

- (void)pushMemberHealthProfileInEnglish:(HFUserProfile *)profile withCompletion:(UpdateProfileCompletionHandler)completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    if(profile) {
        if(profile.userID) {
            params[ApiParamUserID] = profile.userID;
        }
        [params addEntriesFromDictionary:[profile convertToDictionary]];
    }
    
    [self setupJSONRequestSerializerWithCompletion:^{
        [_sessionManager POST:[ApiUrlConfigurator updateProfileUrlPath]
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          if([responseObject isKindOfClass:[NSDictionary class]]){
                              NSDictionary *response = [(NSDictionary *)responseObject objectForKey:ApiParamResponse];
                              if(!response) {
                                  if(completion) {
                                      completion(profile, nil);
                                  }
                                  return;
                              }
                              
                              profile.reference = response[ApiParamRef];
                              profile.start = [response[ApiParamStart] integerValue];
                              
                              if(completion) {
                                  completion(profile, nil);
                              }
                          } else {
                              if(completion) {
                                  completion(profile, nil);
                              }
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if(completion) {
                              completion(profile, error);
                          }
                      }];
    }];
}
     
- (void)pushMemberHealthProfileInCodes:(HFMedicalUserProfile *)medicalProfile withCompletion:(UpdateProfileCompletionHandler)completion {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    if(medicalProfile) {
        if(medicalProfile.userID) {
            params[ApiParamUserID] = medicalProfile.userID;
        }
        if(medicalProfile.reference) {
            params[ApiParamRef] = medicalProfile.reference;
        }
        params[ApiParamStart] = @(medicalProfile.start);
    }
    
    if(medicalProfile.medicalHistory) {
        //TODO: convert medical history and conditions to dictionary
        //[result addEntriesFromDictionary:[self.medicalHistory convertToDictionary]];
    }
    
    [self setupJSONRequestSerializerWithCompletion:^{
        [_sessionManager POST:[ApiUrlConfigurator updateMedicalHistoryUrlPath]
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          if([responseObject isKindOfClass:[NSDictionary class]]){
                              NSDictionary *response = [(NSDictionary *)responseObject objectForKey:ApiParamResponse];
                              if(!response) {
                                  if(completion) {
                                      completion(medicalProfile, nil);
                                  }
                                  return;
                              }
                              
                              medicalProfile.reference = response[ApiParamRef];
                              medicalProfile.start = [response[ApiParamStart] integerValue];
                              
                              if(completion) {
                                  completion(medicalProfile, nil);
                              }
                          } else {
                              if(completion) {
                                  completion(medicalProfile, nil);
                              }
                          }
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if(completion) {
                              completion(medicalProfile, error);
                          }
                      }];
    }];
}

- (void)pushMemberID:(NSString *)memberID andExtraDataList:(NSMutableArray *)extraDataList withCompletion:(UpdateProfileCompletionHandler)completion {
    HFUserProfile *profile = [[HFUserProfile alloc]init];
    profile.userID = memberID;
    profile.extraDataList = extraDataList;
    
    [self pushMemberHealthProfileInEnglish:profile withCompletion:completion];
}

#pragma mark Getting Options and Settings
- (void)loadApplicationOptionsWithCompletion:(LoadOptionsCompletionHandler)completion {
    [self setupJSONRequestSerializerWithCompletion:^{
        [_sessionManager GET:[ApiUrlConfigurator conditionsUrlPath]
                  parameters:nil
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if([responseObject isKindOfClass:[NSDictionary class]]){
                             NSDictionary *response = [(NSDictionary *)responseObject objectForKey:ApiParamResponse];
                             
                             if(!response) {
                                 if(completion) {
                                     completion(nil, 0, 0, nil, nil);
                                 }
                                 return;
                             }
                             
                             NSArray *catOption = [[response objectForKey:ApiParamCatOption] objectForKey:ApiParamConditions];
                             
                             NSMutableArray *conditions = [NSMutableArray array];
                             for(NSDictionary *option in catOption) {
                                 [conditions addObject:[HFConditionItem objectWithDictionary:option]];
                             }
                             
                             NSInteger bitMask = [response[@"featureBitMask"] integerValue];
                             NSInteger appID = [response[@"appId"] integerValue];
                             NSDictionary *webResources = response[@"cdnFileUrls"];
                             
                             if(completion) {
                                 completion(conditions, appID, bitMask, webResources, nil);
                             }
                         } else {
                             if(completion) {
                                 completion(nil, 0, 0, nil, nil);
                             }
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if(completion) {
                             completion(nil, 0, 0, nil, nil);
                         }
                     }];
        
    }];
}

- (void)getUserSettings:(HFUserProfile *)profile withCompletion:(LoadSettingsCompletionHandler)completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if(profile) {
        if(profile.userID) {
            params[ApiParamUserID] = profile.userID;
        }
        if(profile.reference) {
            params[ApiParamRef] = profile.reference;
        }
    }
    
    [self setupJSONRequestSerializerWithCompletion:^{
        [_sessionManager POST:[ApiUrlConfigurator getProfileSettingsUrlPath]
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if([responseObject isKindOfClass:[NSDictionary class]]){
                             NSDictionary *response = [(NSDictionary *)responseObject objectForKey:ApiParamResponse];
                             
                             if(!response) {
                                 if(completion) {
                                     completion(HFUserGenderUnknown, HFUserAgeGroupUnknown, HFUserEthnicityAsian, nil, nil);
                                 }
                                 return;
                             }
                             
                             HFUserGender gender = [HFUserProfile convertGenderFromString:response[ApiParamGender]];
                             HFUserAgeGroup ageGroup = [HFUserProfile convertAgeGroupFromString:response[@"ageGroup"]];
                             HFUserEthnicity ethnicity = [HFUserProfile convertEthnicityFromString:response[ApiParamEthnicity]];
                             
                             NSArray *selectedConditions = response[@"settingConditions"];
                             
                             NSMutableArray *conditions = [NSMutableArray array];
                             for(NSDictionary *option in selectedConditions) {
                                 [conditions addObject:[HFConditionItem objectWithDictionary:option]];
                             }
                             
                             if(completion) {
                                 completion(gender, ageGroup, ethnicity, conditions, nil);
                             }
                         } else {
                             if(completion) {
                                 completion(HFUserGenderUnknown, HFUserAgeGroupUnknown, HFUserEthnicityAsian, nil, nil);
                             }
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if(completion) {
                             completion(HFUserGenderUnknown, HFUserAgeGroupUnknown, HFUserEthnicityAsian, nil, error);
                         }
                     }];
        
    }];
}

- (void)getUserDemographicInfo:(HFUserProfile *)profile withCompletion:(LoadDemographicCompletionHandler)completion {
    [self getUserSettings:profile withCompletion:^(HFUserGender gender, HFUserAgeGroup ageGroup, HFUserEthnicity ethnicity, NSMutableArray *selectedConditions, NSError *error) {
        if(completion) {
            completion(gender, ageGroup, ethnicity, error);
        }
    }];
}

- (void)getUserMedicalConditions:(HFUserProfile *)profile withCompletion:(LoadMedicalCompletionHandler)completion {
    [self getUserSettings:profile withCompletion:^(HFUserGender gender, HFUserAgeGroup ageGroup, HFUserEthnicity ethnicity, NSMutableArray *selectedConditions, NSError *error) {
        if(completion) {
            completion(selectedConditions, error);
        }
    }];
}

#pragma mark - Content API
#pragma mark Content By Conditions

- (void)contentByConditions:(NSArray *)conditionItems
                 completion:(ContentCompletionHandler)completion {
    
    [self contentByConditions:conditionItems
                  userProfile:nil
                   completion:completion];
}

- (void)contentByConditions:(NSArray *)conditionItems
                userProfile:(HFUserProfile *)profile
                 completion:(ContentCompletionHandler)completion {

    [self contentByConditions:conditionItems
                  userProfile:profile
                extraDataList:nil
                   completion:completion];
}

- (void)contentByConditions:(NSArray *)conditionItems
                userProfile:(HFUserProfile *)profile
              extraDataList:(NSArray *)extraDataList
                 completion:(ContentCompletionHandler)completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSMutableArray *namesParams = [NSMutableArray array];
    for(HFConditionItem *item in conditionItems) {
        if(item.apiParam) {
            [namesParams addObject:item.apiParam];
        }
    }
    
    if(namesParams.count > 0) {
        params[ApiParamNames] = namesParams;
    }
    
    if(profile) {
        if(profile.userID) {
            params[ApiParamUserID] = profile.userID;
        }
        [params addEntriesFromDictionary:[profile convertToDictionary]];
    }
    
    if(extraDataList.count > 0) {
        NSMutableArray *extraData = [NSMutableArray array];
        for(HFExtraData *data in extraDataList) {
            [extraData addObject:[data convertToDictionary]];
        }
        params[ApiParamExtDataList] = extraData;
    }
    
    [self contentWithRequestURLPath:[ApiUrlConfigurator contentByConditionUrlPath]
                          andParams:params
                         completion:completion];
}

#pragma mark Content By Reference
- (void)contentByProfile:(HFUserProfile *)profile
              completion:(ContentCompletionHandler)completion {
    [self contentByReference:profile.reference andStartArticle:profile.start completion:completion];
}

- (void)contentByReference:(NSString *)reference andStartArticle:(NSInteger)startArticleNumber completion:(ContentCompletionHandler)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[ApiParamRef] = reference;
    if(startArticleNumber >= 0) {
        params[ApiParamStart] = @(startArticleNumber);
    }
    
    [self contentWithRequestURLPath:[ApiUrlConfigurator contentByRefUrlPath]
                          andParams:params
                         completion:completion];
}

#pragma mark Content By Medical History

- (void)contentByMedicalHistory:(HFMedicalHistory *)history
                    userProfile:(HFUserProfile *)profile
                  extraDataList:(NSArray *)extraDataList
                     completion:(ContentCompletionHandler)completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if(profile) {
        if(profile.userID) {
            params[ApiParamUserID] = profile.userID;
        }
        [params addEntriesFromDictionary:[profile convertToDictionary]];
    }
    
    if(extraDataList.count > 0) {
        NSMutableArray *extraData = [NSMutableArray array];
        for(HFExtraData *data in extraDataList) {
            [extraData addObject:[data convertToDictionary]];
        }
        params[ApiParamExtDataList] = extraData;
    }
    
    if(history) {
        [params addEntriesFromDictionary:[history convertToDictionary]];
    }
    
    [self contentWithRequestURLPath:[ApiUrlConfigurator contentByMedicalHistoryUrlPath]
                          andParams:params
                         completion:completion];
    
}

#pragma mark - Add Metadata API
- (void)markArticleAsFavorite:(HFFeedItem *)article withUserProfile:(HFUserProfile *)profile completion:(CompletionHandler)completion {
    [self addFeedMetadataForArticleID:article.identifier
                          userProfile:profile
                                 type:HFFeedMetadataTypeFavorite
                           sourceType:article.contentSourceType
                             viewType:article.contentViewType
                                 text:nil completion:completion];
}

- (void)markArticleAsLiked:(HFFeedItem *)article withUserProfile:(HFUserProfile *)profile completion:(CompletionHandler)completion {
    [self addFeedMetadataForArticleID:article.identifier
                          userProfile:profile
                                 type:HFFeedMetadataTypeLike
                           sourceType:article.contentSourceType
                             viewType:article.contentViewType
                                 text:nil completion:completion];
}

- (void)addComment:(NSString *)text toArticle:(HFFeedItem *)article withUserProfile:(HFUserProfile *)profile completion:(CompletionHandler)completion {
    [self addFeedMetadataForArticleID:article.identifier
                          userProfile:profile
                                 type:HFFeedMetadataTypeComment
                           sourceType:article.contentSourceType
                             viewType:article.contentViewType
                                 text:text completion:completion];
}

- (void)addQuestion:(NSString *)text toArticle:(HFFeedItem *)article withUserProfile:(HFUserProfile *)profile completion:(CompletionHandler)completion {
    [self addFeedMetadataForArticleID:article.identifier
                          userProfile:profile
                                 type:HFFeedMetadataTypeQuestion_Answer
                           sourceType:article.contentSourceType
                             viewType:article.contentViewType
                                 text:text completion:completion];
}

- (void)addFeedMetadataForArticleID:(NSString *)articleID
                        userProfile:(HFUserProfile *)profile
                               type:(HFFeedMetadataType)type
                         sourceType:(NSInteger)sourceType
                           viewType:(NSInteger)viewType
                               text:(NSString *)text
                         completion:(CompletionHandler)completion {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if(sourceType >= 0) {
        params[ApiParamSourceType] = @(sourceType);
    }
    
    if(viewType >= 0) {
        params[ApiParamViewType] = @(viewType);
    }
    
    if(text.length > 0) {
        params[ApiParamText] = text;
    }
    
    params[ApiParamGuid] = articleID;
    
    if(profile) {
        if(profile.userID) {
            params[ApiParamUser_ID] = profile.userID;
        }
    }
    
    params[ApiParamEventType] = [HFFeedMetadata convertMetadataTypeToString:type];
    params[@"digitalTouchPoint"] = @"MOBILE_APP";
    
    [self setupJSONRequestSerializerWithCompletion:^{
        [_sessionManager POST:[ApiUrlConfigurator addMetadataToArticleUrlPath]
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          if(completion) {
                              completion(nil);
                          }
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if(completion) {
                              completion(error);
                          }
                      }];
    }];
}

#pragma mark - Content With Metadata (favorites, likes, comments)
- (void)getPersonalFolderItemsForUserProfile:(HFUserProfile *)profile andCompletion:(MetadataCompletionHandler)completion {
    NSDictionary *params = nil;
    
    if(profile.reference) {
        params = @{ApiParamRef : profile.reference};
    }
    
    [self setupJSONRequestSerializerWithCompletion:^{
        [_sessionManager GET:[ApiUrlConfigurator metadataUrlPath]
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         
                         if([responseObject isKindOfClass:[NSDictionary class]]){
                             NSDictionary *response = [(NSDictionary *)responseObject objectForKey:ApiParamResponse];
                             if(!response) {
                                 if(completion) {
                                     completion(nil, nil, nil, nil, nil);
                                 }
                                 return;
                             }
                             
                             NSMutableArray *favoritesArticles = nil;
                             NSMutableArray *likedArticles = nil;
                             NSMutableArray *commentedArticles = nil;
                             NSMutableArray *questionsArticles = nil;
                             
                             NSMutableArray *favoritesDictionaries = response[ApiParamFavorites];
                             NSMutableArray *likedDictionaries = response[ApiParamLikes];
                             NSMutableArray *commentedDictionaries = response[ApiParamComments];
                             NSMutableArray *questionsDictionaries = response[ApiParamQuestions];
                             
                             if(favoritesDictionaries.count > 0) {
                                 favoritesArticles = [NSMutableArray array];
                                 for(NSDictionary *itemDictionary in favoritesDictionaries) {
                                     HFFeedItem *feedItem = [HFFeedItem objectWithDictionary:itemDictionary];
                                     [favoritesArticles addObject:feedItem];
                                 }
                             }
                             
                             if(likedDictionaries.count > 0) {
                                 likedArticles = [NSMutableArray array];
                                 for(NSDictionary *itemDictionary in likedDictionaries) {
                                     HFFeedItem *feedItem = [HFFeedItem objectWithDictionary:itemDictionary];
                                     [likedArticles addObject:feedItem];
                                 }
                             }
                             
                             if(commentedDictionaries.count > 0) {
                                 commentedArticles = [NSMutableArray array];
                                 for(NSDictionary *itemDictionary in commentedDictionaries) {
                                     HFFeedItem *feedItem = [HFFeedItem objectWithDictionary:itemDictionary];
                                     [commentedArticles addObject:feedItem];
                                 }
                             }
                             
                             if(questionsDictionaries.count > 0) {
                                 questionsArticles = [NSMutableArray array];
                                 for(NSDictionary *itemDictionary in questionsDictionaries) {
                                     HFFeedItem *feedItem = [HFFeedItem objectWithDictionary:itemDictionary];
                                     [questionsArticles addObject:feedItem];
                                 }
                             }
                             
                             if(completion) {
                                 completion(favoritesArticles, likedArticles, commentedArticles, questionsArticles, nil);
                             }
                         } else {
                             if(completion) {
                                 completion(nil, nil, nil, nil, nil);
                             }
                         }
                         
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if(completion) {
                             completion(nil, nil, nil, nil, error);
                         }
                     }];
    }];
}

#pragma mark - Search Content
- (void)getSearchResultsWithText:(NSString *)searchText resultsOffset:(NSInteger)resultOffset andCompletion:(SearchCompletionHandler)completion {
    if (searchText.length == 0) {
        if(completion) {
            completion(nil, 0, 0, nil);
        }
    }
    
    if(resultOffset < 0) {
        resultOffset = 0;
    }
    
    NSDictionary *params = @{@"q" : searchText,
                             ApiParamStart : @(resultOffset)};
    [self setupJSONRequestSerializerWithCompletion:^{
        //TODO: necessory setup real appID, it is get from /api/v1/app/details
        [_sessionManager GET:[ApiUrlConfigurator searchUrlPathWithAppID:@"41"]
                  parameters:params
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if([responseObject isKindOfClass:[NSDictionary class]]){
                             NSDictionary *response = [(NSDictionary *)responseObject objectForKey:ApiParamResponse];
                             if(!response) {
                                 if(completion) {
                                     completion(nil, 0, 0, nil);
                                 }
                                 return;
                             }
                             
                             NSInteger totalArticlesNumber = [response[ApiParamnumFound] integerValue];
                             NSInteger articlePosition = [response[ApiParamStart] integerValue];
                             
                             NSMutableArray *foundArticles = nil;
                             NSMutableArray *foundDictionaries = response[ApiParamDocs];
                             
                             if(foundDictionaries.count > 0) {
                                 foundArticles = [NSMutableArray array];
                                 for(NSDictionary *itemDictionary in foundDictionaries) {
                                     HFFeedItem *feedItem = [HFFeedItem objectWithDictionary:itemDictionary];
                                     [foundArticles addObject:feedItem];
                                 }
                             }
                             
                             if(completion) {
                                 completion(foundArticles, totalArticlesNumber, articlePosition, nil);
                             }
                         } else {
                             if(completion) {
                                 completion(nil, 0, 0, nil);
                             }
                         }
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if(completion) {
                             completion(nil, 0, 0, error);
                         }
                     }];
    }];
}

#pragma mark - Campaigns API
- (void)campaignsForFeed:(HFFeedResponse *)feedResponce andUserProfile:(HFUserProfile *)profile completion:(CampaignsCompletionHandler)completion {
    [self campaignsForArticles:feedResponce.articles
                andUserProfile:profile
                    completion:completion];
}

- (void)campaignsForArticles:(NSArray *)articles andUserProfile:(HFUserProfile *)profile completion:(CampaignsCompletionHandler)completion {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if(profile) {
        if(profile.userID) {
            params[ApiParamUser_ID] = profile.userID;
        }
    }
    
    NSMutableArray *contentReferences = [NSMutableArray array];
    
    for(HFFeedItem *item in articles) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if(item.identifier) {
            dict[ApiParamGuid] = item.identifier;
        }
        dict[ApiParamContentSourceType] = @(item.contentSourceType);
        dict[ApiParamContentViewType] = @(item.contentViewType);
        [contentReferences addObject:dict];
    }
    
    if(contentReferences.count > 0) {
        params[ApiParamContentReferences] = contentReferences;
    }
    
    [self setupJSONRequestSerializerWithCompletion:^{
        [_sessionManager POST:[ApiUrlConfigurator campaingsUrlPath]
                   parameters:params
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          
                          if([responseObject isKindOfClass:[NSDictionary class]]){
                              NSDictionary *response = (NSDictionary *)responseObject;
                              if(!response) {
                                  if(completion) {
                                      completion(nil, nil, nil);
                                  }
                                  return;
                              }
                              
                              NSArray *qualifiedCampaignsIds = response[ApiParamQualifiedCampaignIds];
                              NSArray *associatedCampaignsDicts = response[ApiParamAssociatedCampaigns];
                              NSArray *actionableCampaignsDicts = response[ApiParamActionableCampaigns];
                              
                              NSMutableArray *parsedCampaigns = [NSMutableArray array];
                              
                              //Parse campaigns
                              for(NSDictionary *dict in actionableCampaignsDicts) {
                                  HFCampaignItem *campaign = [HFCampaignItem objectWithDictionary:dict];
                                  if((campaign.campaignHTML || campaign.permissionHTML) && campaign.renderingType != HFCampaignRenderingTypeUnknown) {
                                      [parsedCampaigns addObject:campaign];
                                  }
                              }
                              
                              if(parsedCampaigns.count == 0) {
                                  if(completion) {
                                      completion(nil, nil, nil);
                                  }
                                  return;
                              }
                              
                              NSMutableArray *qualifiedCampaigns = nil;
                              if(qualifiedCampaignsIds.count > 0) {
                                  qualifiedCampaigns = [NSMutableArray array];
                                  
                                  for(NSString *campaignID in qualifiedCampaignsIds) {
                                      NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"campaignID == %@", campaignID];
                                      NSArray *foundObjects = [parsedCampaigns filteredArrayUsingPredicate:searchPredicate];
                                      for(HFCampaignItem *item in foundObjects) {
                                          HFCampaignItem *copyOfItem = item.copy;
                                          copyOfItem.loadedTime = [[NSDate date] timeIntervalSince1970];
                                          [qualifiedCampaigns addObject:copyOfItem];
                                      }
                                  }
                              }
                              
                              NSMutableArray *associatedCampaigns = nil;
                              if(associatedCampaignsDicts.count > 0) {
                                  associatedCampaigns = [NSMutableArray array];
                                  
                                  for(NSDictionary *dict in associatedCampaignsDicts) {
                                      HFAssociatedCampaignObject *associatedObject = [HFAssociatedCampaignObject objectWithDictionary:dict];
                                      if(!associatedObject.articleID) {
                                          continue;
                                      }
                                      
                                      NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"identifier == %@", associatedObject.articleID];
                                      NSArray *foundArticles = [articles filteredArrayUsingPredicate:searchPredicate];
                                      
                                      NSMutableArray *foundCampaigns = [NSMutableArray array];
                                      
                                      for(NSString *campaignID in associatedObject.campaignIDs) {
                                          searchPredicate = [NSPredicate predicateWithFormat:@"campaignID == %@", campaignID];
                                          NSArray *foundObjects = [parsedCampaigns filteredArrayUsingPredicate:searchPredicate];
                                          
                                          [foundObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                                              HFCampaignItem *campaign = (HFCampaignItem *)obj;
                                              [foundCampaigns addObject:campaign.copy];
                                          }];
                                      }
                                      
                                      if(foundCampaigns.count > 0) {
                                          [associatedCampaigns addObjectsFromArray:foundCampaigns];
                                          [foundArticles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
                                              HFFeedItem *article = (HFFeedItem *)obj;
                                              article.associatedCampaigns = foundCampaigns;
                                          }];
                                      }
                                  }
                              }
                              
                              if(completion) {
                                  completion(qualifiedCampaigns, associatedCampaigns, nil);
                              }
                          } else {
                              if(completion) {
                                  completion(nil, nil, nil);
                              }
                          }
                      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          if(completion) {
                              completion(nil, nil, error);
                          }
                      }];
    }];
}

#pragma mark - Analitics

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
                           extDataList:(NSArray *)extDataList {
    
}

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
                          extDataList:(NSArray *)extDataList {
    
}

- (void)reportAnalyticsForCampaignID:(NSString *)campaignID
                         userProfile:(HFUserProfile *)profile
                                type:(HFFeedMetadataType)type
                                text:(NSString *)text
                          completion:(CompletionHandler)completion {
}

- (void)downloadFileWithUrl:(NSString *)url andFileName:(NSString *)fileName intoFolderWithPath:(NSString *)folderPath {
    NSURL *requestURL = [NSURL URLWithString:url];
    NSURL *destinationURL = [NSURL fileURLWithPath:folderPath];
    if(!requestURL) {
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:requestURL];
    
    [self setupJSONRequestSerializerWithCompletion:^{
        NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request
                                                                                 progress:nil
                                                                              destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                                                                  if(fileName) {
                                                                                      return [destinationURL URLByAppendingPathComponent:fileName];
                                                                                  } else {
                                                                                      return [destinationURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                                  }
                                                                              } completionHandler:nil];
        [downloadTask resume];
    }];
}

@end
