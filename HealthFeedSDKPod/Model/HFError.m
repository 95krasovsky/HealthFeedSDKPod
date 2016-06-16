//
//  HFError.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFError.h"
#import "ApiParams.h"

@implementation HFError

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self) {
        self.code = [dictionary[ApiParamErrorCode] integerValue];
        self.errorType = dictionary[ApiParamErrorType];
        self.errorDetails = dictionary[ApiParamErrorDetail];
    }
    
    return self;
}

@end
