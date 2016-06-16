//
//  HFProcedureList.h
//  HealthFeedApp
//
//  Created by Aravind Kilaru on 6/8/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFProcedure.h"

@interface HFProcedureList : HFBaseModelObject

@property(nonatomic, strong)NSMutableArray *procedures;//List of HFProcedure

@end
