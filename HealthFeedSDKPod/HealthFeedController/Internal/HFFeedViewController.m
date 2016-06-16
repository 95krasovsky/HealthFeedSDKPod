//
//  HFFeedViewController.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/1/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFFeedViewController.h"
#import "HFFeedItemCell.h"
#import "HFContentManager.h"
#import "HFCampaignsManager.h"
#import "HFLoaderCell.h"
#import "HFFeedItemCell.h"
#import "PBWebViewController.h"
#import "HFCampaignView.h"
#import "HFCommentsViewController.h"
#import "HFFeedMetadataElement.h"
#import "HFQuestionsViewController.h"

@interface HFFeedViewController () <UITableViewDelegate, UITableViewDataSource, HFFeedItemCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) HFFeedResponse *lastFeedResponse;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) BOOL isLoading;
@end

@implementation HFFeedViewController


- (void)viewDidLoad{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    self.dataSource = [NSMutableArray array];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 131;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([[HFContentManager sharedInstance] isContentReseted]) {
        [_dataSource removeAllObjects];
        [self.tableView reloadData];
        
        [self.refreshControl beginRefreshing];
        self.isLoading = YES;
        [[HFContentManager sharedInstance] loadCurrentFeedPageWithComplition:^(HFFeedResponse *feedResponse, NSError *error) {
            [self processLoadedFeedResponse:feedResponse andError:error isPreviousPage:NO];
        }];
    }
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadPreviousArticles];
}

- (void)loadPreviousArticles {
    if (self.isLoading) return;
    [self.refreshControl beginRefreshing];
    self.isLoading = YES;
    
    [[HFContentManager sharedInstance]loadPreviousFeedPageWithComplition:^(HFFeedResponse *feedResponse, NSError *error) {
        [self processLoadedFeedResponse:feedResponse andError:error isPreviousPage:YES];
    }];
}

- (void)loadNextArticles {
    if (self.isLoading) return;
    [self.refreshControl beginRefreshing];
    self.isLoading = YES;
    
    [[HFContentManager sharedInstance] loadNextFeedPageWithComplition:^(HFFeedResponse *feedResponse, NSError *error) {
        [self processLoadedFeedResponse:feedResponse andError:error isPreviousPage:NO];
    }];
}

- (void)processLoadedFeedResponse:(HFFeedResponse *)feedResponse andError:(NSError *)contentError isPreviousPage:(BOOL)isPreviousPage {
    
    if(contentError) {
        self.isLoading = NO;
        [self.refreshControl endRefreshing];
        return;
    }
    
    [[HFCampaignsManager sharedInstance]loadCampaignsWithCompletion:^(NSError *error) {
        HFCampaignView *campaignView = [[HFCampaignsManager sharedInstance] showNextQualifiedCampaignForType:HFCampaignRenderingTypeInfeed];
        
        self.isLoading = NO;
        [self.refreshControl endRefreshing];
        self.lastFeedResponse = feedResponse;
        
        NSMutableArray *newdata = [NSMutableArray arrayWithArray:feedResponse.articles];
        if(campaignView) {
            if(newdata.count > 3) {
                NSInteger inserIndex = newdata.count/2 + arc4random_uniform(2);
                [newdata insertObject:campaignView atIndex:inserIndex];
            } else {
                [newdata addObject:campaignView];
            }
        }
        
        if(isPreviousPage) {
            [self.dataSource insertObjects:newdata
                                 atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newdata.count)]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            [self.dataSource addObjectsFromArray:newdata];
            [self.tableView reloadData];
        }
        
        [[HFCampaignsManager sharedInstance] showNextQualifiedCampaign];
    }];
}

- (void)addInfeedCampaignViewIntoFeed:(HFCampaignView *)campaignView atIndex:(NSInteger)index{
    NSInteger topCurrentIndex = [self.tableView indexPathForCell:self.tableView.visibleCells.firstObject].row;
    NSInteger bottomCurrentIndex = [self.tableView indexPathForCell:self.tableView.visibleCells.lastObject].row;
    
    if(topCurrentIndex == bottomCurrentIndex) {
        [self.dataSource addObject:campaignView];
    } else {
        [self.dataSource insertObject:campaignView atIndex:bottomCurrentIndex-topCurrentIndex/2];
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
    HFFeedMetadataElement *element1 = [[HFFeedMetadataElement alloc] initWithDictionary:@{
                                                                                          @"type":@(0),
                                                                                          @"msg":@"aslj kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk",
                                                                                          }];
    HFFeedMetadataElement *element2 = [[HFFeedMetadataElement alloc] initWithDictionary:@{
                                                                                          @"type":@(0),
                                                                                          @"msg":@"jshf  k ahf kha  kfhsakjh akjs kjsah shda fksgk glg k ",
                                                                                          }];
    HFFeedMetadataElement *element3 = [[HFFeedMetadataElement alloc] initWithDictionary:@{
                                                                                          @"type":@(0),
                                                                                          @"msg":@" h hfks fia iuyf iuaisdg aifig ifg isgaifgal ifkgsk gzgfisgfli y glsgyfd   h hfks fia iuyf iuaisdg aifig ifg isgaifgal ifkgsk gzgfisgfli y glsgyfd   h hfks fia iuyf iuaisdg aifig ifg isgaifgal ifkgsk gzgfisgfli y glsgyfd   h hfks fia iuyf iuaisdg aifig ifg isgaifgal ifkgsk gzgfisgfli y glsgyfd   h hfks fia iuyf iuaisdg aifig ifg isgaifgal ifkgsk gzgfisgfli y glsgyfd ",
                                                                                          }];
    HFFeedMetadataElement *element4 = [[HFFeedMetadataElement alloc] initWithDictionary:@{
                                                                                          @"type":@(0),
                                                                                          @"msg":@" ufi uas ifgsig fisa gfghashi ug lifg laigsisafglkg lkgkgfysgal  fgaflisgl ig lfgfguig",
                                                                                          }];
    if(!article.metadata.comments.count){
        article.metadata.comments = [NSArray arrayWithObjects:element1, element2, element3, element4, nil];
    }
    
    
    [self performSegueWithIdentifier:@"showCommentsVCSegueId" sender:article];
}

- (void)pressedQuestionWithArticle:(HFFeedItem *)article {
    
    HFFeedMetadataElement *element1 = [[HFFeedMetadataElement alloc] initWithDictionary:@{
                                                                                          @"type":@(0),
                                                                                          @"msg":@"aslj kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk",
                                                                                          @"resp":@"j kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahf sh siufg i ",

                                                                                          }];
    HFFeedMetadataElement *element2 = [[HFFeedMetadataElement alloc] initWithDictionary:@{
                                                                                          @"type":@(0),
                                                                                          @"msg":@"jshf  k ahf kha  kfhsakjh akjs kjsah shda fksgk glg k ",
                                                                                          @"resp":@"j kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahf sh siufg i ",

                                                                                          }];
    HFFeedMetadataElement *element3 = [[HFFeedMetadataElement alloc] initWithDictionary:@{
                                                                                          @"type":@(0),
                                                                                          @"msg":@" h hfks fia iuyf iuaisdg aifig ifg isgaifgal ifkgsk gzgfisgfli y glsgyfd   h hfks fia iuyf iuaisdg aifig ifg isgaifgal ifkgsk gzgfisgfli y glsgyfd   h hfks fia iuyf iuaisdg aifig ifg isgaifgal ifkgsk gzgfisgfli y glsgyfd   h hfks fia iuyf iuaisdg aifig ifg isgaifgal ifkgsk gzgfisgfli y glsgyfd   h hfks fia iuyf iuaisdg aifig ifg isgaifgal ifkgsk gzgfisgfli y glsgyfd ",
                                                                                          @"resp":@"j kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahf sh siufg i ",
                                                                                          }];
    HFFeedMetadataElement *element4 = [[HFFeedMetadataElement alloc] initWithDictionary:@{
                                                                                          @"type":@(0),
                                                                                          @"msg":@" ufi uas ifgsig fisa gfghashi ug lifg laigsisafglkg lkgkgfysgal  fgaflisgl ig lfgfguig",
                                                                                          @"resp":@"j kkjhsahf sh siufg i if  iua sigsgfslkg lkg aksgsdkg kgskag lkgf kagsk gfkjagskj gfajks gk aslj kkjhsahfh siufg i ",
                                                                                          }];
    



    if(!article.metadata.questions.count){
        article.metadata.questions = [NSArray arrayWithObjects:element1, element2, element3, element4, nil];
    }
    
    
    [self performSegueWithIdentifier:@"showQuestionsVCSegueId" sender:article];
}

#pragma mark - TableView Data Source and Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSource.count){
        return self.dataSource.count + 1;
    } else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.dataSource count] - 2 ) {
        [self loadNextArticles];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == [self.dataSource count]) {
        static NSString *LoaderCellId = @"LoaderCellId";
        HFLoaderCell *cell = [tableView dequeueReusableCellWithIdentifier:LoaderCellId forIndexPath:indexPath];
        [cell.activityIndicator startAnimating];
        return cell;
    } else if([self.dataSource[indexPath.row] isKindOfClass:[HFFeedItem class]]){
        static NSString *FeedItemCellId = @"FeedItemCellId";
        HFFeedItemCell *cell = [tableView dequeueReusableCellWithIdentifier:FeedItemCellId];
        cell.delegate = self;
        [cell updateWithArticle:self.dataSource[indexPath.row]];
        return cell;
    } else {
        HFCampaignView *campaignView = self.dataSource[indexPath.row];
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        [cell addSubview:campaignView];
        campaignView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 92);
        campaignView.contentView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 92);
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row < self.dataSource.count) {
        if([self.dataSource[indexPath.row] isKindOfClass:[HFCampaignView class]]) {
            return 92;
        }
    }
    return UITableViewAutomaticDimension;
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
