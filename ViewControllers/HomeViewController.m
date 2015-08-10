//
//  HomeViewController.m
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WebFS Manager";
    self.endpointArray = [[NSMutableArray alloc] init];
    
    self.homeTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.homeTableView.delegate = self;
    self.homeTableView.dataSource = self;
    [self.view addSubview:self.homeTableView];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.homeTableView addSubview:self.refreshControl];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [WebFSManager getDirectory:@"" completionBlock:^(BOOL success, NSDictionary *result) {
        NSLog(@"%@\n%@", success ? @"Yes" : @"No", result);
        self.endpointArray = [[NSMutableArray alloc] initWithArray:(NSArray*)result];
        [self.homeTableView reloadData];
    }];
}

- (void) refresh {
    [WebFSManager getDirectory:@"" completionBlock:^(BOOL success, NSDictionary *result) {
        NSLog(@"%@\n%@", success ? @"Yes" : @"No", result);
        self.endpointArray = [[NSMutableArray alloc] initWithArray:(NSArray*)result];
        [self.homeTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@""];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell.textLabel setText:[self.endpointArray objectAtIndex:indexPath.row]];

        [WebFSManager getMeta:@"" file:[self.endpointArray objectAtIndex:indexPath.row] completionBlock:^(BOOL success, NSDictionary *result) {
            NSLog(@"%@\n%@", success ? @"Yes" : @"No", result);
            if ([[result objectForKey:@"mimetype"] isEqualToString:@"inode/directory"])
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            else if ([[result objectForKey:@"mimetype"] isEqualToString:@"image/jpeg"]) {
                AsyncImageView *imageBG = [[AsyncImageView alloc] initWithFrame:cell.contentView.bounds];
                imageBG.imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_ENDPOINT, [self.endpointArray objectAtIndex:indexPath.row]]];
                imageBG.contentMode = UIViewContentModeScaleAspectFill;
                imageBG.clipsToBounds = YES;
                imageBG.showActivityIndicator = NO;
                [cell.contentView insertSubview:imageBG belowSubview:cell.textLabel];
                cell.textLabel.textColor = [UIColor whiteColor];
                cell.textLabel.layer.shadowOpacity = 1.0;
                cell.textLabel.layer.shadowRadius = 3.0;
                cell.textLabel.layer.shadowColor = [UIColor blackColor].CGColor;
                cell.textLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
            }
                
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.endpointArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

@end
