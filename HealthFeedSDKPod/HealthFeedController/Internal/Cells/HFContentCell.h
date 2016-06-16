//
//  HFContentCell.h
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFeedItem.h"

@protocol HFContentCellDelegate <NSObject>
- (void)pressedTitleWithArticle: (HFFeedItem *)article;
@end

@interface HFContentCell : UITableViewCell

@property (strong, nonatomic) HFFeedItem *article;
@property (nonatomic, weak) id <HFContentCellDelegate> delegate;
- (void)updateWithArticle:(HFFeedItem *)article;

@end
