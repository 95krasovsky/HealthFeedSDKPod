//
//  HFFeedItem.h
//  HealthFeedApp
//
//  Created by Mihail Kosyuhin on 5/18/16.
//  Copyright © 2016 softteco. All rights reserved.
//

#import "HFBaseModelObject.h"
#import "HFFeedMetadata.h"

typedef NS_ENUM(NSUInteger, HFFeedContentType) {
    HFFeedContentTypeVideo = 0,
    HFFeedContentTypeIllustrator,
    HFFeedContentTypeInfoGraphic,
    HFFeedContentTypeAudio,
    HFFeedContentTypeText,
    HFFeedContentTypeContentFrames,
    HFFeedContentTypeQandA,
    HFFeedContentTypePDF,
    HFFeedContentTypeMultipleLinks,
    HFFeedContentTypeRecipe,
    HFFeedContentTypeSlideShow,
    HFFeedContentTypeExercisePose,
    HFFeedContentTypeTable,
    HFFeedContentTypeTextToSpeech,
    HFFeedContentTypeQuiz,
    HFFeedContentTypeCalculator
};


@interface HFFeedItem : HFBaseModelObject

@property(nonatomic, strong) NSString *identifier; //uniquely identifier the item
@property(nonatomic, strong) NSString *title; //The name of the article
@property(nonatomic, strong) NSString *summary; //Short summary of the article
@property(nonatomic, strong) NSString *language;
@property(nonatomic, strong) HFFeedMetadata *metadata; //Metadata for the content, contains if user liked, favorited, featured comments or featured questions

@property(nonatomic, strong) NSArray *contentTypes; //Contains list of one or more following to describe the content of site HFFeedContentType

@property(nonatomic, strong) NSString *imageURL; //Image link to represent the website origin
@property(nonatomic, strong) NSString *link; //The URL to the website of the  article
@property(nonatomic, strong) NSString *linkHostName; //Website origin of the article like google.com, health.com...

@property(nonatomic) NSInteger contentSourceType; //Int indicating source of content e.g 1 for internet
@property(nonatomic) NSInteger contentViewType; //Int indicating view type of content e.g 1 for article

@property(nonatomic, strong) NSArray *associatedCampaigns;

@end

