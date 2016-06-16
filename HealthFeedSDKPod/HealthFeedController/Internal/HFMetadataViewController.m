//
//  HFMetadataViewController.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/14/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFMetadataViewController.h"

@interface HFMetadataViewController ()


@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@end

@implementation HFMetadataViewController

- (void)viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];		

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    
    
    self.textView.layer.cornerRadius = 5.0;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0].CGColor;
    [self updateUI];
}

- (void)setArticle:(HFFeedItem *)article{
    _article = article;
    [self updateUI];
}

- (void)updateUI{
    self.titleLabel.text = self.article.title;
    [self.tableView reloadData];
    [self scrollToBottom];
}

#pragma mark - TableView Data Source and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //Need to override
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Need to override
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


#pragma mark - actions

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length){
        self.sendButton.enabled = YES;
    } else{
        self.sendButton.enabled = NO;
    }
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    if (newSize.height < 100){
        self.textViewHeight.constant = newSize.height;
    }

    [UIView animateWithDuration:0.3
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (void)keyboardWasShown:(NSNotification*)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *aValue = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
   CGSize keyboardSize = [aValue CGRectValue].size;
    self.bottomDistance.constant = keyboardSize.height;

    [UIView animateWithDuration:0.0
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
    [self scrollToBottom];
}

- (void)scrollToBottom{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self tableView:self.tableView numberOfRowsInSection:0] - 1 inSection: 0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition: UITableViewScrollPositionTop animated: YES];
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    self.bottomDistance.constant = 0;
    [UIView animateWithDuration:0.0
                     animations:^{
                         [self.view layoutIfNeeded];
                     }];
}

- (IBAction)sendBtnPressed:(UIButton *)sender{
    [self textViewDidChange:self.textView];
    //Need to override
    return;
}




@end
