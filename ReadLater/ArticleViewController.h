//
//  ArticleViewController.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 23/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"
#import "AMWaveTransition.h"

@interface ArticleViewController : UIViewController

@property (nonatomic, nonatomic) IBOutlet UILabel* article_title;
@property (nonatomic, strong) IBOutlet UIImageView* article_image;
@property (nonatomic, strong) IBOutlet UITextView* article_content;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Article* article;
@property (strong, nonatomic) IBOutlet AMWaveTransition *interactive;

- (id)initWithArticle:(Article*) article1;
@end
