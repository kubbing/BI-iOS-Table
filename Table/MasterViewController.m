//
//  MasterViewController.m
//  Table
//
//  Created by Jakub Hladík on 17.10.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import "MasterViewController.h"
#import "ItemViewController.h"

@interface MasterViewController ()

@property (nonatomic, assign) BOOL editing;

@property (nonatomic, strong) NSMutableArray *itemArray;

@end

@implementation MasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Moje tabulka!";
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
    self.navigationItem.rightBarButtonItem = editItem;

    _itemArray = [NSMutableArray array];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self refresh:self.refreshControl];
    [self.refreshControl beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)refresh:(id)sender
{
    TRC_ENTRY;
    
    DEFINE_BLOCK_SELF;
    int64_t delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [blockSelf.refreshControl endRefreshing];
    });
}

- (void)addItem
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_itemArray.count inSection:0];
    [_itemArray addObject:[NSDate date]];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)editButtonTapped:(id)sender
{
        _editing = YES;
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem = doneItem;
    
    [self.tableView setEditing:YES animated:YES];
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_itemArray.count inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    

}

- (void)doneButtonTapped:(id)sender
{
       _editing = NO;
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
    self.navigationItem.rightBarButtonItem = editItem;
    
    [self.tableView setEditing:NO animated:YES];
    [self.tableView beginUpdates];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_itemArray.count inSection:0];
    [self.tableView deleteRowsAtIndexPaths:@[ indexPath ] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
 
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger count;
    if (_editing) {
        count = _itemArray.count + 1;
    }
    else {
        count = _itemArray.count;
    }
    
    TRC_LOG(@"%d", count);
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"[%d, %d]", indexPath.section, indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(320 - 180 -4, 2, 80, 20)];
        label.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        label.textAlignment = UITextAlignmentRight;
        label.tag = 1;
        label.adjustsFontSizeToFitWidth = YES;
        [cell.contentView addSubview:label];
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        cell.accessoryView = [[UISwitch alloc] init];
    }
    
    if (indexPath.row == _itemArray.count) {
        cell.textLabel.text = @"insert new";
        return cell;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", indexPath.row];
    cell.detailTextLabel.text = [[NSDate date] description];
    cell.imageView.image = [UIImage imageNamed:@"kitty"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterNoStyle;
    formatter.timeStyle = NSDateFormatterMediumStyle;
    NSString *timeString = [formatter stringFromDate:_itemArray[indexPath.row]];
    UILabel *dateLabel = (UILabel *)[cell.contentView viewWithTag:1];
    dateLabel.text = timeString;
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _itemArray.count) {
        return UITableViewCellEditingStyleInsert;
    }
    
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [_itemArray removeObjectAtIndex:indexPath.row];        
        [self.tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        ItemViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemViewNavigationController"];
//        [self presentViewController:controller animated:YES completion:nil];
        
        [self addItem];
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    id item = _itemArray[fromIndexPath.row];
    [_itemArray insertObject:item atIndex:toIndexPath.row];
    [_itemArray removeObjectAtIndex:fromIndexPath.row];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    if (indexPath.row == _itemArray.count) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%d", indexPath.row]
                               message:nil
                              delegate:nil
                     cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
}

@end
