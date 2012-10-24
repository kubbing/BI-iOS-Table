//
//  Item.h
//  Table
//
//  Created by Jakub Hladík on 24.10.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

- (id)initWithJSONObject:(id)JSONObject;

- (id)JSONObject;

@end
