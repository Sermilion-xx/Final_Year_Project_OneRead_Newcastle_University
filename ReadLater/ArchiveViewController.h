//
//  ArchivedViewController.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 28/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "LoginViewController.h"
#import "Database.h"
#import "SHCTableViewCellDelegate.h"
#import "RTLabel.h"


@interface ArchiveViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, SHCTableViewCellDelegate, RTLabelDelegate>



@property (strong, nonatomic) IBOutlet UITableView *tableView;
//--------------------For Segue------------------------------//
//prperty for inbox articles of user
@property (nonatomic, strong) NSData* response;
@property (nonatomic, strong) NSMutableArray* jsonData;

@property (nonatomic, strong) NSMutableArray* articles;
@property (nonatomic, strong) Article* articleToShare;
@property (nonatomic, strong) Article* articleToTag;
//@property (nonatomic, strong) NSMutableArray* safeArticles;
@property (nonatomic, strong) Database* db;
//-----------------------------------------------------------//

@property (strong, nonatomic) NSArray *data;
@property (nonatomic, strong) NSURL* url;

//0 - E, 1- R, 2-A
@property (nonatomic, assign) NSInteger ERA;
//0 - date, 1 - rating
@property (nonatomic, assign) NSInteger sortingOption;

@property (nonatomic, strong) NSMutableArray* selectedTags;
@property (nonatomic, strong) NSMutableArray* selectedBlogs;
@property (nonatomic, assign) BOOL allTagsAndBlogs;
@property (nonatomic, assign) NSInteger EIRA;

@end
