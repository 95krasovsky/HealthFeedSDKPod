//
//  HFMedicationList.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFMedication.h"

@interface HFMedicationList : HFBaseModelObject

@property(nonatomic, strong)NSMutableArray *medications;// list of HFMedication

@end
