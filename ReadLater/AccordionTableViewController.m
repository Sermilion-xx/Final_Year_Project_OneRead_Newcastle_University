//
//  AccordionTableViewController.m
//  AccordionTableView
//
//  Created by Vladimir Olexa on 3/29/13.
//  Copyright (c) 2013 Vladimir Olexa. All rights reserved.
//

#import "AccordionTableViewController.h"
#import "Article.h"
#import "InboxViewController.h"


#define NUM_TOP_ITEMS 20
#define NUM_SUBITEMS 6

static NSDictionary *optionDictionary;
static NSString *CellIdentifier = @"MyOptionCell";

@interface AccordionTableViewController () <UISearchBarDelegate>
@property(nonatomic, strong) NSArray *filteredOptions;
@end

@implementation AccordionTableViewController

@synthesize articles, delegate, tags, db, blogs, enteredBlogs, enteredTags;

- (NSMutableArray* ) articles
{
    if (!articles) {
        articles = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return articles;
}

- (NSMutableArray* ) tags
{
    if (!tags) {
        tags = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return tags;
}

- (NSMutableArray* ) blogs
{
    if (!blogs) {
        blogs = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return blogs;
}

- (NSMutableArray* ) enteredBlogs
{
    if (!enteredBlogs) {
        enteredBlogs = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return enteredBlogs;
}

- (NSMutableArray* ) enteredTags
{
    if (!enteredTags) {
        enteredTags = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return enteredTags;
}

- (Database* ) db
{
    if (!db) {
        db = [[Database alloc] init];
    }
    return db;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super init];
    if (self) {
        topItems = [[NSArray alloc] initWithArray:[self topLevelItems]];
        subItems = [NSMutableArray new];
        currentExpandedIndex = -1;
        NSMutableArray *subitems = [self subItems];
        [subItems addObject:[subitems objectAtIndex:0]];
        [subItems addObject:[subitems objectAtIndex:1]];
        [subItems addObject:[subitems objectAtIndex:2]];
        [subItems addObject:[subitems objectAtIndex:3]];
    }
    return self;
}

#pragma mark - Data generators

- (NSArray *)topLevelItems {
    NSMutableArray *items = [NSMutableArray array];
    
    [items addObject:@"Sort"];
    [items addObject:@"Filter By Tags"];
    [items addObject:@"Filter By Blog"];
    [items addObject:@"Reset"];
    return items;
}

- (NSMutableArray *)subItems {
    NSMutableArray *subItems1 = [NSMutableArray array];
    
    NSMutableArray *subSorting = [NSMutableArray array];
    NSMutableArray *subFilterByDate = [NSMutableArray array];
    NSMutableArray *subFilterByRating = [NSMutableArray array];
    NSMutableArray *subReset = [NSMutableArray array];
    
    [subSorting addObject:@"Sort By Date"];
    [subSorting addObject:@"Sort By Rating"];
    
    [subReset addObject:@"Reset Tags"];
    [subReset addObject:@"Reset Blogs"];
    
    
    [self.db openDatabase];
    self.tags = [self.db getAllTags];
    self.blogs = [self.db getAllBlog];
    
    [self.db closeDatabase];

    [subFilterByDate addObjectsFromArray:self.tags];
    
    [subFilterByRating addObjectsFromArray:self.blogs];
    
    [subItems1 addObject:subSorting];
    [subItems1 addObject:subFilterByDate];
    [subItems1 addObject:subFilterByRating];
    [subItems1 addObject:subReset];
    
    
    return subItems1;
}

#pragma mark - View management

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    [self.searchDisplayController.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.tableView.tableHeaderView = self.searchDisplayController.searchBar;
    self.filteredOptions = @[];
    self.navigationController.navigationBar.hidden=NO;
    [self setTitle:@"Menu"];
    NSLog(@"Article Sizedsfsdjfldksf %lu", (unsigned long)self.articles.count);
    //populate table view with distinct tags form all articles
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [topItems count] + ((currentExpandedIndex > -1) ? [[subItems objectAtIndex:currentExpandedIndex] count] : 0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ParentCellIdentifier = @"ParentCell";
    static NSString *ChildCellIdentifier = @"ChildCell";
    
    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[subItems objectAtIndex:currentExpandedIndex] count];
    
    UITableViewCell *cell;
    
    if (isChild) {
        cell = [tableView dequeueReusableCellWithIdentifier:ChildCellIdentifier];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:ParentCellIdentifier];
    }
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ParentCellIdentifier];
    }
    
    if (isChild) {
        cell.detailTextLabel.text = [[subItems objectAtIndex:currentExpandedIndex] objectAtIndex:indexPath.row - currentExpandedIndex - 1];
    }
    else {
        long topIndex = (currentExpandedIndex > -1 && indexPath.row > currentExpandedIndex)
        ? indexPath.row - [[subItems objectAtIndex:currentExpandedIndex] count]
        : indexPath.row;
        
        cell.textLabel.text = [topItems objectAtIndex:topIndex];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}






#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isChild =
    currentExpandedIndex > -1
    && indexPath.row > currentExpandedIndex
    && indexPath.row <= currentExpandedIndex + [[subItems objectAtIndex:currentExpandedIndex] count];
    
    if (isChild) {

        NSString *cellValue = [self.tableView cellForRowAtIndexPath:indexPath].detailTextLabel.text;
        //NSLog(@"A child was tapped, do what you will with it %@", firstCar);
        if ([cellValue isEqualToString:@"Sort By Date"] || [cellValue isEqualToString:@"Sort By Rating"]) {
            
            if([cellValue isEqualToString:@"Sort By Date"]){
                NSArray* sortedArticles = [self sortArticlesBy:0];
                self.articles = [sortedArticles mutableCopy];
                [self.delegate  selectedFilter:self.articles];
                [self dismissViewControllerAnimated:YES completion:NULL];

                
            }else{
                
                NSArray* sortedArticles = [self sortArticlesBy:1];
                self.articles = [sortedArticles mutableCopy];
                [self.delegate  selectedFilter:self.articles];
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
        
        }else{
            //----------------------------------------------------------------------------------------------------//
            
            //sort by blog
            NSRange range = [cellValue rangeOfString:@"."];
            if (range.location != NSNotFound) {
                
                [self.db openDatabase];
                [self.enteredBlogs removeAllObjects];
                self.enteredBlogs = [self.db importAllArticlesFilterByOption:cellValue];
                [self.db closeDatabase];

                self.articles = enteredBlogs;
                [self.delegate  selectedFilter:self.articles];
                [self dismissViewControllerAnimated:YES completion:NULL];
                
                
            }else{
                //sort by tag
                [self.db openDatabase];
                [self.enteredTags removeAllObjects];
                self.enteredTags = [self.db importAllArticlesFilterByOption:cellValue];
                [self.db closeDatabase];
                [self.articles removeAllObjects];
                
                self.articles = self.enteredTags;
                [self.delegate  selectedFilter:self.articles];
                [self dismissViewControllerAnimated:YES completion:NULL];
                
            }
            
            
            //----------------------------------------------------------------------------------------------------//
            
            if ([cellValue isEqualToString:@"Reset Tags"]) {
                [self.enteredTags removeAllObjects];
                [self.articles removeAllObjects];
                
                self.articles = [self.db importAllArticlesWithStatus:0];
                [self.delegate  selectedFilter:self.articles];
                
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            
            if ([cellValue isEqualToString:@"Reset Blogs"]) {
                [self.articles removeAllObjects];

                self.articles = [self.db importAllArticlesWithStatus:0];
                [self.delegate  selectedFilter:self.articles];
                [self dismissViewControllerAnimated:YES completion:NULL];
            }
            
        }
    
        return;
    }
    
    
    
    [self.tableView beginUpdates];
    
    if (currentExpandedIndex == indexPath.row) {
        [self collapseSubItemsAtIndex:(int)currentExpandedIndex];
        currentExpandedIndex = -1;
    }
    else {
        
        BOOL shouldCollapse = currentExpandedIndex > -1;
        
        if (shouldCollapse) {
            [self collapseSubItemsAtIndex:(int)currentExpandedIndex];
        }
        
        currentExpandedIndex = (shouldCollapse && indexPath.row > currentExpandedIndex) ? indexPath.row - [[subItems objectAtIndex:currentExpandedIndex] count] : indexPath.row;
        
        [self expandItemAtIndex:(int)currentExpandedIndex];
    }
    
    [self.tableView endUpdates];
    
}

- (void)expandItemAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    NSArray *currentSubItems = [subItems objectAtIndex:index];
    int insertPos = index + 1;
    for (int i = 0; i < [currentSubItems count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:insertPos++ inSection:0]];
    }
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)collapseSubItemsAtIndex:(int)index {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (int i = index + 1; i <= index + [[subItems objectAtIndex:index] count]; i++) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
}

#pragma mark Filtering/Sorting of Articles
//sorting type: 0 - date , 1- by rating
- (NSArray*)sortArticlesBy:(int )type
{
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"rating" ascending:YES comparator:^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    
    
    if (type==0) {

    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"date"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [self.articles
                                 sortedArrayUsingDescriptors:sortDescriptors];
    return sortedEventArray;
        
    }else if(type==1){
        NSArray* sortedByRatingArray = [NSMutableArray arrayWithArray:[self.articles sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];

        return sortedByRatingArray;

    }
    return nil;
}

- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue
{

}



@end
