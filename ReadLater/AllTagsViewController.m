//
//  AllTagsViewController.m
//  readlater
//
//  Created by Ibragim Gapuraev on 02/08/2014.
//  Copyright (c) 2014 Sermilion. All rights reserved.
//

#import "AllTagsViewController.h"
#import "AMWaveTransition.h"
#import "SHCTableViewCell_inbox.h"
#import "NRLabel.h"
#import "InboxViewController.h"


@interface AllTagsViewController ()

@end

@implementation AllTagsViewController

@synthesize allTags, db, selectedTags;

- (NSMutableArray*) allTags
{
    if(!allTags){
        allTags = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return allTags;
}


- (NSMutableArray*) selectedTags
{
    if(!selectedTags){
        selectedTags = [[NSMutableArray alloc]initWithCapacity:20];
    }
    return selectedTags;
}

- (Database* ) db
{
    if (!db) {
        db = [[Database alloc] init];
    }
    return db;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {

//		UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,150,30)];
//		[titleLabel setBackgroundColor:[UIColor clearColor]];
//		[titleLabel setTextColor:[UIColor whiteColor]];
//		[titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20]];
//		[titleLabel setText:@"RTLabel"];
//		[self.navigationItem setTitleView:titleLabel];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
	[self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    //[self.tableView registerNib:[UINib nibWithNibName:@"SHCT_TableViewCell_inbox" bundle:nil] forCellReuseIdentifier:@"ContentCell"];
    [self setTitle:@"All Tags"];
    self.tableView.allowsMultipleSelection = YES;
    NSMutableArray *sorted = [[self.allTags sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        // Remove all spaces
        NSString *s1 = [str1 stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString *s2 = [str2 stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        return [s1 localizedCaseInsensitiveCompare:s2];
    }] mutableCopy];
    self.allTags = sorted;

    //[self.db openDatabase];
    //self.allTags = [self.db getAllTags];
    //[self.db closeDatabase];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.allTags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tagCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //cell.textLabel.layer.borderColor = [UIColor greenColor].CGColor;
    //cell.textLabel.layer.borderWidth = 1.0;
    [cell setBackgroundColor:[UIColor clearColor]];
    self.clearsSelectionOnViewWillAppear = NO;
	//[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textLabel.text = [self.allTags objectAtIndex:indexPath.row];
    NSLog(@"Row: %ld", (long)indexPath.row);
    
    if([[tableView indexPathsForSelectedRows] containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
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
    return 40.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellValue = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.selectedTags addObject:cellValue];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView.hidden = YES;
    //[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    // if you don't use custom image tableViewCell.accessoryType = UITableViewCellAccessoryNone;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellValue = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryView.hidden = NO;
    [self.selectedTags removeObject:cellValue];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    if([segue.identifier isEqualToString:@"tagSelectSegue"]){
//        UINavigationController * navigationController = (UINavigationController *)[segue destinationViewController];
//        InboxViewController * controller = [[navigationController viewControllers] objectAtIndex:0];
//        controller.selectedTags = self.selectedTags;
//        
//    }
//}


- (IBAction)showPressed:(UIButton*)sender
{
    
    [self.delegate tagsWereSelected:self.selectedTags];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
