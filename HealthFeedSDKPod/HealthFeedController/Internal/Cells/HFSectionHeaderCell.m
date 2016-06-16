//
//  HFSectionHeaderCell.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFSectionHeaderCell.h"

@interface HFSectionHeaderCell ()

@property (weak, nonatomic) IBOutlet UIView *countView;

@end

@implementation HFSectionHeaderCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.countView.layer.cornerRadius = 10.0;
}

@end
