//
//  SHCTableViewCell.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 17/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//


#import "SHCTableViewCellDelegate.h"
#import "Article.h"
#import "RTLabel.h"


// A custom table cell that renders SHCToDoItem items.
@interface SHCTableViewCell_inbox : UITableViewCell


@property (nonatomic) Article *todoItem;

// The object that acts as delegate for this cell.
@property (nonatomic, assign) id<SHCTableViewCellDelegate> delegate;

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet RTLabel *blog;
@property (nonatomic, strong) IBOutlet UILabel *tags;
@property (nonatomic, strong) IBOutlet UILabel *rating;


//clickable label
@property (nonatomic, strong) RTLabel *rtLabel;
+ (RTLabel*)textLabel;
@end