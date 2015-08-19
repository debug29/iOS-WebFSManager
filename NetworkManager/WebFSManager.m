//
//  WebFSManager.m
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import "WebFSManager.h"

@implementation WebFSManager

+ (void) getDirectory:(NSString *)path completionBlock:(void (^)(BOOL success, NSDictionary *result)) _block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", API_ENDPOINT, path];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _block(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _block(NO, nil);
    }];
}

+ (void) getMeta:(NSString *)path file:(NSString*)file completionBlock:(void (^)(BOOL success, NSDictionary *result)) _block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    if ([path isEqualToString:@""]) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@?stat", API_ENDPOINT, path, file];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _block(YES, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _block(NO, nil);
        }];
    }
    else {
        NSString *urlString = [NSString stringWithFormat:@"%@%@/%@?stat", API_ENDPOINT, path, file];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            _block(YES, responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            _block(NO, nil);
        }];
        
    }
}


@end
