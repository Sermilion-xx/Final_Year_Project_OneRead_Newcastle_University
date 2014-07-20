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

@synthesize tags, article, db;

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
    self.tags = [self.db getAllTags];
    [self.db closeDatabase];
    
    
	_tagsInputView = [[AKTagsInputView alloc] initWithFrame:CGRectMake(17, 261.0f, 278, 35.0f)];
	_tagsInputView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	_tagsInputView.lookupTags = self.tags; //@[@"ios", @"iphone", @"objective-c", @"development", @"cocoa", @"xcode", @"icloud"];
	//_tagsInputView.selectedTags = nil;
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

- (IBAction) btnPressed:(id)sender
{
   [self dismissViewControllerAnimated:YES completion:NULL]; 
}

@end
