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
        NSURL *url = [NSURL URLWithString:@"http://illy.kubbing.com:3000"];
        _client = [AFHTTPClient clientWithBaseURL:url];
        [_client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        _client.operationQueue.maxConcurrentOperationCount = 2;
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

- (void)getItems
{
    [self getJSONAtPath:@"items.json"
                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    TRC_OBJ(responseObject);
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    ;
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

- (void)newItem
{
    NSDictionary *item = @{
    @"item[title]" : @"yahooo",
    @"item[subtitle]" : @"dobry den",
    @"item[description]" : @"desc text text",
    @"item[price]" : @(6.50)
    };
    
    TRC_OBJ(item);
    
    [self postJSONObject:item
                  toPath:@"items"
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     ;
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     ;
                 }];
}

@end
