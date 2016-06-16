//
//  ExpandableTextViewCell.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/14/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFMetadataItemCell.h"

#define DEFAULT_HEIGHT self.textViewDefaultHeight.constant

@interface HFMetadataItemCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewDefaultHeight;


@end

@implementation HFMetadataItemCell


- (void)updateWithMetadata:(HFFeedMetadataElement *)metadataItem {
    [self setupTextView];
}

- (void)setupTextView{
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewTapped:)];
    tapGR.delegate = self;
    for (UIGestureRecognizer *recognizer in self.textView.gestureRecognizers){
        [self.textView removeGestureRecognizer:recognizer];
    }
    [self.textView addGestureRecognizer:tapGR];
}

- (void)textViewTapped:(UITapGestureRecognizer *)recognizer{
    
    CGFloat fixedWidth = self.textView.frame.size.width;
    CGSize newSize = [self.textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = self.textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    if (self.textViewHeight.constant == DEFAULT_HEIGHT){
        self.textViewHeight.constant = (newFrame.size.height >= DEFAULT_HEIGHT) ? newFrame.size.height : DEFAULT_HEIGHT;
    } else{
        self.textViewHeight.constant = DEFAULT_HEIGHT;
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

@end
