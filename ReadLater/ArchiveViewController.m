//
//  ArchivedViewController.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 28/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "ArchiveViewController.h"
#import "LoginViewController.h"
#import "SHCTableViewCell_inbox.h"
#import "ArticleViewController.h"
#import "AMWaveTransition.h"
#import "SharingViewController.h"
#import "WebViewController.h"
#import "TaggingViewController.h"

@interface ArchiveViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, TaggingDelegate>

@end

@implementation ArchiveViewController

@synthesize db, articles, response, jsonData, selectedBlogs, selectedTags, ERA, sortingOption, allTagsAndBlogs;

- (NSMutableArray* ) selectedBlogs
{
    if (!selectedBlogs) {
        selectedBlogs = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return selectedBlogs;
}

- (NSMutableArray* ) selectedTags
{
    if (!selectedTags) {
        selectedTags = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return selectedTags;
}

- (BOOL) allTagsAndBlogs
{
    if (!allTagsAndBlogs) {
        allTagsAndBlogs = NO;
    }
    return allTagsAndBlogs;
}


- (NSMutableArray* ) articles
{
    if (!articles) {
        articles = [[NSMutableArray alloc] initWithCapacity:20];
    }
    
    return articles;
}

- (Database* ) db
{
    if (!db) {
        db = [[Database alloc] init];
    }
    return db;
}


//---------------------------------Getting data from web-------------------------------------------//

/**
 The method will connect to a given url and send date of article that has been added at last.
 Then, connectionDidFinishLoading will receive json array of all articles, that have been added to server database after that time
 **/

//----------------------------------------------------------------------------------------------------
#pragma mark TODO: work out why data from server loads only after second login
#pragma mark view
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.db openDatabase];
    
    if (!self.allTagsAndBlogs) {
        self.articles = [self.db importAndFilterByTags:self.selectedTags andBlogs:selectedBlogs status:1];
        self.articles = [[self sortArticlesBy:(int)self.sortingOption]mutableCopy];
    }else{
        self.articles = [self.db importAllArticlesWithStatus:1];
        self.articles = [[self sortArticlesBy:(int)self.sortingOption]mutableCopy];
    }

    [self.tableView reloadData];
    

    NSLog(@"A-viewWillAppear: self.articles: %lu", (unsigned long)self.articles.count);
    [self.db closeDatabase];
    [self.tableView registerClass:[SHCTableViewCell_inbox class] forCellReuseIdentifier:@"Content"];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self setTitle:@"Archive"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"SHCT_TableViewCell_inbox" bundle:nil] forCellReuseIdentifier:@"ContentCell"];
    
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.navigationController setDelegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"A-numberOfRowsInSection: self.articles: %lu", (unsigned long)self.articles.count);
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ContentCell";
    
    SHCTableViewCell_inbox *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    [cell setBackgroundColor:[UIColor clearColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Article* article = [self.articles objectAtIndex:indexPath.row];
    
    NSMutableString* blogLink = [[NSMutableString alloc] init];
    [blogLink appendFormat:@"%@%@%@%@%@", @"<a href='http://www.", article.blog, @"'>",article.blog, @"</a>"];
    //cell.blog.text = @"<a href='http://www.google.com'>link to google</a>";//blogLink;
    cell.rating.text = [NSString stringWithFormat: @"%ld", (long)article.rating];
    cell.title.text = article.title;
    cell.tags.text = article.stringTags;
    cell.rtLabel.text = blogLink;
    [cell.rtLabel setDelegate:self];
    
    cell.delegate = self;
    cell.todoItem = article;
    return cell;

}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation != UINavigationControllerOperationNone) {
        return [AMWaveTransition transitionWithOperation:operation andTransitionType:AMWaveTransitionTypeBounce];
    }
    return nil;
}

- (NSArray*)visibleCells
{
    return [self.tableView visibleCells];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0f;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell.backgroundColor = [self colorForIndex:indexPath.row];
}


#pragma mark TODO delete from server database
//method to delete an article form view and to call method to delete from database, as well as form server database
-(void)deleteArticle:(Article*)articleToDelete {
    // use the UITableView to animate the removal of this row
    NSUInteger index = [self.articles indexOfObject:articleToDelete];
    [self.tableView beginUpdates];
    [self.articles removeObject:articleToDelete];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.db openDatabase];
    [self.db deleteArticle:articleToDelete.article_id];
    [self.db closeDatabase];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}

#pragma mark TODO delete from server database
//method to delete an article form view and to call method to delete from database, as well as form server database
-(void)archiveArticle:(Article*)articleToArchive {
    // use the UITableView to animate the removal of this row
    NSUInteger index = [self.articles indexOfObject:articleToArchive];
    [self.tableView beginUpdates];
    [self.articles removeObject:articleToArchive];
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.db openDatabase];
    [self.db archiveArticle:articleToArchive];
    NSLog(@"A-Block to archive.");
    [self.db closeDatabase];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}



- (void) performSegueForSharing:(Article*)article
{
    self.articleToShare = article;
    [self performSegueWithIdentifier: @"shareSegueArchive" sender: self];
}

- (void) performSegueForTagging:(Article*)article
{
    self.articleToTag = article;
    [self performSegueWithIdentifier: @"tagSegueArchive" sender: self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"WebView"]){
        WebViewController *controller = (WebViewController *)segue.destinationViewController;
        controller.url = self.url;
    }
    
    if([segue.identifier isEqualToString:@"shareSegueArchive"]){
        SharingViewController *controller = (SharingViewController *)segue.destinationViewController;
        controller.article = self.articleToShare;
    }
    
    if([segue.identifier isEqualToString:@"tagSegueArchive"]){
        TaggingViewController *controller = (TaggingViewController *)segue.destinationViewController;
        controller.article = self.articleToTag;
        [controller setDelegate:self];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath  *)indexPath
{
    
    ArticleViewController *articleView = [self.storyboard instantiateViewControllerWithIdentifier:@"ArticleView"];
    articleView.article = [self.articles objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:articleView animated:YES];
    
    
}

#pragma mark - State Selection Delegate
- (void)tagAddedToArticle:(Article *)article
{
    if (!self.allTagsAndBlogs) {
        //if (self.selectedTags.count>0 && self.selectedBlogs.count>0) {
        self.articles = [self.db importAndFilterByTags:self.selectedTags andBlogs:selectedBlogs status:0];
        self.articles = [[self sortArticlesBy:(int)self.sortingOption]mutableCopy];
        //}
    }else{
        //NSInteger user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserLoginIdSession"]integerValue];
        self.articles = [self.db importAllArticlesWithStatus:0];
        self.articles = [[self sortArticlesBy:(int)self.sortingOption]mutableCopy];
    }
    [self.tableView reloadData];
}

- (NSArray*)sortArticlesByDate:(NSMutableArray*)articles1
{
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:@"date"
                                        ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSArray *sortedEventArray = [articles1
                                 sortedArrayUsingDescriptors:sortDescriptors];
    return sortedEventArray;
    
    
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

#pragma mark RTLabel delegate

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
	NSLog(@"did select url %@", url);
    self.url = url;
    [self performSegueWithIdentifier: @"WebView" sender: self];
}

@end
