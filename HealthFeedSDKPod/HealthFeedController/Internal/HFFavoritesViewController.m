//
//  HFFavoritesViewController.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/1/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFFavoritesViewController.h"
#import "HFContentManager.h"
#import "HFLoaderCell.h"
#import "HFFeedItemCell.h"
#import "HFTitleCell.h"
#import "HFSectionHeaderCell.h"
#import "PBWebViewController.h"
#import "HFCommentsViewController.h"
#import "HFQuestionsViewController.h"

@interface HFFavoritesViewController () <UITableViewDelegate, UITableViewDataSource, HFFeedItemCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL isLoading;

@property (nonatomic, strong) NSArray *sectionNames;
@property (nonatomic, strong) NSMutableDictionary *articles;
@property (nonatomic, strong) NSMutableDictionary *showArticleInSection;

@end

@implementation HFFavoritesViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.articles = [NSMutableDictionary dictionary];
    self.showArticleInSection = [NSMutableDictionary dictionary];
    self.sectionNames = @[
                          @"Favourites",
                          @"Likes",
                          @"Comments",
                          @"Questions"
                          ];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 131;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    [self loadData];
}

- (void)loadData{
    if (self.isLoading) return;
    [self.refreshControl beginRefreshing];
    self.isLoading = YES;
    [[HFContentManager sharedInstance]getPersonalFolderItemsWithCompletion:^(NSArray *favoritesArticles, NSArray *likedArticles, NSArray *commentedArticles, NSArray *questionsArticles, NSError *error) {
        for (NSString *section in self.sectionNames){
            [self.articles setObject:[NSMutableArray array] forKey:section];
            [self.showArticleInSection setObject:[NSMutableArray array] forKey:section];
        }
        
        self.isLoading = NO;
        [self.refreshControl endRefreshing];
        if (error){
            NSLog(@"ERR: %@", error.localizedDescription);
            return;
        }
        NSMutableArray *favourites = [self.articles objectForKey:self.sectionNames[0]];
        [favourites addObjectsFromArray:favoritesArticles];
        NSMutableArray *liked = [self.articles objectForKey:self.sectionNames[1]];
        [liked addObjectsFromArray:likedArticles];
        NSMutableArray *comments = [self.articles objectForKey:self.sectionNames[2]];
        [comments addObjectsFromArray:commentedArticles];
        NSMutableArray *questions = [self.articles objectForKey:self.sectionNames[3]];
        [questions addObjectsFromArray:questionsArticles];
        
        for (NSString *section in self.sectionNames){
            NSMutableArray *articles = [self.articles objectForKey:section];
            NSMutableArray *showFavouritesAtIndex = [self.showArticleInSection objectForKey:section];
            for (int i = 0; i < articles.count; i++){
                showFavouritesAtIndex[i] = @(0);
            }
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - TableView Data Source and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int n = 1;
    for (int i = 1; i < 4; i++){
        if ([[self.articles objectForKey:self.sectionNames[i]] count]){
            n++;
        }
    }
    return n;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num;
    if (section == 0){
        num = 1;
    } else{
        num = 0;
    }
    NSString *sectionName = self.sectionNames[section];
    NSArray *expands = [self.showArticleInSection objectForKey:sectionName];
    num = num + [[self.articles objectForKey:sectionName] count] + [[expands valueForKeyPath:@"@sum.self"] integerValue];
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *section = self.sectionNames[indexPath.section];
    NSArray *articles = [self.articles objectForKey:section];

    if (indexPath.row == 0) {
        static NSString *SectionHeaderCellId = @"SectionHeaderCellId";
        HFSectionHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:SectionHeaderCellId forIndexPath:indexPath];
        cell.titleLabel.text =  self.sectionNames[indexPath.section];
        cell.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)articles.count];
        return cell;
    } else {
        NSArray *showArticlesAtIndex = [self.showArticleInSection objectForKey:section];
        long row = indexPath.row - 1;
        int i = 0;
        int n = -1;
        while (n <= row){
            n += 1;
            if (n == row){
                static NSString *TitleCellId = @"TitleCellId";
                HFTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:TitleCellId];
                cell.titleLabel.text = [articles[i] title];
                return cell;
            }
            n += [showArticlesAtIndex[i] integerValue];
            
            if (n == row){
                static NSString *FeedItemCellId = @"FeedItemCellId";
                HFFeedItemCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedItemCellId];
                cell.delegate = self;
                [cell updateWithArticle:articles[i]];
                return cell;
            }
            i++;
        }
        NSLog(@"Something wrong with it");
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSString *section = self.sectionNames[indexPath.section];
    NSMutableArray *showArticlesAtIndex = [self.showArticleInSection objectForKey:section];
    long row = indexPath.row - 1;
    int i = 0;
    int n = -1;
    while (n <= row){
        n += 1;
        if (n == row){
            long k = [showArticlesAtIndex[i] integerValue];
            k = ((k+1)%2);
            showArticlesAtIndex[i] = [NSNumber numberWithInteger:k];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section];

            if (k == 1){
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else{
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            return;
        }
        n += [showArticlesAtIndex[i] integerValue];
        
        if (n == row){
            return;
        }
        i++;
    }
}

#pragma mark - HFContentCellDelegate

- (void)pressedTitleWithArticle:(HFFeedItem *)article{
    [self performSegueWithIdentifier:@"showWebViewSegueId" sender:article];
}

- (void)pressedFavouriteWithArticle:(HFFeedItem *)article {
    [[HFContentManager sharedInstance]markArticle:article asFavorite:!article.metadata.isFavorite completion:^(NSError *error) {
        [self.tableView reloadData];
    }];
}

- (void)pressedLikeWithArticle:(HFFeedItem *)article {
    [[HFContentManager sharedInstance]markArticle:article asLiked:!article.metadata.liked completion:^(NSError *error) {
        [self.tableView reloadData];
    }];
}

- (void)pressedCommentWithArticle:(HFFeedItem *)article {
    [self performSegueWithIdentifier:@"showCommentsVCSegueId" sender:article];
}

- (void)pressedQuestionWithArticle:(HFFeedItem *)article {
    [self performSegueWithIdentifier:@"showQuestionsVCSegueId" sender:article];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showWebViewSegueId"]){
        HFFeedItem *article = (HFFeedItem *)sender;
        PBWebViewController * webViewController = (PBWebViewController *)segue.destinationViewController;
        webViewController.URL = [NSURL URLWithString:article.link];
    }
    if ([segue.identifier isEqualToString:@"showCommentsVCSegueId"]){
        HFCommentsViewController *commentsVC = (HFCommentsViewController *)segue.destinationViewController;
        HFFeedItem *article = (HFFeedItem *)sender;
        commentsVC.article = article;
    }
    if ([segue.identifier isEqualToString:@"showQuestionsVCSegueId"]){
        HFQuestionsViewController *questionsVC = (HFQuestionsViewController *)segue.destinationViewController;
        HFFeedItem *article = (HFFeedItem *)sender;
        questionsVC.article = article;
    }

}

@end
