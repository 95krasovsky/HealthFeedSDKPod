//
//  HFConditionItemCellModel.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/10/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFConditionItemCellModel.h"

@implementation HFConditionItemCellModel


- (instancetype)initWithCondition: (HFConditionItem *)condition level:(NSUInteger)level{

    self = [super init];
    if (self) {
        self.condition = condition;
        self.level = level;
        self.subConditionModels = [NSArray array];
        for (HFConditionItem *subCondition in condition.subConditionItems){
            HFConditionItemCellModel *subConditionModel = [[HFConditionItemCellModel alloc] initWithCondition:subCondition level:self.level+1];
            self.subConditionModels = [self.subConditionModels arrayByAddingObject:subConditionModel];
        }
    }
    return self;
}



- (HFConditionItemCellModel *)expandedModelForIndex:(NSInteger)index withCounter:(HFCounter *)counter {
    if (index == counter.n){
        return self;
    }
    counter.n++;
    if (!self.isExpanded){
        return nil;
    }
    for (HFConditionItemCellModel *subModel in self.subConditionModels){
        HFConditionItemCellModel *resultConditionModel = [subModel expandedModelForIndex:index withCounter:counter];
        if (resultConditionModel) return resultConditionModel;
    }
    return nil;
}

- (NSUInteger)calculateVisibleSubModels{
    NSUInteger number = 1;
    if (!self.isExpanded){
        return number;
    }
    for (HFConditionItemCellModel *subModel in self.subConditionModels){
        number += [subModel calculateVisibleSubModels];
    }
    return number;
}

- (void)gatherAllExpandedModel:(NSMutableArray *)resultSelectedModels {
    if (self.isSelected){
        [resultSelectedModels addObject:self.condition];
    }
    for (HFConditionItemCellModel *subModel in self.subConditionModels){
        [subModel gatherAllExpandedModel:resultSelectedModels];
    }
}

@end
