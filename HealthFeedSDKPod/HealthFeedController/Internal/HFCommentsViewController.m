//
//  HFCommentsViewController.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/14/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCommentsViewController.h"
#import "HFCommentCell.h"
#import "HFContentManager.h"
#import "MBProgressHUD.h"



@interface HFCommentsViewController()

@property (nonatomic, strong, readonly) NSArray *comments;

@end

@implementation HFCommentsViewController

- (NSArray *)comments{
    return self.article.metadata.comments;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"Featured comments";
}

#pragma mark - TableView Data Source and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *HFCommentCellId = @"HFCommentCellId";
    HFCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:HFCommentCellId];
    [cell updateWithMetadata:self.comments[indexPath.row]];
    return cell;
}



#pragma mark - actions

- (IBAction)sendBtnPressed:(UIButton *)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[HFContentManager sharedInstance] addComment:self.textView.text toArticle:self.article completion:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.textView resignFirstResponder];
        self.textView.text = @"";
        [self updateUI];
        [super sendBtnPressed:sender];
    }];
    return;
}



@end
