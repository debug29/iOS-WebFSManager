//
//  VisualizerView.h
//  SoundFi
//
//  Created by Florian Coulon on 20/07/15.
//  Copyright (c) 2015 Florian Coulon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <FrameAccessor.h>

@interface VisualizerView : UIView

@property (nonatomic) CAEmitterCell *cell;
@property (nonatomic) CAEmitterLayer *emitterLayer;
@property (nonatomic) AVAudioPlayer *audioPlayer;
- (void)update: (float)volumeter;
@end
