//
//  HFSearchViewController.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/1/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFSearchViewController.h"
#import "MBProgressHUD.h"
#import "HFContentCell.h"
#import "HFFeedResponse.h"
#import "HFFeedItemCell.h"
#import "PBWebViewController.h"
#import "HFContentManager.h"
#import "HFLoaderCell.h"
#import "HFPlaceholderCell.h"

@interface HFSearchViewController () <UITableViewDelegate, UITableViewDataSource, HFContentCellDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HFFeedResponse *lastFeedResponse;
@property (nonatomic) BOOL isLoading;
@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic) NSInteger currentArticleOffset;
@property (nonatomic) NSInteger totalFoundArticles;
@property (nonatomic, strong) NSString *searchText;
@end

@implementation HFSearchViewController

- (void)viewDidLoad{
    self.articles = [NSMutableArray array];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 131;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    self.searchText = @"";
    self.currentArticleOffset = -1;
    [self loadArticlesWithSearchString];

}

- (void)loadArticlesWithSearchString{
    if (self.isLoading) return;
    self.isLoading = YES;
    NSInteger newOffset = (self.currentArticleOffset == -1) ? 0 : self.currentArticleOffset + 5;
    if (newOffset == 0){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [[HFContentManager sharedInstance]getSearchResultWithText:self.searchText resultsOffset:newOffset andCompletion:^(NSArray *articles, NSInteger totalFoundArticles, NSInteger currentArticleOffset, NSError *error) {
        self.isLoading = NO;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.currentArticleOffset = currentArticleOffset;
        self.totalFoundArticles = totalFoundArticles;
        [self.articles addObjectsFromArray: articles];
        [self.tableView reloadData];
    }];    
}

#pragma mark - HFContentCellDelegate

- (void)pressedTitleWithArticle:(HFFeedItem *)article{
    [self performSegueWithIdentifier:@"showWebViewSegueId" sender:article];
}

#pragma mark - TableView Data Source and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.currentArticleOffset + 5 >= self.totalFoundArticles){
        if (self.articles.count){
            return self.articles.count;
        } else{
            if (self.currentArticleOffset == -1){
                return 0;
            } else{
                return 1;
            }
        }
    } else{
        return self.articles.count + 1;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.articles.count) return;
    if ((indexPath.row == [self.articles count]) && (self.currentArticleOffset + 5 < self.totalFoundArticles)) {
        [self loadArticlesWithSearchString];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && self.articles.count == 0){
        static NSString *PlaceholderCellId = @"PlaceholderCellId";
        HFPlaceholderCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellId forIndexPath:indexPath];
        [cell updateWithSearchText:self.searchText];
        return cell;
    }
    if (indexPath.row == [self.articles count]) {
        static NSString *LoaderCellId = @"LoaderCellId";
        HFLoaderCell *cell = [tableView dequeueReusableCellWithIdentifier:LoaderCellId forIndexPath:indexPath];
        [cell.activityIndicator startAnimating];
        return cell;
    } else {
        static NSString *FeedItemCellId = @"FeedItemCellId";
        HFContentCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedItemCellId];
        cell.delegate = self;
        [cell updateWithArticle:self.articles[indexPath.row]];
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showWebViewSegueId"]){
        HFFeedItem *article = (HFFeedItem *)sender;
        PBWebViewController * webViewController = (PBWebViewController *)segue.destinationViewController;
        webViewController.URL = [NSURL URLWithString:article.link];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.articles = [NSMutableArray array];
    self.totalFoundArticles = 0;
    self.currentArticleOffset = -1;
    [self.tableView reloadData];
    self.searchText = searchBar.text;
    self.isLoading = NO;
    [self loadArticlesWithSearchString];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    searchBar.text = self.searchText;
}


@end
