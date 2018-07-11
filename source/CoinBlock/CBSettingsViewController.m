//
//  CBSettingsViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBSettingsViewController.h"
#import "SevenSwitch.h"
#import "CBConfettiView.h"
#import "UIResponder+MotionRecognizers.h"
#import "NSAttributedString+DDHTML.h"

@interface CBSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISlider *soundVolumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *musicVolumeSlider;

@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *musicSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *gamecenterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *adSwitch;

@property (nonatomic, strong) SevenSwitch *soundSwitch2;
@property (nonatomic, strong) SevenSwitch *musicSwitch2;
@property (nonatomic, strong) SevenSwitch *gamecenterSwitch2;
@property (nonatomic, strong) SevenSwitch *adSwitch2;

@property (weak, nonatomic) IBOutlet UISwitch *vibrateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *notifySwitch;
@property (nonatomic, strong) SevenSwitch *vibrateSwitch2;
@property (nonatomic, strong) SevenSwitch *notifySwitch2;

@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (nonatomic, strong) IBOutlet UIButton *contactButton;
@property (nonatomic, strong) IBOutlet UIButton *rateButton;
@property (nonatomic, strong) IBOutlet UIButton *restoreButton;
@property (nonatomic, strong) IBOutlet UIButton *aboutButton;
@property (nonatomic, strong) IBOutlet UIButton *tipButton;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *helpButton;
@property (nonatomic, strong) IBOutlet UIButton *iCloudButton;

@property (weak, nonatomic) IBOutlet UIButton *statsButon;
@property (weak, nonatomic) IBOutlet UILabel *soundLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *gamecenterLabel;
@property (weak, nonatomic) IBOutlet UILabel *adLabel;
@property (weak, nonatomic) IBOutlet UILabel *vibrateLabel;
@property (weak, nonatomic) IBOutlet UILabel *notifyLabel;
@property (weak, nonatomic) IBOutlet UILabel *iCloudLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton2;
@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (weak, nonatomic) IBOutlet UILabel *soundPlusLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundMinusLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicPlusLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicMinusLabel;
@property (weak, nonatomic) IBOutlet UILabel *coffeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *socialLabel;

@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UIImageView *shineImageView;
@property (nonatomic, strong) IBOutlet UIImageView *cloud1;
@property (strong, nonatomic) NSTimer *timerCloud;
@property (strong, nonatomic) NSTimer *timerVCR;
@property (strong, nonatomic) NSTimer *timerBounce;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;
@property (nonatomic, strong) IBOutlet UIImageView *vcr;
@property (nonatomic, strong) IBOutlet UIButton *coffeeButton;
@property (nonatomic, strong) IBOutlet UIImageView *coffeeImage;
@property (nonatomic, strong) IBOutlet UIImageView *backTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resetButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restoreButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionBottom;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;

@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;

@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;

@property (nonatomic) BOOL skipFade;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;

//@property (strong, nonatomic) SIAlertView *alertView;

@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *twitterButton;
@property (nonatomic, strong) IBOutlet UIButton *instaButton;
@property (nonatomic, strong) IBOutlet UIButton *youtubeButton;
@property (nonatomic, strong) IBOutlet UIButton *discordButton;
@property (nonatomic, strong) IBOutlet UIButton *mailingButton;
@property (nonatomic, strong) IBOutlet UIButton *spriteKitButton;
@property (nonatomic, strong) CAEmitterLayer *coffeeEmitter;


- (IBAction)actionBack:(id)sender;
- (IBAction)actionReset:(id)sender;
- (IBAction)actionStats:(id)sender;
- (IBAction)actionAbout:(id)sender;
- (IBAction)contactButtonPressed:(id)sender;
- (IBAction)rateButtonPressed:(id)sender;
- (IBAction)restoreButtonPressed:(id)sender;
- (IBAction)actionLogin:(id)sender;
- (IBAction)actionHelp:(id)sender;
- (IBAction)actionICloud:(id)sender;

- (IBAction)likeButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)instaButtonPressed:(id)sender;
- (IBAction)youtubeButtonPressed:(id)sender;
- (IBAction)discordButtonPressed:(id)sender;
- (IBAction)mailingButtonPressed:(id)sender;
- (IBAction)coffeeButtonPressed:(id)sender;

@end


@implementation CBSettingsViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupFade];
    [self bringSubviewsToFront];

    [kAppDelegate scaleView:self.view];

    [kHelpers loopInBackground];

    //shake
    [self addMotionRecognizerWithAction:@selector(shakeWasRecognized:)];


    //corner
    [kAppDelegate cornerView:self.view];

    [UIView setAnimationsEnabled:NO];

    [self setupConfetti];
    [self setupWhiteBar];

	//enable coffee
	self.coffeeButton.hidden = self.coffeeImage.hidden = NO;

    //scroll
    self.scrollView.hidden = NO;
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = NO; //YES

    /*
    //move all
    int offset = 0;
    CGRect tempRect;

    tempRect = self.resetButton.frame;
    [self.resetButton removeFromSuperview];
    [self.scrollView addSubview:self.resetButton];
    self.resetButton.frame = tempRect;

    //self.resetButton.y -= offset;

    tempRect = self.contactButton.frame;
    [self.contactButton removeFromSuperview];
    [self.scrollView addSubview:self.contactButton];
    self.contactButton.frame = tempRect;
     */

    //curtains
    CGRect screenRect = [kHelpers getScreenRect];
    self.curtainLeft.x = 0;
    self.curtainRight.x = screenRect.size.width-self.curtainRight.width;


    //disable autolayout
    self.curtainLeft.translatesAutoresizingMaskIntoConstraints = YES;
    self.curtainRight.translatesAutoresizingMaskIntoConstraints = YES;

    if(kVCRAnimEnabled) {
        self.vcr.animationImages = @[[UIImage imageNamed:@"vcr"], [UIImage imageNamed:@"vcr2"]];
        self.vcr.animationDuration = kVCRAnimDuration;
        self.vcr.animationRepeatCount = 0;
    }

    //kAppDelegate.settingsController = self;

    //constraints
    if([kHelpers isIphone4Size])
    {
        int offset = 20; //(568-480)
        //self.resetButtonConstraint.constant -= offset;
        self.rateButton.y -= offset;
        self.contactButton.y -= offset;
        self.restoreButton.y -= offset;
        self.aboutButton.y -= offset;
        //self.tipButton.y -= offset;

    }

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;
    self.cloud1.image = [UIImage imageNamed:kCloudName];

    //dark
    self.darkImage.alpha = 0;

    //labels
    //self.titleLabel.font = [UIFont fontWithName:kFontName size:16*kFontScale]; //20
    self.titleLabel.font = [UIFont fontWithName:kFontNameBlocky size:16*kFontScale]; //20


    self.titleLabel.textColor = kYellowTextColor;

    self.soundLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.musicLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.gamecenterLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.adLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.vibrateLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.notifyLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.iCloudLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.coffeeLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.socialLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];

    self.soundLabel.textColor = kYellowTextColor;
    self.musicLabel.textColor = kYellowTextColor;
    self.gamecenterLabel.textColor = kYellowTextColor;
    self.adLabel.textColor = kYellowTextColor;
    self.vibrateLabel.textColor = kYellowTextColor;
    self.notifyLabel.textColor = kYellowTextColor;
    self.coffeeLabel.textColor = kYellowTextColor;
    self.socialLabel.textColor = kYellowTextColor;

    //disable
    self.iCloudLabel.hidden = self.iCloudButton.hidden = YES;

    //year
    //NSDate *date = [NSDate date];
    //NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    //NSDateComponents *components = [[NSCalendar currentCalendar] components:componentFlags fromDate:date];
    int year = kCopyrightYear; //(int)[components year];

    //build time
    //NSString *dateStr = [NSString stringWithUTF8String:__DATE__];
    //NSString *timeStr = [NSString stringWithUTF8String:__TIME__];

    //version
    /*self.versionLabel.text = [NSString stringWithFormat:@"Version %@ (%@), Copyright © %d",
     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
     year];*/

    /*self.versionLabel.text = [NSString stringWithFormat:@"Version %@ (%@), Skyriser Media, %d",
                              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                              year];*/

    self.versionLabel.text = [NSString stringWithFormat:@"Skyriser Media ©%d - %@ (%@)",
                              year,
                              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]
                              ];


    //self.versionLabel.font = [UIFont fontWithName:kFontName size:10*kFontScale];
    self.versionLabel.font = [UIFont fontWithName:@"OrangeKid-Regular" size:20];

    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.textColor = [UIColor whiteColor];
    self.versionLabel.alpha = 0.4f;
    self.versionLabel.hidden = NO;

    //rays
    self.shineImageView.alpha = 0.2f;


    //slider
    self.soundVolumeSlider.tintColor = kYellowTextColor;
    self.soundVolumeSlider.minimumValue = 0;
    self.soundVolumeSlider.maximumValue = 1;
    self.soundVolumeSlider.value = kAppDelegate.soundVolume;
    [self.soundVolumeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.soundVolumeSlider.tintColor = RGB(208,160,0);

    self.musicVolumeSlider.tintColor = self.soundVolumeSlider.tintColor;
    self.musicVolumeSlider.minimumValue = 0;
    self.musicVolumeSlider.maximumValue = 1;
    self.musicVolumeSlider.value = kAppDelegate.musicVolume;
    [self.musicVolumeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.musicVolumeSlider.tintColor = RGB(208,160,0);


    //UIImage *thumbImage = [CBSkinManager getBlockImage];
    UIImage *thumbImage = [UIImage imageNamed:@"settings_thumb_small2"];

    /*[[UISlider appearance] setMaximumTrackImage:maxImage
                                       forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:minImage
                                       forState:UIControlStateNormal];*/
    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateNormal];


    //vibrate
    UIImage *switchImage = [UIImage imageNamed:@"settings_thumb_small2"];
    //UIImage *switchImage = [CBSkinManager getBlockImage];


    //UIColor *switchColorOn = RGBA(208/2,160/2,0, 0.5f); //yellow
    UIColor *switchColorOn = RGBA(0,0,0, 0.5f); //grey
    UIColor *switchColorOff = RGBA(100,100,100, 0.5f); //grey

    self.vibrateSwitch.tintColor = RGB(208,160,0);
    [self.vibrateSwitch setOnTintColor: self.vibrateSwitch.tintColor];
    self.vibrateSwitch.on = kAppDelegate.vibrationEnabled;
    self.vibrateSwitch.hidden = YES;

    self.vibrateSwitch2 = [[SevenSwitch alloc] initWithFrame:self.vibrateSwitch.frame];
    self.vibrateSwitch2.width = 80;
    [self.vibrateSwitch2 addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventValueChanged];

    self.vibrateSwitch2.activeColor = switchColorOn;
    self.vibrateSwitch2.inactiveColor = switchColorOff;
    self.vibrateSwitch2.onTintColor = switchColorOn;
    self.vibrateSwitch2.borderColor = [UIColor clearColor];
    self.vibrateSwitch2.thumbTintColor = [UIColor clearColor];

    self.vibrateSwitch2.isRounded = NO;
    self.vibrateSwitch2.offLabel.text = @"OFF";
    self.vibrateSwitch2.onLabel.text = @"ON";
    self.vibrateSwitch2.on = self.vibrateSwitch.on;
    self.vibrateSwitch2.thumbImage = switchImage;

    [self.view addSubview:self.vibrateSwitch2];
    [self.scrollView addSubview:self.vibrateSwitch2];


    //notify
    self.notifySwitch.tintColor = self.vibrateSwitch.tintColor;
    [self.notifySwitch setOnTintColor: self.notifySwitch.tintColor];
    self.notifySwitch.on = kAppDelegate.notifyEnabled;
    self.notifySwitch.hidden = YES;

    self.notifySwitch2 = [[SevenSwitch alloc] initWithFrame:self.notifySwitch.frame];
    self.notifySwitch2.width = 80;
    [self.notifySwitch2 addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventValueChanged];

    self.notifySwitch2.activeColor = switchColorOn;
    self.notifySwitch2.inactiveColor = switchColorOff;
    self.notifySwitch2.onTintColor = switchColorOn;
    self.notifySwitch2.borderColor = [UIColor clearColor];
    self.notifySwitch2.thumbTintColor = [UIColor clearColor];

    self.notifySwitch2.isRounded = NO;
    self.notifySwitch2.offLabel.text = @"OFF";
    self.notifySwitch2.onLabel.text = @"ON";
    self.notifySwitch2.on = self.notifySwitch.on;
    self.notifySwitch2.thumbImage = switchImage;
    //[self.view addSubview:self.notifySwitch2];
    [self.scrollView addSubview:self.notifySwitch2];


    //sound
    self.soundSwitch.tintColor = self.vibrateSwitch.tintColor;
    [self.soundSwitch setOnTintColor: self.soundSwitch.tintColor];
    self.soundSwitch.hidden = YES;

    self.soundSwitch2 = [[SevenSwitch alloc] initWithFrame:self.soundSwitch.frame];
    self.soundSwitch2.width = 80;
    [self.soundSwitch2 addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventValueChanged];

    self.soundSwitch2.activeColor = switchColorOn;
    self.soundSwitch2.inactiveColor = switchColorOff;
    self.soundSwitch2.onTintColor = switchColorOn;
    self.soundSwitch2.borderColor = [UIColor clearColor];
    self.soundSwitch2.thumbTintColor = [UIColor clearColor];

    self.soundSwitch2.isRounded = NO;
    self.soundSwitch2.offLabel.text = @"OFF";
    self.soundSwitch2.onLabel.text = @"ON";
    self.soundSwitch2.thumbImage = switchImage;
    [self.scrollView addSubview:self.soundSwitch2];

    //music
    self.musicSwitch.tintColor = self.vibrateSwitch.tintColor;
    [self.musicSwitch setOnTintColor: self.musicSwitch.tintColor];
    self.musicSwitch.hidden = YES;

    self.musicSwitch2 = [[SevenSwitch alloc] initWithFrame:self.musicSwitch.frame];
    self.musicSwitch2.width = 80;
    [self.musicSwitch2 addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventValueChanged];

    self.musicSwitch2.activeColor = switchColorOn;
    self.musicSwitch2.inactiveColor = switchColorOff;
    self.musicSwitch2.onTintColor = switchColorOn;
    self.musicSwitch2.borderColor = [UIColor clearColor];
    self.musicSwitch2.thumbTintColor = [UIColor clearColor];

    self.musicSwitch2.isRounded = NO;
    self.musicSwitch2.offLabel.text = @"OFF";
    self.musicSwitch2.onLabel.text = @"ON";
    self.musicSwitch2.thumbImage = switchImage;
    [self.scrollView addSubview:self.musicSwitch2];

    [self updateUI];

    //gamcenter
    self.gamecenterSwitch.tintColor = self.vibrateSwitch.tintColor;
    [self.gamecenterSwitch setOnTintColor: self.gamecenterSwitch.tintColor];
    self.gamecenterSwitch.on = kAppDelegate.gameCenterEnabled;
    self.gamecenterSwitch.hidden = YES;

    self.gamecenterSwitch2 = [[SevenSwitch alloc] initWithFrame:self.gamecenterSwitch.frame];
    self.gamecenterSwitch2.width = 80;
    [self.gamecenterSwitch2 addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventValueChanged];

    self.gamecenterSwitch2.activeColor = switchColorOn;
    self.gamecenterSwitch2.inactiveColor = switchColorOff;
    self.gamecenterSwitch2.onTintColor = switchColorOn;
    self.gamecenterSwitch2.borderColor = [UIColor clearColor];
    self.gamecenterSwitch2.thumbTintColor = [UIColor clearColor];

    self.gamecenterSwitch2.isRounded = NO;
    self.gamecenterSwitch2.offLabel.text = @"OFF";
    self.gamecenterSwitch2.onLabel.text = @"ON";
    self.gamecenterSwitch2.on = self.gamecenterSwitch.on;
    self.gamecenterSwitch2.thumbImage = switchImage;
    [self.scrollView addSubview:self.gamecenterSwitch2];


    //ad
    self.adSwitch.tintColor = self.vibrateSwitch.tintColor;
    [self.adSwitch setOnTintColor: self.adSwitch.tintColor];
    self.adSwitch.on = YES;
    self.adSwitch.hidden = YES;

    self.adSwitch2 = [[SevenSwitch alloc] initWithFrame:self.adSwitch.frame];
    self.adSwitch2.width = 80;
    [self.adSwitch2 addTarget:self action:@selector(actionSwitch:) forControlEvents:UIControlEventValueChanged];

    self.adSwitch2.activeColor = switchColorOn;
    self.adSwitch2.inactiveColor = switchColorOff;
    self.adSwitch2.onTintColor = switchColorOn;
    self.adSwitch2.borderColor = [UIColor clearColor];
    self.adSwitch2.thumbTintColor = [UIColor clearColor];

    self.adSwitch2.isRounded = NO;
    self.adSwitch2.offLabel.text = @"OFF";
    self.adSwitch2.onLabel.text = @"ON";
    self.adSwitch2.on = self.adSwitch.on;
    self.adSwitch2.thumbImage = switchImage;
    [self.scrollView addSubview:self.adSwitch2];


    //buttons
    self.resetButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.contactButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.rateButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.restoreButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.statsButon.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.aboutButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.tipButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.loginButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.helpButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];

    float inset = 6.0f;
    [self.resetButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    [self.contactButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    [self.rateButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    [self.restoreButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    [self.statsButon setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    [self.aboutButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    [self.tipButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    [self.loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    [self.helpButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];


    [self.resetButton setTintColor:kYellowTextColor];
    [self.rateButton setTintColor:kYellowTextColor];
    [self.restoreButton setTintColor:kYellowTextColor];
    [self.contactButton setTintColor:kYellowTextColor];
    [self.statsButon setTintColor:kYellowTextColor];
    [self.aboutButton setTintColor:kYellowTextColor];
    [self.tipButton setTintColor:kYellowTextColor];
    [self.loginButton setTintColor:kYellowTextColor];
    [self.helpButton setTintColor:kYellowTextColor];

    [self.resetButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.rateButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.restoreButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.contactButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.statsButon setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.aboutButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.tipButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.loginButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.helpButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];


    //labels
    self.soundPlusLabel.font = [UIFont fontWithName:kFontName size:20*kFontScale];
    self.soundMinusLabel.font = [UIFont fontWithName:kFontName size:20*kFontScale];
    self.musicPlusLabel.font = [UIFont fontWithName:kFontName size:20*kFontScale];
    self.musicMinusLabel.font = [UIFont fontWithName:kFontName size:20*kFontScale];


    self.soundPlusLabel.textColor = kYellowTextColor;
    self.soundMinusLabel.textColor = kYellowTextColor;
    self.musicPlusLabel.textColor = kYellowTextColor;
    self.musicMinusLabel.textColor = kYellowTextColor;


    //shadow
    int shadowOffset = 2;
    UIColor *shadowColor = kTextShadowColor;

    self.soundLabel.shadowColor = shadowColor;
    self.soundLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.musicLabel.shadowColor = shadowColor;
    self.musicLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.gamecenterLabel.shadowColor = shadowColor;
    self.gamecenterLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.adLabel.shadowColor = shadowColor;
    self.adLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.vibrateLabel.shadowColor = shadowColor;
    self.vibrateLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.notifyLabel.shadowColor = shadowColor;
    self.notifyLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.coffeeLabel.shadowColor = shadowColor;
    self.coffeeLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.socialLabel.shadowColor = shadowColor;
    self.socialLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.iCloudLabel.shadowColor = shadowColor;
    self.iCloudLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.soundPlusLabel.shadowColor = shadowColor;
    self.soundPlusLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.soundMinusLabel.shadowColor = shadowColor;
    self.soundMinusLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.musicPlusLabel.shadowColor = shadowColor;
    self.musicPlusLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.musicMinusLabel.shadowColor = shadowColor;
    self.musicMinusLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.titleLabel.shadowColor = shadowColor;
    self.titleLabel.shadowOffset = CGSizeMake(3, 3);


    int buttonCornerRadius = 10;
    int buttonBorderWidth = 2;
    UIColor *buttonColor = RGBA(0,0,0, 0.3f); //RGBA(255,255,255, 0.1f);
    UIColor *borderColor = kYellowTextColor;

    CALayer * l = nil;

    //reset
    //[self.resetButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.resetButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.resetButton.clipsToBounds = NO;
    self.resetButton.titleLabel.clipsToBounds = NO;
    self.resetButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.resetButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.resetButton.titleLabel.layer.shadowRadius = 0.0f;
    self.resetButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.resetButton.titleLabel.layer.masksToBounds = NO;
    self.resetButton.backgroundColor = buttonColor;

    l = [self.resetButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];

    //rate
    //[self.rateButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.rateButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.rateButton.clipsToBounds = NO;
    self.rateButton.titleLabel.clipsToBounds = NO;
    self.rateButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.rateButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.rateButton.titleLabel.layer.shadowRadius = 0.0f;
    self.rateButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.rateButton.titleLabel.layer.masksToBounds = NO;
    self.rateButton.backgroundColor = buttonColor;

    l = [self.rateButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];

    //restore
    //[self.restoreButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.restoreButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.restoreButton.clipsToBounds = NO;
    self.restoreButton.titleLabel.clipsToBounds = NO;
    self.restoreButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.restoreButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.restoreButton.titleLabel.layer.shadowRadius = 0.0f;
    self.restoreButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.restoreButton.titleLabel.layer.masksToBounds = NO;
    self.restoreButton.backgroundColor = buttonColor;
    l = [self.restoreButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];

    //login
    //[self.loginButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.loginButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.loginButton.clipsToBounds = NO;
    self.loginButton.titleLabel.clipsToBounds = NO;
    self.loginButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.loginButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.loginButton.titleLabel.layer.shadowRadius = 0.0f;
    self.loginButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.loginButton.titleLabel.layer.masksToBounds = NO;
    self.loginButton.backgroundColor = buttonColor;
    l = [self.loginButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];


    //help
    self.helpButton.clipsToBounds = NO;
    self.helpButton.titleLabel.clipsToBounds = NO;
    self.helpButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.helpButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.helpButton.titleLabel.layer.shadowRadius = 0.0f;
    self.helpButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.helpButton.titleLabel.layer.masksToBounds = NO;
    self.helpButton.backgroundColor = buttonColor;
    l = [self.helpButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];
    self.helpButton.hidden = YES; //disabled

    //contact
    //[self.contactButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.contactButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.contactButton.clipsToBounds = NO;
    self.contactButton.titleLabel.clipsToBounds = NO;
    self.contactButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.contactButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.contactButton.titleLabel.layer.shadowRadius = 0.0f;
    self.contactButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.contactButton.titleLabel.layer.masksToBounds = NO;
    self.contactButton.backgroundColor = buttonColor;
    l = [self.contactButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];



    //stats
    //[self.statsButon setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.statsButon.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.statsButon.clipsToBounds = NO;
    self.statsButon.titleLabel.clipsToBounds = NO;
    self.statsButon.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.statsButon.titleLabel.layer.shadowOpacity = 1.0f;
    self.statsButon.titleLabel.layer.shadowRadius = 0.0f;
    self.statsButon.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.statsButon.titleLabel.layer.masksToBounds = NO;
    self.statsButon.backgroundColor = buttonColor;
    l = [self.statsButon layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];

    //about
    //[self.aboutButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.aboutButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.aboutButton.clipsToBounds = NO;
    self.aboutButton.titleLabel.clipsToBounds = NO;
    self.aboutButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.aboutButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.aboutButton.titleLabel.layer.shadowRadius = 0.0f;
    self.aboutButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.aboutButton.titleLabel.layer.masksToBounds = NO;
    self.aboutButton.backgroundColor = buttonColor;
    l = [self.aboutButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];



    //tip
    self.tipButton.clipsToBounds = NO;
    self.tipButton.titleLabel.clipsToBounds = NO;
    self.tipButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.tipButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.tipButton.titleLabel.layer.shadowRadius = 0.0f;
    self.tipButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.tipButton.titleLabel.layer.masksToBounds = NO;
    self.tipButton.backgroundColor = buttonColor;
    l = [self.tipButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];

    //spacing
    NSString *tempTitle = nil;
    NSMutableAttributedString *attributedString = nil;
    float spacing = 2.0f;

    tempTitle = self.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    self.titleLabel.attributedText = attributedString;


    tempTitle = self.soundLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    self.soundLabel.attributedText = attributedString;

    tempTitle = self.musicLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    self.musicLabel.attributedText = attributedString;

    tempTitle = self.adLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    self.adLabel.attributedText = attributedString;

    tempTitle = self.vibrateLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    self.vibrateLabel.attributedText = attributedString;

    tempTitle = self.notifyLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    self.notifyLabel.attributedText = attributedString;

    //spacing = 2.0f;

    tempTitle = self.statsButon.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.statsButon setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.aboutButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.aboutButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.tipButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.tipButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.resetButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.resetButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.contactButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.contactButton setAttributedTitle:attributedString forState:UIControlStateNormal];


    tempTitle = self.rateButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.rateButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.restoreButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.restoreButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.loginButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.loginButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.helpButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.helpButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    //swipe
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    //[self.view addGestureRecognizer:gestureRecognizer];

    [UIView setAnimationsEnabled:YES];

}

-(void)updateUI
{
    self.soundSwitch.on = kAppDelegate.soundVolume > 0.0f;
    self.soundSwitch2.on = self.soundSwitch.on;
    self.musicSwitch.on = kAppDelegate.musicVolume > 0.0f;
    self.musicSwitch2.on = self.musicSwitch.on;

    [self.backButton setBackgroundImage:nil forState:UIControlStateNormal];

    //back button
    UIImage *backImage = self.backToGame ? [UIImage imageNamed:@"podium2"] : [UIImage imageNamed:@"podium7"];
    [self.backButton setImage:backImage forState:UIControlStateNormal];

    self.socialLabel.hidden = YES;

    //doesn't work, do in storyboard instead?
//    [self.view bringSubviewToFront:self.coffeeButton];
//    [self.view bringSubviewToFront:self.coffeeImage];
}

-(void) resumeNotification:(NSNotification*)notif {

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });
}

-(void)viewDidLayoutSubviews {

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    //scroll
    //self.scrollView.frame = self.view.frame;
    CGSize scrollSize = CGSizeMake(320,568+20);
    [self.scrollView setContentSize:scrollSize];


    if([kHelpers isIphone4Size])
    {
        self.likeButton.y = 441 - 66;

        self.tipButton.y = self.likeButton.y - 42;
        self.coffeeImage.y = self.tipButton.y - 2;

    }
    else if([kHelpers isIphoneX])
    {
        //lower

        self.backTop.height = 45+kiPhoneXTopSpace; //taller
        self.likeButton.y = 511;
        self.tipButton.y = self.likeButton.y - 100;
        self.coffeeImage.y = self.tipButton.y - 2;

        self.backButton.y = 11  + kiPhoneXTopSpace;
        self.titleLabel.y = 2 + kiPhoneXTopSpace;
        self.scrollView.y = 43 + kiPhoneXTopSpace;

        self.versionBottom.constant = 0;

        //self.versionLabel.y = self.view.height - 20; //self.likeButton.y - 20;
        //self.versionLabel.y = self.likeButton.y +  20;


    }
    else
    {
        self.likeButton.y = 441;
        self.tipButton.y = self.likeButton.y - 70;
        self.coffeeImage.y = self.tipButton.y - 2;

    }

    self.coffeeLabel.y = self.coffeeImage.y + 0;
    self.socialLabel.y = self.likeButton.y + 0;

    self.twitterButton.y =  self.likeButton.y;
    self.instaButton.y =  self.likeButton.y -2;
    self.youtubeButton.y =  self.likeButton.y + 1;
    self.discordButton.y =  self.likeButton.y + 1;
    self.mailingButton.y =  self.likeButton.y;
    self.spriteKitButton.y =  self.likeButton.y;

    self.coffeeButton.y = self.coffeeImage.y - 5;

    //more scroll for ipad
    if([kHelpers isIpad])
    {
        self.scrollView.x = 20;
    }


    if([kHelpers isIphone4Size])
    {
        //reposition emiter
        self.coffeeEmitter.emitterPosition = CGPointMake(self.coffeeImage.frame.origin.x+20, self.coffeeImage.frame.origin.y+32);

    }
    else if([kHelpers isIphoneX])
    {
        //reposition emiter
        self.coffeeEmitter.emitterPosition = CGPointMake(self.coffeeImage.frame.origin.x+20, self.coffeeImage.frame.origin.y+62);
    }
    else
    {
        //reposition emiter
        self.coffeeEmitter.emitterPosition = CGPointMake(self.coffeeImage.frame.origin.x+20, self.coffeeImage.frame.origin.y+32);
    }


}

- (void)viewWillAppear:(BOOL)animated{

    Log(@"***** Settings: viewWillAppear");

    [super viewWillAppear:animated];

    [self enableButtons:NO];

    [self setupFade];

    //subscribe to resume updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeNotification:)
                                                 name:kResumeNotificationSettings
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];


    //switch
    self.notifySwitch.on = kAppDelegate.notifyEnabled && [kAppDelegate isRegisteredForNotifications]; //???

    //state
    kAppDelegate.titleController.menuState = menuStateSettings;

    [self enableButtons:YES];

    [kHelpers setupGoogleAnalyticsForView:[[self class] description]];

    //move
    //self.resetButton.y = self.statsButon.y;

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });


    self.vcr.hidden = YES;
    self.vcr.alpha = 0.0f;
    [self.vcr startAnimating];

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    //scroll top
    [self.scrollView setContentOffset:CGPointZero animated:NO];

    //music
    [kAppDelegate playMusic:kMusicNameOptions andRemember:YES];


    //block images
    //UIImage *thumbImage = [CBSkinManager getBlockImage];
    UIImage *thumbImage = [UIImage imageNamed:@"settings_thumb_small2"];

    thumbImage = [kHelpers imageWithImage:thumbImage scaleToWidth:30 resizeIfSmaller:NO];


    [[UISlider appearance] setThumbImage:thumbImage
                                forState:UIControlStateNormal];

    //self.vibrateSwitch2.thumbImage = thumbImage;
    self.notifySwitch2.thumbImage = thumbImage;
    self.musicSwitch2.thumbImage = thumbImage;
    self.soundSwitch2.thumbImage = thumbImage;
    self.adSwitch2.thumbImage = thumbImage;

    //disable
    self.adSwitch.hidden = YES;
    self.adSwitch2.hidden = YES;
    self.adLabel.hidden = YES;

    self.gamecenterLabel.hidden = YES;
    self.gamecenterSwitch.hidden = YES;
    self.gamecenterSwitch2.hidden = YES;

    //disabled
//    self.notifyLabel.hidden = YES;
//    self.notifySwitch.hidden = YES;
//    self.notifySwitch2.hidden = YES;

	//hide reset
    self.resetButton.hidden = YES;

    [self updateLoginButton];

    /*
     [self startConfetti];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopConfetti];
    });
    */

    [self showWhiteBar];
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self showCoffee];
    //});

    //disabled
    self.statsButon.hidden = YES;

    [self updateUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self enableButtons:NO];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    [self stopConfetti];

    [self stopWhiteBar];
    //[self.shineImageView.layer removeAllAnimations];

    [self.timerVCR invalidate];
    self.timerVCR = nil;
    self.vcr.hidden = YES;

    [self.timerBounce invalidate];
    self.timerBounce = nil;
}

- (void)viewDidAppear:(BOOL)animated {

    Log(@"***** Settings: viewDidAppear");

    [super viewDidAppear:animated];

    [self enableButtons:YES];

    //give time to layout
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self resetTimer];
    });

    //rotate
    [self addShineAnimation];

    //state
    kAppDelegate.launchInGame = NO;
    [kAppDelegate saveState];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.shineImageView.layer removeAllAnimations];

    [self.cloud1.layer removeAllAnimations];
    self.cloud1.alpha = 0.0f;
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    //always save
    [kAppDelegate saveState];

	[self stopCoffee];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

-(void)enableButtons:(BOOL)enable {

    self.backButton.enabled = enable;
    self.backButton2.enabled = enable;

    self.resetButton.enabled = enable;
    self.contactButton.enabled = enable;
    self.rateButton.enabled = enable;
    self.restoreButton.enabled = enable;
    self.aboutButton.enabled = enable;
    self.tipButton.enabled = enable;
    self.loginButton.enabled = enable;
    self.helpButton.enabled = enable;
    self.statsButon.enabled = enable;

    self.twitterButton.enabled = enable;
    self.instaButton.enabled = enable;
    self.youtubeButton.enabled = enable;
    self.discordButton.enabled = enable;
    self.mailingButton.enabled = enable;
    self.likeButton.enabled = enable;
    self.spriteKitButton.enabled = enable;

	self.coffeeButton.enabled = enable;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)actionAbout:(id)sender {

    //credits

    [kAppDelegate playSound:kClickSound];

    [kAppDelegate animateControl:self.aboutButton];

    [self enableButtons:NO];

    [self fadeIn];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				[kAppDelegate setViewController:kAppDelegate.aboutController];
    });
}

- (IBAction)actionStats:(id)sender {

    [self enableButtons:NO];

    [kAppDelegate playSound:kClickSound];

    [kAppDelegate animateControl:self.statsButon];

    [self fadeIn];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			//[kAppDelegate setViewController:kAppDelegate.statsController];
    });

}


- (IBAction)rateButtonPressed:(id)sender
{
    [kAppDelegate animateControl:self.rateButton];

    [kAppDelegate playSound:kClickSound];
    [kAppDelegate playSound:@"kiss.caf"];

    [self enableButtons:NO];

    __weak typeof(self) weakSelf = self;

    //ask
    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];


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
                                    [kAppDelegate openRatings];

									//achievement
									[kAppDelegate reportAchievement:kAchievement_social];

                               }];

    /*[kAppDelegate.alertView addButtonWithTitle:@"Cancel"
                                  type:kAlertButtonOrange
                               handler:^(SIAlertView *alert) {

                                   [kAppDelegate playSound:kClickSound];

                               }];*/

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
        [weakSelf enableButtons:YES];
    }];


    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        [weakSelf enableButtons:YES];

        [weakSelf showVCR:NO animated:YES];
    }];



    //kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];

    [self showVCR:YES animated:YES];

}

- (IBAction)actionICloud:(id)sender {

    [kAppDelegate playSound:kClickSound];

    [kAppDelegate animateControl:self.iCloudButton];


    //offline
    if(![kHelpers checkOnline]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        return;
    }


    __weak typeof(self) weakSelf = self;

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"iCloud Sync"
                                                     andMessage:@"Synchronize your progress between your devices."];

    [kAppDelegate.alertView addButtonWithTitle:@"Save to iCloud"
                                          type:kAlertButtonGray
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];

                                           [weakSelf contactButtonPressed:nil];

                                           //save
                                           [kAppDelegate saveState:YES];
                                       }];


    [kAppDelegate.alertView addButtonWithTitle:@"Load from iCloud"
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];

                                           //transfer
                                           [kAppDelegate loadFromIcloud];

                                       }];

    /*[kAppDelegate.alertView addButtonWithTitle:@"Cancel"
     type:kAlertButtonOrange
     handler:^(SIAlertView *alert) {

     [kAppDelegate playSound:kClickSound];

     }];*/

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];


    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        [weakSelf enableButtons:YES];

        [weakSelf showVCR:NO animated:YES];
    }];



    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];

    [self showVCR:YES animated:YES];

}

- (IBAction)actionHelp:(id)sender {
}


- (IBAction)actionLogin:(id)sender
{
    __weak typeof(self) weakSelf = self;

    [kAppDelegate playSound:kClickSound];

    //already
    if([kAppDelegate isLoggedIn]) {
        [kAppDelegate logoutFacebook];
        [kAppDelegate logout];

        [self updateLoginButton];

        //image
        kAppDelegate.profileImage = nil;

        [kHelpers showSuccessHud:LOCALIZED(@"kStringSuccess")];
        return;
    }

    //[kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Login"
                                             andMessage:[NSString stringWithFormat:@"How to you want to login?"]];


    [kAppDelegate.alertView addButtonWithTitle:@"Facebook"
                             type:kAlertButtonGray
                          handler:^(SIAlertView *alert) {
                              [kAppDelegate playSound:kClickSound];

                              [weakSelf actionFacebook:nil];

                          }];


    [kAppDelegate.alertView addButtonWithTitle:@"Twitter"
                             type:kAlertButtonGray
                          handler:^(SIAlertView *alert) {
                              [kAppDelegate playSound:kClickSound];

                              [weakSelf actionTwitter:nil];

                          }];



    [kAppDelegate.alertView addButtonWithTitle:@"Cancel"
                             type:kAlertButtonOrange
                          handler:^(SIAlertView *alert) {
                              [kAppDelegate playSound:kClickSound];

                          }];

    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

        [weakSelf showVCR:NO animated:YES];
    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];


    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];

    [self showVCR:YES animated:YES];
}


- (IBAction)restoreButtonPressed:(id)sender
{
    [kAppDelegate animateControl:self.restoreButton];

    [kAppDelegate playSound:kClickSound];

    [self enableButtons:NO];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self enableButtons:YES];
    });

    //offline
    if(![kHelpers checkOnline]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        return;
    }


    [kHelpers showMessageHud:@"Connecting..."];

    [[IAPShare sharedHelper].iap restoreProductsWithCompletion:^(SKPaymentQueue *payment, NSError *error) {

        [kHelpers dismissHud];


        //success
        if(payment.transactions.count > 0 && !error) {
            [kHelpers showMessageHud:LOCALIZED(@"kStringIAPRestoreSuccess")];


            [kAppDelegate restoreFromPayment:payment];


            //[kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
            [self startConfetti];
            float secs = kConfettiThanksDuration;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self stopConfetti];
            });

        }
        else
        {
            //just cancelled
            if(error.code == SKErrorPaymentCancelled){
                Log(@"SKPaymentTransactionStateFailed: SKErrorPaymentCancelled");
            }
            else
                [kHelpers showErrorHud:LOCALIZED(@"kStringIAPRestoreError")];
        }

    }];
}


- (IBAction)contactButtonPressed:(id)sender
{

    if(sender) {
        [kAppDelegate animateControl:self.contactButton];

        [kAppDelegate playSound:kClickSound];
    }
    //[kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];


    NSString *version = [kHelpers getVersionString2];
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    NSString *model = [kHelpers platformString];
    NSString *body = [NSString stringWithFormat: @"App Version: %@\niOS Version: %@\niOS Device: %@\n\n\nDear Skyriser Media, \n\n\n\n", version, iosVersion, model];

    [kAppDelegate sendEmailTo:@"coinyblock@skyriser.com" withSubject: @"Coiny Block Feedback" withBody:body withView:self];

}


- (IBAction)actionReset:(id)sender {

    [kAppDelegate animateControl:self.resetButton];

    __weak typeof(self) weakSelf = self;

    [self enableButtons:NO];

    [kAppDelegate playSound:kClickSound];

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];


    NSString *message = [NSString stringWithFormat:@"Woah! Are you sure you want to reset the game? You will lose your <color1>progress</color1> and <color1>achievements</color1>.\n\nYour unlocked <color1>Blocks</color1> will stay unlocked."];


    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Reset Game?"
                                                     andMessage:message];
    [kAppDelegate.alertView addButtonWithTitle:@"Reset"
                             type:kAlertButtonGreen
                          handler:^(SIAlertView *alert) {

                              //shake
                              [kAppDelegate playSound:kClickSound];
                              [kAppDelegate playSound:@"aaaahhh.caf"];

							  //keep skins
                              [kAppDelegate resetState:NO];

                              //reset achievements
                              [kAppDelegate resetAchievements];

                              //firebals
                              [kAppDelegate.gameScene hideAllFireballs];
                              [kAppDelegate.gameScene hidePowerup];
                              [kAppDelegate.gameScene hideAllClouds:NO];

                              weakSelf.soundVolumeSlider.value = kAppDelegate.soundVolume;
                              weakSelf.musicVolumeSlider.value = kAppDelegate.musicVolume;

                              float secs = 0.3f;
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                  [weakSelf actionBack:nil];
                              });

                          }];



    [kAppDelegate.alertView addButtonWithTitle:@"Cancel"
                             type:kAlertButtonOrange
                          handler:^(SIAlertView *alert) {
                              //
                              [kAppDelegate playSound:kClickSound];
                              //nothing

                          }];
    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //[kAppDelegate playSound:kClickSound];
        //nothing
    }];


    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        [weakSelf enableButtons:YES];

        [weakSelf showVCR:NO animated:YES];
    }];

    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];

    [self showVCR:YES animated:YES];

    //[kAppDelegate playSound:@"gasp1.caf"];
    [kAppDelegate playSound:kScreamSound];
}

- (void) actionBack:(id)sender {

    //[kAppDelegate stopMusic];

    if(!self.curtainLeft.hidden)
        return;

    [kAppDelegate animateControl:self.backButton];
    [kAppDelegate animateControl:self.backButton2];

    [self enableButtons:NO];

    if(sender)
        [kAppDelegate playSound:kClickSound];


    [self fadeIn];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            if(!kAppDelegate.playedWelcomeAlert)
            {
                kAppDelegate.titleController.menuState = menuStateStory;
                [kAppDelegate setViewController:kAppDelegate.storyController];
            }
			else if(self.backToGame) {
				//[kAppDelegate setViewController:kAppDelegate.gameController];
                [kAppDelegate setViewController:kAppDelegate.transitionController];
			}
			else {
				[kAppDelegate setViewController:kAppDelegate.titleController];
			}

        self.backToGame = NO;
    });


}


- (IBAction)actionSwitch:(id)sender{

    __weak typeof(self) weakSelf = self;

    [kAppDelegate animateControl:sender];

    if(sender == self.vibrateSwitch || sender == self.vibrateSwitch2) {
        //kAppDelegate.vibrationEnabled = self.vibrateSwitch.on;
        kAppDelegate.vibrationEnabled = self.vibrateSwitch2.on;

        if(kAppDelegate.vibrationEnabled)
            [kHelpers vibrate];
    }

    if(sender == self.notifySwitch || sender == self.notifySwitch2) {
        kAppDelegate.notifyEnabled = self.notifySwitch2.on;

        if(kAppDelegate.notifyEnabled) {
            if(!kAppDelegate.notifyAsked && ![kAppDelegate isRegisteredForNotifications]) {

                kAppDelegate.notifyAccepted = YES;
                kAppDelegate.notifyAsked = YES;

                [kAppDelegate registerNotifications];
                [kAppDelegate setupNotifications];

                /*
                //prime alert
                NSString *message = LOCALIZED(@"kStringNotifPrimeDesc");
                RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:LOCALIZED(@"kStringNotifPrimeCancel") action:^{
                    //nothing
                }];
                //RIButtonItem *okItem = [RIButtonItem itemWithLabel:LOCALIZED(@"kStringOK") action:^{
                RIButtonItem *okItem = [RIButtonItem itemWithLabel:LOCALIZED(@"kStringNotifPrimeOk2") action:^{

                    kAppDelegate.notifyAccepted = YES;

                    [kAppDelegate registerNotifications];
                    [kAppDelegate setupNotifications];


                }];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALIZED(@"kStringNotifPrimeTitle")
                                                                message:message
                                                       cancelButtonItem:cancelItem
                                                       otherButtonItems:okItem, nil];
                [alert show];
                kAppDelegate.notifyAsked = YES;*/
            }
            else {
                [kAppDelegate registerNotifications];
                [kAppDelegate setupNotifications];
            }

        }


        //sound
        if(self.soundSwitch2.on) {

            float secs = 0.0f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [kAppDelegate playSound:kClickSound];
            });

            //[kAppDelegate playSound:@"smb3_bump.caf"];
        }

    }

    if(sender == self.musicSwitch || sender == self.musicSwitch2) {
        float newVolume = 0.0f;
        if(self.musicSwitch2.on) {
            newVolume =kDefaultVolumeMusic;
        }

        [kAppDelegate setMusicVolume:newVolume];

        //sound
        if(self.soundSwitch2.on) {

            float secs = 0.0f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [kAppDelegate playSound:kClickSound];
            });

            //[kAppDelegate playSound:@"smb3_bump.caf"];
        }

    }

    if(sender == self.soundSwitch || sender == self.soundSwitch2) {
        float newVolume = 0.0f;
        if(self.soundSwitch2.on) {
            newVolume = kDefaultVolumeSound;
        }

        [kAppDelegate setSoundVolume:newVolume];

        //sound
        if(self.soundSwitch2.on) {

            float secs = 0.0f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [kAppDelegate playSound:kClickSound];
            });

            secs = 0.2f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSString *soundName =[CBSkinManager getCoinSoundNameIndex:(int)[kAppDelegate getSkin]];
                [kAppDelegate playSound:soundName];
            });

        }
    }

		if(sender == self.gamecenterSwitch || sender == self.gamecenterSwitch2) {
				kAppDelegate.gameCenterEnabled = self.gamecenterSwitch2.on;


			if(kAppDelegate.gameCenterEnabled) {
				[kAppDelegate setupGameCenter];

				//wait
				[kHelpers showMessageHud:@""];
				float secs = 1.0f;
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
					[kHelpers dismissHud];
				});

			}


		}


    if(sender == self.adSwitch || sender == self.adSwitch2) {

        if(self.adSwitch2.on) {
            //nothing
        }
        else {
            //self.adSwitch2.on = NO;

            //alert

            if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
                [kAppDelegate.alertView dismissAnimated:NO];

            kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Feature locked"
                                                             andMessage:[NSString stringWithFormat:@"Do you want to permanently unlock all ads?"]];

            [kAppDelegate.alertView addButtonWithTitle:@"Cancel"

                                     type:kAlertButtonOrange
                                  handler:^(SIAlertView *alert) {
                                      [weakSelf enableButtons:YES];

                                      weakSelf.adSwitch2.on = YES;

                                      [kAppDelegate playSound:kClickSound];
                                  }];


            [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
                [weakSelf enableButtons:YES];
                weakSelf.adSwitch2.on = YES;

            }];

            [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
                [weakSelf showVCR:NO animated:YES];
            }];


            kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
            kAppDelegate.alertView.transitionStyle = kAlertStyle;

            [kAppDelegate.alertView show:YES];

            [self showVCR:YES animated:YES];

            //shake
            //[self.view shake];

        }

        //sound
        if(self.soundSwitch2.on) {

            float secs = 0.0f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [kAppDelegate playSound:kClickSound];
            });

        }

    }

    //always save
    [kAppDelegate saveState];
}


- (IBAction)actionSliderRelease:(UISlider *)sender {
    [kAppDelegate playSound:@"smb3_bump.caf"];
    //[kAppDelegate playSound:@"smb3_coin6.caf"];

    NSString *soundName =[CBSkinManager getCoinSoundNameIndex:(int)[kAppDelegate getSkin]];
    //[kAppDelegate playSound:@"smb3_coin6.caf"];
    [kAppDelegate playSound:soundName];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {

    if(sender == self.soundVolumeSlider)
    {
        [kAppDelegate setSoundVolume:sender.value];

        [kHelpers sendGoogleAnalyticsEventWithCategory:@"settings" andAction:@"tap" andLabel:@"sliderVolumeSound"];


    }
    else if(sender == self.musicVolumeSlider)
    {
        [kHelpers sendGoogleAnalyticsEventWithCategory:@"settings" andAction:@"tap" andLabel:@"sliderVolumeMusic"];

        [kAppDelegate setMusicVolume:sender.value];
    }

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

-(void)bringSubviewsToFront
{
    //top
    [self.view bringSubviewToFront:self.curtainLeft];
    [self.view bringSubviewToFront:self.curtainRight];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.vcr];
    [self.view bringSubviewToFront:self.scanline];
}

-(void)fadeIn {
    [self setupFade];

    [self bringSubviewsToFront];

    //reset
    [self.darkImage.layer removeAllAnimations];

    self.darkImage.alpha = 0.0f;
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

    [self bringSubviewsToFront];

    //reset
    [self.darkImage.layer removeAllAnimations];

    self.darkImage.alpha = 1.0f;
    [UIView animateWithDuration:kFadeDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.darkImage.alpha = 0.0f;

				//reset fade white
				kAppDelegate.fadingWhite = NO;

    } completion:nil];

    //curtains
    [self openCurtains];
}

-(void)openCurtains {

    self.curtainLeft.userInteractionEnabled = YES;
    self.curtainRight.userInteractionEnabled = YES;

    [self bringSubviewsToFront];

    //reset
    self.curtainLeft.hidden = NO;
    self.curtainRight.hidden = NO;

    CGRect screenRect = [kHelpers getScreenRect];
    self.curtainLeft.x = 0;
    self.curtainRight.x = screenRect.size.width-self.curtainRight.width;

    //force no anim?
    //[UIView beginAnimations:nil context:nil];

    [kAppDelegate playSound:kCurtain2Sound];

    [UIView animateWithDuration:kCurtainAnimDuration delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{

        self.curtainLeft.x =-self.curtainLeft.width;
        self.curtainRight.x = screenRect.size.width;

    }
                     completion:^(BOOL finished){
                         self.curtainLeft.hidden = YES;
                         self.curtainRight.hidden = YES;

                         //because overlap
                         //[self showCoffee];
                     }];
}

-(void)closeCurtains {

    CGRect screenRect = [kHelpers getScreenRect];

    //top
    [self bringSubviewsToFront];

    //reset
    self.curtainLeft.hidden = NO;
    self.curtainRight.hidden = NO;

    self.curtainLeft.x = -self.curtainLeft.width;
    self.curtainRight.x = screenRect.size.width;

    //hide before overlap
    [self stopCoffee];

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

-(void)addShineAnimation {
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    //rotate.toValue = [NSNumber numberWithFloat:-M_PI*2];
    rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.duration = 32;
    rotate.repeatCount = HUGE_VALF;
    [self.shineImageView.layer removeAllAnimations];

    [self.shineImageView.layer addAnimation:rotate forKey:@"10"];

}

- (void)notifyForeground
{
    if(kAppDelegate.titleController.menuState != menuStateSettings)
        return;

    //only for iOS7
    //if(kIsIOS8)
    //    return;

    //re-add anim
    [self addShineAnimation];

    [self showWhiteBar];

}


- (void) shakeWasRecognized:(NSNotification*)notif {

    if([kHelpers isBackground])
        return;

    if(kAppDelegate.titleController.menuState == menuStateSettings) {

        //[self cheatsButtonPressed:nil];
    }

}

- (IBAction)cheatsButtonPressed:(id)sender
{
    self.skipFade = NO;

    //self.resumeButton.alpha = kButtonSelectedAlpha;


    [self enableButtons:NO];

    [kAppDelegate playSound:kClickSound];

    kAppDelegate.titleController.menuState = menuStateCheat;

    [self fadeIn];
    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[kAppDelegate setViewController:kAppDelegate.cheatController];

    });

}

- (void)notifyBackground
{
    //only for iOS7
    //if(kIsIOS8)
    //    return;

    //fix crash
    [self.shineImageView.layer removeAllAnimations];
}

- (void)resetTimer{

    //cloud
    [self.timerCloud invalidate];
    self.timerCloud = nil;

    int interval = kCloudInterval;
    self.timerCloud = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerCloud:) userInfo:@"actionTimerCloud" repeats:YES];

    //call now
    [self actionTimerCloud:nil];


    //vcr
    [self.timerVCR invalidate];
    self.timerVCR = nil;
    interval = 2.0 + (arc4random_uniform(3*10)/10.0f);
    self.timerVCR = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                   selector:@selector(actionTimerVCR:) userInfo:@"actionTimerVCR" repeats:NO];


	//bounce
    [self.timerBounce invalidate];
    self.timerBounce = nil;
    interval = 3.0;
    self.timerBounce = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                      selector:@selector(actionTimerBounce:) userInfo:@"actionTimerBounce" repeats:YES];
}

- (void) actionTimerBounce:(NSTimer *)incomingTimer
{
    [kAppDelegate animateControl:self.twitterButton];
    [kAppDelegate animateControl:self.instaButton];
    [kAppDelegate animateControl:self.youtubeButton];
    [kAppDelegate animateControl:self.discordButton];
    [kAppDelegate animateControl:self.mailingButton];
    [kAppDelegate animateControl:self.likeButton];
    [kAppDelegate animateControl:self.spriteKitButton];

    [kAppDelegate animateControl:self.coffeeImage];
    [kAppDelegate animateControl:self.coffeeButton];

}

- (void) actionTimerVCR:(NSTimer *)incomingTimer
{
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

    if(kAppDelegate.titleController.menuState != menuStateSettings || (self.view.hidden == YES))
        return;

    if(!self.curtainLeft.hidden)
        return;

    if([kHelpers isSlowDevice])
        return;

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        return;

    self.vcr.hidden = NO;
    self.vcr.alpha = 0.0f;

    [kAppDelegate playSound:@"noise2.caf"];

    ///fade out
    [UIView animateWithDuration:kVCRDelayIn delay:0.0 options:0 animations:^{
        self.vcr.alpha = kVCRAlpha;

    } completion:^(BOOL finished){

        //fade out
        [UIView animateWithDuration:kVCRDelayOut delay:kVCRDelayWait options:0 animations:^{
            self.vcr.alpha = 0.0f;
        } completion:^(BOOL finished){
            self.vcr.hidden = YES;
        }];
        //});

    }];

}


- (void) actionTimerCloud:(NSTimer *)incomingTimer
{
    if(kAppDelegate.titleController.menuState != menuStateSettings || (self.view.hidden == YES))
        return;

    [self showCloud];
}


-(void)showCloud {

    //disabled
    return;

#if 0
    //still on screen
    if(self.cloud1.frame.origin.x < self.view.frame.size.width && self.cloud1.frame.origin.x > 0)
        return;

    self.cloud1.hidden = NO;
    self.cloud1.alpha = kCloudAlpha;

    self.cloud1.x = -kCloudWidth;
    //self.cloud1.y = 100 + arc4random_uniform(self.view.frame.size.height-100);
    self.cloud1.y = kCloudY;

    [UIView animateWithDuration:kCloudDuration delay:0.0 options:0 animations:^{
        self.cloud1.x += self.view.width + kCloudWidth*2;
    } completion:^(BOOL finished){
        //Log(@"cloud done");
    }];
#endif
}

#pragma mark scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //Log(@"scrollViewDidScroll");
}


#pragma mark Facebook

-(void)updateFacebookProfileImage {
#if kParseEnabled
    PFUser *currentUser = [PFUser currentUser];
    if(!currentUser)
        return;

    NSString *facebookID =  [currentUser objectForKey:@"facebookId"];
    if(!facebookID)
        return;

    NSString *photoURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:photoURL] options:0 progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

                            if(image && finished){

                                //save profile photo
                                PFUser *currentUser = [PFUser currentUser];

                                NSData *imageData = UIImageJPEGRepresentation(image, 0.9f);
                                PFFile *imageFile = [PFFile fileWithName:@"profileImage.jpg" data:imageData];

                                [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                    if (!error && succeeded) {

                                        [currentUser setObject:imageFile forKey:@"profileImage"];
                                        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                            if (!error && succeeded) {
                                                //done

                                                [kHelpers showSuccessHud:LOCALIZED(@"kStringSuccess")];

                                                float secs = 0.1f;
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                    [kAppDelegate updateProfileImage];
                                                });

                                            }
                                            else {
                                                //could not save
                                                Log(@"Could not save profile image");
                                            }
                                        }];
                                    }
                                    else {
                                        Log(@"Could not save profile image");
                                    }


                                }];

                            }
                            else {


                            }

                        }];
#endif
}

- (IBAction)actionFacebook:(id)sender {
}

-(void)updateLoginButton
{

    //button title
    NSString *tempTitle = nil;
    NSMutableAttributedString *attributedString = nil;
    float spacing = 2.0f;

    //button title
    if([kAppDelegate isLoggedIn]) {
        tempTitle = @"Logout";
        self.loginButton.hidden = NO;

    }
    else {
        tempTitle = @"Login";

        //disable
        self.loginButton.hidden = YES; //YES

    }

    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.loginButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}


- (IBAction)spriteKitButtonPressed:(id)sender{
    [self enableButtons:NO];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self enableButtons:YES];
    });

    [kAppDelegate animateControl:self.spriteKitButton];

    [kAppDelegate playSound:kClickSound];

    NSURL *webURL = [NSURL URLWithString:@"https://developer.apple.com/spritekit/"];
    [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
}

- (IBAction)actionTwitter:(id)sender{
#if 0
    //offline
    if(![kHelpers checkOnline]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        return;
    }

    //reset
    [PFUser logOut];

    //logout twitter
    [PFTwitterUtils initializeWithConsumerKey:kTwitterAPIKey consumerSecret:kTwitterAPISecret];

    //login
    [kHelpers showMessageHud:LOCALIZED(@"kStringConnecting")];

    [PFTwitterUtils logInWithBlock:^(PFUser *user, NSError *error) {
        [kHelpers dismissHud];

        //error
        if(error) {
            [kHelpers dismissHud];

            if(error) {
                NSString *message = [NSString stringWithFormat:@"%@ %@", LOCALIZED(@"kStringTwitterSignupError"), [error errorString] ];
                [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:message];
            }
            else {
                NSString *message = [NSString stringWithFormat:@"%@", LOCALIZED(@"kStringTwitterSignupError")];
                [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:message];

            }

        }
        else {

            //good
            if (!user) {

                //cancel, nothing to do
                Log(@"Uh oh. The user cancelled the Twitter login.");

            }
            else { //always save

                //new user, update
                //link error?
                NSString *twitterUsername = @""; //[PFTwitterUtils twitter].screenName;
                NSString *twitterId = @""; //[PFTwitterUtils twitter].userId;

                Log(@"twitter: %@", twitterUsername);

                //language
                NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
                if(language)
                    [user setObject:language forKey:@"language"];

                //add more info
                [user setObject:twitterUsername forKey:@"username"];
                [user setObject:twitterUsername forKey:@"first_name"];
                [user setObject:twitterId forKey:@"twitterId"];
                [user setObject:@"twitter" forKey:@"loginType"];

                [user setObject:[NSNumber numberWithBool:YES] forKey:@"Enable"]; //enable

                [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error && succeeded) {
                        //done

                        //profile
                        [self updateTwitterProfileImage];

                        [self updateLoginButton];

                        //[kHelpers showSuccessHud:LOCALIZED(@"kStringSuccess")];

                    }
                    else {
                        //could not save

                        //force logout
                        [PFUser logOut];

                        NSString *message = nil;
                        if(error) {
                            message = [NSString stringWithFormat:@"%@ %@", LOCALIZED(@"kStringTwitterSignupError"),
                                       [error errorString] ];
                        }
                        else {
                            message = [NSString stringWithFormat:@"%@", LOCALIZED(@"kStringTwitterSignupError")];
                        }

                        [kHelpers dismissHud];

                        [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:message];

                    }
                }];


            }
        }
    }];

#endif
}


-(void)updateTwitterProfileImage {
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


-(void)showVCR:(BOOL)show animated:(BOOL)animated {

    if(!kVCRAlertEnabled)
        return;

    float alpha = kVCRAlphaPaused;

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

- (IBAction)instaButtonPressed:(id)sender {

    [self enableButtons:NO];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self enableButtons:YES];
    });

    [kAppDelegate animateControl:self.instaButton];

    [kAppDelegate playSound:kClickSound];

    [self gotoInsta];
}

- (void)gotoInsta
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"instagram://user?username=skyrisermedia"] options:@{} completionHandler:nil];

    }
    else
    {
        NSURL *webURL = [NSURL URLWithString:@"http://instagram/skyrisermedia"];
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }

    //achievement
    [kAppDelegate reportAchievement:kAchievement_social];
}


- (IBAction)youtubeButtonPressed:(id)sender {

    [self enableButtons:NO];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self enableButtons:YES];
    });

    [kAppDelegate animateControl:self.youtubeButton];

    [kAppDelegate playSound:kClickSound];

    [self gotoYoutube];
}

- (void)gotoYoutube
{
    /*if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"instagram://"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"instagram://user?username=skyrisermedia"] options:@{} completionHandler:nil];

    }
    else*/
    {
        //NSURL *webURL = [NSURL URLWithString:@"https://www.youtube.com/user/skyrisermedia"];
        //NSURL *webURL = [NSURL URLWithString:@"https://www.youtube.com/channel/UCPh2MfJijfkwnPZvGzIk9Bw"];
        NSURL *webURL = [NSURL URLWithString:@"https://coinyblock.com/youtube"];
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }

    //achievement
    [kAppDelegate reportAchievement:kAchievement_social];
}

- (IBAction)discordButtonPressed:(id)sender {

    [self enableButtons:NO];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self enableButtons:YES];
    });

    [kAppDelegate animateControl:self.discordButton];

    [kAppDelegate playSound:kClickSound];

    [self gotoDiscord];
}

- (void)gotoDiscord
{
    {
        //NSURL *webURL = [NSURL URLWithString:@"https://discord.gg/73hpA5A"];
        NSURL *webURL = [NSURL URLWithString:@"http://coinyblock.com/discord"];
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }

    //achievement
    [kAppDelegate reportAchievement:kAchievement_social];
}

/*- (IBAction)mailingButtonPressed:(id)sender {

    [self enableButtons:NO];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self enableButtons:YES];
    });

    [kAppDelegate animateControl:self.mailingButton];

    [kAppDelegate playSound:kClickSound];

    [self gotoMailing];
}
*/

- (IBAction)mailingButtonPressed:(id)sender
{
    [kAppDelegate animateControl:self.mailingButton];
    [kAppDelegate playSound:kClickSound];

    //alert
    __weak typeof(self) weakSelf = self;

    NSString *message = LOCALIZED(@"kStringMailingAsk");

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Newsletter"
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringMailingButton")
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * 0.33f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                                               kAppDelegate.mailingAsked = YES;
                                               [kAppDelegate saveState];

                                               [self gotoMailing];
                                           });


                                       }];

    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

        [weakSelf showVCR:NO animated:YES];

    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];
    [self showVCR:YES animated:YES];
}


- (void)gotoMailing
{
    {
        NSURL *webURL = [NSURL URLWithString:kURLMailing];
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }

    //achievement
    [kAppDelegate reportAchievement:kAchievement_social];
}


- (IBAction)twitterButtonPressed:(id)sender {

    [self enableButtons:NO];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self enableButtons:YES];
    });


    [kAppDelegate animateControl:self.twitterButton];

    [kAppDelegate playSound:kClickSound];

    [self gotoTwitter];
}

- (void)gotoTwitter
{

    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=SkyriserMedia"] options:@{} completionHandler:nil];

    }
    else
    {
        NSURL *webURL = [NSURL URLWithString:@"http://twitter.com/SkyriserMedia"];
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }

	//achievement
	[kAppDelegate reportAchievement:kAchievement_social];
}


- (IBAction)likeButtonPressed:(id)sender {

    [self enableButtons:NO];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self enableButtons:YES];
    });

    [kAppDelegate animateControl:self.likeButton];

    [kAppDelegate playSound:kClickSound];

    [self gotoFacebook];
}

- (void)gotoFacebook
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]])
    {
        //[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"fb://profile/CoinBlockApp"]];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/868865553150465"] options:@{} completionHandler:nil]; //coinblock

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/78932345192"] options:@{} completionHandler:nil]; //skyriser

    }
    else
    {
        //fanPageURL failed to open.  Open the website in Safari instead
        //NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/pages/Password-Grid/169115183113120"];

        //NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/CoinyBlock"];
        NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/SkyriserMedia"];
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }

	//achievement
	[kAppDelegate reportAchievement:kAchievement_social];
}

- (IBAction)coffeeButtonPressed:(id)sender
{
	NSString *price = [kAppDelegate.iapPrices objectForKey:kIAP_Coffee];
    NSString *buttonTitle = nil;
    if(price)
	{
        //buttonTitle = [NSString stringWithFormat:@"☕ ❤️ (%@)", price];
        buttonTitle = [NSString stringWithFormat:@"❤️ %@", price];
	}
	else
	{
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
		return;
	}

    [kAppDelegate animateControl:self.coffeeButton];
    [kAppDelegate animateControl:self.tipButton];

	 [kAppDelegate playSound:kClickSound];
	 //[kAppDelegate playSound:@"kiss.caf"];

    [self enableButtons:NO];


    __weak typeof(self) weakSelf = self;

    //ask
    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Tip Jar"
                   andMessage:kAppDelegate.inReview ? LOCALIZED(@"kStringCoffeeMessage") : LOCALIZED(@"kStringCoffeeMessage2")];


    //bitcoin
    if(!kAppDelegate.inReview)
    {
      [kAppDelegate.alertView addButtonWithTitle:@"Send Bitcoin..."
                                                 type:kAlertButtonOrange
                                              handler:^(SIAlertView *alert) {

                                                [kAppDelegate playSound:kClickSound];

                                                [self enableButtons:NO];

                                                //after delay
                                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                                    [self enableButtons:YES];

                                                    [self bitcoinPressed];
                                                });

                                              }];
    }


    //iap
    [kAppDelegate.alertView addButtonWithTitle:buttonTitle
                                  type:kAlertButtonGreen
                               handler:^(SIAlertView *alert) {
									[self coffeeButtonPressed2];
                               }];


    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing

        [weakSelf enableButtons:YES];

    }];

    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

        [weakSelf showVCR:NO animated:YES];

        [weakSelf enableButtons:YES];


    }];

    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    float secs = 0.3f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kAppDelegate.alertView show:YES];
        [self showVCR:YES animated:YES];

        //sound sip
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [kAppDelegate playSound:@"coffee_sip.caf"];
        //});
    });
}

- (void)bitcoinPressed
{
  //refill
  //kAppDelegate.numHearts = kHeartFull;

  __weak typeof(self) weakSelf = self;

  //another alert

  kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Send Bitcoin"
                 andMessage:[NSString stringWithFormat:@"Bitcoin address:\n<color1>%@</color1>\n", kBitcoinAddress]];

  [kAppDelegate.alertView addButtonWithTitle:@"Copy"
                                               type:kAlertButtonGreen
                                            handler:^(SIAlertView *alert) {
                                                [kAppDelegate playSound:kClickSound];

                                                //Copy
                                                [kHelpers textToClipboard:kBitcoinAddress];
                                            }];

  [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
      //nothing
  }];


  [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
      [weakSelf enableButtons:YES];
      [weakSelf showVCR:NO animated:YES];
  }];


  //kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
  kAppDelegate.alertView.transitionStyle = kAlertStyle;

  [kAppDelegate.alertView show:YES];

  [self showVCR:YES animated:YES];
}

- (void)coffeeButtonPressed2
{
	//[kAppDelegate playSound:@"kiss.caf"];

    [self enableButtons:NO];

    [kAppDelegate playSound:kClickSound];


    //offline
    if(![kHelpers checkOnline]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        [self enableButtons:YES];
        return;
    }

    SKProduct *product = nil;
    NSString *whichProduct = kIAP_Coffee;
    //find product
    for(SKProduct *tempProduct in [IAPShare sharedHelper].iap.products) {
        //for(SKProduct *tempProduct in kAppDelegate.iapProducts) {
        if([tempProduct.productIdentifier isEqualToString:whichProduct]) {
            product = tempProduct;
            break;
        }
    }

    //invalid?
    if(!product || ![kHelpers checkOnline]) {
        [kAppDelegate getIAP];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            if(![kHelpers checkOnline])
                [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
            else
                [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];

            [self enableButtons:YES];
        });

        return;
    }

   //buy
   //SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:0];

   if(product) {
	   [kHelpers showMessageHud:@"Connecting..."];

	   [[IAPShare sharedHelper].iap buyProduct:product
								  onCompletion:^(SKPaymentTransaction* trans){

									  [kHelpers dismissHud];

                                      [self enableButtons:YES];

									  if(trans.error)
									  {
										  //just cancelled
										  if(trans.error.code == SKErrorPaymentCancelled){
											  Log(@"SKPaymentTransactionStateFailed: SKErrorPaymentCancelled");
										  }
										  else
											  [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];

										  [self enableButtons:YES];
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
											 	//good

											  	kAppDelegate.coffeeCount++;

												//achievement
												if(kAppDelegate.coffeeCount >= 1)
													[kAppDelegate reportAchievement:kAchievement_coffee];

												if(kAppDelegate.coffeeCount >= 2)
													[kAppDelegate reportAchievement:kAchievement_coffee2];

												if(kAppDelegate.coffeeCount >= 3)
													[kAppDelegate reportAchievement:kAchievement_coffee3];

												//save
												[[IAPShare sharedHelper].iap provideContentWithTransaction:trans];

												//refill
												kAppDelegate.numHearts = kHeartFull;
												//[self setNumHearts:(int)kAppDelegate.numHearts];

												//date
												kAppDelegate.coffeeDate = [NSDate date];

                                                  //also disable banner ads temporarily
                                                  kAppDelegate.adBannerEnabledTemp = NO;

												[kAppDelegate saveState];

												[kAppDelegate playSound:kUnlockSound];
												[kAppDelegate playSound:kUnlockSound2];

												[kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
												[self startConfetti];
												float secs = kConfettiThanksDuration;
												dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
													[self stopConfetti];
												});

                                                [self enableButtons:YES];

											  }
											  else {
												  [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
												  [self enableButtons:YES];

											  }
										  }];
									  }
									  else if(trans.transactionState == SKPaymentTransactionStateFailed) {
										  [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
										  [self enableButtons:YES];
									  }
								  }];//end of buy product
   }
   else {
	   [kAppDelegate getIAP];
	   [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
	   [self enableButtons:YES];

   }

}

-(void)showCoffee
{
    NSString *price = [kAppDelegate.iapPrices objectForKey:kIAP_Coffee];
    if(!price)
    {
        //offline?
        //[self stopCoffee];
        //return;
    }

    //date
    /*if(kAppDelegate.coffeeDate)
    {
        //BOOL daysEnough = ([[NSDate date] daysAfterDate:kAppDelegate.coffeeDate] > 7);
        BOOL hoursEnough = ([[NSDate date] hoursAfterDate:kAppDelegate.coffeeDate] > 24*1);

        if(!hoursEnough)
        {
            [self stopCoffee];
            return;
        }
    }*/

    //show
    self.coffeeButton.hidden = YES;
    self.coffeeImage.hidden = NO;
    self.tipButton.hidden = NO;

    //particles
	if(self.coffeeEmitter)
	{
        //already created
        self.coffeeEmitter.birthRate = 0;
        self.coffeeEmitter.emitterCells = nil;
        //kill
        [self.coffeeEmitter removeFromSuperlayer];
        self.coffeeEmitter = nil;
	}

    //new create
    self.coffeeEmitter = [CAEmitterLayer layer];

    self.coffeeEmitter.emitterPosition = CGPointMake(0,0);
    self.coffeeEmitter.emitterSize	= CGSizeMake(20, 1);
    self.coffeeEmitter.emitterMode	= kCAEmitterLayerOutline;
    self.coffeeEmitter.emitterShape	= kCAEmitterLayerLine;
    self.coffeeEmitter.renderMode = kCAEmitterLayerAdditive;
    self.coffeeEmitter.seed = (arc4random()%100)+1;

    //delay
    self.coffeeEmitter.birthRate = 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.coffeeEmitter.birthRate = 5;
    });

	//smoke cell
	CAEmitterCell* smokeCell = [CAEmitterCell emitterCell];
	smokeCell.contents = (__bridge id)[[UIImage imageNamed:@"spark2.png"] CGImage]; //spark2.png
	[smokeCell setName:@"smokeCell"];

	smokeCell.birthRate = 1;
	smokeCell.lifetime = 2.0;
	smokeCell.lifetimeRange = 0.5f;
    smokeCell.color = [[[UIColor whiteColor] colorWithAlphaComponent:0.4f] CGColor] ;
    smokeCell.alphaSpeed = -0.2f;
    //smokeCell.alphaRange = 0.2f;
//	smokeCell.velocity = 10;
//	smokeCell.velocityRange = 10;
	smokeCell.yAcceleration = -20;
	smokeCell.emissionLongitude = -M_PI / 2;
	smokeCell.emissionRange = M_PI / 4;
	smokeCell.scale = 0.1f;
	smokeCell.scaleRange = 0.1f;

	//add cells
	self.coffeeEmitter.emitterCells = [NSArray arrayWithObject:smokeCell];

	//add emitter
    [self.view.layer addSublayer:self.coffeeEmitter];
}

-(void)stopCoffee
{
    //stop particles
	self.coffeeEmitter.birthRate = 0.0;

//    self.coffeeButton.hidden = YES;
//    self.coffeeImage.hidden = YES;
}

@end
