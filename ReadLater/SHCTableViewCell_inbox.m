//
//  SHCTableViewCell.m
//  ClearStyle
//
//  Created by Fahim Farook on 23/9/12.
//  Copyright (c) 2012 RookSoft Pte. Ltd. All rights reserved.
//

#import "SHCTableViewCell_inbox.h"
#import <QuartzCore/QuartzCore.h>

@implementation SHCTableViewCell_inbox {
    CAGradientLayer* _gradientLayer;
	CGPoint _originalCenter;
    
	UILabel *deleteLabel;
	UILabel *archiveLabel;
    UILabel *tagLabel;
	UILabel *shareLabel;
    
    BOOL _markDeleteOnDragRelease;
	BOOL _markArchivedOnDragRelease;
    BOOL _markSetTagOnDragRelease;
    BOOL _markShareOnDragRelease;
}

const float UI_CUES_MARGIN = 20.0f;
const float UI_CUES_WIDTH = 60.0f;

- (void)awakeFromNib {
    //self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // add a Delete label
        deleteLabel = [self createCueLabel];
        deleteLabel.text = @"Delete";
        deleteLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:deleteLabel];
        
        // add a Archived label
        archiveLabel = [self createCueLabel];
        archiveLabel.text = @"Archive";
        archiveLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:archiveLabel];
        
        // add a tag label
        tagLabel = [self createCueLabel];
        tagLabel.text = @"Set tag";
        tagLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:tagLabel];
        
        // add a favourite label
        shareLabel = [self createCueLabel];
        shareLabel.text = @"Share";
        shareLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:shareLabel];
		// remove the default blue highlight for selected cells
		//self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //[self.layer insertSublayer:_gradientLayer atIndex:0];
		// add a pan recognizer
		UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		recognizer.delegate = self;
		[self addGestureRecognizer:recognizer];
        
        //clickable labe;
        #pragma mark clickable label
        _rtLabel = [SHCTableViewCell_inbox textLabel];
		[self.contentView addSubview:_rtLabel];
		[_rtLabel setBackgroundColor:[UIColor clearColor]];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

}



const float LABEL_LEFT_MARGIN = 20.0f;

-(void)layoutSubviews {
    [super layoutSubviews];

    archiveLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);
    //archiveLabel.hidden = YES;
    
    deleteLabel.frame = CGRectMake(self.bounds.size.width + UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);

    
    tagLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);

    
    shareLabel.frame = CGRectMake(-UI_CUES_WIDTH - UI_CUES_MARGIN, 0, UI_CUES_WIDTH, self.bounds.size.height);

    
    CGSize optimumSize = [self.rtLabel optimumSize];
	CGRect frame = [self.rtLabel frame];
	frame.size.height = (int)optimumSize.height; // +5 to fix height issue, this should be automatically fixed in iOS5
	[self.rtLabel setFrame:frame];
}

-(void)setTodoItem:(Article *)todoItem {
    _todoItem = todoItem;
}

// utility method for creating the contextual cues
-(UILabel*) createCueLabel {
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectNull];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    label.backgroundColor = [UIColor clearColor];
    return label;
}

#pragma mark - horizontal pan gesture methods
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self superview]];
    // Check for horizontal gesture
    if (fabsf(translation.x) > fabsf(translation.y)) {
        return YES;
    }
    return NO;
}

-(void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
		// if the gesture has just started, record the current centre location
        _originalCenter = self.center;
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        // translate the center
        CGPoint translation = [recognizer translationInView:self];
        self.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        // determine whether the item has been dragged far enough to initiate a delete / complete
        _markArchivedOnDragRelease = self.frame.origin.x < (-self.frame.size.width / 2+(self.frame.size.width/4));
        _markDeleteOnDragRelease = self.frame.origin.x < (-self.frame.size.width / 2);
        _markSetTagOnDragRelease = self.frame.origin.x > (self.frame.size.width / 2);
        _markShareOnDragRelease = self.frame.origin.x > (self.frame.size.width / 4);
        
        if(_markDeleteOnDragRelease){
            _markArchivedOnDragRelease=false;
            deleteLabel.hidden=NO;
        }else{
            deleteLabel.hidden=YES;
        }
        
        if(_markArchivedOnDragRelease){
            _markDeleteOnDragRelease=false;
            archiveLabel.hidden=NO;

        }else{
            archiveLabel.hidden=YES;
        }
        
        if(_markSetTagOnDragRelease){
            _markShareOnDragRelease=false;
            tagLabel.hidden=NO;
        }else{
            tagLabel.hidden=YES;
        }
        
        if (_markShareOnDragRelease) {
            _markSetTagOnDragRelease=false;
            shareLabel.hidden=NO;
        }else{
            shareLabel.hidden=YES;
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // the frame this cell would have had before being dragged
        CGRect originalFrame = CGRectMake(0, self.frame.origin.y,
                                          self.bounds.size.width, self.bounds.size.height);
        if (!_markDeleteOnDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
		if (_markDeleteOnDragRelease) {
			// notify the delegate that this item should be deleted
            self.todoItem.completed = YES;
			[self.delegate deleteArticle:self.todoItem];
            NSLog(@"Delete Selected!");
		}
        if (!_markArchivedOnDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        if (_markArchivedOnDragRelease) {
            // mark the item as complete and update the UI state
            self.todoItem.completed = YES;
            NSLog(@"Archive Selected!");
           [self.delegate archiveArticle:self.todoItem];
            
        }
        if (!_markSetTagOnDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        if (_markSetTagOnDragRelease) {
            // mark the item as complete and update the UI state
            [self.delegate performSegueForTagging:self.todoItem];
            self.todoItem.completed = YES;
            NSLog(@"Set Tag Selected!");

        }
        if (!_markShareOnDragRelease) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 self.frame = originalFrame;
                             }
             ];
        }
        if (_markShareOnDragRelease) {
            // mark the item as complete and update the UI state
            [self.delegate performSegueForSharing:self.todoItem];
            self.todoItem.completed = YES;
            NSLog(@"Share Selected!");
        }
        
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

//clickable label

+ (RTLabel*)textLabel
{
	RTLabel *label = [[RTLabel alloc] initWithFrame:CGRectMake(73,50,300,100)];
	[label setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    label.textColor = [UIColor whiteColor];
    [label setParagraphReplacement:@""];
	return label;
}

@end
