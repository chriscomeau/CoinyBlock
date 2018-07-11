//
//  CBTransitionViewController.h
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface CBTransitionViewController : UIViewController

@property (nonatomic) BOOL backToGame;
@property (nonatomic) BOOL wait;
//@property (strong, nonatomic) MPMoviePlayerController *videoController;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (nonatomic) BOOL playbackDurationSet;

@end
