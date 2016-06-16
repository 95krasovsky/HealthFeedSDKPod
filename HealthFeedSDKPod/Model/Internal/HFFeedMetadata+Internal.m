//
//  HFFeedMetadata+Internal.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/20/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFFeedMetadata+Internal.h"

@implementation HFFeedMetadata(Internal)

+ (NSString *)convertMetadataTypeToString:(HFFeedMetadataType)type {
    
    switch (type) {
        case HFFeedMetadataTypeLike: return @"LIKE";
        case HFFeedMetadataTypeComment: return @"COMMENT";
        case HFFeedMetadataTypeFavorite: return @"FAV";
        case HFFeedMetadataTypeQuestion_Answer: return @"QUESTION_ANSWER";
    }
}

@end
