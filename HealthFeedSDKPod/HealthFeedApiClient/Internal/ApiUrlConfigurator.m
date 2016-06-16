//
//  ApiUrlConfigurator.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/17/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "ApiUrlConfigurator.h"

#define SERVER_URL                  @"http://verify.myhealthfeed.com"
#define BASE_PATH                   @"/healthdata/api"
#define API_VERSION                 @"/v1"


#define AUTH_URL                    @"/healthdata/oauth/token"

#define CONTENT_BY_CONDITIONS       @"/condition"
#define CONTENT_BY_REFERENCE        @"/condition/ref"
#define CONTENT_BY_MEDICAL         @"/profile/content"

#define ADD_METADATA                @"/condition/article/metaadd"
#define GET_ALL_CAMPAIGNS           @"/mob1/eval/rule"
#define GET_ALL_CONDITIONS          @"/app/details?digitalTouchPoint=MOBILE_APP"

#define GET_ALL_METADATA            @"/condition/breifcase/ref"
#define SEARCH_ARTICLES             @"/search/%@/hfeed"

#define UPDATE_PROFILE              @"/profile/update/user"
#define UPDATE_MEDICAL              @"/profile/update/profile"
#define PROFILE_SETTINGS            @"/profile/settings"

#define VISIT_ANALYTICS             @"/visit"

#pragma mark -

@implementation ApiUrlConfigurator

#pragma mark -
#pragma mark Static methods

+ (NSString *)combinePathWithPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@%@%@", BASE_PATH, API_VERSION, path];
}

+ (NSString *)baseUrl{
    return SERVER_URL;
}

+ (NSString *)authUrlPath{
    return AUTH_URL;
}

+ (NSString *)contentByConditionUrlPath{
    return [self combinePathWithPath:CONTENT_BY_CONDITIONS];
}

+ (NSString *)contentByRefUrlPath{
    return [self combinePathWithPath:CONTENT_BY_REFERENCE];
}

+ (NSString *)contentByMedicalHistoryUrlPath{
    return [self combinePathWithPath:CONTENT_BY_MEDICAL];
}

+ (NSString *)addMetadataToArticleUrlPath{
    return [self combinePathWithPath:ADD_METADATA];
}

+ (NSString *)campaingsUrlPath {
    return [self combinePathWithPath:GET_ALL_CAMPAIGNS];
}

+ (NSString *)conditionsUrlPath {
    return [self combinePathWithPath:GET_ALL_CONDITIONS];
}

+ (NSString *)metadataUrlPath {
    return [self combinePathWithPath:GET_ALL_METADATA];
}

+ (NSString *)searchUrlPathWithAppID:(NSString *)appID {
    return [NSString stringWithFormat:SEARCH_ARTICLES, appID];
}

+ (NSString *)updateProfileUrlPath {
    return [self combinePathWithPath:UPDATE_PROFILE];
}

+ (NSString *)getProfileSettingsUrlPath {
    return [self combinePathWithPath:PROFILE_SETTINGS];
}

+ (NSString *)updateMedicalHistoryUrlPath {
    return [self combinePathWithPath:UPDATE_MEDICAL];
}

+ (NSString *)visitAnalyticUrlPath {
    return [self combinePathWithPath:UPDATE_MEDICAL];
}

+ (NSString *)pathToWebResourcesFolder {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"www"];

    if(![[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        [[NSFileManager defaultManager]createDirectoryAtPath:documentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return documentsPath;
}

@end
