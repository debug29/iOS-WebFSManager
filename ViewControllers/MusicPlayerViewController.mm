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
    AVAsset *asset;
    
    NSURL *URL = [NSURL URLWithString:[self.fileURL stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    asset = [AVURLAsset URLAssetWithURL:URL options:nil];

    NSUInteger dTotalSeconds = CMTimeGetSeconds([asset duration]);
    
    NSUInteger dHours = floor(dTotalSeconds / 3600);
    NSUInteger dMinutes = floor(dTotalSeconds % 3600 / 60);
    NSUInteger dSeconds = floor(dTotalSeconds % 3600 % 60);
    
    NSString *videoDurationText = [NSString stringWithFormat:@"%i:%02i:%02i",dHours, dMinutes, dSeconds];
    NSLog(@"%@", videoDurationText);
    for (AVMetadataItem *metadataItem in asset.commonMetadata) {
        
        NSLog(@"%@ : %@", metadataItem.commonKey, metadataItem.stringValue);
        
        if ([metadataItem.commonKey isEqualToString:@"artwork"]){
     
        }
    }
    

}

- (void)viewWillDisappear:(BOOL)animated {
    [self.audioPlayer stop];
}

- (void)viewDidAppear:(BOOL)animated {
    [self configureAudioPlayer];
    [self toggleBars];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureAudioSession];
    self.title = @"Music Player";
    self.view.backgroundColor = [UIColor blackColor];
    
    self.visualizer = [[VisualizerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.visualizer.alpha = 0.4;
    [self.visualizer.emitterLayer setValue:(id)[self getRandomColor].CGColor forKeyPath:@"emitterCells.cell.color"];
    [self.view addSubview:_visualizer];
    
    
    // ToolBar
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 94)];
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

    _isBarHide = YES;
    _isPlaying = NO;
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandler:)];
    [self.view addGestureRecognizer:tapGR];
    
    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 6.0 target: self selector: @selector(callAfterSixtySecond:) userInfo: nil repeats: YES];
    
    CADisplayLink *dpLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [dpLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
    // Do any additional setup after loading the view.
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

- (void)playURL:(NSURL *)url {
    if (_isPlaying) {
        [self playPause]; // Pause the previous audio player
    }
    
    // Add audioPlayer configurations here
    [_audioPlayer setMeteringEnabled:YES];
    _visualizer.audioPlayer = self.audioPlayer;
    [self playPause];   // Play
}


- (void)toggleBars {
    CGFloat toolBarDis = 94;
    if (_isBarHide ) {
        toolBarDis = -toolBarDis;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGPoint toolBarCenter = _toolBar.center;
        toolBarCenter.y += toolBarDis;
        [_toolBar setCenter:toolBarCenter];
    }];
    
    _isBarHide = !_isBarHide;
}

- (void)update {
    //1
    float scale = 0.5;

    if (self.audioPlayer.state == STKAudioPlayerStatePlaying) {
        //2
//        [_audioPlayer updateMeters];
        //3
        float power = 0.0f;
        power = [self.audioPlayer averagePowerInDecibelsForChannel:1];
        //4
        float level = self->meterTable.ValueAt(power);
        scale = level * 5;
    }
    //5
    [self.visualizer.emitterLayer setValue:@(scale) forKeyPath:@"emitterCells.cell.emitterCells.childCell.scale"];
}


- (void)tapGestureHandler:(UITapGestureRecognizer *)tapGR {
    [self toggleBars];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
