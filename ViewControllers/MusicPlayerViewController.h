//
//  MusicPlayerViewController.h
//  WebFS Manager
//
//  Created by Florian Coulon on 10/08/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "STKAudioPlayer.h"
#import "VisualizerView.h"

@interface MusicPlayerViewController : UIViewController {
    BOOL _isBarHide;
    BOOL _isPlaying;
}

@property (nonatomic) UIToolbar *toolBar;
@property (nonatomic) NSArray *playItems;
@property (nonatomic) NSArray *pauseItems;
@property (nonatomic) UIBarButtonItem *playBBI;
@property (nonatomic) UIBarButtonItem *pauseBBI;
@property (nonatomic) NSString *fileURL;
// Add properties here
@property (readwrite, retain) STKAudioPlayer* audioPlayer;
@property (nonatomic) VisualizerView *visualizer;


@end
