//
//  HFCampaignsManager.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/26/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCampaignsManager.h"
#import "HealthFeedSDK.h"
#import "HFDataManager.h"
#import "HFCampaignsUIFactory.h"
#import "HFCampaignsManager+Internal.h"

#define kAutomaticallyTimerElapsedTime 1.0 //sec

@interface HFCampaignsManager() {
    
    HFAPIClient *_apiClient;
    NSMutableArray *_loadedQualifiedCampaigns;
    NSMutableArray *_alreadyShowedCampaigns;
    
    NSArray *_lastLoadedQualifiedCampaigns;
    
    NSMutableArray *_currentDisplayedCampaigns;
    
    NSTimer *_timer;
}

@end

@implementation HFCampaignsManager

+ (instancetype)sharedInstance {
    static HFCampaignsManager *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[HFCampaignsManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _apiClient = [[HFAPIClient alloc]init];
        self.allowedQualifiedCampaigns = HFCampaignRenderingTypePopUpCenter |
        HFCampaignRenderingTypeFullPage |
        HFCampaignRenderingTypeLeaderboard |
        HFCampaignRenderingTypeBannerBottom |
        HFCampaignRenderingTypeInfeed;
        self.showOnlyLastLoadedQualifiedCampaigns = YES;
        self.showQualifiedCampaignsAutomattically = NO;
        _loadedQualifiedCampaigns = [NSMutableArray array];
        _alreadyShowedCampaigns = [NSMutableArray array];
        _currentDisplayedCampaigns = [NSMutableArray array];
    }
    return self;
}

- (HFUserProfile *)userProfile {
    return [HFDataManager sharedInstance].userProfile;
}

#pragma mark - Properties
- (NSArray *)allQualifiedCampaigns {
    return _loadedQualifiedCampaigns;
}

- (NSArray *)allAlreadyShowedCampaigns {
    return _alreadyShowedCampaigns;
}

- (NSArray *)lastQualifiedCampaigns {
    return _lastLoadedQualifiedCampaigns;
}

- (NSArray *)currentDisplayedCampaign {
    return _currentDisplayedCampaigns;
}

- (void)setShowQualifiedCampaignsAutomattically:(BOOL)showQualifiedCampaignsAutomattically {
    _showQualifiedCampaignsAutomattically = showQualifiedCampaignsAutomattically;
    
    if(_showQualifiedCampaignsAutomattically) {
        [_timer invalidate];
         _timer = [NSTimer scheduledTimerWithTimeInterval:kAutomaticallyTimerElapsedTime
                                                   target:self
                                                 selector:@selector(automaticallyTimerFire) userInfo:nil repeats:YES];
    } else {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - Internal
- (BOOL)isQualifiedCampaignAllowedToShow:(HFCampaignItem *)campaign {
    if(campaign.renderingType == HFCampaignRenderingTypeUnknown) {
        return NO;
    }
    
    return (self.allowedQualifiedCampaigns & campaign.renderingType) > 0;
}

- (void)automaticallyTimerFire {
    
    NSArray *qualifiedCampaigns = (self.showOnlyLastLoadedQualifiedCampaigns ? _lastLoadedQualifiedCampaigns : _loadedQualifiedCampaigns);
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"alreadyDisplayed == false AND ((loadedTime + presetAfter) <= %f AND presetAfter > 0)",
                                    [[NSDate date] timeIntervalSince1970]];
    NSArray *foundCampaigns = [qualifiedCampaigns filteredArrayUsingPredicate:searchPredicate];
    
    for(HFCampaignItem *item in foundCampaigns) {
        if([self showQualifiedCampaign:item]) {
            break;
        }
    }
}

#pragma mark - Public
#pragma mark Request
- (void)loadCampaigns {
    [self loadCampaignsWithCompletion:nil];
}

- (void)loadCampaignsWithCompletion:(CompletionHandler)completion {
    [self loadCampaignsForFeedResponse:nil completion:completion];
}

- (void)loadCampaignsForFeedResponse:(HFFeedResponse *)feedresponse completion:(CompletionHandler)completion {
    [self loadCampaignsForFeedResponse:feedresponse
                       withCompletion:^(NSArray *qualifiedCampaigns, NSArray *associatedCampaigns, NSError *error) {
                           if(completion) {
                               completion(error);
                           }
                       }];
}

- (void)loadCampaignsForFeedResponse:(HFFeedResponse *)feedresponse withCompletion:(CampaignsCompletionHandler)completion {
    [_apiClient campaignsForFeed:feedresponse
                  andUserProfile:self.userProfile
                      completion:^(NSArray *qualifiedCampaigns, NSArray *associatedCampaigns, NSError *error) {
                          
                          NSMutableArray *filteredCampaigns = [NSMutableArray array];
                          for(HFCampaignItem *item in qualifiedCampaigns) {
                              if(![_alreadyShowedCampaigns containsObject:item]) {
                                  [filteredCampaigns addObject:item];
                              }
                          }
                          
                          if(filteredCampaigns.count > 0) {
                              _lastLoadedQualifiedCampaigns = filteredCampaigns;
                              [_loadedQualifiedCampaigns addObjectsFromArray:filteredCampaigns];
                          }
                          
                          if(completion) {
                              completion(filteredCampaigns, associatedCampaigns, error);
                          }
                      }];
}

#pragma mark Show Campaigns
- (HFCampaignView *)showNextQualifiedCampaign {
   return [self showNextQualifiedCampaignForType:HFCampaignRenderingTypeInfeed |
           HFCampaignRenderingTypeFullPage |
           HFCampaignRenderingTypeLeaderboard |
           HFCampaignRenderingTypePopUpCenter |
           HFCampaignRenderingTypeBannerBottom];
    
}

- (HFCampaignView *)showNextQualifiedCampaignForType:(HFCampaignRenderingType)type {
    NSArray *qualifiedCampaigns = (self.showOnlyLastLoadedQualifiedCampaigns ? _lastLoadedQualifiedCampaigns : _loadedQualifiedCampaigns);
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"alreadyDisplayed == NO AND (renderingType & %d > 0)", type];
    NSArray *foundCampaigns = [qualifiedCampaigns filteredArrayUsingPredicate:searchPredicate];
    
    for(HFCampaignItem *item in foundCampaigns) {
        return [self showQualifiedCampaign:item];
    }
    
    return nil;
}

- (HFCampaignView *)showQualifiedCampaign:(HFCampaignItem *)campaign {
    
    if((!campaign.campaignHTML && !campaign.permissionHTML) ||
       campaign.alreadyDisplayed ||
       ![self isQualifiedCampaignAllowedToShow:campaign] ||
       ![_loadedQualifiedCampaigns containsObject:campaign]) {
        return nil;
    }
    
    if([_alreadyShowedCampaigns containsObject:campaign]) {
        return nil;
    }
    
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"(renderingType & %d > 0)", campaign.renderingType];
    NSArray *foundCampaigns = [_currentDisplayedCampaigns filteredArrayUsingPredicate:searchPredicate];
    
    if(foundCampaigns.count > 0) {
        return nil;
    }
    
    if(self.showQualifiedCampaignsAutomattically && [_delegate respondsToSelector:@selector(shouldAutomaticallyShowCampaign:)]) {
        if(![_delegate shouldAutomaticallyShowCampaign:campaign]) {
            return nil;
        }
    }
    
    HFCampaignView *campaignView = [HFCampaignsUIFactory campaignViewForCampaign:campaign];
    [campaignView show];
    
    return campaignView;
}

- (HFCampaignView *)viewForCampaign:(HFCampaignItem *)campaign {
    return [HFCampaignsUIFactory campaignViewForCampaign:campaign];
}

@end


@implementation HFCampaignsManager(Internal)

- (void)addToCurrentDisplayCampaigns:(HFCampaignItem *)campaign {
    if(campaign.renderingType != HFCampaignRenderingTypeInfeed) {
        campaign.alreadyDisplayed = YES;
        [_alreadyShowedCampaigns addObject:campaign];
        [_currentDisplayedCampaigns addObject:campaign];
    }
}

- (void)removeFromCurrentDisplayCampaigns:(HFCampaignItem *)campaign{
    [_currentDisplayedCampaigns removeObject:campaign];
}

@end


