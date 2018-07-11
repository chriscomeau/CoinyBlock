//
//  CBStoryViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBStoryViewController.h"
#import "CBConfettiView.h"
//#import "NSAttributedString+DDHTML.h"

@interface CBStoryViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readyLabel;
@property (weak, nonatomic) IBOutlet UILabel *worldLabel;
@property (weak, nonatomic) IBOutlet ZCAnimatedLabel *worldLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullButtton;
@property (weak, nonatomic) IBOutlet UIImageView *coinsImage;
@property (weak, nonatomic) IBOutlet UIImageView *brainImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIImageView *overlay;
@property (strong, nonatomic) UIImageView *explosion;

@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (strong, nonatomic) NSMutableArray *imageArray1;
@property (nonatomic) int currentBg;
@property (nonatomic) BOOL firstTime;
@property (nonatomic) BOOL willDisappear;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;

@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;
@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;
@property (strong, nonatomic) NSTimer *timerFlash;
@property (strong, nonatomic) NSTimer *timerSwitch;
@property (strong, nonatomic) NSTimer *timerBg;
@property (strong, nonatomic) NSTimer *timerExplosion;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *readyBottomConstraint;


@property (strong, nonatomic) NSMutableArray *bgImages;

- (IBAction)actionFullButton:(id)sender;

@end


@implementation CBStoryViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.firstTime = YES;

    [kHelpers loopInBackground];

    [kAppDelegate scaleView:self.view];

    //corner
    [kAppDelegate cornerView:self.view];

    [UIView setAnimationsEnabled:NO];


    //explosion
    self.explosion = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"explosion1Frame1"]];
    self.explosion.image = nil;
    //self.explosion = [[UIImageView alloc] init];
    self.explosion.alpha = 0.0f;
    self.explosion.animationRepeatCount = 1;
    //[self.view addSubview:self.explosion];
    [self.view insertSubview:self.explosion aboveSubview:self.bgImage];

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

    self.worldLabel.font = [UIFont fontWithName:kFontName size:16*kFontScale];
    self.worldLabel.textColor = kYellowTextColor;
    self.worldLabel.numberOfLines = 0;

    self.worldLabel2.font = [UIFont fontWithName:kFontName size:16*kFontScale];
    self.worldLabel2.textColor = kYellowTextColor;

    self.tipLabel.font = [UIFont fontWithName:kFontName size:20];
    self.tipLabel.textColor = kYellowTextColor;
    self.tipLabel.alpha = 0.4f;
    self.tipLabel.hidden = NO;

    self.readyLabel.font = [UIFont fontWithName:kFontName size:16*kFontScale];
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


    [UIView setAnimationsEnabled:YES];

    [kAppDelegate doneNotification:nil];
}

-(void)updateUI {

    self.titleLabel.text = @""; //[NSString stringWithFormat:@"World %d-%d", level, subLevel];

	//mario 3, 1998
	//snes, 1990
	//megaman2 intro https://www.youtube.com/watch?v=auQv90TfXrI

	if(self.toTransition)
	{
		//based on level
        if(kAppDelegate.level == kStoryLevel1)
            self.worldLabel.text = LOCALIZED(@"kStringStory2");
        else if(kAppDelegate.level == kStoryLevel2)
            self.worldLabel.text = LOCALIZED(@"kStringStory3");
	}
	else
	{
		self.worldLabel.text = LOCALIZED(@"kStringStory1");
	}

    self.worldLabel2.text = self.worldLabel.text;

    self.worldLabel.hidden = YES;
    self.worldLabel2.hidden = NO;

    // a mysterious wizard known as agahim to came
    //through evil magic

   // self.readyLabel.text = @"Press Start"; //@"Let's go!"; //@"Skip"; //[CBSkinManager getRandomReady];
    self.readyLabel.text = [CBSkinManager getRandomReady];

}

-(void) resumeNotification:(NSNotification*)notif {

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });

}

-(void)viewDidLayoutSubviews {

    if([kHelpers isIpad])
    {
        self.textTopConstraint.constant = 190;
        self.readyBottomConstraint.constant = 20;
    }
    else if([kHelpers isIphone4Size])
    {
        self.textTopConstraint.constant = 210;
        self.readyBottomConstraint.constant = 4;
    }
    else if ([kHelpers isIphoneX])
    {
        self.textTopConstraint.constant = 278;
        self.readyBottomConstraint.constant = 49;
    }
    else
    {
        self.textTopConstraint.constant = 228;
        self.readyBottomConstraint.constant = 29;
    }
}

-(void) bringSubviewsToFront{
    //top

    [self.view bringSubviewToFront:self.playLabel];
    [self.view bringSubviewToFront:self.titleLabel];
    [self.view bringSubviewToFront:self.readyLabel];
    [self.view bringSubviewToFront:self.worldLabel];
    //[self.view bringSubviewToFront:self.explosion];

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

    self.willDisappear = NO;

    self.overlay.alpha = 1.0f; //0.8f;

    //tip
    self.tipLabel.text = [CBSkinManager getRandomTip];
    //long test
    //self.tipLabel.text = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a dolor eu urna posuere commodo.";

    self.playLabel.hidden = YES; //NO

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


    [self enableButtons:NO];


    //state
    kAppDelegate.titleController.menuState = menuStateStory;

    [kHelpers setupGoogleAnalyticsForView:[[self class] description]];

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });


    //music
    //[kAppDelegate playMusic:kMusicNameOptions andRemember:YES];
    [kAppDelegate playMusic:@"intro1.mp3" andRemember:YES];

    /*[self startConfetti];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopConfetti];
    });
    */

    [self updateUI];

    [self showWhiteBar];

    [self showCoins];
    [self startShake];

    self.playbackDurationSet = NO;


    //bg animate
    self.bgImages = [NSMutableArray array];
    NSMutableArray *names = [NSMutableArray array];

//    for(int i = 1; i<=kNumBackgrounds; i++)
//    {
//        NSString *bgName = [NSString stringWithFormat:@"background%d", i];
//        [names addObject:bgName];
//    }
//
//    //remove
//    [names removeObject:@"background10"];
//    [names removeObject:@"background31"];
//    [names removeObject:@"background32"];
//    [names removeObject:@"background35"];
//    [names removeObject:@"background36"];
//    [names removeObject:@"background37"];
//    [names removeObject:@"background19"];
//    [names removeObject:@"background23"];
//    [names removeObject:@"background30"];

    //add manually
    [names addObject:@"background1"]; //default
    [names addObject:@"background2"]; //field, zelda
    [names addObject:@"background3"]; //water
    [names addObject:@"background27"]; //beach
    [names addObject:@"background9"]; //sunset
    [names addObject:@"background6"]; //city sky
    [names addObject:@"background12"]; //green trees
    [names addObject:@"background16"]; //san fran, orange beige
    [names addObject:@"background18"]; //rainbow
    [names addObject:@"background36"]; //underwater green/pink
    [names addObject:@"background37"]; //snow sunset

    for(NSString *bgName in names)
    {
        UIImage *image = [UIImage imageNamed:bgName];
        [self.bgImages addObject:image];
    }

    self.currentBg = 0;
    self.bgImage.image = [self.bgImages objectAtIndex:0];
    /*
    self.bgImage.animationImages = self.bgImages;
    self.bgImage.animationDuration = (self.bgImages.count * 1.0f);
    [self.bgImage startAnimating];
    self.currentBg = 0;
     */

    /*
     [UIView transitionWithView:textFieldimageView
     duration:0.2f
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^{
     imageView.image = newImage;
     } completion:nil];

     */

    self.readyLabel.alpha = 0.0f;
    self.worldLabel.alpha = 0.0f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //give time to layout
//    float secs = 0.5f;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      //  [self resetTimer];
//    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //animate label
        NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        style.lineSpacing = 5;
        style.alignment = NSTextAlignmentCenter;
        NSDictionary *attrsDictionary = @{NSFontAttributeName : self.worldLabel2.font, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : [UIColor whiteColor]};
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.worldLabel2.text attributes:attrsDictionary];
        [self.worldLabel2 setAttributedString:attrString];

        self.worldLabel2.animationDuration = 0.5f;
        self.worldLabel2.animationDelay = 0.04f;
        [self.worldLabel2 startAppearAnimation];

        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.worldLabel.alpha = 1.0f;
            self.readyLabel.alpha = 1.0f;
        } completion:nil];
    });

    int chatCount = 0;

    if(self.toTransition)
    {
        //based on level
        if(kAppDelegate.level == kStoryLevel1)
            chatCount = 4;
        else if(kAppDelegate.level == kStoryLevel2)
            chatCount = 4;
    }
    else
    {
        chatCount = 5;
    }


    CGFloat secsChat = 0.3f;
    for(int i=0; i<chatCount; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secsChat * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            if(!self.willDisappear)
                [kAppDelegate playSound:@"alertchat.caf"];
        });

        secsChat += 1.0f;
    }


    //state
    kAppDelegate.playedWelcomeAlert = YES;
    [kAppDelegate saveState];

    [self enableButtons:YES];

    [self resetTimerExplosion];

    float secs = self.firstTime ? 1.5f : 0.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        if(kAppDelegate.titleController.menuState != menuStateStory)
            return;

        if(self.willDisappear)
            return;

        [self resetTimer];
        //[self enableButtons:YES];
    });

    self.firstTime = NO;
}




- (void) actionTimerExplosion:(NSTimer *)incomingTimer {

    //Log(@"actionTimerExplosion");

    CGFloat width = 100.0f; //64.0f
    CGFloat padding = 10;
    CGRect screenRect = [kHelpers getScreenRect];

    CGFloat explosionX = padding + (arc4random_uniform(screenRect.size.width - width - padding*2));
    CGFloat explosionY = 160.0f;

    if([kHelpers isIpad])
    {
        explosionY = 110.0f;
    }

    self.explosion.frame = CGRectMake(explosionX,explosionY,width,width);
    self.explosion.alpha = 0.5f;

    NSArray *animationFrames = nil;

    //if([kHelpers randomBool])
    if(YES)
    {
        //regular
        animationFrames = [NSArray arrayWithObjects:
                                [UIImage imageNamed:@"explosion1Frame1"],
                                [UIImage imageNamed:@"explosion1Frame2"],
                                [UIImage imageNamed:@"explosion1Frame3"],
                                [UIImage imageNamed:@"explosion1Frame4"],
                                [UIImage imageNamed:@"explosion1Frame5"],
                                [UIImage imageNamed:@"explosion1Frame6"],
                                [UIImage imageNamed:@"explosion1Frame7"],
                                [UIImage imageNamed:@"explosion1Frame8"],
                                [UIImage imageNamed:@"explosion1Frame9"],
                                nil];
    }
    else
    {
        //gray
        animationFrames = [NSArray arrayWithObjects:
                           [kHelpers getGrayImage:[UIImage imageNamed:@"explosion1Frame1"]],
                           [kHelpers getGrayImage:[UIImage imageNamed:@"explosion1Frame2"]],
                           [kHelpers getGrayImage:[UIImage imageNamed:@"explosion1Frame3"]],
                           [kHelpers getGrayImage:[UIImage imageNamed:@"explosion1Frame4"]],
                           [kHelpers getGrayImage:[UIImage imageNamed:@"explosion1Frame5"]],
                           [kHelpers getGrayImage:[UIImage imageNamed:@"explosion1Frame6"]],
                           [kHelpers getGrayImage:[UIImage imageNamed:@"explosion1Frame7"]],
                           [kHelpers getGrayImage:[UIImage imageNamed:@"explosion1Frame8"]],
                           [kHelpers getGrayImage:[UIImage imageNamed:@"explosion1Frame9"]],
                           nil];
    }

    self.explosion.animationImages = animationFrames;
    self.explosion.animationDuration = 0.1f * animationFrames.count;
    [self.explosion startAnimating];
}

- (void) actionTimerBg:(NSTimer *)incomingTimer {

    //Log(@"actionTimerBg");

    [UIView transitionWithView:self.bgImage
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.bgImage.image = [self.bgImages objectAtIndex:self.currentBg];
                    } completion:nil];

    self.currentBg++;
    if(self.currentBg >= self.bgImages.count)
    {
        self.currentBg = 0;
    }
}

- (void) actionTimerSwitch:(NSTimer *)incomingTimer {

    [self.timerSwitch invalidate];
    self.timerSwitch = nil;

    [self enableButtons:NO];


	if(self.toTransition)
	{
		[self switchToTransition];
	}
	else
        [self switchToTitle];

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

-(void)switchToTransition {

	//reset
	self.toTransition = NO;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeIn];

        float secs = kFadeDuration;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
             [kAppDelegate setViewController:kAppDelegate.transitionController];
        });
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    self.willDisappear = YES;
    //[kAppDelegate stopAllAudio];
    [kAppDelegate stopSound:@"alertchat.caf"];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    [self stopConfetti];
    [self stopCoins];
    [self stopShake];
    [self stopWhiteBar];

    //timers
    [self.timerFlash invalidate];
    self.timerFlash = nil;

    [self.timerSwitch invalidate];
    self.timerSwitch = nil;

    [self.timerBg invalidate];
    self.timerBg = nil;

    [self.timerExplosion invalidate];
    self.timerExplosion = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];


    //cleanup
    [self.bgImage.layer removeAllAnimations];
    [self.bgImages removeAllObjects];
    self.bgImages = nil;

    [self.worldLabel2 startDisappearAnimation];

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
    //[kAppDelegate playSound:kClickSound];

    [self actionTimerSwitch:nil];
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

  #if 0
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
  #endif
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
    if(kAppDelegate.titleController.menuState != menuStateStory)
        return;

    //only for iOS7
    //if(kIsIOS8)
    //    return;

    [self showWhiteBar];
    [self showCoins];
}

- (void)notifyBackground
{
    //only for iOS7
    //if(kIsIOS8)
    //    return;
}


- (void)resetTimer {

    [self.timerFlash invalidate];
    self.timerFlash = nil;

    float interval = kFlashArrowsInterval;

    self.timerFlash = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerFlash:) userInfo:@"actionTimerFlash" repeats:YES];

    interval = self.firstTime ? 30.0f : 16.0f;
    self.timerSwitch = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerSwitch:) userInfo:@"actionTimerSwitch" repeats:NO];

    interval = 1.5f;
    self.currentBg = 1; //force second one
    self.timerBg = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                      selector:@selector(actionTimerBg:) userInfo:@"actionTimerBg" repeats:YES];

}

-(void)resetTimerExplosion
{
    CGFloat interval = 1.2f;
    self.timerExplosion = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                         selector:@selector(actionTimerExplosion:) userInfo:@"actionTimerExplosion" repeats:YES];
    //now
    [self actionTimerExplosion:nil];
}


- (void) actionTimerFlash:(NSTimer *)incomingTimer
{
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


-(void)startShake
{
    //move first

    if([kHelpers isIpad])
    {
        self.brainImage.y = 68;
    }
    else
    {
        self.brainImage.y = 88;
    }


    float distance = -3.0f;
    CGPoint origin = self.brainImage.center;

    CGPoint target = CGPointMake(self.brainImage.center.x, self.brainImage.center.y+distance);
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.y"];
    bounce.duration = 0.5f;
    bounce.fromValue = [NSNumber numberWithInt:origin.y];
    bounce.toValue = [NSNumber numberWithInt:target.y];
    bounce.repeatCount = HUGE_VALF;
    bounce.autoreverses = YES;
    [self.brainImage.layer removeAllAnimations];
    [self.brainImage.layer addAnimation:bounce forKey:@"position"];
}

-(void)stopShake
{
    [self.brainImage.layer removeAllAnimations];
}

-(void)showCoins {

    //coins
    CABasicAnimation *translate;
    translate = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translate.fromValue = [NSNumber numberWithFloat:0];

    int distance = -2000;
    translate.toValue = [NSNumber numberWithFloat:distance];

    translate.duration = 60; //100;
    translate.repeatCount = 0;
    [self.coinsImage.layer removeAllAnimations];

    self.coinsImage.y = 0;

    self.coinsImage.hidden = NO;

	//alpha based on story?

	if(kAppDelegate.level == kStoryLevel1)
	{
		self.coinsImage.alpha = 0.8f;
	}
	else if(kAppDelegate.level == kStoryLevel2)
	{
		self.coinsImage.alpha = 0.5f;
	}
	else
	{
		self.coinsImage.alpha = 1.0f;
	}

    [self.coinsImage.layer addAnimation:translate forKey:@"10"];
}

-(void)stopCoins {
    [self.coinsImage.layer removeAllAnimations];
}

@end
