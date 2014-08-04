//
//  MainViewController.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 02/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "MainViewController.h"
#import "User.h"
#import "DWTagList.h"
#import "InboxViewController.h"
#import "ArchiveViewController.h"
#import "AllTagsViewController.h"
#import "AllBlogsViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize allBlogs, allTags, db, selectedTags, selectedBlogs, ERA, sortingOption, allTagsAndBlogs;

- (Database* ) db
{
    if (!db) {
        db = [[Database alloc] init];
    }
    return db;
}

- (NSMutableArray* ) allBlogs
{
    if (!allBlogs) {
        allBlogs = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return allBlogs;
}

- (NSMutableArray* ) allTags
{
    if (!allTags) {
        allTags = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return allTags;
}

- (NSMutableArray* ) selectedTags
{
    if (!selectedTags) {
        selectedTags = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return selectedTags;
}

- (NSMutableArray* ) selectedBlogs
{
    if (!selectedBlogs) {
        selectedBlogs = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return selectedBlogs;
}

- (NSInteger)ERA
{
    if (!ERA) {
        ERA = 1;
    }
    return ERA;
}

- (NSInteger)sortingOption
{
    if (!sortingOption) {
        sortingOption = 0;
    }
    return sortingOption;
}

- (BOOL) allTagsAndBlogs
{
    if (!allTagsAndBlogs) {
        allTagsAndBlogs = NO;
    }
    return allTagsAndBlogs;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.db openDatabase];
    self.allTags = [self.db getAllTags];
    self.allBlogs = [self.db getAllBlog];
    [self.db closeDatabase];
    
    _tagList = [[DWTagList alloc] initWithFrame:CGRectMake(30.0f, 180.0f, self.view.bounds.size.width-40.0f, 50.0f)];
    [_tagList setAutomaticResize:YES];
    _array = [[NSMutableArray alloc] initWithArray:self.allTags];
    [_tagList setTags:_array];
    [_tagList setTagDelegate:self];
    
    // Customisation
    [_tagList setCornerRadius:8.0f];
    [_tagList setBorderColor:[UIColor lightGrayColor].CGColor];
    [_tagList setBorderWidth:1.0f];
    
    _blogList = [[DWTagList alloc] initWithFrame:CGRectMake(30.0f, 320.0f, self.view.bounds.size.width-40.0f, 50.0f)];
    [_blogList setAutomaticResize:YES];
    _array = [[NSMutableArray alloc] initWithArray:self.allBlogs];
    [_blogList setTags:_array];
    [_blogList setTagDelegate:self];
    
    // Customisation
    [_blogList setCornerRadius:6.0f];
    [_blogList setBorderColor:[UIColor lightGrayColor].CGColor];
    [_blogList setBorderWidth:1.0f];
    
    [self.view addSubview:_blogList];
    [self.view addSubview:_tagList];
    
}

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex
{
    NSString * tappedBlogOrTag = [NSString stringWithFormat:@"'%@'", tagName];
    
    if ((self.selectedBlogs.count==self.allBlogs.count) && (self.selectedTags.count==self.allTags.count)) {
        self.allTagsAndBlogs = YES;
    }else{
        self.allTagsAndBlogs = NO;
    }
    
    
    
    if (self.allTagsAndBlogs) {
        [self.selectedTags removeAllObjects];
        [self.selectedBlogs removeAllObjects];
    }else{
        if (self.selectedTags.count==self.allTags.count) {
            [self.selectedTags removeAllObjects];
        }
        if (self.selectedBlogs.count==self.allBlogs.count) {
            [self.selectedBlogs removeAllObjects];
        }
    }
    
    
    NSRange range = [tagName rangeOfString:@"."];
    if (range.location != NSNotFound) {
        
        if ([self.selectedBlogs containsObject:tappedBlogOrTag]) {
            [self.selectedBlogs removeObject:tappedBlogOrTag];
            NSLog(@"Blog %@ removed", tagName);
        }else{
            [self.selectedBlogs addObject:tappedBlogOrTag];
            NSLog(@"Blog %@ added", tappedBlogOrTag);
        }
    }else{
        if ([self.selectedTags containsObject:tappedBlogOrTag]) {
            [self.selectedTags removeObject:tappedBlogOrTag];
            NSLog(@"Tag %@ removed", tappedBlogOrTag);
        }else{
            [self.selectedTags addObject:tappedBlogOrTag];
            NSLog(@"Tag %@ added", tappedBlogOrTag);
        }
        
    }
    
}

- (IBAction)ETapped:(id)sender
{
    self.ERA = 0;
}

- (IBAction)RTapped:(id)sender
{
    self.ERA = 1;
}

- (IBAction)ATapped:(id)sender
{
    self.ERA = 2;
}

- (IBAction)sortByDateTapped:(id)sender
{
    self.sortingOption = 0;
}

- (IBAction)sortByRatingTapped:(id)sender
{
    self.sortingOption = 1;
}

- (IBAction)GoTapped:(id)sender
{
    
    if (self.selectedTags.count==0 && self.selectedBlogs.count==0) {
        self.allTagsAndBlogs=YES;
    }else{
        self.allTagsAndBlogs=NO;
    }
    
//    if (self.selectedTags.count==0) {
//        for (int i=0; i<self.allTags.count; i++) {
//            [self.selectedTags addObject:[NSString stringWithFormat:@"'%@'", [self.allTags objectAtIndex:i]]];
//        }
//        //self.selectedTags = self.allTags;
//    }
//    if (self.selectedBlogs.count==0) {
//        for (int i=0; i<self.allBlogs.count; i++) {
//            [self.selectedBlogs addObject:[NSString stringWithFormat:@"'%@'", [self.allBlogs objectAtIndex:i]]];
//        }
//        //self.selectedBlogs= self.allBlogs;
//    }
    
    
    if (self.ERA == 0) {
       [self performSegueWithIdentifier: @"ExploreSegue" sender: self];
    }else if(self.ERA ==1){
        [self performSegueWithIdentifier: @"InboxSegue" sender: self];
    }else if(self.ERA ==2){
        [self performSegueWithIdentifier: @"ArchiveSegue" sender: self];
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"InboxSegue"]){
        UINavigationController * navigationController = (UINavigationController *)[segue destinationViewController];
        InboxViewController * controller = [[navigationController viewControllers] objectAtIndex:0];
        controller.ERA = ERA;
        controller.sortingOption = self.sortingOption;
        controller.selectedTags = self.selectedTags;
        controller.selectedBlogs = self.selectedBlogs;
        controller.allTagsAndBlogs = self.allTagsAndBlogs;

    }
    
    if([segue.identifier isEqualToString:@"ArchiveSegue"]){
        UINavigationController * navigationController = (UINavigationController *)[segue destinationViewController];
        ArchiveViewController * controller = [[navigationController viewControllers] objectAtIndex:0];
        controller.ERA = ERA;
        controller.sortingOption = self.sortingOption;
        controller.selectedTags = self.selectedTags;
        controller.selectedBlogs = self.selectedBlogs;
        controller.allTagsAndBlogs = self.allTagsAndBlogs;
        
    }
    
    if ([segue.identifier isEqualToString:@"allTagsSegue"]) {
        [self.selectedTags removeAllObjects];
        UINavigationController * navigationController = (UINavigationController *)[segue destinationViewController];
        AllTagsViewController * controller = [[navigationController viewControllers] objectAtIndex:0];
        controller.allTags = self.allTags;
        //tags
        [controller.selectedTags removeAllObjects];
        [controller setDelegate:self];

    }
    
    if ([segue.identifier isEqualToString:@"allBlogsSegue"]) {
        [self.selectedTags removeAllObjects];
        UINavigationController * navigationController = (UINavigationController *)[segue destinationViewController];
        AllBlogsViewController * controller = [[navigationController viewControllers] objectAtIndex:0];
        [controller.allBlogs removeAllObjects];
        controller.allBlogs = self.allBlogs;
        [controller setDelegate:self];
        
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(UIStoryboardSegue *)sender
{
    
}

- (void)tagsWereSelected:(NSArray *)SelectedTags
{
    if (SelectedTags.count==0) {
        SelectedTags = self.allTags;
        self.allTagsAndBlogs=YES;
    }else{
        self.allTagsAndBlogs=NO;
    }
    [self.selectedBlogs removeAllObjects];
    [_tagList setTags:SelectedTags];
    for (int i=0; i<SelectedTags.count; i++) {
        [self.selectedTags addObject:[NSString stringWithFormat:@"'%@'",[SelectedTags objectAtIndex:i]]];
    }
    
}

- (void)blogsWereSelected:(NSArray *)SelectedBlogs
{
    
    if (SelectedBlogs.count==0) {
        SelectedBlogs = self.allBlogs;
        self.allTagsAndBlogs=YES;
    }else{
        self.allTagsAndBlogs=NO;
    }
    [self.selectedBlogs removeAllObjects];
    [_blogList setTags:SelectedBlogs];
    for (int i=0; i<SelectedBlogs.count; i++) {
        [self.selectedBlogs addObject:[NSString stringWithFormat:@"'%@'",[SelectedBlogs objectAtIndex:i]]];
    }
    
}

@end
