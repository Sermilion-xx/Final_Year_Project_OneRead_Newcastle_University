//
//  InboxArticlesViewController.h
//  readlater
//
//  Created by Ibragim Gapuraev on 07/08/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "LoginViewController.h"
#import "Database.h"
#import "SHCTableViewCellDelegate.h"
#import "RTLabel.h"
#import "TaggingViewController.h"
#import "AllTagsViewController.h"


@interface InboxArticlesViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, SHCTableViewCellDelegate, RTLabelDelegate>

//prperty for inbox articles of user
@property (nonatomic, strong) NSData* response;
@property (nonatomic, strong) NSMutableArray* jsonData;

@property (nonatomic, strong) NSMutableArray* articles;
@property (nonatomic, strong) Article* articleToShare;
@property (nonatomic, strong) Article* articleToTag;
@property (nonatomic, strong) Database* db;
@property (nonatomic, strong) NSURLConnection * connection;
@property (nonatomic, strong) NSURL* url;
@end
