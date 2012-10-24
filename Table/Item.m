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
        
        _title = [JSONObject[@"title"] stringValue];
        _subtitle = [JSONObject[@"subtitle"] stringValue];
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
        
        /*
         TODO: dodelat dalsi atributy
         "2012-10-24T14:03:27Z" timestamp ma format string "yyyy-MM-dd'T'HH:mm:ssZ"
         */
    }
    
    return self;
}

- (NSDictionary *)JSONObject
{
    /*
     Do NSDictionaty @ { key : value} nesmi prijit nil, takze tam dame zastupny objekt [NSNull null]
     */
    
    return @{
    @"item[title]" : _title? _title : [NSNull null],
    @"item[subtitle]" : _subtitle? _subtitle : [NSNull null],
    @"item[description]" : [NSNull null],
    @"item[price]" : @(3.1415)
    };
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Item: %@, %@", _title, _subtitle];
}

@end
