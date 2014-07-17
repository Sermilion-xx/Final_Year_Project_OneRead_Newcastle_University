//
//  Article.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 02/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize title,content,author,date,url,tags;

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
           rating:(NSInteger)Rating

{
    self = [super init];
    if (self) {
        self.article_id = Articele_id;
        self.content = Content;
        self.author = Author;
        self.date = Date;
        self.url = Url;
        self.tags = Tags;
        self.stringTags = StringTags;
        self.archived = Archived;
        self.title = Title;
        self.completed = false;
        self.blog = Blog;
        self.rating = Rating;
    }
    return self;
}



@end
