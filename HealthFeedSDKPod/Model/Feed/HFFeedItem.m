//
//  HFFeedItem.m
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFFeedItem.h"
#import "ApiParams.h"

@implementation HFFeedItem

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    if(self) {
        
        self.identifier = dictionary[ApiParamGuid];
        self.title = dictionary[ApiParamTitle];
        self.summary = dictionary[ApiParamDescription];
        self.language = dictionary[ApiParamLanguage];
        self.imageURL = dictionary[ApiParamImageUrl];
        self.link = dictionary[ApiParamLink];
        self.linkHostName = dictionary[ApiParamLinkHostName];
        
        self.metadata = [HFFeedMetadata objectWithDictionary:dictionary[ApiParamMeta]];
        
        NSMutableArray *mutableContentTypes = [NSMutableArray array];
        NSArray *typeArray = dictionary[ApiParamContentTypes];
        for(NSString *type in typeArray) {
            NSInteger enumType = [self feedContentTypeForString:type];
            if(enumType >= 0) {
                [mutableContentTypes addObject:@(enumType)];
            }
        }
        
        self.contentTypes = mutableContentTypes;
        self.contentViewType = [dictionary[ApiParamContentViewType] integerValue];
        self.contentSourceType = [dictionary[ApiParamContentSourceType] integerValue];
    }
    
    return self;
}

- (HFFeedContentType)feedContentTypeForString:(NSString *)type {
    if([type isEqualToString:@"VIDEO"]) return HFFeedContentTypeVideo;
    if([type isEqualToString:@"ILLUSTRATION"]) return HFFeedContentTypeIllustrator;
    if([type isEqualToString:@"INFO_GRAPHIC"]) return HFFeedContentTypeInfoGraphic;
    if([type isEqualToString:@"AUDIO"]) return HFFeedContentTypeAudio;
    if([type isEqualToString:@"TEXT"]) return HFFeedContentTypeText;
    if([type isEqualToString:@"CONTENT_FRAMES"]) return HFFeedContentTypeContentFrames;
    if([type isEqualToString:@"Q_AND_A"]) return HFFeedContentTypeQandA;
    if([type isEqualToString:@"PDF"]) return HFFeedContentTypePDF;
    if([type isEqualToString:@"MULTIPLE_LINKS"]) return HFFeedContentTypeMultipleLinks;
    if([type isEqualToString:@"RECIPE"]) return HFFeedContentTypeRecipe;
    if([type isEqualToString:@"SLIDE_SHOW"]) return HFFeedContentTypeSlideShow;
    if([type isEqualToString:@"EXERCISE_POSE"]) return HFFeedContentTypeExercisePose;
    if([type isEqualToString:@"TABLE"]) return HFFeedContentTypeTable;
    if([type isEqualToString:@"TEXT_TO_SPEECH"]) return HFFeedContentTypeTextToSpeech;
    if([type isEqualToString:@"QUIZ"]) return HFFeedContentTypeQuiz;
    if([type isEqualToString:@"CALCULATOR"]) return HFFeedContentTypeCalculator;
    return -1;
}

@end