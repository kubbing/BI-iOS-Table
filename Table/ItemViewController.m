//
//  ItemViewController.m
//  Table
//
//  Created by Jakub Hladík on 24.10.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import "ItemViewController.h"
#import "NetworkService.h"
#import "ToastService.h"

@implementation ItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _subtitleCell.detailTextLabel.text = _item.title;
    _descriptionCell.detailTextLabel.text = _item.subtitle;
    _imageCell.imageView.image = [UIImage imageNamed:@"kitty"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveButtonTapped:)];
}

- (void)saveButtonTapped:(id)sender
{
    if (_item) {
        /*
         TODO:
         mame _item, taze budeme updatovat a NEbudeme vytvaret novy item na serveru
         takze HTTP PUT
         
         [NetworkService sharedService] updateItemWithId: withItem:
         */
    }
    else {
        /*
         TODO:
         zadny item nemame a tak ho musime vytvorit
         takze HTTP POST
         */
        
        Item *item = [[Item alloc] init];
        item.title = [[NSDate date] description];
        
        /*
         nastavime mu properties
         item.title = titleTextField.text
         ...
         */
        
        DEFINE_BLOCK_SELF;
        [[NetworkService sharedService] createItem:item
                                           success:^(Item *item){
                                               if (blockSelf.onSave) {
                                                   blockSelf.onSave(item);
                                               }
                                           } failure:^{
                                               [[ToastService sharedService] toastErrorWithTitle:@"Error" subtitle:@"Could not create item."];
                                           }];
    }
}

@end
