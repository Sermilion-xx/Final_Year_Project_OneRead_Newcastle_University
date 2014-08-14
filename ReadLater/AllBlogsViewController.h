//
//  AllBlogsViewController.h
//  readlater
//
//  Created by Ibragim Gapuraev on 04/08/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "Database.h"
#import "SHCTableViewCellDelegate.h"
#import "RTLabel.h"
#import "TaggingViewController.h"
#import "DWTagList.h"

@protocol AllBlogsSelectDelegate <NSObject>
- (void)blogsWereSelected:(NSArray *)SelectedBlog;
@end

@interface AllBlogsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray* allBlogs;
@property (strong, nonatomic) NSMutableArray* selectedBlogs;
@property (nonatomic, strong) Database* db;



- (IBAction)showPressed:(UIButton*)sender;
@property (nonatomic, weak) id<AllBlogsSelectDelegate> delegate;

@end