//
//  HFConditionItemCell.h
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/10/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFConditionItemCellModel.h"

@interface HFConditionItemCell : UITableViewCell

- (void)updateWithConditionModel:(HFConditionItemCellModel *)conditionModel;

@end
