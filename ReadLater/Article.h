//
//  Article.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 02/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, assign) NSInteger article_id;
@property (nonatomic, strong) NSString* content;
@property (nonatomic, strong) NSString* author;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* url;
@property (nonatomic, strong) NSArray* tags;
@property (nonatomic, strong) NSString* stringTags;
@property (nonatomic, assign) NSInteger archived;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* blog;
@property (nonatomic, assign) NSInteger rating;

// A boolean value that determines the completed state of this item.
@property (nonatomic) BOOL completed;


- (id) initWithId:(NSInteger)Articele_id
             content:(NSString *)Content
              author:(NSString *)Author
                date:(NSDate *)Date
                 url:(NSString *)Url
                tags:(NSArray*)Tags
          stringTags:(NSString*)StringTags
             arhived:(NSInteger)Archived
               title:(NSString *)Title
                blog:(NSString*)Blog
              rating:(NSInteger)Rating;



@end


