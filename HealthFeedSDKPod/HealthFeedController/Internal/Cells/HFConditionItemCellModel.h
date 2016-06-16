//
//  HFConditionItemCellModel.h
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/10/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HFConditionItem.h"
#import "HFCounter.h"

@interface HFConditionItemCellModel : NSObject

@property (nonatomic, strong) HFConditionItem *condition;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) NSUInteger level;
@property(nonatomic, strong) NSArray *subConditionModels; //HFConditionItemCellModel

- (instancetype)initWithCondition: (HFConditionItem *)condition level:(NSUInteger)level;

- (HFConditionItemCellModel *)expandedModelForIndex:(NSInteger)index withCounter:(HFCounter *)counter;

- (void)gatherAllExpandedModel:(NSMutableArray *)resultSelectedModels;

- (NSUInteger)calculateVisibleSubModels;

@end
