//
//  HFConditionItemCell.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/10/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFConditionItemCell.h"

@interface HFConditionItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (nonatomic, strong) HFConditionItemCellModel *conditionModel;

@end

@implementation HFConditionItemCell

- (void)updateWithConditionModel:(HFConditionItemCellModel *)conditionModel{
    self.conditionModel = conditionModel;
    self.nameLabel.text = conditionModel.condition.name;
    self.indentationLevel = conditionModel.level;
    self.indentationWidth = 20.0f;
    UIFont *font;
    switch (conditionModel.level) {
        case 0:
            font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
            break;
        case 1:
            font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            break;
        case 2:
            font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
            break;
        default:
            break;
    }
    self.nameLabel.font = font;
    self.checkBtn.selected = conditionModel.isSelected;
}

- (IBAction)checkmarkPressed:(UIButton *)sender {
    self.conditionModel.isSelected = !self.conditionModel.isSelected;
    sender.selected = self.conditionModel.isSelected;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    float indentPoints = self.indentationLevel * self.indentationWidth;
    
    self.contentView.frame = CGRectMake(
                                        indentPoints,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width - indentPoints,
                                        self.contentView.frame.size.height
                                        );
}
@end
