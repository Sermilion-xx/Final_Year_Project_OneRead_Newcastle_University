//
//  AllTagsViewController.h
//  readlater
//
//  Created by Ibragim Gapuraev on 02/08/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "Database.h"
#import "SHCTableViewCellDelegate.h"
#import "RTLabel.h"
#import "TaggingViewController.h"
#import "DWTagList.h"

@protocol AllTagsSelectDelegate <NSObject>
- (void)tagsWereSelected:(NSArray *)SelectedTags;
@end

@interface AllTagsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* allTags;
@property (strong, nonatomic) NSMutableArray* selectedTags;
@property (nonatomic, strong) Database* db;



- (IBAction)showPressed:(UIButton*)sender;
@property (nonatomic, weak) id<AllTagsSelectDelegate> delegate;

@end
