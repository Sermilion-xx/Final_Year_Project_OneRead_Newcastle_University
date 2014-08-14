//
//  TaggingViewController.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 20/07/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "TaggingViewController.h"
#import "AKTagsInputView.h"
#import "AKTagsDefines.h"
#import "AKTagsInputView.h"

@interface TaggingViewController ()
{
	AKTagsInputView *_tagsInputView;
}

@end

@implementation TaggingViewController

@synthesize tags, article, db, response, connection;

- (NSMutableArray*) tags
{
    if(!tags){
        tags = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return tags;
}

- (Database* ) db
{
    if (!db) {
        db = [[Database alloc] init];
    }
    return db;
}

- (Article*) article
{
    if(!article){
        article = [[Article alloc]init];
    }
    return article;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(AKTagsInputView*)createTagsInputView
{
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.titleLabel.text = self.article.title;
    [self.db openDatabase];
    self.tags = [self.db getAllTagsWithStatus:0];
    [self.db closeDatabase];
    
    
	_tagsInputView = [[AKTagsInputView alloc] initWithFrame:CGRectMake(17, 261.0f, 278, 35.0f)];
	_tagsInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_tagsInputView.lookupTags = self.tags; //@[@"ios", @"iphone", @"objective-c", @"development", @"cocoa", @"xcode", @"icloud"];
	_tagsInputView.selectedTags = [[NSMutableArray alloc]init];
	_tagsInputView.enableTagsLookup = YES;
    _tagsInputView.backgroundColor = [UIColor clearColor];
    //_tagsInputView.placeholder = @"+ Add";
	return _tagsInputView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];//WK_COLOR(200, 200, 200, 1);
	//[self.view addSubview:[self createLabel]];
	[self.view addSubview:[self createTagsInputView]];
	//[self.view addSubview:[self createButton]];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [self.view addSubview:tempImageView];
    [self.view sendSubviewToBack:tempImageView];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark TODO: add tag to server
#pragma mark TODO: refresh Reading List to display newly added tag
- (IBAction) btnPressed:(id)sender
{
    NSLog(@"TagInputView %@", _tagsInputView.selectedTags);
    NSMutableArray* temp = [[NSMutableArray alloc] initWithArray:_tagsInputView.selectedTags];
    [_tagsInputView.selectedTags removeAllObjects];
    
        for (int i=0; i<temp.count; i++) {
            [_tagsInputView.selectedTags addObject:[NSString stringWithFormat:@"#%@", [temp objectAtIndex:i]]];
        }
    [self.db openDatabase];
    
    for (int i=0;i<_tagsInputView.selectedTags.count; i++){
        [self.db addTagsForArticleWithID:self.article.article_id tags:[_tagsInputView.selectedTags objectAtIndex:i]];
        [self.article.tags addObject:[_tagsInputView.selectedTags objectAtIndex:i]];
    }
    
    [self.db closeDatabase];
    //[self.delegate tagAddedToArticle:self.article];
    
//    NSString* url = nil;
//    NSString* article_id = [NSString stringWithFormat:@"%ld", (long)self.article.article_id];

//    NSData *data = [[NSData alloc]init];
//    [data setValue:article_id forKey:@"article_id"];
//    [data setValue:_tagsInputView.selectedTags forKey:@"tags"];
//    
//    //send tags to add to database
//    [self makeConnetion:data toUrl:url];
    
   [self dismissViewControllerAnimated:YES completion:NULL]; 
}

- (void) makeConnetion:(id)data toUrl:(NSString*)url
{
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
        
        if (self.connection) {
            NSLog(@"Tagging: makeConnetion: Connected!");
            [self connectionDidFinishLoading:self.connection];
        }else{
            NSLog(@"Tagging: makeConnetion: Error while connecting...");
        }

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
{
    response = [[NSData alloc] initWithData:data];
    
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString* result = nil;
    if(response!=nil){
        if (self.connection) {
            
            NSError* error;
            NSArray* json = [NSJSONSerialization
                             JSONObjectWithData:response
                             options:kNilOptions
                             error:&error];
            
            self.jsonData = [[NSMutableArray alloc] initWithArray:json];
            
            for (int i=0; i<self.jsonData.count; i++) {
                NSDictionary *item = [self.jsonData objectAtIndex:i];
                result = [item objectForKey:@"result"];
            }
            
            if([result isEqualToString:@"success"]){
                NSLog(@"Tag was added to server database.");
            }else{
                NSLog(@"Error adding tag to server database.");
            }
            
        }
    }
}

@end
