//
//  ArticleViewController.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 09/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "InboxViewController.h"
#import "LoginViewController.h"
#import "SHCTableViewCell_inbox.h"
#import "ArticleViewController.h"
#import "AMWaveTransition.h"
#import "AccordionTableViewController.h"
#import "WebViewController.h"
#import "SharingViewController.h"
#import "TaggingViewController.h"




@interface InboxViewController () <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate>

@end

@implementation InboxViewController

@synthesize db, connection, articles, response, jsonData, bgView, selectedBlogs, selectedTags,EIRA, sortingOption, allTagsAndBlogs;



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

#pragma mark Initialization


- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
        self.selectedTags = [[NSMutableArray alloc] initWithCapacity:20];
        self.selectedBlogs = [[NSMutableArray alloc] initWithCapacity:20];
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

//---------------------------------Getting data from web-------------------------------------------//

/**
 The method will connect to a given url and send date of article that has been added at last.
 Then, connectionDidFinishLoading will receive json array of all articles, that have been added to server database after that time
 **/
#pragma mark Connection to server
- (void) makeConnetion:(id)data
{
    
    if (self.articles.count==0) {
    NSURL *theURL = [NSURL URLWithString:@"http://localhost:8080/api/reading-list/?format=json"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:theURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //send id of article that was added last, to server,
    //which will return json arrya of all articles with id greater then the one sent
    [request setHTTPMethod:@"GET"];
    
        
    //Pass some default parameter(like content-type etc.)
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"1" forHTTPHeaderField:@"password"];
    [request setValue:@"Sermilion" forHTTPHeaderField:@"username"];
    //[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (self.connection) {
         NSLog(@"makeConnetion: Connected!");
        [self connectionDidFinishLoading:self.connection];
    }else{
        NSLog(@"makeConnetion: Error while connecting...");
    }
    }else{
        NSLog(@"makeConnetion: Loading 2nd time!");
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    response = [[NSData alloc] initWithData:data];
    
}

//Check if data been received
- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if(response!=nil){
        
    NSLog(@"Got response from server %@", response);
    if (self.connection) {

        NSError* error;
        NSArray* json = [NSJSONSerialization
                         JSONObjectWithData:response //1
                         options:kNilOptions
                         error:&error];
        
        self.jsonData = [[NSMutableArray alloc] initWithArray:json];
        int count = 0;
        [self.db openDatabase];
        BOOL added = false;
        BOOL addedToUser = false;
        NSLog(@"jsonData %lu", (unsigned long)jsonData.count);
        
        for (int i=0; i<self.jsonData.count; i++) {
            
            NSDictionary *item = [self.jsonData objectAtIndex:i];
            NSString* content = [item objectForKey:@"content"];
            NSString* author = [item objectForKey:@"author"];
            NSString* date = [item objectForKey:@"date"];
            
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date1 = [dateFormat dateFromString:date];
            NSString* url = [item objectForKey:@"url"];
            NSString* tags = [item objectForKey:@"tags"];
            NSMutableArray *tagsArray = [[tags componentsSeparatedByString:@","]mutableCopy];
            NSInteger archived = [[item objectForKey:@"archived"]integerValue];
            NSString* title = [item objectForKey:@"title"];
            NSString* blog = [item objectForKey:@"blog"];
            NSInteger rating = [[item objectForKey:@"rating"]integerValue];
            NSInteger status = [[item objectForKey:@"status"]integerValue];
            
            
            Article* article = [[Article alloc]initWithId:0 content:content author:author date:date1 url:url tags:tagsArray stringTags:tags arhived:archived title:title blog:blog rating:rating status:status];
            //adding articel to database
            added = [self.db addArticleToArticleDB:article];
            NSLog(@"Got from server: %@", article);
            if (added == true) {
                NSInteger last_id = [self.db getLastArticleID];
                article.article_id = last_id;
               //adding article to user 
                addedToUser = [self.db addArticleToUserArticleDB:article];
                
                
                for (int i=0; i<tagsArray.count; i++) {
                    bool added = [self.db addTagsForArticleWithID:article.article_id tags:[tagsArray objectAtIndex:i]];
                    if (added==true) {
                        //NSLog(@"Tags was added");
                    }
                }
                added=false;
                
            }
            count++;
        }
    }
    }
    
        self.connection = nil;
}

//----------------------------------------------------------------------------------------------------
#pragma mark TODO: work out why data from server loads only after second login
#pragma mark view
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.db openDatabase];
    NSString* date_added = [self.db getLastArticleDate];
    [self makeConnetion:(id)date_added];
    
    self.articles = [self.db importAndFilterByTags:self.selectedTags andBlogs:selectedBlogs status:0];
    self.articles = [[self sortArticlesBy:(int)self.sortingOption]mutableCopy];
    [self.tableView reloadData];
  
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    cell.EIRA=2;
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

#pragma mark TODO delete from server database
//method to delete an article form view and to call method to delete from database, as well as form server database
-(void)archiveUnarchiveDeleteArticle:(Article*)articleToArchive setStatus:(NSInteger)status
{
    // use the UITableView to animate the removal of this row
    NSUInteger index = [self.articles indexOfObject:articleToArchive];
    [self.tableView beginUpdates];
    [self.articles removeObject:articleToArchive];
    
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.db openDatabase];
    [self.db changeArticleStatus:articleToArchive setStatus:status];
    NSLog(@"A-Block to archive.");
    [self.db closeDatabase];
    [self.tableView endUpdates];
    [self.tableView reloadData];
}


//#pragma mark TODO delete from server database
////method to delete an article form view and to call method to delete from database, as well as form server database
//-(void)deleteArticle:(Article*)articleToDelete {
//    // use the UITableView to animate the removal of this row
//    NSUInteger index = [self.articles indexOfObject:articleToDelete];
//    [self.tableView beginUpdates];
//    [self.articles removeObject:articleToDelete];
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
//                          withRowAnimation:UITableViewRowAnimationFade];
//    [self.db openDatabase];
//    [self.db deleteArticle:articleToDelete.article_id];
//    [self.db closeDatabase];
//    [self.tableView endUpdates];
//    [self.tableView reloadData];
//}
//
//#pragma mark TODO delete from server database
////method to delete an article form view and to call method to delete from database, as well as form server database
////0-readingList, 1-archived, 2-deleted
//-(void)archiveArticle:(Article*)articleToArchive setArchived:(NSInteger)archived{
//    // use the UITableView to animate the removal of this row
//    NSUInteger index = [self.articles indexOfObject:articleToArchive];
//    [self.tableView beginUpdates];
//    [self.articles removeObject:articleToArchive];
//    
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]]
//                          withRowAnimation:UITableViewRowAnimationFade];
//    //NSInteger user_id = [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserLoginIdSession"]integerValue];
//    [self.db openDatabase];
//    [self.db changeArticleStatus:articleToArchive setStatus:1];
//    [self.db closeDatabase];
//    [self.tableView endUpdates];
//    [self.tableView reloadData];
//}

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
    
    if([segue.identifier isEqualToString:@"shareSegue"]){
        SharingViewController *controller = (SharingViewController *)segue.destinationViewController;
        controller.article = self.articleToShare;
    }
    
    if([segue.identifier isEqualToString:@"tagSegue"]){
        TaggingViewController *controller = (TaggingViewController *)segue.destinationViewController;
        controller.article = self.articleToTag;
        //[controller setDelegate:self];
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

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
	NSLog(@"did select url %@", url);
    self.url = url;
    [self performSegueWithIdentifier: @"WebView" sender: self];
}





@end
