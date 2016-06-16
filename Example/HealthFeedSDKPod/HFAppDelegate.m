//
//  HFAppDelegate.m
//  HealthFeedSDKPod
//
//  Created by Vladislav Krasovsky on 06/16/2016.
//  Copyright (c) 2016 Vladislav Krasovsky. All rights reserved.
//

#import "HFAppDelegate.h"

@implementation HFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [[HealthFeedSDK sharedInstance] configurateWithApiKey:OAUTH_CLIENT_ID andApiSecret:OAUTH_CLIENT_SECRET];
    
    ////////EXAMPLE
    
    //Setup HealthFeedSDK
    [[HealthFeedSDK sharedInstance] configurateWithApiKey:OAUTH_CLIENT_ID andApiSecret:OAUTH_CLIENT_SECRET];
    
    //load application settings
    [[HFDataManager sharedInstance]loadManagerWithComplition:^(HFUserProfile *profile) {
        if(!profile) {
            profile = [[HFUserProfile alloc]init];
            profile.userID = @"geneate_your_own_unique_userID_if_user_is_new";
            [[HFDataManager sharedInstance]pushMemberHealthProfileInEnglish:profile withCompletion:^(HFUserProfile *profile, NSError *error) {
                self.window.rootViewController = [[HealthFeedViewController alloc] init];;
                [self.window makeKeyWindow];
            }];
        } else {
            self.window.rootViewController = [[HealthFeedViewController alloc] init];
            [self.window makeKeyWindow];
        }
    }];
    
    /////////////////
    
    //    [[HFDataManager sharedInstance]pushMemberHealthProfileInEnglish:profile withCompletion:^(HFUserProfile *profile, NSError *error) {
    //
    //        HealthFeedViewController *controller = [HealthFeedViewController ]
    //
    //        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"HealthFeedStoryboard" bundle:nil] instantiateInitialViewController];
    //        [self.window makeKeyWindow];
    //    }];
    //
    /*
     
     HFAPIClient *weakClient = client;
     [client updateUserProfile:profile withCompletion:^(NSString *reference, NSInteger start, NSError *error) {
     [weakClient conditionsWithCompletion:^(NSArray *conditions, NSError *error) {
     NSLog(@"");
     
     NSArray * selectedConditions = [conditions subarrayWithRange:NSMakeRange(0, 2)];
     
     [weakClient contentByConditions:selectedConditions
     userProfile:profile completion:^(HFFeedResponse *feedResponse, HFError *feedError, NSError *error) {
     NSLog(@"");
     
     // profile.start = 5;
     HFFeedItem *article = feedResponse.articles.firstObject;
     [weakClient markArticleAsLiked:article withUserProfile:profile completion:^(NSError *error) {
     NSLog(@"");
     [weakClient markArticleAsFavorite:article withUserProfile:profile completion:^(NSError *error) {
     NSLog(@"");
     [weakClient addComment:@"my first comment" toArticle:article withUserProfile:profile completion:^(NSError *error) {
     NSLog(@"");
     [weakClient addQuestion:@"my first question" toArticle:article withUserProfile:profile completion:^(NSError *error) {
     NSLog(@"");
     
     [weakClient contentWithMetadataForUserProfile:profile
     andCompletion:^(NSArray *favoritesArticles, NSArray *likedArticles, NSArray *commentedArticles, NSArray *questionsArticles, NSError *error) {
     NSLog(@"");
     }];
     }];
     }];
     }];
     
     
     [weakClient contentByProfile:profile
     completion:^(HFFeedResponse *feedResponse, HFError *feedError, NSError *error) {
     NSLog(@"");
     }];
     
     
     [weakClient campaignsForFeed:feedResponse
     andUserProfile:profile
     completion:^(NSArray *qualifiedCampaigns, NSArray *associatedCampaigns, NSError *error) {
     NSLog(@"");
     }];
     }];
     }];
     }];
     
     [weakClient searchContentWithText:@"dia" articleOffset:0
     andCompletion:^(NSArray *articles, NSInteger totalFoundArticles, NSInteger currentArticleOffset, NSError *error) {
     NSLog(@"");
     }];
     }];
     
     
     */
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
