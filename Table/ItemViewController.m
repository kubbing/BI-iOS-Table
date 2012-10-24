//
//  ItemViewController.m
//  Table
//
//  Created by Jakub Hladík on 24.10.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import "ItemViewController.h"
//#import "UIImageView+AFNetworking.h"
#import "NetworkService.h"

@implementation ItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _subtitleCell.detailTextLabel.text = _item.title;
    _descriptionCell.detailTextLabel.text = _item.subtitle;
    _imageCell.imageView.image = [UIImage imageNamed:@"kitty"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped:)];
}

- (void)addButtonTapped:(id)sender
{
    [[NetworkService sharedService] newItemWithItem:[[Item alloc] init]];
}

@end
