//
//  HFCampaignView.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/1/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFCampaignItem.h"
#import "HFCampaignDelegate.h"
#import "HFCampaignContentView.h"

@interface HFCampaignView : UIView

@property(nonatomic, weak)<HFCampaignDelegate> delegate;

@property(nonatomic, readonly)UIWebView *webview;
@property(nonatomic) BOOL showPermissionCampaign;

@property(nonatomic, readonly)UIView *backgroundView;
@property(nonatomic, readonly)HFCampaignContentView *contentView;

@property(nonatomic, strong)HFCampaignItem *campaign;

- (instancetype)initWithCampaing:(HFCampaignItem *)campaign;

- (void)setupView;

- (void)configurateShowingForView:(UIView *)view;

- (void)showOnView:(UIView *)view animated:(BOOL)animated withCompletion:(void(^)())completion;
- (void)showAnimated:(BOOL)animated withComletion:(void(^)())completion;
- (void)showAnimated:(BOOL)animated;
- (void)show;

- (void)hideAnimated:(BOOL)animated withCompletion:(void(^)())completion;
- (void)hideAnimated:(BOOL)animated;
- (void)hide;

@end
