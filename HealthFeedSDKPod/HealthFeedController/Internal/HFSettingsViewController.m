//
//  HFSettingsViewController.m
//  HealthFeedApp
//
//  Created by Vladislav Krasovsky on 6/10/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFSettingsViewController.h"
#import "HFConditionsChooserViewController.h"
#import "HFDataManager.h"
#import "HFUserProfile.h"
#import "HFMedicalUserProfile.h"
#import "HFContentManager.h"
#import "HFConditionItem.h"
#import "MBProgressHUD.h"

@interface HFSettingsViewController () <HFConditionChooserDelegate>

@property (nonatomic, strong, readonly) HFUserProfile *userProfile;

@property (nonatomic) HFUserGender selectedGender;
@property (nonatomic) HFUserAgeGroup selectedAgeGroup;
@property (nonatomic) HFUserEthnicity selectedEthnicity;
@property (nonatomic, strong) NSArray *selectedConditions;
@end

@implementation HFSettingsViewController

- (HFUserProfile *)userProfile{
    return [HFDataManager sharedInstance].userProfile;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.selectedGender = self.userProfile.gender;
    self.selectedAgeGroup = self.userProfile.ageGroup;
    self.selectedEthnicity = self.userProfile.ethnicity;
    self.selectedConditions = self.userProfile.conditions;
    [self.tableView reloadData];
}

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(self.tableView.frame.size.width - 49, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [[self stringForSelectedConditions] boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    return size.height;
}

- (NSString *)stringForSelectedConditions{
    NSString *str = @"";
    for (HFConditionItem *condition in self.selectedConditions){
        str = [[str stringByAppendingString:condition.name] stringByAppendingString:@", "];
    }
    if (str.length){
        str = [str substringToIndex:str.length - 2];
    } else{
        str = @"No conditions selected.";
    }
    return str;
}


#pragma mark - UITableView Delegate and DataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0){
        [self pushToConditionsController];
        return;
    }

    if ([[tableView cellForRowAtIndexPath:indexPath ] accessoryType] != UITableViewCellAccessoryCheckmark)
    {
        switch (indexPath.section) {
            case 1:
                self.selectedGender = indexPath.row;
                break;
            case 2:
                self.selectedAgeGroup = indexPath.row;
                break;
            case 3:
                self.selectedEthnicity = indexPath.row;
                break;
            default:
                break;
        }
        [self.tableView reloadData];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        UITableViewCell * cell = [self tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        CGSize constraint = CGSizeMake(self.tableView.frame.size.width - 49, CGFLOAT_MAX);
        CGSize size;
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        CGSize boundingBox = [[self stringForSelectedConditions] boundingRectWithSize:constraint
                                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:@{NSFontAttributeName:cell.detailTextLabel.font}
                                                                              context:context].size;
        
        size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));

        
        CGFloat height = 40 + size.height;
        return height;
    } else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0){
        cell.detailTextLabel.text = [self stringForSelectedConditions];
    }
    switch (indexPath.section) {
        case 1:
            if (indexPath.row == self.selectedGender){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            } else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            break;
        case 2:
            if (indexPath.row == self.selectedAgeGroup){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            } else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            break;
        case 3:
            if (indexPath.row == self.selectedEthnicity){
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            } else{
                [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
            break;
        default:
            break;
    }
    
    
    return cell;
}


#pragma mark - actions

- (IBAction)savePressed:(UIBarButtonItem *)sender {
    self.userProfile.gender = self.selectedGender;
    self.userProfile.ethnicity = self.selectedEthnicity;
    self.userProfile.ageGroup = self.selectedAgeGroup;
    self.userProfile.conditions = [self.selectedConditions mutableCopy];
    [[HFContentManager sharedInstance] resetContent];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if([self.userProfile isKindOfClass:[HFMedicalUserProfile class]]) {
        [[HFDataManager sharedInstance]pushMemberHealthProfileInCodes:(HFMedicalUserProfile *)self.userProfile
                                                       withCompletion:^(HFUserProfile *profile, NSError *error) {
                                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                           [self dismissViewControllerAnimated:YES completion:nil];
                                                       }];
    } else {
        [[HFDataManager sharedInstance]pushMemberHealthProfileInEnglish:self.userProfile
                                                         withCompletion:^(HFUserProfile *profile, NSError *error) {
                                                             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                             [self dismissViewControllerAnimated:YES completion:nil];
                                                         }];
    }
}

- (IBAction)cancelPressed:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)pushToConditionsController{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if([HFDataManager sharedInstance].availableConditions.count > 0) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self performSegueWithIdentifier:@"chooseConditionsSegueId" sender:[HFDataManager sharedInstance].availableConditions];
    } else {
        [[HFDataManager sharedInstance]loadAvailableConditionsWithComplition:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self performSegueWithIdentifier:@"chooseConditionsSegueId" sender:[HFDataManager sharedInstance].availableConditions];
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"chooseConditionsSegueId"]){
        HFConditionsChooserViewController *conditionsController = (HFConditionsChooserViewController *)segue.destinationViewController;
        conditionsController.delegate = self;
        conditionsController.selectedConditions = [self.selectedConditions mutableCopy];
        conditionsController.conditions = sender;
    }
}

#pragma mark - HFConditionChooserDelegate

- (void)choseNewConditions:(NSArray *)newConditions{
    self.selectedConditions = newConditions;
    [self.tableView reloadData];
}

@end
