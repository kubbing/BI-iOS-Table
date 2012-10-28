//
//  NetworkService.m
//  Table
//
//  Created by Jakub Hladík on 24.10.12.
//  Copyright (c) 2012 Jakub Hladík. All rights reserved.
//

#import "NetworkService.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "ToastService.h"
#import "Item.h"

@interface NetworkService ()

@property (nonatomic, strong) AFHTTPClient *client;

@end

@implementation NetworkService

+ (NetworkService *)sharedService
{
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[NetworkService alloc] init];
    });
}

- (id)init
{
    self = [super init];
    if (self) {
//        NSURL *url = [NSURL URLWithString:@"http://localhost:3000"];
        NSURL *url = [NSURL URLWithString:@"http://illy.kubbing.com:3000"];
        _client = [AFHTTPClient clientWithBaseURL:url];
        [_client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        _client.operationQueue.maxConcurrentOperationCount = 2;
        
//        [_client setDefaultHeader:@"Accept-Charset" value:@"UTF-8"];
//        [_client setDefaultHeader:@"Accept-Charset" value:@"utf-8"];
    }
    
    return self;
}

- (void)getJSONAtPath:(NSString *)aPath
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))onSuccess
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))onFailure
{
    [_client getPath:aPath
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 TRC_LOG(@"%d, GET %@", operation.response.statusCode, operation.request.URL);
                 onSuccess(operation, responseObject);
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 TRC_LOG(@"%d, GET %@", operation.response.statusCode, operation.request.URL);
                 [[ToastService sharedService] toastErrorWithHTTPStatusCode:operation.response.statusCode];
                 onFailure(operation, error);
             }];
}

- (void)postJSONObject:(id)JSONObject
                toPath:(NSString *)aPath
               success:(void (^)(AFHTTPRequestOperation *, id))onSuccess
               failure:(void (^)(AFHTTPRequestOperation *, NSError *))onFailure
{
    [_client postPath:aPath
           parameters:JSONObject
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                  TRC_LOG(@"%d, POST %@", operation.response.statusCode, operation.request.URL);
                  onSuccess(operation, responseObject);
              } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  TRC_LOG(@"%d, POST %@", operation.response.statusCode, operation.request.URL);
                  onFailure(operation, error);
              }];
}

- (void)getItemsSuccess:(void (^)(NSMutableArray *))onSuccess failure:(void (^)())onFailure
{
    [self getJSONAtPath:@"items.json"
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSMutableArray *itemArray = [NSMutableArray array];
                    for (NSDictionary *itemDictionary in responseObject) {
                        Item *item = [[Item alloc] initWithJSONObject:itemDictionary];
                        [itemArray addObject:item];
                    }
                    
                    if (onSuccess) {
                        onSuccess(itemArray);
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    if (onFailure) {
                        onFailure();
                    }
                }];
}

- (void)getItemWithId:(NSUInteger)anId
{
    [self getJSONAtPath:[NSString stringWithFormat:@"items/%d.json", anId]
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    TRC_OBJ(responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    ;
                }];
}

- (void)createItem:(Item *)item success:(void (^)(Item *item))onSuccess failure:(void (^)())onFailure
{    
    [self postJSONObject:[item JSONObject]
                  toPath:@"items.json"
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     Item *item = [[Item alloc] initWithJSONObject:responseObject];
                     if (onSuccess) {
                         onSuccess(item);
                     }
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     if (onFailure) {
                         onFailure();
                     }
                 }];
}

- (void)put
{
    NSDictionary *parameters = @{
        @"item[title]" : @"novy titulek"
    };
    
    [_client putPath:@"items/5.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TRC_LOG(@"%d, PUT %@", operation.response.statusCode, operation.request.URL);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        TRC_LOG(@"%d, PUT %@", operation.response.statusCode, operation.request.URL);
    }];
}

@end
