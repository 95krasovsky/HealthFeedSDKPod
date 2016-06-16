//
//  HFFeedItemCell.h
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFContentCell.h"

@protocol HFFeedItemCellDelegate <HFContentCellDelegate>
- (void)pressedFavouriteWithArticle:(HFFeedItem *)article;
- (void)pressedLikeWithArticle:(HFFeedItem *)article;
- (void)pressedCommentWithArticle:(HFFeedItem *)article;
- (void)pressedQuestionWithArticle:(HFFeedItem *)article;
@end


@interface HFFeedItemCell : HFContentCell
@property (nonatomic, weak) id <HFFeedItemCellDelegate> delegate;
@end
