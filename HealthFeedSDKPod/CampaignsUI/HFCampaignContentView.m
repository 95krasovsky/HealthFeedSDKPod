//
//  HFCampaignContentView.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/2/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCampaignContentView.h"

@implementation HFCampaignContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _closeButton.frame = CGRectMake(0, 0, 30, 30);
        [_closeButton setImage:[UIImage imageNamed:@"close_campaign_button"] forState:UIControlStateNormal];
        [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 5, 0)];
        [self addSubview:_closeButton];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(CGRectEqualToRect(self.frame, window.frame)) {
        _closeButton.frame = CGRectMake(self.bounds.size.width - _closeButton.bounds.size.width, 20, _closeButton.bounds.size.width, _closeButton.bounds.size.height);
    } else {
        _closeButton.frame = CGRectMake(self.bounds.size.width - _closeButton.bounds.size.width, 0, _closeButton.bounds.size.width, _closeButton.bounds.size.height);
    }
}

- (void)addSubview:(UIView *)view {
    [super addSubview:view];
    
    [self bringSubviewToFront:_closeButton];
}

@end
