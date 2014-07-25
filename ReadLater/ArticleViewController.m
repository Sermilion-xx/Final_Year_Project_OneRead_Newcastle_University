//
//  ArticleViewController.m
//  ReadLater
//
//  Created by Ibragim Gapuraev on 23/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "ArticleViewController.h"
#import "SHCTableViewCell_inbox.h"
#import "AMWaveTransition.h"

@interface ArticleViewController ()

@end

@implementation ArticleViewController

@synthesize article, article_content, article_image, article_title, interactive;



- (id)initWithArticle:(Article*) article1
{
    self = [super init];
    if (!self) {
        self.article = article1;
    }
    return self;
    
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
    
    self.article_title.text = self.article.title;
    self.article_content.text = self.article.content;
    self.article_content.backgroundColor = [UIColor clearColor];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    interactive = [[AMWaveTransition alloc] init];
    
    

    
    [self.tableView reloadData];

    

    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
