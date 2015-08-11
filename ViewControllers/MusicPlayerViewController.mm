//
//  MusicPlayerViewController.m
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import "MusicPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "VisualizerView.h"
#import "MeterTable.h"

@interface MusicPlayerViewController ()

@end

@implementation MusicPlayerViewController {
    MeterTable meterTable;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // Test Meta
    
    AVAsset *asset;
    
    NSURL *URL = [NSURL URLWithString:[self.fileURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    asset = [AVURLAsset URLAssetWithURL:URL options:nil];

    NSUInteger dTotalSeconds = CMTimeGetSeconds([asset duration]);
    
    NSUInteger dHours = floor(dTotalSeconds / 3600);
    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    
    NSString *videoDurationText = [NSString stringWithFormat:@"%lu:%02lu:%02lu",(unsigned long)dHours, (unsigned long)dMinutes, (unsigned long)dSeconds];
    NSLog(@"%@", videoDurationText);
    for (AVMetadataItem *metadataItem in asset.commonMetadata) {
        
        NSLog(@"%@ : %@", metadataItem.commonKey, metadataItem.stringValue);
        
        if ([metadataItem.commonKey isEqualToString:@"artwork"]){
     
        }
    }

    // End test meta

}

- (void)viewWillDisappear:(BOOL)animated {
    // Disable player at end of view
    [self.audioPlayer stop];
}

- (void)viewDidAppear:(BOOL)animated {
    
    // Wait view before start player (better transition)
    
    [self configureAudioPlayer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure session
    
    [self configureAudioSession];
    
    self.title = @"Music Player";
    self.view.backgroundColor = [UIColor blackColor];
    
    self.visualizer = [[VisualizerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.visualizer.alpha = 0.4;
    [self.visualizer.emitterLayer setValue:(id)[self getRandomColor].CGColor forKeyPath:@"emitterCells.cell.color"];
    [self.view addSubview:_visualizer];
    
    
    // ToolBar
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 94., self.view.frame.size.width, 94)];
    [_toolBar setBarStyle:UIBarStyleBlackTranslucent];
    [_toolBar setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    self.playBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(playPause)];
    
    self.pauseBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(playPause)];
    
    UIBarButtonItem *leftFlexBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *rightFlexBBI = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    self.playItems = [NSArray arrayWithObjects: leftFlexBBI, _playBBI, rightFlexBBI, nil];
    self.pauseItems = [NSArray arrayWithObjects: leftFlexBBI, _pauseBBI, rightFlexBBI, nil];
    
    [_toolBar setItems:_playItems];
    
    [self.view addSubview:_toolBar];

    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(20, self.view.height - 20, self.view.width - 40., 20)];
    self.slider.continuous = YES;
    [self.slider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    _isPlaying = NO;
    
    // Color change in animation
    [NSTimer scheduledTimerWithTimeInterval: 6.0 target: self selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: YES];

    // Animation run loop
    CADisplayLink *dpLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [dpLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

-(void) sliderChanged {
    
    // pb with server, seekToTime not working with this server, work well with mine, based on an apache or an nginx
    if (!self.audioPlayer) {
        return;
    }
    
    NSLog(@"Slider Changed: %f", self.slider.value);
    
    [self.audioPlayer seekToTime:self.slider.value];
}

-(void) callAfterSixtySecond:(NSTimer*) t {
    [self.visualizer.emitterLayer setValue:(id)[self getRandomColor].CGColor forKeyPath:@"emitterCells.cell.color"];
}

- (UIColor *) getRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

- (void)playPause {
    if (_isPlaying) {
        // Pause audio here
        [_audioPlayer pause];
        [_toolBar setItems:_playItems];  // toggle play/pause button
    }
    else {
        // Play audio here
        [self.audioPlayer resume];
        [_toolBar setItems:_pauseItems]; // toggle play/pause button
    }
    _isPlaying = !_isPlaying;
}

- (void)configureAudioPlayer {
    NSError *error;
    
    NSLog(@"%@", self.fileURL);
    
    self.fileURL = [self.fileURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    self.audioPlayer = [[STKAudioPlayer alloc] initWithOptions:(STKAudioPlayerOptions){ .flushQueueOnSeek = YES, .enableVolumeMixer = NO, .equalizerBandFrequencies = {50, 100, 200, 400, 800, 1600, 2600, 16000} }];
    [self.audioPlayer playURL:[NSURL URLWithString:self.fileURL]];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    [_audioPlayer setMeteringEnabled:YES];
    _visualizer.audioPlayer = self.audioPlayer;
    [self playPause];
}

- (void)configureAudioSession {
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
    
    if (error) {
        NSLog(@"Error setting category: %@", [error description]);
    }
}

- (void)update {
    if (self.audioPlayer.duration != 0) {
        self.slider.minimumValue = 0;
        self.slider.maximumValue = self.audioPlayer.duration;
        self.slider.value = self.audioPlayer.progress;
    }
    
    float scale = 0.5;

    if (self.audioPlayer.state == STKAudioPlayerStatePlaying) {
        float power = 0.0f;
        power = [self.audioPlayer averagePowerInDecibelsForChannel:1];
        float level = self->meterTable.ValueAt(power);
        scale = level * 5;
    }
    [self.visualizer.emitterLayer setValue:@(scale) forKeyPath:@"emitterCells.cell.emitterCells.childCell.scale"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
