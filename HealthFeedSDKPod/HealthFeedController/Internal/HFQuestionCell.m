//
//  HFQuestionCell.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/14/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFQuestionCell.h"

@implementation HFQuestionCell

- (void)updateWithMetadata:(HFFeedMetadataElement *)metadataItem{
    [super updateWithMetadata:metadataItem];
    NSMutableAttributedString *attributedQ;
    if (metadataItem.message.length){
        attributedQ = [[NSMutableAttributedString alloc] initWithString:@"Q: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]}];
        [attributedQ appendAttributedString:[[NSAttributedString alloc] initWithString:metadataItem.message attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular]}]];
    }
    NSMutableAttributedString *attributedA;
    if (metadataItem.response.length){
        attributedA = [[NSMutableAttributedString alloc] initWithString:@"\nA: " attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightBold]}];
        [attributedA appendAttributedString:[[NSAttributedString alloc] initWithString:metadataItem.response attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0 weight:UIFontWeightRegular]}]];
        [attributedQ appendAttributedString:attributedA];
    }
    
    self.textView.attributedText = attributedQ;
}

@end
