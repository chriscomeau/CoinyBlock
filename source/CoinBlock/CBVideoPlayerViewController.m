//
//  CBVideoPlayerViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBVideoPlayerViewController.h"
//#import "CBSkinCell.h"
#import "CBConfettiView.h"
@interface CBVideoPlayerViewController ()

@property (weak, nonatomic) IBOutlet UIButton *fullButtton;

@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
//@property (weak, nonatomic) IBOutlet UIImageView *skipImage;
//@property (weak, nonatomic) IBOutlet UIImageView *playImage;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (strong, nonatomic) NSMutableArray *imageArray1;
@property (nonatomic) int selectedSkin;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;

@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;
@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;
@property (strong, nonatomic) NSTimer *timerSwitch;

@property (nonatomic) int numFlash;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionFullButton:(id)sender;

@end


@implementation CBVideoPlayerViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    //corner

    [kAppDelegate cornerView:self.view];

    [UIView setAnimationsEnabled:NO];

    //dark
    self.darkImage.alpha = 0;


    [self setupConfetti];
    [self setupWhiteBar];

    //curtains
    self.curtainLeft.x = 0;
    self.curtainRight.x = self.curtainRight.width;

    //disable autolayout
    self.curtainLeft.translatesAutoresizingMaskIntoConstraints = YES;
    self.curtainRight.translatesAutoresizingMaskIntoConstraints = YES;


    //title text
    [self updateUI];

    //subscribe to resume updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeNotification:)
                                                 name:kResumeNotificationStore
                                               object:nil];



    //swipe
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    //[self.view addGestureRecognizer:gestureRecognizer]; //disabled



    //play
    //self.playLabel.font = [UIFont fontWithName:kFontVCR size:42];
    self.playLabel.textAlignment = NSTextAlignmentLeft;
    self.playLabel.textColor = [UIColor whiteColor];
    self.playLabel.hidden = NO;
    //shadow
    UIColor *shadowColor = kTextShadowColor;
    int shadowOffset = 2;
    self.playLabel.clipsToBounds = NO;
    self.playLabel.layer.shadowColor = shadowColor.CGColor;
    self.playLabel.layer.shadowOpacity = 0.6f;
    self.playLabel.layer.shadowRadius = 0.0f;
    self.playLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.playLabel.layer.masksToBounds = NO;

    [UIView setAnimationsEnabled:YES];

    //skins
    /*self.imageArray1 = [NSMutableArray array];
    NSArray *imageNames = @[@"block5Frame1", @"block5Frame2", @"block5Frame3", @"block5Frame4", @"block5Frame1",
                            @"block5Frame1", @"block5Frame1", @"block5Frame1", @"block5Frame1", @"block5Frame1"];

    self.imageArray1 = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [self.imageArray1 addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }*/


    //done
    /*[[NSNotificationCenter defaultCenter] postNotificationName:kLoadingDoneNotifications
     object:self
     userInfo:nil];*/
    [kAppDelegate doneNotification:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];

}

-(void)updateUI {
}

-(void) resumeNotification:(NSNotification*)notif {

    [self fadeOut];
}

-(void)viewDidLayoutSubviews {

}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    self.playLabel.hidden = NO;
    self.playLabel.alpha = 0.6f;
    //self.playLabel.text = @"PLAY";
    self.playLabel.text = [@[
                             @"PLAY",
                             @"FF",
                             @"SAP",
                             @"INPUT 1",
                             @"3",
                             @"4",
                             ] randomObject];

    [self setupFade];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    //update sublevel
    [kAppDelegate.gameScene updateLevelLabel:NO];

    //update time
    [kAppDelegate updateForegroundTime];


    [self enableButtons:YES];

    self.selectedSkin = (int)kAppDelegate.currentSkin;

    //state
    kAppDelegate.titleController.menuState = menuStateTransition;

    [kHelpers setupGoogleAnalyticsForView:[[self class] description]];

    [self fadeOut];

    //music
    //[kAppDelegate playMusic:kMusicNameOptions andRemember:YES];
    [kAppDelegate stopMusic];

    /*[self startConfetti];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopConfetti];
    });
    */

    [self updateUI];

    [self showWhiteBar];

    //video


    /*
    if(![kHelpers isWifi])
        return;

    self.playerView.delegate = self;

    [self.playerView setPlaybackRate:1.0f];


    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 @"autoplay" : @1,
                                 @"loop" : @1,
     };
    [self.playerView loadWithVideoId:@"8SFDXHel77E" playerVars:playerVars];


    //[self.playerView loadWithVideoId:@"dCs02CeiwP8"];

    //_6wFr2SHsmY : Epic Huge 80s Commercial Mix, looooong
    //dCs02CeiwP8 : 80's Commercials Vol. 283, short
    //8SFDXHel77E: Classic Toy Commercials From The 80's, 4m

    */

    /*
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"commercial1" ofType:@"mp4"];
    NSURL *movieURL = [[NSURL fileURLWithPath:moviePath] retain];

    theMoviPlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    theMoviPlayer.controlStyle = MPMovieControlStyleFullscreen;
    theMoviPlayer.view.transform = CGAffineTransformConcat(theMoviPlayer.view.transform, CGAffineTransformMakeRotation(M_PI_2));
    UIWindow *backgroundWindow = [[UIApplication sharedApplication] keyWindow];
    [theMoviPlayer.view setFrame:backgroundWindow.frame];
    [backgroundWindow addSubview:theMoviPlayer.view];
    [theMoviPlayer play];
     */


    self.playbackDurationSet = NO;

    [self removeVideoView];

//    NSBundle *bundle = [NSBundle mainBundle];
//    NSString *moviePath = [bundle pathForResource:@"commercial1" ofType:@"mp4"];

    NSFileManager *fileManager = [[NSFileManager alloc] init]; //[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *moviePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kCommercialName];
    if(![fileManager fileExistsAtPath:moviePath]) {
        return;
    }

    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];

    self.videoController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    CGRect videoFrame = self.view.frame;
    //videoFrame = CGRectInset(videoFrame, 10, 10);
    [self.videoController.view setFrame:videoFrame];
    self.videoController.view.userInteractionEnabled = NO;

    self.videoController.view.backgroundColor = [UIColor blackColor];

    [self.view addSubview:self.videoController.view];
    self.videoController.view.tag = kCommercialTag;

    [self.videoController stop];
    [kAppDelegate playSound:@"noiseLong.caf"];

    //volume
    self.videoController.useApplicationAudioSession = YES;


    //4:12 = 252
    int duration = 4*60+12;
    int skip = 10;
    int start = skip + arc4random_uniform(duration) - skip - kCommercialDuration; //from end

    //Classic Toy Commercials From The 80's
    //https://www.youtube.com/watch?v=8SFDXHel77E
    /*int start = [[@
                  [
                   @(10), //barbie
                   @(37), //he-man
                   @(70), //carebears
                   //@(96), //snail, keykeeper
                   @(127), //me and you
                   @(161), //rainbowbrite
                   @(187), //thundercats
                   @(217), //poney
                   ]
                  randomObject] intValue];*/

    NSLog(@"start: %d", start);

    self.videoController.initialPlaybackTime = start;
    //self.videoController.endPlaybackTime = self.videoController.initialPlaybackTime + kCommercialDuration;
    self.videoController.controlStyle = MPMovieControlStyleNone;
    self.videoController.scalingMode = MPMovieScalingModeAspectFill;
    self.videoController.allowsAirPlay = NO;
    self.videoController.fullscreen = NO;

    //self.videoController.volume = (kAppDelegate.musicVolume <= 0.0f);
    //self.videoController.shouldAutoplay = YES;

    //[self.videoController setCurrentPlaybackTime:start];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.videoController prepareToPlay];
        [self.videoController play];
    });
}


- (void)moviePlayerPlaybackStateChanged:(NSNotification*)notification
{
    MPMoviePlayerController* player = (MPMoviePlayerController*)notification.object;

    switch ( player.playbackState ) {
        case MPMoviePlaybackStatePlaying:

            if(!self.playbackDurationSet){
                [self.videoController setCurrentPlaybackTime:player.initialPlaybackTime];
                self.playbackDurationSet = YES;
            }

            [self bringSubviewsToFront];

            //volume
            //[[MPMusicPlayerController applicationMusicPlayer] setVolume:0.1f];

            break;

        default:
            break;
    }
}

-(void)removeVideoView {
    int tag = kCommercialTag;
    //remove existing

    UIView *removeView;
    while((removeView = [self.view viewWithTag:tag]) != nil) {
        [removeView removeFromSuperview];
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self bringSubviewsToFront];

    self.numFlash = 0;

    //give time to layout
//    float secs = 0.5f;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self resetTimer];
//    });

    //state
    kAppDelegate.launchInGame = NO;
    [kAppDelegate saveState];
}


- (void) actionTimerSwitch:(NSTimer *)incomingTimer {

    [self.timerSwitch invalidate];
    self.timerSwitch = nil;

    [self.videoController stop];
    [kAppDelegate playSound:@"noiseLong.caf"];

    [self enableButtons:NO];
    [self switchToPrevious];
}

-(void)switchToPrevious {

    self.playLabel.hidden = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeIn];

        float secs = kFadeDuration;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{


            //game
            if(kAppDelegate.videoController.previousViewController == kAppDelegate.gameController) {
                //force reset
                //kAppDelegate.gameController = nil;
                //kAppDelegate.gameController = [kStoryboard instantiateViewControllerWithIdentifier:@"game"];
            }

            [kAppDelegate setViewController:self.previousViewController];
        });

    });
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

//    [self.videoController stop];
//    [kAppDelegate playSound:@"noiseLong.caf"];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    [self stopConfetti];

    [self stopWhiteBar];


    //[self.shineImageView.layer removeAllAnimations];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self removeVideoView];

    [self.timerSwitch invalidate];
    self.timerSwitch = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

-(void)enableButtons:(BOOL)enable {
    self.fullButtton.enabled = enable;
}


- (void) actionFullButton:(id)sender {
    [self actionTimerSwitch:nil];
}

- (void) actionBack:(id)sender {

    //[kAppDelegate stopMusic];

    if(sender)
        [kAppDelegate playSound:kClickSound];

    [self enableButtons:NO];

    [self fadeIn];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

			[kAppDelegate setViewController:kAppDelegate.settingsController];

    });
}

-(void)setupFade {
	if(kAppDelegate.fadingWhite) {
		self.darkImage.image = [UIImage imageNamed:@"white"];
	}
	else {
		self.darkImage.image = [UIImage imageNamed:@"black"];
	}
}

-(void) bringSubviewsToFront{
    //top
    [self.view bringSubviewToFront:self.videoController.view];
    [self.view bringSubviewToFront:self.playLabel];

    [self.view bringSubviewToFront:self.curtainLeft];
    [self.view bringSubviewToFront:self.curtainRight];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.scanline];
    [self.view bringSubviewToFront:self.fullButtton];

}

-(void)fadeIn {

    [self setupFade];

    [self bringSubviewsToFront];

    //reset
    [self.darkImage.layer removeAllAnimations];

    self.darkImage.alpha = 0;
    [UIView animateWithDuration:kFadeDuration delay:kFadeDelay options:UIViewAnimationOptionCurveLinear animations:^{
        self.darkImage.alpha = 1.0f;
    } completion:nil];

    //curtains
    [self closeCurtains];
}

-(void)fadeOut {

    [self setupFade];

    [self bringSubviewsToFront];

    //reset
    [self.darkImage.layer removeAllAnimations];

    self.darkImage.alpha = 1.0f;
    [UIView animateWithDuration:kFadeDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.darkImage.alpha = 0;

        //reset fade white
        kAppDelegate.fadingWhite = NO;

    } completion:nil];


    //curtains
    [self openCurtains];

}

-(void)openCurtains {

    self.curtainLeft.hidden = YES;
    self.curtainRight.hidden = YES;

    //disabled
    return;

    //top
    [self.view bringSubviewToFront:self.curtainLeft];
    [self.view bringSubviewToFront:self.curtainRight];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.scanline];

    //reset
    self.curtainLeft.hidden = NO;
    self.curtainRight.hidden = NO;

    self.curtainLeft.x = 0;
    self.curtainRight.x = self.curtainRight.width;

    //force no anim?
    //[UIView beginAnimations:nil context:nil];

    CGRect screenRect = [kHelpers getScreenRect];

    [kAppDelegate playSound:kCurtain2Sound];

    [UIView animateWithDuration:kCurtainAnimDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{

        self.curtainLeft.x =-self.curtainLeft.width;
        self.curtainRight.x = screenRect.size.width;
    }
                     completion:^(BOOL finished){
                         self.curtainLeft.hidden = YES;
                         self.curtainRight.hidden = YES;
                     }];
}

-(void)closeCurtains {
    self.curtainLeft.hidden = YES;
    self.curtainRight.hidden = YES;

    //disabled
    return;

    CGRect screenRect = [kHelpers getScreenRect];

    //top
    [self.view bringSubviewToFront:self.curtainLeft];
    [self.view bringSubviewToFront:self.curtainRight];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.scanline];

    //reset
    self.curtainLeft.hidden = NO;
    self.curtainRight.hidden = NO;

    self.curtainLeft.x = -self.curtainLeft.width;
    self.curtainRight.x = screenRect.size.width;

    [kAppDelegate playSound:kCurtainSound];

    [UIView animateWithDuration:kCurtainAnimDuration delay:0.01f options:UIViewAnimationOptionCurveEaseIn animations:^{

        self.curtainLeft.x = 0;
        self.curtainRight.x = self.curtainRight.width;

    }
                     completion:^(BOOL finished){
                     }];

}


-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    Log(@"Swipe received.");

    [self actionBack:nil];

}

#pragma mark - Scroll

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollingFinish];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollingFinish];
}
- (void)scrollingFinish {
    //enter code here

}

#pragma mark - Actions

- (void)notifyForeground
{
    if(kAppDelegate.titleController.menuState != menuStateSettings)
        return;

    //only for iOS7
    //if(kIsIOS8)
    //    return;

    [self showWhiteBar];

}


- (void)notifyBackground
{
    //only for iOS7
    //if(kIsIOS8)
    //    return;
}


- (void)resetTimer{

    float interval = kCommercialDuration;
    self.timerSwitch = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerSwitch:) userInfo:@"actionTimerSwitch" repeats:NO];
}

-(void)setupConfetti {
    [self.confettiView setup:kConfettiBirthRateTitle];
    [self.confettiView stopEmitting:NO];
}

-(void)startConfetti {
    //disabled
    //return;

    [self.confettiView startEmitting:kConfettiBirthRateTitle];
}

-(void)stopConfetti {
    [self.confettiView stopEmitting:YES];
}

-(void)setupWhiteBar {
    //disabled
    //return;

    if(!kShowWhiteBar)
        return;

    self.whiteBar =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,50)];
    self.whiteBar.image=[UIImage imageNamed:@"whiteBar"];
    self.whiteBar.userInteractionEnabled = NO;
    self.whiteBar.alpha = kWhiteBarAlpha;
    [self.view addSubview:self.whiteBar];
}

-(void)showWhiteBar {

    //disabled
    //return;

    if(!kShowWhiteBar)
        return;

    CGRect screenRect = [kHelpers getScreenRect];

    CABasicAnimation *translate;
    translate = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translate.fromValue = [NSNumber numberWithFloat:kWhiteBarDistanceTop];

    int distance = screenRect.size.height;
    distance += kWhiteBarDistanceTop;
    distance += kWhiteBarDistanceExtra; //delay
    translate.toValue = [NSNumber numberWithFloat:distance];

    translate.duration = kWhiteBarDuration;
    translate.repeatCount = HUGE_VALF;
    [self.whiteBar.layer removeAllAnimations];

    self.whiteBar.hidden = YES;
    float secs = kWhiteBarDelayMin + (arc4random_uniform(kWhiteBarDelayMax * 1000)/1000.0f);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.whiteBar.hidden = NO;
        [self.whiteBar.layer addAnimation:translate forKey:@"10"];
    });

}

-(void)stopWhiteBar {
    [self.whiteBar.layer removeAllAnimations];
}

@end
