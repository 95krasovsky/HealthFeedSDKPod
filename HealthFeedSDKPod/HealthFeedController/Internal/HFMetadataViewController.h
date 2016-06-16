//
//  HFMetadataViewController.h
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/14/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFeedItem.h"

@interface HFMetadataViewController : UIViewController <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) HFFeedItem *article;

- (void)updateUI;
- (IBAction)sendBtnPressed:(UIButton *)sender;

@end
