//
//  HFCampaignView.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 6/1/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFCampaignView.h"
#import "PBWebViewController.h"
#import "HFCampaignsUIFactory.h"
#import "ApiUrlConfigurator.h"
#import "HFCampaignsManager+Internal.h"

@interface HFCampaignView() <UIWebViewDelegate>

@end

@implementation HFCampaignView

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setupView];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (instancetype)initWithCampaing:(HFCampaignItem *)campaign {
    self = [self init];
    if(self) {
        self.campaign = campaign;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    _backgroundView.frame = self.bounds;
}

- (void)setShowPermissionCampaign:(BOOL)showPermissionCampaign {
    _showPermissionCampaign = showPermissionCampaign;
    
    [self reloadWebView];
}

- (void)setCampaign:(HFCampaignItem *)campaign {
    _campaign = campaign;
    [self reloadWebView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _webview.frame = self.contentView.bounds;
}


#pragma mark - 
- (void)setupView {
    if(!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.center = self.center;
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_backgroundView];
    }
    
    if(!_contentView) {
        _contentView = [[HFCampaignContentView alloc]init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.center = self.center;
        [_contentView.closeButton addTarget:self action:@selector(closeCampaignViewDidTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_contentView];
    }
    
    _webview = [[UIWebView alloc]initWithFrame:self.contentView.bounds];
    _webview.delegate = self;
    [self.contentView addSubview:_webview];
    
    [self reloadWebView];
}

- (void)configurateShowingForView:(UIView *)view {
    //for override
}

- (void)reloadWebView {
    
    if(self.campaign) {
        [_webview loadHTMLString:(self.showPermissionCampaign ? self.campaign.permissionHTML : self.campaign.campaignHTML)
                         baseURL:[NSURL fileURLWithPath:[ApiUrlConfigurator pathToWebResourcesFolder]]];
        _webview.backgroundColor = [UIColor whiteColor];
        _webview.scrollView.scrollEnabled = NO;
    }
}

- (void)closeCampaignViewDidTap:(id)sender {
    [self sendDidCloseCampaign];
    [self hide];
}

#pragma mark - Public
- (void)showOnView:(UIView *)view animated:(BOOL)animated withCompletion:(void(^)())completion {
    [[HFCampaignsManager sharedInstance] addToCurrentDisplayCampaigns:self.campaign];
    [self sendDidShowCampaign];
}

- (void)showAnimated:(BOOL)animated withComletion:(void(^)())completion {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showOnView:window.rootViewController.view animated:animated withCompletion:completion];
}

- (void)showAnimated:(BOOL)animated {
    [self showAnimated:animated withComletion:nil];
}

- (void)show {
    [self showAnimated:YES];
}

- (void)hideAnimated:(BOOL)animated withCompletion:(void(^)())completion {
    [[HFCampaignsManager sharedInstance]removeFromCurrentDisplayCampaigns:self.campaign];
    [self sendDidHideCampaign];
}

- (void)hideAnimated:(BOOL)animated {
    [self hideAnimated:animated withCompletion:nil];
}

- (void)hide {
    [self hideAnimated:YES];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    NSString *urlStr = url.absoluteString;
    
    return [self processURL:urlStr];
    
}
- (BOOL) processURL:(NSString *) url {
    NSString *urlStr = [NSString stringWithString:url];
    
    NSString *protocolPrefix = @"js2ios://";
    
    if ([[urlStr lowercaseString] hasPrefix:protocolPrefix]){
        urlStr = [urlStr substringFromIndex:protocolPrefix.length];
        urlStr = [urlStr stringByRemovingPercentEncoding];
        
        NSDictionary *callInfo = [self parseStringToJson:urlStr];
        
        if (!callInfo){
            [self hide];
            return NO;
        }
        
        NSDictionary *args = [self parseStringToJson:[[callInfo objectForKey:@"args"] firstObject]];
        if(!args) {
            [self hide];
            return NO;
        }
        [self processJS2IOSArgs:args];
        
        return NO;
    }
    
    return YES;
}

#pragma -
- (void)processJS2IOSArgs:(NSDictionary *)args {
    NSDictionary *appdata = args[@"appdata"];
    NSString *campaignId = args[@"campaignId"];
    NSString *eventType = args[@"eventType"];
    NSInteger version = [args[@"version"] integerValue];
    NSString *url = args[@"url"];
    NSString *campaignType = args[@"campaignType"];
    NSString *data = args[@"data"];
    
    if(appdata) {
        NSString *action = appdata[@"action"];
        NSString *value = appdata[@"value"];
        if([action isEqualToString:@""]) {
            
        } else if([action isEqualToString:@"NONE"]) {
            //do nothing
            //TODO: send analytics
        } else if([action isEqualToString:@"CLOSE"]) {
            //do nothing
        } else if([action isEqualToString:@"CAMPAIGN"]) {
            HFCampaignView *campaignView = [HFCampaignsUIFactory campaignViewForCampaignIgnorePermission:self.campaign];
            [campaignView show];
        } else if([action isEqualToString:@"URL"]) {
            if(url){
                NSURL *webUrl = [NSURL URLWithString:url];
                [self showModalWebViewWithUrl:webUrl];
            }
        } else if([action isEqualToString:@"APP_VIEW"]) {
            [self passAppViewToDelegateOrOpenView:appdata];
        } else if([action isEqualToString:@"APP_PH_CALL"]) {
            [self passAppPhoneCallToDelegateOrOpenView:appdata];
        } else if([action isEqualToString:@"APP_MAP_VIEW"]) {
            [self passAppMapViewToDelegateOrOpenView:appdata];
        }
        
        [self sendCampaignAnalytics];
        [self hide];
    }
}

- (void)showModalWebViewWithUrl:(NSURL *)url {
    if(!url){
        return;
    }
    
    PBWebViewController *webViewController = [[PBWebViewController alloc]init];
    webViewController.URL = url;
    
    UINavigationController *modalNavigation = [[UINavigationController alloc]initWithRootViewController:webViewController];
    webViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                       target:modalNavigation
                                                                                                       action:@selector(dismissModalViewControllerAnimated:)];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow.rootViewController presentViewController:modalNavigation animated:YES completion:nil];
    
}

- (void)sendCampaignAnalytics {
    //TODO: send analytics on the server
}

- (void)passAppViewToDelegateOrOpenView:(NSDictionary *)params {
    if(![self passActionToDelegate:@"APP_VIEW" withParams:params]) {
        //Do Nothing
    }
}

- (void)passAppPhoneCallToDelegateOrOpenView:(NSDictionary *)params {
    if(![self passActionToDelegate:@"APP_PH_CALL" withParams:params]) {
        //TODO: make phone call if it possible
    }
}

- (void)passAppMapViewToDelegateOrOpenView:(NSDictionary *)params {
    if(![self passActionToDelegate:@"APP_MAP_VIEW" withParams:params]) {
        //TODO: open map view
    }
}

- (NSDictionary *)parseStringToJson:(NSString *)stringToJson {
    NSError *jsonError;
    NSDictionary *info = [NSJSONSerialization
                          JSONObjectWithData:[stringToJson dataUsingEncoding:NSUTF8StringEncoding]
                          options:kNilOptions
                          error:&jsonError];
    
    if (jsonError || ![info isKindOfClass:[NSDictionary class]]){
        return nil;
    }
    return info;
}

#pragma mark - Work With Delegate
- (BOOL)passActionToDelegate:(NSString *)action withParams:(NSDictionary *)params {
    if(params) {
        if([_delegate respondsToSelector:@selector(didCall2Action:params:forCampaign:)]) {
            [_delegate didCall2Action:action params:params forCampaign:self.campaign];
            return YES;
        }
    }
    return NO;
}

- (void)sendDidShowCampaign {
    if([_delegate respondsToSelector:@selector(didShowCampaign:)]) {
        [_delegate didShowCampaign:self.campaign];
    }
}

- (void)sendDidHideCampaign {
    if([_delegate respondsToSelector:@selector(didHideCampaign:)]) {
        [_delegate didHideCampaign:self.campaign];
    }
}

- (void)sendDidCloseCampaign {
    if([_delegate respondsToSelector:@selector(didCloseCampaign:)]) {
        [_delegate didCloseCampaign:self.campaign];
    }
}


@end
