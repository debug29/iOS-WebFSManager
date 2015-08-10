//
//  WebFSManager.m
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import "WebFSManager.h"

#define API_ENDPOINT @"http://ioschallenge.api.meetlima.com/"

@implementation WebFSManager

+ (void) getDirectory:(NSString *)path completionBlock:(void (^)(BOOL success, NSDictionary *result)) _block {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[NSString stringWithFormat:@"%@%@", API_ENDPOINT, path] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _block(YES, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        _block(NO, nil);
    }];
}

@end
