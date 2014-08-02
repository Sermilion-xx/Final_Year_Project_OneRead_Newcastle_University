//
//  UserModel.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 05/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "Database.h"
#import "User.h"

@implementation Database

- (id) init
{
    self = [super init];
    if (self) {
        [self copyDatabaseToDocDirectory];
        
    }
    return self;
}



- (void) copyDatabaseToDocDirectory
{
    NSFileManager *fileMan = [NSFileManager defaultManager];
    NSError *error;
    //get the path to the database in the documents directory
    NSString *dbFilePath = [self pathToDatabaseFile:@"readlater.sql"];
    //does the database exist in the documents directory?
    if (![fileMan fileExistsAtPath:dbFilePath]) {
        //if not, copy the file:
        NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"readlater.sql"];
        if (![fileMan copyItemAtPath:bundlePath toPath:dbFilePath error:&error]) {
            NSLog(@"Database file could not be copied to documents path: %@", error.localizedDescription);
        } else {
            NSLog(@"DB copied...");
        }
    } else {
        //NSLog(@"File exists at path %@", dbFilePath);
    }
}

- (void) test
{
    NSLog(@"This is the PartsModel");
}

- (void) openDatabase
{
    const char* databaseFile = [[self pathToDatabaseFile:@"readlater.sql"] UTF8String];
    sqlite3 *connection;
    if (sqlite3_open(databaseFile, &connection) != SQLITE_OK) {
        //NSLog(@"Cannot open database.");
        return;
    }
    //NSLog(@"Database connection was open.");
    self.db = connection;
}

- (NSString *)pathToDatabaseFile:(NSString *)fileName
{
    NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [allPaths objectAtIndex:0];
    NSString *dbPath = [docPath stringByAppendingPathComponent:fileName];
    return dbPath;
}


- (void) closeDatabase
{
    sqlite3_close(self.db);
    self.db = nil;
}

#pragma mark Registration
- (User*) registerUser:(NSString *) firstname
              lastname:(NSString *) lastname
                   age:(NSInteger) age
                 email:(NSString *) email
              password:(NSString *) password
               picture:(NSString *) picture

{
    NSString *sql = @"INSERT INTO User (firstname,lastname,age,email,password,picture)"
    " VALUES (?,?,?,?,?,?)";
    sqlite3_stmt *insert;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &insert, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(insert, 1, [firstname UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert, 2, [lastname UTF8String],  -1, SQLITE_TRANSIENT);
        sqlite3_bind_int (insert, 3, (int)age);
        sqlite3_bind_text(insert, 4, [email UTF8String],     -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert, 5, [password UTF8String],  -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert, 6, [picture UTF8String],   -1, SQLITE_TRANSIENT);
        result = sqlite3_step(insert);
        
        User* user = [[User alloc]init];
        user.firstname = firstname;
        user.lastname = lastname;
        user.age = age;
        user.password = password;
        user.picture = picture;
        
        sqlite3_finalize(insert);
        if (result == 19) {
            NSLog(@"User with such e-mail exists!");
            return nil;
        }else{
            return user;
            NSLog(@"Reg Successful!");
        }
        return user;
    } else {
        NSLog(@"Error: insert prepare statement failed: %s.", sqlite3_errmsg(self.db));
        sqlite3_finalize(insert);
        return nil;
    }
    sqlite3_finalize(insert);
    
}


#pragma mark login
- (User*) login:(NSString *) email
       password:(NSString *) password
{
    User* user = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM User WHERE email=? AND password=?"];
    
    sqlite3_stmt *select;
    
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &select, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_text(select, 1, [email UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(select, 2, [password UTF8String],  -1, SQLITE_TRANSIENT);
    
        
        while (sqlite3_step(select) == SQLITE_ROW) {
            NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:6];
            
            // add the id:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 0)]];
            // add the firstname:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 1)]];
            // add the lastname:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 2)]];
            // add the age:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 3)]];
            // add the email:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 4)]];
            // add the password:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 5)]];
            
            user = [[User alloc]initWithId:[[values objectAtIndex:0]integerValue] firstname:[values objectAtIndex:1] lastname:[values objectAtIndex:2] age:(NSInteger)[values objectAtIndex:3] email:[values objectAtIndex:4] password:[values objectAtIndex:5] picture:@"default.png"];
    
            sqlite3_finalize(select);
            if(user.user_id>-1){
                NSLog(@"Sucsefful login! Hello %@", user.firstname );
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat: @"%d", (int)user.user_id] forKey:@"UserLoginIdSession"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                return user;
            }else{
                NSLog(@"Wrong Credentials!");
                return nil;
            }
        }
        sqlite3_finalize(select);
        return nil;
        
    } else {
        NSLog(@"Error: insert prepare statement failed: %s.", sqlite3_errmsg(self.db));
        sqlite3_finalize(select);
        return nil;
    }
    
}
#pragma mark importAllArticles
- (NSMutableArray*)importAllArticlesWithStatus:(int)status
{
    NSMutableArray *inboxArticles = [[NSMutableArray alloc]initWithCapacity:20];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Article WHERE status=?"];
    
    sqlite3_stmt *select;
    
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &select, NULL);
    
    sqlite3_bind_int (select, 1, (int)status);
    if (result == SQLITE_OK) {
        

        while (sqlite3_step(select) == SQLITE_ROW) {
            NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:6];
            
            // add the id:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 0)]];
            // add the content:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 1)]];
            // add the author:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 2)]];
            // add the date:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 3)]];
            // add the url:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 4)]];
            // add the tags:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 5)]];
            // add the title:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 6)]];
            // add the blog:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 7)]];
            // add the rating:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 8)]];
            // add the status:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 9)]];
            
           
            
            Article* article = [[Article alloc]init];
            
            article.article_id = [[values objectAtIndex:0]integerValue];
            article.content = [values objectAtIndex:1];
            article.author = [values objectAtIndex:2];
            article.date = [values objectAtIndex:3];
            article.url = [values objectAtIndex:4];
            article.stringTags = [values objectAtIndex:5];
            article.title = [values objectAtIndex:6];
            article.blog = [values objectAtIndex:7];
            article.rating = [[values objectAtIndex:8] integerValue];
            article.status = [[values objectAtIndex:9]integerValue];
            [inboxArticles addObject:article];
            
            //NSLog(@"Imported Article: %@", article);
        }
        
    }
    sqlite3_finalize(select);
    //NSLog(@"%lu articles were imported form db", (unsigned long)inboxArticles.count);
    return inboxArticles;
    
}

- (NSMutableArray*)importAllArticlesFilterByOption:(NSString*)option
{
    NSMutableArray *filteredArticles = [[NSMutableArray alloc]initWithCapacity:20];
    NSString *sql = nil;
    
    NSRange range = [option rangeOfString:@"."];
    if (range.location != NSNotFound) {
        sql = [NSString stringWithFormat:@"SELECT * FROM Article  WHERE blog=?"];

    }else{
        sql = [NSString stringWithFormat:@"SELECT * FROM Article AS A JOIN ArticleTags AS AT ON AT.article_id=A.ID WHERE tag=?"];
    }
    
    sqlite3_stmt *select;
    
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &select, NULL);
    //printf( "could not prepare statemnt: %s\n", sqlite3_errmsg(self.db) );

    sqlite3_bind_text(select, 1, [option UTF8String],  -1, SQLITE_TRANSIENT);
     //NSLog(@"***********Filtered By Tag: %d %d" , sqlite3_step(select), SQLITE_OK);
    if (result == SQLITE_OK) {
        
        
        while (sqlite3_step(select) == SQLITE_ROW) {
            NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:6];
            //NSLog(@"***********Filtered By Tag: %d %d" , result, SQLITE_OK);
            // add the id:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 0)]];
            // add the content:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 1)]];
            // add the author:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 2)]];
            // add the date:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 3)]];
            // add the url:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 4)]];
            // add the tags:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 5)]];
            // add the title:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 6)]];
            // add the blog:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 7)]];
            // add the rating:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 8)]];
            // add the status:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 9)]];
            
            
            
            Article* article = [[Article alloc]init];
            
            article.article_id = [[values objectAtIndex:0]integerValue];
            article.content = [values objectAtIndex:1];
            article.author = [values objectAtIndex:2];
            article.date = [values objectAtIndex:3];
            article.url = [values objectAtIndex:4];
            article.stringTags = [values objectAtIndex:5];
            article.title = [values objectAtIndex:6];
            article.blog = [values objectAtIndex:7];
            article.rating = [[values objectAtIndex:8] integerValue];
            article.status = [[values objectAtIndex:9] integerValue];
            [filteredArticles addObject:article];
            //NSLog(@"Filtered Article: %@", article);
        }
        
    }
    sqlite3_finalize(select);
    //NSLog(@"%lu articles were imported form db", (unsigned long)filteredArticles.count);
    return filteredArticles;
    
}

- (NSMutableArray*)importAndFilterByTags:(NSMutableArray*)tags andBlogs:(NSMutableArray*)blogs status:(BOOL) status
{
    NSString * tagsArrayString = [tags componentsJoinedByString:@","];
    NSString * blogsArrayString = [blogs componentsJoinedByString:@","];
    NSString * sql = nil;
    NSMutableArray *filteredArticles = [[NSMutableArray alloc]initWithCapacity:20];
    
    if (tags.count==0 && blogs.count==0) {
        sql = [NSString stringWithFormat:@"SELECT * FROM Article LEFT OUTER JOIN ArticleTags ON ArticleTags.article_id=article.id WHERE status=0 GROUP BY ArticleTags.tag"];
    }else if(tags.count==0){
        sql = [NSString stringWithFormat:@"SELECT * FROM Article LEFT OUTER JOIN ArticleTags ON ArticleTags.article_id=article.id WHERE status=0 AND blog IN (%@)", blogsArrayString];
    }else if(blogs.count==0){
        sql = [NSString stringWithFormat:@"SELECT * FROM Article LEFT OUTER JOIN ArticleTags ON ArticleTags.article_id=article.id WHERE status=0 AND ArticleTags.tag IN (%@)", tagsArrayString];
    }else{
        sql = [NSString stringWithFormat:@"SELECT * FROM Article LEFT OUTER JOIN ArticleTags ON ArticleTags.article_id=article.id WHERE status=0 AND ArticleTags.tag IN (%@) AND blog IN (%@)", tagsArrayString, blogsArrayString];
    }
    
    
    sqlite3_stmt *select;
    
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &select, NULL);

    if (result == SQLITE_OK) {
     sqlite3_bind_int (select, 1, (BOOL)status);
        
        while (sqlite3_step(select) == SQLITE_ROW) {
            NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:6];
            //NSLog(@"***********Filtered By Tag: %d %d" , result, SQLITE_OK);
            // add the id:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 0)]];
            // add the content:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 1)]];
            // add the author:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 2)]];
            // add the date:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 3)]];
            // add the url:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 4)]];
            // add the tags:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 5)]];
            // add the title:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 6)]];
            // add the blog:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 7)]];
            // add the rating:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 8)]];
            //add the status
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 9)]];
            
            
            
            Article* article = [[Article alloc]init];
            
            article.article_id = [[values objectAtIndex:0]integerValue];
            article.content = [values objectAtIndex:1];
            article.author = [values objectAtIndex:2];
            article.date = [values objectAtIndex:3];
            article.url = [values objectAtIndex:4];
            article.stringTags = [values objectAtIndex:5];
            article.title = [values objectAtIndex:6];
            article.blog = [values objectAtIndex:7];
            article.rating = [[values objectAtIndex:8] integerValue];
            article.status = [[values objectAtIndex:9] integerValue];
            
            if (![filteredArticles containsObject:article]) {
                [filteredArticles addObject:article];
            }
            
            //NSLog(@"Filtered Article: %@", article);
        }
        
    }
    sqlite3_finalize(select);
    //NSLog(@"%lu articles were imported form db", (unsigned long)filteredArticles.count);
    return filteredArticles;
    
}


- (NSMutableArray*)getAllTags
{
    NSString *sql = [NSString stringWithFormat:@"SELECT DISTINCT tag FROM ArticleTags"];
    sqlite3_stmt *select;
    NSMutableArray *values = [[NSMutableArray alloc]initWithCapacity:10];
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &select, NULL);
    if (result == SQLITE_OK) {
        
        
        while (sqlite3_step(select) == SQLITE_ROW) {
            // add the tag:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 0)]];
        }
    }
    sqlite3_finalize(select);
    return values;
}


- (NSMutableArray*)getAllBlog
{
    NSString *sql = [NSString stringWithFormat:@"SELECT DISTINCT blog FROM Article"];
    sqlite3_stmt *select;
    NSMutableArray *values = [[NSMutableArray alloc]initWithCapacity:10];
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &select, NULL);
    if (result == SQLITE_OK) {
        
        
        while (sqlite3_step(select) == SQLITE_ROW) {
            // add the tag:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 0)]];
        }
    }
    sqlite3_finalize(select);
    return values;
    
    
}

- (NSMutableArray*) importAllFollowersForUser:(NSInteger)user_id
{
//     sql = [NSString stringWithFormat:@"SELECT * FROM Article AS A JOIN ArticleTags AS AT ON AT.article_id=A.ID WHERE tag=?"];
    NSString *sql = nil;
    sql = [NSString stringWithFormat:@"SELECT * FROM User WHERE U.id!=?"];
    sqlite3_stmt *select;
    
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &select, NULL);
    User *user = nil;
    NSMutableArray* followers = [[NSMutableArray alloc]initWithCapacity:20];
    if (result == SQLITE_OK) {
        sqlite3_bind_int(select, 1, (int)user_id);

        
        
        while (sqlite3_step(select) == SQLITE_ROW) {
            NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:6];
            // add the id:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 0)]];
            // add the firstname:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 1)]];
            // add the lastname:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 2)]];
            // add the age:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 3)]];
            // add the email:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 4)]];
            // add the password:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 5)]];
            
            user = [[User alloc]initWithId:[[values objectAtIndex:0]integerValue] firstname:[values objectAtIndex:1] lastname:[values objectAtIndex:2] age:(NSInteger)[values objectAtIndex:3] email:[values objectAtIndex:4] password:[values objectAtIndex:5] picture:@"default.png"];
            [followers addObject:user];

        }
        sqlite3_finalize(select);
        return followers;
    } else {
        NSLog(@"Error: insert prepare statement failed: %s.", sqlite3_errmsg(self.db));
        sqlite3_finalize(select);
        return nil;
    }

}

#pragma mark addArticle
- (BOOL)addArticleToArticleDB:(Article*)article
{
    NSString *sql = @"INSERT INTO Article (content,author,date,url,tags, title, blog, rating, status) VALUES (?,?,?,?,?,?,?,?,?)";
    sqlite3_stmt *insert;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &insert, NULL);

    if (result == SQLITE_OK) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:article.date];
        sqlite3_bind_text(insert, 1, [article.content UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert, 2, [article.author UTF8String],  -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert, 3, [strDate UTF8String],     -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert, 4, [article.url UTF8String],     -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert, 5, [article.stringTags UTF8String],     -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert, 6, [article.title UTF8String],   -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(insert, 7, [article.blog UTF8String],   -1, SQLITE_TRANSIENT);
        sqlite3_bind_int (insert, 8, (int)article.rating);
        sqlite3_bind_int (insert, 9, (int)article.status);
        result = sqlite3_step(insert);
        
        sqlite3_finalize(insert);
        //Constraint violation
        if (result == 19) {
            return false;
        }else{
            return true;
            //NSLog(@"addArticleToArticleDB: Article has been added to database with result = %d SQLITE_OK = %d", result, SQLITE_OK);
        }
        
    } else {
        NSLog(@"addArticleToArticleDB: Error: insert prepare statement failed: %s.", sqlite3_errmsg(self.db));
        sqlite3_finalize(insert);
        return false;
    }
    
}

//- (BOOL) deleteArticle:(NSInteger) article_id forUser:(NSInteger)user_id
//{
//    NSString *sql = @"DELETE FROM UserArticle WHERE article_id=? AND user_id=?;";
//    sqlite3_stmt *insert;
//    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &insert, NULL);
//    if (result == SQLITE_OK) {
//        sqlite3_bind_int (insert, 1, (int)article_id);
//        sqlite3_bind_int (insert, 2, (int)user_id);
//        result = sqlite3_step(insert);
//        sqlite3_finalize(insert);
//        //NSLog(@"deleteArticle: Article Deleted!");
//        return true;
//    }else {
//        NSLog(@"deleteArticle: Error: insert prepare statement failed: %s.", sqlite3_errmsg(self.db));
//        sqlite3_finalize(insert);
//        return false;
//    }
//}


- (BOOL) deleteArticle:(NSInteger) article_id
{
    //NSString *sql = @"DELETE FROM UserArticle WHERE article_id=? AND user_id=?;";
    NSString *sql = @"UPDATE Article SET status=2 WHERE article_id=?";
    sqlite3_stmt *insert;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &insert, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_int (insert, 1, (int)article_id);
        result = sqlite3_step(insert);
        sqlite3_finalize(insert);
        //NSLog(@"deleteArticle: Article Deleted!");
        return true;
    }else {
        NSLog(@"deleteArticle: Error: insert prepare statement failed: %s.", sqlite3_errmsg(self.db));
        sqlite3_finalize(insert);
        return false;
    }
}

- (BOOL) addArticleToUserArticleDB:(Article *)article
{
    //NSString* str = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserLoginIdSession"];
    
    NSString *sql = @"INSERT INTO UserArticle (user_id, article_id, date_added, archived) VALUES (?,?,?,?)";
    sqlite3_stmt *insert;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &insert, NULL);
    if (result == SQLITE_OK) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:article.date];
        
        sqlite3_bind_int (insert, 1, (NSInteger)16);
        sqlite3_bind_int (insert, 2, (int)article.article_id);
        sqlite3_bind_text(insert, 3, [strDate UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int (insert, 4, (int)article.archived);
        result = sqlite3_step(insert);
        //NSLog(@"addArticleToUserArticleDB: Article added for user result = %d, SQLITE_OK = %d", result, SQLITE_OK);
        sqlite3_finalize(insert);
        return true;
    } else {
        NSLog(@"addArticleToUserArticleDB: Error: insert prepare statement failed: %s.", sqlite3_errmsg(self.db));
        sqlite3_finalize(insert);
        return false;
    }
    

}

- (BOOL) addTagsForArticleWithID:(NSInteger)article_id tags:(NSString*)tag
{
    NSString *sql = @"INSERT INTO ArticleTags (article_id, tag) VALUES (?,?)";
    sqlite3_stmt *insert;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &insert, NULL);
    if (result == SQLITE_OK) {
        sqlite3_bind_int (insert, 1, (int)article_id);
        sqlite3_bind_text(insert, 2, [tag UTF8String], -1, SQLITE_TRANSIENT);
        result = sqlite3_step(insert);
        sqlite3_finalize(insert);
        return true;
    } else {
        NSLog(@"addTagsForArticleWithID: Error: insert prepare statement failed: %s.", sqlite3_errmsg(self.db));
        sqlite3_finalize(insert);
        return false;
    }
}


#pragma mark getLastArticleDate
- (NSString* )getLastArticleDate
{
    NSString* date_adde  = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT date_added FROM Article AS A JOIN UserArticle AS UA ON UA.article_id=A.ID WHERE article_id = (SELECT MAX(article_id)  FROM UserArticle)"];
    sqlite3_stmt *select;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &select, NULL);
    if (result == SQLITE_OK) {
        while (sqlite3_step(select) == SQLITE_ROW) {
            // add the id:
            date_adde = [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 0)];
            sqlite3_finalize(select);
            return date_adde;
        }
    }
    sqlite3_finalize(select);
    return date_adde;
}

-(NSInteger)getLastArticleID
{
    NSInteger last_id  = -1;
    NSString *sql = [NSString stringWithFormat:@"SELECT MAX(ID)  FROM Article"];
    
    sqlite3_stmt *select;
    
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &select, NULL);
    if (result == SQLITE_OK) {
        while (sqlite3_step(select) == SQLITE_ROW) {
            // add the id:
            last_id = [[NSString stringWithFormat:@"%s", sqlite3_column_text (select, 0)] integerValue];
            sqlite3_finalize(select);
            return last_id;
        }
    }
    sqlite3_finalize(select);
    return last_id;
}


- (BOOL) archiveArticle:(Article *) article forUser:(NSInteger)user_id
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE UserArticle SET archived = ? WHERE article_id=? AND user_id=?"];
    
    sqlite3_stmt *update;
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &update, NULL);
    NSLog(@"archiveArticle: Before IF %d %d",result, SQLITE_OK);
    
    if (result == SQLITE_OK){
        sqlite3_bind_int(update, 1, 1);
        
        sqlite3_bind_int(update, 2 , (int)article.article_id);
        
        sqlite3_bind_int(update, 3 , (int)user_id);
        
        char* errmsg;
        sqlite3_exec(self.db, "COMMIT", NULL, NULL, &errmsg);
        //NSLog(@"archiveArticle: Article was archived!");
    }else{
        NSLog(@"archiveArticle: Error while creating update statement. %s", sqlite3_errmsg(self.db));
    }
    
    
    if(SQLITE_DONE != sqlite3_step(update))
        NSLog(@"Error while updating. %s", sqlite3_errmsg(self.db));
    
    sqlite3_finalize(update);
    return false;
}

- (NSMutableArray* )importAllArchivedForUser:(NSInteger)user_id
{
    NSMutableArray *inboxArticles = [[NSMutableArray alloc]initWithCapacity:20];
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM Article AS A JOIN UserArticle AS UA ON UA.article_id=A.ID WHERE user_id=? AND archived=?"];
    //NSString *sql = [NSString stringWithFormat:@"SELECT * FROM UserArticle"];
    
    sqlite3_stmt *select;
    
    int result = sqlite3_prepare_v2(self.db, [sql UTF8String], -1, &select, NULL);
    
    sqlite3_bind_int (select, 1, (int)user_id);
    sqlite3_bind_int (select, 2, (NSInteger)1);
    if (result == SQLITE_OK) {
        
        
        while (sqlite3_step(select) == SQLITE_ROW) {
            NSMutableArray *values = [[NSMutableArray alloc] initWithCapacity:6];
            
            // add the id:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 0)]];
            // add the content:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 1)]];
            // add the author:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 2)]];
            // add the date:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 3)]];
            // add the url:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text(select, 4)]];
            // add the tags:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 5)]];
            // add the title:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 6)]];
            // add the blog:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 7)]];
            // add the rating:
            [values addObject:
             [NSString stringWithFormat:@"%s", sqlite3_column_text (select, 8)]];
            
            
            
            Article* article = [[Article alloc]init];
            
            article.article_id = [[values objectAtIndex:0]integerValue];
            article.content = [values objectAtIndex:1];
            article.author = [values objectAtIndex:2];
            article.date = [values objectAtIndex:3];
            article.url = [values objectAtIndex:4];
            article.stringTags = [values objectAtIndex:5];
            article.title = [values objectAtIndex:6];
            article.blog = [values objectAtIndex:7];
            NSInteger a = [[values objectAtIndex:8] integerValue];
            article.rating = a;
            [inboxArticles addObject:article];
            //NSLog(@"Imported Article: %@", article);
        }
        
    }
    sqlite3_finalize(select);
    NSLog(@"%lu articles were imported form db", (unsigned long)inboxArticles.count);
    return inboxArticles;
}

@end
