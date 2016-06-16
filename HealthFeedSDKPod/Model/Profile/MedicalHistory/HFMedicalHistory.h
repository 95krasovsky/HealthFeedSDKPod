//
//  HFMedicalHistory.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/19/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFDiagnosisList.h"
#import "HFDrugsToAvoidList.h"
#import "HFMeasurementList.h"
#import "HFMedicationList.h"
#import "HFVaccineList.h"
#import "HFProcedureList.h"
#import "HFTherapiesList.h"

@interface HFMedicalHistory : HFBaseModelObject

@property(nonatomic, strong)HFDiagnosisList *diagnosisList; //Contains user diagnosis
@property(nonatomic, strong)HFDrugsToAvoidList *drugsToAvoidList; //Contains user drugs to avoid
@property(nonatomic, strong)HFMeasurementList *measurementList; //Contains user measurements
@property(nonatomic, strong)HFMedicationList *medicationList; //Contains user medication
@property(nonatomic, strong)HFVaccineList *vaccineList; //Contains user vaccine
@property(nonatomic, strong)HFProcedureList *procedureList; //Contains user procedure
@property(nonatomic, strong)HFTherapiesList *therapiesList; //Contains user therapies

@property(nonatomic, strong)NSMutableArray *extraDataList;
@end
