//
//  SHCTableViewCellDelegate.h
//  ReadLater
//
//  Created by Ibragim Gapuraev on 17/06/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "Article.h"

// A protocol that the SHCTableViewCell uses to inform of state change
//
@protocol SHCTableViewCellDelegate <NSObject>

// indicates that the given item has been deleted
- (void) deleteArticle:(Article*) articleToDelete;

- (void) archiveArticle:(Article*) articleToArchive;

- (void) performSegueForSharing:(Article*)article;

- (void) performSegueForTagging;

@end
