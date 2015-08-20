//
//  HomeViewController.h
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemTableViewCell.h"
#import "ContentViewController.h"
#import "VideoViewController.h"
#import <NYTPhotosViewController.h>
#import "NYTExamplePhoto.h"

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NYTPhotosViewControllerDelegate>

@property (nonatomic) NSMutableArray *endpointArray;
@property (nonatomic) UITableView *homeTableView;
@property (nonatomic) UIRefreshControl *refreshControl;

@end
