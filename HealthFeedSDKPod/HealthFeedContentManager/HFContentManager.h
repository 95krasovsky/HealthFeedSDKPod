//
//  HFContentManager.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/17/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFModel.h"
#import "HFAPIClient.h"

typedef void (^FeedCompletionHandler)(HFFeedResponse *feedResponse, NSError *error);

@interface HFContentManager : NSObject

@property(nonatomic, strong)NSMutableArray *extraUserData; //List of HFExtraData

+ (instancetype)sharedInstance;

- (void)resetContent;
- (BOOL)isContentReseted;

- (void)loadPreviousFeedPageWithComplition:(FeedCompletionHandler)completion;
- (void)loadCurrentFeedPageWithComplition:(FeedCompletionHandler)completion;
- (void)loadNextFeedPageWithComplition:(FeedCompletionHandler)completion;

- (void)getPersonalFolderItemsWithCompletion:(MetadataCompletionHandler)completion;
- (void)getSearchResultWithText:(NSString *)searchText resultsOffset:(NSInteger)offset andCompletion:(SearchCompletionHandler)completion;

- (void)markArticle:(HFFeedItem *)article asFavorite:(BOOL)favorite completion:(CompletionHandler)completion;
- (void)markArticle:(HFFeedItem *)article asLiked:(BOOL)liked completion:(CompletionHandler)completion;

- (void)addComment:(NSString *)comment toArticle:(HFFeedItem *)article completion:(CompletionHandler)completion;
- (void)addQuestion:(NSString *)question toArticle:(HFFeedItem *)article completion:(CompletionHandler)completion;

@end
