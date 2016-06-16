//
//  HFFullScreenCampaignView.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/2/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFFullScreenCampaignView.h"

@interface HFFullScreenCampaignView() {
    BOOL _isHidding;
}

@end

@implementation HFFullScreenCampaignView

- (void)configurateShowingForView:(UIView *)view {
    self.frame = view.bounds;
    self.contentView.frame = view.bounds;
    self.contentView.center = self.center;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if(!_isHidding){
        self.contentView.frame = self.backgroundView.frame;
        self.contentView.center = self.backgroundView.center;
        [self.webview.scrollView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    }
}

- (void)hideAnimated:(BOOL)animated withCompletion:(void (^)())completion {
    _isHidding = YES;
    [super hideAnimated:animated withCompletion:completion];
}

@end
