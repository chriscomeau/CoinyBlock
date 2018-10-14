//
//  CBGameViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-08-30.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBGameViewController.h"
#import "CBGameScene.h"
#import "UIButton+BadgeValue.h"
#import "UIResponder+MotionRecognizers.h"
#import "UIView+Snapshot.h"
#import "CBConfettiView.h"
#import "UIView+Screenshot.h"
#if kKTPlayEnabled
#import "KTPlay.h"
#endif

@interface CBGameViewController ()
@property (strong, nonatomic) SKView *skView;

@property (weak, nonatomic) IBOutlet UILabel *labelTopTime;
@property (weak, nonatomic) IBOutlet UILabel *labelTopLife;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;
@property (weak, nonatomic) IBOutlet UIButton *buttonTime;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UIButton *plusEnergyButton;
@property (weak, nonatomic) IBOutlet UIButton *plusEnergyButton2;
@property (weak, nonatomic) IBOutlet UIButton *doublerButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (weak, nonatomic) IBOutlet UIImageView *flashImage;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton2;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton2;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *curtainLeftXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *curtainRightXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *curtainLeftWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *curtainRightWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerBottom;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;
@property (nonatomic, strong) IBOutlet UIImageView *vcr;
@property (nonatomic, strong) IBOutlet UIImageView *blurImageView;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;
@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;
@property (strong, nonatomic) NSDate *dateActive;
@property (nonatomic) BOOL skipFade;
@property (weak, nonatomic) IBOutlet UIButton *hashtag;
@property (strong, nonatomic) NSTimer *timerSave;
@property (strong, nonatomic) NSTimer *timerWobble;
@property (strong, nonatomic) NSTimer *timerScroll;
@property (strong, nonatomic) NSTimer *timerPause;
@property (strong, nonatomic) NSTimer *timerVCR;
//@property (weak, nonatomic) IBOutlet MarqueeLabel *labelScroll;
@property (weak, nonatomic) IBOutlet UILabel *labelScroll;
@property (nonatomic) BOOL didAppear;

//@property (strong, nonatomic) CAEmitterLayer *mortor;

- (IBAction)actionSettings:(id)sender;
- (IBAction)actionBack:(id)sender;
- (IBAction)actionTime:(id)sender;
- (IBAction)actionMenu:(id)sender;
- (IBAction)actionProfile:(id)sender;
- (IBAction)actionCloseAd:(id)sender;
- (IBAction)actionPlusEnergy:(id)sender;
- (IBAction)actionInfo:(id)sender;
- (IBAction)actionDoubler:(id)sender;
- (IBAction)actionHashtag:(id)sender;

@end


@implementation CBGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupFade];
    [self bringSubviewsToFront];

    [kAppDelegate scaleView:self.view];

    //unscale banner
    if([kHelpers isIpad])
    {
       //banner.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1/kiPadScaleX, 1/kiPadScaleY);
    }

    [kHelpers loopInBackground];

    //gif
    /*self.imageView1 = [[FLAnimatedImageView alloc] init];
    self.imageView1.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView1.clipsToBounds = YES;
    NSURL *url1 = [[NSBundle mainBundle] URLForResource:@"rock" withExtension:@"gif"];
    NSData *data1 = [NSData dataWithContentsOfURL:url1];
    FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
    self.imageView1.animatedImage = animatedImage1;
    */

    //corner
    [kAppDelegate cornerView:self.view];

    //preload
    //UIImage *tempImage = [kAppDelegate.gameScene getScreenshot];
    //UIImage *tempImage = [UIImage imageNamed:@"background10"];
    //tempImage = [kHelpers getBlurredImage:tempImage];

    //dark
    self.darkImage.alpha = 0;
    self.darkAdImage.alpha = 1;
    self.darkVisible = YES;
    self.blurImageView.alpha = 0.0f;
    self.blurImageView.hidden = YES;
    //self.blurImageView.contentMode = UIViewContentModeCenter;

    //flash
    self.flashImage.image = nil;

    [self setupConfetti];
    [self setupWhiteBar];

    if(kVCRAnimEnabled)
    //if(NO)
        {
        self.vcr.animationImages = @[[UIImage imageNamed:@"vcr"], [UIImage imageNamed:@"vcr2"]];
        self.vcr.animationDuration = kVCRAnimDuration;
        self.vcr.animationRepeatCount = 0;
    }

    //kAppDelegate.gameController = self;

    //shake
    [self addMotionRecognizerWithAction:@selector(shakeWasRecognized:)];

    // Configure the view.
    //SKView * skView = (SKView *)self.view;
    if([kHelpers isIphoneX])
    {
        CGRect frame = self.view.bounds;
        frame.size.width /= kiPhoneXScaleX;
        frame.size.height /= kiPhoneXScaleX;

        self.skView = [[SKView alloc] initWithFrame:frame];
    }
    else if([kHelpers isIpad])
    {
        CGRect frame = self.view.bounds;
        frame.size.width /= kiPadScaleX;
        frame.size.height /= kiPadScaleX;

        self.skView = [[SKView alloc] initWithFrame:frame];
    }
    else
    {
        self.skView = [[SKView alloc] initWithFrame:self.view.bounds];
    }

    [self.view addSubview:self.skView];
    [self.view sendSubviewToBack:self.skView];

    //sibling optimize, need to fix zposition of fires to fix
    //self.skView.ignoresSiblingOrder = YES;

    //limit framerate / fps
    //http://stackoverflow.com/questions/23840355/setting-the-frames-per-second-to-30-when-running-a-sprite-kit-project-on-a-devic

    //self.skView.frameInterval = 2; //30 fps
    self.skView.preferredFramesPerSecond = 60;

    // Create and configure the scene.
    CGRect tempRect = self.skView.bounds;
    tempRect = self.skView.frame;

    if(kAppDelegate.gameScene) {
        //kAppDelegate.gameScene = kAppDelegate.gameScene;
    }
    else {
        if([kHelpers isIphoneX])
        {
            kAppDelegate.gameScene = [CBGameScene sceneWithSize:self.skView.bounds.size];
            kAppDelegate.gameScene.scaleMode = SKSceneScaleModeAspectFill; //SKSceneScaleModeFill;

        }
        else
        {
            kAppDelegate.gameScene = [CBGameScene sceneWithSize:self.skView.bounds.size];
            kAppDelegate.gameScene.scaleMode = SKSceneScaleModeAspectFill;

        }

    }

    //set

    // Present the scene.
    kAppDelegate.gameScene.view.userInteractionEnabled = YES;
    [self.skView presentScene:kAppDelegate.gameScene];

    //profile
    self.profileButton.layer.borderColor=  [UIColor whiteColor].CGColor;
    self.profileButton.layer.cornerRadius = self.profileButton.width/2;
    self.profileButton.layer.borderWidth= 1.0f;
    [self.profileButton.layer setMasksToBounds:YES];
    self.profileButton.clipsToBounds = YES;

    [self.profileButton setImage:nil forState:UIControlStateNormal];
    [self.profileButton setBackgroundImage:nil forState:UIControlStateNormal];

    //[self.profileButton setImage:[UIImage imageNam    ed:@"profile_placeholder"] forState:UIControlStateNormal];
    [self.profileButton setBackgroundImage:[UIImage imageNamed:@"profile_placeholder"] forState:UIControlStateNormal];

    //hide
    self.profileButton.hidden = YES;


    //scroll/quote
    //int shadowOffset = 1;
    /*UIColor *shadowColor = RGBA(0.0f,0.0f,0.0f, 0.5f); //kTextShadowColor;
    //self.labelScroll.font = [UIFont fontWithName:kFontName size:12*kFontScale];
    self.labelScroll.font = [UIFont fontWithName:@"OrangeKid-Regular" size:20];
    self.labelScroll.textColor = RGB(255,255,255); //white
    //self.labelScroll.textColor = kGreenTextColor; //green
    //self.labelScroll.backgroundColor = [UIColor blueColor];
    self.labelScroll.shadowColor = shadowColor;
    self.labelScroll.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.labelScroll.alpha = 0.9f;
    //self.labelScroll.lineBreakMode = NSLineBreakByWordWrapping;
    //self.labelScroll.numberOfLines = 1;
    self.labelScroll.text = @"";
    self.labelScroll.userInteractionEnabled = NO;
    //marquee
    self.labelScroll.fadeLength = 10.0f;
    self.labelScroll.rate = 40.0f;
    self.labelScroll.marqueeType = MLContinuous;*/
    self.labelScroll.hidden = YES;

    //time
    self.labelTime.hidden = self.buttonTime.hidden = NO;
    self.labelTime.font = [UIFont fontWithName:kFontName size:15*kFontScale];
    int shadowOffset = 1;
    UIColor *shadowColor = [[UIColor colorWithHex:0x655419] colorWithAlphaComponent:0.9f]; //kTextShadowColor;
    //self.labelTime.shadowColor = shadowColor;
    //self.labelTime.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    //disabled
    self.labelTime.text = @"";
    self.labelTime.hidden = YES;
    [self updateTimeLabel:NO];

    //top labels
    self.labelTopLife.hidden = YES; //disabled
    self.labelTopLife.font = [UIFont fontWithName:kFontName size:10*kFontScale];
    shadowOffset = 1;
    shadowColor = [[UIColor colorWithHex:0x655419] colorWithAlphaComponent:0.9f]; //kTextShadowColor;
    self.labelTopLife.shadowColor = shadowColor;
    self.labelTopLife.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.labelTopLife.alpha = 0.6f;

    self.labelTopTime.hidden = YES; //disabled
    self.labelTopTime.font = [UIFont fontWithName:kFontName size:10*kFontScale];
    shadowOffset = 1;
    shadowColor = [[UIColor colorWithHex:0x655419] colorWithAlphaComponent:0.9f]; //kTextShadowColor;
    self.labelTopTime.shadowColor = shadowColor;
    self.labelTopTime.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.labelTopTime.alpha = 0.6f;


    //red
    self.flashImage.alpha = 0.0f;
    self.flashImage.hidden = NO;

    //curtains
    self.curtainLeft.alpha = 1.0f;
    self.curtainRight.alpha = 1.0f;
    self.curtainLeft.hidden = YES;
    self.curtainRight.hidden = YES;
    self.curtainLeft.userInteractionEnabled = YES;
    self.curtainRight.userInteractionEnabled = YES;

    //curtains
    //self.curtainLeft.x = 0;
    //    self.curtainRight.x = screenRect.size.width-self.curtainRight.width;

    //disable autolayout
    //self.curtainLeft.translatesAutoresizingMaskIntoConstraints = YES;
    //self.curtainRight.translatesAutoresizingMaskIntoConstraints = YES;

    //banner
#if kBannerEnabled
    //self.bannerView.delegate = self;
#endif
	[self hideBanner];

    //close
    //bigger
    int buttonResize = 5;
    [self.closeAdButton setHitTestEdgeInsets:UIEdgeInsetsMake(-buttonResize, -buttonResize, -buttonResize, -buttonResize)];
    //[self.closeAdButton2 setHitTestEdgeInsets:UIEdgeInsetsMake(-buttonResize, -buttonResize, -buttonResize, -buttonResize)];

    [self.backButton setHitTestEdgeInsets:UIEdgeInsetsMake(-buttonResize, -buttonResize, -buttonResize, -buttonResize)];
    [self.backButton2 setHitTestEdgeInsets:UIEdgeInsetsMake(-buttonResize, -buttonResize, -buttonResize, -buttonResize)];

    //order
    [self.view bringSubviewToFront:self.adSpinner];
    [self.view bringSubviewToFront:self.bannerView];
    [self.view bringSubviewToFront:self.closeAdButton];
    [self.view bringSubviewToFront:self.closeAdButton2];

    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.profileButton];


    [self.view bringSubviewToFront:self.confettiView];

    [self bringSubviewsToFront];

    //disable scanline
    //self.scanline.hidden = YES;

    self.adSpinner.color = RGB(248,216,0);

    //[kHelpers showMessageHud:@"Loading..."];

    //fireworks
    //[self setupFireworks];

    //gamecenter
    //[[GameCenterManager sharedManager] setDelegate:self];


    //swipe
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    //[self.view addGestureRecognizer:gestureRecognizer]; //disabled


    //hashtag
    [self.hashtag setTitle:@"#coinblock" forState:UIControlStateNormal];
    [self.hashtag.titleLabel setFont:[UIFont fontWithName:@"OrangeKid-Regular" size:22] ];
    [self.hashtag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.hashtag.alpha = 0.3f;
    self.hashtag.hidden = YES;

    //done
    /*[[NSNotificationCenter defaultCenter] postNotificationName:kLoadingDoneNotifications
     object:self
     userInfo:nil];*/
    [kAppDelegate doneNotification:nil];

}

-(void)setupConfetti {
    [self.confettiView setup:kConfettiBirthRateGame];
    [self.confettiView stopEmitting:NO];
}

-(void)startConfetti {
    [self.confettiView startEmitting:kConfettiBirthRateGame];
}

-(void)startConfetti2 {
    [self.confettiView startEmitting:kConfettiBirthRateTitle];
}

-(void)stopConfetti {
    [self.confettiView stopEmitting:YES];
}

-(void) resumeNotification:(NSNotification*)notif {

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
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

    self.darkVisible = YES;

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

    if(self.skipFade) {
        self.skipFade = NO;
        return;
    }

    [self setupFade];

    [self.view bringSubviewToFront:self.flashImage];

    [self bringSubviewsToFront];


    //reset
    [self.darkImage.layer removeAllAnimations];

    self.darkVisible = YES;

    self.darkImage.alpha = 1.0f;
    [UIView animateWithDuration:kFadeDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.darkImage.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.darkVisible = NO;

			//reset fade white
			kAppDelegate.fadingWhite = NO;
    }];

    //curtains
    [self openCurtains];
}

/*- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController
{
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        Log(@"Finished Presenting Authentication Controller");
    }];

}*/

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if([kHelpers isDebug] && ![kHelpers isSimulator] && (kShowFPS || kAppDelegate.fps) ) {
        self.skView.showsFPS = YES;
        self.skView.showsNodeCount = NO; //YES;
    }
    else {
        self.skView.showsFPS = NO;
        self.skView.showsNodeCount = NO;
    }


    //banner
    //[kAppDelegate setupBannerAds];

    //if(self.sharing)
    //    return;

    //[kAppDelegate loadAchievements];

    self.darkAdImage.hidden = YES;

    self.showingKTPlay = NO;

    //self.paused = NO;
    //kAppDelegate.gameScene.paused = NO;
    [kAppDelegate.gameScene enablePause:NO];

    [kAppDelegate.gameScene willAppear];

    if(!self.sharing)
        [self setupFade];

    //[kAppDelegate cacheRewardVideos];

    self.vcr.hidden = YES;
    self.vcr.alpha = 0.0f;
    [self.vcr startAnimating];

    self.cheatButton.alpha = 0.0f;

    if(YES)
    {
        //animate cheat button
        NSArray *allImages = @[
                               //[UIImage imageNamed:@"menu_icon_cheat"],
                               [UIImage imageNamed:@"menu_icon_cheat_color1"], //yellow
                               [UIImage imageNamed:@"menu_icon_cheat_color2"], //orange
                               ];
        self.cheatButton.imageView.animationImages = allImages;
        self.cheatButton.imageView.animationRepeatCount = 0;
        self.cheatButton.imageView.animationDuration = allImages.count * 0.1f;
        [self.cheatButton.imageView startAnimating];
    }


    self.didAppear = NO;

    //show/hide
    self.labelScroll.hidden = YES;

    /*float secs = 8.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.labelScroll.hidden = !kAppDelegate.showQuotes;
        [self updateScroll];
    });*/
    self.labelScroll.hidden = YES;

    //update time
    [kAppDelegate updateForegroundTime];


    self.dateActive = [NSDate date];

    //show status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    //curtains
    if(!self.sharing)
    {
        self.curtainRight.hidden = YES;
        self.curtainLeft.hidden = YES;
    }

    kAppDelegate.titleController.menuState = menuStateGame;

    [self enableButtons:YES];

    // Present the scene.

    //[skView presentScene:kAppDelegate.gameScene];

    //kAppDelegate.gameScene.paused = NO;
    //kAppDelegate.gameScene.paused = NO;
    //self.skpaused = NO;

    //scene
    //kAppDelegate.gameScene.x = CGPointMake(400.0f,0.0f);

    //google analytics
    [kHelpers setupGoogleAnalyticsForView:[[self class] description]];


    //forced, IAP, todo:
    //kAppDelegate.adBannerEnabled = YES;

    if(!self.sharing)
    //if(!kAppDelegate.gameScene.paused)
    {
        [kAppDelegate.gameScene updateAll];
    }

    //reset
    self.backButton.y = 10; //30;// - kStatusBarOffset*2;
    //self.plusEnergyButton.y = 30 - kStatusBarOffset*2;
    self.profileButton.y = 10;

    //store
    self.plusEnergyButton.hidden = self.plusEnergyButton2.hidden = YES;
    self.storeButton.hidden = YES; //NO;

    //fade, delay
    if(!self.sharing)
    {
        if(!self.skipFade) {
            self.darkImage.alpha = 1.0f;
            self.darkVisible = YES;
        }

        float secs = 0.3f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self fadeOut];
        });
    }

    //music
    //[kAppDelegate playMusicRandom];

    //music
    [kAppDelegate playMusicRandom];

    //notify
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground2:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];



    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];

    //subscribe to resume updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeNotification:)
                                                 name:kResumeNotification
                                               object:nil];


    [self updateBadge];

    //hide banner
    [self hideBanner];

    //reset
    [kAppDelegate.gameScene resetParticles];

    //rest flash
    self.flashImage.hidden = YES;
    self.flashImage.alpha = 0;

    //help
    self.helpButton.alpha = 0.8f;
    [self updateButtons];


    //info
    //NSString *skinName = [kAppDelegate getBlockDisplayNameIndex:[kAppDelegate getSkin]];
    //NSString *skinDesc = [kAppDelegate getBlockDescIndex:[kAppDelegate getSkin]];
    //NSString *skinURL = [kAppDelegate getBlockWebsite:(int)[kAppDelegate getSkin]];

	if([kAppDelegate getSkin] == kCoinTypeTA)
	{
		//show only for TA
		self.infoButton.hidden = YES; //NO;
	}
    else
	{
		self.infoButton.hidden = YES;
    }

	self.infoButton.alpha = 0.8f;

    [self showWhiteBar];

    [self resetTimer];

    //today
    [kAppDelegate saveBlockImage];

    //parse
    [kAppDelegate dbIncPlay];

    //un pause
    [self blurScene:NO];


    //spotlight
    //[MLPSpotlight addSpotlightInView:self.view atPoint:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2)];


    [self updateTimeLabel:NO];

    //banner
    [self hideBanner];
    CGFloat secs = 4.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       // [self showBanner];
    });

    //debug
    //cheat
    if([kHelpers isDebug]) {
        float secs = 1.0f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //[self shakeWasRecognized:nil];
        });
    }

}

-(void) showBanner
{
    self.lastBannerToggle = [NSDate date];

    //debug
    if([kHelpers isDebug])
    {
//        [self hideBanner];
//        return;
    }

    //ipad
    if([kHelpers isIpad] && !kBannerIPadEnabled)
    {
        [self hideBanner];
        return;
    }


    if(kAppDelegate.inReview)
    {
        [self hideBanner];
        return;
    }

    BOOL premium = [kAppDelegate isPremium];
    if(premium)
    {
        [self hideBanner];
        return;
    }

    //temp
    if(!kAppDelegate.adBannerEnabledTemp)
    {
        [self hideBanner];
        return;
    }

    //too small?
    if([kHelpers isIphone4Size])
    {
//        [self hideBanner];
//        return;
    }


    //launch
    if(kAppDelegate.launchCount <= 1)
    {
        [self hideBanner];
        return;
    }

    //by level
    if(kAppDelegate.level <= 1)
    {
        [self hideBanner];
        return;
    }

    if(![self bannerAvailable])
    {
        [self hideBanner];
        return;
    }

    //not during buff
    if(kAppDelegate.currentBuff != kBuffTypeNone)
    {
      [self hideBanner];
      return;
    }


    self.bannerView.backgroundColor = RGB(50,50,50);

    self.bannerView.hidden = NO;
    self.closeAdButton.hidden = NO;
    self.closeAdButton2.hidden = YES; //NO;

    self.bannerView.alpha = 1.0f;
    self.closeAdButton.alpha = 1.0f;

    [kAppDelegate.gameScene repositionAll];
    //[kAppDelegate.gameScene updateAll];

}

-(void)hideBanner {

    self.lastBannerToggle = [NSDate date];

    self.bannerView.hidden = YES;
    self.closeAdButton.hidden = YES;
    self.closeAdButton2.hidden = YES;
    self.adSpinner.hidden = YES;

    [kAppDelegate.gameScene repositionAll];
    //[kAppDelegate.gameScene updateAll];
}

-(void)showFirstTimeAlert {

    if(kAppDelegate.playedIntroAlert)
       return;

    __weak typeof(self) weakSelf = self;

    //<color1>?
    NSString *message =
    @"• Tap <color1>Block</color1> to collect Coins.\n\
    • Avoid <color1>Enemies</color1> and <color1>Spikes</color1>.\n\
    • Collect <color1>Powerups</color1>.\n\
    • <color1>Unlock</color1> new Blocks.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];
    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                             type:kAlertButtonGreen
                          handler:^(SIAlertView *alert) {
                              //
                              [kAppDelegate playSound:kClickSound];
                              //nothing

                              kAppDelegate.playedIntroAlert = YES;
                              [kAppDelegate saveState];

                          }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    //force height, bug with \n
    kAppDelegate.alertView.forcedHeight = 135.0f;

    //pause
    [kAppDelegate.gameScene enablePause:YES];
    [kAppDelegate.gameController blurScene:YES];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        [kAppDelegate.gameScene enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];
        [weakSelf showVCR:NO animated:YES];

    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        kAppDelegate.playedIntroAlert = YES;
        [kAppDelegate saveState];
    }];


    [kAppDelegate.alertView show:YES];

    [self showVCR:YES animated:YES];
}

-(void)updateButtons {
    self.helpButton.hidden = YES;

    self.doublerButton.hidden = YES;

    self.settingsButton.hidden = YES;;
    self.settingsButton2.hidden = YES;

}

-(void)updateBadge {
    int num = [kAppDelegate getNumNewSkins];
    int offsetX = 5;
    int offsetY = -5;

    int newRainbow = kAppDelegate.rainbowCount;

    if(num > 0 || [kAppDelegate.titleController chestReady] || (newRainbow > 0) || [kAppDelegate.titleController downloadAvailable]) {
        [self.backButton setBadgeValue:nil];
        [self.storeButton setBadgeValue:nil];

        //[self.storeButton setBadgeValue:[NSString stringWithFormat:@"%d", num] withOffsetX:offsetX withOffsetY:offsetY];
        [self.backButton setBadgeValue:[NSString stringWithFormat:@"%d", num] withOffsetX:offsetX withOffsetY:offsetY];

    }
    else {
        [self.backButton setBadgeValue:nil];
        [self.storeButton setBadgeValue:nil];
        [self.backButton setBadgeValue:nil];
    }

}

-(void)viewDidLayoutSubviews {

    Log(@"CBGameViewController::viewDidLayoutSubviews");
    //update arrow
    //if(!self.didAppear)
    //    [self showArrowBlock];

    if([kHelpers isIpad])
    {
        //self.bannerBottom.constant = 40;;
    }
    else if([kHelpers isIphone4Size])
    {
    }
    else if([kHelpers isIphoneX])
    {
        self.backButton.y = 14+kiPhoneXTopSpace; //taller
        self.backButton2.y = 5+kiPhoneXTopSpace; //taller

        //self.bannerBottom.constant = kiPhoneXBottomSpace;
    }
    else
    {
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //alert 1st time
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showFirstTimeAlert];
    });


    //reset
    self.forceEnding = NO;

#if kKTPlayEnabled
#if !(TARGET_IPHONE_SIMULATOR)

    [KTPlay setViewDidAppearBlock:^{
        Log(@"ktplay window appear...");

        self.showingKTPlay = YES;

        //stop
        [kAppDelegate stopMusic];
    }];

    [KTPlay setViewDidDisappearBlock:^{
        Log(@"ktplay window disappear...");

        self.showingKTPlay = NO;

        [kAppDelegate playMusicRandom];

        [self actionMenu:nil];
    }];

    [KTPlay setActivityStatusChangedBlock:^(BOOL hasNewActivity) {
        if (hasNewActivity) {
        }else{
        }
    }];

    [KTPlay setDidDispatchRewardsBlock:^(KTReward *reward) {
        for (KTRewardItem *item in reward.items) {
            Log(@"name->%@ ID->%@ value->%llu", item.name, item.typeId, item.value);
        }
    }];
#endif
#endif

    //cache
    //[kAppDelegate cacheRewardVideos];

    //kAppDelegate.gameScene.paused = NO;
    //kAppDelegate.gameScene.paused = NO;
    //self.skpaused = NO;

    //((SKView*)(self.view)).paused = NO;

    /*float secs = 2.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        kAppDelegate.gameScene.paused = NO;
        kAppDelegate.gameScene.paused = NO;
    });*/


    //unlocks
    self.lastEnabledSkins = 0;
    for(int i=0;i<kNumSkins;i++) {
        BOOL enabled  = [kAppDelegate isBlockEnabledIndex:i];
        if(enabled)
            self.lastEnabledSkins++;
    }

    //state
    kAppDelegate.launchInGame = YES;
    //[kAppDelegate saveState];


    //move
    //self.infoButton.y = self.view.height - 100;
    //self.infoButton.y = self.view.height - 40;

    //[self showUnlockBanner];

    //update arrow
    /*float secs = 0.3f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //update arrow
        [self showArrowBlock];
    });*/

    [kAppDelegate.gameScene showArrowBlock];

    self.didAppear = YES;

    //sound friday pew

    //fridays with pewdiepie


    if([kHelpers isFriday] && [kAppDelegate getSkin] == kCoinTypePew) {
    //if([kHelpers isNight] && [kHelpers isFriday] && [kAppDelegate getSkin] == kCoinTypePew) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //update arrow
            [kAppDelegate playSound:@"pew_fridays.caf"];
        });
    }

    //big ad
    //if((kAppDelegate.fromWin || kAppDelegate.fromDie) && (kAppDelegate.level >= 3))
    //if(kAppDelegate.level >= 3)
    {
        kAppDelegate.fromWin = NO;
        kAppDelegate.fromDie = NO;

        if([kHelpers randomBool100:[kAppDelegate getInterstitialOdds:kAppDelegate.interstitialAfterWinOdds]])
        {
            //hud?
            [kHelpers showMessageHud:@""];

            //after delay
            float secs = 0.5f; //0.5
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [kAppDelegate showInterstitial:kRewardScreen];
            });

            //after delay, in case
            secs = 3.0f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [kHelpers dismissHud];
            });
        }
    }

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [kAppDelegate saveState:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [kAppDelegate.gameScene willDisappear];


    [self hideBanner];

    [self stopConfetti];

    //reset force
    kAppDelegate.gameController.curtainsVisible = NO;

    //unsubscribe
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kResumeNotification object:nil];


    [kAppDelegate.gameScene hideArrowBlock];

    [self stopWhiteBar];

    //save
    [self.timerSave invalidate];
    self.timerSave = nil;

    [self.timerScroll invalidate];
    self.timerScroll = nil;

    [self.timerPause invalidate];
    self.timerPause = nil;

    [self.timerVCR invalidate];
    self.timerVCR = nil;
    self.vcr.hidden = YES;

    [self.timerWobble invalidate];
    self.timerWobble = nil;

    [kAppDelegate dbSaveObjects];

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    //spotlight
    //[MLPSpotlight removeSpotlightsInView:self.view];

    [kAppDelegate cacheRewardVideos];
}

/*- (void)showAuthenticationViewController
{
    GameKitHelper *gameKitHelper =
    [GameKitHelper sharedGameKitHelper];

    [self presentViewController:
     gameKitHelper.authenticationViewController
                                         animated:YES
                                       completion:nil];
}
*/

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    Log(@"didReceiveMemoryWarning");
}

- (void)updateScroll {
    //disabled
    self.labelScroll.hidden = YES;
    return;
    /*
    //not yet
    if(kAppDelegate.level <= 2) {
        return;
    }

    NSString *string = [kAppDelegate randomQuote];

    self.labelScroll.text = string;
    self.labelScroll.leadingBuffer = self.view.width;
    self.labelScroll.trailingBuffer = self.view.width * 10;

    [self.labelScroll restartLabel];*/

}

- (IBAction)actionHashtag:(id)sender
{
    [kAppDelegate actionHashtag];
}

-(void)actionDoubler:(id)sender{

#if 0
    [kAppDelegate animateControl:self.doublerButton];

    [kAppDelegate playSound:kClickSound];


    //offline
    if(![kHelpers checkOnline]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        return;
    }

    //payments
//    if(![kHelpers canMakePayments]) {
//        [kHelpers showErrorHud:LOCALIZED(@"kStringPayments")];
//        return;
//    }

    [kHelpers showMessageHud:@"Connecting..."];

    //fake
    float secs = 2.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kAppDelegate unlockDoubler];
        //also ads
        kAppDelegate.adBannerEnabled = NO;
        [kAppDelegate saveState];

        [self hideBanner];

        [self updateButtons];
        [kAppDelegate.gameScene updateAll];

        [kAppDelegate playSound:kUnlockSound];
        [kAppDelegate playSound:kUnlockSound2];

        [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
        [self startConfetti];
        float secs = kConfettiThanksDuration;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self stopConfetti];
        });
    });
#endif

}

- (void) actionPlusEnergy:(id)sender {
#if 0
    //store

    //report
    [kAppDelegate reportScore];

    [kAppDelegate saveState];

    [kAppDelegate animateControl:self.plusEnergyButton];
    [kAppDelegate animateControl:self.storeButton];

    [self enableButtons:NO];

		//fade white
		//kAppDelegate.fadingWhite = YES;

    [self fadeIn];

    [kAppDelegate playSound:kClickSound];
    //[kAppDelegate playSound:@"whistle3.caf"];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //stop sounds
        [kAppDelegate.gameScene stopAllSounds];

        kAppDelegate.skinController.backToGame = YES;
        [kAppDelegate setViewController:kAppDelegate.skinController];
    });

#endif
}


- (void) actionWin:(id)sender {

    [kAppDelegate reportScore];

    [kAppDelegate saveState];

    [self enableButtons:NO];

	//fade white
	kAppDelegate.fadingWhite = YES;

    [self fadeIn];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //stop sounds
        if(kAppDelegate.level == (kLevelMax+1) || self.forceEnding)
        {
            //ending
            [kAppDelegate setViewController:kAppDelegate.endingController];
        }
        else
        {
			//regular, win
            kAppDelegate.winController.backToGame = YES;
            kAppDelegate.winController.backToGameMenu = NO;
            kAppDelegate.winController.backToTitle = NO;
            [kAppDelegate setViewController:kAppDelegate.winController];
        }
    });
}

- (IBAction)actionSettings:(id)sender {

    //report
    [kAppDelegate reportScore];

    [kAppDelegate saveState];

    //[kAppDelegate animateControl:self.plusEnergyButton];

    [self enableButtons:NO];

    [self fadeIn];

    //[kAppDelegate playSound:kClickSound];
    //[kAppDelegate playSound:@"whistle3.caf"];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //stop sounds
        [kAppDelegate.gameScene stopAllSounds];

        kAppDelegate.settingsController.backToGame = YES;
        [kAppDelegate setViewController:kAppDelegate.settingsController];
    });

}

- (void) actionInfo:(id)sender {

	//just hide
	self.infoButton.hidden = YES;

    __weak typeof(self) weakSelf = self;

    NSString *skinName = [CBSkinManager getBlockDisplayNameIndex:(int)[kAppDelegate getSkin]];
    NSString *skinDesc = [CBSkinManager getBlockDescIndex:(int)[kAppDelegate getSkin]];
    NSString *skinURL = [CBSkinManager getBlockWebsite:(int)[kAppDelegate getSkin]];


    [kAppDelegate animateControl:self.infoButton];

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:skinName
                                        andMessage:skinDesc];

    [kAppDelegate.alertView addButtonWithTitle:@"More info..."
                             type:kAlertButtonGreen
                          handler:^(SIAlertView *alert) {
                              [kAppDelegate playSound:kClickSound];

                              if([skinURL contains:@"itunes.apple.com"]) {
                                  float secs = 0.3f;
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:skinURL] options:@{} completionHandler:nil];

                                  });
                              }
                              else {
                                  /*[kAppDelegate stopMusic];

                                  SVModalWebViewController *webViewController = [[SVModalWebViewController alloc] initWithAddress:skinURL];
                                  webViewController.barsTintColor = kGreenTextColor;

                                  [self presentViewController:webViewController animated:YES completion:nil];*/

                                  [weakSelf enableButtons:NO];
                                  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                      [weakSelf enableButtons:YES];

                                      [kAppDelegate openExternalURL:skinURL];
                                  });
                              }


                          }];


    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];
}


-(void) actionHideAds {

    [self hideBanner];

    //bannerOffset
    [self adButtonPressed:nil];
}


- (void) actionCloseAd:(id)sender {

    //return;

    //already
    if(/*self.paused ||*/ kAppDelegate.alertView.visible)
        return;

    __weak typeof(self) weakSelf = self;


    //report
    [kAppDelegate reportScore];

    [kAppDelegate playSound:kClickSound];

    [kAppDelegate animateControl:self.closeAdButton];
    [kAppDelegate animateControl:self.closeAdButton2];

    //disabled
    /*if(![kHelpers isDebug]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];
        return;
    }*/



    //alert

    NSString *message = LOCALIZED(@"kStringPremiumAsk");
    //NSString *message = @"Disable ads permanently?";
    NSString *title = @"VIP";
    //NSString *title = @"No Ads";

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:title andMessage:message];

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Just for now"
                                  type:kAlertButtonOrange
                               handler:^(SIAlertView *alert) {
                                   [kAppDelegate playSound:kClickSound];

                                   float secs = 0.3f;
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                       [weakSelf hideBanner];

                                       kAppDelegate.adBannerEnabledTemp = NO;
                                       [kAppDelegate saveState];

                                       [kAppDelegate playSound:@"sigh.caf"];

                                       [kAppDelegate.gameScene repositionAll];
                                       [kAppDelegate.gameScene updateAll];
                                   });


                               }];
#endif


    //[kAppDelegate.alertView addButtonWithTitle:@"Forever! (Disable Ads)"
     [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringPremiumButton") //@"Disable Ads"
                                  type:kAlertButtonGreen
                               handler:^(SIAlertView *alert) {
										[self actionHideAds];
                               }];

    //close x
    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {

        [kAppDelegate playSound:kClickSound];

    }];


    //closed, reset music
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        [weakSelf showVCR:NO animated:YES];

        [kAppDelegate.gameScene setSoundVolume];

        [kAppDelegate resumeMusic];

        //weakSelf.paused = NO;
        //kAppDelegate.gameScene.paused = NO;
        [kAppDelegate.gameScene enablePause:NO];
        [weakSelf blurScene:NO];
    }];


    //weakSelf.paused = YES;
    //kAppDelegate.gameScene.paused = YES;
    [kAppDelegate.gameScene enablePause:YES];
    //[weakSelf blurScene:YES];
    [self showVCR:YES animated:YES];


    weakSelf.labelScroll.hidden = YES;

    kAppDelegate.alertView.transitionStyle = kAlertStyle;
    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical

    [kAppDelegate stopMusic];

    //force
    //stop sounds
    [kAppDelegate.gameScene stopAllSounds];


    [kAppDelegate.alertView show:YES];
}


-(void)enableButtons:(BOOL)enable {

    self.buttonTime.enabled = enable;
    self.backButton.enabled = enable;
    self.backButton2.enabled = enable;
		self.plusEnergyButton.enabled = enable;
    self.plusEnergyButton2.enabled = enable;
		self.storeButton.enabled = enable;
    self.doublerButton.enabled = enable;
    self.hashtag.enabled = enable;
    self.settingsButton.enabled = enable;
    self.settingsButton2.enabled = enable;
}

- (void) actionProfile:(id)sender {

    //disabled
    return;

}

//actionpause

- (void) actionMenu:(id)sender
{
    [self actionMenu:sender playSound:YES];
}

- (void) actionMenu:(id)sender playSound:(BOOL)playSound
{
    //only if still in game?
    if(kAppDelegate.titleController.menuState != menuStateGame)
      return;

    if(kAppDelegate.gameScene.dying)
    {
        //[self actionBack:nil];
        return;
    }

    __weak typeof(self) weakSelf = self;

    [kAppDelegate saveState:NO];

    //regular alert
    //already
    if(kAppDelegate.alertView.visible)
        return;

    //screenshot before?
    //UIImage *screenshot = [kHelpers takeScreenshot:self.view];

    NSString *message = nil;
    message = [CBSkinManager getRandomTip];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Paused" andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:@"Home"
                                  type:kAlertButtonGray
                               handler:^(SIAlertView *alert) {
                                   [kAppDelegate playSound:kClickSound];

                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                       [weakSelf actionBack:nil];
                                   });
                               }];

    [kAppDelegate.alertView addButtonWithTitle:@"Settings"
                                  type:kAlertButtonGray
                               handler:^(SIAlertView *alert) {
                                   [kAppDelegate playSound:kClickSound];

                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                       [weakSelf actionSettings:nil];
                                   });


                               }];


#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Share"
                                          type:kAlertButtonGray
                                       handler:^(SIAlertView *alert) {
                                           //[kAppDelegate.gameScene setSoundVolume];
                                           [kAppDelegate playSound:kClickSound];

                                           //[kAppDelegate.gameScene enablePause:NO];

                                           //[kAppDelegate playSound:kClickSound];
                                           //[kAppDelegate resumeMusic];


                                           //help
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [weakSelf shareButtonPressed:nil];
                                           });

                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Forums"
                                          type:kAlertButtonGray
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];


                                           //help
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [weakSelf socialButtonPressed:nil];
                                           });

                                       }];
#endif


/*
	[kAppDelegate.alertView addButtonWithTitle:@"Disable Ads"
																				type:kAlertButtonGray
																		 handler:^(SIAlertView *alert) {
																			 //[kAppDelegate playSound:kClickSound];
																			 [self actionHideAds];
																		 }];
*/


#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Store"
                                  type:kAlertButtonGray
                               handler:^(SIAlertView *alert) {
                                   //[kAppDelegate playSound:kClickSound];

                                   //weakSelf.paused = NO;
                                   //kAppDelegate.gameScene.paused = NO;

                                   //[kAppDelegate.gameScene enablePause:NO];

                                   [weakSelf actionPlusEnergy:nil];

                               }];
#endif



if([kAppDelegate.titleController chestReady])
{
    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringFreeGiftButton")
                                          type:kAlertButtonOrange // kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               //[weakSelf actionBack:nil];

                                               [self fadeIn];

                                               float secs = kFadeDuration;
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                                   //regular, win
                                                   kAppDelegate.winController.backToGameMenu = YES;
                                                   kAppDelegate.winController.backToGame = NO;
                                                   kAppDelegate.winController.backToTitle = NO;
                                                   [kAppDelegate setViewController:kAppDelegate.winController];
                                               });

                                           });

                                       }];
}


#if 1
    if(![kAppDelegate isPremium]) {
        [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringPremiumButton")
                                          type:kAlertButtonOrange
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];
                                           float secs = 0.5f;
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [self adButtonPressed:nil];

                                           });
                                       }];
    }
#endif

    void (^resumeBlock)(void);
    resumeBlock =
    ^{
        [kAppDelegate.gameScene setSoundVolume];
        [kAppDelegate resumeMusic];

        //credit coin
        //[kAppDelegate playSound:@"credit1.caf"];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            //audio
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [kAppDelegate.gameScene enablePause:NO];
                [weakSelf blurScene:NO];
            });
        });
    };

    //resume
    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringResume")
                                  type:kAlertButtonGreen
                               handler:^(SIAlertView *alert) {

                                   //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                       resumeBlock();

                                       [kAppDelegate playSound:kClickSound];
                                   //});


                               }];

    //close x
    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {

        //ispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            resumeBlock();
        //});
    }];


    //closed, reset music
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        [weakSelf showVCR:NO animated:YES];
    }];

    [kAppDelegate.gameScene enablePause:YES];
    [weakSelf blurScene:YES];

    weakSelf.labelScroll.hidden = YES;

    kAppDelegate.alertView.transitionStyle = kAlertStyle;
    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical

    [kAppDelegate stopMusic];

    //modes
	kAppDelegate.alertView.pauseMenuMode = YES;

    [kAppDelegate.alertView show:YES showContinue:NO playSound:playSound];

    if(sender)
        [kAppDelegate playSound:kClickSound];

    [self showVCR:YES animated:YES];

    //arrow
    [kAppDelegate.gameScene hideArrowBlock];

    //cache
    [kAppDelegate cacheRewardVideos];

}

- (IBAction)socialButtonPressed:(id)sender
{
//    [kAppDelegate playSound:kClickSound];
//
//    [kAppDelegate animateControl:self.socialButton];

    if(![kHelpers checkOnline])
    {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        return;
    }

    /*[kHelpers showMessageHud:@""];
    float secs = 0.5f; //1.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kHelpers dismissHud];
    });*/

    float secs = 0.0f; //0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
#if kKTPlayEnabled
#if !(TARGET_IPHONE_SIMULATOR)
        [KTPlay show];
#endif
#endif
    });

}

- (void)blurScene:(BOOL)blur {

    //disabled
    return;

    //if([kHelpers isSlowDevice])
    //    return;

    //[self setShouldEnableEffects:blur];
#if 0
    if(blur) {

        [self.view bringSubviewToFront:self.blurImageView];

        UIImage *blur = [kAppDelegate.gameScene getScreenshot];
        //blur
        blur = [kHelpers getBlurredImage:blur];

        //pixelated
        //blur = [kHelpers getPixelated:blur];
        //gray
        //blur = [kHelpers getGrayImage:blur];

        self.blurImageView.image = blur;

        self.blurImageView.hidden = NO;
        self.blurImageView.alpha = 0.0f;
        [UIView animateWithDuration:kPauseBlurDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.blurImageView.alpha = 1.0f;
        }
        completion:^(BOOL finished) {
        }];

    }
    else {

        self.blurImageView.hidden = NO;
        self.blurImageView.alpha = 1.0f;
        [UIView animateWithDuration:kPauseBlurDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        //[UIView animateWithDuration:0.0f delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.blurImageView.alpha = 0.0f;
        }
         completion:^(BOOL finished) {
             self.blurImageView.hidden = YES;
         }];

        //self.pauseView.alpha = 1;
        //[self.pauseView runAction:[SKAction fadeAlphaTo:0 duration:kPauseBlurDuration] completion:^{
        //}];
    }
#endif
}

- (IBAction)actionTime:(id)sender {

    if([kHelpers isDebug] && NO) {
        kAppDelegate.worldTimeLeft -= 10;
        [kAppDelegate playSound:kClickSound];

        [kAppDelegate.gameScene actionTimerWorldTime:nil];
    }
}

- (void) actionRestart:(id)sender
{
    //just back
    //[self actionBack:sender];

    //refill
    kAppDelegate.numHearts = kHeartFull;

    //report
    [kAppDelegate reportScore];


    [kAppDelegate saveState:NO];

    [self enableButtons:NO];

    [self fadeIn];

    [self.backButton setBadgeValue:nil];
    [self.plusEnergyButton setBadgeValue:nil];
    [self.storeButton setBadgeValue:nil];

    //no sound if called manually
    if(sender)
        [kAppDelegate playSound:kClickSound];


    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //stop sounds
        [kAppDelegate.gameScene stopAllSounds];

        [kAppDelegate setViewController:kAppDelegate.transitionController];
    });

}

- (void) actionBack:(id)sender {

    //report
    [kAppDelegate reportScore];


    //[kAppDelegate stopMusic];

    [kAppDelegate saveState:NO];

    //[kAppDelegate animateControl:self.backButton];
    //[kAppDelegate animateControl:self.backButton2];

    [self enableButtons:NO];

    [self fadeIn];


    [self.backButton setBadgeValue:nil];
    [self.plusEnergyButton setBadgeValue:nil];
    [self.storeButton setBadgeValue:nil];

    //no sound if called manually
    if(sender)
        [kAppDelegate playSound:kClickSound];

    //[kAppDelegate.gameScene showMenu];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //stop sounds
        [kAppDelegate.gameScene stopAllSounds];

				[kAppDelegate setViewController:kAppDelegate.titleController];
        //[self dismissViewControllerAnimated:NO completion:nil];

    });

}


- (void) shakeWasRecognized:(NSNotification*)notif {

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return;

//    [self showCommercial];
//    return;

    if([kHelpers isBackground])
        return;

    if(![kHelpers isDebug])
        return;

    //doo doo doo
    [kAppDelegate playSound:@"discover.caf"];

    if(kAppDelegate.titleController.menuState == menuStateGame) {
        self.cheatButton.alpha = 1.0f;
    }

}

- (void)notifyBackground:(NSNotification *)notification {

    //reset timer
    kAppDelegate.gameScene.lastClickDate = [NSDate date];

    Log(@"Application Entered background");

    [self actionMenu:nil playSound:NO];
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    //disabled
    return;

    Log(@"Application Entered Foreground");

    //reset timer
    kAppDelegate.gameScene.lastClickDate = [NSDate date];

    float secs = 0.1f; //0.3f
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //[self actionBack:nil];
        [self actionMenu:nil];
    });

    //reset
    [self showWhiteBar];

    [kAppDelegate.gameScene hideArrowBlock];
}

- (void)applicationEnteredForeground2:(NSNotification *)notification {
    Log(@"Application Entered Foreground 2");

    //disabled
    //return;

    float secs = 0.1f; //0.3f
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //disabled, already in other foreground
        [self actionMenu:nil];
    });

    //reset
    [self showWhiteBar];

    [kAppDelegate.gameScene hideArrowBlock];
}


- (void)toggleBanner {

    if(self.bannerView.hidden) {

        if([kHelpers randomBool100:kAppDelegate.bannerOdds])
        {
            [self showBanner];
        }
    }
    //else
    else if([kHelpers randomBool100:50]) //only hide 1/2 of the time
    {
        //[self hideBanner];
    }
}

- (BOOL)bannerVisible {
    if(_bannerView)
        return !_bannerView.hidden;
    else
        return NO;
}

- (BOOL)bannerAvailable
{
    return [self.bannerView subviews].count > 0;
}

//didReceiveBanner
- (void)receivedBanner:(UIView*)banner
{
    Log(@"***** receivedBanner");

    //ipad
    if([kHelpers isIpad] && !kBannerIPadEnabled)
    {
        return;
    }

    //remove old
    for(UIView *subview in [self.bannerView subviews]) {
        [subview removeFromSuperview];
    }

    //kAppDelegate.gameController.bannerView removeS
    [self.bannerView addSubview:banner];

    //unscale banner
    if([kHelpers isIpad])
    {
        banner.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1/kiPadScaleX, 1/kiPadScaleY);

    }

    //force position
    banner.x = banner.y = 0;

    [kAppDelegate.gameScene repositionAll];

}


-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    Log(@"Swipe received.");

    //[self actionBack:nil];

}

/*
-(void)setupFireworks {
    return;

    //Create the root layer
    CALayer *rootLayer = [CALayer layer];
    rootLayer.bounds = self.view.bounds; //CGRectMake(0, 0, 640, 480);
    rootLayer.backgroundColor = [UIColor blueColor].CGColor;

    self.mortor = [CAEmitterLayer layer];

    //Set the view's layer to the base layer
    [rootLayer addSublayer:self.mortor];
    [self.view.layer addSublayer:rootLayer];

}

-(void)startFireworks {

    return;

    UIImage *image = [UIImage imageNamed:@"tspark"];
    CGPoint point = CGPointMake(160,200);

    self.mortor.emitterPosition = point;
    self.mortor.renderMode = kCAEmitterLayerBackToFront;

    //Invisible particle representing the rocket before the explosion
    CAEmitterCell *rocket = [CAEmitterCell emitterCell];
    rocket.emissionLongitude = M_PI / 2;
    rocket.emissionLatitude = 0;
    rocket.lifetime = 1.6;
    rocket.birthRate = 1;
    rocket.velocity = 40;
    rocket.velocityRange = 100;
    rocket.yAcceleration = -250;
    rocket.emissionRange = M_PI / 4;
    rocket.color = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
    rocket.redRange = 0.5;
    rocket.greenRange = 0.5;
    rocket.blueRange = 0.5;

    //Name the cell so that it can be animated later using keypath
    [rocket setName:@"rocket"];

    //Flare particles emitted from the rocket as it flys
    CAEmitterCell *flare = [CAEmitterCell emitterCell];
    flare.contents = (id)image.CGImage;
    flare.emissionLongitude = (4 * M_PI) / 2;
    flare.scale = 0.4;
    flare.velocity = 100;
    flare.birthRate = 45;
    flare.lifetime = 1.5;
    flare.yAcceleration = -350;
    flare.emissionRange = M_PI / 7;
    flare.alphaSpeed = -0.7;
    flare.scaleSpeed = -0.1;
    flare.scaleRange = 0.1;
    flare.beginTime = 0.01;
    flare.duration = 0.7;



    //The particles that make up the explosion
    CAEmitterCell *firework = [CAEmitterCell emitterCell];
    firework.contents = (id)image.CGImage;
    firework.birthRate = 9999;
    firework.scale = 0.6;
    firework.velocity = 130;
    firework.lifetime = 2;
    firework.alphaSpeed = -0.2;
    firework.yAcceleration = -80;
    firework.beginTime = 1.5;
    firework.duration = 0.1;
    firework.emissionRange = 2 * M_PI;
    firework.scaleSpeed = -0.1;
    firework.spin = 2;

    //Name the cell so that it can be animated later using keypath
    [firework setName:@"firework"];

    //preSpark is an invisible particle used to later emit the spark
    CAEmitterCell *preSpark = [CAEmitterCell emitterCell];
    preSpark.birthRate = 80;
    preSpark.velocity = firework.velocity * 0.70;
    preSpark.lifetime = 1.7;
    preSpark.yAcceleration = firework.yAcceleration * 0.85;
    preSpark.beginTime = firework.beginTime - 0.2;
    preSpark.emissionRange = firework.emissionRange;
    preSpark.greenSpeed = 100;
    preSpark.blueSpeed = 100;
    preSpark.redSpeed = 100;

    //Name the cell so that it can be animated later using keypath
    [preSpark setName:@"preSpark"];

    //The 'sparkle' at the end of a firework
    CAEmitterCell *spark = [CAEmitterCell emitterCell];
    spark.contents = (id)image.CGImage;
    spark.lifetime = 0.05;
    spark.yAcceleration = -250;
    spark.beginTime = 0.8;
    spark.scale = 0.4;
    spark.birthRate = 10;

    preSpark.emitterCells = [NSArray arrayWithObjects:spark, nil];
    rocket.emitterCells = [NSArray arrayWithObjects:flare, firework, preSpark, nil];
    self.mortor.emitterCells = [NSArray arrayWithObjects:rocket, nil];

    [self.view setNeedsDisplay];
}
*/

-(void)shake {
    //[self.view shake];
}

-(void)wobble {

    //Log(@"wobble");
    //disabled
    //return;

    [kAppDelegate animateControl:self.plusEnergyButton];
    [kAppDelegate animateControl:self.storeButton];

//    [kAppDelegate animateControl:self.closeAdButton];
//    [kAppDelegate animateControl:self.closeAdButton2];
//    [kAppDelegate animateControl:self.backButton];

    //disabled
    return;

#if 0
    //float wiggleOffset = 4.0f;
    float wiggleTimeEach = 0.1f;


    //reset

    //reset
    [self.backButton.layer removeAllAnimations];
    self.backButton.y = 10;

    //https://github.com/yangmeyer/CPAnimationSequence

    CPAnimationSequence* sequence = [CPAnimationSequence sequenceWithSteps:


        [CPAnimationStep for:wiggleTimeEach animate:^{
        //self.backButton.y -= wiggleOffset;
        //self.closeAdButton.y -= wiggleOffset;
        }],

        [CPAnimationStep for:wiggleTimeEach animate:^{
        //self.backButton.y += wiggleOffset;
        //self.closeAdButton.y += wiggleOffset;
        }],

        [CPAnimationStep for:wiggleTimeEach animate:^{
        //self.backButton.y -= wiggleOffset/2;
        //self.closeAdButton.y -= wiggleOffset/2;
        }],

        [CPAnimationStep for:wiggleTimeEach animate:^{
        //self.backButton.y += wiggleOffset/2;
        //self.closeAdButton.y += wiggleOffset/2;
        }],

        nil];


    [sequence runAnimated:YES];
#endif
}

-(void)showFlash:(UIColor*)color {
    [self showFlash:color autoHide:YES];
}

-(void)showFlash:(UIColor*)color autoHide:(BOOL)autoHide{
    //disable
    //return;

    //already
    if(!self.flashImage.hidden)
        return;

    float durationFade = 0.15f;
    float durationWait = 0.05f;
    float maxAlpha = 1.0f; //0.6f;

    self.flashImage.alpha = 0;
    self.flashImage.hidden = NO;

    //color
    //self.flashImage.image = nil; //[kHelpers imageWithColor:color andSize:self.flashImage.frame.size];
    self.flashImage.backgroundColor = color;

    //fade in
    [UIView animateWithDuration:durationFade delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.flashImage.alpha = maxAlpha;
    }
                     completion:^(BOOL finished){

                         if(autoHide) {
                             //fade out
                             float secs = durationWait;
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                 [UIView animateWithDuration:durationFade delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                                     self.flashImage.alpha = 0.0f;
                                 }
                                                  completion:^(BOOL finished){
                                                      self.flashImage.hidden = YES;
                                                  }];


                             });
                         }

                     }];
}

-(void)hideFlash {
    self.flashImage.hidden = YES;
}

-(void)openCurtains {

    //Log(@"openCurtains");

    self.curtainLeft.userInteractionEnabled = YES;
    self.curtainRight.userInteractionEnabled = YES;

    [self updateButtons];

    //disabled
    /*[kAppDelegate.gameScene openCurtains];
    self.curtainLeft.hidden = YES;
    self.curtainRight.hidden = YES;
    return;*/

    //skip
    //if(self.curtainLeft.hidden) {
    //    return;
    //}

    //top
    [self bringSubviewsToFront];

    //reset
    [self.curtainLeft pop_removeAllAnimations];
    [self.curtainRight pop_removeAllAnimations];
    [self.curtainLeft.layer removeAllAnimations];
    [self.curtainRight.layer removeAllAnimations];

    self.curtainLeft.hidden = NO;
    self.curtainRight.hidden = NO;

    [self.curtainLeft setNeedsUpdateConstraints];
    [self.curtainLeft updateConstraints];
    [self.curtainLeft updateConstraintsIfNeeded];

    [self.curtainRight setNeedsUpdateConstraints];
    [self.curtainRight updateConstraints];
    [self.curtainRight updateConstraintsIfNeeded];


    //self.curtainLeft.x = 0;
    //    self.curtainRight.x = screenRect.size.width-self.curtainRight.width;


    /*self.curtainLeftXConstraint.constant = 0; //leading
    self.curtainRightXConstraint.constant = 0; //training

    [self.view layoutIfNeeded];

    self.curtainLeftXConstraint.constant = -self.curtainLeft.width;
    self.curtainRightXConstraint.constant = -self.curtainLeft.width;
     */

    //force no anim?
    //[UIView beginAnimations:nil context:nil];

    //CGRect screenRect = [kHelpers getScreenRect];

    [kAppDelegate playSound:kCurtain2Sound];

    if([kHelpers isIphoneX])
    {
        self.curtainLeftXConstraint.constant = 0;
        self.curtainRightXConstraint.constant = 0;
        self.curtainLeftWidth.constant = 160;
        self.curtainRightWidth.constant = 160;
    }
    else if([kHelpers isIpad])
    {
        //kiPadCurtainOffset
        self.curtainLeftXConstraint.constant = 0.0;
        self.curtainRightXConstraint.constant = 0.0f;
        self.curtainLeftWidth.constant = 180;
        self.curtainRightWidth.constant = 180;
    }
    else
    {
        self.curtainLeftXConstraint.constant = 0;
        self.curtainRightXConstraint.constant = 0;
        self.curtainLeftWidth.constant = 160;
        self.curtainRightWidth.constant = 160;
    }

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];


    if([kHelpers isIphoneX])
    {
        self.curtainLeftXConstraint.constant = -self.curtainLeft.width;
        self.curtainRightXConstraint.constant = -self.curtainLeft.width;
    }
    else if([kHelpers isIpad])
    {
        self.curtainLeftXConstraint.constant = -self.curtainLeft.width;
        self.curtainRightXConstraint.constant = -self.curtainLeft.width;
    }
    else
    {
        self.curtainLeftXConstraint.constant = -self.curtainLeft.width;
        self.curtainRightXConstraint.constant = -self.curtainLeft.width;
    }

    CGFloat openDelay = 0.0f;
    if([kHelpers isIpad] || [kHelpers isSlowDevice])
    {
        openDelay = 1.0f;
    }

    [UIView animateWithDuration:kCurtainAnimDuration delay:openDelay options:UIViewAnimationOptionCurveEaseIn animations:^{

        [self.view layoutIfNeeded];

    }
     completion:^(BOOL finished){
         self.curtainLeft.hidden = YES;
         self.curtainRight.hidden = YES;

         self.curtainsVisible = NO;
     }];
}

-(void)bringSubviewsToFront
{
    [self.view bringSubviewToFront:self.curtainLeft];
    [self.view bringSubviewToFront:self.curtainRight];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkAdImage];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.vcr];
    [self.view bringSubviewToFront:self.scanline];
}

-(void)closeCurtains {

    //Log(@"closeCurtains");

    //disabled
    /*[kAppDelegate.gameScene closeCurtains];
    self.curtainLeft.hidden = YES;
    self.curtainRight.hidden = YES;
    return;*/

    //skip
    if(!self.curtainLeft.hidden) {
        return;
    }

    //CGRect screenRect = [kHelpers getScreenRect];

    //top
    [self bringSubviewsToFront];

    //delays
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.curtainsVisible = YES;
    });

    //reset
    self.curtainLeft.hidden = NO;
    self.curtainRight.hidden = NO;

    //self.curtainLeft.x = -self.curtainLeft.width;
    //self.curtainRight.x = screenRect.size.width;

    if([kHelpers isIphoneX])
    {
        self.curtainLeftXConstraint.constant = -self.curtainLeft.width; //leading
        self.curtainRightXConstraint.constant = -self.curtainRight.width; //trailing
        self.curtainLeftWidth.constant = 160;
        self.curtainRightWidth.constant = 160;

    }
    else if([kHelpers isIpad])
    {
        self.curtainLeftXConstraint.constant = -self.curtainLeft.width; //leading
        self.curtainRightXConstraint.constant = -self.curtainRight.width; //trailing
        self.curtainLeftWidth.constant = 180;
        self.curtainRightWidth.constant = 180;
    }
    else
    {
        self.curtainLeftXConstraint.constant = -self.curtainLeft.width; //leading
        self.curtainRightXConstraint.constant = -self.curtainRight.width; //trailing
        self.curtainLeftWidth.constant = 160;
        self.curtainRightWidth.constant = 160;
    }

    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];

    if([kHelpers isIphoneX])
    {
        self.curtainLeftXConstraint.constant = 0; //leading
        self.curtainRightXConstraint.constant = 0; //trailing
    }
    else if([kHelpers isIpad])
    {
        self.curtainLeftXConstraint.constant = 0; //leading
        self.curtainRightXConstraint.constant = 0; //trailing
    }
    else
    {
        self.curtainLeftXConstraint.constant = 0; //leading
        self.curtainRightXConstraint.constant = 0; //trailing
    }

    [kAppDelegate playSound:kCurtainSound];

    [UIView animateWithDuration:kCurtainAnimDuration delay:0.01f options:UIViewAnimationOptionCurveEaseIn animations:^{

        //self.curtainLeft.x = 0;
        //    self.curtainRight.x = screenRect.size.width-self.curtainRight.width;


        [self.view layoutIfNeeded];
    }
     completion:^(BOOL finished){
     }];

}


- (IBAction)contactButtonPressed:(id)sender
{
    [kAppDelegate playSound:kClickSound];

    //[kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];


    NSString *version = [kHelpers getVersionString2];
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    NSString *model = [kHelpers platformString];
    NSString *body = [NSString stringWithFormat: @"App Version: %@\niOS Version: %@\niOS Device: %@\n\n\nDear Skyriser Media, \n\n\n\n", version, iosVersion, model];

    [kAppDelegate sendEmailTo:@"coinyblock@skyriser.com" withSubject: @"Coiny Block Feedback" withBody:body withView:self];
}


- (IBAction)rateButtonPressed:(id)sender
{
    //[kAppDelegate playSound:kClickSound];
    [kAppDelegate playSound:@"kiss.caf"];

    [kAppDelegate dbIncRate];

    __weak typeof(self) weakSelf = self;

    //ask
    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Rate"
                                             andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringEnjoying")]];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringHateIt")
                                  type:kAlertButtonGray
                               handler:^(SIAlertView *alert) {
                                   [kAppDelegate playSound:kClickSound];

                                   //email
                                   [weakSelf contactButtonPressed:nil];


                               }];


    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringLoveIt")
                                  type:kAlertButtonGreen
                               handler:^(SIAlertView *alert) {
                                   [kAppDelegate playSound:kClickSound];

                                   //just rate
                                   NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", kAppStoreAppID];

                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];

                               }];
    /*
    [kAppDelegate.alertView addButtonWithTitle:@"Cancel"
                             type:kAlertButtonGray
                          handler:^(SIAlertView *alert) {

                              [kAppDelegate playSound:kClickSound];

                          }];*/


    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];
}

- (IBAction)shareButtonPressed:(id)sender
{
    //[kAppDelegate playSound:kClickSound];

    [kAppDelegate dbIncRate];

    NSString *textToShare = LOCALIZED(@"kStringShareMessage");
    NSURL *url = [NSURL URLWithString:kAppStoreURL];
    NSString *subject = LOCALIZED(@"kStringShareSubject");

    UIImage *image = [UIImage imageNamed:@"icon120"];
    NSArray *objectsToShare = @[textToShare, url, image];

    //NSArray *objectsToShare = @[textToShare, url];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   //UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];

    activityVC.excludedActivityTypes = excludeActivities;

    //email subject
    [activityVC setValue:subject forKey:@"subject"];

    //ipad crash
    if([kHelpers isIpad])
    {
        activityVC.popoverPresentationController.sourceRect = ((UIButton*)sender).frame;
        activityVC.popoverPresentationController.sourceView = self.view;
        activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }

    [self presentViewController:activityVC animated:YES completion:^{
    }];
}


#pragma mark -
#pragma mark Notification Banner

- (void)showUnlockBanner
{
#if 0
    //disabled
    return;

    //banner
    LNNotification* notification = [LNNotification notificationWithMessage:@"New block unlocked!"];


    //notification.title = @"First Notification";
    notification.date = [NSDate date];

    //notification.soundName = @"gasp1.caf";
    notification.soundName =[kAppDelegate getCoinSoundNameIndex:(int)[kAppDelegate getSkin] which:0];

    notification.defaultAction = [LNNotificationAction actionWithTitle:@"View" handler:^(LNNotificationAction *action) {
        [self notificationWasTapped:nil];
    }];

    [[LNNotificationCenter defaultCenter] presentNotification:notification forApplicationIdentifier:@"new_skin_identifier"];

#endif
}

- (void)notificationWasTapped:(NSNotification*)notification
{
    // Handle tap here.

    [self actionPlusEnergy:nil];
}


-(void)setupWhiteBar {

    //disabled
    return;

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
    //disabled
    return;

    if(!kShowWhiteBar)
        return;

    //if([kHelpers isSlowDevice])
    //    return;

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
        [self.whiteBar.layer removeAllAnimations];
        self.whiteBar.hidden = NO;
        [self.whiteBar.layer addAnimation:translate forKey:@"10"];
    });

}

-(void)stopWhiteBar {
    [self.whiteBar.layer removeAllAnimations];
}


- (void)resetTimer{

    //save
    [self.timerSave invalidate];
    self.timerSave = nil;

    float interval = 5.0f;
    self.timerSave = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                selector:@selector(actionTimerSave:) userInfo:@"actionTimerSave" repeats:YES];

    //call now
    //[self actionTimer:nil];


    [self.timerScroll invalidate];
    self.timerScroll = nil;
    self.labelScroll.hidden = YES;
    /*if([kHelpers isDebug])
        interval = 15.0f;
    else
        interval = 30.0f;

    self.timerScroll = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                    selector:@selector(actionTimerScroll:) userInfo:@"actionTimerScroll" repeats:YES];
    */

    //pause
    [self.timerPause invalidate];
    self.timerPause = nil;
    interval = 10.0f;
    self.timerPause = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                      selector:@selector(actionTimerPause:) userInfo:@"actionTimerPause" repeats:YES];



    //vcr
    [self.timerVCR invalidate];
    self.timerVCR = nil;
    interval = 2.0 + (arc4random_uniform(3*10)/10.0f);
    self.timerVCR = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                   selector:@selector(actionTimerVCR:) userInfo:@"actionTimerVCR" repeats:NO];


    //wobble
    [self.timerWobble invalidate];
    self.timerWobble = nil;
    interval = 5.0f;
    self.timerWobble = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                   selector:@selector(actionTimerWobble:) userInfo:@"actionTimerWobble" repeats:YES];

    //call now
    //[self actionTimerVCR:nil];

}

-(void)showVCR:(BOOL)show animated:(BOOL)animated {

    if(!kVCRAlertEnabled)
        return;

    //disable animated
    //animated = NO;

    float alpha = 0.4f; //kVCRAlphaPaused;

    if(animated) {

        if(show) {
            self.vcr.hidden = NO;
            self.vcr.alpha = 0.0f;

            //[kAppDelegate playSound:@"noise2.caf"];

            [UIView animateWithDuration:kVCRDelayIn delay:0.0 options:0 animations:^{
                self.vcr.alpha = alpha;
            } completion:nil];

        }
        else {
            self.vcr.hidden = NO;
            self.vcr.alpha = alpha;

            //[kAppDelegate playSound:@"noise2.caf"];

            [UIView animateWithDuration:kVCRDelayIn delay:0.0 options:0 animations:^{
                self.vcr.alpha = 0.0f;
            } completion:^(BOOL finished){
                self.vcr.hidden = YES;
            }];

        }
    }
    else {
        self.vcr.hidden = !show;
        self.vcr.alpha = show?alpha:0.0;
    }

}


- (void) actionTimerWobble:(NSTimer *)incomingTimer {

    //if(![kHelpers isSlowDevice]) {
        [self wobble];
    //}
}

-(void)flashVCR {
    [self actionTimerVCR:nil];
}

- (void) actionTimerVCR:(NSTimer *)incomingTimer
{
    //disabled
    //return;

    if(!kVCREnabled)
        return;

    //reset timer
    [self.timerVCR invalidate];
    self.timerVCR = nil;
    float interval = 2.0 + (arc4random_uniform(3*10)/10.0f);
    self.timerVCR = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                   selector:@selector(actionTimerVCR:) userInfo:@"actionTimerVCR" repeats:NO];


    //control center
    if(!kAppDelegate.appActive)
        return;

    if(kAppDelegate.titleController.menuState != menuStateGame || (self.view.hidden == YES))
        return;

    if(kAppDelegate.gameScene.paused) {
        return;
    }

    if(!self.curtainLeft.hidden)
        return;

    if(!kAppDelegate.gameScene.curtainLeft.hidden)
        return;

    if([kHelpers isSlowDevice])
        return;

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        return;

    if(self.showingKTPlay)
        return;


    self.vcr.hidden = NO;
    self.vcr.alpha = 0.0f;

    [kAppDelegate playSound:@"noise2.caf"];

    ///fade out
    [UIView animateWithDuration:kVCRDelayIn delay:0.0 options:0 animations:^{
        self.vcr.alpha = kVCRAlpha;

    } completion:^(BOOL finished){

        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            return;

        //[kAppDelegate playSound:@"noise.caf"];

        //fade out
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kVCRDelayOut delay:kVCRDelayWait options:0 animations:^{
            self.vcr.alpha = 0.0f;
        } completion:^(BOOL finished){
            self.vcr.hidden = YES;
        }];
        //});

    }];
    //self.vcr.alpha = 0.5f;
    //self.vcr.y = arc4random_uniform(200); //random pos



}

- (void) actionTimerSave:(NSTimer *)incomingTimer
{
    //[kAppDelegate saveState];
}

- (void) actionTimerScroll:(NSTimer *)incomingTimer
{
    //[self updateScroll];
}


- (void) actionTimerPause:(NSTimer *)incomingTimer
{
    //disabled
    //return;


#if 1
    if(kAppDelegate.currentBuff == kBuffTypeAuto)
    {
        //not during auto
        return;
    }

    //should only happen in vip
    int interval = abs((int)[kAppDelegate.gameScene.lastClickDate timeIntervalSinceNow]);
    float max = kPauseIdleTime;

    if(interval < max)
        return;

    if(![kHelpers isForeground])
        return;

    [kAppDelegate dbIncPause];

    //[self actionMenu:incomingTimer]; //sound
    [self actionMenu:nil]; //no sound

    //big ad
    if([kHelpers randomBool100:[kAppDelegate getInterstitialOdds:100]])
    {
        //after delay
        float secs = 0.5f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [kAppDelegate showInterstitial:kRewardScreen];
        });
    }
#endif
}


- (void)actionTiredOfAds:(id)sender {

    //disabled
	return;

#if 0
     //already
     if(/*self.paused ||*/ kAppDelegate.alertView.visible)
         return;

     __weak typeof(self) weakSelf = self;


     //report
     [kAppDelegate reportScore];

     [kAppDelegate playSound:kClickSound];

     [kAppDelegate animateControl:self.closeAdButton];
     [kAppDelegate animateControl:self.closeAdButton2];

     //disabled
     /*if(![kHelpers isDebug]) {
      [kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];
      return;
      }*/



     //alert


     kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"No Ads" andMessage:@"Tired of ads?"];

     [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringMaybeLater")
                                   type:kAlertButtonOrange
                                handler:^(SIAlertView *alert) {
                                    [kAppDelegate playSound:kClickSound];


                                    float secs = 0.3f;
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                        [weakSelf hideBanner];

                                        kAppDelegate.adBannerEnabledTemp = NO;
                                        [kAppDelegate saveState];

                                        [kAppDelegate playSound:@"sigh.caf"];

                                        //[kAppDelegate.gameScene repositionAll];
                                        //[kAppDelegate.gameScene updateAll];
                                    });


                                }];


     [kAppDelegate.alertView addButtonWithTitle:@"Disable Ads"
                                   type:kAlertButtonGreen
                                handler:^(SIAlertView *alert) {
                                    [kAppDelegate playSound:kClickSound];

                                    [kHelpers showMessageHud:@"Connecting..."];

                                    float secs = 2.0f;
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                        [kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];

                                        [weakSelf hideBanner];

                                        //refill
                                        kAppDelegate.numHearts = kHeartFull;
                                        [kAppDelegate playSound:kRefillSound];

                                        kAppDelegate.adBannerEnabled = NO;
                                        [kAppDelegate saveState];

                                        [kAppDelegate playSound:kUnlockSound];
                                        [kAppDelegate playSound:kUnlockSound2];

                                        [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
                                        [weakSelf startConfetti];

                                        float secs = kConfettiThanksDuration;
                                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                            [weakSelf stopConfetti];
                                        });

                                        [kAppDelegate.gameScene updateAll];
                                    });


                                }];

     //close x
     [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {

         [kAppDelegate playSound:kClickSound];

     }];


     //closed, reset music
     [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
         [weakSelf showVCR:NO animated:YES];

         [kAppDelegate.gameScene setSoundVolume];

         [kAppDelegate resumeMusic];

         //weakSelf.paused = NO;
         //kAppDelegate.gameScene.paused = NO;
         [kAppDelegate.gameScene enablePause:NO];
         [weakSelf blurScene:NO];
     }];


     //weakSelf.paused = YES;
     //kAppDelegate.gameScene.paused = YES;
     //[weakSelf blurScene:YES];
     [kAppDelegate.gameScene enablePause:YES];
     [self showVCR:YES animated:YES];

     weakSelf.labelScroll.hidden = YES;

     kAppDelegate.alertView.transitionStyle = kAlertStyle;
     kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical

     [kAppDelegate stopMusic];

     //force
     //stop sounds
     [kAppDelegate.gameScene stopAllSounds];


     [kAppDelegate.alertView show:YES];
#endif
}

-(void)updateTimeLabel:(BOOL)animated {
    [kAppDelegate.gameScene updateTimeLabel:animated];
}

- (IBAction)cheatsButtonPressed:(id)sender
{
    __weak typeof(self) weakSelf = self;

    if(![kHelpers isDebug])
        return;

    //already
    if(/*self.paused ||*/ kAppDelegate.alertView.visible)
        return;



    //spotlight
    //[MLPSpotlight addSpotlightInView:self.view atPoint:CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2)];

    if(sender)
        [kAppDelegate playSound:@"pause.caf"];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Cheats" andMessage:nil];



    [kAppDelegate.alertView addButtonWithTitle:@"God"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           //time
                                           kAppDelegate.invincible = YES;

                                           //refill
                                           [kAppDelegate playSound:kClickSound];

                                           kAppDelegate.numHearts = kHeartFull;
                                           [kAppDelegate playSound:kRefillSound];
                                           [kAppDelegate.gameScene updateAll];


                                       }];

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Refill"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           kAppDelegate.numHearts = kHeartFull;
                                           [kAppDelegate playSound:kRefillSound];

                                           kAppDelegate.numPotions = kPotionStart;

                                           [kAppDelegate.gameScene updateAll];
                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Weak Spot"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [kAppDelegate.gameScene showWeakSpot];
                                           });


                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Heart"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypeHeart];
                                           });

                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Doubler"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               //[kAppDelegate.gameScene showBuff:YES which:kBuffTypeShield];
                                               [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypeDoubler];

                                           });

                                       }];
#endif

#if 1
    [kAppDelegate.alertView addButtonWithTitle:@"Auto"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               //[kAppDelegate.gameScene showBuff:YES which:kBuffTypeShield];
                                               [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypeAuto];

                                           });

                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Weak Spot Buff"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               //[kAppDelegate.gameScene showBuff:YES which:kBuffTypeShield];
                                               [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypeWeak];

                                           });

                                       }];
#endif

#if 1
    [kAppDelegate.alertView addButtonWithTitle:@"Huge" //"Grow"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               //[kAppDelegate.gameScene showBuff:YES which:kBuffTypeShield];
                                               [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypeGrow];

                                           });

                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Tiny" //"Shrink"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypeShrink];
                                           });

                                       }];
#endif

#if 1
    [kAppDelegate.alertView addButtonWithTitle:@"Ink"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypeInk];
                                           });

                                       }];
#endif
#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Shield"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               //[kAppDelegate.gameScene showBuff:YES which:kBuffTypeShield];
                                               [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypeShield];

                                           });

                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Lava"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                               kAppDelegate.gameScene.lastLavaDate = nil;
                                               if(kAppDelegate.gameScene.lava.hidden)
                                                   [kAppDelegate.gameScene showLava];
                                               else
                                                   [kAppDelegate.gameScene hideLava:YES];
                                           });

                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Toasty"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               //[kAppDelegate.gameScene showBuff:YES which:kBuffTypeShield];
                                               kAppDelegate.gameScene.lastToastieDate = nil;
                                               [kAppDelegate.gameScene showToastie:YES force:YES];
                                           });

                                       }];
#endif


#if 1
    [kAppDelegate.alertView addButtonWithTitle:@"Star"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           //star
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                               [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypeStar];
                                           });

                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Bomb"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           //star
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                               [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypeBomb];
                                           });

                                       }];
#endif


#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Potion"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           [kAppDelegate.gameScene hidePowerup];

                                           //star
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                               [kAppDelegate.gameScene showPowerup:YES which:kPowerUpTypePotion];
                                           });

                                       }];
#endif

    [kAppDelegate.alertView addButtonWithTitle:@"Power-up"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];


                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                               [kAppDelegate.gameScene showImageSquare:YES];
                                           });

                                       }];



    [kAppDelegate.alertView addButtonWithTitle:@"Almost Win"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                               //force almost done
											   int coinsNeeded = 1; //10;
                                               kAppDelegate.clickCount = kAppDelegate.nextOneUp - coinsNeeded;

                                               [kAppDelegate.gameScene updateAll];

                                           });

                                       }];

#if 1
    [kAppDelegate.alertView addButtonWithTitle:@"x-4"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                               //force almost done
                                               int coinsNeeded = 100; //10;
                                               kAppDelegate.clickCount = kAppDelegate.nextOneUp - coinsNeeded;

                                               [kAppDelegate.gameScene updateAll];

                                           });

                                       }];
#endif


#if 1
    [kAppDelegate.alertView addButtonWithTitle:@"Interstitial"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{


                                               {
                                                   //hud?
                                                   [kHelpers showMessageHud:@""];

                                                   //after delay
                                                   float secs = 0.5f; //0.5
                                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                       [kAppDelegate showInterstitial:kRewardScreen];
                                                   });

                                                   //after delay, in case
                                                   secs = 3.0f;
                                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                       [kHelpers dismissHud];
                                                   });
                                               }
                                           });

                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Ending"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                               //force
                                               self.forceEnding = YES;

                                               //force almost done
                                               kAppDelegate.clickCount = kAppDelegate.nextOneUp - 10;

                                               [kAppDelegate.gameScene updateAll];

                                           });

                                       }];
#endif

#if 0
    [kAppDelegate.alertView addButtonWithTitle:@"Low time"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               kAppDelegate.worldTimeLeft = 32;
                                           });

                                       }];
#endif


    //close x
    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {


    }];


    //closed, reset music
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        [weakSelf showVCR:NO animated:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            [kAppDelegate.gameScene setSoundVolume];

            [kAppDelegate resumeMusic];

            [kAppDelegate.gameScene enablePause:NO];
            [weakSelf blurScene:NO];
        });
    }];


    //weakSelf.paused = YES;
    //kAppDelegate.gameScene.paused = YES;
    [kAppDelegate.gameScene enablePause:YES];
    [weakSelf blurScene:YES];


    weakSelf.labelScroll.hidden = YES;

    kAppDelegate.alertView.transitionStyle = kAlertStyle;
    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical

    [kAppDelegate stopMusic];

    //force
    //stop sounds
    [kAppDelegate.gameScene stopAllSounds];

    //modes
    kAppDelegate.alertView.flashMode = NO;
    kAppDelegate.alertView.soundMode = NO;

    //test
    [kAppDelegate.alertView show:YES];

    if(sender)
        [kAppDelegate playSound:kClickSound];

    [self showVCR:YES animated:YES];

    [kAppDelegate.gameScene hideArrowBlock];
}

- (void)showCommercial {

    //test youtube

    /*[self presentViewController:kAppDelegate.videoController animated:false completion:^{
     //nothing

     }];*/


    if(kAppDelegate.titleController.menuState == menuStateVideo)
        return;

    //exists?
    NSFileManager *fileManager = [[NSFileManager alloc] init]; //[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *moviePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:kCommercialName];
    if(![fileManager fileExistsAtPath:moviePath]) {
        return;
    }

    self.skipFade = NO;

    [self enableButtons:NO];

    //[kAppDelegate playSound:kClickSound];

    kAppDelegate.titleController.menuState = menuStateVideo;

    [self fadeIn];
    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        kAppDelegate.videoController.previousViewController = self;

        [kAppDelegate setViewController:kAppDelegate.videoController];
    });

    return;
}


- (IBAction)adButtonPressed:(id)sender
{
    //just to go premium view
    self.skipFade = NO;
    [self enableButtons:NO];
    //[kAppDelegate playSound:kClickSound];

    kAppDelegate.titleController.menuState = menuStatePremium;

    [self fadeIn];
    float secs2 = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        kAppDelegate.premiumController.backToGame = YES;
        [kAppDelegate setViewController:kAppDelegate.premiumController];
    });

    return;

#if 0
    //offline
    if(![kHelpers checkOnline]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        return;
    }

    SKProduct *product = nil;
    NSString *whichProduct = kIAP_NoAds;
    //find product
    for(SKProduct *tempProduct in [IAPShare sharedHelper].iap.products) {
        //for(SKProduct *tempProduct in kAppDelegate.iapProducts) {
        if([tempProduct.productIdentifier isEqualToString:whichProduct]) {
            product = tempProduct;
            break;
        }
    }

    //invalid?
    if(!product) {
        [kAppDelegate getIAP];
        [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
    }


    //alert
    __weak typeof(self) weakSelf = self;

    //ask
    //kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"No Ads"
    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"VIP"
                                                     andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringIAPMessageNoAds")]];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringIAPMessageCancel")
                                          type:kAlertButtonOrange
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];
                                           //rien
                                       }];


    //NSString *okString = [NSString stringWithFormat:LOCALIZED(@"kStringIAPMessageOK"), [product priceAsString]];
    NSString *okString = [NSString stringWithFormat:LOCALIZED(@"kStringIAPMessageOK"), [product priceAsString]];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(okString)
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           //ok

                                           //buy
#if 1
                                           //SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];

                                           if(product) {
                                               [kHelpers showMessageHud:@"Connecting..."];

                                               [[IAPShare sharedHelper].iap buyProduct:product
                                                                          onCompletion:^(SKPaymentTransaction* trans){

                                                                              [kHelpers dismissHud];

                                                                              if(trans.error)
                                                                              {
                                                                                  //just cancelled
                                                                                  if(trans.error.code == SKErrorPaymentCancelled){
                                                                                      Log(@"SKPaymentTransactionStateFailed: SKErrorPaymentCancelled");
                                                                                  }
                                                                                  else
                                                                                      [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
                                                                              }
                                                                              else if(trans.transactionState == SKPaymentTransactionStatePurchased) {

                                                                                  NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
                                                                                  NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];

                                                                                  [[IAPShare sharedHelper].iap checkReceipt:receiptData AndSharedSecret:kIAP_sharedSecret onCompletion:^(NSString *response, NSError *error) {

                                                                                      //Convert JSON String to NSDictionary
                                                                                      NSDictionary* rec = [IAPShare toJSON:response];
                                                                                      NSString *productIdentifier = trans.payment.productIdentifier;

                                                                                      if([rec[@"status"] integerValue]== 0 && [productIdentifier isEqualToString:whichProduct])
                                                                                      {
                                                                                          //save
                                                                                          [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];

                                                                                          //good
                                                                                          kAppDelegate.adBannerEnabled = NO;

                                                                                          //[kAppDelegate unlockAllBlocks];?
                                                                                          [kAppDelegate unlockVIPBlocks];

                                                                                          //also doubler
                                                                                          [kAppDelegate unlockDoubler];

                                                                                          [kAppDelegate saveState];


                                                                                          [kAppDelegate.gameScene updateAll];

                                                                                          [kAppDelegate playSound:kUnlockSound];
                                                                                          [kAppDelegate playSound:kUnlockSound2];

                                                                                          [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
                                                                                          [self startConfetti];
                                                                                          float secs = kConfettiThanksDuration;
                                                                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                                                              [self stopConfetti];
                                                                                          });
                                                                                      }
                                                                                      else {
                                                                                          [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
                                                                                      }
                                                                                  }];
                                                                              }
                                                                              else if(trans.transactionState == SKPaymentTransactionStateFailed) {
                                                                                  [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
                                                                              }
                                                                          }];//end of buy product
                                           }
                                           else {
                                               [kAppDelegate getIAP];
                                               [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
                                           }
#endif


                                       }];


    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {

    }];

    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

        [self updateBadge];

        [kAppDelegate.gameScene setSoundVolume];
        [kAppDelegate resumeMusic];
        [kAppDelegate.gameScene enablePause:NO];
        [weakSelf blurScene:NO];

        [weakSelf showVCR:NO animated:YES];

    }];

    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
    kAppDelegate.alertView.transitionStyle = kAlertStyle;
    [kAppDelegate.alertView show:YES];

    [self showVCR:YES animated:YES];


    float secs = 0.3f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        [kAppDelegate playSound:@"aaaahhh.caf"];
    });
#endif
}
@end
