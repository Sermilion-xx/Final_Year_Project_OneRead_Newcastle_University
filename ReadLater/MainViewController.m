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

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize allBlogs, allTags, db;

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
    [_tagList setCornerRadius:4.0f];
    [_tagList setBorderColor:[UIColor lightGrayColor].CGColor];
    [_tagList setBorderWidth:1.0f];
    
    _blogList = [[DWTagList alloc] initWithFrame:CGRectMake(30.0f, 320.0f, self.view.bounds.size.width-40.0f, 50.0f)];
    [_blogList setAutomaticResize:YES];
    _array = [[NSMutableArray alloc] initWithArray:self.allBlogs];
    [_blogList setTags:_array];
    [_blogList setTagDelegate:self];
    
    // Customisation
    [_blogList setCornerRadius:4.0f];
    [_blogList setBorderColor:[UIColor lightGrayColor].CGColor];
    [_blogList setBorderWidth:1.0f];
    
    [self.view addSubview:_blogList];
    [self.view addSubview:_tagList];
    
}

- (void)selectedTag:(NSString *)tagName tagIndex:(NSInteger)tagIndex
{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message"
//                                                    message:[NSString stringWithFormat:@"You tapped tag %@ at index %ld", tagName,(long)tagIndex]
//                                                   delegate:nil
//                                          cancelButtonTitle:@"Ok"
//                                          otherButtonTitles:nil];
//    [alert show];

    [self.selectedTags addObject:tagName];
    
    
}

- (IBAction)ETapped:(id)sender
{
    
}
- (IBAction)tappedAdd:(id)sender
{
//    [_addTagField resignFirstResponder];
//    if ([[_addTagField text] length]) {
//        [_array addObject:[_addTagField text]];
//    }
//    [_addTagField setText:@""];
//    [_tagList setTags:_array];
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

@end
