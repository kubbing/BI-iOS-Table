//
//  MasterViewController.m
//  Table
//
//  Created by Jakub Hladík on 17.10.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

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
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addButtonTapped:)];
    self.navigationItem.rightBarButtonItem = addItem;

    _itemArray = [NSMutableArray array];
    
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

- (void)addButtonTapped:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_itemArray.count inSection:0];
    [_itemArray addObject:[NSDate date]];
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[ indexPath ]
                          withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *title = nil;
//    switch (section) {
//        case 0:
//            title = @"FIT";
//            break;
//        case 1:
//            title = @"FEL";
//            break;
//        case 2:
//            title = @"FS";
//            break;
//        case 3:
//            title = @"AR";
//            break;
//        default:
//            break;
//    }
//    
//    return title;
//}

//- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//{
//    NSString *title = nil;
//    switch (section) {
//        case 0:
//            title = @"FIT je nejlepsi";
//            break;
//        case 1:
//            title = nil;
//            break;
//        case 2:
//            title = @"FS je nejvic";
//            break;
//        case 3:
//            title = @"AR …";
//            break;
//        default:
//            break;
//    }
//    
//    return title;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _itemArray.count;
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
        
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.accessoryView = [[UISwitch alloc] init];
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

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
