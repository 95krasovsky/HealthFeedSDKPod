//
//  HFConditionsChooserViewController.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/10/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFConditionsChooserViewController.h"
#import "HFConditionItem.h"
#import "HFConditionItemCellModel.h"
#import "HFConditionItemCell.h"
#import "HFCounter.h"

@interface HFConditionsChooserViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *conditionModels; //HFConditionItemCellModel

@end



@implementation HFConditionsChooserViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
}

- (void)viewWillDisappear:(BOOL)animated{
    self.selectedConditions = [NSMutableArray array];
    
    for (HFConditionItemCellModel *conditionModel in self.conditionModels){
        [conditionModel gatherAllExpandedModel:self.selectedConditions];
    }
    [self.delegate choseNewConditions:[self.selectedConditions copy]];
    [super viewWillDisappear:animated];
}

- (NSArray *)conditionModels{
    if (!_conditionModels){
        _conditionModels = [NSArray array];
    }
    return _conditionModels;
}

- (void)setConditions:(NSArray *)conditions{
    _conditions = conditions;
    for (HFConditionItem *condition in conditions){
        HFConditionItemCellModel *conditionModel = [[HFConditionItemCellModel alloc] initWithCondition:condition level:0];
        if ([self.selectedConditions containsObject:condition]){
            conditionModel.isSelected = YES;
        }
        self.conditionModels = [self.conditionModels arrayByAddingObject:conditionModel];
    }
    [self.tableView reloadData];
}

- (HFConditionItemCellModel *)conditionModelForRow:(NSInteger)row{
    HFConditionItemCellModel *resultConditionModel;
    HFCounter *counter = [[HFCounter alloc] init];
    for (HFConditionItemCellModel *conditionModel in self.conditionModels){
        resultConditionModel = [conditionModel expandedModelForIndex:row withCounter:counter];
        if (resultConditionModel){
            return resultConditionModel;
        }
    }
    return nil;
}


#pragma mark - UITableView Delegate and DataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger num = 0;
    for (HFConditionItemCellModel *conditionModel in self.conditionModels){
        num += [conditionModel calculateVisibleSubModels];
    }
    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HFConditionItemCellModel *conditionModel = [self conditionModelForRow:indexPath.row];
    static NSString *ConditionItemCellId = @"ConditionItemCellId";
    HFConditionItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ConditionItemCellId];
    [cell updateWithConditionModel:conditionModel];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HFConditionItemCellModel *conditionModel = [self conditionModelForRow:indexPath.row];
    conditionModel.isExpanded = !conditionModel.isExpanded;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}










@end
