//
//  HFFeedMetadata.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFFeedMetadata.h"
#import "ApiParams.h"
#import "HFFeedMetadataElement.h"

@implementation HFFeedMetadata

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self) {
        self.isFavorite = [dictionary[ApiParamFav] boolValue];
        self.liked = [dictionary[ApiParamLike] boolValue];
        
        NSMutableArray *mutableComments = [NSMutableArray array];
        NSArray *commentsArray = dictionary[ApiParamComments];
        for(NSDictionary *commentDictionary in commentsArray) {
            HFFeedMetadataElement *element = [HFFeedMetadataElement objectWithDictionary:commentDictionary];
            [mutableComments addObject:element];
        }
        
        NSMutableArray *mutableQuestions = [NSMutableArray array];
        NSArray *quiestionsArray = dictionary[ApiParamQuestions];
        for(NSDictionary *questionDictionary in quiestionsArray) {
            HFFeedMetadataElement *element = [HFFeedMetadataElement objectWithDictionary:questionDictionary];
            [mutableQuestions addObject:element];
        }
        
        self.comments = mutableComments;
        self.questions = mutableQuestions;
    }
    return self;
}

@end
