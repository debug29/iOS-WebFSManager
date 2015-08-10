//
//  ContentViewController.h
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemTableViewCell.h"

@interface ContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSMutableArray *contentArray;
@property (nonatomic) UITableView *contentTableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSString *folderName;
@property (nonatomic) NSString *path;

@end
