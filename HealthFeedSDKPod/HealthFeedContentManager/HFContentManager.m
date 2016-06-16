//
//  HFContentManager.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/17/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFContentManager.h"
#import "HFAPIClient.h"
#import "HFDataManager.h"

#define kNumberArticlesOnPage   5

@interface HFContentManager() {
    
    HFAPIClient *_apiClient;
    
    HFFeedResponse *_lastLoadedFeedResponse;
    NSInteger _currentStart;
    NSInteger _topStart;
    NSInteger _bottomStart;
}


@property(readonly)HFUserProfile *userProfile;
@property(readonly)HFMedicalHistory *medicalHistory;

@end

@implementation HFContentManager

+ (instancetype)sharedInstance {
    static HFContentManager *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[HFContentManager alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _apiClient = [[HFAPIClient alloc]init];
        [self resetContent];
    }
    return self;
}

- (HFUserProfile *)userProfile {
    return [HFDataManager sharedInstance].userProfile;
}

- (HFMedicalHistory *)medicalHistory {
    if([self.userProfile isKindOfClass:[HFMedicalUserProfile class]]) {
        HFMedicalUserProfile *medicalProfile = (HFMedicalUserProfile *)self.userProfile;
        return medicalProfile.medicalHistory;
    }
    return nil;
}

- (NSMutableArray *)healthConditions {
    return [HFDataManager sharedInstance].userProfile.conditions;
}

#pragma mark - Internal
- (void)processFeedResoponse:(HFFeedResponse *)response start:(NSInteger)start reference:(NSString *)reference {
    _lastLoadedFeedResponse = response;
    if(reference) {
        self.userProfile.reference = reference;
        self.userProfile.start = start;
        _currentStart = start;
    }
}

#pragma mark - Public
- (void)resetContent {
    _lastLoadedFeedResponse = nil;
    NSInteger userStart = self.userProfile.start > 0 ? self.userProfile.start : 0;
    _currentStart = userStart;
    _topStart = userStart;
    _bottomStart = userStart;
}

- (BOOL)isContentReseted {
    return (_lastLoadedFeedResponse == nil);
}

#pragma mark - Load Content
- (void)loadPreviousFeedPageWithComplition:(FeedCompletionHandler)completion {
    if(_topStart - kNumberArticlesOnPage >= 0) {
        _topStart -= kNumberArticlesOnPage;
        _currentStart = _topStart;
        [self loadCurrentFeedPageWithComplition:completion];
    } else {
        completion(nil, nil);
    }
}

- (void)loadNextFeedPageWithComplition:(FeedCompletionHandler)completion {
    _bottomStart += kNumberArticlesOnPage;
    _currentStart = _bottomStart;
    [self loadCurrentFeedPageWithComplition:completion];
}

- (void)loadCurrentFeedPageWithComplition:(FeedCompletionHandler)completion {
    [self loadFeedPageFromStart:_currentStart withComplition:completion];
}

- (void)loadFeedPageFromStart:(NSInteger)start withComplition:(FeedCompletionHandler)completion {
    self.userProfile.start = start;
    
    if(self.medicalHistory && !_lastLoadedFeedResponse) {
        [_apiClient contentByMedicalHistory:self.medicalHistory
                                userProfile:self.userProfile
                              extraDataList:self.extraUserData
                                 completion:^(HFFeedResponse *feedResponse, NSInteger start, NSString *referense, HFError *feedError,  NSError *error) {
                                     [self processFeedResoponse:feedResponse start:start reference:referense];
                                     completion(feedResponse, error);
                                 }];
    } else if(_lastLoadedFeedResponse) {
        [_apiClient contentByProfile:self.userProfile
                          completion:^(HFFeedResponse *feedResponse, NSInteger start, NSString *referense, HFError *feedError, NSError *error) {
                              [self processFeedResoponse:feedResponse start:start reference:referense];
                              completion(feedResponse, error);
                          }];
    } else {
        [_apiClient contentByConditions:self.healthConditions
                            userProfile:self.userProfile
                          extraDataList:self.extraUserData
                             completion:^(HFFeedResponse *feedResponse, NSInteger start, NSString *referense, HFError *feedError, NSError *error) {
                                 [self processFeedResoponse:feedResponse start:start reference:referense];
                                 completion(feedResponse, error);
                             }];
    }
}

- (void)getPersonalFolderItemsWithCompletion:(MetadataCompletionHandler)completion {
    [_apiClient getPersonalFolderItemsForUserProfile:self.userProfile andCompletion:completion];
}

#pragma mark - Searching
- (void)getSearchResultWithText:(NSString *)searchText resultsOffset:(NSInteger)offset andCompletion:(SearchCompletionHandler)completion {
    [_apiClient getSearchResultsWithText:searchText resultsOffset:offset andCompletion:completion];
}

#pragma mark Work with Articles
- (void)markArticle:(HFFeedItem *)article asFavorite:(BOOL)favorite completion:(CompletionHandler)completion {
    if(article.metadata.isFavorite == favorite) {
        completion(nil);
        return;
    }
    
    [_apiClient markArticleAsFavorite:article withUserProfile:self.userProfile completion:^(NSError *error) {
        if(error) {
            completion(error);
            return;
        }
        article.metadata.isFavorite = favorite;
        completion(nil);
    }];
}

- (void)markArticle:(HFFeedItem *)article asLiked:(BOOL)liked completion:(CompletionHandler)completion {
    if(article.metadata.liked == liked) {
        completion(nil);
        return;
    }
    
    [_apiClient markArticleAsLiked:article withUserProfile:self.userProfile completion:^(NSError *error) {
        if(error) {
            completion(error);
            return;
        }
        article.metadata.liked = liked;
        completion(nil);
    }];
}

- (void)addComment:(NSString *)comment toArticle:(HFFeedItem *)article completion:(CompletionHandler)completion {
    if(comment.length == 0) {
        completion(nil);
        return;
    }
    
    [_apiClient addComment:comment toArticle:article withUserProfile:self.userProfile completion:^(NSError *error) {
        if(error) {
            completion(error);
            return;
        }
        NSMutableArray *loadedComments = [NSMutableArray array];
        if(article.metadata.comments) {
            loadedComments = [NSMutableArray arrayWithArray:article.metadata.comments];
        }
        HFFeedMetadataElement *element = [[HFFeedMetadataElement alloc]init];
        //TODO: hardcode, fix when we will got enum with types
        element.type = 0;
        element.message = comment;
        [loadedComments addObject:element];
        
        article.metadata.comments = loadedComments;
        
        completion(nil);
    }];
}

- (void)addQuestion:(NSString *)question toArticle:(HFFeedItem *)article completion:(CompletionHandler)completion{
    if(question.length == 0) {
        completion(nil);
        return;
    }
    
    [_apiClient addQuestion:question toArticle:article withUserProfile:self.userProfile completion:^(NSError *error) {
        if(error) {
            completion(error);
            return;
        }
        NSMutableArray *loadedQuestions = [NSMutableArray array];
        if(article.metadata.questions) {
            loadedQuestions = [NSMutableArray arrayWithArray:article.metadata.questions];
        }
        HFFeedMetadataElement *element = [[HFFeedMetadataElement alloc]init];
        //TODO: hardcode, fix when we will got enum with types
        element.type = 1;
        element.message = question;
        [loadedQuestions addObject:element];
        
        article.metadata.questions = loadedQuestions;
        
        completion(nil);
    }];
}

@end
