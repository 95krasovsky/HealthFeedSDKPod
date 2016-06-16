//
//  ApiUrlConfigurator.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/17/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApiUrlConfigurator : NSObject

+ (NSString *)baseUrl;

+ (NSString *)authUrlPath;

+ (NSString *)contentByConditionUrlPath;
+ (NSString *)contentByRefUrlPath;
+ (NSString *)contentByMedicalHistoryUrlPath;

+ (NSString *)addMetadataToArticleUrlPath;

+ (NSString *)campaingsUrlPath;

+ (NSString *)conditionsUrlPath;

+ (NSString *)metadataUrlPath;

+ (NSString *)searchUrlPathWithAppID:(NSString *)appID;

+ (NSString *)updateProfileUrlPath;
+ (NSString *)updateMedicalHistoryUrlPath;
+ (NSString *)getProfileSettingsUrlPath;

+ (NSString *)pathToWebResourcesFolder;

@end
