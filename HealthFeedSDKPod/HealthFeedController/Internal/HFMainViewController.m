//
//  HFMainViewController.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/30/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFMainViewController.h"

@interface HFMainViewController ()

@property (nonatomic, strong) UITabBarController *tabBarController;

@end

@implementation HFMainViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoDark];
    [btn addTarget:self action:@selector(infoBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"tabbarSegueId"]){
        self.tabBarController = (UITabBarController *)segue.destinationViewController;
        self.tabBarController.tabBar.hidden = YES;
    }
    
    
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    [self.tabBarController setSelectedIndex:sender.selectedSegmentIndex];
}

- (void)infoBtnPressed:(UIButton *)btn{
    [self performSegueWithIdentifier:@"showInfoViewControllerSegueId" sender:self];
}



@end
