//
//  HFFeedMetadata.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFFeedMetadataElement.h"

typedef NS_ENUM(NSUInteger, HFFeedMetadataType) {
    HFFeedMetadataTypeComment,
    HFFeedMetadataTypeQuestion_Answer,
    HFFeedMetadataTypeLike,
    HFFeedMetadataTypeFavorite
};

@interface HFFeedMetadata : HFBaseModelObject

@property(nonatomic) BOOL isFavorite; // indicating if user favorited the content
@property(nonatomic) BOOL liked; // indicating if user liked the content

@property(nonatomic, strong) NSArray *comments; // Featured comments or comments from user (array of HFFeedMetadataElement)
@property(nonatomic, strong) NSArray *questions; // Featured questions or questions from user (array of HFFeedMetadataElement)

@end
