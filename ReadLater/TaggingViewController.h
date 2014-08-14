//
//  TaggingViewController.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 20/07/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "Database.h"
#import "InboxViewController.h"


@protocol TaggingDelegate <NSObject>
- (void)tagAddedToArticle:(Article *)article;
@end


@interface TaggingViewController : UIViewController 

@property (nonatomic, strong) IBOutlet UITextField* tagsTextField;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@property (nonatomic, strong) Article* article;
@property (nonatomic, strong) NSMutableArray* tags;

@property (nonatomic, strong) Database* db;

- (IBAction) btnPressed:(id)sender;

@property (nonatomic, weak) id<TaggingDelegate> delegate;


@property (nonatomic, strong) NSURLConnection * connection;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSData* response;
@property (nonatomic, strong) NSMutableArray* jsonData;

@end
