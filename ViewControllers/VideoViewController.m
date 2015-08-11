//
//  VideoViewController.m
//  mydistrikt
//
//  Created by fcdev on 09/12/2014.
//  Copyright (c) 2014 COULON Florian. All rights reserved.
//

#import "VideoViewController.h"

#define DEGREES_TO_RADIANS(x) (x * M_PI/180.0)

@interface VideoViewController ()

@end

@implementation VideoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSLog(@"%@", self.videoURL);
    self.player = [[FCVideoPlayerView alloc] initWithFrame:self.view.bounds contentURL:[NSURL URLWithString:_videoURL]];
    
    [self.view addSubview:self.player];
    self.player.tintColor = [UIColor orangeColor];
    self.player.delegate = self;
    [self.player play];
    [self.player showHud:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(detectOrientation) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self.player pause];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self removeFromParentViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    UIView *BG = [[UIView alloc] initWithFrame:self.view.bounds];
    BG.backgroundColor = [UIColor blackColor];
    [self.view addSubview:BG];
}

-(void) detectOrientation {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation( DEGREES_TO_RADIANS(90) );
        [UIView animateWithDuration:0.5
                         animations:^{
                             CGAffineTransform landscapeTransform = rotation;
                             self.player.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
                             self.player.center = self.view.center;
                             [self.player setTransform:landscapeTransform];
                         } completion:nil];
    }
    else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation( DEGREES_TO_RADIANS(-90) );
        [UIView animateWithDuration:0.5
                         animations:^{
                             CGAffineTransform landscapeTransform = rotation;
                             self.player.frame = CGRectMake(0, 0, self.view.frame.size.height, self.view.frame.size.width);
                             self.player.center = self.view.center;
                             [self.player setTransform:landscapeTransform];
                         } completion:nil];
    }
    else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        CGAffineTransform rotation = CGAffineTransformMakeRotation( DEGREES_TO_RADIANS(0) );
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.player.transform = CGAffineTransformIdentity;
                             self.player.transform = rotation;
                             self.player.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                         } completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
