//
//  HFMedicalProfile.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/11/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFProfessionList.h"
#import "HFUserProfile.h"
#import "HFPregnancy.h"
#import "HFSmoking.h"
#import "HFMedicalHistory.h"
#import "HFUserProfile.h"

@interface HFMedicalUserProfile : HFUserProfile

@property(nonatomic, strong) HFMedicalHistory *medicalHistory;

@property(nonatomic) NSInteger weeklyAlcoholDrinkEquivalents; //alcohol drinks in a week
@property(nonatomic) bool lactation; // true or false

@property(nonatomic, strong) HFProfessionList *professionList;
@property(nonatomic, strong) HFPregnancy *pregnancy;
@property(nonatomic, strong) HFSmoking *smoking;

@end
