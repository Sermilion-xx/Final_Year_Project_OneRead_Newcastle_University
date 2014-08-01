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

@interface ArchiveViewController ()

@end

@implementation ArchiveViewController

@synthesize db, articles, response, jsonData, sortingOption, allTagsAndBlogs, selectedBlogs, selectedTags;

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
    NSInteger user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserLoginIdSession"]integerValue];
    NSArray *importedArticles =  [self.db importAllArchivedForUser:user_id];
    self.articles = nil;
    [self.articles addObjectsFromArray:importedArticles];
    [self.tableView reloadData];
    
//    if (!self.allTagsAndBlogs) {
//        if (self.selectedTags.count>0 && self.selectedBlogs.count>0) {
//            self.articles = [self.db importAndFilterTags:self.selectedTags andBlogs:selectedBlogs archived:YES];
//            self.articles = [[self sortArticlesBy:(int)self.sortingOption]mutableCopy];
//        }
//    }else{
//        NSInteger user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserLoginIdSession"]integerValue];
//        self.articles = [self.db importAllArticlesForUser:(int)user_id archived:0];
//        self.articles = [[self sortArticlesBy:(int)self.sortingOption]mutableCopy];
//    }
    
    
    
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
    NSInteger user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserLoginIdSession"]integerValue];
    [self.db openDatabase];
    [self.db archiveArticle:articleToArchive forUser:user_id];
    NSLog(@"A-Block to archive.");
    [self.db closeDatabase];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}


- (void) performSegueForSharing:(Article *)article
{
    
}

- (void) performSegueForTagging
{
    
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

- (IBAction)goBack:(UIStoryboardSegue *)sender
{
    
}
@end
