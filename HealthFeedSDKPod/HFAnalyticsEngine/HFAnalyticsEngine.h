//
//  HFAnalyticsEngine.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/10/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFModel.h"

@interface HFAnalyticsEngine : NSObject

+ (instancetype)sharedInstance;

- (void)sendArticlesPageDidLoad:(HFFeedResponse *)feedResponse forAPIRole:(HFAPIRoleType)type;
- (void)sendDidTapOnArticle:(HFFeedItem *)article forAPIRole:(HFAPIRoleType)type;
- (void)sendDidOpenArticle:(HFFeedItem *)article forAPIRole:(HFAPIRoleType)type;
- (void)sendDidCloseArticle:(HFFeedItem *)article forAPIRole:(HFAPIRoleType)type;
- (void)sendSettingsScreenDispayedForAPIRole:(HFAPIRoleType)type;
- (void)infoScreenDisplayedForAPIRole:(HFAPIRoleType)type;

@end
