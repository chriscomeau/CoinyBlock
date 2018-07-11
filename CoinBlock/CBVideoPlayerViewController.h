//
//  CBVideoPlayerViewController.h
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "YTPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CBVideoPlayerViewController : UIViewController

@property (nonatomic) BOOL backToGame;

@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (strong, nonatomic) UIViewController *previousViewController;
@property (nonatomic) BOOL playbackDurationSet;

@end
