//
//  HFBottomBannerCampaignView.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/13/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBottomBannerCampaignView.h"

#define kHeightOfBanner 92

@implementation HFBottomBannerCampaignView

- (void)configurateShowingForView:(UIView *)view {
    self.frame = CGRectMake(0, view.bounds.size.height, view.bounds.size.width, kHeightOfBanner);
    self.contentView.frame = self.bounds;
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.frame = CGRectMake(self.frame.origin.x, self.superview.frame.size.height - kHeightOfBanner, self.frame.size.width, self.frame.size.height);
}

- (void)showOnView:(UIView *)view animated:(BOOL)animated withCompletion:(void(^)())completion {
    [super showOnView:view animated:animated withCompletion:nil];
    [self configurateShowingForView:view];
    
    if(!animated) {
        [view addSubview:self];
        [view bringSubviewToFront:self];
        if(completion) {
            completion();
        }
        return;
    }
    
    [view addSubview:self];
    [view bringSubviewToFront:self];
    
    [UIView animateKeyframesWithDuration:0.4
                                   delay:0.5
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
                                      self.frame = CGRectOffset(self.frame, 0, -self.bounds.size.height);
                                  }];
                              } completion:^(BOOL finished) {
                                  NSLog(@"%@", self.description);
                                  if(completion) {
                                      completion();
                                  }
                              }];
}

- (void)hideAnimated:(BOOL)animated withCompletion:(void (^)())completion {
    [super hideAnimated:animated withCompletion:nil];
    if(!animated) {
        [self removeFromSuperview];
        if(completion) {
            completion();
        }
        return;
    }
    
    [UIView animateKeyframesWithDuration:0.3
                                   delay:0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
                                      self.frame = CGRectOffset(self.frame, 0, self.bounds.size.height);
                                  }];
                              } completion:^(BOOL finished) {
                                  [self removeFromSuperview];
                                  if(completion) {
                                      completion();
                                  }
                              }];
}

@end
