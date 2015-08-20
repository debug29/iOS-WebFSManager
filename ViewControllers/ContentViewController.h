//
//  ContentViewController.h
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemTableViewCell.h"
#import "MusicPlayerViewController.h"
#import "VideoViewController.h"
#import <NYTPhotosViewController.h>
#import "NYTExamplePhoto.h"

@interface ContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NYTPhotosViewControllerDelegate>

@property (nonatomic) NSMutableArray *contentArray;
@property (nonatomic) UITableView *contentTableView;
@property (nonatomic) UIRefreshControl *refreshControl;
@property (nonatomic) NSString *folderName;
@property (nonatomic) NSString *path;

@end
