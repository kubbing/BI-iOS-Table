//
//  Item.m
//  Table
//
//  Created by Jakub Hladík on 24.10.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import "Item.h"

@implementation Item

- (id)initWithJSONObject:(NSDictionary *)JSONObject
{
    self = [super init];
    if (self) {
        TRC_OBJ(JSONObject);
        
        _title = JSONObject[@"title"];
        _subtitle = JSONObject[@"subtitle"];
//        NSNumber *number = JSONObject[@"price"];
//        if ((NSNull *)number != [NSNull null]) {
//            _price = number.floatValue;
//        }
        _price = [JSONObject[@"price"] floatValue];
        
        NSString *dateString = JSONObject[@"available"];
        if ((NSNull *)dateString != [NSNull null]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyy-MM-dd";
            _available = [formatter dateFromString:dateString];
        }
    }
    
    return self;
}

- (NSDictionary *)JSONObject
{
    return @{
    @"item[title]" : @"yahooo",
    @"item[subtitle]" : @"dobry den",
    @"item[description]" : @"desc text text",
    @"item[price]" : @(6.50)
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Item: %@, %@", _title, _subtitle];
}

@end
