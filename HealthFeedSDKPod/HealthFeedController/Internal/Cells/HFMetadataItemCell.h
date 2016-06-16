//
//  ExpandableTextViewCell.h
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/14/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFeedMetadataElement.h"

@interface HFMetadataItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextView *textView;


- (void)updateWithMetadata:(HFFeedMetadataElement *)metadataItem;

@end
