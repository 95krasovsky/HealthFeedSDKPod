//
//  HFFeedItemCell.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFFeedItemCell.h"

@interface HFFeedItemCell () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *favouriteBtn;
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;

@end

@implementation HFFeedItemCell

@dynamic delegate;

- (void)updateWithArticle:(HFFeedItem *)article{
    [super updateWithArticle:article];
    [self setupButtons];
}

- (void)setupButtons{
    [self.favouriteBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.likeBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.commentBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.questionBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
}


#pragma mark - Actions

- (IBAction)favouriteBtnPressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [self.delegate pressedFavouriteWithArticle:self.article];
}

- (IBAction)likeBtnPressed:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    [self.delegate pressedLikeWithArticle:self.article];
}

- (IBAction)commentBtnPressed:(UIButton *)sender {
    [self.delegate pressedCommentWithArticle:self.article];
}

- (IBAction)questionBtnPressed:(UIButton *)sender {
    [self.delegate pressedQuestionWithArticle:self.article];
}


@end
