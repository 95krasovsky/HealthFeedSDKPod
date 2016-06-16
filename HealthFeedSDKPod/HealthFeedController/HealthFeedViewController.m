//
//  HealthFeedViewController.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/30/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HealthFeedViewController.h"
#import "HFLeaderboardCampaignView.h"
#import "HFPopupCampaignView.h"
#import "HFBottomBannerCampaignView.h"
#import "HealthFeedSDK.h"

@implementation HealthFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (instancetype)init{
    self = [HealthFeedViewController instantiateHeathFeedViewController];
    return self;
}

+ (HealthFeedViewController *)instantiateHeathFeedViewController{
    return [[UIStoryboard storyboardWithName:@"HealthFeedStoryboard" bundle:nil] instantiateInitialViewController];
}

@end
