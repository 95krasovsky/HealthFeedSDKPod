//
//  HFBaseCode.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

typedef NS_ENUM(NSUInteger, HFMedicalCodeSystem) {
   HFMedicalCodeSystemSNOMEDCT,
   HFMedicalCodeSystemICD9CM,
   HFMedicalCodeSystemICD10CM,
   HFMedicalCodeSystemLOINC,
   HFMedicalCodeSystemRXNORM
};

@interface HFBaseCode : HFBaseModelObject

@property(nonatomic, strong)NSString *codeValue;
@property(nonatomic)HFMedicalCodeSystem codeSystem;
@property(nonatomic, strong)NSNumber *codeVersion; //Version of coding system (Optional)

@end
