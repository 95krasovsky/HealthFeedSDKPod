//
//  HFMedicalHistory+Internal.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/19/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFMedicalHistory+Internal.h"
#import "ApiParams.h"
#import "HFExtraData+Internal.h"

@implementation HFMedicalHistory(Internal)

- (NSDictionary *)convertToDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    //TODO: implement convertToDictionary
    
//    NSArray *convertedDiagnosis = [self.diagnosis convertToDictionaries];
//    if(convertedDiagnosis) {
//        result[ApiParamDiagnosisList] = convertedDiagnosis;
//    }
//    
//    NSArray *convertedDrugsToAvoidList = [self.drugsToAvoid convertToDictionaries];
//    if(convertedDrugsToAvoidList) {
//        result[ApiParamDrugsToAvoidList] = convertedDrugsToAvoidList;
//    }
//    
//    NSArray *convertedMeasurementList = [self.measurements convertToDictionaries];
//    if(convertedMeasurementList) {
//        result[ApiParamMeasurementList] = convertedMeasurementList;
//    }
//    
//    NSArray *convertedMedications = [self.medications convertToDictionaries];
//    if(convertedDiagnosis) {
//        result[ApiParamMedicationList] = convertedMedications;
//    }
//    
//    NSArray *convertedVaccines = [self.vaccines convertToDictionaries];
//    if(convertedVaccines) {
//        result[ApiParamVaccineList] = convertedVaccines;
//    }
//    
//    NSArray *convertedProcedures = [self.procedures convertToDictionaries];
//    if(convertedProcedures) {
//        result[ApiParamProcedureList] = convertedProcedures;
//    }
//    
//    NSArray *convertedTherapies = [self.therapies convertToDictionaries];
//    if(convertedTherapies) {
//        result[ApiParamTherapiesList] = convertedTherapies;
//    }
//    
//    if(self.extraDataList.count > 0) {
//        NSMutableArray *extraData = [NSMutableArray array];
//        for(HFExtraData *data in self.extraDataList) {
//            [extraData addObject:[data convertToDictionary]];
//        }
//        result[ApiParamExtDataList] = extraData;
//    }

    return result;
}

@end
