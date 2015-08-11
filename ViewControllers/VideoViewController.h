//
//  VideoViewController.h
//  mydistrikt
//
//  Created by fcdev on 09/12/2014.
//  Copyright (c) 2014 COULON Florian. All rights reserved.
//

#import "FCVideoPlayerView.h"

@interface VideoViewController : UIViewController <playerViewDelegate>
@property (strong, nonatomic) FCVideoPlayerView* player;
@property (nonatomic, strong) NSString *videoURL;
@property (nonatomic, strong) NSString *provider;
@end
