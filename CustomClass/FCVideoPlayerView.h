//
//  ViewController.m
//  mydistrikt
//
//  Created by fcdev on 09/12/2014.
//  Copyright (c) 2014 COULON Florian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class FCVideoPlayerView;

@protocol playerViewDelegate <NSObject>
@optional
-(void)playerViewZoomButtonClicked:(FCVideoPlayerView*)view;
-(void)playerFinishedPlayback:(FCVideoPlayerView*)view;

@end

@interface FCVideoPlayerView : UIView

@property (assign, nonatomic) id <playerViewDelegate> delegate;
@property (assign, nonatomic) BOOL isFullScreenMode;
@property (retain, nonatomic) NSURL *contentURL;
@property (retain, nonatomic) AVPlayer *moviePlayer;
@property (assign, nonatomic) BOOL isPlaying;

@property (retain, nonatomic) UIButton *playPauseButton;
@property (retain, nonatomic) UIButton *closeBut;
@property (retain, nonatomic) UIButton *volumeButton;
@property (retain, nonatomic) UIButton *zoomButton;
@property (retain, nonatomic) MPVolumeView *airplayButton;

@property (retain, nonatomic) UISlider *progressBar;
@property (retain, nonatomic) UISlider *volumeBar;

@property (retain, nonatomic) UILabel *playBackTime;
@property (retain, nonatomic) UILabel *playBackTotalTime;

@property (retain,nonatomic) UIView *playerHudCenter;
@property (retain,nonatomic) UIView *playerHudBottom;


- (id)initWithFrame:(CGRect)frame contentURL:(NSURL*)contentURL;
-(id)initWithFrame:(CGRect)frame playerItem:(AVPlayerItem*)playerItem;
-(void)play;
-(void)pause;
-(void) showHud:(BOOL)show;
-(void) setupConstraints;

@end
