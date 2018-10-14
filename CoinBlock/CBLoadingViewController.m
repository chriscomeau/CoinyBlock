//
//  CBLoadingViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "Config.h"
#import "CBLoadingViewController.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/xattr.h>
#import "NSAttributedString+DDHTML.h"
#import "ExtAudioConverter.h"

@interface CBLoadingViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (nonatomic, strong) IBOutlet UIImageView *shineImageView;
@property (nonatomic, strong) IBOutlet UIImageView *skyriserLogo;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageSplash;
@property (strong, nonatomic) IBOutlet UIImageView *splashMiniShine;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner2Shadow;
@property (weak, nonatomic) IBOutlet UIImageView *spinImage;
@property (weak, nonatomic) IBOutlet UIImageView *spinImageShadow;
@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (weak, nonatomic) IBOutlet UIImageView *blockImage;
@property (weak, nonatomic) IBOutlet UIImageView *coinsImage;
@property (weak, nonatomic) IBOutlet UIImageView *enemiesImage;
@property (weak, nonatomic) IBOutlet UIImageView *seal;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UIImageView *floppy;
@property (weak, nonatomic) IBOutlet UIImageView *logoSubtitle;
@property (nonatomic, strong) IBOutlet UIImageView *overlay;
@property (nonatomic, strong) IBOutlet UIImageView *vcr;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;
@property (nonatomic, strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic, strong) IBOutlet UILabel *tip;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UILabel *labelSubtitle;
@property (nonatomic, strong) IBOutlet UIView *barFlat;
@property (strong, nonatomic) NSTimer *timerVCR;
@property (strong, nonatomic) NSTimer *timerDots;
@property (strong, nonatomic) NSTimer *timerProgress;
@property (strong, nonatomic) NSTimer *timerBounce;
@property (strong, nonatomic) NSTimer *timerMaxConvert;
@property (strong, nonatomic) NSArray *loadingArray;
@property (nonatomic) int currentLoading;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintSpinner2x;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintSpinner2y;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *constraintBarFlatWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blockWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blockHeight;

@property (strong, nonatomic) IBOutlet NSMutableArray *soundsToConvert;
@property (nonatomic) int soundsTotal;
@property (nonatomic) int soundsReady;
@property (nonatomic) int loadingDots;
@property (nonatomic) float progress;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blockYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;

@end


@implementation CBLoadingViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [kAppDelegate scaleView:self.view];

    self.currentLoading = 0;

    //random in game
    if(kAppDelegate.launchInGame)
    {
        //random
        if(kAppDelegate.isRandomSkin) {
            NSMutableArray *randomArray = [NSMutableArray array];
            for(int i=0;i<kNumSkins;i++) {
                BOOL enabled  = [kAppDelegate isBlockEnabledIndex:i] && [kAppDelegate isBlockRemoteEnabledIndex:i];
                if(enabled)
                    [randomArray addObject:[NSNumber numberWithInt:i]];
            }

            int randomIndex = [[randomArray randomObject] intValue];
            //set skin
            [kAppDelegate setSkin:randomIndex];
        }

    }


    //get random skin
    if(kAppDelegate.isRandomSkin)
    {
        NSMutableArray *randomArray = [NSMutableArray array];
        for(int i=0;i<kNumSkins;i++) {
            BOOL enabled  = [kAppDelegate isBlockEnabledIndex:i] && [kAppDelegate isBlockRemoteEnabledIndex:i];
            if(enabled)
                [randomArray addObject:[NSNumber numberWithInt:i]];
        }
        int randomIndex = [[randomArray randomObject] intValue];
        [kAppDelegate setSkin:randomIndex];
    }

    self.view.clipsToBounds = YES;

    self.view.backgroundColor = [UIColor whiteColor];


    //mini shine
    self.splashMiniShine =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,40,40)]; //50
    self.splashMiniShine.image = [UIImage imageNamed:@"ray8"];
    self.splashMiniShine.clipsToBounds = YES;
    self.splashMiniShine.contentMode = UIViewContentModeScaleAspectFit;
    self.splashMiniShine.alpha = 0.0f;
    [self.view addSubview:self.splashMiniShine];


    //corner
    [kAppDelegate cornerView:self.view];

    //set set
    //kAppDelegate.loadingController = self;

    self.darkImage.alpha = 0.0f;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    //bar flat
    self.barFlat.backgroundColor = [UIColor colorWithHex:0xEFB73C];
    self.barFlat.hidden = YES; //disdabled
    self.barFlat.alpha = 1.0f;

    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = [[UIColor whiteColor] CGColor];
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 0.5f);
    //[self.barFlat.layer addSublayer:upperBorder];


    //subscribe to resume updates
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneNotification:)
                                                 name:kLoadingDoneNotifications
                                               object:nil];*/

    //background, themed
    if([CBSkinManager getSkinBackground])
        self.bgImage.image = [UIImage imageNamed:[CBSkinManager getSkinBackground]];
    else
        self.bgImage.image = [UIImage imageNamed:@"background1"];

    if([kHelpers isIphone5Size]) {
        self.bgImageSplash.image = [UIImage imageNamed:@"Default2-568h"];
        //self.overlay.image = [UIImage imageNamed:@"Loading_overlay-568h"];

    }
    else if([kHelpers isIphoneX]) {
        self.bgImageSplash.image = [UIImage imageNamed:@"Default2-iPhoneX"];
        //self.overlay.image = [UIImage imageNamed:@"Loading_overlay-568h"];

    }
    else {
        self.bgImageSplash.image = [UIImage imageNamed:@"Default2"];
        //self.overlay.image = [UIImage imageNamed:@"Loading_overlay"];
    }


    if(kVCRAnimEnabled) {
        self.vcr.animationImages = @[[UIImage imageNamed:@"vcr"], [UIImage imageNamed:@"vcr2"]];
        self.vcr.animationDuration = kVCRAnimDuration;
        self.vcr.animationRepeatCount = 0;
    }

    //disable, reset
    BOOL remoteEnabled = [kAppDelegate isBlockRemoteEnabledIndex:(int)[kAppDelegate getSkin]];
    BOOL enabled  = [kAppDelegate isBlockEnabledIndex:(int)[kAppDelegate getSkin]];

    if(!remoteEnabled || !enabled) {
        [kAppDelegate setSkin:kCoinTypeDefault];

    }

    self.blockImage.image = [CBSkinManager getBlockImage];

    //self.blockImage.alpha = 0.5f;

    int shadowOffset = 2;
    UIColor *shadowColor = kTextShadowColor;

    //version
    //year
    //NSDate *date = [NSDate date];
    //NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    //NSDateComponents *components = [[NSCalendar currentCalendar] components:componentFlags fromDate:date];
    int year = kCopyrightYear; //(int)[components year];

    //version
    /*self.versionLabel.text = [NSString stringWithFormat:@"Version %@ (%@), Copyright © %d",
     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
     year];*/

    self.versionLabel.text = [NSString stringWithFormat:@"Version %@ (%@), Skyriser Media, %d",
                              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                              year];

    //self.versionLabel.font = [UIFont fontWithName:kFontName size:10*kFontScale];
    self.versionLabel.font = [UIFont fontWithName:@"OrangeKid-Regular" size:20];

    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.textColor = [UIColor whiteColor];
    self.versionLabel.alpha = 0.4f;
    self.versionLabel.hidden = YES;

    //subtitle
    self.labelSubtitle.textColor = [UIColor whiteColor];
    //self.labelSubtitle.font = [UIFont fontWithName:kFontNamePlus size:13.0f];
    self.labelSubtitle.font = [UIFont fontWithName:@"OrangeKid-Regular" size:26.0f];
    self.labelSubtitle.hidden = YES; //NO;
    self.labelSubtitle.alpha = 0.8f;
    self.labelSubtitle.shadowColor = shadowColor;
    self.labelSubtitle.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.labelSubtitle.text = @"Retro Clicker";

    //seal
    self.seal.hidden = YES;

    //loading

    self.loadingLabel.hidden = NO;
    //self.loadingLabel.font = [UIFont fontWithName:kFontName size:12*kFontScale];
    self.loadingLabel.font = [UIFont fontWithName:@"OrangeKid-Regular" size:26];
    //self.loadingLabel.font = [UIFont fontWithName:kFontNameBlocky size:26];


    self.loadingLabel.alpha = 0.8f;
    self.loadingLabel.textColor = RGB(255,255,255); //white
    self.loadingLabel.shadowColor = shadowColor;
    self.loadingLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.loadingLabel.numberOfLines = 1;
    //self.loadingLabel.text = @"";

    /*if(kAppDelegate.launchCount == 0)
        self.loadingLabel.text = LOCALIZED(@"kStringLoadingPreparing");
    else*/
        self.loadingLabel.text = @"Loading..."; //[self getRandomLoadingLabel];

    //tip
    self.tip.hidden = NO;
    //self.tip.font = [UIFont fontWithName:kFontName size:12*kFontScale];
    self.tip.font = [UIFont fontWithName:@"OrangeKid-Regular" size:20];
    self.tip.textColor = RGB(255,255,255); //white
    //self.tip.textColor = RGB(200,200,200); //grey
    //self.tip.textColor = RGB(255,255,0); //yellow

    self.tip.shadowColor = shadowColor;
    self.tip.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.tip.alpha = 0.9f; //0.7f;
    self.tip.lineBreakMode = NSLineBreakByWordWrapping;
    self.tip.numberOfLines = 0;


    //force test
    //message = @"Tip: Give it a little tappy... tap-tap-taperoo",

    //int count = (int)kAppDelegate.launchCount;
    /*if(count == 0)
        self.tip.text = @"";
    else if(count == 1) //first real quote
        self.tip.text = LOCALIZED(@"kStringLoadingFirst");
    else*/
        self.tip.text = [CBSkinManager getRandomTip];


    //color text
    NSString *tempString = [kHelpers colorString:self.tip.text];
    NSAttributedString *attrString = [NSAttributedString attributedStringFromHTML:tempString
                                                                       normalFont:self.tip.font
                                                                         boldFont:self.tip.font
                                                                       italicFont:self.tip.font];
    //center
    tempString = attrString.string;
    NSMutableAttributedString *attrString2 = [attrString mutableCopy];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    paragraphStyle.minimumLineHeight = paragraphStyle.maximumLineHeight = 20.0f;
    [attrString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempString length])];
    self.tip.attributedText = attrString2;

    //self.spinner.color = RGB(248,216,0); //yellow
    self.spinner.color = RGB(255,255,255); //white
    self.spinner2.color = RGB(255,255,255); //white
    self.spinner2Shadow.color = RGBA(0,0,0, 1.0f); //white

    //shadow
    /*self.spinner.layer.shadowColor = RGBA(0.0f,0.0f,0.0f, 0.8f).CGColor;
    self.spinner.layer.shadowOffset = CGSizeMake(2, 2);
    self.spinner2.layer.shadowColor = RGBA(0.0f,0.0f,0.0f, 0.8f).CGColor;
    self.spinner2.layer.shadowOffset = CGSizeMake(2, 2);
     */

    self.spinner.alpha = 1.0f;
    self.spinner2.alpha = 1.0f;
    self.spinner2Shadow.alpha = 0.5f;

    self.spinImage.alpha = 1.0f;

    self.bgImage.hidden = NO;
    self.bgImageSplash.hidden = NO;
    self.blockImage.hidden = NO;
    self.overlay.hidden = NO;

    self.spinner.hidden =  YES;
    self.spinner2.hidden =  YES;
    self.spinner2Shadow.hidden =  YES;
    self.spinImage.hidden =  YES;

    self.skyriserLogo.hidden =  YES;

    [self setupWhiteBar];

    [self.view bringSubviewToFront:self.bgImage];
    [self.view bringSubviewToFront:self.titleImage];
    [self.view bringSubviewToFront:self.shineImageView];
    [self.view bringSubviewToFront:self.enemiesImage];
    [self.view bringSubviewToFront:self.coinsImage];
    [self.view bringSubviewToFront:self.blockImage];
    [self.view bringSubviewToFront:self.seal];
    [self.view bringSubviewToFront:self.spinImageShadow];
    [self.view bringSubviewToFront:self.spinImage];
    [self.view bringSubviewToFront:self.spinner];
    [self.view bringSubviewToFront:self.spinner2Shadow];
    [self.view bringSubviewToFront:self.spinner2];
    [self.view bringSubviewToFront:self.skyriserLogo];
    [self.view bringSubviewToFront:self.loadingLabel];
    [self.view bringSubviewToFront:self.labelSubtitle];

    [self.view bringSubviewToFront:self.overlay]; //coins

    [self.view bringSubviewToFront:self.logoSubtitle];
    [self.view bringSubviewToFront:self.logo];
    [self.view bringSubviewToFront:self.floppy];

    [self.view bringSubviewToFront:self.tip];
    [self.view bringSubviewToFront:self.versionLabel];
    [self.view bringSubviewToFront:self.barFlat];
    [self.view bringSubviewToFront:self.bgImageSplash];

    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.vcr];
    [self.view bringSubviewToFront:self.scanline];

    //rays
    self.shineImageView.alpha = 0.2f;
    self.shineImageView.hidden = YES;

    //audio
    //[SoundManager sharedManager].allowsBackgroundMusic = YES;
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategorySoloAmbient error:NULL]; //stop bg music/podcast
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:NULL]; //keep bg music/podcast

    //sounds
    //[self preloadSounds];

    //block
    self.blockImage.image = [CBSkinManager getBlockImage];


    //splash bigger
    //self.bgImageSplash.transform=CGAffineTransformMakeScale(1.2f, 1.2f);
}

/*
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
*/

-(void)preloadSounds {


    //[[SoundManager sharedManager] prepareToPlay];

		//session, after
		[kAppDelegate setupAudioSession];

		[[SoundManager sharedManager] prepareToPlayWithSound:kClickSound];

    //set volume
    [kAppDelegate setSoundVolume:kAppDelegate.soundVolume];
    [kAppDelegate setMusicVolume:kAppDelegate.musicVolume];


}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

	[self setupFade];

    //[self resetTimer];

	//reset
    self.floppy.hidden = YES;
    self.floppy.alpha = 0.8f;

    self.loadingLabel.hidden = NO;

    self.vcr.hidden = YES;
    self.vcr.alpha = 0.0f;
    [self.vcr startAnimating];

    [self moveSpinner];

    //hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [self updateProgressBar:0];
    //fade out splash
    [self fadeInLoading];

    //after fade
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //[self showWhiteBar];
    });


    [self showCoins];
    [self showEnemies];

	//logo reset
	//self.logo.alpha = 0.0f;

    [self addLogoAnimation];



    //bg anim
#if 0
    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSNumber numberWithFloat:1.0f];
    //scale.toValue = [NSNumber numberWithFloat:-M_PI*2];
    scale.toValue = [NSNumber numberWithFloat:2.0f];
    scale.duration = 3.0f;
    //scale.repeatCount = 1;
    scale.autoreverses = NO;
    [self.bgImageSplash.layer removeAllAnimations];
    [self.bgImageSplash.layer addAnimation:scale forKey:@"scale"];
#endif

#if 0
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    //rotate.toValue = [NSNumber numberWithFloat:-M_PI*2];
    rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.duration = 64; //32;
    rotate.repeatCount = HUGE_VALF;
    [self.bgImageSplash.layer removeAllAnimations];
    [self.bgImageSplash.layer addAnimation:rotate forKey:@"rotate"];
#endif

#if 0
    //scart scalling
    //CGRect frame = self.bgImageSplash.frame;

    [UIView animateWithDuration:8.0f
                          delay:0.0f
                        //options:UIViewAnimationOptionBeginFromCurrentState
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:(void (^)(void)) ^{
                         self.bgImageSplash.transform=CGAffineTransformMakeScale(1.2f, 1.2f);
                         //self.bgImageSplash.transform=CGAffineTransformMakeTranslation(0.0f, -50.0);

                         //self.bgImageSplash.frame = frame;
                     }
                     completion:^(BOOL finished){
                         //self.bgImageSplash.transform=CGAffineTransformIdentity;
                     }];
#endif

}

-(void)addLogoAnimation
{
    //logo scale
    [self.logo.layer removeAllAnimations];

    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSNumber numberWithFloat:1.02f];
    scale.toValue = [NSNumber numberWithFloat:1.0f];
    scale.duration = 0.3f;
    scale.repeatCount = HUGE_VALF;
    scale.autoreverses = YES;
    [self.logo.layer addAnimation:scale forKey:@"scale"];

    //also fade
    #if 0
    if(NO)
    {
        CABasicAnimation* fadein= [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadein.fromValue = [NSNumber numberWithFloat:0.0f];
        fadein.toValue = [NSNumber numberWithFloat:1.0f];
        //delay
        fadein.beginTime = CACurrentMediaTime() + 0.0f;
        //fix ending
        fadein.fillMode = kCAFillModeForwards;
        fadein.removedOnCompletion = NO;
        [fadein setDuration:4];
        [self.logo.layer addAnimation:fadein forKey:@"opacity"];
    }
    #endif

    [self.loadingLabel.layer removeAllAnimations];
    [self.loadingLabel.layer addAnimation:scale forKey:@"scale"];
}

-(NSString*)getRandomLoadingLabel
{
    //force
   	//return LOCALIZED(@"kStringLoading");

    //if(kAppDelegate.level <= 2)
    //    return LOCALIZED(@"kStringLoading");

    if(!self.loadingArray)
        self.loadingArray = [@[
               // LOCALIZED(@"kStringLoading"), //Loading...
                //LOCALIZED(@"kStringLoading"), //Loading...
                //LOCALIZED(@"kStringLoading"), //Loading...

                /*@"Booting...",
                @"Powering up...",
                @"Checking BIOS...",
                @"Zapping PRAM...",
                @"Loading extensions...",
                @"Starting up...",*/

				//Mac
				//@"Loading Extensions...",
                //@"Loading Control Panels...",

                //@"Loading Workbench...",
                //@"\"LOAD\"*,8,1",

              	//@"verifying 1.44 mb",
              	//@"press f2 to enter setup",
				//@"plug and play",

				@"Loading Pixels...",
				@"Loading Assembly...",
				@"Loading Double buffers...",
				@"Loading Sprites...",
				@"Loading L2 cache...",
				@"Loading Gamma...",
				//@"Loading QSound...", //capcom

				//resedit
				//@"Loading PAT resources...",
				//@"Loading PICT resources...",
				//@"Loading ICON resources...",
				//@"Loading BNDL resources...",

				@"Loading ROMs...",
        @"Loading Floppies...",
				@"Loading Color palettes...",
				@"Loading Lookup tables...",
				@"Loading Gradients...",
				@"Loading Bits...",
				@"Loading Bytes...",
				@"Loading Bitmaps...",
				@"Loading Sound effects...",
				@"Loading Voice samples...",
				@"Loading Music...",
				@"Loading Coordinate system...",
				@"Loading Blocks...",
				@"Loading Coins...",
				@"Loading Enemies...",
				@"Loading Clouds...",
				@"Loading AI...",
				@"Loading Power-ups...",
				@"Loading Backgrounds...",
				@"Loading Fonts...",
				@"Loading Save slots...",
				@"Loading Cheat codes...",
				@"Loading Easter eggs...",
				@"Loading MIDI files...",
				@"Loading WAD files...", //doom
				@"Loading Blast processing...",
        @"Loading Super FX...",
        @"Loading Mode 7...",

				//http://www.h6.dion.ne.jp/~fff/old/technique/mac/Mac.html
				@"Loading Game Sprockets...",
				@"Loading Dirty rectangles...",
				//@"Loading Page-flipping...",
				@"Loading CopyBits...",
				@"Loading ScreenBits...",
				//@"Loading GWorldPtrs...",
				@"Loading PixMaps...",
				//@"Loading PortBits...",
        @"Loading Tilesets...",

				//c64
				//@"Loading LOAD \"*\",8,1",
				@"Loading SID player...",


				//amiga
				//@"Loading Workbench...",
				@"Loading Guru Meditation...",
				@"Loading Agnus chip...",
				@"Loading Daphne chip...",
				@"Loading Portia chip...",
				@"Loading CLI...",
				@"Loading blitter...",
				@"Loading anti-aliasing...",
				@"Loading trainer...",
				@"Loading DMA...",
				@"Loading playfields...",

				//nes/snes hardware
				@"Loading 6502 processor...",
				@"Loading 65C816 processor...",
        @"Loading SA1 chip...",
        @"Loading Cx4 chip...",
        @"Loading PPU registers...",
        @"Loading OAM...",

        //TA
        @"Loading layer of jank...",

        //pew
        @"Loading bros...",

				//@"Loading Things...",
                //@"Loading Stuff...",
                //@"Loading More things and stuff...",
                //@"Loading blab bla bla...",



            ] shuffledArray];

    self.currentLoading++;

    //return [array randomObject];
    return [self.loadingArray objectAtIndex:self.currentLoading];
}

-(void)enableAutoProgress:(BOOL)enable {

    //Log(@"enableAutoProgress: %d", enable);

    [self.timerProgress invalidate];
    self.timerProgress = nil;
    self.progress = 0.0f;

    [self updateProgressBar:0.0f];

    if(enable) {
        dispatch_async(dispatch_get_main_queue(), ^{

        float interval = 0.1f; //1.0f;
        self.timerProgress = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                            selector:@selector(actionProgress:) userInfo:@"actionProgress" repeats:YES];
        });
    }
    else {
        //nothing

    }
}

-(void)updateProgressBar:(float)pourcentage {

    //self.barFlat

    //Log(@"updateProgressBar: %d", (int)pourcentage);
    //bar
    //pourcentage = 70;

    //[self.view updateConstraintsIfNeeded];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.constraintBarFlatWidth.constant = (float)[kHelpers getScreenRect].size.width * (pourcentage/100.0f);

        //animated
        /*[UIView animateWithDuration:0.1f
             animations:^{
                 [self.barFlat setNeedsLayout];
             }];*/

        [self.view layoutIfNeeded];

    });
}

-(void)startLoading1 {

    //for kMinLoadTime
    kAppDelegate.loadStartDate = [NSDate date];

    //rotate
    [self addShineAnimation];

    //fade out splash
    //[self fadeInLoading];

    //cache
    //if(kAppDelegate.adBannerEnabled) {
       // [Chartboost cacheRewardedVideo:kRewardScreen];
        [kAppDelegate cacheRewardVideos];
    //}

    //give time to layout
    float secs = 0.1f;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[self resetTimer];
			//[self actionTimerVCR:nil];
    });


    [self convertSoundsSetup];
}

-(void)startLoading2 {

    //Log(@"startLoading2");

    [self.timerMaxConvert invalidate];
    self.timerMaxConvert = nil;

    [self enableAutoProgress:YES];


    dispatch_async(dispatch_get_main_queue(), ^{
        // Add transition (must be called after self.loadingLabel has been displayed)
        /*CATransition *animation = [CATransition animation];
        animation.duration = 1.0;
        animation.type = kCATransitionFade;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.loadingLabel.layer addAnimation:animation forKey:@"changeTextTransition"];*/

        // Change the text
        self.loadingLabel.text = @"Loading..."; //[self getRandomLoadingLabel];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [kAppDelegate loadViews];
        });
    });
}

-(void)convertSoundsSetup {

    //setup sounds, session
    [self preloadSounds];


    //play splash sound, launch sound

    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //sound splash

		int wavFilesCount = [kAppDelegate numSoundsInFolder];

		self.soundsToConvert = [@[
															@"aaaahhh.caf",
															@"awh-yeah.caf",
															@"card.caf",
															@"click1.caf",
															@"click2.caf",
															@"click3.caf",
															@"click4.caf",
															@"click5.caf",
															@"clock.caf",
															@"coin_contra.caf",
															@"coin_contra2.caf",
															@"coin_flap.caf",
															@"coin_flap2.caf",
															@"coin_gameboy.caf",
															@"coin_icarus.caf",
															@"coin_icarus2.caf",
															@"coin_mega.caf",
															@"coin_mega2.caf",
                                                            @"coin_mine.caf",
                                                            @"coin_mine2.caf",
                                                           // @"coin_metal.caf",
                                                            //@"coin_metal2.caf",
															//@"coin_montreal.caf",
															//@"coin_montreal2.caf",
//															@"coin_nyan.caf",
//															@"coin_nyan2.caf",
															@"coin_piew.caf",
															@"coin_piew2.caf",
															@"coin_piew3.caf",
															@"coin_reset.caf",
															@"coin_sonic.caf",
															@"coin_ta.caf",
															@"coin_ta2.caf",
															@"coin_wood.caf",
															@"coin_yoshi.caf",
															@"coin_zelda.caf",
//															@"coin_zoella.caf",
//															@"coin_zoella2.caf",
															@"coin1.caf",
															@"coin2.caf",
															@"coin3.caf",
															@"curtain.caf",
															@"curtain2.caf",
															@"death.caf",
															@"explosion1.caf",
                                                            @"explosion2.caf",
                                                            //@"ko.caf",
                                                            @"perfect.caf",
                                                            @"toastie.caf",
                                                            @"toastie_portal.caf",
                                                            @"toastie_trump.caf",
                                                            @"toastieAlert.caf",
                                                            @"eagle.caf",
                                                            //@"snap.caf",
                                                            @"sinistar1.caf",
                                                            @"sinistar2.caf",
                                                            @"sinistar3.caf",
                                                            @"sinistar4.caf",
															@"fireball.caf",
															@"fireball2.caf",
															@"fireworks.caf",
															@"gasp1.caf",
															@"hashtag.caf",
															@"heart_low.caf",
															@"heart_low2.caf",
															@"help.caf",
															@"hmm.caf",
															@"hurt.caf",
															@"intro.caf",
															@"intro2.caf",
															@"joy1.caf",
															@"kiss.caf",
															@"noise.caf",
                                                            @"noise2.caf",
                                                            @"noiseLong.caf",
                                                            @"pause.caf",
                                                            @"smashBell.caf",
															//@"pause2.caf",
															@"pew_fridays.caf",
                                                            @"refill.caf",
                                                            @"comboRise.caf",
                                                            @"potion.caf",
                                                            @"potion2.caf",
															@"rewind.caf",
															@"rewind2.caf",
															//@"shake1.caf",
															//@"shake2.caf",
															@"sigh.caf",
															//@"smb3_1-up.caf",
															//@"smb3_1-up2.caf",
															@"smb3_break_brick_block.caf",
															@"smb3_bump.caf",
															@"smb3_coin_notif.caf",
															@"smb3_coin_notif2.caf",
															@"smb3_coin.caf",
															@"smb3_coin2.caf",
															@"smb3_coin3.caf",
															@"smb3_coin4.caf",
															@"smb3_coin5.caf",
															@"smb3_coin6.caf",
															@"smb3_jump.caf",
															@"smb3_mushroom_appears.caf",
															@"smb3_pause.caf",
															//@"smb3_power-up.caf",
                                                            @"spikeAppear.caf",
                                                            @"spikeAppearMega.caf",
                                                            @"spikeAppear2Mega.caf",
                                                            @"spikeAppearSword.caf",
                                                            @"spikeAppearChain.caf",
                                                            @"spikeAppearGradius.caf",
                                                            @"credit1.caf",
															@"spin1.caf",
															//@"splash.caf",
															//@"splash2.caf",
															//@"splash3.caf",
                                                            //@"splash5.caf",
                                                            @"splash6.caf",
                                                            @"splash7.caf",
                                                            @"harddrive.caf",
															@"starAppear.caf",
															@"starAppear2.caf",
															@"starClick.caf",
															@"starClick2.caf",
															@"starClick3.caf",
															@"starClickBitcoin.caf",
															@"starClickMine.caf",
															//@"starClickMontreal.caf",
															@"starClickPew.caf",
															@"starClickTa.caf",
															@"starClickTa2.caf",
															//@"starClickZoella.caf",
															@"starEmoji.caf",
															@"unclick.caf",
															@"unlock.caf",
															@"warning.caf",
															@"whistle_low.caf",
															@"whistle.caf",
															@"whistle2.caf",
															@"whistle3.caf",
															@"whistle4.caf",
															@"whistle5.caf",
															@"WilhelmScream.caf",
															//@"WilhelmScream2.caf",
															@"wrong_bitcoin.caf",
															@"wrong_emoji.caf",
															@"wrong_flappy.caf",
															@"wrong_mega.caf",
															@"wrong_mine.caf",
															//@"wrong_montreal.caf",
//															@"wrong_nyan.caf",
															@"wrong_pew.caf",
                                                            @"wrong_pew2.caf",
                                                            //@"wrong_pew3.caf",
															@"wrong_sonic.caf",
															@"wrong_ta.caf",
															//@"wrong_zoella.caf",
                                                            @"wrong.caf",
                                                            @"wrong2.caf",
                                                            @"wrong3.caf",
                                                            @"low_beep.caf",
//                                                            @"oldman.caf",
//                                                            @"oldman2.caf",
                                                            @"pan1.caf",
                                                            @"pan2.caf",
                                                            @"pan3.caf",
                                                            @"swoosh.caf",
                                                            @"weakSpot.caf",
                                                            @"weakSpot2.caf",
                                                            @"weakSpotFinish.caf",
                                                            @"buffShield.caf",
                                                            @"buffDoubler.caf",
                                                            @"buffAuto.caf",
                                                            @"buffGrow.caf",
                                                            @"buffShrink.caf",
                                                            @"buffInk.caf",
                                                            //@"secret.caf",
                                                            ///@"roundabout.caf",
                                                            //@"sad_wah.caf",
                                                            @"key1.caf",
                                                            @"key2.caf",
                                                            @"coffee_sip.caf",
                                                            @"buff_repeat.caf",

                                                            @"voice_coinblock.caf",
                                                            @"voice_powerup.caf",
                                                            @"voice_warning.caf",
                                                            @"voice_gameover.caf",
                                                            @"voice_win.caf",
                                                            @"rubber.caf",
                                                            @"lava.caf",
                                                            @"alertchat.caf",
                                                            @"alertchat2.caf",
                                                            @"boss_hit.caf",
                                                            @"boss_die.caf",


                                                            @"voice_amazing.caf",
                                                            @"voice_wow.caf",

                                                            @"voice_auto.caf",
                                                            @"voice_bomb.caf",
                                                            @"voice_grow.caf",
                                                            @"voice_ink.caf",
                                                            @"voice_shrink.caf",
                                                            @"voice_star.caf",
                                                            @"voice_potion.caf",
                                                            @"voice_shield.caf",
                                                            @"voice_doubler.caf",
                                                            @"voice_weak.caf",
                                                            @"voice_heart.caf",

                                                            @"discover.caf",

                                                            @"silence.caf",

                                                            @"cat1.caf",
                                                            @"cat2.caf",
                                                            @"cat3.caf",
                                                            
                                                            @"coin_valentine1.caf",
                                                            @"coin_valentine2.caf",
                                                            @"wrong_valentine.caf",
                                                            
                                                            @"coin_soccer1.caf",

                                                            @"starClickValentine.caf",
															] mutableCopy];


    self.soundsTotal = (int)[self.soundsToConvert count];
    self.soundsReady = 0;


    //check existing files
    if(wavFilesCount < self.soundsTotal)
    {
        //missing files? force
        kAppDelegate.prefSoundsConverted = NO;
    }

    //common group
    NSUserDefaults *prefsCommon = [[NSUserDefaults alloc] initWithSuiteName:kPrefGroupCommon];
    if(!prefsCommon)
    {
        Log(@"***** prefsCommon error");
    }
    
    //sound version

    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:kPrefGroup];
    if([[prefs objectForKey:@"soundVersion"] integerValue] != kSoundVersion)
    {
        kAppDelegate.prefSoundsConverted = NO;
    }
    //save version
    [prefs setObject:@(kSoundVersion) forKey:@"soundVersion"];

    //force
    //kAppDelegate.prefSoundsConverted = NO;

    if(kAppDelegate.launchCount == 0 || kForceLoadSounds || !kAppDelegate.prefSoundsConverted)
    //if(YES)
    {
			//delete all
			[kAppDelegate deleteAllSoundFiles];

			if([kAppDelegate checkDiskSpace]) {

                //max convert
                self.timerMaxConvert = [NSTimer scheduledTimerWithTimeInterval:kLoadForceDoneConvertDelay target:self selector:@selector(actionTimerMaxConvert:) userInfo:@"actionTimerMaxConvert" repeats:NO];

                [self enableAutoProgress:NO];

                //hide tip
                //self.tip.text = @"";
                //self.tip.text = LOCALIZED(@"kStringLoadingWelcome");

                //start convert
				[self convertSoundsNext:NO];
			}
			else {
				//not enough space, error no button and wait/crash
				[kHelpers showAlertWithTitleNoButton:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringLoadingSpace")];

			}
    }
    else {
        //empty
        self.soundsTotal = 0;
        self.soundsReady = 0;
        self.soundsToConvert = [@[] mutableCopy];

        //first real quote
        /*if(kAppDelegate.launchCount == 1) {

        }*/

        //straight to loading
        [self startLoading2];
    }
}

-(BOOL)shouldConvertSounds {
    //return YES;
	return (kAppDelegate.launchCount == 0 || kForceLoadSounds || !kAppDelegate.prefSoundsConverted);
}

-(void)convertSoundsNext:(BOOL)inc {

    [kHelpers loopInBackground];

    if(inc) {
        self.soundsReady++;

        float percent = self.soundsReady /(self.soundsTotal/100.0f);
        [self updateProgressBar:percent];
    }

    //label count
    if([self shouldConvertSounds]) {

        dispatch_async(dispatch_get_main_queue(), ^{
            // Change the text
            //self.loadingLabel.text = [NSString stringWithFormat:LOCALIZED(@"kStringLoadingPreparingCount"), self.soundsReady, self.soundsTotal];
            int total = 100; //self.soundsTotal
            int current = ceilf((self.soundsReady*100.0f) / self.soundsTotal);
            if(current > total)
                current = total;

            //self.loadingLabel.text = [NSString stringWithFormat:LOCALIZED(@"kStringLoadingPreparingCount"), current, total];
            self.loadingLabel.text = [NSString stringWithFormat:LOCALIZED(@"kStringLoadingPreparingCount2"), current];
            Log(@"%@", self.loadingLabel.text);
        });
    }

    if(self.soundsToConvert.count > 0) {

        //next
        NSString *soundName = [self.soundsToConvert objectAtIndex:0];
        [self.soundsToConvert removeObjectAtIndex:0];

        //validate .caf
        if([kHelpers isDebug])
          assert([soundName contains:@".caf"]);

        // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [kAppDelegate convertSound:soundName];
            [self convertSoundsNext:YES];
        //});
    }
    else {
        if(self.soundsReady >= self.soundsTotal) {
            //done
			kAppDelegate.prefSoundsConverted = YES;

            //next, start loading
            //main thread
            //self.tip.text = [CBSkinManager getRandomTip];

            //color text
            /*NSString *tempString = [kHelpers colorString:self.tip.text];
            NSAttributedString *attrString = [NSAttributedString attributedStringFromHTML:tempString
                                                                               normalFont:self.tip.font
                                                                                 boldFont:self.tip.font
                                                                               italicFont:self.tip.font];
            //center
            tempString = attrString.string;
            NSMutableAttributedString *attrString2 = [attrString mutableCopy];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            paragraphStyle.minimumLineHeight = paragraphStyle.maximumLineHeight = 20.0f;
            [attrString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempString length])];
            self.tip.attributedText = attrString2;*/

            [self startLoading2];
        }
    }
}


#if 0
-(void)convertSound2:(NSString*)soundName {

    //Log(@"convertSound: soundnamed: %@", soundName);
    assert(![soundName containsString:@".wav"]);
    assert([soundName containsString:@".caf"]);

    NSString *soundNameWav = [soundName stringByReplacingOccurrencesOfString:@".caf" withString:@".wav"];
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];

    NSString *soundPathNew = [kAppDelegate savePath];
    soundPathNew = [soundPathNew stringByAppendingString:soundNameWav];

    //caf exists
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    if([fileManager fileExistsAtPath:soundPath]) {
        //Log(@"soundnamed: %@, exist", soundName );

        //delete?
        if([self shouldConvertSounds])
        {

            if([fileManager fileExistsAtPath:soundPathNew])
            {
                //delete
                if ([fileManager fileExistsAtPath:soundPathNew])
                {
                    [fileManager removeItemAtPath:soundPathNew error:nil];
                }
            }
        }


        //check wav
        if([fileManager fileExistsAtPath:soundPathNew])
        {
            //wav exists
            //all set
            //Log(@"wav exists");

            //test delete
            if ([fileManager fileExistsAtPath:soundPathNew])
            {
                [fileManager removeItemAtPath:soundPathNew error:nil];
            }

            [self convertSoundsNext:YES];
        }
        else
        {
            //doesn't exist, convert it

            NSString *cafFilePath = soundPath;

            NSURL *assetURL = [NSURL fileURLWithPath:cafFilePath];
            AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];

            NSError *assetError = nil;
            AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
                                                                       error:&assetError];

            if (assetError)
            {
                NSLog (@"convertSound: error: %@", assetError);
                return;
            }

            AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                                      assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                                      audioSettings: nil];
            if (! [assetReader canAddOutput: assetReaderOutput])
            {
                NSLog (@"can't add reader output... die!");
                return ;
            }
            [assetReader addOutput: assetReaderOutput];

            //NSString *title = @"title";
            //NSArray *docDirs = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
            //NSString *docDir = [docDirs objectAtIndex: 0];
            //NSString *wavFilePath = [[docDir stringByAppendingPathComponent :title] stringByAppendingPathExtension:@"wav"];

            NSString *wavFilePath = soundPathNew;
            if ([[NSFileManager defaultManager] fileExistsAtPath:wavFilePath])
            {
                [[NSFileManager defaultManager] removeItemAtPath:wavFilePath error:nil];
            }
            NSURL *exportURL = [NSURL fileURLWithPath:wavFilePath];
            AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
                                                                  fileType:AVFileTypeWAVE
                                                                     error:&assetError];
            if (assetError)
            {
                NSLog (@"error: %@", assetError);
            }

            AudioChannelLayout channelLayout;
            memset(&channelLayout, 0, sizeof(AudioChannelLayout));
            channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
            NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                            [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                            [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                            [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                            [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                            [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                            [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                            [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                            nil];
            AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                                      outputSettings:outputSettings];
            if ([assetWriter canAddInput:assetWriterInput])
            {
                [assetWriter addInput:assetWriterInput];
            }
            else
            {
                NSLog (@"can't add asset writer input... die!");
            }

            assetWriterInput.expectsMediaDataInRealTime = NO;

            [assetWriter startWriting];
            [assetReader startReading];

            AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
            CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
            [assetWriter startSessionAtSourceTime: startTime];

            __block UInt64 convertedByteCount = 0;
            dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);

            [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                                    usingBlock: ^{

                 while (assetWriterInput.readyForMoreMediaData)
                 {
                     CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
                     if (nextBuffer)
                     {
                         // append buffer
                         [assetWriterInput appendSampleBuffer: nextBuffer];
                         convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                         CMTime progressTime = CMSampleBufferGetPresentationTimeStamp(nextBuffer);

                         CMTime sampleDuration = CMSampleBufferGetDuration(nextBuffer);
                         if (CMTIME_IS_NUMERIC(sampleDuration))
                             progressTime= CMTimeAdd(progressTime, sampleDuration);
                         float dProgress= CMTimeGetSeconds(progressTime) / CMTimeGetSeconds(songAsset.duration);
                         Log(@"%f",dProgress);
                     }
                     else
                     {

                         [assetWriterInput markAsFinished];
                         //              [assetWriter finishWriting];
                         [assetReader cancelReading];

                         //done
                         //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                             [self convertSoundsNext:YES];
                         //});



                     }
                 }
             }];
        }

    }
    else {
        Log(@"soundnamed: %@, doesn't exist ********* ", soundName );
        if([kHelpers isDebug])
            assert(0);
        //next
        [self convertSoundsNext:YES];
    }

}
#endif

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    });

    //reset
    self.bgImageSplash.transform = CGAffineTransformMakeScale(1.0f, 1.0f);


    //mini shine
    [self.splashMiniShine.layer removeAllAnimations];
    self.splashMiniShine.alpha = 0.0f;
    self.splashMiniShine.hidden = YES; //NO;
//    self.splashMiniShine.width = 0.0f;
//    self.splashMiniShine.height = 0.0f;

    //move
    self.splashMiniShine.x = 60.0f;
    if([kHelpers isIphone4Size]) {
        //smaller, iphone4, ipad
        self.splashMiniShine.y = 208.0f;
    }
    else {
        self.splashMiniShine.y = 252.0f;
    }



    //rotate shine
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.duration = 1.5f;
    rotate.repeatCount = HUGE_VALF;
    [self.splashMiniShine.layer addAnimation:rotate forKey:@"spinImageRotate"];


    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSNumber numberWithFloat:0.0f];
    scale.toValue = [NSNumber numberWithFloat:1.0f];
    scale.duration = 0.3f;
    //[self.splashMiniShine.layer addAnimation:scale forKey:@"scale"];

    //shine alpha fade in
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:(void (^)(void)) ^{
                         self.splashMiniShine.alpha = 0.5f;
//                         self.splashMiniShine.width = 50.0f;
//                         self.splashMiniShine.height = 50.0f;
                     }
                     completion:^(BOOL finished){
                     }];

    CABasicAnimation *alpha1;
    alpha1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha1.fromValue = [NSNumber numberWithFloat:0.0f];
    alpha1.toValue = [NSNumber numberWithFloat:0.5f];
    alpha1.duration = 0.3f;
    alpha1.autoreverses = NO;
    //alpha1.repeatCount = 0;
    //[self.splashMiniShine.layer addAnimation:alpha1 forKey:@"opacity"];


    //move shine
    [UIView animateWithDuration:1.0f //0.8f
                          delay:0.0f
                        //options:UIViewAnimationOptionCurveLinear
                        options:0
                     animations:(void (^)(void)) ^{
                         self.splashMiniShine.x = 220.0f;

                     }
                     completion:^(BOOL finished){

                         CABasicAnimation *scale;
                         scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                         scale.fromValue = [NSNumber numberWithFloat:1.0f];
                         scale.toValue = [NSNumber numberWithFloat:0.0f];
                         scale.duration = 0.3f;
                         //[self.splashMiniShine.layer addAnimation:scale forKey:@"scale"];

                         CABasicAnimation *alpha2;
                         alpha2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
                         alpha2.fromValue = [NSNumber numberWithFloat:0.5f];
                         alpha2.toValue = [NSNumber numberWithFloat:0.0f];
                         alpha2.duration = 0.3f;
                         alpha2.autoreverses = NO;
                         alpha2.repeatCount = 0;
                         //[self.splashMiniShine.layer addAnimation:alpha2 forKey:@"opacity"];

                         //fade out
                         [UIView animateWithDuration:0.3f
                                               delay:0.0f
                                              //options:UIViewAnimationOptionCurveLinear
                                              options:0
                                          animations:(void (^)(void)) ^{
                                              self.splashMiniShine.alpha = 0.0f;

//                                              self.splashMiniShine.width = 0.0f;
//                                              self.splashMiniShine.height = 0.0f;
                                          }
                                          completion:^(BOOL finished){
                                              //self.splashMiniShine.hidden = YES;
                                          }];
                     }];


#if 1
    if(YES) {
        CGFloat duration = 0.2f;

        //start scalling
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                           //self.bgImageSplash.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                           self.bgImageSplash.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
                         }
                         completion:^(BOOL finished){
                             //splash here instead
                             //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                 //if(!kAppDelegate.inReview)
                             
                                    [kHelpers haptic1];
                                     [kAppDelegate playSound:kSplashSound force:YES];
                             //});

                             //reverse
                             [UIView animateWithDuration:duration
                                                   delay:0.0f
                                                 options:UIViewAnimationOptionBeginFromCurrentState
                                              animations:(void (^)(void)) ^{
                                                  self.bgImageSplash.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
                                              }
                                              completion:^(BOOL finished){
                                              }];
                         }];

    }
#endif

    //same delay for fade in
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kLoadDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self startLoading1];
    });

    //boot, hard drive
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //    [kAppDelegate playMusic:@"boot.mp3" andRemember:NO];
    //});

    //[self addLogoAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    [self stopWhiteBar];
    [self stopCoins];
    [self stopEnemies];

    //parse
    [kAppDelegate dbIncLaunch];

    //parse
    [kAppDelegate dbSaveObjects];

    [self.timerVCR invalidate];
    self.timerVCR = nil;
    self.vcr.hidden = YES;

    [self.timerBounce invalidate];
    self.timerBounce = nil;

    [self.timerProgress invalidate];
    self.timerProgress = nil;

    [self.timerMaxConvert invalidate];
    self.timerMaxConvert = nil;


    [self.timerDots invalidate];
    self.timerDots = nil;

    //force bar
    [self updateProgressBar:100.f];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.shineImageView.layer removeAllAnimations];
}

-(void)viewDidLayoutSubviews {

    //[self moveSpinner];

    if([kHelpers isIpad])
    {
        self.blockYConstraint.constant = 160;
        self.logoTopConstraint.constant = 4;
    }
    else if([kHelpers isIphone4Size])
    {
        self.blockYConstraint.constant = 130;
        self.logoTopConstraint.constant = 4;
    }
    else if([kHelpers isIphoneX])
    {
        self.blockYConstraint.constant = 242;
        self.logoTopConstraint.constant = 54;
    }

    else
    {
        self.blockYConstraint.constant = 202;
        self.logoTopConstraint.constant = 54;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

-(void)moveSpinner {

    self.spinImageShadow.alpha = 0.5f;

    [self.spinImage.layer removeAllAnimations];
    [self.spinImageShadow.layer removeAllAnimations];

    self.spinner2.tintColor = self.spinner2.color = [UIColor whiteColor]; //[kAppDelegate getBlockColor];

    self.spinner.hidden = YES;
    self.spinner2.hidden = YES; //NO;
    self.spinner2Shadow.hidden = YES;

    self.spinImageShadow.hidden = NO;
    self.spinImage.hidden = NO;

    NSString *coinName = [CBSkinManager getCoinBarImageName];

    coinName = [NSString stringWithFormat:@"%@%@", coinName, @"Frame1"];

    self.spinImage.image = [UIImage imageNamed:coinName];
    [self.spinImage.layer removeAllAnimations];

    self.spinner2.alpha = 1.0f;
    self.spinImage.alpha = 1.0f; //0.6


    //count coin
    BOOL shouldSpin = YES;

    //test frame 2?
    coinName = [CBSkinManager getCoinBarImageName];

    UIImage *testImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame2", coinName]];
    if (testImage) {
        shouldSpin = NO;
    }

#if 0
    //animate coin
    //scale
    float duration = 0.3f;
    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    scale.fromValue = [NSNumber numberWithFloat:1.0f];
    scale.toValue = [NSNumber numberWithFloat:-1.0]; //0.1f;
    scale.duration = duration * 2;
    scale.repeatCount = HUGE_VALF;
    scale.autoreverses = YES;
    [self.spinImage.layer removeAllAnimations];
    [self.spinImage.layer addAnimation:scale forKey:@"spinImageRotate"];
#endif

#if 0
    //rotate
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.duration = 1.5f;
    rotate.repeatCount = HUGE_VALF;
    [self.spinImage.layer removeAllAnimations];
    [self.spinImage.layer addAnimation:rotate forKey:@"spinImageRotate"];
#endif

#if 1
    //rotate shadow
    [self.spinImageShadow.layer removeAllAnimations];
    if(!shouldSpin) {

        CABasicAnimation *rotate2;
        rotate2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotate2.fromValue = [NSNumber numberWithFloat:0];
        rotate2.toValue = [NSNumber numberWithFloat:M_PI*2];
        rotate2.duration = 10.0f;
        rotate2.repeatCount = HUGE_VALF;
        [self.spinImageShadow.layer addAnimation:rotate2 forKey:@"spinImageRotate2"];
    }
    else {
        //also scale shadow
        float duration = 0.3f;
        CABasicAnimation *scale;
        scale = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        scale.fromValue = [NSNumber numberWithFloat:1.0f];
        scale.toValue = [NSNumber numberWithFloat:0.5]; //0.1f;
        scale.duration = duration;
        scale.repeatCount = HUGE_VALF;
        scale.autoreverses = YES;
        [self.spinImageShadow.layer addAnimation:scale forKey:@"spinImageRotate"];
    }

#endif

#if 1
    //reset
    //no shadow?
    //self.spinImageShadow.hidden = YES;


    //animate with frames, or scale

    if(shouldSpin) {
        //set 1st frame
        self.spinImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]];

        //scale
        float duration = 0.3f;
        CABasicAnimation *scale;
        scale = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        scale.fromValue = [NSNumber numberWithFloat:1.0f];
        scale.toValue = [NSNumber numberWithFloat:-1.0]; //0.1f;
        scale.duration = duration * 2;
        scale.repeatCount = HUGE_VALF;
        scale.autoreverses = YES;
        [self.spinImage.layer removeAllAnimations];
        [self.spinImage.layer addAnimation:scale forKey:@"spinImageRotate"];
    }
    else {

        self.spinImage.animationImages = @[
                    [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]],
                    [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame2", coinName]],
                    [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame3", coinName]],
                    [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame4", coinName]],
                    ];
        self.spinImage.animationDuration = kCoinAnimRate * self.spinImage.animationImages.count;
        self.spinImage.animationRepeatCount = 0;
        [self.spinImage startAnimating];
    }

#endif

    if([kHelpers isIpad]) {

        self.constraintSpinner2y.constant = 240; //self.view.height-self.spinner2.height - 100;
    }
    else if([kHelpers isIphone4Size]) {

        self.constraintSpinner2y.constant = self.view.height-self.spinner2.height - 200;
    }
    else if([kHelpers isIphoneX]) {
        self.constraintSpinner2y.constant = self.view.height-self.spinner2.height - 420;
    }
    else {
        self.constraintSpinner2y.constant = self.view.height-self.spinner2.height - 220;
    }

    //also block
    if([kHelpers isIpad])
    {
        self.blockWidth.constant = 200.0f;
        self.blockHeight.constant = 200.0f;
    }
    else
    {
        self.blockWidth.constant = 260.0f;
        self.blockHeight.constant = 260.0f;
    }

}

-(void)addShineAnimation {
	//disabled
	return;

#if 0
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    //rotate.toValue = [NSNumber numberWithFloat:-M_PI*2];
    rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.duration = 64; //32;
    rotate.repeatCount = HUGE_VALF;
    [self.shineImageView.layer removeAllAnimations];

    self.shineImageView.hidden = NO;
    [self.shineImageView.layer addAnimation:rotate forKey:@"10"];
#endif
}

-(void)setupFade {
    //self.darkImage.alpha = 1.0f;

	if(kAppDelegate.fadingWhite) {
		self.darkImage.image = [UIImage imageNamed:@"white"];
	}
	else {
		self.darkImage.image = [UIImage imageNamed:@"black"];
	}
}

-(void)fadeIn {

    //hide tip
    self.loadingLabel.hidden = YES;

    //force bar
    [self updateProgressBar:100.f];

    [self setupFade];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.vcr];
    [self.view bringSubviewToFront:self.scanline];

    //reset
    [self.darkImage.layer removeAllAnimations];

    self.darkImage.alpha = 0;
    [UIView animateWithDuration:kFadeDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.darkImage.alpha = 1.0f;
    } completion:nil];

}


-(void)fadeOut {
    [self setupFade];

    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.vcr];
    [self.view bringSubviewToFront:self.scanline];

    //reset
    [self.darkImage.layer removeAllAnimations];

    self.darkImage.alpha = 1.0f;
    [UIView animateWithDuration:kFadeDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.darkImage.alpha = 0;

				//reset fade white
				kAppDelegate.fadingWhite = NO;

    } completion:nil];

}


-(void)fadeInLoading {

    //disabled
   /* self.bgImageSplash.hidden = YES;
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.vcr];
    [self.view bringSubviewToFront:self.scanline];
*/

#if 1
    self.bgImageSplash.hidden = NO;
    [self.view bringSubviewToFront:self.bgImageSplash];
    [self.view bringSubviewToFront:self.splashMiniShine];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.vcr];
    [self.view bringSubviewToFront:self.scanline];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //[self actionTimerVCR:nil];
    });

#if 0
    if(NO) {
        //start scalling
        [UIView animateWithDuration:3.0f
                          delay:0.0f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^{
                         //self.bgImageSplash.transform=CGAffineTransformMakeScale(1.2f, 1.2f);
                         self.bgImageSplash.transform=CGAffineTransformMakeScale(1.1f, 1.1f);
                     }
                     completion:^(BOOL finished){
                         //self.bgImageSplash.transform=CGAffineTransformIdentity;
                     }];

    }
#endif

    //update?
    //self.loadingLabel.text = @"Updating...";

    //remove shine too, before
    [self.splashMiniShine.layer removeAllAnimations];
    self.splashMiniShine.alpha = 0.0f;

    //fade out
    self.bgImageSplash.alpha = 1;

    float loadDelay = kLoadDelay;
    float secs = kFadeDuration;
    [UIView animateWithDuration:secs delay:loadDelay options:UIViewAnimationOptionCurveLinear animations:^{
        self.bgImageSplash.alpha = 0.0f;

    } completion:^(BOOL finished) {

        //[self actionTimerVCR:nil];

        self.bgImageSplash.hidden = YES;
        [self.bgImageSplash removeFromSuperview];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //[self showWhiteBar];
        });



    }];

#endif
}


-(void)checkForUpdates
{
    if(![kHelpers checkOnline])
        return;

    if(![kHelpers isWifi])
        return;

    //download
    [kAppDelegate checkAssets];

    //self.loadingLabel.text = LOCALIZED(@"kStringCheckUpdate");
}

-(void)hideCheckForUpdates
{
    //self.loadingLabel.text = @"";
    //self.tip.text = @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)notifyForeground
{
    //if(kAppDelegate.titleController.menuState != menuStateLoading)
    //    return;

    //only for iOS7
    //if(kIsIOS8)
    //    return;

    [self moveSpinner];

    //re-add anim
    [self addShineAnimation];

    [self showWhiteBar];
    [self showCoins];
    [self showEnemies];
}

- (void)notifyBackground
{
    //only for iOS7
    //if(kIsIOS8)
    //    return;

    //fix crash
    //[self.shineImageView.layer removeAllAnimations];
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

    //hide
    self.whiteBar.hidden = YES;
}

-(void)showWhiteBar {

    if(!kShowWhiteBar)
        return;

    //disabled
    //self.whiteBar.hidden = YES;
    //return;

    self.whiteBar.hidden = NO;

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
    //float secs = kWhiteBarDelayMin + (arc4random_uniform(kWhiteBarDelayMax * 1000)/1000.0f);
    //float secs = 0.1f;
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.whiteBar.hidden = NO;
        [self.whiteBar.layer addAnimation:translate forKey:@"10"];
    //});

}

-(void)stopWhiteBar {
    [self.whiteBar.layer removeAllAnimations];
}


-(void)showCoins {

    //coins
    CABasicAnimation *translate;
    translate = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translate.fromValue = [NSNumber numberWithFloat:-100];

    int distance = 2000;
    translate.toValue = [NSNumber numberWithFloat:distance];

    translate.duration = 100;
    translate.repeatCount = 0;
    [self.coinsImage.layer removeAllAnimations];

    self.coinsImage.hidden = NO;
    [self.coinsImage.layer addAnimation:translate forKey:@"10"];


    //+1
    CABasicAnimation *translate2;
    translate2 = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translate2.fromValue = [NSNumber numberWithFloat:20];

    distance = -1500;
    translate2.toValue = [NSNumber numberWithFloat:distance];

    translate2.duration = 100;
    translate2.repeatCount = 0;
    [self.overlay.layer removeAllAnimations];

    self.overlay.hidden = NO;
    [self.overlay.layer addAnimation:translate2 forKey:@"10"];

}

-(void)stopCoins {
    [self.coinsImage.layer removeAllAnimations];
    [self.overlay.layer removeAllAnimations];
}

-(void)showEnemies {

    //enemies
    CABasicAnimation *translate;
    translate = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translate.fromValue = [NSNumber numberWithFloat:-100];

    int distance = -2000;
    translate.toValue = [NSNumber numberWithFloat:distance];

    translate.duration = 250; //100;
    translate.repeatCount = 0;
    [self.enemiesImage.layer removeAllAnimations];

    self.enemiesImage.hidden = NO;
    self.enemiesImage.alpha = 0.8f;
    [self.enemiesImage.layer addAnimation:translate forKey:@"10"];
}

-(void)stopEnemies {
    [self.enemiesImage.layer removeAllAnimations];
}

- (void)resetTimer{

    //bounce

    [self.timerBounce invalidate];
    self.timerBounce = nil;
    float interval = 1.0f;
    self.timerBounce = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(actionTimerBounce:) userInfo:@"actionTimerBounce" repeats:YES];
    //call now
    [self actionTimerBounce:nil];

    //vcr
    /*[self.timerVCR invalidate];
    self.timerVCR = nil;
    float interval = 0.3f; //0.0 + (arc4random_uniform(2*10)/10.0f);
    self.timerVCR = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                   selector:@selector(actionTimerVCR:) userInfo:@"actionTimerVCR" repeats:NO];
    //call now
    [self actionTimerVCR:nil];*/


	[self.timerDots invalidate];
    self.timerDots = nil;
    interval = 0.4f;
    self.timerDots = [NSTimer scheduledTimerWithTimeInterval:interval target:self
    selector:@selector(actionUpdateLoading:) userInfo:@"actionUpdateLoading" repeats:YES];

    //call now
    [self actionUpdateLoading:nil];

}


- (void) actionTimerMaxConvert:(NSTimer *)incomingTimer {

    //not done
    kAppDelegate.prefSoundsConverted = NO;

    //next, start loading
    //self.tip.text = [CBSkinManager getRandomTip];

    //color text
    NSString *tempString = [kHelpers colorString:self.tip.text];
    NSAttributedString *attrString = [NSAttributedString attributedStringFromHTML:tempString
                                                                       normalFont:self.tip.font
                                                                         boldFont:self.tip.font
                                                                       italicFont:self.tip.font];
    //center
    tempString = attrString.string;
    NSMutableAttributedString *attrString2 = [attrString mutableCopy];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    paragraphStyle.minimumLineHeight = paragraphStyle.maximumLineHeight = 20.0f;
    [attrString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempString length])];
    self.tip.attributedText = attrString2;

    [self startLoading2];
}

- (void) actionUpdateLoading:(NSTimer *)incomingTimer {

    self.loadingLabel.text = [self getRandomLoadingLabel];

    if([kHelpers randomBool100:50]) {

        //sound
        //[kHelpers playSoundCaf:@"harddrive.caf"];
        //[kHelpers playSoundCaf:@"harddrive.caf"];
        [kAppDelegate playSound:@"harddrive.caf" force:YES];
        
        //[kHelpers haptic1];
        
        self.floppy.hidden = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            self.floppy.hidden = YES;
        });
    }



#if 0
    NSString *string = @"";
	//if not processing assets
	if(![self.loadingLabel.text contains:LOCALIZED(@"kStringLoadingPreparingShort")]) {
		if(self.loadingDots == 0) {
			string = LOCALIZED(@"kStringLoading1");
		}
		else if(self.loadingDots == 1) {
			string = LOCALIZED(@"kStringLoading2");
		}
		else if(self.loadingDots == 2) {
			string = LOCALIZED(@"kStringLoading3");
		}
	}

    dispatch_async(dispatch_get_main_queue(), ^{
        self.loadingLabel.text = string;
    });

	self.loadingDots++;
	if(self.loadingDots >= 3)
		self.loadingDots = 0;

    Log(@"self.loadingLabel.text: %@", self.loadingLabel.text);
#endif
}

- (void) actionProgress:(NSTimer *)incomingTimer {

    //Log(@"actionProgress");

    self.progress += 10.0f;
    if(self.progress >= 100)
        self.progress = 100;

    [self updateProgressBar:self.progress];
}

- (void) actionTimerBounce:(NSTimer *)incomingTimer
{
    //[kAppDelegate animateControl:self.loadingLabel];
}

- (void) actionTimerVCR:(NSTimer *)incomingTimer
{
    if(!kVCREnabled)
        return;

    //reset timer
    [self.timerVCR invalidate];
    self.timerVCR = nil;
    //float interval = 1.0 + (arc4random_uniform(1*10)/10.0f);
    //self.timerVCR = [NSTimer scheduledTimerWithTimeInterval:interval target:self
     //                                              selector:@selector(actionTimerVCR:) userInfo:@"actionTimerVCR" repeats:NO];


    //if(!self.curtainLeft.hidden)
    //    return;

    //if(!kAppDelegate.gameScene.curtainLeft.hidden)
     //   return;


    //if(kAppDelegate.titleController.menuState != menuStateTitle || (self.view.hidden == YES))
    //    return;

    if([kHelpers isSlowDevice])
        return;

    //control center
    if(!kAppDelegate.appActive)
        return;

    self.vcr.hidden = NO;
    self.vcr.alpha = 0.0f;

    [kAppDelegate playSound:@"noise2.caf"];

    ///fade out
    [UIView animateWithDuration:kVCRDelayIn delay:0.0 options:0 animations:^{
        self.vcr.alpha = kVCRAlpha;
    } completion:^(BOOL finished){

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

}

@end
