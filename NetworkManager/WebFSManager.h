//
//  WebFSManager.h
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebFSManager : NSObject

+ (void) getDirectory:(NSString *)path completionBlock:(void (^)(BOOL success, NSDictionary *result)) _block;
+ (void) getMeta:(NSString *)path file:(NSString*)file completionBlock:(void (^)(BOOL success, NSDictionary *result)) _block;

@end
