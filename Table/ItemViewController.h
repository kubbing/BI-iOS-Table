//
//  ItemViewController.h
//  Table
//
//  Created by Jakub Hladík on 24.10.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface ItemViewController : UITableViewController

@property (nonatomic, strong) Item *item;

@property (weak, nonatomic) IBOutlet UITableViewCell *imageCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *subtitleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *descriptionCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *priceCell;

@property (nonatomic, strong) void (^onSave)(Item *item);

@end
