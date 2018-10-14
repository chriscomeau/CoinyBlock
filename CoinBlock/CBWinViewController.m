//
//  CBWinViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBWinViewController.h"
//#import "CBSkinCell.h"
#import "CBConfettiView.h"
#import "UIButton+BadgeValue.h"

@interface CBWinViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *labelSubTitleTop;
@property (nonatomic, strong) IBOutlet UILabel *labelSubTitle;
@property (nonatomic, strong) IBOutlet ZCAnimatedLabel *labelSubTitle2;
@property (nonatomic, strong) IBOutlet UILabel *labelMult;
@property (nonatomic, strong) IBOutlet UILabel *labelBlock;
@property (nonatomic, strong) IBOutlet UILabel *labelBlockName;
@property (nonatomic, strong) IBOutlet UILabel *labelBlockType;
@property (nonatomic, strong) IBOutlet UILabel *comboLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton2;
@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (weak, nonatomic) IBOutlet UIImageView *perfectImage;
@property (nonatomic, strong) IBOutlet UIImageView *shineImageView;
@property (nonatomic, strong) IBOutlet UIImageView *cloud1;
@property (strong, nonatomic) NSTimer *timerCloud;
@property (strong, nonatomic) NSTimer *timerVCR;
@property (strong, nonatomic) NSTimer *timerLabelBlock;
@property (strong, nonatomic) NSTimer *timerCoins;
@property (strong, nonatomic) NSMutableArray *imageArray1;
@property (nonatomic) BOOL alreadyDidAppear;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;
@property (nonatomic, strong) IBOutlet UIImageView *vcr;
@property (weak, nonatomic) IBOutlet UIImageView *coinsImage;
@property (weak, nonatomic) IBOutlet UIImageView *brainImage;
@property (weak, nonatomic) IBOutlet UIImageView *flashImage;
@property (nonatomic) BOOL sharing;
@property (weak, nonatomic) IBOutlet UIImageView *tutoArrow;

@property (nonatomic, strong) IBOutlet UIImageView *chestImage;
@property (nonatomic, strong) IBOutlet UIImageView *poofImage;
@property (nonatomic, strong) IBOutlet UIImageView *poofImage2;
@property (nonatomic, strong) IBOutlet UIImageView *block;
@property (nonatomic, strong) IBOutlet UIImageView *blueBg;
@property (nonatomic, strong) IBOutlet UIButton *blockButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelDescContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelDescContraintTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touch1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touch1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touch2Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touch2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touch3Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *touch3Height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blockWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blockHeight;

@property (nonatomic, strong) IBOutlet UIButton *premiumButton;
@property (nonatomic, strong) IBOutlet UIImageView *premiumBadge;
@property (nonatomic, strong) IBOutlet UIImageView *premiumBack;

//@property (strong, nonatomic) SIAlertView *alertView;

@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;
@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *rateButton;
@property (weak, nonatomic) IBOutlet UIButton *storeButton;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (weak, nonatomic) IBOutlet UIButton *shareButton2;
@property (weak, nonatomic) IBOutlet UIButton *likeButton2;
@property (weak, nonatomic) IBOutlet UIButton *rateButton2;
@property (weak, nonatomic) IBOutlet UIButton *storeButton2;
@property (weak, nonatomic) IBOutlet UIButton *otherButton2;
@property (weak, nonatomic) IBOutlet UIButton *adButton2;

@property (strong, nonatomic) NSTimer *timerPulse;

@property (nonatomic) BOOL boolTimerLabelBlock;
@property (nonatomic) BOOL showPerfect;
@property (nonatomic) BOOL newEnemies;
@property (nonatomic) BOOL newPowerups;
//@property (nonatomic) BOOL continueClicked;
@property (nonatomic) int newSkin;
@property (nonatomic) int randomSkin;
@property (nonatomic) int isCoin;
@property (nonatomic) int isPotion;
@property (nonatomic) int isRainbow;

@property (nonatomic, strong) IBOutlet UIImageView *star1;
@property (nonatomic, strong) IBOutlet UIImageView *star2;
@property (nonatomic, strong) IBOutlet UIImageView *star3;
@property (nonatomic, strong) IBOutlet UIImageView *touch1;
@property (nonatomic, strong) IBOutlet UIImageView *touch2;
@property (nonatomic, strong) IBOutlet UIImageView *touch3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unlockBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blockTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unlockedTopConstraint;

@property (nonatomic, strong) NSMutableArray *miniShineArray;
@property (nonatomic, strong) NSMutableArray *miniCoinArray;

- (IBAction)actionShare:(id)sender;
- (IBAction)actionRate:(id)sender;
- (IBAction)actionStore:(id)sender;
- (IBAction)actionContinue:(id)sender;

- (IBAction)storeButtonPressed:(id)sender;
- (IBAction)otherButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)likeButtonPressed:(id)sender;


- (IBAction)actionBack:(id)sender;

- (IBAction)premiumButtonPressed:(id)sender;

@end

#define kTitleSpacingAfter 20
#define kTitleSpacingBefore 130

@implementation CBWinViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [kAppDelegate scaleView:self.view];

    [kHelpers loopInBackground];

    [self setupFade];
    [self bringSubviewsToFront];

    //perfect, disabled
    self.showPerfect = NO;
    self.perfectImage.hidden = YES;

    //flash
    self.flashImage.image = nil;
    self.flashImage.alpha = 0.0f;
    self.flashImage.hidden = YES;
    self.continueButton.alpha = 0;

    [self setupMiniShines];

    //corner
    [kAppDelegate cornerView:self.view];

    [UIView setAnimationsEnabled:NO];

    self.backgroundImageView.image = [UIImage imageNamed:@"background_levelup"];

    //kAppDelegate.storeController = self;

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;
    self.cloud1.image = [UIImage imageNamed:kCloudName];

    self.alreadyDidAppear = NO;

    //dark
    self.darkImage.alpha = 0;

    //rays
    self.shineImageView.alpha = 0.2f;

    [self setupConfetti];
    [self setupWhiteBar];

    //labels
    self.titleLabel.textColor = kYellowTextColor;
    //disabled
    //self.titleLabel.hidden = YES;

    //title
    self.labelSubTitle.textColor = [UIColor whiteColor]; //[UIColor colorWithHex:0xaaaaaa]; //RGB(240,240,240);
    self.labelSubTitle.font = [UIFont fontWithName:kFontName size:14*kFontScale];
    self.labelSubTitle.hidden = NO;
    self.labelSubTitle.alpha = 0.9f;
    self.labelSubTitle.numberOfLines = 0;


    self.labelSubTitle2 = [[ZCAnimatedLabel alloc] initWithFrame:self.labelSubTitle.frame];
    [self.view addSubview:self.labelSubTitle2];

    self.labelSubTitle.hidden = NO;
    self.labelSubTitle2.hidden = YES;


    self.labelSubTitleTop.textColor = [UIColor whiteColor];
    self.labelSubTitleTop.font = [UIFont fontWithName:kFontName size:18*kFontScale];
    self.labelSubTitleTop.hidden = NO;
    self.labelSubTitleTop.alpha = 0.9f;
    self.labelSubTitleTop.numberOfLines = 0;
    self.labelSubTitleTop.text = @"";//[kAppDelegate getRandomWinMessage];



    self.labelMult.font = [UIFont fontWithName:kFontName size:16*kFontScale]; //20
    self.labelMult.textColor = [UIColor orangeColor];

    self.labelBlock.font = [UIFont fontWithName:kFontName size:18*kFontScale]; //20
    self.labelBlock.textColor = [UIColor orangeColor] ; //kYellowTextColor;

    self.labelBlockName.font = [UIFont fontWithName:kFontName size:16*kFontScale]; //20
    self.labelBlockName.textColor = [UIColor orangeColor] ; //kYellowTextColor;

    self.comboLabel.font = [UIFont fontWithName:@"OrangeKid-Regular" size:20];
    self.comboLabel.textAlignment = NSTextAlignmentCenter;
    self.comboLabel.textColor = [UIColor whiteColor];
    self.comboLabel.alpha = 0.8f;
    self.comboLabel.hidden = NO;

    //shadow
    int shadowOffset = 2;
    UIColor *shadowColor = kTextShadowColor;

    self.comboLabel.clipsToBounds = NO;
    self.comboLabel.layer.shadowColor = shadowColor.CGColor;
    self.comboLabel.layer.shadowOpacity = 0.6f;
    self.comboLabel.layer.shadowRadius = 0.0f;
    self.comboLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.comboLabel.layer.masksToBounds = NO;

    if(kVCRAnimEnabled) {
        self.vcr.animationImages = @[[UIImage imageNamed:@"vcr"], [UIImage imageNamed:@"vcr2"]];
        self.vcr.animationDuration = kVCRAnimDuration;
        self.vcr.animationRepeatCount = 0;
    }

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

    self.labelMult.shadowColor = shadowColor;
    self.labelMult.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.labelBlock.shadowColor = shadowColor;
    self.labelBlock.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    self.labelBlockName.shadowColor = shadowColor;
    self.labelBlockName.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);


    UIColor* defaultColor = RGB(180,180,180); //[UIColor whiteColor];
    //UIColor* cancelColor = [UIColor colorWithHex:0xff7900];
    UIColor* continueColor = [UIColor colorWithHex:0x12c312];

    //buttons
    self.shareButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.rateButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];
    self.storeButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];

    self.continueButton.titleLabel.font = [UIFont fontWithName:kFontName size:15*kFontScale];

    //play symbol
    [self.continueButton setTitle:@"Continue" forState:UIControlStateNormal];


    float inset = 6.0f;
    [self.shareButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    //[self.shareButton setTintColor:kYellowTextColor];
    [self.shareButton setTitleColor:[defaultColor colorWithAlphaComponent:1.0f] forState:UIControlStateNormal];

    [self.rateButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    //[self.rateButton setTintColor:kYellowTextColor];
    [self.rateButton setTitleColor:[defaultColor colorWithAlphaComponent:1.0f] forState:UIControlStateNormal];

    [self.storeButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    //[self.storeButton setTintColor:kYellowTextColor];
    [self.storeButton setTitleColor:[defaultColor colorWithAlphaComponent:1.0f] forState:UIControlStateNormal];

    [self.continueButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    //[self.continueButton setTitleColor:[continueColor colorWithAlphaComponent:1.0f] forState:UIControlStateNormal];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];


    /*[[SIAlertView appearance] setButtonColor:RGB(180,180,180)]; //[UIColor whiteColor]
    //cancel
    [[SIAlertView appearance] setCancelButtonColor:[UIColor colorWithHex:0xff7900]]; //[UIColor orangeColor]
    //ok:
    //[[SIAlertView appearance] setDestructiveButtonColor:[UIColor colorWithHex:0x019201]]; //[UIColor green]
    [[SIAlertView appearance] setDestructiveButtonColor:[UIColor colorWithHex:0x12c312]]; //[UIColor green]
     */

    int buttonCornerRadius = 10;
    int buttonBorderWidth = 2;
    //UIColor *buttonColor = RGBA(0,0,0, 0.3f); //RGBA(255,255,255, 0.1f);
    //UIColor *borderColor = kYellowTextColor;

    CALayer * l = nil;

    //reset
    self.shareButton.clipsToBounds = NO;
    self.shareButton.titleLabel.clipsToBounds = NO;
    self.shareButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.shareButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.shareButton.titleLabel.layer.shadowRadius = 0.0f;
    self.shareButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.shareButton.titleLabel.layer.masksToBounds = NO;
    self.shareButton.backgroundColor = [defaultColor colorWithAlphaComponent:0.1f];

    self.rateButton.clipsToBounds = NO;
    self.rateButton.titleLabel.clipsToBounds = NO;
    self.rateButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.rateButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.rateButton.titleLabel.layer.shadowRadius = 0.0f;
    self.rateButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.rateButton.titleLabel.layer.masksToBounds = NO;
    self.rateButton.backgroundColor = [defaultColor colorWithAlphaComponent:0.1f];

    self.storeButton.clipsToBounds = NO;
    self.storeButton.titleLabel.clipsToBounds = NO;
    self.storeButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.storeButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.storeButton.titleLabel.layer.shadowRadius = 0.0f;
    self.storeButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.storeButton.titleLabel.layer.masksToBounds = NO;
    self.storeButton.backgroundColor = [defaultColor colorWithAlphaComponent:0.1f];

    self.continueButton.clipsToBounds = NO;
    self.continueButton.titleLabel.clipsToBounds = NO;
    self.continueButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.continueButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.continueButton.titleLabel.layer.shadowRadius = 0.0f;
    self.continueButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.continueButton.titleLabel.layer.masksToBounds = NO;
    self.continueButton.backgroundColor = [continueColor colorWithAlphaComponent:0.6f];

    l = [self.shareButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[[defaultColor colorWithAlphaComponent:0.6f] CGColor]];

    l = [self.rateButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[[defaultColor colorWithAlphaComponent:0.6f] CGColor]];

    l = [self.storeButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[[defaultColor colorWithAlphaComponent:0.6f] CGColor]];

    l = [self.continueButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[[continueColor colorWithAlphaComponent:0.6f] CGColor]];

    //spacing
    NSString *tempTitle = nil;
    NSMutableAttributedString *attributedString = nil;
    float spacing = 2.0f;

    tempTitle = self.shareButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.shareButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.rateButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.rateButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.storeButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.storeButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.continueButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.continueButton setAttributedTitle:attributedString forState:UIControlStateNormal];



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

    if([kHelpers isIpad])
    {
        //ipad iphone 4
        self.titleTopConstraint.constant = -10;
        self.unlockBottomConstraint.constant = 2;
        self.blockTopConstraint.constant = 200;
        self.unlockedTopConstraint.constant = 4;
    }
    else if([kHelpers isIphone4Size])
    {
        //ipad iphone 4
        self.titleTopConstraint.constant = -10;
        self.unlockBottomConstraint.constant = 2;
        self.blockTopConstraint.constant = 210;
        self.unlockedTopConstraint.constant = 4;
    }
    else if([kHelpers isIphoneX])
    {
        self.titleTopConstraint.constant = 54;
        self.unlockBottomConstraint.constant = 23;
        self.blockTopConstraint.constant = 284;
        self.unlockedTopConstraint.constant = 12;

        self.backButton.y = 11  + kiPhoneXTopSpace;

    }
    else
    {
        self.titleTopConstraint.constant = 14;
        self.unlockBottomConstraint.constant = 23;
        self.blockTopConstraint.constant = 244;
        self.unlockedTopConstraint.constant = 12;

    }
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    if(self.sharing)
        return;

    if(self.alreadyDidAppear)
        return;

    //self.continueClicked = NO;

    self.isPotion = self.isCoin = self.isRainbow = NO;

    self.newPowerups = NO;
    self.newEnemies = NO;

    self.newSkin = kCoinTypeNone; //[kAppDelegate getSkin]
    self.randomSkin = kCoinTypeNone;

    self.tutoArrow.hidden = YES;
    self.tutoArrow.userInteractionEnabled = NO;
    self.block.hidden = YES;

	//chest
	self.chestImage.hidden = NO;
	self.chestImage.alpha = 1.0f;

    self.poofImage.hidden = YES;
    self.poofImage2.hidden = YES;

    //text desc
    if(self.backToTitle || self.backToGameMenu)
        //self.labelSubTitle.text = @"It's dangerous to go alone, Hero...\nTake this!";
        self.labelSubTitle.text = @"It's dangerous to go alone...\nTake this!";
        //self.labelSubTitle.text = @"It's dangerous to go alone, Hero...Take this!\nIt's content will help you on your way.";
    else
        self.labelSubTitle.text = @"But more Coins are in\nanother World...";


    //continue button text
    NSString *tempTitle = nil;

    if(self.backToTitle || self.backToGameMenu)
        //tempTitle = [CBSkinManager getRandomOKButton2]; //LOCALIZED(@"kStringGotIt"); //LOCALIZED(@"kStringClose");
        tempTitle =  LOCALIZED(@"kStringContinueCollect");
    else
        tempTitle =  LOCALIZED(@"kStringContinueNext");

    [self.continueButton setTitle:tempTitle forState:UIControlStateNormal];

    //attrib
    NSMutableAttributedString *attributedString = nil;
    float spacing = 2.0f;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.continueButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    //continue icon
    UIImage *buttonImage = [UIImage imageNamed:@"menu_icon_resume"];
    //resize
    buttonImage = [kHelpers imageByScalingForSize:CGSizeMake(25,25) withImage:buttonImage];
    if(buttonImage && !self.backToTitle && !self.backToGameMenu) {
        float topOffset = 2;

        [self.continueButton setImage:buttonImage forState:UIControlStateNormal];

        //left with padding
        CGFloat spacing = 6; // the amount of spacing to appear between image and title
        self.continueButton.imageEdgeInsets = UIEdgeInsetsMake(topOffset, 0, 0, spacing);
        self.continueButton.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
    }


    self.flashImage.alpha = 0.0f;
    self.flashImage.hidden = YES;

    [self setupFade];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    self.comboLabel.hidden = self.backToTitle || self.backToGameMenu;
        // = (kAppDelegate.maxComboLevel < kComboMinCount);
    self.comboLabel.text = [NSString stringWithFormat:@"Best Combo: %d", (int)kAppDelegate.maxComboLevel];

    self.perfectImage.hidden = YES;
    self.brainImage.hidden = YES;

    //title
	int levelTemp = (int)kAppDelegate.level-1;
	BOOL negative = NO;
    if(levelTemp > kLevelMax)
    {
        //negative
        levelTemp = (levelTemp % kLevelMax);
        negative = YES;
    }

    //title text
    if(self.backToTitle || self.backToGameMenu)
    {
        self.titleLabel.text = @"Free Gift";

        self.titleLabel.font = [UIFont fontWithName:kFontNameBlocky size:20*kFontScale]; //20

    }
    else
    {
        if(negative)
        {
            self.titleLabel.text = [NSString stringWithFormat:@"World Minus %d Complete!", levelTemp];

            self.titleLabel.font = [UIFont fontWithName:kFontNameBlocky size:15*kFontScale]; //20
        }
        else
        {
            self.titleLabel.text = [NSString stringWithFormat:@"World %d Complete!", levelTemp];

            self.titleLabel.font = [UIFont fontWithName:kFontNameBlocky size:20*kFontScale]; //20
        }

    }

    self.vcr.hidden = YES;
    self.vcr.alpha = 0.0f;
    [self.vcr startAnimating];


    self.star1.alpha = self.star2.alpha = self.star3.alpha = 0.0f; //0.2f;
    self.touch1.alpha = self.touch2.alpha = self.touch3.alpha = 0.0f;

    //disable
    self.star1.hidden = self.star2.hidden = self.star3.hidden =
        self.touch1.hidden = self.touch2.hidden = self.touch3.hidden = YES;

    //reset
    self.touch1Width.constant = self.touch1Height.constant =
    self.touch2Width.constant = self.touch2Height.constant =
    self.touch3Width.constant = self.touch3Height.constant = 40.0f;

    //update time
    [kAppDelegate updateForegroundTime];

    //setup
    self.labelBlock.text = @"New Block unlocked!"; //"We've obtained." //"You got a" //"Aquired"
    self.labelMult.text = @"Mult +5%";
    self.block.image = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:(int)[kAppDelegate getSkin]]];
    self.labelBlockName.text = @""; //[CBSkinManager getBlockDisplayNameIndex:(int)[kAppDelegate getSkin]];

    [self enableButtons:NO];

    //hide for chest
    self.continueButton.hidden = YES; //self.backToTitle || self.backToGameMenu;
    self.continueButton.alpha = 0.0f;

    //no back
    self.backButton.hidden = NO; //YES;
    self.backButton2.hidden = NO; //YES;
    self.storeButton.hidden = YES;
    self.storeButton2.hidden = YES;

    //hide like, rate
    self.likeButton2.hidden = YES;
    self.rateButton.hidden = YES; //big one
    self.rateButton2.hidden = YES; //small bottom

    //state
    kAppDelegate.titleController.menuState = menuStateWin;

    [kHelpers setupGoogleAnalyticsForView:[[self class] description]];

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    [self startConfetti];

    [self updateUI];

    [self showWhiteBar];

    [self showCoins];

    if(!self.backToTitle && !self.backToGameMenu)
        [self showBrain];

    //from game
    [kAppDelegate dbIncLevelup];

    float secs = 0.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        [kAppDelegate playMusic:[CBSkinManager getLevelupMusicName] andRemember:YES];

    });

    [kAppDelegate cacheRewardVideos];

    //level up

    if(!self.alreadyDidAppear) {
        self.labelSubTitle.alpha = 0.0f;
        self.labelSubTitleTop.alpha = 0.0f;

        self.block.alpha = 0.0f;
        self.blueBg.alpha = 0.0f;

        self.labelBlock.alpha = 0.0f;
        self.labelBlockName.alpha = 0.0f;

        self.labelMult.alpha = 0.0f;
        self.blockButton.hidden = YES;

        self.labelDescContraintTop.constant = kTitleSpacingAfter; //kTitleSpacingBefore;
    }

    [self setupPremium];

}

-(BOOL)shouldUnlock
{
	//BOOL should =  (kAppDelegate.level % 2); //odd;
	BOOL should =  ([kAppDelegate unlockRandomBlock:NO] != kCoinTypeNone); //don't really unlock

	if(self.backToTitle || self.backToGameMenu)
		should = NO; //always win potion from reward?

	return  should;
}

-(void)showAlertNewEnemies
{
  NSString *message = @"New <color1>Enemies</color1> have been unlocked!";

  if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
      [kAppDelegate.alertView dismissAnimated:NO];

  kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Unlocked"
                                                   andMessage:message];

  [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                        type:kAlertButtonGreen
                                     handler:^(SIAlertView *alert) {
                                         //
                                         [kAppDelegate playSound:kClickSound];

                                     }];

  kAppDelegate.alertView.transitionStyle = kAlertStyle;

  //close, unpause
  [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

  }];

  [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
      //nothing
  }];

  //after delay
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //pause
    [kAppDelegate.alertView show:YES];
    [self enableButtons:YES];
  });
}

-(void)showAlertNewPowerups
{
  NSString *message = @"New <color1>Power-ups</color1> have been unlocked!";

  if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
      [kAppDelegate.alertView dismissAnimated:NO];

  kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Unlocked"
                                                   andMessage:message];

  [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                        type:kAlertButtonGreen
                                     handler:^(SIAlertView *alert) {
                                         //
                                         [kAppDelegate playSound:kClickSound];

                                     }];

  kAppDelegate.alertView.transitionStyle = kAlertStyle;

  //close, unpause
  [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

  }];

  [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
      //nothing
  }];

  //after delay
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //pause
    [kAppDelegate.alertView show:YES];
    [self enableButtons:YES];
  });
}

-(void)showAlertNewEnemiesAndPowerups
{
    NSString *message = @"New <color1>Enemies</color1> and <color1>Power-ups</color1> have been unlocked!";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Unlocked"
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           //
                                           [kAppDelegate playSound:kClickSound];

                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //after delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //pause
        [kAppDelegate.alertView show:YES];
        [self enableButtons:YES];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if(self.sharing)
        return;

    self.block.contentMode = UIViewContentModeScaleAspectFit;

    if(self.alreadyDidAppear)
        return;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //[kAppDelegate playSound:@"alertchat.caf"];
    });

#if 0
    //new unlocks alert
    if(self.backToGame)
    {
      //new enemies
      NSArray *before = nil;
      NSArray *after = nil;

      before = [CBSkinManager getFireballArrayWithLevel:kAppDelegate.level-1 all:NO];
      after = [CBSkinManager getFireballArrayWithLevel:kAppDelegate.level all:NO];
      BOOL newEnemies1 = (before.count != after.count);
      before = [CBSkinManager getSpikeArrayWithLevel:kAppDelegate.level-1 all:NO];
      after = [CBSkinManager getSpikeArrayWithLevel:kAppDelegate.level all:NO];
      BOOL newEnemies2 = (before.count != after.count);
      self.newEnemies = (newEnemies1 || newEnemies2);

      //force
      //newEnemies1 = newEnemies2 = YES;

      //new powerups
      before = [CBSkinManager getAvailablePowerupsWithLevel:kAppDelegate.level-1];
      after = [CBSkinManager getAvailablePowerupsWithLevel:kAppDelegate.level];
      self.newPowerups = (before.count != after.count);

      //force
      //self.newPowerups = YES;
    }

    //disable button for alerts
    if(self.newPowerups || self.newEnemies)
        [self enableButtons:NO];
    //and show alerts after delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //if(self.newPowerups || self.newEnemies)
        //    [self enableButtons:YES];

        if(self.newPowerups && self.newEnemies)
            [self showAlertNewEnemiesAndPowerups];
        else if (self.newPowerups)
            [self showAlertNewPowerups];
        else if (self.newEnemies)
            [self showAlertNewEnemies];
    });

#endif

	//reset chest, but not for real win
	if(!self.backToGame)
	{
		kAppDelegate.chestDate = [NSDate date];
    	[kAppDelegate saveState];
	}

    //free chest after 1-4, but only from game
    if(kAppDelegate.level == 2 && self.backToGame)
    {
        //force chest
        kAppDelegate.chestDate = [[NSDate date] dateByAddingTimeInterval:-kChestIntervalNeeded];
        [kAppDelegate saveState];
    }

    //long key sound
    [kAppDelegate playSound:@"key2.caf"];

    //voice
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(self.backToTitle || self.backToGameMenu)
        {
            if(kVoiceEnabled)
                [kAppDelegate playSound:@"voice_win.caf"]; //gift
        }
        else
        {
            if(kVoiceEnabled)
                [kAppDelegate playSound:@"voice_win.caf"]; //win
        }
    });


    kAppDelegate.fromWin = YES;

    if(self.backToTitle || self.backToGameMenu)
        self.labelSubTitleTop.text = @"Welcome back, Hero!";
    else
        self.labelSubTitleTop.text = [CBSkinManager getRandomWinMessage];

	self.coinsImage.alpha = 1.0;

    ///animate

    //self.labelSubTitle2.animationDuration = 0.5f;
    self.labelSubTitle2.animationDelay = 0.04f; //0.04f;

    self.labelSubTitle2.text = self.labelSubTitle.text;
    self.labelSubTitle2.font = self.labelSubTitle.font;
    self.labelSubTitle2.textColor = self.labelSubTitle.textColor;

    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //style.lineSpacing = 1;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attrsDictionary = @{NSFontAttributeName : self.labelSubTitle.font, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : self.labelSubTitle.textColor};
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.labelSubTitle.text attributes:attrsDictionary];
    [self.labelSubTitle2 setAttributedString:attrString];
    [self.labelSubTitle2 startAppearAnimation];

    //__weak typeof(self) weakSelf = self;

    //give time to layout
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self resetTimer];

        [kAppDelegate playSound:kUnlockSound];
    });

    //level 3 and only for chest
    //if(kAppDelegate.level >= 3 && (self.backToTitle || self.backToGameMenu))
    if(kAppDelegate.level >= 3)
    {
        kAppDelegate.notifyEnabled = YES;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [kAppDelegate registerNotifications];
            [kAppDelegate setupNotifications];


            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(kIsIOS10_3 & ![kHelpers isDebug])
                {
                    //10.3 review
                    //[SKStoreReviewController requestReview];


                    //getrated instead
                    [[getRated sharedInstance] promptIfAllCriteriaMet];
                }
            });

        });
    }

    //scale
    //alernate potion

    BOOL showAlternate = ![self shouldUnlock]; //if already unlocked, show potion
    CGFloat blockScaleMult  = 0.0f;
    if(showAlternate)
    {
        //potion
        blockScaleMult = 1.0f;
    }
    else
    {
        blockScaleMult = 1.0f;
    }

    CABasicAnimation *scale3;
    scale3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale3.fromValue = [NSNumber numberWithFloat:1.0f * blockScaleMult];
    scale3.toValue = [NSNumber numberWithFloat:0.9f * blockScaleMult];
    scale3.duration = 0.3f;
    scale3.repeatCount = HUGE_VALF;
    scale3.autoreverses = YES;
    [self.block.layer removeAllAnimations];
    [self.block.layer addAnimation:scale3 forKey:@"scale"];




    [self.chestImage.layer removeAllAnimations];
    //[self.chestImage.layer addAnimation:scale3 forKey:@"scale"];

    //shake
    //https://stackoverflow.com/questions/3844557/uiview-shake-animation
    CABasicAnimation *shake =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.05f];
    [shake setRepeatCount:HUGE_VALF];
    [shake setAutoreverses:YES];

    CGFloat offset = 2.0f;
    [shake setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.chestImage center].x - offset, [self.chestImage center].y)]];
    [shake setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.chestImage center].x + offset, [self.chestImage center].y)]];
    [self.chestImage.layer addAnimation:shake forKey:@"shake"];

    //also scale in
    CABasicAnimation *scale4;
    scale4 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale4.fromValue = [NSNumber numberWithFloat:1.0f * blockScaleMult];
    scale4.toValue = [NSNumber numberWithFloat:1.4f * blockScaleMult];
    scale4.duration = 2.0f;
    //scale4.repeatCount = 1;
    //scale4.autoreverses = NO;
    [self.chestImage.layer addAnimation:scale4 forKey:@"scale"];




    self.chestImage.image = [UIImage imageNamed:@"chest2"];
    //animate chest images
    self.chestImage.animationImages = @[[UIImage imageNamed:@"chest2"], [UIImage imageNamed:@"chest3"]];
    self.chestImage.animationDuration = 0.3f;
    self.chestImage.animationRepeatCount = 0;
    [self.chestImage startAnimating];


    //desc, fade in
    if(!self.alreadyDidAppear) {

        int unlockedSkin = kCoinTypeNone;
        if(!showAlternate)
        {
            unlockedSkin = [kAppDelegate unlockRandomBlock];

            if(unlockedSkin != kCoinTypeNone && unlockedSkin != kCoinTypeDefault)
            {
                //set as current
                self.newSkin = unlockedSkin;
                //[kAppDelegate setSkin:unlockedSkin];
            }
        }

        self.labelDescContraintTop.constant = kTitleSpacingAfter; //kTitleSpacingBefore;
        [self.view layoutIfNeeded];



        //title
        self.labelSubTitle.alpha = 0.0f;
        self.labelSubTitle.hidden = NO;

        self.labelSubTitleTop.alpha = 0.0f;
        self.labelSubTitleTop.hidden = NO;
        [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.labelSubTitle.alpha = 0.6f;
            self.labelSubTitleTop.alpha = 0.9f;

			//already 1.0 on willappear
            //self.chestImage.alpha = 1.0f;

        } completion:^(BOOL finished){


            self.block.alpha = 0.0f;
            self.block.hidden = NO;
            //self.tutoArrow.hidden = NO;
            [self showArrow];

            self.blueBg.alpha = 0.0f;
            self.blueBg.hidden = YES; //NO;

            self.labelBlock.alpha = 0.0f;
            self.labelBlock.hidden = NO;
            self.labelBlockName.alpha = 0.0f;
            self.labelBlockName.hidden = NO;

            //alternate
            if(unlockedSkin != kCoinTypeDefault && unlockedSkin != kCoinTypeNone && !showAlternate) {
                    self.labelDescContraintTop.constant = kTitleSpacingAfter;

                    self.block.image = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:unlockedSkin]];

                    self.labelBlockName.text = [CBSkinManager getBlockDisplayNameIndex:unlockedSkin];

                    NSString *typeName = [CBSkinManager getBlockTypeName:unlockedSkin];
                    UIColor *typeColor = [CBSkinManager getBlockTypeColor:unlockedSkin];

                    //self.labelBlockName.text = [NSString stringWithFormat:@"%@ - %@", self.labelBlockName.text, typeName];
                    self.labelBlockName.text = [NSString stringWithFormat:@"%@", self.labelBlockName.text];

                    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:self.labelBlockName.text];

                    [attributed addAttribute:NSForegroundColorAttributeName
                                       value:self.labelBlockName.textColor
                                       range:[self.labelBlockName.text fullRange]];

                     //rarity
                    [attributed addAttribute:NSForegroundColorAttributeName
                                           value:typeColor
                                           range:[self.labelBlockName.text rangeOfString:typeName]];

                    //font
                    [attributed addAttribute:NSFontAttributeName
                                   value: [UIFont fontWithName:kFontName size:14*kFontScale]
                                   range:[self.labelBlockName.text rangeOfString:typeName]];


                    self.labelBlockName.attributedText = attributed;

                    NSString *soundName = [CBSkinManager getStartSoundName:unlockedSkin];

                    //if(!kAppDelegate.inReview)
                    if(NO)
                    {
                        if(kAppDelegate.level == kLevelMax)
                        {
                            soundName = @"sinistar1.caf"; //beware i live
                        }
                    }

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                        [kAppDelegate playSound:soundName];

                    });

                    self.labelSubTitle2.frame = self.labelSubTitle.frame;

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        //flash white for transition
                        [self showFlash:kFlashColorWhiteFull autoHide:YES];

                        //also poof
                        [self showPoof];



                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self showMiniShines];
                        });

                        //short key sound
                        [kAppDelegate playSound:@"key1.caf"];

                        //doo doo doo
                        [kAppDelegate playSound:@"discover.caf"];

                    });

                    [UIView animateWithDuration:0.1f delay:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{

                        //hide chest, faster
                        self.chestImage.alpha = 0.0f;

                    } completion:^(BOOL finished){
                    }];

                    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{


                        self.block.alpha = 1.0f;
                        self.blueBg.alpha = 0.8f; //1.0f;
                        self.labelBlock.alpha = 0.9f;
                        self.labelBlockName.alpha = 0.9f;

                        self.labelSubTitle2.frame = self.labelSubTitle.frame;

                    } completion:^(BOOL finished){


                        self.blockButton.hidden = NO;

                        //regular win
                        //if(!self.continueClicked)
                        {
                            self.continueButton.hidden = NO;
                            self.continueButton.alpha = 0;
                            [UIView animateWithDuration:0.3f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                self.continueButton.alpha = 1.0f;
                            } completion:nil];
                        }

                        //not if alert coming
                        if(!self.newPowerups && !self.newEnemies)
                            [self enableButtons:YES];
                    }];
                }
                else
                {
                    //self.labelBlock.text =  @"Item aquired!"; //@"New item!"; //"We've obtained." //"You got a" //"Aquired"
                    self.labelBlock.text =  @"You got"; //@"New item!"; //"We've obtained." //"You got a" //"Aquired"

                    //potion
                    self.labelDescContraintTop.constant = kTitleSpacingAfter;

                    self.block.contentMode = UIViewContentModeScaleAspectFit;

                    int coinDiff =  kAppDelegate.nextOneUp - kAppDelegate.clickCount;

                    //at least 50 before end
                    if([kHelpers randomBool100:30] || coinDiff<20)
                    //if(NO)
                    {
                        self.block.image = [UIImage imageNamed:@"potion_win"];
                        self.isPotion = YES;

                        [self setupMiniShines];
                    }
                    else if ([kHelpers randomBool100:10])
                    //else if (NO)
                    {
                        self.block.image = nil;

                        [self.block.layer removeAllAnimations];

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

                        self.block.animationImages = images;
                        self.block.animationDuration = images.count * 0.1f;
                        self.block.animationRepeatCount = 0;
                        [self.block startAnimating];

                        self.isRainbow = YES;

                        //scale
                        float duration = 0.3f;
                        CABasicAnimation *scale4;
                        scale4 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
                        scale4.fromValue = [NSNumber numberWithFloat:1.0f];
                        scale4.toValue = [NSNumber numberWithFloat:-1.0]; //0.1f;
                        scale4.duration = duration * 2;
                        scale4.repeatCount = HUGE_VALF;
                        scale4.autoreverses = YES;
                        [self.block.layer addAnimation:scale4 forKey:@"scale"];

                    }
                    else
                    {
                        //self.block.image = [UIImage imageNamed:@"pile_of_coins"];
                        //self.block.image = [UIImage imageNamed:@"coin3Frame1"];
                        NSString *coinName = [CBSkinManager getCoinBarImageName];
                        coinName = [NSString stringWithFormat:@"%@%@", coinName, @"Frame1"];
                        assert(coinName);

                        self.block.image = [UIImage imageNamed:coinName];
                        assert(self.block.image);

                        self.isCoin = YES;

                        [self setupMiniShines];

                        //scale
                        float duration = 0.3f;
                        CABasicAnimation *scale4;
                        scale4 = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
                        scale4.fromValue = [NSNumber numberWithFloat:1.0f];
                        scale4.toValue = [NSNumber numberWithFloat:-1.0]; //0.1f;
                        scale4.duration = duration * 2;
                        scale4.repeatCount = HUGE_VALF;
                        scale4.autoreverses = YES;
                        [self.block.layer addAnimation:scale4 forKey:@"scale"];
                    }

                    //unused?
                    NSString *typeName = [CBSkinManager getBlockTypeName:unlockedSkin];
                    UIColor *typeColor = [CBSkinManager getBlockTypeColor:unlockedSkin];

                    self.labelBlockName.text = [NSString stringWithFormat:@"%@", self.labelBlockName.text];

                    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:self.labelBlockName.text];

                    [attributed addAttribute:NSForegroundColorAttributeName
                                       value:self.labelBlockName.textColor
                                       range:[self.labelBlockName.text fullRange]];

                    //rarity
                    [attributed addAttribute:NSForegroundColorAttributeName
                                       value:typeColor
                                       range:[self.labelBlockName.text rangeOfString:typeName]];

                    //font
                    [attributed addAttribute:NSFontAttributeName
                                       value: [UIFont fontWithName:kFontName size:14*kFontScale]
                                       range:[self.labelBlockName.text rangeOfString:typeName]];


                    self.labelBlockName.attributedText = attributed;


                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                        if(self.isPotion)
                        {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                [kAppDelegate playSound:@"potion2.caf"];
                            });

                            //inc potion
                            int newPotions = 1 + arc4random_uniform(3);

                            kAppDelegate.numPotions += newPotions;
                            if(kAppDelegate.numPotions > kMaxPotions)
                                kAppDelegate.numPotions = kMaxPotions;

                            self.labelBlockName.text = [NSString stringWithFormat:@"Potion x %d", newPotions];

                            [kAppDelegate checkAchievements];

                        }

                        if(self.isRainbow)
                        {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                [kAppDelegate playSound:@"coin_gameboy.caf"];
                            });

                            //inc rainbow
                            kAppDelegate.rainbowCount += 1;
                            //also inc count used
                            kAppDelegate.rainbowUsedCount += 1;

                            [kAppDelegate checkAchievements];

                            self.labelBlockName.text = [NSString stringWithFormat:@"Power Coin x1"];


                            [kAppDelegate saveState];
                        }

                        if(self.isCoin)
                        {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                [kAppDelegate playSound:@"smb3_coin6.caf"];
                            });


                            /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                [kAppDelegate playSound:@"smb3_coin6.caf"];
                            });

                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                [kAppDelegate playSound:@"smb3_coin6.caf"];
                            });*/


                            //inc coins
                            // 1/4 diff
                            int newCoins = arc4random_uniform(coinDiff/4);

                            //always even
                            if(newCoins % 2 == 1)
                                newCoins--;

                            newCoins = MAX(10, newCoins); //min 5
                            kAppDelegate.clickCount += newCoins;

                            //self.labelBlockName.text = [NSString stringWithFormat:@"More Coins x %d", newCoins];
                            self.labelBlockName.text = [NSString stringWithFormat:@"Coins x %d", newCoins];

                            [kAppDelegate checkAchievements];

                        }


                    });

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        [self showFlash:kFlashColorWhiteFull autoHide:YES];

                        //also poof
                        [self showPoof];

                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self showMiniShines];
                        });

                        //short key sound
                        [kAppDelegate playSound:@"key1.caf"];

                        //doo doo doo
                        [kAppDelegate playSound:@"discover.caf"];

                    });

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.6f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                        //regular win
                        //if(!self.continueClicked)
                        {
                            //show if hidden, for chest
                            self.continueButton.hidden = NO;

                            //from title chest
                            self.continueButton.alpha = 0;
                            [UIView animateWithDuration:0.3f delay:1.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
                                self.continueButton.alpha = 1.0f;
                            } completion:nil];
                        }
                    });

                    self.labelSubTitle2.frame = self.labelSubTitle.frame;

                    [UIView animateWithDuration:0.1f delay:0.6f options:UIViewAnimationOptionCurveEaseInOut animations:^{

                        //hide chest, faster
                        self.chestImage.alpha = 0.0f;

                    } completion:^(BOOL finished){
                    }];

                    [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{

                        self.block.alpha = 1.0f;
                        self.blueBg.alpha = 0.8f; //1.0f;
                        self.labelBlock.alpha = 0.9f;
                        self.labelBlockName.alpha = 0.9f;

                        self.labelSubTitle2.frame = self.labelSubTitle.frame;

                    } completion:^(BOOL finished){


                        self.blockButton.hidden = NO;

                        //not if alert coming
                        if(!self.newPowerups && !self.newEnemies)
                            [self enableButtons:YES];
                    }];
                }

            //}];

        }];
    }

    //wobble
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kAppDelegate animateControl:self.continueButton];
    });

    //rotate
    [self addShineAnimation];

    //state
    kAppDelegate.launchInGame = NO;
    [kAppDelegate saveState];

    //previous skin
    //int lastSkin = [kAppDelegate getSkin];

    //re-random, but not from chest
    if(kAppDelegate.isRandomSkin && !self.backToTitle && !self.backToGameMenu) {
        NSMutableArray *randomArray = [NSMutableArray array];
        for(int i=0;i<kNumSkins;i++) {
            BOOL enabled  = [kAppDelegate isBlockEnabledIndex:i] && [kAppDelegate isBlockRemoteEnabledIndex:i];
            if(enabled)
                [randomArray addObject:[NSNumber numberWithInt:i]];
        }

        //self.isRandoming = YES;
        //kAppDelegate.isRandomSkin = YES;
        //[kAppDelegate playSound:@"spin1.caf"];

        int randomIndex = [[randomArray randomObject] intValue];
        //[self.carousel scrollToItemAtIndex:randomIndex animated:YES];

        //make sure it's different
        for(int i = 0; i<10; i++) {
            if(randomIndex == [kAppDelegate getSkin])
                randomIndex = [[randomArray randomObject] intValue];
            else
                break;
        }

        //set skin
        self.randomSkin = randomIndex;
        //[kAppDelegate setSkin:randomIndex];
    }

    NSString *message = [CBSkinManager getRandomWinMessage];

    //unlocks
    int oldEnabledSkins = kAppDelegate.gameController.lastEnabledSkins;
    kAppDelegate.gameController.lastEnabledSkins = 0;
    for(int i=0;i<kNumSkins;i++) {
        BOOL enabled  = [kAppDelegate isBlockEnabledIndex:i];
        if(enabled)
            kAppDelegate.gameController.lastEnabledSkins++;
    }

    //BOOL newNotifEnabled = NO;
    //different, show unlock
    if(kAppDelegate.gameController.lastEnabledSkins > oldEnabledSkins) {
        message = [message stringByAppendingString:@"\n\nNew Block unlocked!"];

        //show notif alert, 1st time
//        if(kAppDelegate.level >= 3 && (self.backToTitle || self.backToGameMenu))
//            kAppDelegate.notifyEnabled = YES;


        //set back to new skin, to cancel random
        //self.newSkin = lastSkin;
        //[kAppDelegate setSkin:lastSkin];

        self.alreadyDidAppear = true;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if(self.sharing)
        return;

    [self hideArrow];

	//reset level combo
	kAppDelegate.maxComboLevel = 0;

    [kAppDelegate saveState];

	[self.timerCoins invalidate];
	self.timerCoins = nil;

    [self hideMiniShines];
    [self stopCoins];

   /* [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    [self.shineImageView.layer removeAllAnimations];
    [self.chestShine.layer removeAllAnimations];

    [self.cloud1.layer removeAllAnimations];
    self.cloud1.alpha = 0.0f;
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    [self stopWhiteBar];

    [self stopConfetti];
*/
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

-(void)actionInit
{
    self.alreadyDidAppear = NO;
}

-(void)actionDone
{
    self.alreadyDidAppear = NO;
    self.showPerfect = NO;
    self.perfectImage.hidden = YES;

    //reset
    //self.numCheatStars = 0;

    [self.labelSubTitle2 startDisappearAnimation];

    //reset
    kAppDelegate.worldTimeLeft = [CBSkinManager getWorldTime];
    kAppDelegate.starLevelCount = 0;
    kAppDelegate.prefLevelNumFireballsTouched = 0;
    //[kAppDelegate saveState];


    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    [self.timerVCR invalidate];
    self.timerVCR = nil;
    self.vcr.hidden = YES;

    [self.timerLabelBlock invalidate];
    self.timerLabelBlock = nil;

    [kAppDelegate saveState];
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

    self.backButton.enabled = enable;
    self.backButton2.enabled = enable;

    self.storeButton.enabled = enable;
    self.rateButton.enabled = enable;
    self.shareButton.enabled = enable;
    self.continueButton.enabled = enable;
    self.blockButton.enabled = enable;

    self.premiumButton.enabled = enable;
    self.premiumButton.alpha = enable?1.0f:0.5f;

    self.self.continueButton.enabled = enable;
    //self.self.continueButton.alpha = enable?1.0f:0.5f;
}

- (void) actionShare:(id)sender {
    [kAppDelegate playSound:kClickSound];

    //share
    [self shareButtonPressed:sender];
}

- (void) actionRate:(id)sender {

    [self rateButtonPressed:sender];
}

- (void) actionStore:(id)sender {
    [kAppDelegate playSound:kClickSound];

    [kAppDelegate setupNotifications];

    [self actionPlusEnergy:nil];
}


- (void) actionContinue:(id)sender {

    if(!self.continueButton.enabled)
        return;

    //self.continueClicked = YES;

    [self actionDone];

    [self enableButtons:NO];

    [self hideArrow];

    //hide
    self.continueButton.hidden = NO;

    //self.continueButton.alpha = 0;
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.continueButton.alpha = 0.0f;
    } completion:nil];

    //BOOL newNotifEnabled = NO;

    //fade white
    kAppDelegate.fadingWhite = YES;

    //if(!self.backToTitle && !self.backToGameMenu)
        [kAppDelegate playSound:kClickSound];

    //mark as read
    [kAppDelegate.dicSkinNew setObject:@(NO)forKey:[CBSkinManager getSkinKey:(int)[kAppDelegate getSkin]]];


    [kAppDelegate setupNotifications];

    //[kAppDelegate playSound:@"starClick3.caf"];

    //set new skin, if from block click, not continue
    if((self.newSkin != kCoinTypeNone) && (sender == self.blockButton))
	     [kAppDelegate setSkin:self.newSkin];
    //random
    else if((self.newSkin != kCoinTypeNone) && (sender == self.continueButton))
        [kAppDelegate setSkin:self.randomSkin];

    float secs = 0.5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        if(self.backToTitle /*|| self.backToGameMenu*/)
            [self actionBack:nil];
        else
            [self actionBack:nil];

    });
}

- (void) actionBack:(id)sender {

    self.alreadyDidAppear = NO;

    [kAppDelegate animateControl:self.backButton];
    [kAppDelegate animateControl:self.backButton2];

    //[kAppDelegate stopMusic];

    if(sender)
        [kAppDelegate playSound:kClickSound];

    [self enableButtons:NO];

    [self hideArrow];

    [self fadeIn];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //[kAppDelegate setViewController:kAppDelegate.gameController];
        if(sender || self.backToTitle)
        {
            [kAppDelegate setViewController:kAppDelegate.titleController];
        }
        else
        {
            if(self.backToGameMenu)
            {
                //game directly
                //[kAppDelegate setViewController:kAppDelegate.gameController];
                [kAppDelegate setViewController:kAppDelegate.transitionController];
            }
            else
            {
                BOOL story = (kAppDelegate.level == kStoryLevel1 || kAppDelegate.level == kStoryLevel2);
                if(story)
                {
                    kAppDelegate.storyController.toTransition = YES;
                    [kAppDelegate setViewController:kAppDelegate.storyController];
                }
                else
                {
                    [kAppDelegate setViewController:kAppDelegate.transitionController];
                }
            }

		}
    });
}


- (IBAction)storeButtonPressed:(id)sender
{
    //self.skipFade = NO;

    [kAppDelegate animateControl:self.storeButton];

    [self enableButtons:NO];

    //self.storeButton.alpha = kButtonSelectedAlpha;

    [self.storeButton2 setBadgeValue:nil];

    [kAppDelegate playSound:kClickSound];

    kAppDelegate.titleController.menuState = menuStateStore;

    [self fadeIn];
}

- (IBAction)otherButtonPressed:(id)sender
{
    //self.otherButton.alpha = kButtonSelectedAlpha;

    [kAppDelegate animateControl:self.otherButton2];

    //save
    int numAppsInt = [kAppDelegate.titleController.numApps intValue];
    kAppDelegate.numApps = numAppsInt;
    [kAppDelegate saveState];

    [self.otherButton2 setBadgeValue:nil];

    [kAppDelegate playSound:kClickSound];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/artist/skyriser-media/id359807334"] options:@{} completionHandler:nil];
}


- (IBAction)likeButtonPressed:(id)sender {
    [kAppDelegate animateControl:self.likeButton2];

    [self gotoFacebook];
}

- (void)gotoFacebook
{

    //fb://profile/CoinBlockApp

    //NSURL *fanPageURL = [NSURL URLWithString:@"fb://CoinBlockApp"];

    //if(true)
    //if (![[UIApplication sharedApplication] openURL: fanPageURL])
    {
        //fanPageURL failed to open.  Open the website in Safari instead
        //NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/pages/Password-Grid/169115183113120"];

        NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/CoinyBlock"];
        [[UIApplication sharedApplication] openURL:webURL options:@{} completionHandler:nil];

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
    //    [self.view bringSubviewToFront:self.brainImage];
    //    [self.view bringSubviewToFront:self.coinsImage];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.flashImage];
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
        self.curtainRight.x = screenRect.size.width;
    }
                     completion:^(BOOL finished){
                         self.curtainLeft.hidden = YES;
                         self.curtainRight.hidden = YES;
                     }];
}

-(void)closeCurtains {
    //disabled
    //return;

    CGRect screenRect = [kHelpers getScreenRect];

    //top
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


#pragma mark - Actions

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
    //if(kAppDelegate.titleController.menuState != menuStateWin)
    //    return;

    //only for iOS7
    //if(kIsIOS8)
    //    return;

    //re-add anim
    [self addShineAnimation];

    [self showWhiteBar];

    [self setupPremium];

    [self showCoins];

    [self showMiniShines];

    if(!self.block.hidden)
    {
        self.tutoArrow.hidden = YES;
        [self showArrow];
    }
}


- (void)notifyBackground
{
    //only for iOS7
    //if(kIsIOS8)
    //    return;

    //fix crash
    [self.shineImageView.layer removeAllAnimations];

    [self.premiumButton.layer removeAllAnimations];
    [self.premiumBadge.layer removeAllAnimations];
    [self.premiumBack.layer removeAllAnimations];

    [self.tutoArrow.layer removeAllAnimations];


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
    //call now
    //[self actionTimerVCR:nil];


    [self.timerLabelBlock invalidate];
    self.timerLabelBlock = [NSTimer scheduledTimerWithTimeInterval:0.15f target:self
                                                   selector:@selector(actionTimerLabelBlock:) userInfo:@"actionTimerLabelBlock" repeats:YES];

    //pulse
    [self.timerPulse invalidate];
    self.timerPulse = nil;

    interval = 1.0f;
    self.timerPulse = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                          selector:@selector(actionTimerPulse:) userInfo:@"actionTimerPulse" repeats:YES];

														      interval = 15.0f;
    [self.timerCoins invalidate];
    self.timerCoins = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerCoins:) userInfo:@"actionTimerBg" repeats:YES];
}

- (void) actionTimerLabelBlock:(NSTimer *)incomingTimer
{
    self.boolTimerLabelBlock = !self.boolTimerLabelBlock;
    if(self.boolTimerLabelBlock)
    {
        //self.labelBlock.textColor = [UIColor orangeColor];
        self.labelBlockName.textColor = [UIColor orangeColor];
    }
    else
    {
        //self.labelBlock.textColor = [UIColor yellowColor]; //[UIColor blackColor];
        self.labelBlockName.textColor = [UIColor yellowColor]; //[UIColor blackColor];
    }

    //perfect
    if(self.showPerfect)
    {
        self.perfectImage.hidden = !self.perfectImage.hidden;
    }

    //self.labelBlockName.textColor =
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

    if(kAppDelegate.titleController.menuState != menuStateWin || (self.view.hidden == YES))
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
        //[kAppDelegate playSound:@"noise.caf"];

        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            return;

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

- (void) actionTimerCloud:(NSTimer *)incomingTimer
{
    if(kAppDelegate.titleController.menuState != menuStateStore || (self.view.hidden == YES))
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
             //unlock emoji skin
             [kAppDelegate unlockBlock:kCoinTypeEmoji];

			 //achievement
			[kAppDelegate reportAchievement:kAchievement_share];
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


- (IBAction)rateButtonPressed:(id)sender
{
    [kAppDelegate dbIncRate];

    //[kAppDelegate playSound:kClickSound];
    [kAppDelegate playSound:@"kiss.caf"];

    __weak typeof(self) weakSelf = self;

    //ask
    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Rate"
                                             andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringEnjoying")]];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringHateIt")
                                  type:SIAlertViewButtonTypeDefault
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
                               }];

    /*[kAppDelegate.alertView addButtonWithTitle:@"Cancel"
                                  type:kAlertButtonOrange
                               handler:^(SIAlertView *alert) {

                                   [kAppDelegate playSound:kClickSound];


                                   float secs = 0.5;
                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                       //[weakSelf actionBack:nil];
                                   });

                               }];*/


    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing

        float secs = 0.5;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //[weakSelf actionBack:nil];
        });
    }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView show:YES];

    //[self showVCR:YES animated:YES];
}


- (IBAction)contactButtonPressed:(id)sender
{
    [kAppDelegate playSound:kClickSound];

    //[kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];


    NSString *version = [kHelpers getVersionString2];
    NSString *iosVersion = [[UIDevice currentDevice] systemVersion];
    NSString *model = [kHelpers platformString];
    NSString *body = [NSString stringWithFormat: @"App Version: %@\niOS Version: %@\niOS Device: %@\n\n\nDear Skyriser Media, \n\n\n\n", version, iosVersion, model];

    [kAppDelegate sendEmailTo:@"info@skyriser.com" withSubject: @"Coiny Block Feedback" withBody:body withView:self];

}

- (void) actionPlusEnergy:(id)sender {

    //store

    //report
    [kAppDelegate reportScore];

    [kAppDelegate saveState];

    [self enableButtons:NO];

    [self fadeIn];

    [kAppDelegate playSound:kClickSound];
    //[kAppDelegate playSound:@"whistle3.caf"];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //stop sounds
        [kAppDelegate.gameScene stopAllSounds];
    });

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

-(void) updateBadges
{
    int offset = -5;

    int num = [kAppDelegate getNumNewSkins];
    if(num > 0) {
        //[self.otherButton setBadgeValue:nil];
        //[self.otherButton setBadgeValue:@"6"];

        //store
        [self.storeButton setBadgeValue:[NSString stringWithFormat:@"%d", num] withOffsetY:offset];
        [self.storeButton2 setBadgeValue:[NSString stringWithFormat:@"%d", num] withOffsetY:offset];

    }
    else {
        [self.storeButton setBadgeValue:nil withOffsetY:offset];
        [self.storeButton2 setBadgeValue:nil withOffsetY:offset];

    }

    //other apps, badge

    [self.otherButton2 setBadgeValue:nil];

    //[PFConfig getConfigInBackgroundWithBlock:^(PFConfig *config, NSError *error) {

        //from parse
        //kAppDelegate.titleController.numApps = config[@"numApps"];
        kAppDelegate.titleController.numApps = @(kAppDelegate.numApps);
        int numAppsInt = [kAppDelegate.titleController.numApps intValue];

        //save last value?
        numAppsInt -= kAppDelegate.numApps;
        if(numAppsInt < 0)
            numAppsInt = 0;


        NSString *stringValue = [NSString stringWithFormat:@"%d", numAppsInt];

        if((numAppsInt > 0) && (kAppDelegate.level > 1)) {
            //if(YES) {
            [self.otherButton2 setBadgeValue:stringValue withOffsetY:2];
            //[self.optionsButton setBadgeValue:stringValue withOffsetY:offset];
        }
        else {
            [self.otherButton2 setBadgeValue:nil];
            //[self.optionsButton setBadgeValue:nil withOffsetY:offset];
        }

    //}];
}


- (void)updateUI {

    self.otherButton2.hidden = YES; //NO

    //resume
    UIFont *buttonFont1 = nil;

    //force
    buttonFont1 = [UIFont fontWithName:kFontName size:([kHelpers isIphone4Size] ? 24 : 26)*kFontScale];

    [self updateBadges];

    self.adButton2.hidden = YES;


    int buttonResize = 10;
    [self.storeButton2 setHitTestEdgeInsets:UIEdgeInsetsMake(-buttonResize, -buttonResize, -buttonResize, -buttonResize)];


    //disabled
    self.shareButton.hidden = YES;
    self.rateButton.hidden = YES;
    self.storeButton.hidden = YES;
    //self.continueButton.hidden = YES;
    self.labelMult.hidden = YES;

    self.premiumButton.hidden = self.premiumBadge.hidden = self.premiumBack.hidden = [kAppDelegate isPremium];
    self.premiumBadge.hidden = YES; //no badge
}

- (void) actionTimerPulse:(NSTimer *)incomingTimer
{
    [kAppDelegate animateControl:self.continueButton];
}


- (IBAction)premiumButtonPressed:(id)sender
{
    [self adButtonPressed:sender];
}

- (IBAction)adButtonPressed:(id)sender
{
    //just to go premium view
    [kAppDelegate animateControl:self.premiumButton];
    [self enableButtons:NO];
    [kAppDelegate playSound:kClickSound];

    kAppDelegate.titleController.menuState = menuStatePremium;

    [self actionDone];

    [self fadeIn];
    float secs2 = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        kAppDelegate.premiumController.backToGame = self.backToGame;
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

                                                                                          [kAppDelegate unlockVIPBlocks];

                                                                                          //also doubler
                                                                                          [kAppDelegate unlockDoubler];

                                                                                          [kAppDelegate saveState];

                                                                                          [self updateUI];

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

-(void)setupPremium
{
    //animate premium
    if(![kAppDelegate isPremium])
    {
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


-(void)showBrain {
    self.brainImage.hidden = NO;
    self.brainImage.alpha = 0.5f;

    CGFloat yStart = 150;
    CGFloat yEnd = yStart - 50;
    CGFloat brainWidthStart = 70.0f;
    CGFloat brainWidthEnd = 30.0f;

    self.brainImage.frame = CGRectMake(-brainWidthStart, yStart, brainWidthStart, brainWidthStart);

    CGFloat duration = 4.0f;
    [UIView animateWithDuration:duration delay:0.5f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.brainImage.alpha = 0.2f;

        CGRect screenRect = [kHelpers getScreenRect];
        self.brainImage.frame = CGRectMake(screenRect.size.width + brainWidthEnd, yEnd, brainWidthEnd, brainWidthEnd);
    }
    completion:nil];

#if 0
    //laugh
    //if([kHelpers randomBool])
    if(NO)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //if(!kAppDelegate.inReview)
            if(NO)
            {
                NSString* soundName = [@[@"sinistar1.caf", //beware i live
                                         @"sinistar2.caf", //run
                                         //@"sinistar3.caf", //rarrrrrr
                                         @"sinistar4.caf", //i hunger
                                         ] randomObject];

                [kAppDelegate playSound:soundName];
            }
        });
    }
#endif

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
}

-(void)stopCoins {
    [self.coinsImage.layer removeAllAnimations];
}

-(void)actionTimerCoins:(NSTimer *)incomingTimer
{
    [self showCoins];
}

-(void)showPoof
{
    self.poofImage.hidden = NO;
    self.poofImage.alpha = 0.0f;
    self.poofImage2.hidden = YES; //NO;
    self.poofImage2.alpha = 0.0f;

    CABasicAnimation *scale3;
    scale3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale3.fromValue = [NSNumber numberWithFloat:0.2f];
    scale3.toValue = [NSNumber numberWithFloat:3 ];
    scale3.duration = 0.8f;

    /*CABasicAnimation *scale4;
    scale4 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale4.fromValue = [NSNumber numberWithFloat:0.2f];
    scale4.toValue = [NSNumber numberWithFloat:2];
    scale4.duration = 1.0f; //0.8f;*/

    CABasicAnimation *alpha1;
    alpha1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha1.fromValue = [NSNumber numberWithFloat:1.0f];
    alpha1.toValue = [NSNumber numberWithFloat:0.0f];
    alpha1.duration = scale3.duration;

    /*CABasicAnimation *alpha2;
    alpha2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alpha2.fromValue = [NSNumber numberWithFloat:1.0f];
    alpha2.toValue = [NSNumber numberWithFloat:0.0f];
    alpha2.duration = scale4.duration;*/

    /*CABasicAnimation *rotate;
    rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotate.fromValue = [NSNumber numberWithFloat:0];
    rotate.toValue = [NSNumber numberWithFloat:(M_PI*2)/4];
    rotate.duration = 0.0f;*.


    [self.poofImage.layer removeAllAnimations];
    [self.poofImage.layer addAnimation:scale3 forKey:@"scale"];
    [self.poofImage.layer addAnimation:alpha1 forKey:@"opacity"];

    [self.poofImage2.layer removeAllAnimations];
    //[self.poofImage2.layer addAnimation:rotate forKey:@"rotate"];
    [self.poofImage2.layer addAnimation:scale4 forKey:@"scale"];
    [self.poofImage2.layer addAnimation:alpha2 forKey:@"opacity"];*/
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

-(void)setupMiniShines
{
    self.miniShineArray = [NSMutableArray array];
    //minishine
    int num = kNumMiniShines;
    for(int i=0; i<num; i++)
    {
        [self createMiniShine];
    }


    //miniCoins
    self.miniCoinArray = [NSMutableArray array];
    //if(self.isCoin || self.isPotion)
    if(self.isCoin)
    {
      num = kNumMiniShines;

      for(int i=0; i<num; i++)
      {
          [self createMiniCoin];
      }
    }

}

-(void) showMiniShines
{
    for(UIImageView *node in self.miniShineArray)
    {
        //front
        //[self.view bringSubviewToFront:node];
        //under block
        [node removeFromSuperview];
        [self.view insertSubview:node belowSubview:self.block];

        [node.layer removeAllAnimations];
        node.hidden = NO;
        node.userInteractionEnabled = NO;
        node.alpha = 0.0f;

        CGFloat margin = 20; //20

        node.x = margin + arc4random_uniform([kHelpers getScreenRect].size.width - margin*2);
        node.y = margin + arc4random_uniform([kHelpers getScreenRect].size.height - margin*2);

        CGFloat durationIn = 0.3f + arc4random_uniform(5)/10.f ;//0.5f;
        //CGFloat durationOut = 0.3f + arc4random_uniform(5)/10.f ;//0.5f;

        CABasicAnimation *scale3;
        scale3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale3.fromValue = [NSNumber numberWithFloat:1.4f ];
        scale3.toValue = [NSNumber numberWithFloat:0.6f];
        scale3.duration = durationIn;
        scale3.repeatCount = HUGE_VALF;
        scale3.autoreverses = YES;

        CABasicAnimation *alpha1;
        alpha1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alpha1.fromValue = [NSNumber numberWithFloat:0.0f];
        alpha1.toValue = [NSNumber numberWithFloat:0.8f];
        alpha1.duration = scale3.duration;
        alpha1.repeatCount = HUGE_VALF;
        alpha1.autoreverses = YES;


        [node.layer removeAllAnimations];
        [node.layer addAnimation:scale3 forKey:@"scale"];
        [node.layer addAnimation:alpha1 forKey:@"opacity"];
    }

    //and coins
    for(UIImageView *node in self.miniCoinArray)
    {
        //disabled
        //continue;

        //front
        //[self.view bringSubviewToFront:node];
        //under block
        [node removeFromSuperview];
        [self.view insertSubview:node belowSubview:self.block];

        [node.layer removeAllAnimations];
        node.hidden = NO;
        node.userInteractionEnabled = NO;
        CGFloat newAlpha = 0.8f;
        node.alpha = 0.0f; //newAlpha;

        CGFloat margin = 40; //20

        //close to block
        node.x = self.block.x - margin + arc4random_uniform(margin*2 + self.block.width);
        node.y = self.block.y - margin + arc4random_uniform(margin*2 + self.block.height);
        if([kHelpers isIpad])
        {
            //more left, higher
            node.x -= 40;
            node.y -= 20;
        }

        //everywhere
//        node.x = margin + arc4random_uniform([kHelpers getScreenRect].size.width - margin*2);
//        node.y = margin + arc4random_uniform([kHelpers getScreenRect].size.height - margin*2);


        CGFloat durationIn = 0.3f + arc4random_uniform(5)/10.f ;//0.5f;

        CABasicAnimation *scale3;
        scale3 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale3.fromValue = [NSNumber numberWithFloat:1.2]; //1.4f
        scale3.toValue = [NSNumber numberWithFloat:0.5]; //0.6f
        scale3.duration = durationIn;
        scale3.repeatCount = HUGE_VALF;
        scale3.autoreverses = YES;

        CABasicAnimation *alpha1;
        alpha1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        alpha1.fromValue = [NSNumber numberWithFloat:0.0f];
        alpha1.toValue = [NSNumber numberWithFloat:newAlpha];
        alpha1.duration = scale3.duration;
        alpha1.repeatCount = HUGE_VALF;
        alpha1.autoreverses = YES;

        [node.layer removeAllAnimations];
        [node.layer addAnimation:scale3 forKey:@"scale"];
        [node.layer addAnimation:alpha1 forKey:@"opacity"];
    }
}

-(void)hideMiniShines
{
  for(UIImageView *node in self.miniShineArray)
  {
      [node.layer removeAllAnimations];
      node.hidden = YES;
  }

  for(UIImageView *node in self.miniCoinArray)
  {
      [node.layer removeAllAnimations];
      node.hidden = YES;
  }
}


-(UIImageView*)createMiniShine
{
    UIImageView *node =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];

    NSString *name = @"ray8";

    node.image = [UIImage imageNamed:name];

    node.clipsToBounds = YES;
    node.contentMode = UIViewContentModeScaleAspectFit;

    node.alpha = 0.0f;
    //node.scale = 0.5f;
    //node.position = CGPointMake(0,0);

    //array
    [self.miniShineArray addObject:node];

    [self.view addSubview:node];

    return node;
}

-(UIImageView*)createMiniCoin
{
    UIImageView *node =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];

    NSString *name = nil;
    if(self.isCoin)
    {
        //name = [CBSkinManager getCoinBarImageName];
        name = [CBSkinManager getCoinImageName];
        name = [NSString stringWithFormat:@"%@%@", name, @"Frame1"];
    }
    else if (self.isPotion)
    {
        name = @"potion_win";
    }

    assert(name);

    node.image = [UIImage imageNamed:name];
    assert(node.image);

    node.clipsToBounds = YES;
    node.contentMode = UIViewContentModeScaleAspectFit;

    node.alpha = 0.0f;
    //node.scale = 0.5f;
    //node.position = CGPointMake(0,0);

    //array
    [self.miniCoinArray addObject:node];

    [self.view addSubview:node];

    return node;
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


-(void)showArrow {

    if(!self.tutoArrow.hidden)
        return;

    //only for block unlock
    if(!self.backToGame || self.newSkin == kCoinTypeNone)
        return;

    [self.tutoArrow.layer removeAllAnimations];

    //update constraints
    self.tutoArrow.translatesAutoresizingMaskIntoConstraints = YES;

    //show
    self.tutoArrow.hidden = NO;
    self.tutoArrow.alpha = 0.8f;

    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSNumber numberWithFloat:1.2f]; //1.0f
    scale.toValue = [NSNumber numberWithFloat:1.0f]; //0.8f
    scale.duration = 0.2f;
    scale.repeatCount = HUGE_VALF;
    scale.autoreverses = YES;

    [self.tutoArrow.layer addAnimation:scale forKey:@"scale"];

    //pos
    //self.tutoArrow.x = 20;
    //self.tutoArrow.y = 20;

    //self.arrowTopConstraint.constant = self.view.width/2 + 0;;
    //self.arrowLeftConstraint.constant = self.carousel.y + self.carousel.height/2 + 10;
}


@end
