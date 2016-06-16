//
//  HFContentCell.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFContentCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define IMAGE_HEIGHT self.imageViewHeight.constant

@interface HFContentCell () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *linkLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;

@property (weak, nonatomic) IBOutlet UIImageView *typeIcon1;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon2;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon3;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon4;
@property (weak, nonatomic) IBOutlet UIImageView *typeIcon5;

@end


@implementation HFContentCell

- (void)updateWithArticle:(HFFeedItem *)article{
    if (article != self.article){
        self.textViewHeight.constant = IMAGE_HEIGHT;
    }
    self.article = article;
    [self setupContent];
    [self setupTextView];
    [self setupTitleLabel];
    }

- (void)setupContent{
    self.titleLabel.text = self.article.title;
    self.linkLabel.text = self.article.linkHostName;
    self.textView.text = self.article.summary;
    [self.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", [self.article.imageURL substringFromIndex:6]]]];
}

- (void)setupTextView{
    UIBezierPath * imgRect = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, IMAGE_HEIGHT , IMAGE_HEIGHT)];
    self.textView.textContainer.exclusionPaths = @[imgRect];
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
    tapGR.delegate = self;
    for (UIGestureRecognizer *recognizer in self.textView.gestureRecognizers){
        [self.textView removeGestureRecognizer:recognizer];
    }
    [self.textView addGestureRecognizer:tapGR];
}

- (void)setupTitleLabel{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelTapped)];
    tapGR.delegate = self;
    for (UIGestureRecognizer *recognizer in self.titleLabel.gestureRecognizers){
        [self.titleLabel removeGestureRecognizer:recognizer];
    }
    [self.titleLabel addGestureRecognizer:tapGR];
}

#pragma mark - Actions

- (void)titleLabelTapped{

    [self.delegate pressedTitleWithArticle:self.article];
}

- (void)textViewTapped:(UITapGestureRecognizer *)recognizer{
    
    CGFloat fixedWidth = self.textView.frame.size.width;
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    if (self.textViewHeight.constant == IMAGE_HEIGHT){
        self.textViewHeight.constant = (newFrame.size.height >= IMAGE_HEIGHT) ? newFrame.size.height : IMAGE_HEIGHT;
    } else{
        self.textViewHeight.constant = IMAGE_HEIGHT;
    }
    
    [self reloadCell];
    
}

- (void)reloadCell{
    [UIView animateWithDuration: 0.3 animations: ^{ [self.contentView layoutIfNeeded]; }]; // Or self.contentView if you're doing this from your own cell subclass
    UIView *view = [self superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    UITableView *tableView = (UITableView *)view;
    [tableView beginUpdates];
    [tableView endUpdates];
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


@end
