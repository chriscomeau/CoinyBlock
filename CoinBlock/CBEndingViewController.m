//
//  CBEndingViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBEndingViewController.h"
#import "CBConfettiView.h"
//#import "NSAttributedString+DDHTML.h"
#import "NSAttributedString+DDHTML.h"

@interface CBEndingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readyLabel;
@property (weak, nonatomic) IBOutlet UILabel *worldLabel;
@property (weak, nonatomic) IBOutlet ZCAnimatedLabel *worldLabel2;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *fullButtton;
@property (weak, nonatomic) IBOutlet UIImageView *coinsImage;
@property (weak, nonatomic) IBOutlet UIImageView *blockImage;
@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIImageView *overlay;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
//@property (weak, nonatomic) IBOutlet UIImageView *glitch;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (strong, nonatomic) NSMutableArray *imageArray1;
@property (nonatomic) int currentBg;
@property (nonatomic) BOOL sharing;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;

@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;
@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;
@property (strong, nonatomic) NSTimer *timerFlash;
@property (strong, nonatomic) NSTimer *timerCoins;
@property (strong, nonatomic) NSTimer *timerSwitch;
@property (strong, nonatomic) NSTimer *timerBg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *readyBottomConstraint;


@property (strong, nonatomic) NSMutableArray *bgImages;

- (IBAction)actionFullButton:(id)sender;

@end


@implementation CBEndingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [kHelpers loopInBackground];

    [kAppDelegate scaleView:self.view];

    //corner
    [kAppDelegate cornerView:self.view];

    [UIView setAnimationsEnabled:NO];

    //dark
    self.darkImage.alpha = 0;

    //button more alpha
    self.shareButton.alpha = 0.8f;

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

    self.worldLabel2.font = self.worldLabel.font;
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


    self.worldLabel.text = LOCALIZED(@"kStringEnding");

    if(kAppDelegate.deathCount == 0)
    {
      //special no death endingCount
      self.worldLabel.text = LOCALIZED(@"kStringEnding2");
    }

    //color text
    NSString *tempString = [kHelpers colorString:self.worldLabel.text];
    NSAttributedString *attrString = [NSAttributedString attributedStringFromHTML:tempString
                                                                       normalFont:self.worldLabel.font
                                                                         boldFont:self.worldLabel.font
                                                                       italicFont:self.worldLabel.font];
    //center
    tempString = attrString.string;
    NSMutableAttributedString *attrString2 = [attrString mutableCopy];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attrString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempString length])];
    self.worldLabel.attributedText = attrString2;


    /*
     NSAttributedString *attrString = [NSAttributedString attributedStringFromHTML:@"<font face=\"Avenir-Heavy\" color=\"#FF0000\">This</font> <shadow>is</shadow> <b>Happy bold, <u>underlined</u>, <stroke width=\"2.0\" color=\"#00FF00\">awesomeness </stroke><a href=\"https://www.google.com\">link</a>!</b> <br/> <i>And some italic on the next line.</i><img src=\"car.png\" width=\"50\" height=\"50\" />"
     normalFont:[UIFont systemFontOfSize:12]
     boldFont:[UIFont boldSystemFontOfSize:12]
     italicFont:[UIFont italicSystemFontOfSize:12.0]


     */

    self.worldLabel2.text = self.worldLabel.text;

    self.worldLabel.hidden = NO;
    self.worldLabel2.hidden = YES;

    // a mysterious wizard known as agahim to came
    //through evil magic

    //self.readyLabel.text = @"Press Start"; //@"Let's go!"; //@"Skip"; //[CBSkinManager getRandomReady];
    self.readyLabel.text = @"Thanks for playing!";
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
        self.worldLabel.y = 130;
        self.textTopConstraint.constant = 210;
        self.readyBottomConstraint.constant = 20;
    }
    else if([kHelpers isIphone4Size])
    {
        self.worldLabel.y = 210;
        self.textTopConstraint.constant = 210;
        self.readyBottomConstraint.constant = 10;
    }
    else if ([kHelpers isIphoneX])
    {
        self.worldLabel.y = 210;
        self.textTopConstraint.constant = 278;
        self.readyBottomConstraint.constant = 49;
    }
    else
    {
        self.worldLabel.y = 210;
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

    [self.view bringSubviewToFront:self.curtainLeft];
    [self.view bringSubviewToFront:self.curtainRight];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.whiteBar];

    //[self.view bringSubviewToFront:self.glitch];

    [self.view bringSubviewToFront:self.fullButtton];
    [self.view bringSubviewToFront:self.shareButton];

    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.scanline];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    if(self.sharing)
        return;

    self.overlay.alpha = 1.0f; //0.8f;

    self.logo.hidden = YES; //NO;
    self.logo.alpha = 0.0f;

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
    kAppDelegate.titleController.menuState = menuStateEnding;

    [kHelpers setupGoogleAnalyticsForView:[[self class] description]];

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });


    //music
    //[kAppDelegate playMusic:@"intro1.mp3" andRemember:YES];
    //[kAppDelegate playMusic:kMusicNameLevelup andRemember:YES];
    [kAppDelegate playMusic:@"ending.mp3" andRemember:YES];

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

    self.readyLabel.alpha = 0.0f;
    self.worldLabel.alpha = 0.0f;
    self.shareButton.alpha = 0.0f;

    //self.glitch.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if(self.sharing)
        return;

    //inc ending
    kAppDelegate.numEndings++;

    [kAppDelegate unlockBlock:kCoinTypeBrain];

    [kAppDelegate saveState];
    [kAppDelegate dbIncEnding];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

		//achievement
		[kAppDelegate reportAchievement:kAchievement_ending];

        [kAppDelegate playSound:kUnlockSound];
        [self startConfetti];

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

        self.logo.alpha = 0.0f;

        [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.worldLabel.alpha = 1.0f;
            self.readyLabel.alpha = 1.0f;

            self.shareButton.alpha = 1.0f;

            //self.logo.alpha = 1.0;

        } completion:nil];

        [UIView animateWithDuration:2.0 delay:2.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.logo.alpha = 1.0;

        } completion:nil];

    });


    //state
    kAppDelegate.playedWelcomeAlert = YES;
    [kAppDelegate saveState];

    [self enableButtons:YES];

    float secs = 0.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self resetTimer];
        //[self enableButtons:YES];
    });

    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //gif
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"glitch" withExtension:@"gif"];
        self.glitch.image = [UIImage animatedImageWithAnimatedGIFURL:url];

        self.glitch.hidden = NO;
    });
	*/

}


-(void)actionTimerCoins:(NSTimer *)incomingTimer
{
    [self showCoins];
}

- (void) actionTimerBg:(NSTimer *)incomingTimer
{
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if(self.sharing)
        return;

    [kAppDelegate saveState];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    [self stopConfetti];
    [self stopCoins];
    [self stopShake];
    [self stopWhiteBar];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.timerFlash invalidate];
    self.timerFlash = nil;

    [self.timerSwitch invalidate];
    self.timerSwitch = nil;

    [self.timerCoins invalidate];
    self.timerCoins = nil;

    [self.timerBg invalidate];
    self.timerBg = nil;

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
    if(kAppDelegate.titleController.menuState != menuStateEnding)
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


- (void)resetTimer{

    [self.timerFlash invalidate];
    self.timerFlash = nil;

    float interval = kFlashArrowsInterval;

    self.timerFlash = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerFlash:) userInfo:@"actionTimerFlash" repeats:YES];

    //disabled
    //interval = 60.0f; //1m
    //self.timerSwitch = [NSTimer scheduledTimerWithTimeInterval:interval target:self
    //                                                 selector:@selector(actionTimerSwitch:) userInfo:@"actionTimerSwitch" repeats:NO];

    interval = 1.5f;
    self.currentBg = 1; //force second one
    self.timerBg = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                  selector:@selector(actionTimerBg:) userInfo:@"actionTimerBg" repeats:YES];


    interval = 15.0f;
    self.timerCoins = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                  selector:@selector(actionTimerCoins:) userInfo:@"actionTimerBg" repeats:YES];



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
    self.confettiView.hidden = NO;
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
    /*if([kHelpers isIpad])
    {
        self.brainImage.y = 68;
    }
    else
    {
        self.brainImage.y = 88;
    }*/

    self.blockImage.alpha = 0.0f;

    float distance = -3.0f;
    CGPoint origin = self.blockImage.center;
    CGPoint target = CGPointMake(self.blockImage.center.x, self.blockImage.center.y+distance);
    CABasicAnimation *bounce = [CABasicAnimation animationWithKeyPath:@"position.y"];
    bounce.duration = 0.5f;
    bounce.fromValue = [NSNumber numberWithInt:origin.y];
    bounce.toValue = [NSNumber numberWithInt:target.y];
    bounce.repeatCount = HUGE_VALF;
    bounce.autoreverses = YES;
    [self.blockImage.layer addAnimation:bounce forKey:@"position"];

}

-(void)stopShake
{

    [self.blockImage.layer removeAllAnimations];

}

-(void)showCoins
{
    [self.coinsImage.layer removeAllAnimations];

    //CGRect screenRect = [kHelpers getScreenRect];

    //coins
    CABasicAnimation *translate;
    translate = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translate.fromValue = [NSNumber numberWithFloat:-self.coinsImage.frame.size.height + 200];//[NSNumber numberWithFloat:-100]; //

    int distance = 2000;
    translate.toValue = [NSNumber numberWithFloat:distance];

    translate.duration = 100; //60;
    translate.repeatCount = 0;
    [self.coinsImage.layer removeAllAnimations];

    self.coinsImage.y = 0;

    self.coinsImage.hidden = NO;
    [self.coinsImage.layer addAnimation:translate forKey:@"10"];

    //+1
    /*CABasicAnimation *translate2;
    translate2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translate2.fromValue = [NSNumber numberWithFloat:20];

    distance = -1500;
    translate2.toValue = [NSNumber numberWithFloat:distance];

    translate2.duration = 100;
    translate2.repeatCount = 0;*/
}

-(void)stopCoins {
    [self.coinsImage.layer removeAllAnimations];
}

- (IBAction)shareButtonPressed:(id)sender
{
    //[kAppDelegate playSound:kClickSound];

    [kAppDelegate dbIncShare];

    NSString *textToShare = LOCALIZED(@"kStringShareMessage");
    NSURL *url = [NSURL URLWithString:kAppStoreURL];
    NSString *subject = LOCALIZED(@"kStringShareSubject");

    UIImage *image = [kHelpers takeScreenshot:self.view];
   	//UIImage *image = [UIImage imageNamed:@"icon120"];

    NSArray *objectsToShare = nil;
    if(image)
        objectsToShare = @[textToShare, url, image];
    else
        objectsToShare = @[textToShare, url];

    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];

    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   //UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];

    activityVC.excludedActivityTypes = excludeActivities;

    [activityVC setCompletionWithItemsHandler:
     ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
         self.sharing = NO;
         if(completed)
         {
		 	//achievement
			[kAppDelegate reportAchievement:kAchievement_share];

             //unlock emoji skin
             [kAppDelegate unlockBlock:kCoinTypeEmoji];
         }
     }];

    //email subject
    [activityVC setValue:subject forKey:@"subject"];

    self.sharing = YES;

    //ipad crash
    if([kHelpers isIpad])
    {
        activityVC.popoverPresentationController.sourceRect = ((UIButton*)sender).frame;
        activityVC.popoverPresentationController.sourceView = self.view;
        activityVC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionDown;
    }

    [self presentViewController:activityVC animated:YES completion:^{
        //nothing
        Log(@"done sharing");

    }];

}

- (void) actionShare:(id)sender {
    [kAppDelegate playSound:kClickSound];

    //share
    [self shareButtonPressed:sender];
}

@end
