//
//  HFInfoViewController.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/15/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFInfoViewController.h"

@interface HFInfoViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation HFInfoViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [self.webView loadHTMLString:@"<img src=\"widget_info_image.png\">" baseURL:baseURL];
    self.webView.scalesPageToFit = YES;
}

//061


- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
