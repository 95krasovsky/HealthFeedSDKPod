//
//  HFPlaceholderCell.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/9/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFPlaceholderCell.h"

@interface HFPlaceholderCell ()

@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@end

@implementation HFPlaceholderCell

- (void)updateWithSearchText:(NSString *)str{
    self.warningLabel.text = [NSString stringWithFormat:@"We did not find results for \"%@\". Try the suggestions below or type a new query above.", str];
}

@end
