//
//  HFFeedMetadataElement.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"

@interface HFFeedMetadataElement : HFBaseModelObject

@property(nonatomic) NSInteger type; //type of metadata eg. question or comment
@property(nonatomic, strong) NSString *message; //Message e.g comment or question
@property(nonatomic, strong) NSString *response; //Response String e.g answer for question

@end
