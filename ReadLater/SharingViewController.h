//
//  SharingViewController.h
//  readlater
//
//  Created by Ibragim Gapuraev on 02/08/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "Database.h"


@interface SharingViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField* followersTextField;
@property (nonatomic, strong) IBOutlet UITextField* shareMessage;
@property (nonatomic, strong) IBOutlet UILabel* titleLabel;

@property (nonatomic, strong) Article* article;

@property (nonatomic, strong) Database* db;

- (IBAction) btnPressed:(id)sender;

@property (nonatomic, strong) NSArray* allFollowers;
//
@end
