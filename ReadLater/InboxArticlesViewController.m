//
//  InboxArticlesViewController.m
//  readlater
//
//  Created by Ibragim Gapuraev on 07/08/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "InboxArticlesViewController.h"
#import "InboxViewController.h"
#import "LoginViewController.h"
#import "SHCTableViewCell_inbox.h"
#import "ArticleViewController.h"
#import "AMWaveTransition.h"
#import "AccordionTableViewController.h"
#import "WebViewController.h"
#import "SharingViewController.h"
#import "TaggingViewController.h"

@interface InboxArticlesViewController ()

@end

@implementation InboxArticlesViewController

@synthesize db, connection, articles, response, jsonData, url;



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


#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,30)];
		[titleLabel setBackgroundColor:[UIColor clearColor]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
		[titleLabel setText:@"RTLabel"];
		[self.navigationItem setTitleView:titleLabel];
		//[titleLabel setTextAlignment:UITextAlignmentCenter];
    }
    return self;
}


//----------------------------------------------------------------------------------------------------
#pragma mark TODO: work out why data from server loads only after second login
#pragma mark view
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.db openDatabase];
//    NSString* date_added = [self.db getLastArticleDate];
//    [self makeConnetion:(id)date_added];
//    [self.db closeDatabase];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.db openDatabase];
    self.articles = [self.db importAndFilterByTags:nil andBlogs:nil status:3];
    [self.db closeDatabase];
    [self.tableView reloadData];
    //[self.tableView registerClass:[SHCTableViewCell_inbox class] forCellReuseIdentifier:@"Content"];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    //[self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.tableView registerNib:[UINib nibWithNibName:@"SHCT_TableViewCell_inbox" bundle:nil] forCellReuseIdentifier:@"ContentCell"];
    
    [self setTitle:@"Inbox"];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.articles.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ContentCell";
    
    SHCTableViewCell_inbox *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.EIRA=1;
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    [cell setBackgroundColor:[UIColor clearColor]];
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Article* article = [self.articles objectAtIndex:indexPath.row];
    
    NSMutableString* blogLink = [[NSMutableString alloc] init];
    [blogLink appendFormat:@"%@%@%@%@%@", @"<a href='http://www.", article.blog, @"'>",article.blog, @"</a>"];
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

-(void)sendArticleToReadingList:(Article *)articleToArchive
{
    NSUInteger index = [self.articles indexOfObject:articleToArchive];
    [self.tableView beginUpdates];
    [self.articles removeObject:articleToArchive];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.db openDatabase];
    [self.db changeArticleStatus:articleToArchive setStatus:0];
    //
    [self.db closeDatabase];
    [self.tableView reloadData];
    [self.tableView endUpdates];
}


- (void) performSegueForSharing:(Article*)article
{
    self.articleToShare = article;
    [self performSegueWithIdentifier: @"shareSegue" sender: self];
}

- (void) performSegueForTagging:(Article*)article
{
    self.articleToTag = article;
    [self performSegueWithIdentifier: @"tagSegue" sender: self];
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


- (IBAction)goBack:(UIStoryboardSegue *)sender
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if([segue.identifier isEqualToString:@"Menu"]){
        AccordionTableViewController *controller = (AccordionTableViewController *)segue.destinationViewController;
        controller.articles = self.articles;
        //[controller setDelegate:self];
    }
    
    if([segue.identifier isEqualToString:@"WebView"]){
        WebViewController *controller = (WebViewController *)segue.destinationViewController;
        controller.url = self.url;
    }
    
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

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url1
{
	NSLog(@"did select url %@", url1);
    self.url = url1;
    [self performSegueWithIdentifier: @"WebView" sender: self];
}


@end
