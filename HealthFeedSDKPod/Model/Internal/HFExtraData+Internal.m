//
//  HFExtraData+Internal.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/19/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFExtraData+Internal.h"
#import "ApiParams.h"
#import "NSDate+HF.h"

@implementation HFExtraData(Internal)

- (NSDictionary *)convertToDictionary {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    if(self.codeSystem) {
        result[ApiParamCodeSystem] = self.codeSystem;
    } else {
        result[ApiParamCodeSystem] = @"CUSTOM";
    }
    
    if(self.name) {
        result[ApiParamExDName] = self.name;
    }
    
    if(self.value) {
        result[ApiParamValue] = self.value;
    }
    
    if(self.unit) {
        result[ApiParamUnit] = self.unit;
    }
    
    if(self.pointDateTime) {
        result[ApiParamPointDateTime] = @([self.pointDateTime timeIntervalSince1970inMilliseconds]);
    }
    
    if(self.startDateTime) {
        result[ApiParamStartDateTime] = @([self.startDateTime timeIntervalSince1970inMilliseconds]);
    }
    
    if(self.endDateTime) {
        result[ApiParamEndDateTime] = @([self.endDateTime timeIntervalSince1970inMilliseconds]);
    }
    
    return result;
}

@end