//
//  CBTransitionViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBTransitionViewController.h"
//#import "CBSkinCell.h"
#import "CBConfettiView.h"
#import "NSAttributedString+DDHTML.h"

@interface CBTransitionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readyLabel;
@property (weak, nonatomic) IBOutlet UILabel *worldLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullButtton;

@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (strong, nonatomic) NSMutableArray *imageArray1;
@property (nonatomic) int selectedSkin;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;

@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;
@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;
@property (strong, nonatomic) NSTimer *timerFlash;
@property (strong, nonatomic) NSTimer *timerSwitch;

@property (nonatomic) int numFlash;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionFullButton:(id)sender;

@end


@implementation CBTransitionViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    //corner

    [kAppDelegate scaleView:self.view];

    [kAppDelegate cornerView:self.view];

    [kHelpers loopInBackground];

    [UIView setAnimationsEnabled:NO];

    //dark
    self.darkImage.alpha = 0;


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

    [self setupConfetti];
    [self setupWhiteBar];

    //labels
    self.titleLabel.font = [UIFont fontWithName:kFontName size:32*kFontScale];
    self.titleLabel.textColor = kYellowTextColor;

    self.worldLabel.font = [UIFont fontWithName:kFontName size:18*kFontScale];
    self.worldLabel.textColor = kYellowTextColor;

    self.tipLabel.font = [UIFont fontWithName:kFontName size:20];
    self.tipLabel.textColor = kYellowTextColor;
    self.tipLabel.alpha = 0.4f;
    self.tipLabel.hidden = NO;

    self.readyLabel.font = [UIFont fontWithName:kFontName size:24*kFontScale];
    self.readyLabel.textColor = kYellowTextColor;

    //curtains
    CGRect screenRect = [kHelpers getScreenRect];
    self.curtainLeft.x = 0;
    self.curtainRight.x = screenRect.size.width-self.curtainRight.width;


    //disable autolayout
    self.curtainLeft.translatesAutoresizingMaskIntoConstraints = YES;
    self.curtainRight.translatesAutoresizingMaskIntoConstraints = YES;


    //shadow
    shadowOffset = 2;
    shadowColor = kTextShadowColor;

    self.titleLabel.shadowColor = shadowColor;
    self.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.readyLabel.shadowColor = shadowColor;
    self.readyLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.worldLabel.shadowColor = shadowColor;
    self.worldLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

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

    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
}

-(void)updateUI {

    int level = (int)kAppDelegate.level;
    int subLevel = (int)kAppDelegate.subLevel;

    //negative levels
    int levelTemp = level;
    BOOL negative = NO;
    if(level > kLevelMax)
    {
        //negative
        levelTemp = (level % kLevelMax);
        negative = YES;
    }
    if(negative)
	{
        //self.titleLabel.text = [NSString stringWithFormat:@"World  -%d", levelTemp];
        self.titleLabel.text = [NSString stringWithFormat:@"World Minus %d-%d", levelTemp, subLevel];
	}
    else
        self.titleLabel.text = [NSString stringWithFormat:@"World %d-%d", levelTemp, subLevel];


    self.readyLabel.text = [CBSkinManager getRandomReady];

    self.worldLabel.text = [CBSkinManager getRandomWorldName];
}

-(void) resumeNotification:(NSNotification*)notif {

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });

}

-(void)viewDidLayoutSubviews {

}

-(void) bringSubviewsToFront{
    //top
    //[self.view bringSubviewToFront:self.videoController.view];

    [self.view bringSubviewToFront:self.playLabel];
    [self.view bringSubviewToFront:self.titleLabel];
    [self.view bringSubviewToFront:self.readyLabel];
    [self.view bringSubviewToFront:self.worldLabel];

    [self.view bringSubviewToFront:self.curtainLeft];
    [self.view bringSubviewToFront:self.curtainRight];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.scanline];

    [self.view bringSubviewToFront:self.fullButtton];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    //tip
    self.tipLabel.text = [CBSkinManager getRandomTip];

    //color text
    NSString *tempString = [kHelpers colorString:self.tipLabel.text];
    NSAttributedString *attrString = [NSAttributedString attributedStringFromHTML:tempString
                                                                       normalFont:self.tipLabel.font
                                                                         boldFont:self.tipLabel.font
                                                                       italicFont:self.tipLabel.font];
    //center
    tempString = attrString.string;
    NSMutableAttributedString *attrString2 = [attrString mutableCopy];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attrString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempString length])];
    self.tipLabel.attributedText = attrString2;

    //long test
    //self.tipLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a dolor eu urna posuere commodo.";

    self.playLabel.hidden = YES; //NO
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


    //start hidden for timing
    self.readyLabel.hidden = YES;

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

    self.selectedSkin = (int)[kAppDelegate getSkin];

    //state
    kAppDelegate.titleController.menuState = menuStateTransition;

    [kHelpers setupGoogleAnalyticsForView:[[self class] description]];

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });


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


    self.playbackDurationSet = NO;

    [self removeVideoView];

#if 0

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

    self.view.backgroundColor = [UIColor blackColor];
    //self.view.backgroundColor = [UIColor blueColor];
    self.videoController.view.backgroundColor = self.view.backgroundColor;

    [self.view addSubview:self.videoController.view];
    self.videoController.view.tag = kCommercialTag;

#if 0
    [self.videoController stop];
    [kAppDelegate playSound:@"noiseLong.caf"];
#endif

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

    Log(@"start: %d", start);

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

#endif

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

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

    [self enableButtons:NO];
    [self switchToGame];
}

-(void)switchToTitle {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeIn];

        float secs = kFadeDuration;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            [kAppDelegate setViewController:kAppDelegate.titleController];
        });

    });
}

-(void)switchToGame {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeIn];

        float secs = kFadeDuration;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                [kAppDelegate setViewController:kAppDelegate.gameController];
        });

    });
}

- (void)viewWillDisappear:(BOOL)animated {

    self.wait = NO;

    [super viewWillDisappear:animated];

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

#if 0
    [self.videoController stop];
    [kAppDelegate playSound:@"noiseLong.caf"];

    [self removeVideoView];
#endif

    [self.timerFlash invalidate];
    self.timerFlash = nil;

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
    self.darkImage.alpha = 1.0f;

	if(kAppDelegate.fadingWhite) {
		self.darkImage.image = [UIImage imageNamed:@"white"];
	}
	else {
		self.darkImage.image = [UIImage imageNamed:@"black"];
	}
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

    self.curtainLeft.userInteractionEnabled = YES;
    self.curtainRight.userInteractionEnabled = YES;

    //disabled
    return;

  #if 0
    [self bringSubviewsToFront];

    //reset
    self.curtainLeft.hidden = NO;
    self.curtainRight.hidden = NO;

    self.curtainLeft.x = 0;
    self.curtainRight.x = screenRect.size.width-self.curtainRight.width;


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
    #endif
}

-(void)closeCurtains {
    //disabled
    return;

    CGRect screenRect = [kHelpers getScreenRect];

    [self bringSubviewsToFront];

    //reset
    self.curtainLeft.hidden = NO;
    self.curtainRight.hidden = NO;

    self.curtainLeft.x = -self.curtainLeft.width;
    self.curtainRight.x = screenRect.size.width;

    [kAppDelegate playSound:kCurtainSound];

    [UIView animateWithDuration:kCurtainAnimDuration delay:0.01f options:UIViewAnimationOptionCurveEaseIn animations:^{

        self.curtainLeft.x = 0;
        self.curtainRight.x = screenRect.size.width-self.curtainRight.width;


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

    [self.timerFlash invalidate];
    self.timerFlash = nil;

    float interval = kFlashArrowsInterval;
    self.timerFlash = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerFlash:) userInfo:@"actionTimerFlash" repeats:YES];

    if(!self.wait)
    {
        interval = 1.4f;
        self.timerSwitch = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerSwitch:) userInfo:@"actionTimerSwitch" repeats:NO];
    }
    else
    {
        interval = 30.0f;
        self.timerSwitch = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                          selector:@selector(actionTimerTitle:) userInfo:@"actionTimerTitle" repeats:NO];
    }

}


- (void) actionTimerTitle:(NSTimer *)incomingTimer
{
    [self switchToTitle];
}

- (void) actionTimerFlash:(NSTimer *)incomingTimer
{
    self.numFlash++;
    if(self.numFlash > 6 && !self.wait)
        return;

    self.readyLabel.hidden = !self.readyLabel.hidden;
}


-(void)setupConfetti {
    [self.confettiView setup:kConfettiBirthRateTitle];
    [self.confettiView stopEmitting:NO];
}

-(void)startConfetti {
    [self.confettiView startEmitting:kConfettiBirthRateTitle];
}

-(void)stopConfetti {
    [self.confettiView stopEmitting:YES];
}

-(void)setupWhiteBar {
    if(!kShowWhiteBar)
        return;

    CGRect screenRect = [kHelpers getScreenRect];

    self.whiteBar = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,screenRect.size.width,50)];
    self.whiteBar.image=[UIImage imageNamed:@"whiteBar"];
    self.whiteBar.userInteractionEnabled = NO;
    self.whiteBar.alpha = kWhiteBarAlpha;
    [self.view addSubview:self.whiteBar];

    //for ipad, stretch
    self.whiteBar.contentMode = UIViewContentModeScaleToFill;
}

-(void)showWhiteBar {
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

#if 0
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
#endif

-(void)removeVideoView {
    int tag = kCommercialTag;
    //remove existing

    UIView *removeView;
    while((removeView = [self.view viewWithTag:tag]) != nil) {
        [removeView removeFromSuperview];
    }

}
@end
