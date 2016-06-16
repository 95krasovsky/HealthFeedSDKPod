//
//  HFConditionsChooserViewController.h
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/10/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFConditionItem.h"


@protocol HFConditionChooserDelegate <NSObject>

- (void)choseNewConditions:(NSArray *)newConditions;

@end


@interface HFConditionsChooserViewController : UIViewController

@property (nonatomic, strong) NSArray *conditions;
@property (nonatomic, strong) NSMutableArray *selectedConditions;

@property (nonatomic, strong) id <HFConditionChooserDelegate> delegate;
@end
