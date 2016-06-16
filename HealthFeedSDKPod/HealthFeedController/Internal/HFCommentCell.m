
//
//  HFCommentCell.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/14/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCommentCell.h"

@implementation HFCommentCell

- (void)updateWithMetadata:(HFFeedMetadataElement *)metadataItem{
    [super updateWithMetadata:metadataItem];
    self.textView.text = metadataItem.message;
}

@end
