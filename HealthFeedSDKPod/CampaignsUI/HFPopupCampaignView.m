//
//  HFPopupCampaignView.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/2/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFPopupCampaignView.h"

@implementation HFPopupCampaignView

- (void)setupView {
    [super setupView];
}

- (void)configurateShowingForView:(UIView *)view {
    self.frame = view.bounds;
    self.contentView.frame = CGRectMake(0, 0, view.frame.size.width - 40, view.frame.size.height/3);
    self.contentView.center = self.center;
    
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
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
    
    self.alpha = 0;
    CGAffineTransform defaultTransform = self.contentView.transform;
    self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
    
    [UIView animateKeyframesWithDuration:0.4
                                   delay:0.5
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.1 animations:^{
                                      self.alpha = 1;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
                                      self.contentView.transform = CGAffineTransformScale(defaultTransform, 1.1, 1.1);
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.3 animations:^{
                                      self.contentView.transform = CGAffineTransformScale(defaultTransform, 0.9, 0.9);
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.4 animations:^{
                                      self.contentView.transform = defaultTransform;
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations:^{
                                      self.backgroundView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];
                                  }];
                              } completion:^(BOOL finished) {
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
                                  [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
                                      self.backgroundView.backgroundColor = [UIColor clearColor];
                                  }];
                                  [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
                                      self.contentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                      self.alpha = 0;
                                  }];
                                  
                              } completion:^(BOOL finished) {
                                  [self removeFromSuperview];
                                  if(completion) {
                                      completion();
                                  }
                              }];
}

@end
