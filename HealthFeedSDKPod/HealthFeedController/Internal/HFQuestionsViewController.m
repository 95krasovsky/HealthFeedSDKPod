//
//  HFQuestionsViewController.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/14/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFQuestionsViewController.h"
#import "HFQuestionCell.h"
#import "HFContentManager.h"
#import "MBProgressHUD.h"

@interface HFQuestionsViewController()

@property (nonatomic, strong, readonly) NSArray *questions;

@end

@implementation HFQuestionsViewController

- (NSArray *)questions{
    return self.article.metadata.questions;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = @"Featured questions";
}

#pragma mark - TableView Data Source and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *HFQuestionCellId = @"HFQuestionCellId";
    HFQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:HFQuestionCellId];
    [cell updateWithMetadata:self.questions[indexPath.row]];
    return cell;
}


#pragma mark - actions

- (IBAction)sendBtnPressed:(UIButton *)sender{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[HFContentManager sharedInstance] addQuestion:self.textView.text toArticle:self.article completion:^(NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self.textView resignFirstResponder];
        self.textView.text = @"";
        [self updateUI];
        [super sendBtnPressed:sender];

    }];
    return;
}

@end
