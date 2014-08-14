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
@property (nonatomic, strong) NSMutableArray* tags;
@property (nonatomic, strong) NSString* stringTags;
@property (nonatomic, assign) NSInteger archived;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* blog;
@property (nonatomic, assign) NSInteger rating;

//0-inbox, 1 - archived, 2 - delete, 3 - inbox 
@property (nonatomic, assign) NSInteger status;

// A boolean value that determines the completed state of this item.
@property (nonatomic) BOOL completed;


- (id) initWithId:(NSInteger)Articele_id
             content:(NSString *)Content
              author:(NSString *)Author
                date:(NSDate *)Date
                 url:(NSString *)Url
                tags:(NSMutableArray*)Tags
          stringTags:(NSString*)StringTags
             arhived:(NSInteger)Archived
               title:(NSString *)Title
                blog:(NSString*)Blog
              rating:(NSInteger)Rating
              status:(NSInteger)Status;



@end


