//
//  ContentViewController.m
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import "ContentViewController.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.folderName;
    NSLog(@"%@", self.path);
    self.contentArray = [[NSMutableArray alloc] init];
    
    self.contentTableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.contentTableView.delegate = self;
    self.contentTableView.dataSource = self;
    [self.view addSubview:self.contentTableView];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    [self.contentTableView addSubview:self.refreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [WebFSManager getDirectory:self.path completionBlock:^(BOOL success, NSDictionary *result) {
        NSLog(@"%@\n%@", success ? @"Yes" : @"No", result);
        self.contentArray = [[NSMutableArray alloc] initWithArray:(NSArray*)result];
        [self.contentTableView reloadData];
    }];
}

- (void) refresh {
    [WebFSManager getDirectory:self.path completionBlock:^(BOOL success, NSDictionary *result) {
        NSLog(@"%@\n%@", success ? @"Yes" : @"No", result);
        self.contentArray = [[NSMutableArray alloc] initWithArray:(NSArray*)result];
        [self.contentTableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"ItemTableViewCelll"];
    ItemTableViewCell *cell = (ItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        [cell buildCellWithItem:[self.contentArray objectAtIndex:indexPath.row] andPath:self.path];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell *cell = (ItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        ContentViewController *contentVC = [[ContentViewController alloc] init];
        contentVC.folderName = [self.contentArray objectAtIndex:indexPath.row];
        contentVC.path = [NSString stringWithFormat:@"%@/%@", self.path, contentVC.folderName];
        
        [self.navigationController pushViewController:contentVC animated:YES];
    }
    else {
        if (cell.type == 3) {
            MusicPlayerViewController *player = [[MusicPlayerViewController alloc] init];
            player.fileURL = [NSString stringWithFormat:@"%@%@/%@", API_ENDPOINT ,self.path, [self.contentArray objectAtIndex:indexPath.row]];
            [self.navigationController pushViewController:player animated:YES];
        }
        if (cell.type == 2) {
            
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
