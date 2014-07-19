//
//  ArticleViewController.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 09/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Database.h"
#import "LoginViewController.h"
#import "Database.h"
#import "SHCTableViewCellDelegate.h"
#import "RTLabel.h"



@interface InboxViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, SHCTableViewCellDelegate, RTLabelDelegate>

//- (id) initWithInboxArticles:(NSMutableArray*) inbox;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//--------------------For Segue------------------------------//
//prperty for inbox articles of user
@property (nonatomic, strong) NSData* response;
@property (nonatomic, strong) NSMutableArray* jsonData;

@property (nonatomic, strong) NSMutableArray* articles;
@property (nonatomic, strong) Article* articleToShare;
@property (nonatomic, strong) Database* db;
//-----------------------------------------------------------//

@property (strong, nonatomic) NSArray *data;
//left side menu
@property (nonatomic,retain) UIImageView *bgView;

@property (nonatomic, strong) NSURL* url;


@end
