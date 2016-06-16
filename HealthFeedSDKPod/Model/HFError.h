//
//  HFError.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

@interface HFError : HFBaseModelObject

@property(nonatomic) NSInteger code;
@property(nonatomic, strong) NSString *errorType;
@property(nonatomic, strong) NSString *errorDetails;

@end
