//
//  AccordionTableViewController.h
//  AccordionTableView
//
//  Created by Vladimir Olexa on 3/29/13.
//  Copyright (c) 2013 Vladimir Olexa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InboxViewController.h"
#import "Database.h"

@protocol OptionSelectionDelegate <NSObject>
- (void)selectedFilter:(NSMutableArray *)articles;

@end

@interface AccordionTableViewController  : UITableViewController  {
    
    NSArray *topItems;
    NSMutableArray *subItems; // array of arrays
    NSInteger currentExpandedIndex;
}

@property (nonatomic, strong) NSMutableArray* enteredTags;
@property (nonatomic, strong) NSMutableArray* enteredBlogs;

@property (nonatomic, strong) NSMutableArray* articles;
@property (nonatomic, strong) NSMutableArray* tags;
@property (nonatomic, strong) NSMutableArray* blogs;
@property (nonatomic, strong) Database* db;

@property (nonatomic, weak) id<OptionSelectionDelegate> delegate;
- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;
@end