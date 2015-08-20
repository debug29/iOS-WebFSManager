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

- (void) addFolder:(id) sender {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Create folder" message:@"Type the name of your folder" delegate:self cancelButtonTitle:@"Create" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"Entered: %@",[[alertView textFieldAtIndex:0] text]);
    
    [WebFSManager createDirectory:@"" withName:[[alertView textFieldAtIndex:0] text] completionBlock:^(BOOL success, NSDictionary *result) {
        NSLog(@"%@\n%@", success ? @"Yes" : @"No", result);
        [self refresh];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"WebFS Manager";
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFolder:)];
    self.navigationItem.rightBarButtonItem = flipButton;
    
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"ItemTableViewCelll"];
    ItemTableViewCell *cell = (ItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    [cell buildCellWithItem:[self.endpointArray objectAtIndex:indexPath.row] andPath:@""];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableViewCell *cell = (ItemTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
        ContentViewController *contentVC = [[ContentViewController alloc] init];
        contentVC.folderName = [self.endpointArray objectAtIndex:indexPath.row];
        contentVC.path = contentVC.folderName;
        
        [self.navigationController pushViewController:contentVC animated:YES];
    }
    else {
        if (cell.type == 3) {
            MusicPlayerViewController *player = [[MusicPlayerViewController alloc] init];
            player.fileURL = [NSString stringWithFormat:@"%@%@%@", API_ENDPOINT ,@"", [self.endpointArray objectAtIndex:indexPath.row]];
            [self.navigationController pushViewController:player animated:YES];
        }
        if (cell.type == 2) {
            VideoViewController *VideoVC = [[VideoViewController alloc] init];
            VideoVC.videoURL = [NSString stringWithFormat:@"%@%@%@", API_ENDPOINT ,@"", [self.endpointArray objectAtIndex:indexPath.row]];
            [self.navigationController presentViewController:VideoVC animated:YES completion:nil];
        }
        if (cell.type == 1) {
            NYTExamplePhoto *photo = [[NYTExamplePhoto alloc] init];
            photo.image = cell.image.image;
            
            NSArray *photos = [[NSArray alloc] initWithObjects:photo, nil];
            
            NYTPhotosViewController *photosViewController = [[NYTPhotosViewController alloc] initWithPhotos:photos];
            [self presentViewController:photosViewController animated:YES completion:nil];
        }
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NYTPhotosViewControllerDelegate

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id <NYTPhoto>)photo {
    return nil;
}

- (CGFloat)photosViewController:(NYTPhotosViewController *)photosViewController maximumZoomScaleForPhoto:(id <NYTPhoto>)photo {
    return 1.5f;
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController didNavigateToPhoto:(id <NYTPhoto>)photo atIndex:(NSUInteger)photoIndex {
    NSLog(@"Did Navigate To Photo: %@ identifier: %lu", photo, (unsigned long)photoIndex);
}

- (void)photosViewController:(NYTPhotosViewController *)photosViewController actionCompletedWithActivityType:(NSString *)activityType {
    NSLog(@"Action Completed With Activity Type: %@", activityType);
}

- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController {
    NSLog(@"Did Dismiss Photo Viewer: %@", photosViewController);
}


@end
