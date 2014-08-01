//
//  UserModel.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 05/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "User.h"
#import "Article.h"

@interface Database : NSObject

@property (nonatomic, assign) sqlite3 *db;
- (void)test;
- (void) openDatabase;
- (void) closeDatabase;

- (User*) registerUser:(NSString *) firstname
             lastname:(NSString *) lastname
                  age:(NSInteger) age
                email:(NSString *) email
             password:(NSString *) password
              picture:(NSString *) picture;



- (User*) login:(NSString *) email
       password:(NSString *) password;

- (NSMutableArray*)importAllArticlesWithStatus:(int)status;

- (NSMutableArray*)importAllArticlesFilterByOption:(NSString*)option;

- (NSMutableArray*) importAllFollowersForUser:(NSInteger)user_id;

- (NSMutableArray*)importAndFilterTags:(NSMutableArray*)tags andBlogs:(NSMutableArray*)blogs status:(BOOL) status;

- (NSMutableArray*)getAllTags;
- (NSMutableArray*)getAllBlog;

- (NSString* )getLastArticleDate;


- (BOOL)addArticleToArticleDB:(Article *)article;

- (BOOL) addArticleToUserArticleDB:(Article *)article;

- (BOOL) addTagsForArticleWithID:(NSInteger)article_id tags:(NSArray*)tags;

- (BOOL) deleteArticle:(NSInteger) article_id;

- (BOOL) archiveArticle:(Article *) article forUser:(NSInteger)user_id;

-(NSInteger)getLastArticleID;

- (NSMutableArray* )importAllArchivedForUser:(NSInteger)user_id;

@end
