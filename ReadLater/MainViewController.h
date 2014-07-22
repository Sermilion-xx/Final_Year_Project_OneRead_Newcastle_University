//
//  MainViewController.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 02/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Article.h"
#import "LoginViewController.h"
#import "Database.h"
#import "DWTagList.h"

@interface MainViewController : UIViewController <DWTagListDelegate>

@property (nonatomic, strong) NSMutableArray        *array;
@property (nonatomic, strong) DWTagList             *tagList;
@property (nonatomic, strong) DWTagList             *blogList;
//@property (nonatomic, weak) IBOutlet UITextField    *addTagField;

- (IBAction)tappedAdd:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton* E;
@property (nonatomic, strong) IBOutlet UIButton* R;
@property (nonatomic, strong) IBOutlet UIButton* A;

@property (nonatomic, strong) IBOutlet UIButton* allTagsButton;
@property (nonatomic, strong) IBOutlet UIButton* allBlogsButton;
@property (nonatomic, strong) IBOutlet UIButton* sortByDateButton;
@property (nonatomic, strong) IBOutlet UIButton* sortByRatingButton;
@property (nonatomic, strong) IBOutlet UIButton* goButton;

@property (nonatomic, strong) NSMutableArray* allTags;
@property (nonatomic, strong) NSMutableArray* allBlogs;
@property (nonatomic, strong) NSMutableArray* selectedTags;
@property (nonatomic, strong) NSMutableArray* selectedBlogs;
@property (nonatomic, strong) Database* db;
//0 - E, 1- R, 2-A
@property (nonatomic, assign) NSInteger ERA;


@end
