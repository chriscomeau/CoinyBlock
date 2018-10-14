//
//  CBTitleViewController.m
//  Emergency
//
//  Created by Chris Comeau on 2014-05-20.
//  Copyright (c) 2014 Face 3 Media. All rights reserved.
//

//test commit

#import "CBTitleViewController.h"
#import "UIButton+BadgeValue.h"
#import "CBConfettiView.h"
#import "UIResponder+MotionRecognizers.h"
#import "CBVideoPlayerViewController.h"

#if kKTPlayEnabled
#import "KTPlay.h"
#endif

@interface CBTitleViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIImageView *shineImageView;
@property (nonatomic, strong) IBOutlet UIImageView *cloud1;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;
@property (nonatomic, strong) IBOutlet UIImageView *block;
@property (nonatomic, strong) IBOutlet UIImageView *redArrow;
@property (nonatomic, strong) IBOutlet UIImageView *redArrowLeft;
@property (nonatomic, strong) IBOutlet UIImageView *redArrowRight;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;
@property (nonatomic, strong) IBOutlet UIImageView *vcr;
@property (nonatomic, strong) IBOutlet UIImageView *logo;
@property (nonatomic, strong) IBOutlet UIImageView *logoSubtitle;
@property (nonatomic, strong) IBOutlet UIImageView *verified;
@property (weak, nonatomic) IBOutlet UIImageView *flashImage;
@property (weak, nonatomic) IBOutlet UIImageView *coinsImage;

@property (weak, nonatomic) IBOutlet UIImageView *chestImage;
@property (weak, nonatomic) IBOutlet UIButton *chestButton;
@property (weak, nonatomic) IBOutlet UILabel *chestLabel;
@property (nonatomic, strong) IBOutlet UIImageView *chestShine;
@property (nonatomic, strong) IBOutlet UIImageView *chestBadge;

@property (weak, nonatomic) IBOutlet UIImageView *multImage;
@property (weak, nonatomic) IBOutlet UIButton *multButton;
@property (weak, nonatomic) IBOutlet UILabel *multLabel;
@property (nonatomic, strong) IBOutlet UIImageView *multShine;
@property (nonatomic, strong) IBOutlet UIImageView *multBadge;

@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIImageView *downloadBadge;

@property (nonatomic, strong) IBOutlet UIButton *logoButton;
@property (nonatomic, strong) IBOutlet UIButton *resumeButton;
@property (nonatomic, strong) IBOutlet UIButton *cheatButton;
@property (nonatomic, strong) IBOutlet UIButton *cheatButton2;
@property (nonatomic, strong) IBOutlet UIButton *storeButton;
@property (nonatomic, strong) IBOutlet UIButton *titleBarButton;
@property (nonatomic, strong) IBOutlet UIButton *rateButton;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic, strong) IBOutlet UIButton *socialButton;
@property (nonatomic, strong) IBOutlet UIButton *adButton;
@property (nonatomic, strong) IBOutlet UIButton *adButton2;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *twitterButton;
@property (nonatomic, strong) IBOutlet UIButton *otherButton;
@property (nonatomic, strong) IBOutlet UIButton *otherButton2;
@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) IBOutlet UIButton *optionsButton2;
@property (nonatomic, strong) IBOutlet UIButton *volumeButton;
@property (nonatomic, strong) IBOutlet UIButton *leaderboardButton;
@property (nonatomic, strong) IBOutlet UIButton *leaderboardButton2;
@property (nonatomic, strong) IBOutlet UIButton *contactButton;
@property (nonatomic, strong) IBOutlet UIButton *versionButton;
@property (nonatomic, strong) IBOutlet UIButton *premiumButton;
@property (nonatomic, strong) IBOutlet UIButton *modeButton;
@property (nonatomic, strong) IBOutlet UIImageView *carouselBadge;
@property (nonatomic, strong) IBOutlet UIButton *carouselBadgeButton;
@property (nonatomic, strong) IBOutlet UIImageView *premiumBadge;
@property (nonatomic, strong) IBOutlet UIImageView *premiumBack;
@property (nonatomic, strong) IBOutlet UIImageView *premiumLock;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;
@property (nonatomic, strong) IBOutlet UILabel *parseCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *labelSubtitle;
@property (nonatomic, strong) IBOutlet UILabel *labelSuffix;
@property (nonatomic, strong) IBOutlet UILabel *labelSuffixMulti;
@property (nonatomic, strong) IBOutlet UILabel *skinName;
@property (nonatomic, strong) IBOutlet UILabel *skinType;
@property (nonatomic, strong) IBOutlet UILabel *lifeLabel;
@property (nonatomic, strong) IBOutlet UILabel *comboLabel;
@property (nonatomic, strong) IBOutlet UILabel *fraction;
@property (nonatomic, strong) IBOutlet UILabel *socialMessage;
@property (nonatomic, strong) IBOutlet UILabel *blockMessage1;
@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (weak, nonatomic) IBOutlet UIImageView *darkAdImage;
@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (weak, nonatomic) IBOutlet UIImageView *heart1;
@property (weak, nonatomic) IBOutlet UIImageView *heart2;
@property (weak, nonatomic) IBOutlet UIImageView *heart3;
@property (weak, nonatomic) IBOutlet UIImageView *heart4;
@property (weak, nonatomic) IBOutlet UIImageView *heartPlus;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (nonatomic, strong) IBOutlet UIButton *heartButton;
@property (nonatomic, strong) IBOutlet UIImageView *touch1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touch1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touch1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *versionBottom;

@property (weak, nonatomic) IBOutlet UIButton *hashtag;
@property (strong, nonatomic) NSTimer *timerCloud;
@property (strong, nonatomic) NSTimer *timerBg;
@property (strong, nonatomic) NSTimer *timerParseCount;
@property (strong, nonatomic) NSTimer *timerArrow;
@property (strong, nonatomic) NSTimer *timerMult;
@property (strong, nonatomic) NSTimer *timerVCR;
@property (strong, nonatomic) NSTimer *timerCheat;
@property (strong, nonatomic) NSTimer *timerStory;
@property (strong, nonatomic) NSTimer *timerBounce;
@property (strong, nonatomic) NSTimer *timerSocial;
@property (strong, nonatomic) NSTimer *timerBlockMessage;
@property (strong, nonatomic) NSTimer *timerLabelResult;

@property (weak, nonatomic) IBOutlet UIImageView *tutoArrow;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *curtainLeftXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *curtainRightXConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *carouselTopConstraint;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *modeBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heartTopConstraint;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic) int oldResumeY;
@property (nonatomic) int oldBlockY;
@property (nonatomic) int multColorIndex;
@property (nonatomic) int cheatVersionCount;
//@property (strong, nonatomic) SIAlertView *alertView;
@property (nonatomic) BOOL sharing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backgroundConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resumeButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *storeButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rateButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionsButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leaderboardButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactButtonConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *arrowLeftConstraint;

@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSString *startText;
@property (nonatomic) BOOL isRandoming;
@property (nonatomic) BOOL didAppear;
@property (nonatomic) BOOL animateRandom;
@property (nonatomic) BOOL skipFade;
@property (nonatomic) BOOL showingKTPlay;
@property (nonatomic) BOOL activityKTPlay;
@property (nonatomic) int randomBackgroundIndex;
@property (nonatomic) int askedPremium;
@property (nonatomic) int askedMailing;
@property (nonatomic) int askedRate;
@property (nonatomic) BOOL didShowInterstitial;
@property (nonatomic) BOOL boolTimerLabelChest;
@property (nonatomic) BOOL alreadyAnimatedLogo;

@property (strong, nonatomic) NSMutableArray *allBGImages;

@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;


- (IBAction)resumeButtonPressed:(id)sender;
- (IBAction)storeButtonPressed:(id)sender;
- (IBAction)versionButtonPressed:(id)sender;
- (IBAction)rateButtonPressed:(id)sender;
- (IBAction)otherButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)socialButtonPressed:(id)sender;
- (IBAction)cheatsButtonPressed:(id)sender;
- (IBAction)likeButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)adButtonPressed:(id)sender;
- (IBAction)premiumButtonPressed:(id)sender;
- (IBAction)optionsButtonPressed:(id)sender;
- (IBAction)volumeButtonPressed:(id)sender;
- (IBAction)leaderboardButtonPressed:(id)sender;
- (IBAction)contactButtonPressed:(id)sender;
- (IBAction)actionHashtag:(id)sender;
- (IBAction)actionInfo:(id)sender;

@property (strong, nonatomic) FISound *soundCard;
@property (strong, nonatomic) NSMutableArray *soundArray;

@end

@implementation CBTitleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];


    [kAppDelegate scaleView:self.view];

    [kHelpers loopInBackground];

    [self setupFade];
    [self bringSubviewsToFront];

    //init
    self.startText = @"";

    self.numApps = @(0);
    self.randomBackgroundIndex = 0;
    self.menuState = menuStateLoading;

    //corner
    [kAppDelegate cornerView:self.view];

    self.coinsImage.hidden = YES;

	self.carouselBadge.hidden = YES;

    //chest
    [self hideChest];

    //flash
    self.flashImage.image = nil;
    self.flashImage.alpha = 0.0f;
    self.flashImage.hidden = YES;


    [UIView setAnimationsEnabled:NO];

    if(kVCRAnimEnabled) {
        self.vcr.animationImages = @[[UIImage imageNamed:@"vcr"], [UIImage imageNamed:@"vcr2"]];
        self.vcr.animationDuration = kVCRAnimDuration;
        self.vcr.animationRepeatCount = 0;
    }

    //kAppDelegate.titleController= self;

    [self setupConfetti];

    [self setupWhiteBar];

    [self updateBackground:NO];

    //curtains
    CGRect screenRect = [kHelpers getScreenRect];
    self.curtainLeft.x = 0;
    self.curtainRight.x = screenRect.size.width-self.curtainRight.width;


    //disable autolayout
    self.curtainLeft.translatesAutoresizingMaskIntoConstraints = YES;
    self.curtainRight.translatesAutoresizingMaskIntoConstraints = YES;

    //constraints
    //self.curtainLeftXConstraint.active = NO;
    //self.curtainRightXConstraint.active = NO;

    if([kHelpers isIphone4Size])
    {
        int offset = 5; //(568-480)
        //self.logoConstraint.constant -= offset;

        //offset = 10;
        //self.resumeButtonConstraint.constant -= offset;

        offset = 20;
        self.storeButtonConstraint.constant -= offset;
        //self.optionsButtonConstraint.constant -= offset;

        offset = 35;
        self.optionsButtonConstraint.constant -= offset;
        //self.contactButtonConstraint.constant -= offset;

        //offset = 45;
        //self.rateButtonConstraint.constant -= offset;

        //self.otherButtonConstraint.constant -= offset;
        //self.shareButtonConstraint.constant -= offset;
        //self.leaderboardButtonConstraint.constant -= offset;
    }

    //sounds
    [self loadSounds];

    int shadowOffset = 2;
    UIColor *shadowColor = kTextShadowColor;

    //cloud
    self.cloud1.image = [UIImage imageNamed:kCloudName];
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    self.spinner.color = RGB(248,216,0);
    self.spinner.hidden = YES;

    //block
    self.block.alpha = 1.0;
    self.block.image = [UIImage imageNamed:@"title_block2"];
    self.block.hidden = YES; //disabled

    //block
    /*NSArray *imageNames = @[@"block5Frame1", @"block5Frame2", @"block5Frame3", @"block5Frame4", @"block5Frame1",
                            @"block5Frame1", @"block5Frame1", @"block5Frame1", @"block5Frame1", @"block5Frame1"];

    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }*/

    // block animation
    //self.block.animationImages = images;
    //self.block.animationDuration = 1.0;
    //[self.block startAnimating];

    self.block.image = [CBSkinManager getBlockImage];

    UIFont *buttonFont1 = [UIFont fontWithName:kFontName size:([kHelpers isIphone4Size] ? 28 : 20)*kFontScale];
    UIFont *buttonFont2 = [UIFont fontWithName:kFontName size:([kHelpers isIphone4Size] ? 14 : 16)*kFontScale];
    UIFont *buttonFont3 = [UIFont fontWithName:kFontName size:([kHelpers isIphone4Size] ? 18 : 20)*kFontScale];

    self.view.backgroundColor = [UIColor blackColor];


    //social
    self.socialMessage.font = [UIFont fontWithName:@"OrangeKid-Regular" size:16];
    self.socialMessage.font = [UIFont fontWithName:kFontNamePlus size:10];

    self.socialMessage.textAlignment = NSTextAlignmentCenter;
    self.socialMessage.textColor = [UIColor whiteColor];
    self.socialMessage.alpha = 1.0;
    self.socialMessage.hidden = YES;
    self.socialMessage.userInteractionEnabled = NO;

    //mode
    self.modeButton.titleLabel.font = [UIFont fontWithName:kFontName size:11*kFontScale]; //13
    self.modeButton.alpha = 0.7f;

    float inset = 2.0f;
    [self.modeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    [self.modeButton setTintColor:kYellowTextColor];
    //[self.modeButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.modeButton setTitleColor:RGB(250, 250, 250) forState:UIControlStateNormal]; //white/grey

    self.modeButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.modeButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    int buttonCornerRadius = 10;
    int buttonBorderWidth = 2;
    UIColor *buttonColor = RGBA(0,0,0, 0.3f); //RGBA(255,255,255, 0.1f);
    UIColor *borderColor = kYellowTextColor;

    CALayer * l = nil;

    //reset
    self.modeButton.clipsToBounds = NO;
    self.modeButton.titleLabel.clipsToBounds = NO;
    self.modeButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.modeButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.modeButton.titleLabel.layer.shadowRadius = 0.0f;
    self.modeButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.modeButton.titleLabel.layer.masksToBounds = NO;
    self.modeButton.backgroundColor = buttonColor;

    l = [self.modeButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];

    NSMutableAttributedString *attributedString = nil;
    float spacing = 2.0f; //2.0f
    //NSString *tempTitle = @"Mode:\nStory"; //self.modeButton.titleLabel.text;
    NSString *tempTitle = @"Story\nMode"; //self.modeButton.titleLabel.text;
    //NSString *tempTitle = @"Modes"; //self.modeButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.modeButton setAttributedTitle:attributedString forState:UIControlStateNormal];




    //block message
    //self.blockMessage1.font = [UIFont fontWithName:@"OrangeKid-Regular" size:18];
    self.blockMessage1.font = [UIFont fontWithName:kFontNamePlus size:16];

    self.blockMessage1.textAlignment = NSTextAlignmentCenter;
    self.blockMessage1.textColor = [UIColor whiteColor];
    self.blockMessage1.alpha = 1.0;
    self.blockMessage1.hidden = YES;
    self.blockMessage1.userInteractionEnabled = NO;


    //year
    int year = kCopyrightYear; //(int)[components year];


	//good
    self.versionLabel.text = [NSString stringWithFormat:@"@ %d, Skyriser Media",
                              year
                              ];

    //self.versionLabel.font = [UIFont fontWithName:kFontName size:10*kFontScale];
    self.versionLabel.font = [UIFont fontWithName:@"OrangeKid-Regular" size:20];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    self.versionLabel.textColor = [UIColor whiteColor];
    self.versionLabel.alpha = 0.8f;
    self.versionLabel.hidden = NO;
    self.versionButton.hidden = YES;

    //shadow
    self.versionLabel.clipsToBounds = NO;
    self.versionLabel.layer.shadowColor = shadowColor.CGColor;
    self.versionLabel.layer.shadowOpacity = 0.6f;
    self.versionLabel.layer.shadowRadius = 0.0f;
    self.versionLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.versionLabel.layer.masksToBounds = NO;


    //timer
    self.timerLabel.font = [UIFont fontWithName:@"OrangeKid-Regular" size:20];
    self.timerLabel.textAlignment = NSTextAlignmentLeft;
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.alpha = 0.6f;
    self.timerLabel.hidden = YES;
    //shadow
    self.timerLabel.clipsToBounds = NO;
    self.timerLabel.layer.shadowColor = shadowColor.CGColor;
    self.timerLabel.layer.shadowOpacity = 0.6f;
    self.timerLabel.layer.shadowRadius = 0.0f;
    self.timerLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.timerLabel.layer.masksToBounds = NO;
    self.timerLabel.text = @"0m 0s";


    //chest
    self.chestLabel.font = [UIFont fontWithName:@"OrangeKid-Regular" size:18.0f];
    self.chestLabel.textAlignment = NSTextAlignmentCenter;
    self.chestLabel.textColor = [UIColor whiteColor];
    self.chestLabel.alpha = 0.8f;
    self.chestLabel.hidden = YES;
    //shadow
    self.chestLabel.clipsToBounds = NO;
    self.chestLabel.layer.shadowColor = shadowColor.CGColor;
    self.chestLabel.layer.shadowOpacity = 0.6f;
    self.chestLabel.layer.shadowRadius = 0.0f;
    self.chestLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.chestLabel.layer.masksToBounds = NO;
    self.chestLabel.text = @"Free Gift"; //@"Reward!";

    //mult
    self.multLabel.font = [UIFont fontWithName:@"OrangeKid-Regular" size:18.0f];
    self.multLabel.textAlignment = NSTextAlignmentCenter;
    self.multLabel.textColor = [UIColor whiteColor];
    self.multLabel.alpha = 0.8f;
    self.multLabel.hidden = YES;
    //shadow
    self.multLabel.clipsToBounds = NO;
    self.multLabel.layer.shadowColor = shadowColor.CGColor;
    self.multLabel.layer.shadowOpacity = 0.6f;
    self.chestLabel.layer.shadowRadius = 0.0f;
    self.multLabel.layer.shadowOffset = CGSizeMake(1, 1);
    self.multLabel.layer.masksToBounds = NO;
    self.multLabel.text = @"Free Gift"; //@"Reward!";



    self.resumeButton.clipsToBounds = NO;
    self.resumeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.resumeButton.contentEdgeInsets = UIEdgeInsetsMake(0, inset, 0, 0);
    self.resumeButton.titleLabel.font = buttonFont1; //buttonFont1_2
    [self.resumeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.resumeButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.resumeButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected];
    [self.resumeButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected | UIControlStateHighlighted];

    self.cheatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.cheatButton.contentEdgeInsets = UIEdgeInsetsMake(0, inset, 0, 0);
    self.cheatButton.titleLabel.font = buttonFont1; //buttonFont1_2
    [self.cheatButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.cheatButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.cheatButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected];
    [self.cheatButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected | UIControlStateHighlighted];

    self.storeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.storeButton.contentEdgeInsets = UIEdgeInsetsMake(0, inset, 0, 0);
    [self.storeButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.storeButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.storeButton setTintColor:kYellowTextColor];
    self.storeButton.titleLabel.font = buttonFont3;

    self.optionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.optionsButton.contentEdgeInsets = UIEdgeInsetsMake(0, inset, 0, 0);
    [self.optionsButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.optionsButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.optionsButton setTintColor:kYellowTextColor];
    self.optionsButton.titleLabel.font = buttonFont3;

    self.leaderboardButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leaderboardButton.contentEdgeInsets = UIEdgeInsetsMake(0, inset, 0, 0);
    [self.leaderboardButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.leaderboardButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.leaderboardButton setTintColor:kYellowTextColor];
    self.leaderboardButton.titleLabel.font = buttonFont2;

    self.rateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.rateButton.contentEdgeInsets = UIEdgeInsetsMake(0, inset, 0, 0);
    [self.rateButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.rateButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.rateButton setTintColor:kYellowTextColor];
    self.rateButton.titleLabel.font = buttonFont2;

    self.otherButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.otherButton.contentEdgeInsets = UIEdgeInsetsMake(0, inset, 0, 0);
    [self.otherButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.otherButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.otherButton setTintColor:kYellowTextColor];
    self.otherButton.titleLabel.font = buttonFont2;

    /*
    self.shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.shareButton.contentEdgeInsets = UIEdgeInsetsMake(0, inset, 0, 0);
    [self.shareButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.shareButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.shareButton setTintColor:kYellowTextColor];
    self.shareButton.titleLabel.font = buttonFont2;
     */

    self.contactButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contactButton.contentEdgeInsets = UIEdgeInsetsMake(0, inset, 0, 0);
    [self.contactButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.contactButton setTitleColor:kYellowTextColorSelected forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.contactButton setTintColor:kYellowTextColor];
    self.contactButton.titleLabel.font = buttonFont2;


    //[self.resumeButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.resumeButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.resumeButton.clipsToBounds = NO;
    self.resumeButton.titleLabel.clipsToBounds = NO;
    self.resumeButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.resumeButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.resumeButton.titleLabel.layer.shadowRadius = 0.0f;
    self.resumeButton.titleLabel.layer.shadowOffset = CGSizeMake(2, 2); //CGSizeMake(2, 2); //CGSizeMake(3, 3);
    self.resumeButton.titleLabel.layer.masksToBounds = NO;

    self.cheatButton.clipsToBounds = NO;
    self.cheatButton.titleLabel.clipsToBounds = NO;
    self.cheatButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.cheatButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.cheatButton.titleLabel.layer.shadowRadius = 0.0f;
    self.cheatButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.cheatButton.titleLabel.layer.masksToBounds = NO;

    //[self.optionsButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.optionsButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.optionsButton.clipsToBounds = NO;
    self.optionsButton.titleLabel.clipsToBounds = NO;
    self.optionsButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.optionsButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.optionsButton.titleLabel.layer.shadowRadius = 0.0f;
    self.optionsButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.optionsButton.titleLabel.layer.masksToBounds = NO;

    //[self.storeButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.storeButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.storeButton.clipsToBounds = NO;
    self.storeButton.titleLabel.clipsToBounds = NO;
    self.storeButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.storeButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.storeButton.titleLabel.layer.shadowRadius = 0.0f;
    self.storeButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.storeButton.titleLabel.layer.masksToBounds = NO;


    //[self.leaderboardButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.leaderboardButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.leaderboardButton.clipsToBounds = NO;
    self.leaderboardButton.titleLabel.clipsToBounds = NO;
    self.leaderboardButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.leaderboardButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.leaderboardButton.titleLabel.layer.shadowRadius = 0.0f;
    self.leaderboardButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.leaderboardButton.titleLabel.layer.masksToBounds = NO;

    //disabled
    //if(![kAppDelegate isGameCenter])
    //self.leaderboardButton.hidden = true;
    //self.leaderboardButton2.hidden = true;

    //[self.rateButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.rateButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.rateButton.clipsToBounds = NO;
    self.rateButton.titleLabel.clipsToBounds = NO;
    self.rateButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.rateButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.rateButton.titleLabel.layer.shadowRadius = 0.0f;
    self.rateButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.rateButton.titleLabel.layer.masksToBounds = NO;

    //[self.otherButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.otherButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.otherButton.clipsToBounds = NO;
    self.otherButton.titleLabel.clipsToBounds = NO;
    self.otherButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.otherButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.otherButton.titleLabel.layer.shadowRadius = 0.0f;
    self.otherButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.otherButton.titleLabel.layer.masksToBounds = NO;

    //[self.shareButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.shareButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    /*self.shareButton.clipsToBounds = NO;
    self.shareButton.titleLabel.clipsToBounds = NO;
    self.shareButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.shareButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.shareButton.titleLabel.layer.shadowRadius = 0.0f;
    self.shareButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.shareButton.titleLabel.layer.masksToBounds = NO;*/

    //[self.contactButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.contactButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.contactButton.clipsToBounds = NO;
    self.contactButton.titleLabel.clipsToBounds = NO;
    self.contactButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.contactButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.contactButton.titleLabel.layer.shadowRadius = 0.0f;
    self.contactButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.contactButton.titleLabel.layer.masksToBounds = NO;


    //ad
    /*self.adButton.titleLabel.font = [UIFont fontWithName:kFontName size:20];
    [self.adButton setTintColor:kYellowTextColor];
    [self.adButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    inset = 6.0f;
    [self.adButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    [self.adButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];

    int buttonCornerRadius = 10;
    int buttonBorderWidth = 2;
    UIColor *buttonColor = [UIColor clearColor]; //RGBA(0,0,0, 0.3f); //RGBA(255,255,255, 0.1f);
    UIColor *borderColor = kYellowTextColor;

    self.adButton.clipsToBounds = NO;
    self.adButton.titleLabel.clipsToBounds = NO;
    self.adButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.adButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.adButton.titleLabel.layer.shadowRadius = 0.0f;
    self.adButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.adButton.titleLabel.layer.masksToBounds = NO;
    self.adButton.backgroundColor = buttonColor;
    CALayer * l  = [self.adButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];
    //disabled
    //[self.adButton setTitle:@"power-ups" forState:UIControlStateNormal];
    [self.adButton setTitle:@"No Ads" forState:UIControlStateNormal];

    */


    //outline
    /*int buttonCornerRadius = 10;
    int buttonBorderWidth = 2;
    UIColor *buttonColor = RGBA(0,0,0, 0.3f); //RGBA(255,255,255, 0.1f);
    UIColor *borderColor = kYellowTextColor;

    [self.rateButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    self.rateButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.rateButton.backgroundColor = buttonColor;
    CALayer * l = [self.rateButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];*/


    //count
    self.parseCountLabel.textColor = [UIColor whiteColor];
    self.parseCountLabel.font = [UIFont fontWithName:kFontName size:18.0f];
    self.parseCountLabel.hidden = YES;
    self.parseCountLabel.alpha = 0.6f;

    self.parseCountLabel.shadowColor = shadowColor;
    self.parseCountLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    //subtitle
    self.labelSubtitle.textColor = [UIColor whiteColor];
    //self.labelSubtitle.font = [UIFont fontWithName:kFontNamePlus size:14.0f];
    self.labelSubtitle.font = [UIFont fontWithName:@"OrangeKid-Regular" size:22.0f];
    self.labelSubtitle.hidden = YES; //NO;
    self.labelSubtitle.alpha = 0.8f;
    self.labelSubtitle.shadowColor = shadowColor;
    self.labelSubtitle.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.labelSubtitle.text = @"Retro Clicker";
    //self.labelSubtitle.text = @"Retro Clicker - Early Edition";


    UIColor *shadowColor2 = shadowColor; //09ecd8
    int shadowOffset2 = 2;

    //self.labelSuffix.textColor = [UIColor whiteColor];
    self.labelSuffix.textColor = [UIColor colorWithHex:0xfe2f49]; //fe2f49 //0xef1dc8
    //self.labelSuffix.font = [UIFont fontWithName:kFontNamePlus size:14.0f];
    //self.labelSuffix.font = [UIFont fontWithName:@"OrangeKid-Regular" size:32.0f];
    self.labelSuffix.font = [UIFont fontWithName:@"lazer84" size:32.0f];
    self.labelSuffix.hidden = NO;
    self.labelSuffix.alpha = 0.8f;
    self.labelSuffix.shadowColor = shadowColor2;
    self.labelSuffix.shadowOffset = CGSizeMake(shadowOffset2, shadowOffset2);
    self.labelSuffix.text = @"";
    //multiline
    self.labelSuffix.numberOfLines = 1;
    self.labelSuffix.textAlignment = NSTextAlignmentLeft;
    //[self.labelSuffix setTransform:CGAffineTransformMakeRotation(RADIANS(-10))];
    self.labelSuffix.backgroundColor = [UIColor clearColor];

    self.labelSuffixMulti.textColor = self.labelSuffix.textColor;
    self.labelSuffixMulti.font = self.labelSuffix.font;
    self.labelSuffixMulti.hidden = NO;
    self.labelSuffixMulti.alpha = self.labelSuffix.alpha;
    self.labelSuffixMulti.shadowColor = self.labelSuffix.shadowColor;
    self.labelSuffixMulti.shadowOffset = self.labelSuffix.shadowOffset;
    self.labelSuffixMulti.text = @"";
    //multiline
    self.labelSuffixMulti.numberOfLines = 0;
    self.labelSuffixMulti.textAlignment = NSTextAlignmentCenter;
    //[self.labelSuffixMulti setTransform:CGAffineTransformMakeRotation(RADIANS(-10))];
    self.labelSuffixMulti.backgroundColor = self.labelSuffix.backgroundColor;



    shadowOffset = 2;

    //skinName
    self.skinName.textColor = [UIColor whiteColor];
    self.skinName.font = [UIFont fontWithName:kFontName size:21.0f];
    self.skinName.hidden = YES;
    self.skinName.alpha = 1.0f;
    self.skinName.shadowColor = shadowColor;
    self.skinName.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    shadowOffset = 1;

    //common
    self.skinType.textColor = [UIColor whiteColor];
    self.skinType.font = [UIFont fontWithName:kFontName size:18.0f];
    self.skinType.hidden = YES;
    self.skinType.alpha = 0.8f;
    self.skinType.shadowColor = RGBA(0.0f,0.0f,0.0f, 0.8f); //shadowColor;
    self.skinType.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);



    //skin fraction

    shadowOffset = 1;

    self.fraction.textColor = [UIColor whiteColor];
    //self.fraction.font = [UIFont fontWithName:kFontName size:21.0f];
    self.fraction.font = [UIFont fontWithName:kFontName size:18.0f];
    self.fraction.hidden = YES;
    self.fraction.alpha = 0.8f;
    self.fraction.shadowColor = shadowColor;
    self.fraction.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    //life
    self.lifeLabel.textColor = [UIColor whiteColor];
    self.lifeLabel.font = [UIFont fontWithName:kFontName size:26]; //18.0f
    self.lifeLabel.hidden = YES;
    self.lifeLabel.alpha = 0.8f;
    self.lifeLabel.shadowColor = shadowColor;
    self.lifeLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.lifeLabel.hidden = NO;
    //self.lifeLabel.text = @"- Life -";

    //combo
	self.comboLabel.textColor = [UIColor whiteColor];
    self.comboLabel.font = [UIFont fontWithName:kFontName size:18.0f]; //18.0f
    self.comboLabel.alpha = 0.8f;
    self.comboLabel.shadowColor = shadowColor;
    self.comboLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.comboLabel.hidden = NO;

    //spacing
//    NSString *tempTitle = nil;
//    NSMutableAttributedString *attributedString = nil;
//    float spacing = 4.0f;

    tempTitle = self.resumeButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.resumeButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.cheatButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.cheatButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.optionsButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.optionsButton setAttributedTitle:attributedString forState:UIControlStateNormal];

	if(YES)
	{
		//animate cheat button
		NSArray *allImages = @[
           //[UIImage imageNamed:@"menu_icon_cheat"],
           [UIImage imageNamed:@"menu_icon_cheat_color1"], //yellow
           [UIImage imageNamed:@"menu_icon_cheat_color2"], //orange
		];
		self.cheatButton2.imageView.animationImages = allImages;
		self.cheatButton2.imageView.animationRepeatCount = 0;
		self.cheatButton2.imageView.animationDuration = allImages.count * 0.1f;
		[self.cheatButton2.imageView startAnimating];
	}

    /*
    tempTitle = self.storeButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.storeButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    */

    tempTitle = self.leaderboardButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.leaderboardButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    /*tempTitle = self.rateButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.rateButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    */

    tempTitle = self.otherButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.otherButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    /*tempTitle = self.shareButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.shareButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.contactButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.contactButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    */

    //swipe
    //UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    //[gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    //[self.view addGestureRecognizer:gestureRecognizer]; //disabled


    //glow
    //[self.resumeButton setShowsTouchWhenHighlighted:YES];

    self.darkImage.alpha = 1.0f;
    self.curtainLeft.alpha = 1.0f;
    self.curtainRight.alpha = 1.0f;
    self.curtainLeft.hidden = YES;
    self.curtainRight.hidden = YES;

    //rays
    self.shineImageView.alpha = 0.2f;

    //rays
    self.shineImageView.alpha = 0.2f;

    //hide
    self.leaderboardButton.hidden = YES;
    self.otherButton.hidden = YES; //old
    self.otherButton2.hidden = YES; //good
    //self.rateButton.hidden = YES;
    self.contactButton.hidden = YES;
    //self.shareButton.hidden = YES;


    //arrow
    //UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resumeButtonPressed:)];
    //singleTap.numberOfTapsRequired = 1;
    //[self.redArrow setUserInteractionEnabled:YES];
    //[self.redArrow addGestureRecognizer:singleTap];
    self.redArrow.hidden = YES;

    //left right arrows
    //UITapGestureRecognizer *singleTapLeft = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftButtonPressed:)];
    //singleTap.numberOfTapsRequired = 1;
    [self.redArrowLeft setUserInteractionEnabled:NO];
    //[self.redArrowLeft addGestureRecognizer:singleTapLeft];
    self.redArrowLeft.hidden = NO;

    //UITapGestureRecognizer *singleTapRight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightButtonPressed:)];
    //singleTap.numberOfTapsRequired = 1;
    [self.redArrowRight setUserInteractionEnabled:NO];
    //[self.redArrowRight addGestureRecognizer:singleTapRight];
    self.redArrowRight.hidden = NO;

    //carousel
    //configure carousel
    self.carousel.type = iCarouselTypeRotary; //iCarouselTypeRotary;
    self.carousel.delegate = self;
    self.carousel.dataSource = self;
    //self.carousel.wrapEnabled = NO; //loop
    self.carousel.centerItemWhenSelected = YES;
    //self.carousel.bounceDistance = 0.0f; //0.8f;
    self.carousel.bounces = NO;
    //self.carousel.pagingEnabled = NO;

    self.carousel.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    //self.carousel.backgroundColor = [UIColor clearColor];

    //done
    /*[[NSNotificationCenter defaultCenter] postNotificationName:kLoadingDoneNotifications
                                                        object:self
                                                      userInfo:nil];*/

    //reachability
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(actionOnline:)
                                                 name:kReachabilityNotificationOnline
                                               object:nil];


    [kAppDelegate doneNotification:nil];

    [UIView setAnimationsEnabled:YES];


    [self setupBackgroundImages];

    //bigger
    //int buttonResize = 2;
    //[self. setHitTestEdgeInsets:UIEdgeInsetsMake(-buttonResize, -buttonResize, -buttonResize, -buttonResize)];

    //arrow
    self.tutoArrow.hidden = YES;
    self.tutoArrow.userInteractionEnabled = NO;

    //shake
    [self addMotionRecognizerWithAction:@selector(shakeWasRecognized:)];

    //parse
    //[kAppDelegate dbIncLaunch];
}

/*
- (BOOL)prefersStatusBarHidden
{
    return NO;
}
*/

- (void)actionOnline:(NSNotification *)notification {
    Log(@"actionOnline");
}

-(void) setupBackgroundImages {
    //bg random
    //if(!self.allBGImages)
    {
        self.allBGImages = [NSMutableArray array];

        for(int i=0;i<kNumSkins;i++) {
            bool unlocked = [[kAppDelegate.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:i]] boolValue];
            if(unlocked) {
                UIImage* image = [UIImage imageNamed:[CBSkinManager getSkinBackgroundIndex:i]];
                if(image)
                    [self.allBGImages addObject:image];
            }
        }
    }

}

- (void)viewWillAppear:(BOOL)animated {

    //Log(@"***** Title: viewWillAppear");

    [super viewWillAppear:animated];

    if(self.sharing)
    {
        [self notifyForeground];
        return;
    }

    //unlock valentine always
  #if 1
    if(![[kAppDelegate.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:kCoinTypeValentine]] boolValue])
    {
        //only during valentine week, feb 14

        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy";
        NSString *year = [formatter stringFromDate:[NSDate date]];
        formatter.dateFormat = @"M/d/yyyy";
        //Constant Holidays
        NSDate *dateValentine = [formatter dateFromString:[NSString stringWithFormat:@"2/14/%@",year]];

        //range
        NSDate *date1 = [dateValentine dateByAddingDays:-2];
        NSDate *date2 = [dateValentine dateByAddingDays:2];

        //between
        BOOL isValentine = [[NSDate date] isBetweenDate:date1 andDate:date2];

        //after level 2
        if(kAppDelegate.level >= 2 && isValentine)
        {
            [kAppDelegate unlockBlock:kCoinTypeValentine];
        }

    }
#endif

  //unlock st=patrick always
  #if 1
  if(![[kAppDelegate.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:kCoinTypePatrick]] boolValue])
  {
      //only during valentine week, feb 14

      NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
      formatter.dateFormat = @"yyyy";
      NSString *year = [formatter stringFromDate:[NSDate date]];
      formatter.dateFormat = @"M/d/yyyy";
      //Constant Holidays
      NSDate *dateStPatrick = [formatter dateFromString:[NSString stringWithFormat:@"3/17/%@",year]];

      //range
      NSDate *date1 = [dateStPatrick dateByAddingDays:-2];
      NSDate *date2 = [dateStPatrick dateByAddingDays:2];

      //between
      BOOL isPatrick = [[NSDate date] isBetweenDate:date1 andDate:date2];

      //after level 2
      if(kAppDelegate.level >= 2 && isPatrick)
      {
          [kAppDelegate unlockBlock:kCoinTypePatrick];
      }

  }
  #endif


    //unlock soccer always
#if 1
    if(![[kAppDelegate.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:kCoinTypeSoccer]] boolValue])
    {
        //only during valentine week, feb 14
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy";
        NSString *year = [formatter stringFromDate:[NSDate date]];
        formatter.dateFormat = @"M/d/yyyy";
        //Constant Holidays
        
        //June 14 to July 15
        
        //range
        NSDate *date1 = [formatter dateFromString:[NSString stringWithFormat:@"6/7/%@",year]];
        NSDate *date2 = [formatter dateFromString:[NSString stringWithFormat:@"7/22/%@",year]];
        
        //between
        BOOL isDuring = [[NSDate date] isBetweenDate:date1 andDate:date2];
        
        //after level 2
        if(kAppDelegate.level >= 2 && isDuring)
        {
            [kAppDelegate unlockBlock:kCoinTypeSoccer];
        }
        
    }
#endif
    

    [self enableButtons:NO];

    self.showingKTPlay = NO;

    //chest
	[self updateChest];

    //test
    [self updateMult];

    [self updateDownload];

    //hearts, rewind, not saved?
    if(kAppDelegate.numHearts == 0) {
        kAppDelegate.numHearts = kHeartFull;

        kAppDelegate.clickCount = [kAppDelegate.gameScene get1upNumLast];
        [kAppDelegate saveState];
    }

    //update sublevel
    [kAppDelegate.gameScene updateLevelLabel:NO];

    [kAppDelegate loadAchievements];

    [self setupFade];

    [self loadSounds];

	[kAppDelegate cacheRewardVideos];

    //refresh, if unlocked
    [self setupBackgroundImages];

    //disabled
    self.leaderboardButton.hidden = YES; //NO; //![kAppDelegate isGameCenter];
    self.leaderboardButton2.hidden = NO; //always show //![kAppDelegate isGameCenter]; //NO
    self.twitterButton.hidden = YES;
    self.likeButton.hidden = YES;
    self.cheatVersionCount = 0;


#if !(TARGET_IPHONE_SIMULATOR)
    self.socialButton.hidden = YES; //kAppDelegate.inReview;
#else
    self.socialButton.hidden = YES; //NO
#endif

    //disable in review
    self.rateButton.hidden = kAppDelegate.inReview; //NO

    self.verified.hidden = YES;

    //cheat touch anim
    self.touch1.alpha = 0.0f;
    self.touch1Width.constant = self.touch1Height.constant = 40.0f;

    //re-hide
    self.cheatButton2.alpha = 0;
    self.cheatButton2.hidden = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kCurtainAnimDuration+0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self addLogoAnimation];
    });



    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];



    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyForeground)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    [kAppDelegate getIAP];

    //tap to start press
    [self.resumeButton setTitle:@"" forState:UIControlStateNormal];

    self.startText = [kAppDelegate getRandomStart:(int)self.carousel.currentItemIndex];
    //self.redArrowLeft.hidden = NO;
    //self.redArrowRight.hidden = NO;

    //update time
    [kAppDelegate updateForegroundTime];

    [self updateTitleCount];

    [self updateSkinName];
    [self updateArrowImage];

    [self setNumHearts:(int)kAppDelegate.numHearts];

    //setup gamecenter

    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kAppDelegate setupGameCenter];
    });

    //force, gamecenter
    //[kAppDelegate cornerView:self.view];
    //[self.view setNeedsDisplay];

    //done loading
    //kAppDelegate.isLoading = NO;

    self.didAppear = NO;
    self.animateRandom = YES;

    //show status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [self enableButtons:YES];

    //disable, reset
    BOOL remoteEnabled = [kAppDelegate isBlockRemoteEnabledIndex:(int)[kAppDelegate getSkin]];
    BOOL enabled  = [kAppDelegate isBlockEnabledIndex:(int)[kAppDelegate getSkin]];

    if(!remoteEnabled || !enabled) {
        [kAppDelegate setSkin:kCoinTypeDefault];

        [kAppDelegate saveState];
    }

    //volume
    [self setSoundVolume];

    [self updateUI];

    self.resumeButton.alpha = 1.0f;
    self.cheatButton.alpha = 1.0f;
    self.optionsButton.alpha = 1.0f;
    self.storeButton.alpha = 1.0f;
    self.leaderboardButton.alpha = 1.0f;
    self.otherButton.alpha = 1.0f;
    self.rateButton.alpha = 1.0f;
    self.contactButton.alpha = 1.0f;
    self.shareButton.alpha = 1.0f;
    self.socialButton.alpha = 1.0f;
    self.adButton.alpha = 1.0f;
    self.adButton2.alpha = 1.0f;
    self.likeButton.alpha = 1.0f;
    self.twitterButton.alpha = 1.0f;

    self.cheatButton2.alpha = 1.0f;
    self.cheatButton2.hidden = YES;

    self.heartPlus.hidden = [kAppDelegate isPremium];

    //reset logo
    self.logo.image = [UIImage imageNamed:@"logo"];
    self.logo.alpha = 1.0f;
    self.vcr.hidden = YES;
    self.vcr.alpha = 0.0f;
    [self.vcr startAnimating];

    //save for reset
    if(self.oldResumeY == 0)
        self.oldResumeY = self.resumeButton.y;

    if(self.oldBlockY == 0)
        self.oldBlockY = self.block.y;



    self.menuState = menuStateTitle;

    self.spinner.hidden = YES;

    [kAppDelegate playMusic:kMusicNameOptions andRemember:YES];

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    //carousel
    int index = (int)[kAppDelegate getSkin];

    BOOL isRandomVisible = [self isRandomVisible];
    if(kAppDelegate.isRandomSkin && isRandomVisible ) {

        //index = kNumSkins; //random, last
        index = 0;

    }
    else {
        if(isRandomVisible)
            index++;
    }

    [self.carousel scrollToItemAtIndex:index animated:NO];
    [self.carousel reloadData];

    [self startConfetti];
    secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopConfetti];
    });


    [self showWhiteBar];

    [self showCoins];

    //bg
    if([kAppDelegate isRandomSkin]) {
        //[self updateBackground:YES];
        [self updateBackgroundRandom];
    }
    else
        [self updateBackground:NO];



    //timer count
    [self.timerParseCount invalidate];
    self.timerParseCount = nil;

    float interval = 10.0f;
    self.timerParseCount = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                  selector:@selector(updateParseStats:) userInfo:@"updateParseStats" repeats:YES];

    [self updateParseStats:nil];

    [self updateVolumeButton];

    [self setupPremium];
}

-(void)setupPremium
{
    //animate premium
    if(![kAppDelegate isPremium])
    {
        CABasicAnimation *scale;
        scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale.fromValue = [NSNumber numberWithFloat:1.0f];
        //scale.toValue = [NSNumber numberWithFloat:-M_PI*2];
        scale.toValue = [NSNumber numberWithFloat:1.1f];
        scale.duration = 0.5f;
        scale.repeatCount = HUGE_VALF;
        scale.autoreverses = YES;
        [self.premiumButton.layer removeAllAnimations];
        [self.premiumButton.layer addAnimation:scale forKey:@"scale"];

        CABasicAnimation *scale2;
        scale2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale2.fromValue = [NSNumber numberWithFloat:0.6f]; //1.0f
        scale2.toValue = [NSNumber numberWithFloat:0.5f]; //0.8f
        scale2.duration = 0.3f;
        scale2.repeatCount = HUGE_VALF;
        scale2.autoreverses = YES;
        [self.premiumBadge.layer removeAllAnimations];
        [self.premiumBadge.layer addAnimation:scale2 forKey:@"scale"];
        self.premiumBadge.image = [UIImage imageNamed:@"badge2"]; //@"premiumBadge2";

        CABasicAnimation *scale3;
        scale3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale3.fromValue = [NSNumber numberWithFloat:1.0f];
        //scale.toValue = [NSNumber numberWithFloat:-M_PI*2];
        scale3.toValue = [NSNumber numberWithFloat:0.8f];
        scale3.duration = 0.5f;
        scale3.repeatCount = HUGE_VALF;
        scale3.autoreverses = YES;

        CABasicAnimation *alpha1;
        alpha1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alpha1.fromValue = [NSNumber numberWithFloat:0.0f];
        //scale.toValue = [NSNumber numberWithFloat:-M_PI*2];
        alpha1.toValue = [NSNumber numberWithFloat:0.3f];
        alpha1.duration = scale3.duration;
        alpha1.repeatCount = HUGE_VALF;
        alpha1.autoreverses = YES;

        [self.premiumBack.layer removeAllAnimations];
        [self.premiumBack.layer addAnimation:scale3 forKey:@"scale"];
        [self.premiumBack.layer addAnimation:alpha1 forKey:@"opacity"];
    }

}

- (void)viewDidAppear:(BOOL)animated {
    //Log(@"***** Title: viewDidAppear");

    [super viewDidAppear:animated];

    if(self.didAppear)
        return;

    if(self.sharing)
        return;

    self.didAppear = YES;

    //force close alert, if from background after long delay
    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    [self enableButtons:YES];

#if kKTPlayEnabled
#if !(TARGET_IPHONE_SIMULATOR)

    [KTPlay setViewDidAppearBlock:^{
        Log(@"ktplay window appear...");

        self.showingKTPlay = YES;

        //self.activityKTPlay = NO;

        //stop
        [kAppDelegate stopMusic];
    }];

    [KTPlay setViewDidDisappearBlock:^{
        Log(@"ktplay window disappear...");

        self.showingKTPlay = NO;

        [kAppDelegate playMusic:kMusicNameOptions andRemember:YES];

    }];

    [KTPlay setActivityStatusChangedBlock:^(BOOL hasNewActivity) {
        if (hasNewActivity) {
            self.activityKTPlay = YES;

        }else{
            self.activityKTPlay = NO;
        }

        [self updateBadges];
    }];

    [KTPlay setDidDispatchRewardsBlock:^(KTReward *reward) {
        for (KTRewardItem *item in reward.items) {
            Log(@"name->%@ ID->%@ value->%llu", item.name, item.typeId, item.value);
        }
    }];
#endif
#endif

    //cache
    //if(kAppDelegate.adBannerEnabled) {
        //[Chartboost cacheRewardedVideo:kRewardScreen];
    //}

    //give time to layout
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self resetTimer];
    });

    //cheat
    if([kHelpers isDebug])
	{
        float secs = 2.0f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //[self shakeWasRecognized:nil];
        });
    }

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });

    //rotate
    [self addShineAnimation];

    //state
    kAppDelegate.launchInGame = NO;
    [kAppDelegate saveState];

    [self updateUI];

    //help
    //if(kAppDelegate.clickCount == 0 && !kAppDelegate.prefOpened)
		[self actionHelp:nil];


    //sounds
    //if(!kAppDelegate.playedIntroSound)
    {

        kAppDelegate.playedIntroSound = YES;

        secs = 0.5f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            //if([kHelpers randomBool])
            //    [kAppDelegate playSound:@"intro.caf"]; //me
            //else
            //    [kAppDelegate playSound:@"intro2.caf"]; //robot
        });
    }

    //update arrow
    [self showArrow];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

		//BOOL showing = NO;

		//every 10, show alert
		if( (kAppDelegate.launchCount % 10 == 0) && (kAppDelegate.launchCount >= 10) && (kAppDelegate.level >= 3))
		//if(YES)
        {
            int random = [kHelpers randomInt:10];

            //force
            //random = 5;

            //forced random
            if(random <= 3)
            {
                //show VIP alert
                if(![kAppDelegate isPremium] && !self.askedPremium && kAppDelegate.alertView && !kAppDelegate.alertView.visible)
                {
                    [self actionAskPremium];
                }

            }
            else if(random <= 6)
            {
                //show mailing alert
                if(!kAppDelegate.mailingAsked && !self.askedMailing && kAppDelegate.alertView && !kAppDelegate.alertView.visible)
                {
                    [self actionAskMailing];
                }

            }
            else
            {
                //show rate alert
                if(!self.askedRate && kAppDelegate.alertView && !kAppDelegate.alertView.visible)
                {
                    //not in review
                    if(!kAppDelegate.inReview) {
                        self.askedRate = YES;
                        [self rateButtonPressed:nil];
                    }
                }
            }

		}
		#if 1
        else
        {
            //big ad
            if(kAppDelegate.level >= 3)
            {
                if([kHelpers randomBool100:[kAppDelegate getInterstitialOdds:kAppDelegate.interstitialTitleOdds]])
                {
                    //after delay
                    float secs = 0.5f;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        self.didShowInterstitial = YES;
                        [kAppDelegate showInterstitial:kRewardScreen];
                    });
                }
            }
        }
		#endif
    });

	//update launch firebase
	if(!kAppDelegate.prefInstallCountSent)
	{
		[kAppDelegate dbIncInstall];
	}
}


//askalertvip askpremium askvip premiumalert vipalert
-(void)actionAskPremium
{
	//randomly called on appear of title

    if(self.askedPremium)
        return;

    self.askedPremium = YES;

    //alert
    __weak typeof(self) weakSelf = self;

    NSString *message = LOCALIZED(@"kStringPremiumAsk");

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"VIP"
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringPremiumButton")
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {

                                           [kAppDelegate playSound:kClickSound];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * 0.33f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               [self premiumButtonPressed:nil];
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

-(void)actionAskMailing
{
    //randomly called on appear of title

    if(self.askedMailing)
        return;

    self.askedMailing = YES;

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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if(self.sharing)
        return;

    [self enableButtons:NO];

    [self resetTimerStory];

    [self hideArrow];

    [self stopConfetti];
    [self stopCoins];

    [self.timerBounce invalidate];
    self.timerBounce = nil;

    [self.timerSocial invalidate];
    self.timerSocial = nil;

    [self.timerBlockMessage invalidate];
    self.timerBlockMessage = nil;


    [self.timerVCR invalidate];
    self.timerVCR = nil;
    self.vcr.hidden = YES;

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    if(self.sharing)
        return;

    [self.shineImageView.layer removeAllAnimations];

    [self.cloud1.layer removeAllAnimations];
    self.cloud1.alpha = 0.0f;
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    [self.timerBg invalidate];
    self.timerBg = nil;

    [self.timerParseCount invalidate];
    self.timerParseCount = nil;

    [self.labelSuffixMulti pop_removeAllAnimations];
    [self.labelSuffix pop_removeAllAnimations];

    [self.timer invalidate];
    self.timer = nil;

    [self.timerStory invalidate];
    self.timerStory = nil;

    //float interval = 1; //kTimerDelayRandomEvent;
    /*self.timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                selector:@selector(actionTimer:) userInfo:@"actionTimer2" repeats:YES];*/

    //call now
    //[self actionTimer:nil];


    [self.timerCloud invalidate];
    self.timerCloud = nil;

    [self.timerArrow invalidate];
    self.timerArrow = nil;

    [self.timerMult invalidate];
    self.timerMult = nil;

    [self.timerCheat invalidate];
    self.timerCheat = nil;

    [self stopWhiteBar];

    //[self hideArrow];
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

-(void)addShineAnimation
{
    CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    //rotate.toValue = [NSNumber numberWithFloat:-M_PI*2];
    rotate.toValue = [NSNumber numberWithFloat:M_PI*2];
    rotate.duration = 32;
    rotate.repeatCount = HUGE_VALF;
    [self.shineImageView.layer removeAllAnimations];

    [self.shineImageView.layer addAnimation:rotate forKey:@"10"];

    //also chest
    [self.chestShine.layer removeAllAnimations];
    [self.chestShine.layer addAnimation:rotate forKey:@"10"];

    //also chest
    [self.multShine.layer removeAllAnimations];
    [self.multShine.layer addAnimation:rotate forKey:@"10"];
}

-(void)addLogoAnimation
{
    if(self.alreadyAnimatedLogo)
    {
        [self addLogoAnimation2];
        return;
    }

    self.alreadyAnimatedLogo = YES;

    self.logo.alpha = 0.0f;

    [CATransaction begin];

    CGFloat duration = 0.6f;
    CGFloat delay = 0.0f;

    //also fade
    CABasicAnimation* fadein= [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadein.fromValue = [NSNumber numberWithFloat:0.0f];
    fadein.toValue = [NSNumber numberWithFloat:1.0f];
    //delay
    fadein.beginTime = CACurrentMediaTime() + delay;
    //fix ending
    fadein.fillMode = kCAFillModeForwards;
    fadein.removedOnCompletion = NO;
    [fadein setDuration:duration];


    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSNumber numberWithFloat:5.0f]; //12.0f
    scale.toValue = [NSNumber numberWithFloat:1.0f];
    scale.beginTime = CACurrentMediaTime() + delay;
    //scale.removedOnCompletion = NO;
    scale.duration = duration;

    [CATransaction setCompletionBlock:^{

        [self addLogoAnimation2];

        if(kVoiceEnabled)
            [kAppDelegate playSound:@"voice_coinblock.caf"];

        //flash
        [self showFlash:[UIColor whiteColor]];
    }];

    [self.logo.layer removeAllAnimations];
    [self.logo.layer addAnimation:scale forKey:@"scale"];
    [self.logo.layer addAnimation:fadein forKey:@"opacity"];


    [CATransaction commit];

	//sound swoosh
    [kAppDelegate playSound:@"swoosh.caf"];
}

-(void)addLogoAnimation2
{
    self.logo.alpha = 1.0f;

    //logo scale
    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];

    scale.fromValue = [NSNumber numberWithFloat:1.0f];
    scale.toValue = [NSNumber numberWithFloat:1.05f];

    scale.duration = 0.3f;
    scale.repeatCount = HUGE_VALF;
    scale.autoreverses = YES;
    scale.removedOnCompletion = NO;

    [self.logo.layer removeAllAnimations];
    [self.logo.layer addAnimation:scale forKey:@"scale"];
}

- (IBAction)actionHelp:(id)sender {
#if 0
    if(kAppDelegate.playedWelcomeAlert)
			return;

    //alert
    __weak typeof(self) weakSelf = self;


    NSString *message = nil;

    //gamecenter name
    NSString *another = @"";
    if([kAppDelegate getPlayerName]) {
        another = [NSString stringWithFormat:@", %@", [kAppDelegate getPlayerName]];
    }
    message = nil;

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Welcome"
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:@"Let's go!" //@"OK"//[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           //
                                           [kAppDelegate playSound:kClickSound];

                                       }];

    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

        [weakSelf showVCR:NO animated:YES];

        kAppDelegate.playedWelcomeAlert = YES;
        [kAppDelegate saveState];
    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];
    [self showVCR:YES animated:YES];
#endif
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


#if 0
    //test hole
    int radius = self.darkImage.frame.size.width/2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.darkImage.bounds.size.width, self.darkImage.bounds.size.width) cornerRadius:0];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius) cornerRadius:radius];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];

    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor grayColor].CGColor;
    fillLayer.opacity = 1.0f;
    [self.darkImage.layer addSublayer:fillLayer];

    [UIView animateWithDuration:kFadeDuration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.fillLayer.alpha = 1.0;
    }
     completion:^(BOOL finished){
     }];
#endif

    //jerky
    /*
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFadeDuration * 0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.darkImage.alpha = 0.33f;
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFadeDuration * 0.33f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.darkImage.alpha = 0.66f;
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFadeDuration * 0.66f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.darkImage.alpha = 1.0f;
    });
    */


    //smooth
    [UIView animateWithDuration:kFadeDuration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
     self.darkImage.alpha = 1.0;
     }
     completion:^(BOOL finished){
     }];


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

    self.darkImage.alpha = 1.0f;

    //jerky
    /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFadeDuration * 0.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.darkImage.alpha = 0.66;
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFadeDuration * 0.33f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.darkImage.alpha = 0.33f;
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFadeDuration * 0.66f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.darkImage.alpha = 0.0f;
    });*/

    //reset
    [self.darkImage.layer removeAllAnimations];

    //smooth
    [UIView animateWithDuration:kFadeDuration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        self.darkImage.alpha = 0;

				//reset fade white
				kAppDelegate.fadingWhite = NO;

    }
    completion:^(BOOL finished){
     }];


    //curtains
    [self openCurtains];
}

-(void)openCurtains {

    //disabled
    //return;

    self.curtainLeft.userInteractionEnabled = YES;
    self.curtainRight.userInteractionEnabled = YES;

    //top
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
        self.curtainRight.x = screenRect.size.width; //???
    }
     completion:^(BOOL finished){
         self.curtainLeft.hidden = YES;
         self.curtainRight.hidden = YES;
     }];

    //update arrow
    //[self showArrow];
}

-(void)bringSubviewsToFront
{
    //top
    [self.view bringSubviewToFront:self.flashImage];
    [self.view bringSubviewToFront:self.curtainLeft];
    [self.view bringSubviewToFront:self.curtainRight];
    [self.view bringSubviewToFront:self.coinsImage];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.vcr];
    [self.view bringSubviewToFront:self.scanline];
}

-(void)closeCurtains {
    //disabled
    //return;

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


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - Actions


-(void)enableButtons:(BOOL)enable {

    //also reset
    [self resetTimerStory];

    self.logoButton.enabled = enable;
    self.resumeButton.enabled = enable;
    self.cheatButton.enabled = enable;
    self.cheatButton2.enabled = enable;
    self.storeButton.enabled = enable;
    self.rateButton.enabled = enable;
    self.otherButton.enabled = enable;
    self.otherButton2.enabled = enable;
    self.shareButton.enabled = enable;
    self.socialButton.enabled = enable;
    self.adButton.enabled = enable;
    self.adButton2.enabled = enable;
    self.likeButton.enabled = enable;
    self.twitterButton.enabled = enable;
    self.optionsButton.enabled = enable;
    self.optionsButton2.enabled = enable;
    self.volumeButton.enabled = enable;
    self.leaderboardButton.enabled = enable;
    self.contactButton.enabled = enable;
    self.carousel.userInteractionEnabled = enable;
    self.hashtag.userInteractionEnabled = enable;
    self.titleBarButton.userInteractionEnabled = enable;
    self.versionButton.enabled = enable;
	self.modeButton.enabled = enable;
    self.premiumButton.enabled = enable;
    self.infoButton.enabled = enable;
    self.chestButton.enabled = enable;
    self.multButton.enabled = enable;
    self.modeButton.enabled = enable;
    self.downloadButton.enabled = enable;

    self.premiumBadge.alpha = enable?1.0f:0.5f;
    self.premiumLock.alpha = enable?0.8f:0.5f;
}

-(void)updateSuffix
{

    self.labelSuffixMulti.text = @"";
    self.labelSuffix.text = @"";


    if(kAppDelegate.level <= 1)
    {
        //no suffix
        return;
    }

    NSMutableArray *array = [@[
                             @"1.0",

                             @"DX",
                             @"EX",
                             @"SP",
                             @"GX",
                             //@"DS",
                             @"64",
                             @"63 1/3",
                             //@"3D",
                             @"2D",
                             @"2084", //robotron

                             @"++",

                             @"'84",
                             //@"'97",

                             @"HD",
                             //@"X",
                             //@"Plus",
                             //@"NEO",
                             //@"REMIX",
                             //@"ULTRA",
                             //@"TURBO",


                             @"Dash",
                             @"Inc.",
                             //@"Free",
                             @"Saga",
                             //@"Z",
                             @"Go !",
                             //@"1.0",
                             @".io",
                             //@"The Game",
                             @"Pro",
                             //@"Advance",
                             //@"VII",
                             //@"Remake",
                             //@"World Tour",

                             //@"Royale",
                             //@"of\nWar",
                             //@"of\nClans",
                             //@"with\nFriends",

                             @"The\nGame",
                             @"Awesome\nGame",
                             @"Game of\nGames",

                             //@"Galaxy",

                             @"95",
                             @"2000",
                             @"XP",

                             //@"shareware",
                             //@"Great\nJob!",

                             ] mutableCopy];

    //more
    if(!kAppDelegate.inReview) {
        [array addObjectsFromArray:@[
                                     //@"Bros.",
                                     @"Melee",
                                     //@"RPG",

                                     @"NT",
                                     //@"ME",

                                     @"World",

                                     @"Royale",
                                     @"of\nWar",
                                     @"of\nClans",
                                     @"with\nFriends",

                                     ]];
    }


    //suffix
    NSString *suffix =  [array randomObject];



    //force test
    //suffix = @"Great\nJob!";
    //suffix = @"of\nWar!";
    //suffix = @"of\nClans!";
    //suffix = @"with\nFriends!";
    //suffix = @"The\nGame!";
    //suffix = @"Awesome\nGame!";
    //suffix = @"Game of\nGames";

    //force
    //suffix = @"Retro\nClicker";

    //disabled
    suffix = @"";

    BOOL isMulti = [suffix contains:@"\n"];

    if(isMulti)
    {
        self.labelSuffixMulti.text = suffix;
    }
    else
    {
        self.labelSuffix.text = suffix;
    }


    float fontSize = 20.0f;

    //test
//    self.labelSuffix.backgroundColor = isMulti ? [UIColor clearColor] : [UIColor blueColor];
//    self.labelSuffixMulti.backgroundColor = isMulti ? [UIColor blueColor] : [UIColor clearColor];

    //new line, bigger
    if(isMulti)
    {
        NSArray *strings = [suffix componentsSeparatedByString:@"\n"];
        NSString *line1 = [strings firstObject];
        NSString *line2 = [strings lastObject];
        NSInteger length = MAX(line1.length, line2.length);

        if(length <= 1) {
            fontSize = 34.0f;
        }
        else if(length <= 3) {
            fontSize = 32.0f;
        }
        else if(length <= 4) {
            fontSize = 28.0f;
        }
        else if(length <= 6) {
            fontSize = 26.0f;
        }

        //smaller
        fontSize *= 0.6f;

        //fontSize = 24.0f;
        //self.labelSuffixMulti.textAlignment = NSTextAlignmentCenter;

        //self.labelSuffixMulti.font = [UIFont fontWithName:@"OrangeKid-Regular" size:fontSize];
        self.labelSuffixMulti.font = [UIFont fontWithName:@"lazer84" size:fontSize];

        //attributed with spacing
        NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
        style.minimumLineHeight = fontSize;
        style.maximumLineHeight = fontSize;

        [style setAlignment:NSTextAlignmentCenter];

        NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};


        self.labelSuffixMulti.text = @"";
        self.labelSuffixMulti.attributedText = [[NSAttributedString alloc] initWithString:suffix
                                                                          attributes:attributtes];
    }
    else
    {
        if(suffix.length <= 1) {
            fontSize = 34.0f;
        }
        else if(suffix.length <= 3) {
            fontSize = 32.0f;
        }
        else if(suffix.length <= 4) {
            fontSize = 28.0f;
        }
        else if(suffix.length <= 6) {
            fontSize = 26.0f;
        }

        //smaller
        fontSize *= 0.6f;

        //reg, left
        //self.labelSuffix.textAlignment = NSTextAlignmentLeft;

        //self.labelSuffix.font = [UIFont fontWithName:@"OrangeKid-Regular" size:fontSize];
        self.labelSuffix.font = [UIFont fontWithName:@"lazer84" size:fontSize];

    }

    //animate

    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSNumber numberWithFloat:1.0f];
    scale.toValue = [NSNumber numberWithFloat:1.05f];
    scale.duration = 0.5f;
    scale.repeatCount = HUGE_VALF;
    scale.autoreverses = YES;

    [self.labelSuffix.layer removeAllAnimations];
    [self.labelSuffixMulti.layer removeAllAnimations];

    if(isMulti)
        [self.labelSuffixMulti.layer addAnimation:scale forKey:@"scale"];
    else
        [self.labelSuffix.layer addAnimation:scale forKey:@"scale"];
}

- (void)updateResumeFont {

    NSString *tempTitle =  self.startText;
    if(!tempTitle)
        return;

    NSString *fontName = kFontName;

    UIFont *buttonFont1 = [UIFont fontWithName:fontName size:([kHelpers isIphone4Size] ? 16 : 22)*kFontScale];

    self.resumeButton.titleLabel.font = buttonFont1;

    self.resumeButton.titleLabel.numberOfLines = 1;
    self.resumeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.resumeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.resumeButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
}

- (void)updateUI {

    [self updateSuffix];

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
        self.lifeLabel.text = [NSString stringWithFormat:@"World Minus %d-%d", levelTemp, subLevel];
    else
        self.lifeLabel.text = [NSString stringWithFormat:@"World %d-%d", levelTemp, subLevel];

	//combo
    self.comboLabel.hidden = NO; //(kAppDelegate.maxCombo < kComboMinCount);
    self.comboLabel.text = [NSString stringWithFormat:@"Best Combo:\n%d", (int)kAppDelegate.maxCombo];

    self.block.image = [CBSkinManager getBlockImage];

    //fraction
    int numUnlocked = 0;
    for(int i=0;i<kNumSkins;i++) {
        bool unlocked = [[kAppDelegate.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:i]] boolValue];
        if(unlocked)
            numUnlocked++;
    }
    self.fraction.text = [NSString stringWithFormat:@"%d/%d", numUnlocked, kNumSkins];
    //self.fraction.text = [NSString stringWithFormat:@"Collection: %d/%d", numUnlocked, kNumSkins];
    self.fraction.hidden = NO;
    self.fraction.alpha = 0.7f;

    self.cheatButton.titleLabel.font = [UIFont fontWithName:kFontName size:([kHelpers isIphone4Size] ? 16 : 18)*kFontScale];

    //resume

    //UIFont *buttonFont1 = nil;
    /*if((int)kAppDelegate.clickCount > 0) {
        //tempTitle = LOCALIZED(@"kStringContinue");
        buttonFont1 = [UIFont fontWithName:kFontName size:([kHelpers isIphone4Size] ? 24 : 26)*kFontScale];

    }
    else {
        tempTitle = @"Start";
        buttonFont1 = [UIFont fontWithName:kFontName size:([kHelpers isIphone4Size] ? 28 : 30)*kFontScale];
    }*/

    //force
    //tempTitle = @"Play";.
    //tempTitle = @"Start";
    //tempTitle = @"Tap to Start";
    //tempTitle = @"Tap to Play!";
    /*tempTitle =  self.startText;
    buttonFont1 = [UIFont fontWithName:kFontName size:([kHelpers isIphone4Size] ? 24 : 26)*kFontScale];
    //too long?
    if(tempTitle.length >= 15 )
        buttonFont1 = [UIFont fontWithName:kFontName size:20*kFontScale];
    self.resumeButton.titleLabel.font = buttonFont1;*/

    [self updateResumeFont];

    [self.resumeButton setTitle:@"" forState:UIControlStateNormal];

//    NSString *tempTitle = nil;
//    float spacing = 2.0f;
//    NSMutableAttributedString *attributedString = nil;
//    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
//    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
//    [self.resumeButton setAttributedTitle:attributedString forState:UIControlStateNormal];


    //disabled
    self.cheatButton.hidden = YES;
    //self.volumeButton.hidden = YES;

    //force
    [self actionTimerArrow:nil];
    //[self actionTimerMult:nil];

    //hashtag
    [self.hashtag setTitle:@"#coinblock" forState:UIControlStateNormal];
    [self.hashtag.titleLabel setFont:[UIFont fontWithName:@"OrangeKid-Regular" size:24] ];
    [self.hashtag setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.hashtag.alpha = 0.3f;
    self.hashtag.hidden = YES; //NO;

    [self updateBadges];

    //move
    //self.shareButton.x = 100;
    //self.shareButton.y = self.view.height - 20;

    self.adButton.hidden = YES; //YES
    self.adButton2.hidden = YES; //NO

    self.storeButton.hidden = YES; //NO

    if(![kAppDelegate isPremium])
    {
        //regular
        self.premiumButton.hidden = NO;
        self.premiumButton.alpha = 1.0f;
        self.premiumButton.userInteractionEnabled = YES;


        self.premiumBadge.hidden = ![kAppDelegate isPremiumIAPOnSale];
        self.premiumBack.hidden = ![kAppDelegate isPremiumIAPOnSale];

        self.premiumLock.alpha = 0.8f;
        self.premiumLock.hidden = NO;
        self.premiumLock.userInteractionEnabled = NO;
    }
    else
    {
        //vip
        self.premiumButton.hidden = YES; //NO;
        self.premiumButton.alpha = 0.5f;
        self.premiumButton.userInteractionEnabled = YES;

        self.premiumBadge.hidden = YES;
        self.premiumBack.hidden = YES;
        self.premiumLock.hidden = YES;
    }

    //hide badge if touched, but dont save
    if(kAppDelegate.touchedPremium)
        self.premiumBadge.hidden = YES;

    //force
    if([kHelpers isDebug])
    {
//        self.premiumBadge.hidden = NO;
//        self.premiumLock.hidden = NO;
    }

    int buttonResize = 10;
    [self.storeButton setHitTestEdgeInsets:UIEdgeInsetsMake(-buttonResize, -buttonResize, -buttonResize, -buttonResize)];
    [self.optionsButton2 setHitTestEdgeInsets:UIEdgeInsetsMake(-buttonResize, -buttonResize, -buttonResize, -buttonResize)];

    [self.downloadButton setHitTestEdgeInsets:UIEdgeInsetsMake(-buttonResize, -buttonResize, -buttonResize, -buttonResize)];

    [self.carousel reloadData];

	//modes
    //hide level if level 2-
    //self.modeButton.hidden = kAppDelegate.level <= 1;
    self.modeButton.hidden = YES;
}

-(void) updateBadges
{
    int offset = -5;

    int num = [kAppDelegate getNumNewSkins];
    if(num > 0) {
        //[self.otherButton setBadgeValue:nil];
        //[self.otherButton setBadgeValue:@"6"];

        //store
        [self.storeButton setBadgeValue:[NSString stringWithFormat:@"%d", num] withOffsetY:offset];
    }
    else {
        [self.storeButton setBadgeValue:nil withOffsetY:offset];
    }

	//carousel badge
    self.carouselBadge.hidden = YES; //(num <= 0) ;
    self.carouselBadgeButton.hidden = (num <= 0);
    [self.carouselBadgeButton setBadgeValue:[NSString stringWithFormat:@"%d", num] withOffsetY:0];

    //other apps, badge

    [self.otherButton setBadgeValue:nil];

    //arrows?


    //ktplay
    if(self.activityKTPlay)
    //if(YES)
    {
        [self.socialButton setBadgeValue:@" "];
    }
    else
    {
        [self.socialButton setBadgeValue:nil];
    }

}


-(void)viewDidLayoutSubviews {

    /*if([kHelpers isIphone4Size])
    {
        Log(@"iPhoneX");
    }*/

    //topLayoutGuide

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    //update?
    //[self updateUI];

    //save for reset
    if(self.oldResumeY == 0)
        self.oldResumeY = self.resumeButton.y;

    if(self.oldBlockY == 0)
        self.oldBlockY = self.block.y;

    //arows
    self.redArrowLeft.y = self.carousel.y + self.carousel.height/2 - self.redArrowLeft.height/2;
    self.redArrowRight.y = self.carousel.y + self.carousel.height/2 - self.redArrowRight.height/2;


    /*if(!self.didAppear)
    {
        [self showArrow];
    }*/

    if([kHelpers isIphone4Size])
    {
        //smaller, ipad, iphone4
        self.carouselTopConstraint.constant = 160;
        self.logoConstraint.constant = 10;
        self.resumeButtonConstraint.constant = 332;
        self.heartTopConstraint.constant = 40;

        //self.versionBottom.constant = 0;

    }
    else if([kHelpers isIphoneX])
    {
        //same
        self.carouselTopConstraint.constant = 210;
        self.logoConstraint.constant = 40;
        self.resumeButtonConstraint.constant = 382;
        self.heartTopConstraint.constant = 60;

        self.versionBottom.constant = 0;
    }

    else
    {
        self.carouselTopConstraint.constant = 210;
        self.logoConstraint.constant = 40;
        self.resumeButtonConstraint.constant = 382;
        self.heartTopConstraint.constant = 60;

        //self.versionBottom.constant = 0;

    }
}

- (void) actionInfo:(id)sender {

	//just hide
	//self.infoButton.hidden = YES;

    __weak typeof(self) weakSelf = self;

    int index = (int)self.carousel.currentItemIndex;
    BOOL isRandomVisible = [self isRandomVisible];
    if(isRandomVisible)
        index--;

    NSString *skinName = [CBSkinManager getBlockDisplayNameIndex:index];
    NSString *skinDesc = [CBSkinManager getBlockDescIndex:index];
    NSString *skinURL = [CBSkinManager getBlockWebsite:index];

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

- (IBAction)leftButtonPressed:(id)sender
{
    Log(@"leftButtonPressed");
}

- (IBAction)rightButtonPressed:(id)sender
{
    Log(@"rightButtonPressed");
}


-(void)refillHeartAlert {

   __weak typeof(self) weakSelf = self;

    if(![kHelpers checkOnline]) {

        //if(kAppDelegate.playedLowHeartAlert)
        //    return;

        NSString *message = @"Heart refills are not available offline.";

        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            [kAppDelegate.alertView dismissAnimated:NO];

        kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Offline"
                                                 andMessage:message];

        [kAppDelegate.alertView addButtonWithTitle:[CBSkinManager getRandomOKButton]
                                      type:kAlertButtonGreen
                                   handler:^(SIAlertView *alert) {
                                       //
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

        return;
    }

    if(kAppDelegate.numHearts >= kHeartFull)
        return;

    NSString *message = @"Out of hearts! Refill your hearts instantly for free by watching a short video?";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringContinue") //@"Refill"
                                             andMessage:message];

    //float heartHealTime = [CBSkinManager getHeartHealTime];
    //int minutes = ceilf(heartHealTime/60.0f);
    //int seconds = 0;

    /*
    [kAppDelegate.alertView addButtonWithTitle: [NSString stringWithFormat:@"Wait for refill (%dm)", minutes]
                                  type:kAlertButtonOrange
                               handler:^(SIAlertView *alert) {

                                   [kAppDelegate playSound:kClickSound];

                               }];*/


    [kAppDelegate.alertView addButtonWithTitle:
                            LOCALIZED(@"kStringWatchAd") //[CBSkinManager getRandomOKButton]
                                  type:kAlertButtonGreen
                               handler:^(SIAlertView *alert) {
                                   //
                                   [kAppDelegate playSound:kClickSound];
                                   //nothing


                                   //[kHelpers showMessageHud:@""];

                                   [self resetTimerStory];

                                   float secs = 1.0f;
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                       //video
                                       if([kAppDelegate hasRewardedVideo:kRewardRefill]) {
                                           //force ad back
                                           //kAppDelegate.gameController.darkAdImage.hidden = NO;

                                           [kAppDelegate showRewardedVideo:kRewardRefill];
                                       }
                                       else {
                                           [kHelpers dismissHud];

                                           [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorNoVideo")];
                                       }

                                   });

                                   //after delay, in case
                                   secs = 5.0f;
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                       [kHelpers dismissHud];

                                   });
                               }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

        //if([kHelpers isDebug])
        // [self showHeart];


        [weakSelf showVCR:NO animated:YES];

    }];




    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];

    [self showVCR:YES animated:YES];

}


-(void)unlockedSkinReward {

    Log(@"unlockedSkinReward");

    int newSelected = kAppDelegate.skinVideoUnlock;
    if(newSelected == kCoinTypeDefault)
        return;
    //kAppDelegate.skinVideoUnlock = kCoinTypeDefault;

    int numBefore = [self numItemsInCarousel];

    [kAppDelegate unlockBlock:newSelected];

    int numAfter = [self numItemsInCarousel];

    [self updateBadges];

    [self setupBackgroundImages];
    [self updateSkinName];
    [self updateArrowImage];

    [kAppDelegate playSound:kUnlockSound];
    [kAppDelegate playSound:kUnlockSound2];

    [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];

    [self startConfetti];
    float secs = kConfettiThanksDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopConfetti];
    });

    [self.carousel reloadData];

    //fix 1st unlock offset
    if(numAfter != numBefore)
    {
        int index = (int)self.carousel.currentItemIndex;
        index++;
        [self.carousel scrollToItemAtIndex:index animated:NO];
    }

    //force reselect
    [self carouselCurrentItemIndexDidChange:self.carousel];

    [self updateBackground:NO];


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.sharing = NO;
    });

}

-(void)refillHeartAlert2 {

    kAppDelegate.numHearts = kHeartFull;

    //heart refill sound, if needed
    [kAppDelegate playSound:@"refill.caf"];


    //[kAppDelegate playSound:@"soundStarAppear"];
    [kAppDelegate playSound:@"soundStarClick2"];


    [kAppDelegate saveState];
}


- (IBAction)resumeButtonPressed:(id)sender
{
    [self resetTimerStory];

    __weak typeof(self) weakSelf = self;

    //check life
    if(kAppDelegate.numHearts <= 0) {
        [kAppDelegate playSound:kClickSound];

        [kAppDelegate playSound:@"hurt.caf"];

        //[kAppDelegate playSound:[kAppDelegate getFireClickSoundName:0]];

        [self refillHeartAlert];
        return;
    }

    //[self forceTitleTimeFast];

    //arrow
    kAppDelegate.tutoArrowClickedTitle = YES;
    [self hideArrow];
    [kAppDelegate saveState];
    //self.tutoArrow.hidden = YES;

    self.skipFade = NO;

    int newSelected = (int) self.carousel.currentItemIndex;

    BOOL isRandomVisible = [self isRandomVisible];
    if(isRandomVisible)
        newSelected--;

    //BOOL random = (newSelected == kNumSkins);
    BOOL random = (newSelected == -1);

    bool unlocked = [[kAppDelegate.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:kCoinTypeBrain]] boolValue];

    if(kAppDelegate.level == kLevelMax && newSelected != kCoinTypeBrain && unlocked)
    {
        Log(@"last level");

        //force brain
        newSelected = kCoinTypeBrain;
        [self.carousel scrollToItemAtIndex:(kCoinTypeBrain+1) animated:YES]; //+1 for random

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self resumeButtonPressed:sender];
        });

        return;
    }


    if(isRandomVisible && random) {
        //random
        //[kAppDelegate playSound:kClickSound];

        NSMutableArray *randomArray = [NSMutableArray array];
        for(int i=0;i<kNumSkins;i++) {
            if(i == kCoinTypeMario2 || i == kCoinTypeComingSoon)
                continue;

            BOOL enabled  = [kAppDelegate isBlockEnabledIndex:i] && [kAppDelegate isBlockRemoteEnabledIndex:i];
            if(enabled)
                [randomArray addObject:[NSNumber numberWithInt:i]];
        }

        //self.isRandoming = YES;
        kAppDelegate.isRandomSkin = YES;
        [kAppDelegate playSound:@"spin1.caf"];

        int randomIndex = [[randomArray randomObject] intValue];

        //make sure it's different
        for(int i = 0; i<10; i++) {
            if(randomIndex == [kAppDelegate getSkin])
                randomIndex = [[randomArray randomObject] intValue];
            else
                break;
        }


        //[self.carousel scrollToItemAtIndex:randomIndex animated:YES];

        //set skin
        [kAppDelegate setSkin:randomIndex];

        //today
        //[kAppDelegate saveBlockImage];

        [kAppDelegate animateControl:self.resumeButton];
        [kAppDelegate animateControl:self.carousel];
        [kAppDelegate animateControl:self.logoButton];

        //return;
    }

    //kAppDelegate.isRandomSkin = NO;


    [self enableButtons:NO];


    //not random
    if(!random) {

        BOOL enabled  = [kAppDelegate isBlockEnabledIndex:newSelected];
        BOOL remoteEnabled = [kAppDelegate isBlockRemoteEnabledIndex:newSelected];

        if(!remoteEnabled) {
            //[kAppDelegate playSound:kClickSound];
            [kAppDelegate playSound:@"smb3_bump.caf"];

            [kAppDelegate animateControl:self.resumeButton];
            [kAppDelegate animateControl:self.carousel];
            [kAppDelegate animateControl:self.logoButton];

            //alert

            kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Block unavailable"
                                                             andMessage:[NSString stringWithFormat:@"This Block is temporarily unavailable."]];


            [kAppDelegate.alertView addButtonWithTitle:[CBSkinManager getRandomOKButton]
                                     type:kAlertButtonGreen
                                  handler:^(SIAlertView *alert) {
                                      [weakSelf enableButtons:YES];

                                      [kAppDelegate playSound:kClickSound];
                                  }];

            [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
                [weakSelf enableButtons:YES];

                [weakSelf showVCR:NO animated:YES];
            }];


            [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
                //nothing
            }];


            kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
            kAppDelegate.alertView.transitionStyle = kAlertStyle;

            [kAppDelegate.alertView show:YES];

            //shake
            //[self.view shake];

            //[self enableButtons:YES];

            [self showVCR:YES animated:YES];

            //done
            return;
        }

        if(!enabled) {

            BOOL premiumSkin =(newSelected == kCoinTypeMario);
            BOOL lastSkin = (newSelected == kCoinTypeBrain);
            BOOL shareSkin = (newSelected == kCoinTypeFlap);
            BOOL followSkin = (newSelected == kCoinTypeEmoji);
            BOOL rateSkin = (newSelected == kCoinTypePew);
            if(kAppDelegate.inReview)
                rateSkin = NO;

            BOOL secretSkin = (newSelected == kCoinTypeMario2 || newSelected == kCoinTypeValentine || newSelected == kCoinTypePatrick || newSelected == kCoinTypeSoccer);
            BOOL videoSkin = (newSelected == kCoinTypeZelda);
            BOOL comingSoon = (newSelected == kCoinTypeComingSoon);

            //[kAppDelegate playSound:kClickSound];
            [kAppDelegate playSound:@"smb3_bump.caf"];

            [kAppDelegate animateControl:self.resumeButton];
            [kAppDelegate animateControl:self.carousel];
            [kAppDelegate animateControl:self.logoButton];

            //alert
			if(lastSkin)
                kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Block locked"
                                                             andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringNotEnoughEnding"), kLevelMax]];
            else if(secretSkin)
                kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Block locked"
                                                                 andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringNotEnoughSecret")]];
            else if(comingSoon)
                kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Coming Soon"
                                                                 //andMessage:[NSString stringWithFormat:@"More Blocks coming soon!"]];
                                                                andMessage:[NSString stringWithFormat:@"More Blocks will be arriving soon. \n\n We're LITERALLY working on it right now!"]];
			else if(shareSkin)
                kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Block locked"
                                                             andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringNotEnoughShare")]];
			else if(followSkin)
                kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Block locked"
                                                             andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringNotEnoughFollow")]];
            else if(premiumSkin)
			     kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Block locked"
                                                             andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringPremiumSkin")]];
            else if(rateSkin)
			     kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Block locked"
                                                             andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringNotEnoughRate")]];
            else if(videoSkin)
			     kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Block locked"
                                                             andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringNotEnoughVideo")]];
		   else
                kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Block locked"
                                                             andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringNotEnough")]];

#if 1
            if(![kAppDelegate isPremium] && premiumSkin) {
                [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringPremiumButton") //@"VIP"
                                                        //same color now
                                                      //type: (!premiumSkin ? kAlertButtonOrange : kAlertButtonOrange)
                                                      type:kAlertButtonGreen
                                                   handler:^(SIAlertView *alert) {
                                                       [kAppDelegate playSound:kClickSound];

                                                       float secs = 0.8f;
                                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                           [self adButtonPressed:nil];
                                                       });
                                                   }];
            }
			else if(shareSkin) {
                [kAppDelegate.alertView addButtonWithTitle:@"Share"
                                                        //same color now
                                                      //type: (!premiumSkin ? kAlertButtonOrange : kAlertButtonOrange)
                                                      type:kAlertButtonGreen
                                                   handler:^(SIAlertView *alert) {
                                                       [kAppDelegate playSound:kClickSound];

                                                       float secs = 0.8f;
                                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                           [self shareButtonPressed:nil];
                                                       });
                                                   }];
            }

			else if(followSkin) {
                [kAppDelegate.alertView addButtonWithTitle:@"Follow on Facebook"
                                                        //same color now
                                                      //type: (!premiumSkin ? kAlertButtonOrange : kAlertButtonOrange)
                                                      type:kAlertButtonGreen
                                                   handler:^(SIAlertView *alert) {
                                                       [kAppDelegate playSound:kClickSound];

                                                       float secs = 0.8f;
                                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                           [self gotoFacebook];
                                                       });
                                                   }];

                [kAppDelegate.alertView addButtonWithTitle:@"Follow on Twitter"
                                                        //same color now
                                                      //type: (!premiumSkin ? kAlertButtonOrange : kAlertButtonOrange)
                                                      type:kAlertButtonGreen
                                                   handler:^(SIAlertView *alert) {
                                                       [kAppDelegate playSound:kClickSound];

                                                       float secs = 0.8f;
                                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                           [self gotoTwitter];
                                                       });
                                                   }];
            }

			else if(rateSkin) {
                [kAppDelegate.alertView addButtonWithTitle:@"Rate"
                                                        //same color now
                                                      //type: (!premiumSkin ? kAlertButtonOrange : kAlertButtonOrange)
                                                      type:kAlertButtonGreen
                                                   handler:^(SIAlertView *alert) {
                                                       [kAppDelegate playSound:kClickSound];

                                                       float secs = 0.8f;
                                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                           [self rateButtonPressed2:nil];
                                                       });
                                                   }];
            }
            else if(lastSkin)
            {
                [kAppDelegate.alertView addButtonWithTitle:[CBSkinManager getRandomOKButton] //@"Challenge Accepted"
                                                      type:kAlertButtonGreen
                                                   handler:^(SIAlertView *alert) {
                                                       [kAppDelegate playSound:kClickSound];
                                                   }];
            }
            else if(secretSkin)
            {
                [kAppDelegate.alertView addButtonWithTitle:@"???" //[CBSkinManager getRandomOKButton]
                                                      type:kAlertButtonGreen
                                                   handler:^(SIAlertView *alert) {
                                                       [kAppDelegate playSound:kClickSound];
                                                   }];
            }
            else if(comingSoon)
            {
                [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                                      type:kAlertButtonGreen
                                                   handler:^(SIAlertView *alert) {
                                                       [kAppDelegate playSound:kClickSound];
                                                   }];
            }

			else if (videoSkin)
			{

			            [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringWatchAd")
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [weakSelf enableButtons:YES];

                                           [kAppDelegate playSound:kClickSound];

                                           //offline
                                           if(![kHelpers checkOnline]) {
                                               [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
                                               return;
                                           }

                                           //too soon
                                           if(kAppDelegate.lastVideoUnlockDate)
                                           {
                                               NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:kAppDelegate.lastVideoUnlockDate];
                                               if(interval < kIntervalTooSoon) {
                                                  // [kHelpers showErrorHud:LOCALIZED(@"kStringTooSoon")];

                                                   [kHelpers dismissHud];
                                                   [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringTooSoon")];

                                                   return;
                                               }
                                           }

                                           //remember
                                           kAppDelegate.skinVideoUnlock = newSelected;

                                           [kHelpers showMessageHud:@""];

                                           [self resetTimerStory];

                                           float secs = 1.0f;
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               //[kHelpers dismissHud];

                                               //video
                                               if([kAppDelegate hasRewardedVideo:kRewardUnlockSkinTitle]) {
                                                   self.sharing = YES;
                                                   kAppDelegate.lastVideoUnlockDate = [NSDate date];
                                                   [kAppDelegate showRewardedVideo:kRewardUnlockSkinTitle];
                                               }
                                               else {
                                                   [kHelpers dismissHud];
                                                   [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorNoVideo")];
                                               }

                                           });

                                           //after delay, in case
                                           /*secs = 5.0f;
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [kHelpers dismissHud];

                                           });*/
                                       }];


			}
#endif

        //price, not for special?
        //if(!premiumSkin && !lastSkin && !shareSkin && !rateSkin && !secretSkin && !videoSkin && !followSkin)
        if(!premiumSkin && !lastSkin &&!secretSkin &&!comingSoon)
        {
#if 0
            //[kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringWatchAd") //LOCALIZED(@"kStringWatchAd")
            [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringTry")
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [weakSelf enableButtons:YES];

                                           [kAppDelegate playSound:kClickSound];

                                           //offline
                                           if(![kHelpers checkOnline]) {
                                               [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
                                               return;
                                           }

                                           //too soon
                                           if(kAppDelegate.lastVideoUnlockDate)
                                           {
                                               NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:kAppDelegate.lastVideoUnlockDate];
                                               if(interval < kIntervalTooSoon) {
                                                  // [kHelpers showErrorHud:LOCALIZED(@"kStringTooSoon")];

                                                   [kHelpers dismissHud];
                                                   [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringTooSoon")];

                                                   return;
                                               }
                                           }

                                           //remember
                                           kAppDelegate.skinVideoUnlock = newSelected;

                                           //[kHelpers showMessageHud:@""];


                                           [self resetTimerStory];

                                           float secs = 0.3f;
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [kHelpers dismissHud];

                                               //video
                                               if([kAppDelegate hasRewardedVideo:kRewardUnlockSkinTitle]) {

                                                   //force ad back
                                                   //kAppDelegate.gameController.darkAdImage.hidden = NO;

                                                   kAppDelegate.lastVideoUnlockDate = [NSDate date];
                                                   [kAppDelegate showRewardedVideo:kRewardUnlockSkinTitle];
                                               }
                                               else {
                                                   [kHelpers dismissHud];

                                                   [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorNoVideo")];
                                               }

                                           });

                                           //after delay, in case
                                           /*secs = 5.0f;
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [kHelpers dismissHud];

                                           });*/
                                       }];
#endif


            SKProduct *product = nil;
            NSString *whichProduct = [CBSkinManager getSkinIAP:newSelected]; //kIAP_SkinMiner;

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
                //[kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
            }


            NSString *price = [kAppDelegate.iapPrices objectForKey:whichProduct];
            NSString *title = nil;
            if(price)
                title = [NSString stringWithFormat:@"Unlock now (%@)", price];
            else
                title = [NSString stringWithFormat:@"Unlock now"];

            //if(product)
            {
                [kAppDelegate.alertView addButtonWithTitle:title
                                     type:kAlertButtonGreen
                                  handler:^(SIAlertView *alert) {
                                      [weakSelf enableButtons:YES];

                                      [kAppDelegate playSound:kClickSound];


                                      //offline
                                      if(![kHelpers checkOnline]) {
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                              [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
                                          });
                                          return;
                                      }

                                      //other error
                                      if(!product)
                                      {
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                              [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
                                          });
                                          return;
                                      }


//                                      //payments
//                                      if(![kHelpers canMakePayments]) {
//                                          [kHelpers showErrorHud:LOCALIZED(@"kStringPayments")];
//                                          return;
//                                      }



#if 1 //real
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
                                                             int numBefore = [weakSelf numItemsInCarousel];

                                                             //good
                                                             [kAppDelegate unlockBlock:newSelected];

                                                             int numAfter = [weakSelf numItemsInCarousel];

                                                             [weakSelf updateBadges];
                                                             [weakSelf setupBackgroundImages];

                                                             //save
                                                             [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];

                                                             //refill
                                                             kAppDelegate.numHearts = kHeartFull;
                                                             //[self setNumHearts:(int)kAppDelegate.numHearts];


                                                             //also disable banner ads temporarily
                                                             kAppDelegate.adBannerEnabledTemp = NO;


                                                             //update carousel
                                                             [self.carousel reloadData];
                                                             [self updateSkinName];


                                                             [kAppDelegate saveState];

                                                             [kAppDelegate playSound:kUnlockSound];
                                                             [kAppDelegate playSound:kUnlockSound2];

                                                             [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
                                                             [self startConfetti];
                                                             float secs = kConfettiThanksDuration;
                                                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                                 [self stopConfetti];
                                                             });

                                                             //fix 1st unlock offset
                                                             if(numAfter != numBefore)
                                                             {
                                                                 int index = (int)weakSelf.carousel.currentItemIndex;
                                                                 index++;
                                                                 [weakSelf.carousel scrollToItemAtIndex:index animated:NO];
                                                             }


                                                             [weakSelf updateBackground:NO];

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
#endif

#if 0 //fake
                                      float secs = 2.0f;
                                      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                          int numBefore = [weakSelf numItemsInCarousel];

                                          [kAppDelegate unlockBlock:newSelected];

                                          //also disable banner ads temporarily
                                          kAppDelegate.adBannerEnabledTemp = NO;


                                          int numAfter = [weakSelf numItemsInCarousel];

                                          [weakSelf updateBadges];

                                          [weakSelf setupBackgroundImages];

                                          [kAppDelegate playSound:kUnlockSound];
                                          [kAppDelegate playSound:kUnlockSound2];

                                          [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
                                          [weakSelf startConfetti];
                                          float secs = kConfettiThanksDuration;
                                          dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                              [weakSelf stopConfetti];
                                          });

                                          [weakSelf.carousel reloadData];

                                          //fix 1st unlock offset
                                          if(numAfter != numBefore)
                                          {
                                              int index = (int)weakSelf.carousel.currentItemIndex;
                                              index++;
                                              [weakSelf.carousel scrollToItemAtIndex:index animated:NO];
                                          }


                                          [weakSelf updateBackground:NO];
                                      });
#endif

                                  }];
            }

        }


            [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
                //nothing
            }];

            [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
                [weakSelf enableButtons:YES];

                //[kAppDelegate playSound:kClickSound];

                [weakSelf showVCR:NO animated:YES];

            }];


            kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
            kAppDelegate.alertView.transitionStyle = kAlertStyle;


            [kAppDelegate.alertView show:YES];

            //shake
            //[self.view shake];

            //[self enableButtons:YES];

            [self showVCR:YES animated:YES];


            //done
            return;
        }



    }

    //mark as read
    [kAppDelegate.dicSkinNew setObject:@(NO)forKey:[CBSkinManager getSkinKey:(int)[kAppDelegate getSkin]]];
    //mark all read
    //[kAppDelegate markAllAsRead];

    [self enableButtons:NO];

    [self updateBadges];

    //[kAppDelegate playSound:kClickSound];
    [kAppDelegate playSound:@"smb3_bump.caf"];

    [self showFlash:[UIColor whiteColor]];

    self.menuState = menuStateGame;

    self.spinner.hidden = YES; //disabled



    //confetti
    [self startConfetti];
    float secs2 = 1.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopConfetti];
    });



    float secs = 0;
    if(random)
        secs += 0.5f; //wait for sound

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //stop animation
        self.animateRandom = NO;
        [self.carousel reloadData];

        float secs = 0;
        if(random)
            secs += 0.5f; //wait for sound

        //random
        int min = 0;
        int max = 2;
        int random =  min + arc4random_uniform(max); //0-1

        NSString *soundName =[CBSkinManager getStartSoundName:(int)[kAppDelegate getSkin]];
        [kAppDelegate playSound:soundName];

        //credit coin
        //[kAppDelegate playSound:@"credit1.caf"];

        [kAppDelegate animateControl:self.resumeButton];
        [kAppDelegate animateControl:self.carousel];
        [kAppDelegate animateControl:self.logoButton];

        [self updateBackground:NO];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self fadeIn];

            float secs = kFadeDuration;
            if(random)
                secs += 0.5; //wait for sound

            //if([kAppDelegate isGameCenterNotificationUp])
            //    secs += kWaitForGameCenterDelay;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                //force reset
//                kAppDelegate.gameController = nil;
//                kAppDelegate.gameController = [kStoryboard instantiateViewControllerWithIdentifier:@"game"];
//                [kAppDelegate setViewController:kAppDelegate.gameController];

                [kAppDelegate setViewController:kAppDelegate.transitionController];

            });

        });

    });

    //save
    [kAppDelegate saveState];
}


- (void)showCommercial {

    //test youtube

    /*[self presentViewController:kAppDelegate.videoController animated:false completion:^{
     //nothing

     }];*/

    if(self.menuState == menuStateVideo)
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

    self.menuState = menuStateVideo;

    [self fadeIn];
    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        kAppDelegate.videoController.previousViewController = self;

        [kAppDelegate setViewController:kAppDelegate.videoController];
    });

    return;
}

- (IBAction)cheatsButtonPressed:(id)sender
{
    self.skipFade = NO;

    //[kAppDelegate animateControl:self.cheatButton];

    kAppDelegate.fadingWhite = YES;

    [self enableButtons:NO];

    [kAppDelegate playSound:kClickSound];

    self.menuState = menuStateCheat;

    [self fadeIn];
    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[kAppDelegate setViewController:kAppDelegate.cheatController];
    });

}

- (IBAction)volumeButtonPressed:(id)sender
{
    [kHelpers haptic1];
    
    [kAppDelegate animateControl:self.volumeButton];

    if(kAppDelegate.soundVolume > 0.0f || kAppDelegate.musicVolume > 0.0f) {
        [kAppDelegate setSoundVolume:0];
        [kAppDelegate setMusicVolume:0];
    }
    else {
        [kAppDelegate setSoundVolume:kDefaultVolumeSound];
        [kAppDelegate setMusicVolume:kDefaultVolumeMusic];
    }


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kAppDelegate playSound:kClickSound];
    });

    [self updateVolumeButton];

    [kAppDelegate saveState];
}

-(void)updateVolumeButton {
    if(kAppDelegate.soundVolume > 0.0f || kAppDelegate.musicVolume > 0.0f) {
        [self.volumeButton setBackgroundImage:[UIImage imageNamed:@"menu_icon_volume"] forState:UIControlStateNormal];
    }
    else {
        [self.volumeButton setBackgroundImage:[UIImage imageNamed:@"menu_icon_volume_off2"] forState:UIControlStateNormal];
    }
}

- (IBAction)optionsButtonPressed:(id)sender
{
    self.skipFade = NO;

    //self.resumeButton.alpha = kButtonSelectedAlpha;

    [kAppDelegate animateControl:self.optionsButton];

    [self enableButtons:NO];

    [kAppDelegate playSound:kClickSound];

    self.menuState = menuStateSettings;

    [self fadeIn];
    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			[kAppDelegate setViewController:kAppDelegate.settingsController];
    });

}

- (IBAction)versionButtonPressed:(id)sender {
    Log(@"versionButtonPressed");

    //BOOL isDebug = ([kHelpers isDebug]);
    //if(!isDebug)
    //    return;


    self.cheatVersionCount++;
    if(self.cheatVersionCount >= 10) {
        [self enableButtons:NO];

        self.cheatVersionCount = 0;
        [self cheatsButtonPressed:nil];
    }
}


- (IBAction)storeButtonPressed:(id)sender
{
    self.skipFade = NO;

    [kAppDelegate animateControl:self.storeButton];

    [self enableButtons:NO];

    //self.storeButton.alpha = kButtonSelectedAlpha;

    [self.storeButton setBadgeValue:nil];

    [kAppDelegate playSound:kClickSound];

    self.menuState = menuStateStore;

    [self fadeIn];
    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			//[kAppDelegate setViewController:kAppDelegate.skinController];

    });
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
                                   //[kAppDelegate playSound:kClickSound];

                                   //email
                                   [weakSelf contactButtonPressed:nil];
                               }];


    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringLoveIt")
                                  type:kAlertButtonGreen
                               handler:^(SIAlertView *alert) {

                                   [self rateButtonPressed2:nil];

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

        [weakSelf showVCR:NO animated:YES];

        [weakSelf enableButtons:YES];

    }];


    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];

    [self showVCR:YES animated:YES];
}

- (IBAction)rateButtonPressed2:(id)sender
{
    //self.rateButton.alpha = kButtonSelectedAlpha;

    [kAppDelegate animateControl:self.rateButton];

    if(sender)
        [kAppDelegate playSound:kClickSound];

    [kAppDelegate openRatings];


	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayUnlockAfterURL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

		//achievement
		[kAppDelegate reportAchievement:kAchievement_rate];

        int numBefore = [self numItemsInCarousel];

		//unlock emoji skin
		[kAppDelegate unlockBlock:kCoinTypePew];

        int numAfter = [self numItemsInCarousel];

		//update carousel
		[self.carousel reloadData];
		[self updateSkinName];
		//[self updateBadges];

        if(numBefore != numAfter)
        {
            int index = kCoinTypePew + 1; //+random
            [self.carousel scrollToItemAtIndex:index animated:NO];

            [self setupBackgroundImages];

            [kAppDelegate playSound:kUnlockSound];
            [kAppDelegate playSound:kUnlockSound2];

            [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
            [self startConfetti];
            float secs = kConfettiThanksDuration;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
              [self stopConfetti];
            });
        }

	});
}

- (IBAction)otherButtonPressed:(id)sender
{
    //self.otherButton.alpha = kButtonSelectedAlpha;

    [kAppDelegate animateControl:self.otherButton];
    [kAppDelegate animateControl:self.otherButton2];

    //save
    int numAppsInt = [self.numApps intValue];
    kAppDelegate.numApps = numAppsInt;
    [kAppDelegate saveState];

    [self.otherButton setBadgeValue:nil];
    [self.otherButton2 setBadgeValue:nil];

    [kAppDelegate playSound:kClickSound];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/artist/skyriser-media/id359807334"] options:@{} completionHandler:nil];

}

- (IBAction)heartButtonPressed:(id)sender
{
    if(![kAppDelegate isPremium])
    {
        //alert
        __weak typeof(self) weakSelf = self;

        NSString *message = LOCALIZED(@"kStringPremiumHeartAsk");

        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            [kAppDelegate.alertView dismissAnimated:NO];

        kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"VIP"
                                                         andMessage:message];

        [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringPremiumButton")
                                              type:kAlertButtonGreen
                                           handler:^(SIAlertView *alert) {

                                               [kAppDelegate playSound:kClickSound];

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * 0.33f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                   [self premiumButtonPressed:nil];
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
}

- (IBAction)modeButtonPressed:(id)sender
{
	//alert
	[kAppDelegate animateControl:self.modeButton];

	[kAppDelegate playSound:kClickSound];

	__weak typeof(self) weakSelf = self;

    //ask
    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Modes"
                   andMessage:[NSString stringWithFormat:@"More <color1>Game Modes</color1> are coming soon!"]];

    [kAppDelegate.alertView addButtonWithTitle:@"Story Mode" //LOCALIZED(@"kStringGotIt")
                                  type:kAlertButtonGreen
                               handler:^(SIAlertView *alert) {
								   //nothing for now
                               }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing

    }];

    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

        [weakSelf showVCR:NO animated:YES];

    }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kAppDelegate.alertView show:YES];
    //});


    [self showVCR:YES animated:YES];
}



- (IBAction)premiumButtonPressed:(id)sender
{
    [self adButtonPressed:sender];

}

- (IBAction)adButtonPressed:(id)sender
{
    //premium skip
    //if([kAppDelegate isPremium])
    //    return;

    [self resetTimerStory];

    //[kAppDelegate dbIncPremium];

    //just to go premium view
    self.skipFade = NO;
    [kAppDelegate animateControl:self.premiumButton];
    [self enableButtons:NO];

    if(sender)
        [kAppDelegate playSound:kClickSound];

    kAppDelegate.titleController.menuState = menuStatePremium;

    [self fadeIn];
    float secs2 = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        kAppDelegate.premiumController.backToGame = NO;

        [kAppDelegate setViewController:kAppDelegate.premiumController];
    });

    return;




//    [kAppDelegate animateControl:self.adButton];
//    [kAppDelegate animateControl:self.adButton2];

    [kAppDelegate playSound:kClickSound];


//    [kAppDelegate animateControl:self.carousel];
//    [kAppDelegate animateControl:self.logoButton];

    [kAppDelegate animateControl:self.premiumButton];

//
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

                                                                                        [kAppDelegate unlockAllBlocks];

                                                                                        //also doubler
                                                                                        [kAppDelegate unlockDoubler];

                                                                                        [kAppDelegate saveState];

                                                                                        [self updateUI];
                                                                                        [self setupBackgroundImages];

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
		//nothing

        [self.carousel reloadData];
        [self updateUI];
	}];

	[kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

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

}

- (IBAction)twitterButtonPressed:(id)sender {
    [kAppDelegate animateControl:self.twitterButton];

    [self gotoTwitter];
}


- (void)gotoTwitter
{

    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]])
    {
        //[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"twitter://CoinBlockApp"]];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=CoinBlockApp"] options:@{} completionHandler:nil];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=CoinyBlock"] options:@{} completionHandler:nil];

    }
    else
    {
        //fanPageURL failed to open.  Open the website in Safari instead
        //NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/pages/Password-Grid/169115183113120"];

        NSURL *webURL = [NSURL URLWithString:@"http://twitter.com/CoinyBlock"];
        //NSURL *webURL = [NSURL URLWithString:@"http://twitter.com/SkyriserMedia"];
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];
    }

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayUnlockAfterURL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        int numBefore = [self numItemsInCarousel];

        //unlock
		[kAppDelegate unlockBlock:kCoinTypeEmoji];

        int numAfter = [self numItemsInCarousel];

		//achievement
		[kAppDelegate reportAchievement:kAchievement_social];

		 //update carousel
		[self.carousel reloadData];
		[self updateSkinName];
		//[self updateBadges];

        [self setupBackgroundImages];
        [self updateSkinName];
        [self updateArrowImage];


        if(numBefore != numAfter)
        {
            int index = kCoinTypeEmoji + 1; //+random
            [self.carousel scrollToItemAtIndex:index animated:NO];

            [kAppDelegate playSound:kUnlockSound];
            [kAppDelegate playSound:kUnlockSound2];

            [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
            [self startConfetti];
            float secs = kConfettiThanksDuration;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
              [self stopConfetti];
            });
        }

	});
}

- (IBAction)likeButtonPressed:(id)sender {
    [kAppDelegate animateControl:self.likeButton];

    [self gotoFacebook];
}

- (void)gotoFacebook
{
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]])
    {
        //[[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"fb://profile/CoinBlockApp"]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/868865553150465"] options:@{} completionHandler:nil];
    }
    else
    {
        //fanPageURL failed to open.  Open the website in Safari instead
        //NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/pages/Password-Grid/169115183113120"];

        NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/CoinyBlock"];
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];

    }

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayUnlockAfterURL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        int numBefore = [self numItemsInCarousel];

		//unlock
		[kAppDelegate unlockBlock:kCoinTypeEmoji];

        int numAfter = [self numItemsInCarousel];


		//achievement
		[kAppDelegate reportAchievement:kAchievement_social];

		 //update carousel
		[self.carousel reloadData];
		[self updateSkinName];

        [self setupBackgroundImages];
        [self updateSkinName];
        [self updateArrowImage];

        if(numBefore != numAfter)
        {
            int index = kCoinTypeEmoji + 1; //+random
            [self.carousel scrollToItemAtIndex:index animated:NO];

            [kAppDelegate playSound:kUnlockSound];
            [kAppDelegate playSound:kUnlockSound2];

            [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
            [self startConfetti];
            float secs = kConfettiThanksDuration;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self stopConfetti];
            });

        }

	});
}

- (IBAction)shareButtonPressed:(id)sender
{
    //glitch email
    self.skipFade = YES;

    [kAppDelegate dbIncShare];

    [self resetTimerStory];

    if(sender)
    {
        [kAppDelegate playSound:kClickSound];
        [kAppDelegate animateControl:self.shareButton];
    }

    //[kHelpers showMessageHud:@""];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
      //  [kHelpers dismissHud];
    });


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

    [activityVC setCompletionWithItemsHandler:
     ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError) {
         self.sharing = NO;

         //[kHelpers dismissHud];

         if(completed)
         {
			 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayUnlockAfterURL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

			 	//achievement
				[kAppDelegate reportAchievement:kAchievement_share];

                 int numBefore = [self numItemsInCarousel];

				 //unlock emoji skin
				 [kAppDelegate unlockBlock:kCoinTypeFlap];

                 int numAfter = [self numItemsInCarousel];

				 //update carousel
				 [self.carousel reloadData];

                 [self updateSkinName];
                 [self updateArrowImage];
				 [self setupBackgroundImages];

                 //if(!sender)
                 if(numBefore != numAfter)
                 {
                     int index = kCoinTypeFlap + 1; //+random
                     [self.carousel scrollToItemAtIndex:index animated:NO];


                    [kAppDelegate playSound:kUnlockSound];
                    [kAppDelegate playSound:kUnlockSound2];

                    [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
                    [self startConfetti];
                    float secs = kConfettiThanksDuration;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                      [self stopConfetti];
                    });
                 }


			});
         }
     }];

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
        //self.skipFade = YES;

    }];

}

- (IBAction)socialButtonPressed:(id)sender
{
    [kAppDelegate playSound:kClickSound];

    [kAppDelegate animateControl:self.socialButton];

    if(![kHelpers checkOnline])
    {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        return;
    }

    [kHelpers showMessageHud:@""];
    float secs = 0.5f; //1.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kHelpers dismissHud];
    });

    secs = 0.3f; //0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.socialButton setBadgeValue:nil];
#if kKTPlayEnabled
#if !(TARGET_IPHONE_SIMULATOR)
        [KTPlay show];
#endif
#endif
    });

}

- (IBAction)leaderboardButtonPressed:(id)sender
{
    [self resetTimerStory];

    [kAppDelegate playSound:kClickSound];

    [kAppDelegate animateControl:self.leaderboardButton];

    //offline
    if(![kHelpers checkOnline]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        return;
    }

    if(![kAppDelegate isGameCenter]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringGamecenterOffline")];
        return;
    }

	//force
	//kAppDelegate.gameCenterEnabled = YES;
	//[kAppDelegate setupGameCenter];

    //[kHelpers showMessageHud:@""];
    float secs = 0.0f; //0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kHelpers dismissHud];
    });

    secs = 0.0f; //0.3f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
    });

}

- (IBAction)actionMult:(id)sender
{
    __weak typeof(self) weakSelf = self;

    [kAppDelegate playSound:kClickSound];

    [self enableButtons:NO];

    [self resetTimerStory];

    NSString *title = @"Power Coins";
    NSString *message = nil;
    NSString *buttonText = nil;

    if(kAppDelegate.rainbowCount>0)
    {
        //up
        message = @"Your coin <color1>Power</color1> multiplier has been increased!";
        buttonText = [CBSkinManager getRandomOKButton];
    }
    else
    {
        //normal
        message = @"Collect secret <color1>Power Coins</color1> to upgrade your coin <color1>Power</color1> multiplier.";
        buttonText = [CBSkinManager getRandomOKButton];
    }

    //reset
    kAppDelegate.rainbowCount = 0;
    //kAppDelegate.rainbowUsedCount = 0;
    [kAppDelegate saveState];
    [self updateMult];

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:title
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:buttonText
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           //
                                           [kAppDelegate playSound:kClickSound];

                                       }];

    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

        [weakSelf showVCR:NO animated:YES];

        [weakSelf enableButtons:YES];


    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing

        [weakSelf enableButtons:YES];

    }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];


    [self showVCR:YES animated:YES];


}

- (IBAction)actionChest:(id)sender
{
    [kAppDelegate playSound:kClickSound];
    [kAppDelegate playSound:@"key1.caf"];

    [kAppDelegate animateControl:self.chestImage];
    self.chestBadge.hidden = YES;

    [self enableButtons:NO];

    [self fadeIn];
    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

		//also hide
		[self hideChest];
		kAppDelegate.chestDate = [NSDate date];
        [kAppDelegate saveState];

        //go to  win
        kAppDelegate.winController.backToGame = NO;
        kAppDelegate.winController.backToTitle = YES;
        [kAppDelegate setViewController:kAppDelegate.winController];
    });
}

- (IBAction)actionHashtag:(id)sender
{
    [kAppDelegate actionHashtag];
}

- (IBAction)actionTitleBar:(id)sender
{
    [self.carousel scrollToItemAtIndex:0 animated:YES];
}

- (IBAction)contactButtonPressed:(id)sender
{
    self.skipFade = YES;

    [kAppDelegate playSound:kClickSound];

    [kAppDelegate animateControl:self.contactButton];

    //[kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];


    NSString *version = [kHelpers getVersionString2];
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    NSString *model = [kHelpers platformString];
    NSString *body = [NSString stringWithFormat: @"App Version: %@\niOS Version: %@\niOS Device: %@\n\n\nDear Skyriser Media, \n\n\n\n", version, iosVersion, model];

    [kAppDelegate sendEmailTo:@"coinyblock@skyriser.com" withSubject: @"Coiny Block Feedback" withBody:body withView:self];
}

/*-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    Log(@"Swipe received.");

    [self resumeButtonPressed:nil];
}*/

//resetStoryTimer
- (void)resetTimerStory
{
    //story 30s
    [self.timerStory invalidate];
    self.timerStory = nil;

    float interval = 30.0f;
    //force
    if([kHelpers isDebug])
    {
       //interval = 5.0f;
    }

    self.timerStory = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerStory:) userInfo:@"actionTimerStory" repeats:NO];
}

- (void)resetTimer{

    //speed
    //[self.timer invalidate];
    //self.timer = nil;

    float interval = 1; //kTimerDelayRandomEvent;

    //cheat
    [self.timerCheat invalidate];
    self.timerCheat = nil;

    interval = kCheatButtonInterval;
    self.timerCheat = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerCheat:) userInfo:@"actionTimerCheat" repeats:YES];

    [self resetTimerStory];

    //cloud
    [self.timerCloud invalidate];
    self.timerCloud = nil;

    interval = kCloudInterval;
    self.timerCloud = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                selector:@selector(actionTimerCloud:) userInfo:@"actionTimerCloud" repeats:YES];

    //call now
    [self actionTimerCloud:nil];



    //title
    [self.timerArrow invalidate];
    self.timerArrow = nil;
    interval = kFlashArrowsInterval;
    self.timerArrow = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerArrow:) userInfo:@"actionTimerArrow" repeats:YES];
    //call now
    [self actionTimerArrow:nil];


    //mult coin
    /*[self.timerMult invalidate];
    self.timerMult = nil;
    interval = 0.1f;
    self.timerMult = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerMult:) userInfo:@"actionTimerMult" repeats:YES];*/
    //call now

    //vcr
    [self.timerVCR invalidate];
    self.timerVCR = nil;
    interval = 2.0 + (arc4random_uniform(3*10)/10.0f);
    self.timerVCR = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerVCR:) userInfo:@"actionTimerVCR" repeats:NO];
    //call now
    //[self actionTimerVCR:nil];


    //bounce

    [self.timerBounce invalidate];
    self.timerBounce = nil;
    interval = 3.0;
    self.timerBounce = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                      selector:@selector(actionTimerBounce:) userInfo:@"actionTimerBounce" repeats:YES];

    //social
    [self.timerSocial invalidate];
    self.timerSocial = nil;
    interval = 1.5f;
    self.timerSocial = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                      selector:@selector(actionTimerSocial:) userInfo:@"actionTimerSocial" repeats:YES];

    [self.timerBlockMessage invalidate];
    self.timerBlockMessage = nil;
    interval = 1.0f; //2.0f;
    self.timerBlockMessage = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                      selector:@selector(actionTimerBlockMessage:) userInfo:@"actionTimerBlockMessage" repeats:YES];


    [self.timerLabelResult invalidate];
    interval = 0.1f; //kFlashArrowsInterval;
    self.timerLabelResult = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self
                                                           selector:@selector(actionTimerChestLabel:) userInfo:@"actionTimerChestLabel" repeats:YES];
}

- (void) actionTimer:(NSTimer *)incomingTimer
{
    //disabled
    return;

    if(kAppDelegate.titleController.menuState != menuStateTitle || (self.view.hidden == YES))
        return;

    //update hearts, timer
    //check hearts
    //[kAppDelegate checkHeartHeal];

    [self setNumHearts:(int)kAppDelegate.numHearts];

    [self wobble];
}


-(void)wobble {

    //disable
    return;

    //Log(@"title: wobble");
#if 0
    float wiggleOffset = 4.0f;
    float wiggleTimeEach = 0.1f;

    //reset
    self.resumeButton.y = self.oldResumeY;
    self.block.y = self.oldBlockY;
    //self.carousel.y = self.oldBlockY;


    //reset
    [self.block.layer removeAllAnimations];
    [self.carousel.layer removeAllAnimations ];


    //https://github.com/yangmeyer/CPAnimationSequence

    CPAnimationSequence* sequence = [CPAnimationSequence sequenceWithSteps:


    [CPAnimationStep after:0.0f for:wiggleTimeEach options:UIViewAnimationOptionAllowUserInteraction
                   animate:^{
        self.resumeButton.y -= wiggleOffset;
        //self.block.y -= wiggleOffset;
        //self.carousel.y -= wiggleOffset;
    }],

    [CPAnimationStep after:0.0f for:wiggleTimeEach options:UIViewAnimationOptionAllowUserInteraction
                                                    animate:^{
        self.resumeButton.y += wiggleOffset;
        //self.block.y += wiggleOffset;
        //self.carousel.y += wiggleOffset;
    }],

    [CPAnimationStep after:0.0f for:wiggleTimeEach options:UIViewAnimationOptionAllowUserInteraction
                                                    animate:^{
        self.resumeButton.y -= wiggleOffset/2;
        //self.block.y -= wiggleOffset/2;
        //self.carousel.y -= wiggleOffset/2;
    }],

    [CPAnimationStep after:0.0f for:wiggleTimeEach options:UIViewAnimationOptionAllowUserInteraction
                                                    animate:^{
        self.resumeButton.y += wiggleOffset/2;
        //self.block.y += wiggleOffset/2;
        //self.carousel.y += wiggleOffset/2;
    }],

                                     nil];
    //CPAnimationSequence UIViewAnimationOptionAllowUserInteraction

    [sequence runAnimated:YES];
#endif
}

- (void) shakeWasRecognized:(NSNotification*)notif {

    if(kAppDelegate.titleController.menuState != menuStateTitle)
        return;

    [self resetTimerStory];

    //[self showCommercial];
    //return;

    if([kHelpers isBackground])
        return;

    //if(![kHelpers isDebug])
    //    return;


   // BOOL isDebug = ([kHelpers isDebug]);
   //if(!isDebug)
    //    return;

    //cheat touch anim
    self.touch1.alpha = 0.0f;
    self.touch1Width.constant = self.touch1Height.constant = 40.0f;

    BOOL shouldReturn = NO;

    if(!self.curtainLeft.hidden)
        shouldReturn = YES;

    if(!self.cheatButton2.hidden)
        shouldReturn = YES;

    if([kHelpers isBackground])
        shouldReturn = YES;

    if(shouldReturn)
    {
        //shake
        //[kAppDelegate playSound:@"gasp1.caf"];

        float duration = 1.0f;

        //animate touch
        [UIView animateWithDuration:1.0f animations:^{
            self.cheatButton2.alpha = duration;
        } completion:^(BOOL finished) {
            [kAppDelegate animateControl:self.cheatButton2];

            //touch
            float touchScale = 4.0f;
            float touchScaleOld = self.touch1Height.constant;
            float touchDuration = 1.2f;
            float touchAlphaStart = 0.6f;

            //touch 1
            self.touch1.alpha = touchAlphaStart;
            self.touch1Width.constant = self.touch1Height.constant = touchScaleOld * touchScale;
            [UIView animateWithDuration:touchDuration delay:0.0f options:0 animations:^{
                //animate constraint
                [self.view layoutIfNeeded];
                self.touch1.alpha = 0.0f;
            }
                             completion:nil];
        }];

        return;
    }

    if(kAppDelegate.titleController.menuState == menuStateTitle) {

        self.cheatButton2.alpha = 0;
        self.cheatButton2.hidden = NO;


        float duration = 1.0f;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //[kAppDelegate playSound:@"gasp1.caf"];
        });

        [kAppDelegate playSound:@"aaaahhh.caf"];
        //doo doo doo
        [kAppDelegate playSound:@"discover.caf"];

        //animate touch
        [UIView animateWithDuration:1.0f animations:^{
            self.cheatButton2.alpha = duration;
        } completion:^(BOOL finished) {
            [kAppDelegate animateControl:self.cheatButton2];

            //touch
            float touchScale = 4.0f;
            float touchScaleOld = self.touch1Height.constant;
            float touchDuration = 1.2f;
            float touchAlphaStart = 0.6f;

            //touch 1
            self.touch1.alpha = touchAlphaStart;
            self.touch1Width.constant = self.touch1Height.constant = touchScaleOld * touchScale;
            [UIView animateWithDuration:touchDuration delay:0.0f options:0 animations:^{
                //animate constraint
                [self.view layoutIfNeeded];
                self.touch1.alpha = 0.0f;

                //[kAppDelegate playSound:@"toastieAlert.caf"];
                //[kAppDelegate playSound:@"secret.caf"];
                //[kAppDelegate playSound:@"aaaahhh.caf"];

            }
            completion:nil];
        }];

        //[self cheatsButtonPressed:nil];
    }
}

- (void)notifyForeground
{
    if(kAppDelegate.titleController.menuState != menuStateTitle)
        return;

    [self resetTimerStory];

    //only for iOS7
    //if(kIsIOS8)
    //    return;

    //re-add anim
    [self addShineAnimation];

    //reset
    [self showWhiteBar];

    //force
    self.tutoArrow.hidden = YES;

    [self showArrow];

    [self showCoins];

	  [self updateChest];

    [self updateMult];

    [self updateDownload];


    [self setupPremium];

    //update parse
    [self updateParseStats:nil];

    [self updateTitleCount];

    [self updateSuffix];

    [self addLogoAnimation2];

    //reset logo
    self.logo.image = [UIImage imageNamed:@"logo"];

    [self loadSounds];
}


- (void)notifyBackground
{
    //only for iOS7
    //if(kIsIOS8)
    //    return;

    //fix crash
    [self.shineImageView.layer removeAllAnimations];

    [self.tutoArrow.layer removeAllAnimations];

    [self.premiumButton.layer removeAllAnimations];
    [self.premiumBack.layer removeAllAnimations];

    [self.logo.layer removeAllAnimations];

    [self.labelSuffix.layer removeAllAnimations];
    [self.labelSuffixMulti.layer removeAllAnimations];

    [self.chestShine.layer removeAllAnimations];

}


- (void) actionTimerSocial:(NSTimer *)incomingTimer
{
    [self showSocialMessage];
}

- (void) actionTimerBlockMessage:(NSTimer *)incomingTimer
{
    [self showBlockMessage];
}

- (void) actionTimerBounce:(NSTimer *)incomingTimer
{
    //also check gamecenter update
    self.leaderboardButton2.hidden = NO; //![kAppDelegate isGameCenter]; //NO

    [kAppDelegate animateControl:self.shareButton];
    [kAppDelegate animateControl:self.rateButton];
    //[kAppDelegate animateControl:self.socialButton];

    [kAppDelegate animateControl:self.heartPlus];
}

-(void)actionTimerChestLabel:(NSTimer *)incomingTimer
{
    self.boolTimerLabelChest = !self.boolTimerLabelChest;
    if(self.boolTimerLabelChest)
	{
        self.chestLabel.textColor = [UIColor colorWithHex:0xff8000]; //orange
        self.multLabel.textColor = [UIColor colorWithHex:0xff8000]; //orange

	}
    else
	{
        self.chestLabel.textColor = [UIColor colorWithHex:0xfdfd51]; //yellow
        self.multLabel.textColor = [UIColor colorWithHex:0xfdfd51]; //yellow
	}


}

-(void)actionTimerMult:(NSTimer*)incomingTimer
{
    //disabled
    return;

#if 0

    //also coin
    self.multImage.image = [self.multImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];


if 1
    NSArray *colorArray = @[
                            [UIColor whiteColor],
                            [UIColor colorWithHex:0xff8000], //orange

                            [UIColor whiteColor],
                            [UIColor blueColor],

                            [UIColor whiteColor],
                            [UIColor colorWithHex:0xfdfd51], //yellow

                            [UIColor whiteColor],
                            [UIColor purpleColor],

                            [UIColor whiteColor],
                            [UIColor greenColor],

                            [UIColor whiteColor],
                            [UIColor redColor],

                            ];
endif

if 0
            NSArray *colorArray = @[
                        //[UIColor whiteColor],
                        [UIColor colorWithHex:0xff8000], //orange

                        //[UIColor whiteColor],
                        [UIColor colorWithHex:0xfdfd51], //yellow

                          ];
endif


    UIColor *coinColor = [colorArray objectAtIndex:self.multColorIndex];

    self.multColorIndex++;
    if(self.multColorIndex >= colorArray.count)
        self.multColorIndex = 0;

    [self.multImage setTintColor:coinColor];
    //self.multImage.image = [self colorizeImage:[UIImage imageNamed:@"coinWhite"] color:coinColor];

#endif
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

    if(kAppDelegate.titleController.menuState != menuStateTitle || (self.view.hidden == YES))
        return;

    if(!self.curtainLeft.hidden)
        return;

    if([kHelpers isSlowDevice])
        return;

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        return;

    if(self.showingKTPlay)
        return;

    //glitch
    /*if(NO)
    {
        self.logo.image = [UIImage imageNamed:@"logo_glitch2"];
        self.logo.alpha = 0.8f;
    }*/

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
    //self.vcr.alpha = kBlockLockedAlpha;
    //self.vcr.y = arc4random_uniform(200); //random pos


    float secs = 0.1f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //reset logo
        self.logo.image = [UIImage imageNamed:@"logo"];
        self.logo.alpha = 1.0f;
        //self.vcr.hidden = YES;
    });
}

- (void) actionTimerArrow:(NSTimer *)incomingTimer
{
    //[self actionTimerChestLabel:nil];

    if(kAppDelegate.titleController.menuState != menuStateTitle || (self.view.hidden == YES))
        return;


    //subtitle test
    //if(self.redArrowLeft.hidden)
    //    [self updateSuffix];

    //toggle
    //self.redArrow.hidden = !self.redArrow.hidden;
    self.redArrowLeft.hidden = !self.redArrowLeft.hidden;
    self.redArrowRight.hidden = !self.redArrowRight.hidden;

    //hide at ends
    if(self.carousel.currentItemIndex == 0) {
        self.redArrowLeft.hidden = YES;
    }
    else if(self.carousel.currentItemIndex == self.carousel.numberOfItems-1) {
        self.redArrowRight.hidden = YES;
    }
    else {

        if(self.redArrowLeft.hidden != self.redArrowRight.hidden) {
            //different?
            self.redArrowLeft.hidden = self.redArrowRight.hidden;
        }
    }

    //self.resumeButton.hidden = !self.resumeButton.hidden;

    self.resumeButton.hidden = NO;
    NSMutableAttributedString *attributedString = nil;
    NSString *tempTitle = nil;

    int index = (int)self.carousel.currentItemIndex;
    BOOL isRandomVisible = [self isRandomVisible];
    if(isRandomVisible)
        index--;

    //random when random
    //change start
    //if(index == -1 && isRandomVisible)
     //   self.startText = [kAppDelegate getRandomStart:index];

    //start button text
    if(kAppDelegate.numHearts <= 0)
        tempTitle = @"Tap to Refill";
    else if (kAppDelegate.level <= 1) {
        //not yet
        tempTitle = @"Tap to Play!";
    }
    else
        tempTitle = self.startText;


    //force
    //tempTitle = @"Play!";
    //tempTitle = @"Play";
    //tempTitle = @"Start";
    tempTitle = @"Tap to Play";
    //tempTitle = @"1  Player Start";

    //locked
    BOOL enabled  = [kAppDelegate isBlockEnabledIndex:index];
    BOOL comingSoon = (index == kCoinTypeComingSoon);
    if(comingSoon)
    {
        tempTitle = @""; //@"...";
    }
    else if(!enabled && index >= 1) {
        tempTitle = @"Unlock";
    }


    //random
    //if(index == -1 && isRandomVisible) {
        //tempTitle = @"Random";
    //}

    if((index == -1 && !isRandomVisible)) {
        //premium
        tempTitle = @"Unlock";
    }
    else if(index == -1) { //first, random

        //random
        //tempTitle = @"Random";
    }



    if(self.redArrowLeft.hidden && self.redArrowRight.hidden) {
        tempTitle = @"";
        //bounce
        //chest
        [kAppDelegate animateControl:self.chestImage];
        //downloads
        [kAppDelegate animateControl:self.downloadButton];

        //suffix

        //[kAppDelegate animateControl:self.labelSuffix];
        //[kAppDelegate animateControl:self.labelSuffixMulti];

        if(kAppDelegate.numHearts >= 1)
            [kAppDelegate animateControl:self.heart1];
        if(kAppDelegate.numHearts >= 3)
            [kAppDelegate animateControl:self.heart2];
        if(kAppDelegate.numHearts >= 5)
            [kAppDelegate animateControl:self.heart3];
        if(kAppDelegate.numHearts >= 7)
            [kAppDelegate animateControl:self.heart4];

    }

    float spacing = 4.0f;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];

    [self updateResumeFont];

    UIColor *textColor = nil;
    if(kAppDelegate.numHearts <= 0)
        //textColor =[UIColor colorWithHex:0xb10004]; //red
        //textColor =[UIColor colorWithHex:0xdc6e02]; //orange
        textColor =[UIColor whiteColor];
        //textColor =[UIColor lightGrayColor];
    else
        textColor =[UIColor whiteColor];

    [attributedString addAttribute:NSForegroundColorAttributeName value:textColor range:NSMakeRange(0, [tempTitle length])];

    [self.resumeButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}

- (void) actionTimerCheat:(NSTimer *)incomingTimer
{
    if(!self.cheatButton2.hidden && self.cheatButton2.alpha >= 1.0f)
        [kAppDelegate animateControl:self.cheatButton2];
}

- (void) actionTimerStory:(NSTimer *)incomingTimer
{
    if(kAppDelegate.titleController.menuState != menuStateTitle)
        return;

    if([kHelpers isBackground])
        return;

    if([kAppDelegate isPlayingVideoAd])
    {
        [self resetTimerStory];
        return;
    }

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
    {
        [self resetTimerStory];
        return;
    }

    if(self.showingKTPlay)
        return;

    if(self.sharing)
        return;


    [self enableButtons:NO];

    [self fadeIn];
    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //reset
        kAppDelegate.storyController.toTransition = NO;

        kAppDelegate.titleController.menuState = menuStateStory;
        [kAppDelegate setViewController:kAppDelegate.storyController];
    });
}


- (void) actionTimerCloud:(NSTimer *)incomingTimer
{
    if(kAppDelegate.titleController.menuState != menuStateTitle || (self.view.hidden == YES))
        return;

    [self showCloud];
}

-(void)showCloud {

    //disabled
    return;

#if 0
    //CGRect tempRect = self.cloud1.frame;

    //still on screen
    if(self.cloud1.frame.origin.x < self.view.frame.size.width && self.cloud1.frame.origin.x > 0)
        return;

    self.cloud1.hidden = NO;
    self.cloud1.alpha = kCloudAlpha;

    self.cloud1.x = -kCloudWidth;
    //self.cloud1.y = 100 + arc4random_uniform(self.view.frame.size.height-100);
    self.cloud1.y = kCloudY;

    //tempRect = self.cloud1.frame;

    //[UIView animateWithDuration:kCloudDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
    [UIView animateWithDuration:kCloudDuration delay:0.0 options:0 animations:^{
        self.cloud1.x += self.view.width + kCloudWidth*2;
    } completion:^(BOOL finished){
        //Log(@"cloud done");
    }];
#endif
}


-(void)showSocialMessage
{
    //self.socialMessage.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2f];

    if(![kHelpers checkOnline])
    {
        return;
    }

    if(self.socialButton.hidden)
        return;


    [kAppDelegate animateControl:self.socialButton];


    CGRect tempRect = self.socialMessage.frame;
    tempRect.size.width = 60;
    tempRect.size.height = 20;
    tempRect.origin.y = self.socialButton.frame.origin.y - 24;
    tempRect.origin.x = self.socialButton.frame.origin.x + self.socialButton.frame.size.width/2 - tempRect.size.width/2;
    self.socialMessage.frame = tempRect;

    self.socialMessage.hidden = NO;

    //random social
    NSString *message = [@[
                           @"wow",
                           @"cool",
                           //@"bla",
                           @":-)",
                           @"like",
                           @"omg",
                           @"pst",
                           @"hola",
                           @"allo",
                           @"hallo",
                           @"ciao",
                           @"nice",
                           @"hey",
                           @"oh",
                           @"tldr",
                           @"what?",
                           @"...",
                           @"?!",
                           @"lol",
                           @"jk",
                           @"<3",
                           @"yo",
                           @"o rly?",
                           //@"uh oh",


                          ]randomObject];
    self.socialMessage.text = message;

    self.socialMessage.alpha = 0.0f;
    [self.socialMessage.layer removeAllAnimations];

    [UIView animateWithDuration:0.1f
                     animations:^{
                         self.socialMessage.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:1.0f
                                          animations:^{
                                              self.socialMessage.alpha = 0.0f;

                                              CGRect tempRect2 = tempRect;
                                              tempRect2.origin.y -= 20;
                                              self.socialMessage.frame = tempRect2;

                                          }
                                          completion:^(BOOL finished){
                                              self.socialMessage.hidden = YES;
                                          }];
                     }];

}

-(void)showBlockMessage
{
    //self.blockMessage1.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2f];

    CGFloat xValue = 50.0f;
    CGFloat xOffset = -xValue + arc4random_uniform(xValue*2);

    CGRect tempRect = self.blockMessage1.frame;
    tempRect.size.width = 60;
    tempRect.size.height = 20;
//    tempRect.origin.y = self.carousel.frame.origin.y -6;
//    tempRect.origin.x = self.carousel.frame.origin.x + self.carousel.frame.size.width/2 - tempRect.size.width/2 + xOffset;
    tempRect.origin.y = self.logo.frame.origin.y + 0;
    tempRect.origin.x = self.logo.frame.origin.x + self.logo.frame.size.width/2 - tempRect.size.width/2 + xOffset;
    self.blockMessage1.frame = tempRect;

    self.blockMessage1.hidden = NO;

    //random social
    NSString *message = [@[
                           @"+1",
                           ]randomObject];
    self.blockMessage1.text = message;

    self.blockMessage1.alpha = 0.0f;
    [self.blockMessage1.layer removeAllAnimations];

    self.blockMessage1.alpha = 0.6f;

    [UIView animateWithDuration:0.8f
                     animations:^{
                         self.blockMessage1.alpha = 0.0f;

                         CGRect tempRect2 = tempRect;
                         tempRect2.origin.y -= 8;
                         self.blockMessage1.frame = tempRect2;
                     }
                     completion:^(BOOL finished){
                         self.blockMessage1.hidden = YES;
                     }];


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


#pragma mark -
#pragma mark iCarousel methods

-(int)numItemsInCarousel {

    int numEnabled = 0;
    for(int i = 0; i<kNumSkins; i++) {

        if([kAppDelegate isBlockEnabledIndex:i] && [kAppDelegate isBlockRemoteEnabledIndex:i])
            numEnabled++;

    }

    int num = kNumSkins;

    if(numEnabled > 1)
        num++; //random

    return num;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    int num = [self numItemsInCarousel];

    return num;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //UILabel *label = nil;

    //create new view if no view is available for recycling
    if (view == nil || YES) //force no reuse
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
    }
    else
    {
        //get a reference to the label in the recycled view
        //label = (UILabel *)[view viewWithTag:1];
    }

    //reset anim
    [(UIImageView *)view stopAnimating];

    UIImage *blockImage = nil;
    float alpha = 1.0f;

    BOOL isRandomVisible =  [self isRandomVisible];

    if(index == 0) {
        //Log(@"break");
    }

    if(isRandomVisible)
        index--;


    BOOL premiumSkin =(index == kCoinTypeMario);
    //BOOL lastSkin = (index == kCoinTypeBrain);
    BOOL followSkin = (index == kCoinTypeEmoji);
    BOOL shareSkin = (index == kCoinTypeFlap);
    BOOL rateSkin = (index == kCoinTypePew);
    if(kAppDelegate.inReview)
        rateSkin = NO;

    //BOOL secretSkin = (index == kCoinTypeMario2);
    BOOL videoSkin = (index == kCoinTypeZelda);
    BOOL comingSoon = (index == kCoinTypeComingSoon);

    int badgeTag = 345;

    //random
    if(index == -1 && !isRandomVisible) {
        NSMutableArray *allImages = [NSMutableArray array];

        //fill with alpha x/10
        float minAlpha = 7;
        float maxAlpha = 10;

        [allImages removeAllObjects];

        NSString *imageName = @"premium7.png";  //premium6
        for(int i=minAlpha;i<=maxAlpha;i++) {
            UIImage *tempImage = [UIImage imageNamed:imageName];

            tempImage = [kHelpers imageWithAlpha:tempImage alpha:i*0.1f];

            //scale
            //CGSize imageSize = tempImage.size;

            if(i == maxAlpha) {
                //add a few more
                for(int j=0;j<=2;j++) {
                    [allImages addObject:tempImage];
                    Log(@"i: %d", i);

                }
            }
            [allImages addObject:tempImage];

            Log(@"i: %d", i);
        }
        for(int i = maxAlpha-1;i >= minAlpha;i--) {
            //reverse
            UIImage *tempImage = [UIImage imageNamed:imageName];
            tempImage = [kHelpers imageWithAlpha:tempImage alpha:i*0.1f];

            //scale
            //CGSize imageSize = tempImage.size;

            [allImages addObject:tempImage];

            Log(@"i: %d", i);

        }


        float animSpeed = allImages.count * 0.08f; //0.15f
        UIImageView *imageView = ((UIImageView *)view);
        imageView.animationImages = allImages;
        imageView.animationDuration = animSpeed;
        [imageView startAnimating];

        return view;

    }
    else if(index == -1 && isRandomVisible) {

        view.alpha = alpha;
        view.contentMode = UIViewContentModeScaleAspectFit; //UIViewContentModeCenter;

        if(self.animateRandom) {
            //random
            NSMutableArray *allImages = [NSMutableArray array];

            for(int i = 0; i<kNumSkins; i++) {

               if(![kAppDelegate isBlockEnabledIndex:i] || ![kAppDelegate isBlockRemoteEnabledIndex:i])
                   continue; //skip
                if(i == kCoinTypeMario2 || i == kCoinTypeComingSoon)
                    continue;

                UIImage *tempImage = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:i]];

                //force, for screenshots
                if([kHelpers isDebug])
                {
                    //tempImage = [UIImage imageNamed:@"block10Frame1"];
                }

                UIImage *overlay = [UIImage imageNamed:@"store_icon_random_overlay"];
                tempImage = [UIImage mergeImage:tempImage withImage:overlay];

                [allImages addObject:tempImage];
            }

            float animSpeed = allImages.count * kTitleRandomAnimationSpeed;
            ((UIImageView *)view).animationImages = allImages;
            ((UIImageView *)view).animationDuration = animSpeed;
            [(UIImageView *)view startAnimating];

        }
        else {
            //just get new current
            blockImage = [CBSkinManager getBlockImage];
            UIImage *overlay = [UIImage imageNamed:@"store_icon_random_overlay"];
            blockImage = [UIImage mergeImage:blockImage withImage:overlay];

            ((UIImageView *)view).image = blockImage;
        }


        return view;
    }
    else if([kAppDelegate isBlockEnabledIndex:(int)index] && [kAppDelegate isBlockRemoteEnabledIndex:(int)index] ) {
        //regular
        blockImage = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:(int)index]];
    }
    else {
        if([kAppDelegate isBlockSpecial:(int)index] || ![kAppDelegate isBlockRemoteEnabledIndex:(int)index]) {
            //always hide
            blockImage = [UIImage imageNamed:@"store_icon_locked"];
            alpha = kBlockLockedAlpha;

        }
        else {
            //disabled
            blockImage = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:(int)index]];

            //black
            blockImage = [kHelpers getBlackImage:blockImage];

            UIImage *overlay = nil;

            if(rateSkin)
                overlay = [UIImage imageNamed:@"store_icon_locked_overlay_rate"];
            else if(shareSkin)
                overlay = [UIImage imageNamed:@"store_icon_locked_overlay_share"];
            else if(followSkin)
                overlay = [UIImage imageNamed:@"store_icon_locked_overlay_follow"];
            else if(premiumSkin)
                overlay = [UIImage imageNamed:@"store_icon_locked_overlay_vip"];
            else if(videoSkin)
                overlay = [UIImage imageNamed:@"store_icon_locked_overlay_video"];
            else if(comingSoon)
                overlay= nil;
            else
                overlay= [UIImage imageNamed:@"store_icon_locked_overlay"];



			blockImage = [UIImage mergeImage:blockImage withImage:overlay];

            alpha = kBlockLockedAlpha;

        }
    }

    ((UIImageView *)view).image = blockImage;
    view.alpha = alpha;
    view.contentMode = UIViewContentModeScaleAspectFit; //UIViewContentModeCenter;


    BOOL isNew = [[kAppDelegate.dicSkinNew safeObjectForKey:[CBSkinManager getSkinKey:(int)index]] boolValue];
    if(index >= 0 && isNew && [kAppDelegate isBlockRemoteEnabledIndex:(int)index]) {

        int size = 30;
        int offset = 15;
        UIImageView *badgeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"badge2"]];
        badgeImage.x = view.frame.size.width - size/2 - offset;
        badgeImage.tag = badgeTag;
        [view addSubview:badgeImage];

#if 0
        offset = 3;
        //UILabel *lb_badgeValue = [[UILabel alloc] initWithFrame: CGRectMake(view.frame.size.width - size/2 - offset, -size/2 + offset, size,size)];
        //UILabel *lb_badgeValue = [[UILabel alloc] initWithFrame: CGRectMake(0,-offset, size,size)];
        UILabel *lb_badgeValue = [[UILabel alloc] initWithFrame: CGRectMake(badgeImage.x+0, -offset, size,size)];
        lb_badgeValue.textAlignment = NSTextAlignmentCenter;
        lb_badgeValue.textColor = [UIColor whiteColor];
        lb_badgeValue.backgroundColor = [UIColor clearColor];
        lb_badgeValue.layer.masksToBounds = YES;
        //lb_badgeValue.layer.cornerRadius = size/2.0f;

        lb_badgeValue.font = [UIFont fontWithName:kFontName size:22];

        lb_badgeValue.text = @""; //@"!";
        lb_badgeValue.tag = badgeTag;
        [view addSubview:lb_badgeValue];
#endif

    }


    return view;
}

-(BOOL)isRandomVisible {

    int numEnabled = 0;
    for(int i = 0; i<kNumSkins; i++) {

        if([kAppDelegate isBlockEnabledIndex:i] && [kAppDelegate isBlockRemoteEnabledIndex:i])
            numEnabled++;

    }

    if(numEnabled <= 1)
        return NO;

    if ([self numItemsInCarousel] == (kNumSkins+1))
        return YES;

    return NO;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionSpacing:
            //return value * 1.1;
            return value * 1.3;
            break;

        case iCarouselOptionShowBackfaces:
            return NO;
            break;

        case iCarouselOptionWrap:
            return NO; //YES;
            break;

        /*case iCarouselOptionRadius:
            return 1;
            break;

        case iCarouselOptionVisibleItems:
            return 1;
            break;*/

        /*case iCarouselOptionFadeMin:
        case iCarouselOptionFadeMax:
            return 0;
            break;
        case iCarouselOptionFadeRange:
            return 2;
            break;
        case iCarouselOptionFadeMinAlpha:
            return 0.0f;
            break;*/

        case iCarouselOptionFadeMin:
            return -0.8f; //-0.5; //-1
        case iCarouselOptionFadeMax:
            return 0.8; //0.5; //1
            break;
        case iCarouselOptionFadeRange:
            return 0.75f; //1;
            break;
        case iCarouselOptionFadeMinAlpha:
            return 0.01f;
            break;


        default:
            return value;
            break;
    }

    return value;
}

- (BOOL)carousel:(iCarousel *)carousel shouldSelectItemAtIndex:(NSInteger)index {
    return YES;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    int index = (int)carousel.currentItemIndex;

    [kHelpers haptic1];

    BOOL isRandomVisible = [self isRandomVisible];
    if(isRandomVisible)
        index--;

    BOOL enabled  = [kAppDelegate isBlockEnabledIndex:index];

    //hide hand on coming soon? but buggy with y position
    BOOL comingSoon = (index == kCoinTypeComingSoon);
    if(comingSoon)
        [self hideArrow];
    else
        [self showArrow];

    //mark as read, when viewed and new, also reload
    if(index > 0 && enabled)
    {
        BOOL isNew = [[kAppDelegate.dicSkinNew safeObjectForKey:[CBSkinManager getSkinKey:(int)index]] boolValue];
        if(isNew)
            {
            [kAppDelegate.dicSkinNew setObject:@(NO)forKey:[CBSkinManager getSkinKey:index]];
            [self updateBadges];
            //[self.carousel reloadData];
        }
    }

    [self resetTimerStory];

    [self updateSkinName];
    [self updateArrowImage];

    //twitter verified
    self.verified.hidden = YES;
    if(index == kCoinTypePew && enabled) {

        NSDateComponents *component = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:[NSDate date]];
        switch([component weekday]) {
            case DAY_MONDAY:
            case DAY_WEDNESDAY:
            case DAY_FRIDAY:
            case DAY_SUNDAY:
                self.verified.hidden = YES; //NO;
                self.verified.image = [UIImage imageNamed:@"verified2"];
                break;

            case DAY_TUESDAY:
            case DAY_THURSDAY:
            case DAY_SATURDAY:
                self.verified.hidden = YES; //NO;
                self.verified.image = [UIImage imageNamed:@"verified"];
                break;

            default:
                break;
        }
    }

    //change start
    self.startText = [kAppDelegate getRandomStart:index];
    //[self updateResumeFont];

    /*if(!enabled) {
        self.startText = @"Unlock";
    }*/

    //sound
    if(self.didAppear) {
        float secs = 0.0f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
           [self.soundCard play];
        });
    }

    //stop previous confeti
    //[self stopConfetti];

    //only save if enabled
    if(enabled) {
        [kAppDelegate setSkin:index];

        //today
        //[kAppDelegate saveBlockImage];

        //mark as read
        //[kAppDelegate.arraySkinNew replaceObjectAtIndex:index withObject:@NO];
        //[self.carousel reloadData];

        [kAppDelegate saveState];

        [self updateBackground:NO];
    }
    else {
        if(index == -1 && !isRandomVisible) {
            //premium
            [self updateBackground:NO];

            [self startConfetti];
            float secs = 0.5f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self stopConfetti];
            });

        }
        else if(index == -1) { //first, random

            [self updateBackgroundRandom];
        }
        else
            [self updateBackground:YES];
    }

    //random?
    /*if(self.isRandoming) {
        self.isRandoming = NO;

        float secs = 0.3f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //[kAppDelegate stopAllSounds];
            [self resumeButtonPressed:carousel];
        });
    }*/

}

- (void)carouselWillBeginDragging:(iCarousel *)carousel {
    //reset random
    kAppDelegate.isRandomSkin = NO;
    [kAppDelegate saveState];

    //[self hideArrow];
    //[self updateArrowImage];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate {
    //reset random
    kAppDelegate.isRandomSkin = NO;
    [kAppDelegate saveState];

    //[self updateArrowImage];

    [self resetTimerStory];
}

/*- (void)carouselDidEndDecelerating:(iCarousel *)carousel {
    //random?
    if(self.isRandoming) {
         self.isRandoming = NO;

         float secs = 0.3f;
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
         //[kAppDelegate stopAllSounds];
         [self resumeButtonPressed:carousel];
         });
     }
}*/

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {

    [self resetTimerStory];

    [self hideArrow];

    //just bring forward
    if(carousel.currentItemIndex != index) {
        [kAppDelegate playSound:kClickSound];
        return;
    }

    BOOL isRandomVisible = [self isRandomVisible];
    if(isRandomVisible)
        index--;

    BOOL random = (index == -1);

    //random
    if(isRandomVisible && random) {
        //random
        //[kAppDelegate playSound:kClickSound];
        [self resumeButtonPressed:carousel];
        return;
    }

    int newSelected = (int)index;

    [kAppDelegate setSkin:newSelected];

    [kAppDelegate saveState];

    //notif, sound changed
    [kAppDelegate setupNotifications];

    //start
    [self resumeButtonPressed:carousel];
}


-(void)stopAllSounds
{
    float volume = 0;

    for(FISound *sound in self.soundArray) {
        sound.gain = volume;
    }
}

-(void)setSoundVolume
{
    float volume = kAppDelegate.soundVolume;

    for(FISound *sound in self.soundArray) {
        sound.gain = volume;
    }
}

-(void)updateParseStats:(NSTimer *)incomingTimer {

    if(![kHelpers checkOnline])
        return;

    //also
    //[kAppDelegate cacheRewardVideos];

    [kAppDelegate dbInitObjects];

    /*if(![kHelpers checkOnline])
        return;

    PFQuery *query = nil;
    query = [PFQuery queryWithClassName:@"stats"];
    [query whereKey:@"key" equalTo:@"coinCount"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objectArray, NSError *error) {

        if (error || !objectArray || objectArray.count == 0) {
            Log(@"parseInitObjects: parseCoinCount error");
            [self updateTitleCount];
        }
        else {
            PFObject *tempParseCoinCount = [objectArray firstObject];
            kAppDelegate.clickCountWorld = [[tempParseCoinCount objectForKey:@"count"] intValue];
            [self updateTitleCount];
        }
    }];*/
}

- (void)updateSkinName {

    self.skinName.hidden = NO;
    self.skinType.hidden = YES; //NO;

    NSString *tempTitle = @"";
    int index = (int)self.carousel.currentItemIndex;
    BOOL isRandomVisible = [self isRandomVisible];
    if(isRandomVisible)
        index--;

    BOOL enabled  = [kAppDelegate isBlockEnabledIndex:index];

    //info button

	if(index == kCoinTypeTA && enabled)
	{
		//show only for TA
		self.infoButton.hidden = NO;
	}
    else
	{
		self.infoButton.hidden = YES;
    }


    NSString *tempType = [CBSkinManager getBlockTypeName:index];
    UIColor *typeColor = [CBSkinManager getBlockTypeColor:index];
    //locked

    tempTitle = [CBSkinManager getBlockDisplayNameIndex:index multiLine:NO];

    BOOL comingSoon = (index == kCoinTypeComingSoon);

    if(!enabled && !comingSoon) {
        tempTitle = @"???";
    }

    //random
    if(index == -1 && isRandomVisible) {
        tempTitle = @"Random";

        tempType = @"";
        self.skinType.hidden = YES;
    }

    if((index == -1 && !isRandomVisible)) {

        NSString *price = [kAppDelegate.iapPrices objectForKey:kIAP_NoAds];

        if(!price)
            tempTitle = @"VIP";
        else
            tempTitle = [NSString stringWithFormat:@"VIP (%@)", price];

        //tempType = @"";
    }


    self.skinName.text = tempTitle;

    self.skinType.text = tempType;
    self.skinType.textColor = typeColor;
}

- (void)updateTitleCount {

    if(![kHelpers checkOnline]) {
        self.parseCountLabel.hidden = YES;
        return;
    }

    if(kAppDelegate.clickCountWorld <= 0.1f) {
        self.parseCountLabel.hidden = YES;
        return;
    }

    self.parseCountLabel.hidden = YES; //NO;

    NSNumber *count = @(floor(kAppDelegate.clickCountWorld));
    NSString *unit = @"";

    BOOL useShort = NO;
    if(useShort) {
        //short
        NSInteger value = 1000;
        NSInteger integerValue = [count integerValue];

        if(integerValue >= value) {
            integerValue = floor(integerValue/value);
            count = @(integerValue);
            unit = @"K";
        }

        value = 1000000;
        integerValue = [count integerValue];
        if(integerValue >= value) {
            integerValue = floor(integerValue/value);
            count = @(integerValue);
            unit = @"M";
        }
    }


    NSString *countString = [NSString localizedStringWithFormat:@"%@", count];
    //NSString *title = [NSString stringWithFormat:@"%@%@ coins served worldwide!", countString, unit];
    NSString *title = [NSString stringWithFormat:@"Global Coins collected %@%@ ", countString, unit];

    //Log(@"%@", title);

    self.parseCountLabel.text = title;

}

-(void)updateBackgroundRandom {
    //bg random
    /*assert(self.allBGImages);
    float animSpeed = self.allBGImages.count * kTitleRandomAnimationSpeed * 3;
    [self.backgroundImageView.layer removeAllAnimations];
    self.backgroundImageView.animationImages = self.allBGImages;
    self.backgroundImageView.animationDuration = animSpeed;
    [self.backgroundImageView startAnimating];*/


    self.randomBackgroundIndex = 0;

    [self.timerBg invalidate];
    self.timerBg = nil;

    float interval = kTitleRandomAnimationSpeed * 3;
    self.timerBg = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionUpdateBackgroundRandom:) userInfo:@"actionUpdateBackgroundRandom" repeats:YES];

    //call now
    [self actionUpdateBackgroundRandom:nil];
}

-(void)actionUpdateBackgroundRandom:(NSTimer *)incomingTimer {

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        return;


    [self.backgroundImageView.layer removeAllAnimations];

    [UIView transitionWithView:self.backgroundImageView
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.randomBackgroundIndex++;
                        if(self.randomBackgroundIndex >= self.allBGImages.count)
                            self.randomBackgroundIndex = 0;
                        self.backgroundImageView.image = [self.allBGImages objectAtIndex:self.randomBackgroundIndex];

                        //force, for screenshots
                        if([kHelpers isDebug])
                        {
                            //self.backgroundImageView.image = [UIImage imageNamed:@"background1"];
                        }

                        //self.backgroundImageView.image = [self.allBGImages randomObject];
                    } completion:nil];
}


-(void)updateBackground:(BOOL)force{

    //stretch
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
//    UIViewContentModeScaleToFill,
//    UIViewContentModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
//    UIViewContentModeScaleAspectFill,     // contents scaled to fill with fixed aspect. some portion of content may be clipped.

    [self.timerBg invalidate];
    self.timerBg = nil;

    //force
    //self.backgroundImageView.image = [UIImage imageNamed:@"background34"];
    //return;

    [self.backgroundImageView.layer removeAllAnimations];

    [UIView transitionWithView:self.backgroundImageView
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        //background, themed
                        UIImage *newBG = nil;
                        if([CBSkinManager getSkinBackground] && !force)
                            newBG = [UIImage imageNamed:[CBSkinManager getSkinBackground]];
                        else
                            newBG = [UIImage imageNamed:@"background1"];

                        if(force) {
                             newBG = [kHelpers getGrayImage:newBG];
                        }
                        self.backgroundImageView.image = newBG;

                    } completion:nil];

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

//shouldShowChest
-(BOOL)chestReady
{
    //force
    if([kHelpers isDebug])
    {
        //return YES;
    }

    if(kAppDelegate.level < kChestLevel)
        return NO;

    //1st time
    if(!kAppDelegate.chestDate)
        kAppDelegate.chestDate = [NSDate date];

    NSTimeInterval intervalNeeded = kChestIntervalNeeded;
    if([kAppDelegate isPremium])
        intervalNeeded /= 2;

    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:kAppDelegate.chestDate];
    if((interval > intervalNeeded))
        return YES;

    return NO;
}

-(void)updateChest
{
    if([self chestReady])
        [self showChest];
    else
	 	[self hideChest];
}

- (IBAction)actionDownload:(id)sender
{
    [kAppDelegate playSound:kClickSound];

    [self enableButtons:NO];

    [kAppDelegate animateControl:self.downloadButton];

    //hide badge
    //self.downloadBadge.hidden = YES;

    //alert?

    __weak typeof(self) weakSelf = self;

    [kAppDelegate playSound:kClickSound];

    [self enableButtons:NO];

    NSString *title = @"New Version";
    NSString *message = @"A new version of <color1>Coiny Block</color1> is now available on the <color1>App Store</color1>!";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:title
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:@"Update" //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           //
                                           [kAppDelegate playSound:kClickSound];


                                           //app store url
                                           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreURL] options:@{} completionHandler:nil];

                                       }];

    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

        [weakSelf showVCR:NO animated:YES];

        [weakSelf enableButtons:YES];


    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing

        [weakSelf enableButtons:YES];

    }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];


    [self showVCR:YES animated:YES];

}

-(BOOL)downloadAvailable
{
    NSString* currentVersionLocalString = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; //098
    float currentVersionLocal =  [currentVersionLocalString floatValue];

    return ([kHelpers checkOnline] &&
            kAppDelegate.currentVersion > 0.0f &&
            kAppDelegate.currentVersion > currentVersionLocal);
}

-(void)updateDownload
{
    [self.multImage.layer removeAllAnimations];
    [self.multImage.layer removeAllAnimations];

    //scale badge
    CABasicAnimation *scale2;
    scale2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale2.fromValue = [NSNumber numberWithFloat:1.0];
    scale2.toValue = [NSNumber numberWithFloat:0.8f];
    scale2.duration = 0.3f;
    scale2.repeatCount = HUGE_VALF;
    scale2.autoreverses = YES;
    [self.downloadBadge.layer removeAllAnimations];
    [self.downloadBadge.layer addAnimation:scale2 forKey:@"scale"];

    BOOL show = NO;
    //show version
    if([self downloadAvailable])
    {
        show = YES;
    }

    //force
    //show = YES;

    self.downloadButton.hidden = !show;
    self.downloadBadge.hidden = !show;
}

-(void)updateMult
{
    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self showMult];
    });

   // else
   ///     [self hideChest];
}

-(void)showChest
{
    self.chestImage.image = [UIImage imageNamed:@"chest2"];
    //animate chest
    self.chestImage.animationImages = @[[UIImage imageNamed:@"chest2"], [UIImage imageNamed:@"chest3"]];
    self.chestImage.animationDuration = 0.3f;
    self.chestImage.animationRepeatCount = 0;
    [self.chestImage startAnimating];

    self.chestButton.hidden = self.chestLabel.hidden = self.chestImage.hidden = self.chestShine.hidden = self.chestBadge.hidden = NO;

    CABasicAnimation *scale2;
    scale2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale2.fromValue = [NSNumber numberWithFloat:1.0];
    scale2.toValue = [NSNumber numberWithFloat:0.8f];
    scale2.duration = 0.3f;
    scale2.repeatCount = HUGE_VALF;
    scale2.autoreverses = YES;
    [self.chestBadge.layer removeAllAnimations];
    [self.chestBadge.layer addAnimation:scale2 forKey:@"scale"];

    self.chestBadge.image = [UIImage imageNamed:@"badge2"]; //@"premiumBadge2";
}


-(void)hideChest
{
    self.chestButton.hidden = self.chestLabel.hidden = self.chestImage.hidden = self.chestShine.hidden = self.chestBadge.hidden =YES;
}

-(void)showMult
{
    if(kAppDelegate.level <= 1)
       [self hideMult];

    int newRainbow = kAppDelegate.rainbowCount;

    if(newRainbow > 0)
    {
        self.multImage.alpha = 1.0f;
        self.multShine.alpha = 1.0f;
    }
    else
    {
        self.multImage.alpha = 0.3f;
        self.multShine.alpha = 0.4f;
    }

    [self.multImage.layer removeAllAnimations];

    //self.multImage.image = [UIImage imageNamed:@"coin2Frame1"];

    //animate mult
    UIImage *whiteImage = [UIImage imageNamed:@"coin2Frame1"];
    NSMutableArray *images = [NSMutableArray array];

    NSArray *colorArray = @[
                            [UIColor whiteColor],
                            [UIColor colorWithHex:0xff8000], //orange

                            [UIColor whiteColor],
                            [UIColor blueColor],

                            [UIColor whiteColor],
                            [UIColor colorWithHex:0xfdfd51], //yellow

                            [UIColor whiteColor],
                            [UIColor purpleColor],

                            [UIColor whiteColor],
                            [UIColor greenColor],

                            [UIColor whiteColor],
                            [UIColor redColor],

                            ];


    for(UIColor *color in colorArray)
    {
        UIImage *newImage = [kHelpers colorizeImage:whiteImage color:color];
        [images addObject:newImage];
    }

    self.multImage.animationImages = images;
    self.multImage.animationDuration = images.count * 0.1f;
    self.multImage.animationRepeatCount = 0;
    [self.multImage startAnimating];

    self.multButton.hidden = self.multLabel.hidden = self.multImage.hidden = self.multShine.hidden = self.multBadge.hidden = NO;

    //scale
    float duration = 0.3f;
    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
    scale.fromValue = [NSNumber numberWithFloat:1.0f];
    scale.toValue = [NSNumber numberWithFloat:-1.0]; //0.1f;
    scale.duration = duration * 2;
    scale.repeatCount = HUGE_VALF;
    scale.autoreverses = YES;

    [self.multImage.layer addAnimation:scale forKey:@"multImageRotate"];

    //self.multImage.image = [self.multImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //[self.multImage setTintColor:[UIColor greenColor]];

    CABasicAnimation *scale2;
    scale2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale2.fromValue = [NSNumber numberWithFloat:1.0];
    scale2.toValue = [NSNumber numberWithFloat:0.8f];
    scale2.duration = 0.3f;
    scale2.repeatCount = HUGE_VALF;
    scale2.autoreverses = YES;
    [self.multBadge.layer removeAllAnimations];
    [self.multBadge.layer addAnimation:scale2 forKey:@"scale"];

    self.multBadge.image = [UIImage imageNamed:@"badge2"]; //@"premiumBadge2";

    //self.multLabel.text = @"POW 1.5x";
    //self.multLabel.text = [NSString stringWithFormat:@"%.1fx POW", [kAppDelegate.gameScene getMult]];
    self.multLabel.text = [NSString stringWithFormat:@"%.1fx Power", [kAppDelegate.gameScene getMult]];

    self.multBadge.hidden = (newRainbow <= 0);

}

-(void)hideMult
{
    self.multButton.hidden = self.multLabel.hidden = self.multImage.hidden = self.multShine.hidden = self.multBadge.hidden =YES;
}

-(void)hideArrow {

    if(self.tutoArrow.hidden && self.tutoArrow.alpha < 1.0f)
        return;

    //hide
    //self.tutoArrow.hidden = YES;
    [self.tutoArrow.layer removeAllAnimations];

    [UIView animateWithDuration:kTutoHideDuration delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.tutoArrow.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.tutoArrow.hidden = YES;
    }];
}

-(void)updateArrowImage
{
    //locked
    int index = (int)self.carousel.currentItemIndex;
    BOOL isRandomVisible = [self isRandomVisible];
    if(isRandomVisible)
        index--;

    BOOL enabled  = [kAppDelegate isBlockEnabledIndex:index];
    if(!enabled) {
        index = kCoinTypeDefault;
    }

    //random
    if(index == -1 && isRandomVisible) {
        index = kCoinTypeDefault;
    }

    self.tutoArrow.image = [CBSkinManager getTutoArrowImage:index];
}

-(void)showArrow {

    //move
    self.tutoArrow.x = self.view.width/2 + 0;
    if([kHelpers isIphoneX])
        self.tutoArrow.x -= 30;

    //center it more
    self.tutoArrow.x -= self.tutoArrow.width/2;

    //ipad
    if([kHelpers isIpad])
    {
        self.tutoArrow.x = 150.0f;
    }

    self.tutoArrow.y = self.carousel.y + self.carousel.height/2 + 10;

    if(!self.tutoArrow.hidden)
        return;

    [self updateArrowImage];

    if(kAppDelegate.tutoArrowClickedTitle)
    {
        //[self hideArrow];
        //return;
    }

    [self.tutoArrow.layer removeAllAnimations];

    //update constraints
    //[self.view layoutIfNeeded];
    //[self.tutoArrow removeConstraints:self.tutoArrow.constraints];

    //disable autolayout
    self.tutoArrow.translatesAutoresizingMaskIntoConstraints = YES;

    //show
    self.tutoArrow.hidden = NO;
    self.tutoArrow.alpha = 0.8f;

    //pulse
    //[self.tutoArrow.layer removeAllAnimations];


    /*POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
     scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
     scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.5f, 0.5f)];
     //scaleAnimation.springBounciness = 0.f;
     scaleAnimation.autoreverses = YES;
     //scaleAnimation.repeatCount=HUGE_VALF;
     scaleAnimation.repeatForever = YES;
     [self.tutoArrow pop_addAnimation:scaleAnimation forKey:@"scale"];
     */

    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSNumber numberWithFloat:1.0f];
    //scale.toValue = [NSNumber numberWithFloat:-M_PI*2];
    scale.toValue = [NSNumber numberWithFloat:0.8f];
    scale.duration = 0.2f;
    scale.repeatCount = HUGE_VALF;
    scale.autoreverses = YES;

    [self.tutoArrow.layer addAnimation:scale forKey:@"scale"];
}

-(void)setNumHearts:(int)many{

    NSDate * date = [kAppDelegate.healStartDate dateByAddingTimeInterval:[CBSkinManager getHeartHealTime]];

    //float heartHealTime = [CBSkinManager getHeartHealTime]/60.0f;

    //int seconds = (int)[[NSDate date] timeIntervalSinceDate:kAppDelegate.healStartDate];
    int seconds = ((int)([date timeIntervalSinceNow]));
    //float heartHealTime = [CBSkinManager getHeartHealTime];
    int minutes = floorf(seconds/60.0f);
    seconds -= minutes * 60;

    if(seconds < 0 || minutes < 0) {
        seconds = minutes = 0;
    }

    self.timerLabel.text = [NSString stringWithFormat:@"%dm %ds", minutes, seconds];
    //Log(@"setNumHearts: %@", self.timerLabel.text);
    self.timerLabel.hidden = (many == kHeartFull);
    //self.timerLabel.hidden = (many == kHeartFull) || (seconds <= 0.0f) || (minutes <= 0.0f) || !kAppDelegate.healStartDate;
    //self.timerLabel.hidden = (many > 0);
    self.timerLabel.hidden = YES;

    //self.heartButton.enabled = !self.timerLabel.hidden;
    self.heartButton.enabled = YES; //!self.timerLabel.hidden;

    //hearts
    self.heart1.hidden = NO;
    self.heart2.hidden = NO;
    self.heart3.hidden = NO;
    self.heart4.hidden = NO;

    self.heart1.alpha = 0.8f;
    self.heart2.alpha = 0.8f;
    self.heart3.alpha = 0.8f;
    self.heart4.alpha = 0.8f;

    switch(many) {
        case 0:
            [self.heart1 setImage:[UIImage imageNamed:@"heart_empty"]];
            [self.heart2 setImage:[UIImage imageNamed:@"heart_empty"]];
            [self.heart3 setImage:[UIImage imageNamed:@"heart_empty"]];
			if([kAppDelegate isPremium])
				[self.heart4 setImage:[UIImage imageNamed:@"heart_empty"]];
			else
				[self.heart4 setImage:[UIImage imageNamed:@"heart_outline"]];
            break;

        case 1:
            [self.heart1 setImage:[UIImage imageNamed:@"heart_half"]];
            [self.heart2 setImage:[UIImage imageNamed:@"heart_empty"]];
            [self.heart3 setImage:[UIImage imageNamed:@"heart_empty"]];
			if([kAppDelegate isPremium])
				[self.heart4 setImage:[UIImage imageNamed:@"heart_empty"]];
			else
				[self.heart4 setImage:[UIImage imageNamed:@"heart_outline"]];
            break;

        case 2:
            [self.heart1 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart2 setImage:[UIImage imageNamed:@"heart_empty"]];
            [self.heart3 setImage:[UIImage imageNamed:@"heart_empty"]];
			if([kAppDelegate isPremium])
				[self.heart4 setImage:[UIImage imageNamed:@"heart_empty"]];
			else
				[self.heart4 setImage:[UIImage imageNamed:@"heart_outline"]];
            break;

        case 3:
            [self.heart1 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart2 setImage:[UIImage imageNamed:@"heart_half"]];
            [self.heart3 setImage:[UIImage imageNamed:@"heart_empty"]];
			if([kAppDelegate isPremium])
				[self.heart4 setImage:[UIImage imageNamed:@"heart_empty"]];
			else
				[self.heart4 setImage:[UIImage imageNamed:@"heart_outline"]];
            break;

        case 4:
            [self.heart1 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart2 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart3 setImage:[UIImage imageNamed:@"heart_empty"]];
			if([kAppDelegate isPremium])
				[self.heart4 setImage:[UIImage imageNamed:@"heart_empty"]];
			else
				[self.heart4 setImage:[UIImage imageNamed:@"heart_outline"]];
            break;

        case 5:
            [self.heart1 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart2 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart3 setImage:[UIImage imageNamed:@"heart_half"]];
			if([kAppDelegate isPremium])
				[self.heart4 setImage:[UIImage imageNamed:@"heart_empty"]];
			else
				[self.heart4 setImage:[UIImage imageNamed:@"heart_outline"]];
            break;
            break;

        case 6:
            [self.heart1 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart2 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart3 setImage:[UIImage imageNamed:@"heart_full"]];
			if([kAppDelegate isPremium])
				[self.heart4 setImage:[UIImage imageNamed:@"heart_empty"]];
			else
				[self.heart4 setImage:[UIImage imageNamed:@"heart_outline"]];
            break;
            break;

        case 7:
            [self.heart1 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart2 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart3 setImage:[UIImage imageNamed:@"heart_full"]];
			[self.heart4 setImage:[UIImage imageNamed:@"heart_half"]];
            break;

        case 8:
            [self.heart1 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart2 setImage:[UIImage imageNamed:@"heart_full"]];
            [self.heart3 setImage:[UIImage imageNamed:@"heart_full"]];
			[self.heart4 setImage:[UIImage imageNamed:@"heart_full"]];
            break;


        default:
            [self.heart1 setImage:[UIImage imageNamed:@"heart_empty"]];
            [self.heart2 setImage:[UIImage imageNamed:@"heart_empty"]];
            [self.heart3 setImage:[UIImage imageNamed:@"heart_empty"]];
			if([kAppDelegate isPremium])
				[self.heart4 setImage:[UIImage imageNamed:@"heart_empty"]];
			else
				[self.heart4 setImage:[UIImage imageNamed:@"heart_outline"]];
            break;
    }
}

-(void)loadSounds {

    if(!self.soundArray)
        self.soundArray = [NSMutableArray array];

    //already loaded
    if([self.soundArray count] > 0)
        return;

    NSError *error = nil;
    //FISoundEngine *engine = [FISoundEngine sharedEngine];
    CBAppDelegate *engine = kAppDelegate;

    NSString *soundName = @"card.caf";
    self.soundCard = [engine soundNamed:soundName maxPolyphony:10 error:&error];
    if (!self.soundCard) {
        Log(@"Failed to load sound: %@", error);
    }
    //crash when launched in bg
    //assert(self.soundCard);
    if(self.soundCard)
        [self.soundArray addObject:self.soundCard];

}

-(void)showFlash:(UIColor*)color {
    [self showFlash:color autoHide:YES];
}

-(void)showFlash:(UIColor*)color autoHide:(BOOL)autoHide{
    //disable
    return;

    //already
    if(!self.flashImage.hidden)
        return;

    float durationFade = 0.15f; //0.15f;
    float durationWait = 0.03; //0.05f;
    float maxAlpha = 1.0f; //0.6f;

    self.flashImage.alpha = 0;
    self.flashImage.hidden = NO;

    //color
    //self.flashImage.backgroundColor = color;
    self.flashImage.backgroundColor = [color colorWithAlphaComponent:0.3f];

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

-(void)showCoins
{
    //disabled
    return;
#if 0
    [self.coinsImage.layer removeAllAnimations];

    //CGRect screenRect = [kHelpers getScreenRect];

    //coins
    CABasicAnimation *translate;
    translate = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    translate.fromValue = [NSNumber numberWithFloat:-100]; //[NSNumber numberWithFloat:-self.coinsImage.frame.size.height /*+ screenRect.size.height*/];

    int distance = 2000;
    translate.toValue = [NSNumber numberWithFloat:distance];

    translate.duration = 100; //60;
    translate.repeatCount = 0;
    [self.coinsImage.layer removeAllAnimations];

    self.coinsImage.y = 0;

    self.coinsImage.hidden = NO;
    [self.coinsImage.layer addAnimation:translate forKey:@"10"];
#endif
}

-(void)stopCoins {
    [self.coinsImage.layer removeAllAnimations];
}

-(void)actionTimerCoins:(NSTimer *)incomingTimer
{
    [self showCoins];
}

@end
