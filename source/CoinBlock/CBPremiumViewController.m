//
//  CBPremiumViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBPremiumViewController.h"
//#import "CBSkinCell.h"
#import "CBConfettiView.h"
#import "UIButton+BadgeValue.h"
#import "NSAttributedString+DDHTML.h"

@interface CBPremiumViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *titleLabelImage;
@property (nonatomic, strong) IBOutlet UILabel *labelSubTitleTop;
@property (nonatomic, strong) IBOutlet UILabel *labelSubTitle;
@property (nonatomic, strong) IBOutlet UILabel *saleLabel;
@property (nonatomic, strong) IBOutlet UIImageView *block;
@property (nonatomic, strong) IBOutlet UIImageView *shield;
@property (nonatomic, strong) IBOutlet UIImageView *clock;
@property (nonatomic, strong) IBOutlet UIImageView *x2;
@property (nonatomic, strong) IBOutlet UIImageView *enemies;
@property (nonatomic, strong) IBOutlet UIButton *blockButton;
@property (nonatomic, strong) IBOutlet ZCAnimatedLabel *labelSubTitle2;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton2;
@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (nonatomic, strong) IBOutlet UIImageView *shineImageView;
@property (nonatomic, strong) IBOutlet UIImageView *cloud1;
@property (strong, nonatomic) NSTimer *timerCloud;
@property (strong, nonatomic) NSTimer *timerVCR;
@property (strong, nonatomic) NSMutableArray *imageArray1;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;
@property (nonatomic, strong) IBOutlet UIImageView *vcr;
@property (weak, nonatomic) IBOutlet UIImageView *coinsImage;
@property (weak, nonatomic) IBOutlet UIImageView *premiumBadge;
@property (nonatomic, strong) NSMutableArray *miniShineArray;

//@property (strong, nonatomic) SIAlertView *alertView;

@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;
@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;

@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIButton *restoreButton;

@property (strong, nonatomic) NSTimer *timerPulse;
@property (strong, nonatomic) NSTimer *timerShield;
@property (strong, nonatomic) NSTimer *timerCoins;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *subTitleTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blockTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unlockBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *restoreBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backButtonConstraint;

- (IBAction)actionShare:(id)sender;
- (IBAction)actionRate:(id)sender;
- (IBAction)actionStore:(id)sender;
- (IBAction)actionContinue:(id)sender;
- (IBAction)actionRestore:(id)sender;

- (IBAction)actionBack:(id)sender;

- (IBAction)premiumButtonPressed:(id)sender;

@end

#define kTitleSpacingAfter 20
#define kTitleSpacingBefore 130

@implementation CBPremiumViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [kAppDelegate scaleView:self.view];

    [self setupFade];
    [self bringSubviewsToFront];

    [kHelpers loopInBackground];

    //corner
    [kAppDelegate cornerView:self.view];

    [UIView setAnimationsEnabled:NO];

    self.backgroundImageView.image = [UIImage imageNamed:@"background_levelup"];

    //kAppDelegate.storeController = self;

    self.miniShineArray = [NSMutableArray array];
    //minishine
    for(int i=0; i<kNumMiniShines; i++)
    {
        [self createMiniShine];
    }

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;
    self.cloud1.image = [UIImage imageNamed:kCloudName];

    [self setupAnimations];


    //dark
    self.darkImage.alpha = 0;

    //rays
    self.shineImageView.alpha = 0.2f;

    [self setupConfetti];
    [self setupWhiteBar];

    [self updateText];

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
    int shadowOffset = 3;
    UIColor *shadowColor = kTextShadowColor;

    self.titleLabel.shadowColor = shadowColor;
    self.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    //image instead of text
    self.titleLabel.hidden = YES;
    self.titleLabelImage.hidden = NO;

    UIColor* continueColor = [UIColor colorWithHex:0x12c312];

    //buttons
    self.continueButton.titleLabel.font = [UIFont fontWithName:kFontName size:15*kFontScale];
    self.restoreButton.titleLabel.font = [UIFont fontWithName:kFontName size:12*kFontScale];

    float inset = 6.0f;
    [self.continueButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    //[self.continueButton setTitleColor:[continueColor colorWithAlphaComponent:1.0f] forState:UIControlStateNormal];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.restoreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.restoreButton.alpha = 0.6f;

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
    self.continueButton.clipsToBounds = NO;
    self.continueButton.titleLabel.clipsToBounds = NO;
    self.continueButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.continueButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.continueButton.titleLabel.layer.shadowRadius = 0.0f;
    self.continueButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.continueButton.titleLabel.layer.masksToBounds = NO;
    self.continueButton.backgroundColor = [continueColor colorWithAlphaComponent:0.6f];

    l = [self.continueButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[[continueColor colorWithAlphaComponent:0.6f] CGColor]];

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

-(void)setupAnimations
{
    UIImage *tempImage = nil;

    NSMutableArray *allEnemiesNames = [[CBSkinManager getFireballArrayWithLevel:100 all:YES] mutableCopy];

    NSArray *spikeArray = [CBSkinManager getSpikeArrayWithLevel:100 all:YES];

    [allEnemiesNames addObjectsFromArray:spikeArray];

    //remove duplicates
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:allEnemiesNames];
    allEnemiesNames = [[orderedSet array] mutableCopy];

    if(kAppDelegate.inReview)
    {
        [allEnemiesNames removeObject:@"fireball1Frame1"]; //mario?
        [allEnemiesNames removeObject:@"fireball18Frame1"]; //turtle green

        [allEnemiesNames removeObject:@"fireball23Frame1"]; //barrel

        [allEnemiesNames removeObject:@"fireball24Frame1"]; //cactus

        //[allEnemiesNames removeObject:@"fireball19Frame1"]; //spikes metal white
        //[allEnemiesNames removeObject:@"fireball20Frame1"]; //turtle red

        [allEnemiesNames removeObject:@"spike9"]; //spike pipe green
        [allEnemiesNames removeObject:@"spike7"]; //sword
    }

    //enemies images
    NSMutableArray *allEnemies = [NSMutableArray array];
    for(__strong NSString *tempName in allEnemiesNames) //strong to make it modifiable
    {
        //fireball
        if([tempName contains:@"fire"])
        {
            tempName = [tempName stringByAppendingString:@"Frame1"];
        }
        UIImage *tempImage = [UIImage imageNamed:tempName];
        [allEnemies addObject:tempImage];
    }

    self.enemies.animationImages = [allEnemies shuffledArray];
    self.enemies.animationRepeatCount = 0;
    self.enemies.animationDuration = self.enemies.animationImages.count * kTitleRandomAnimationSpeed * 2.0f * 1.1f; //random
    [self.enemies startAnimating];
    self.enemies.alpha = 0.0f;


    //blocks
    NSMutableArray *allImages = [NSMutableArray array];

    //just premium
    if(!kAppDelegate.inReview)
    {
        tempImage = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:kCoinTypeMario]];
        [allImages addObject:tempImage];
    }

    tempImage = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:kCoinTypeMine]];
    [allImages addObject:tempImage];
    tempImage = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:kCoinTypeBitcoin]];
    [allImages addObject:tempImage];
    tempImage = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:kCoinTypeYoshi]];
    [allImages addObject:tempImage];
    tempImage = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:kCoinTypeGameboy]];
    [allImages addObject:tempImage];
    tempImage = [UIImage imageNamed:[CBSkinManager getBlockImageNameIndex:kCoinTypeTA]];
    [allImages addObject:tempImage];

    self.block.animationImages = [allImages shuffledArray];
    self.block.animationRepeatCount = 0;
    self.block.animationDuration = self.block.animationImages.count * kTitleRandomAnimationSpeed * 2.0f;
    [self.block startAnimating];
    self.block.alpha = 0.0f;

    //heart
    self.shield.image = [UIImage imageNamed:@"power_up_heart"];

    //clock
    self.clock.image =  [UIImage imageNamed:@"power_up_star"];

    [allImages removeAllObjects];
    for(int i=0;i<kPowerUpTypeCount;i++) {

        //skip heart
        if(i == kPowerUpTypeHeart)
            continue;

        tempImage = [CBSkinManager getPowerupSquareImage:i];
        assert(tempImage);
        [allImages addObject:tempImage];
    }

    self.clock.animationImages = [allImages shuffledArray];

    self.clock.animationRepeatCount = 0;
    self.clock.animationDuration = self.clock.animationImages.count * kTitleRandomAnimationSpeed * 2.0f * 0.9f; //random
    [self.clock startAnimating];


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

    if([kHelpers isIphone4Size])
    {
        //small iphone, ipad
        self.titleTopConstraint.constant = -10;
        self.subTitleTopConstraint.constant = 5; //10
        self.textTopConstraint.constant = -10;
        self.blockTopConstraint.constant = -20;

        self.unlockBottomConstraint.constant = 70;
        self.restoreBottomConstraint.constant = 4;
    }
    else if([kHelpers isIphoneX])
    {
        self.titleTopConstraint.constant = 14;
        self.subTitleTopConstraint.constant = 15; //20
        self.textTopConstraint.constant = 4;
        self.blockTopConstraint.constant = 2;

        self.unlockBottomConstraint.constant = 100;
        self.restoreBottomConstraint.constant = 20;

        self.backButtonConstraint.constant = 11+kiPhoneXTopSpace;

    }
    else
    {
        self.titleTopConstraint.constant = 14;
        self.subTitleTopConstraint.constant = 15; //20
        self.textTopConstraint.constant = 4;
        self.blockTopConstraint.constant = 2;

        self.unlockBottomConstraint.constant = 80;
        self.restoreBottomConstraint.constant = 10;
    }
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self enableButtons:NO];

    [self setupAnimations];

    [self updateText];

    [self setupFade];

    [self updateSaleLabel];

    if([kAppDelegate isPremium])
    {
        [self showMiniShines];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];


    //__weak typeof(self) weakSelf = self;


    //offline
    /*if(![kHelpers checkOnline]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        return;
    }*/


    SKProduct *product = nil;
    NSString *whichProduct = [kAppDelegate isPremiumIAPOnSale] ? kIAP_NoAds : kIAP_NoAds2;
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

    //title, no used, hidden
    self.titleLabel.text = @"Go VIP!"; //@"Go Deluxe!"; //@"Go Premium!";

    [self updateContinueButton];

    self.vcr.hidden = YES;
    self.vcr.alpha = 0.0f;
    [self.vcr startAnimating];

        //update time
    [kAppDelegate updateForegroundTime];

    //setup

    [self enableButtons:YES];

    //no back
//    self.backButton.hidden = YES;
//    self.backButton2.hidden = YES;

    //state
    kAppDelegate.titleController.menuState = menuStatePremium;

    [kHelpers setupGoogleAnalyticsForView:[[self class] description]];

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    //music
    //[kAppDelegate playMusic:kMusicNameOptions andRemember:YES];

    [self showCoins];

    [self startConfetti];
    //dont stop
//    float secs = 10.0f;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [self stopConfetti];
//    });


    [self updateUI];

    [self showWhiteBar];

    [self setupPremium];

    [kAppDelegate dbIncPremium];

    float secs = 0.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        [kAppDelegate playMusic:[CBSkinManager getLevelupMusicName] andRemember:YES];

    });

}

-(void)updateSaleLabel
{
    if([kAppDelegate isPremiumIAPOnSale] && ![kAppDelegate isPremium])
    {
        NSDate *dateExpire = [kAppDelegate.firstLaunchDate dateByAddingDays:kNumDaysPremiumSale];

        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:dateExpire];
        interval = ABS(interval);

        //NSDate *dateEmpty = [[NSDate alloc] init];
        //NSDate *date = [[NSDate alloc] initWithTimeInterval:interval sinceDate:dateEmpty];

        //NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        //[calendar setLocale:[NSLocale currentLocale]];
        //NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];

        //1.
        //NSString *tempString = [NSString stringWithFormat:@"%02d:%02d:%02d:%02d", (int)[components day], (int)[components hour], (int)[components minute], (int)[components second]];

        //2.
//        NSDateComponentsFormatter *formatter = [[NSDateComponentsFormatter alloc] init];
//        formatter.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated; //NSDateComponentsFormatterUnitsStyleFull;
//        NSString *tempString2 = [formatter stringFromTimeInterval:interval];
//        NSString *tempString3 = [NSString stringWithFormat:@"Hurry, only %@ left!", tempString2];

        //3.
//        int minutes = (int)(interval / (60.0f));
//        int hours = (int)(minutes / 60);
//        minutes -= hours*60;

        NSInteger minutes =( (int)(interval / 60.0f)) % 60;
        NSInteger hours = (interval / 3600.0f);
        //NSString *tempString4 = [NSString stringWithFormat:@"Hurry, offer ends in %dh %dm!", (int)hours, (int)minutes];
        //NSString *tempString4 = [NSString stringWithFormat:@"Ends in %dh %dm", (int)hours, (int)minutes];
        NSString *tempString4 = [NSString stringWithFormat:@"Limited time offer ends in %dh %dm", (int)hours, (int)minutes];

        self.saleLabel.text = tempString4;
        self.saleLabel.hidden = NO;

        //color1
        //BOOL soon = (interval < 60*60*24); //1 day
        BOOL soon = (interval < 60*60*2); //2h
        //force
        //soon = YES;

        if(soon)
            //self.saleLabel.textColor = [UIColor colorWithHex:0xc60c0c]; //red
            self.saleLabel.textColor = [UIColor colorWithHex:0xff8000]; //orange
        else
          self.saleLabel.textColor = [UIColor whiteColor]; //[UIColor colorWithHex:0xaaaaaa]; //RGB(240,240,240);

        //bounce
        //[kAppDelegate animateControl:self.saleLabel];
    }
    else
    {
        self.saleLabel.text = @"";
        self.saleLabel.hidden = YES;
    }
}

-(void)updateText
{
    if([kAppDelegate isPremium])
    {
        self.labelSubTitleTop.text = @"<color1>VIP</color1> mode is <color1>unlocked</color1>!";
    }
    else
    {
        self.labelSubTitleTop.text = @"Unlock <color1>VIP</color1> mode now to get:";
    }

    self.labelSubTitleTop.hidden = NO;
    self.labelSubTitle.hidden = NO;
    self.labelSubTitle2.hidden = YES;

    BOOL isIphone4Size = [kHelpers isIphone4Size];

    //labels
    self.titleLabel.font = [UIFont fontWithName:kFontNameBlocky size:(isIphone4Size?18:24)*kFontScale];
    self.titleLabel.textColor = kYellowTextColor;
    //disabled
    //self.titleLabel.hidden = YES;

    //title
    self.labelSubTitle.textColor = [UIColor whiteColor]; //[UIColor colorWithHex:0xaaaaaa]; //RGB(240,240,240);
    self.labelSubTitle.font = [UIFont fontWithName:kFontName size:(isIphone4Size?12:14)*kFontScale];
    self.labelSubTitle.alpha = 0.9f;
    self.labelSubTitle.numberOfLines = 0;
    self.labelSubTitle.text = LOCALIZED(@"kStringIAPMessageNoAds");

    self.labelSubTitleTop.textColor = [UIColor whiteColor];
    self.labelSubTitleTop.font = [UIFont fontWithName:kFontName size:14*kFontScale];
    self.labelSubTitleTop.alpha = 0.9f;
    self.labelSubTitleTop.numberOfLines = 0;


    //color text
    NSString *tempString = [kHelpers colorString:self.labelSubTitle.text];
    NSAttributedString *attrString = [NSAttributedString attributedStringFromHTML:tempString
                                                                       normalFont:self.labelSubTitle.font
                                                                         boldFont:self.labelSubTitle.font
                                                                       italicFont:self.labelSubTitle.font];
    //align center or left, main text
    tempString = attrString.string;
    NSMutableAttributedString *attrString2 = [attrString mutableCopy];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    //[paragraphStyle setAlignment:NSTextAlignmentCenter];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [attrString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempString length])];
    self.labelSubTitle.attributedText = attrString2;


    //sub title
    tempString = [kHelpers colorString:self.labelSubTitleTop.text];
    attrString = [NSAttributedString attributedStringFromHTML:tempString
                                                   normalFont:self.labelSubTitle.font
                                                     boldFont:self.labelSubTitle.font
                                                   italicFont:self.labelSubTitle.font];
    //center
    tempString = attrString.string;
    attrString2 = [attrString mutableCopy];
    paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attrString2 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [tempString length])];
    self.labelSubTitleTop.attributedText = attrString2;


    //self.labelSubTitle2 = [[ZCAnimatedLabel alloc] initWithFrame:self.labelSubTitle.frame];
    //[self.view addSubview:self.labelSubTitle2];


    //sale
    self.saleLabel.textColor = [UIColor whiteColor]; //[UIColor colorWithHex:0xaaaaaa]; //RGB(240,240,240);
    self.saleLabel.font = [UIFont fontWithName:kFontName size:11*kFontScale];
    self.saleLabel.alpha = 0.8f;
    self.saleLabel.numberOfLines = 1;
    self.saleLabel.text = @"";
}

-(void)updateContinueButton
{
    SKProduct *product = nil;
    NSString *whichProduct = [kAppDelegate isPremiumIAPOnSale] ? kIAP_NoAds : kIAP_NoAds2;
    //find product
    for(SKProduct *tempProduct in [IAPShare sharedHelper].iap.products) {
        //for(SKProduct *tempProduct in kAppDelegate.iapProducts) {
        if([tempProduct.productIdentifier isEqualToString:whichProduct]) {
            product = tempProduct;
            break;
        }
    }


    NSString *okString = nil;

    if(![kAppDelegate isPremium])
    {
        if([product priceAsString]) {
            //okString = [NSString stringWithFormat:@"Unlock %@", [product priceAsString]];
            okString = [NSString stringWithFormat:@"Unlock now! %@", [product priceAsString]];
        }
        else
        {
            okString = [NSString stringWithFormat:@"Unlock"];
        }

        self.continueButton.enabled = YES;

    }
    else
    {
        okString = [NSString stringWithFormat:@"Unlocked"];

        self.continueButton.enabled = YES;
    }


    [self.continueButton setTitle:okString forState:UIControlStateNormal];

    //spacing
    NSString *tempTitle = nil;
    NSMutableAttributedString *attributedString = nil;
    float spacing = 2.0f;

    tempTitle = okString; //self.continueButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.continueButton setAttributedTitle:attributedString forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //[kAppDelegate playSound:@"alertchat.caf"];
    });

    [self enableButtons:YES];

    kAppDelegate.touchedPremium = YES;
    //kAppDelegate.fromWin = YES;

	///animate
    //self.labelSubTitle2.animationDuration = 0.5f;
    //self.labelSubTitle2.animationDelay = 0.04f; //0.04f;

    //self.labelSubTitle2.text = self.labelSubTitle.text;
    //self.labelSubTitle2.font = self.labelSubTitle.font;
    //self.labelSubTitle2.textColor = self.labelSubTitle.textColor;

//    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
//    //style.lineSpacing = 1;
//    style.alignment = NSTextAlignmentCenter;
//    NSDictionary *attrsDictionary = @{NSFontAttributeName : self.labelSubTitle.font, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : self.labelSubTitle.textColor};
//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.labelSubTitle.text attributes:attrsDictionary];
//    [self.labelSubTitle2 setAttributedString:attrString];
//    [self.labelSubTitle2 startAppearAnimation];

    //__weak typeof(self) weakSelf = self;

    //give time to layout
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self resetTimer];

        //[kAppDelegate playSound:kUnlockSound];
    });


    //title
//    self.labelSubTitle.hidden = NO;
//    self.labelSubTitleTop.hidden = NO;

	self.labelSubTitle.alpha = 1.0f; //0.9f;
	self.labelSubTitleTop.alpha = 1.0f;
	self.block.alpha = 1.0f;
	self.enemies.alpha = 1.0f;
	self.coinsImage.alpha = 1.0;
	self.continueButton.alpha = 1.0;
	self.restoreButton.alpha = 0.6f;

    //wobble
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        if(![kAppDelegate isPremium])
        {
            [kAppDelegate animateControl:self.continueButton];
        }
    });

    //rotate
    [self addShineAnimation];

    //state
    kAppDelegate.launchInGame = NO;
    [kAppDelegate saveState];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self enableButtons:NO];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];

    //reset
    kAppDelegate.worldTimeLeft = [CBSkinManager getWorldTime];
    kAppDelegate.starLevelCount = 0;
    kAppDelegate.prefLevelNumFireballsTouched = 0;
    //[kAppDelegate saveState];

    [self stopConfetti];
    [self stopCoins];
    [self stopWhiteBar];
    [self hideMiniShines];

    //[self.shineImageView.layer removeAllAnimations];

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    [self.timerVCR invalidate];
    self.timerVCR = nil;
    self.vcr.hidden = YES;

    [self.timerCloud invalidate];
    self.timerCloud = nil;

    [self.timerShield invalidate];
    self.timerShield = nil;

    [self.timerPulse invalidate];
    self.timerPulse = nil;

    [self.timerCoins invalidate];
    self.timerCoins = nil;

    [self.shineImageView.layer removeAllAnimations];
    [self.premiumBadge.layer removeAllAnimations];
    [self.x2.layer removeAllAnimations];
    //[self.enemies.layer removeAllAnimations];
    //[self.shield.layer removeAllAnimations];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [self.shineImageView.layer removeAllAnimations];

    [self.cloud1.layer removeAllAnimations];
    self.cloud1.alpha = 0.0f;
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    //reset
    [self.labelSubTitle2 startDisappearAnimation];

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

    self.continueButton.enabled = enable;
    self.restoreButton.enabled = enable;
    self.blockButton.enabled = enable;

    self.continueButton.alpha = enable?1.0f:0.5f;

    //disabled
    //self.blockButton.enabled = NO;
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

    [self adButtonPressed:sender];
}

- (void) actionRestore:(id)sender {
    [self restoreButtonPressed:sender];
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

        [kAppDelegate restoreFromPayment:payment];

        //success
        if(payment.transactions.count > 0 && !error) {
            [kHelpers showMessageHud:LOCALIZED(@"kStringIAPRestoreSuccess")];

            float secs = kConfettiThanksDuration;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                //[self stopConfetti];

                [self actionBack:nil];

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


- (void) actionBack:(id)sender {

    if(!self.curtainLeft.hidden)
        return;

    [kAppDelegate animateControl:self.backButton];
    [kAppDelegate animateControl:self.backButton2];

    if(sender)
        [kAppDelegate playSound:kClickSound];

    [self enableButtons:NO];

    [self fadeIn];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        if(self.backToGame) {
            //[kAppDelegate setViewController:kAppDelegate.transitionController];
            [kAppDelegate setViewController:kAppDelegate.transitionController];
        }
        else {
            [kAppDelegate setViewController:kAppDelegate.titleController];
        }


    });
}

-(void)bringSubviewsToFront
{
    //top
    [self.view bringSubviewToFront:self.coinsImage];
    [self.view bringSubviewToFront:self.curtainLeft];
    [self.view bringSubviewToFront:self.curtainRight];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.vcr];
    [self.view bringSubviewToFront:self.scanline];
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

    //disabled
    //return;

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
                     }];
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


    //scale
    /*

    CABasicAnimation *scale;
    scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.fromValue = [NSNumber numberWithFloat:1.05f];
    scale.toValue = [NSNumber numberWithFloat:1.0f];
    scale.duration = 0.3f;
    scale.repeatCount = HUGE_VALF;
    scale.autoreverses = YES;

    [self.x2.layer removeAllAnimations];
    [self.x2.layer addAnimation:scale forKey:@"scale"];

    //[self.enemies.layer removeAllAnimations];
    /[self.enemies.layer addAnimation:scale forKey:@"scale"];

//    [self.shield.layer removeAllAnimations];
//    [self.shield.layer addAnimation:scale forKey:@"scale"];
     */

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

    if([kAppDelegate isPremium])
    {
        [self showMiniShines];
    }
}


- (void)notifyBackground
{
    //only for iOS7
    //if(kIsIOS8)
    //    return;

    //fix crash
    [self.shineImageView.layer removeAllAnimations];

    [self.premiumBadge.layer removeAllAnimations];

    //[self.x2.layer removeAllAnimations];

    //[self.enemies.layer removeAllAnimations];

    //[self.shield.layer removeAllAnimations];

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

    //pulse
    [self.timerPulse invalidate];
    self.timerPulse = nil;

    interval = 1.0f;
    self.timerPulse = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerPulse:) userInfo:@"actionTimerPulse" repeats:YES];

    //title
    [self.timerShield invalidate];
    self.timerShield = nil;
    interval = 1.0f; //kFlashArrowsInterval * 2;
    self.timerShield = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerShield:) userInfo:@"actionTimerShield" repeats:YES];

    interval = 15.0f;
    [self.timerCoins invalidate];
    self.timerCoins = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                     selector:@selector(actionTimerCoins:) userInfo:@"actionTimerBg" repeats:YES];

}

- (void) actionTimerShield:(NSTimer *)incomingTimer
{
    if(kAppDelegate.titleController.menuState != menuStatePremium || (self.view.hidden == YES))
        return;

    //Log(@"actionTimerShield");
    [kAppDelegate animateControl:self.shield];
    [kAppDelegate animateControl:self.clock];
    [kAppDelegate animateControl:self.x2];
    [kAppDelegate animateControl:self.block];
    [kAppDelegate animateControl:self.enemies];


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

    if(kAppDelegate.titleController.menuState != menuStatePremium || (self.view.hidden == YES))
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
    if(kAppDelegate.titleController.menuState != menuStatePremium || (self.view.hidden == YES))
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


- (IBAction)rateButtonPressed:(id)sender
{
    //[kAppDelegate playSound:kClickSound];
    [kAppDelegate playSound:@"kiss.caf"];

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

        //kAppDelegate.skinController.backToGame = YES;
		//		[kAppDelegate setViewController:kAppDelegate.skinController];
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



- (void)updateUI {

    [self.backButton setBackgroundImage:nil forState:UIControlStateNormal];

	//back button
	UIImage *backImage = self.backToGame ? [UIImage imageNamed:@"podium2"] : [UIImage imageNamed:@"podium7"];
	[self.backButton setImage:backImage forState:UIControlStateNormal];
}

- (void) actionTimerPulse:(NSTimer *)incomingTimer
{
    if(![kAppDelegate isPremium])
    {
        [kAppDelegate animateControl:self.continueButton];
    }

    //update title
    [self updateContinueButton];

    [self updateSaleLabel];
}

- (IBAction)premiumButtonPressed:(id)sender
{
    [self adButtonPressed:sender];
}

-(void)purchaseSuccessful
{
    //good
    [kAppDelegate restoreVIPSuccessful];

    [self updateUI];

    [kAppDelegate.gameScene updateAll];

    [kAppDelegate playSound:kUnlockSound];
    [kAppDelegate playSound:kUnlockSound2];

    [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
    [self startConfetti];
    float secs = kConfettiThanksDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopConfetti];
        [self actionBack:nil];
    });

    //achievement
    [kAppDelegate reportAchievement:kAchievement_vip];

    if([kAppDelegate isPremium])
    {
        [self showMiniShines];
    }

}

- (IBAction)adButtonPressed:(id)sender
{
    if([kAppDelegate isPremium])
    {
        [self actionBack:sender];
        return;
    }

    [self enableButtons:NO];


    [kAppDelegate playSound:kClickSound];


    [kAppDelegate animateControl:self.continueButton];

    //
    //offline
    if(![kHelpers checkOnline]) {
        [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
        [self enableButtons:YES];
        return;
    }

    SKProduct *product = nil;
    NSString *whichProduct = [kAppDelegate isPremiumIAPOnSale] ? kIAP_NoAds : kIAP_NoAds2;
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

       if(kAppDelegate.premiumFake)
       {
           //fake
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
               [self purchaseSuccessful];
           });

       }
       else
       {
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
                                                  //save
                                                  [[IAPShare sharedHelper].iap provideContentWithTransaction:trans];

                                                  //good
                                                  [self purchaseSuccessful];
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
   }
   else {
	   [kAppDelegate getIAP];
	   [kHelpers showErrorHud:LOCALIZED(@"kStringIAPUnknownError")];
	   [self enableButtons:YES];

   }

}

-(void)setupPremium
{
    if(![kAppDelegate isPremium])
    {
        //animate badge
        CABasicAnimation *scale2;
        scale2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scale2.fromValue = [NSNumber numberWithFloat:1.5f]; //1.0f
        scale2.toValue = [NSNumber numberWithFloat:1.2f]; //0.8f
        scale2.duration = 0.3f;
        scale2.repeatCount = HUGE_VALF;
        scale2.autoreverses = YES;
        [self.premiumBadge.layer removeAllAnimations];
        [self.premiumBadge.layer addAnimation:scale2 forKey:@"scale"];
        //self.premiumBadge.image = [UIImage imageNamed:@"badge2"]; //@"premiumBadge2";

        self.premiumBadge.hidden = ![kAppDelegate isPremiumIAPOnSale];
    }
    else
    {
        self.premiumBadge.hidden = YES;
    }
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


-(void) showMiniShines
{
    for(UIImageView *node in self.miniShineArray)
    {
        //front
        [self.view bringSubviewToFront:node];

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

        /*[CATransaction setCompletionBlock:^{
         node.x = margin + arc4random_uniform(self.view.frame.size.width - margin*2);
         node.y = margin + arc4random_uniform(self.view.frame.size.height - margin*2);
         }];*/


        [node.layer removeAllAnimations];
        [node.layer addAnimation:scale3 forKey:@"scale"];
        [node.layer addAnimation:alpha1 forKey:@"opacity"];



        /*

         //fade
         SKAction *fade0 = [SKAction fadeAlphaTo:0.8f duration:durationIn];//in
         SKAction *fade1 = [SKAction waitForDuration:0.1f];
         SKAction *fade2 = [SKAction fadeAlphaTo:0.0f duration:durationOut];//out
         SKAction * actionSequenceFade = [SKAction sequence:@[positionAction, fade0,fade1,fade2]];
         [node runAction:[SKAction repeatActionForever:actionSequenceFade] withKey:@"miniShineFade"];

         //rotate, random duration
         SKAction *oneRevolutionKey = [SKAction rotateByAngle:-M_PI*2 duration: 4+arc4random_uniform(6)];
         SKAction *repeatKey = [SKAction repeatActionForever:oneRevolutionKey];
         [node runAction:repeatKey];

         //scale
         //node.xScale = 0.5f;
         //node.yScale = 0.5f;

         CGFloat newScale = 1.2f;
         CGFloat oldScale = 0.6f;

         //scale
         SKAction *action0 = [SKAction scaleTo:newScale duration:durationIn];//in
         SKAction *action1 = [SKAction waitForDuration:0.1f];
         SKAction *action2 = [SKAction scaleTo:oldScale duration:durationOut];//out
         SKAction * actionSequence = [SKAction sequence:@[action0,action1,action2]];
         [node runAction:[SKAction repeatActionForever:actionSequence] withKey:@"miniShineScale"];
         */
    }
}

-(void)hideMiniShines
{
    for(UIImageView *node in self.miniShineArray)
    {
        [node.layer removeAllAnimations];
        node.hidden = YES;
    }
}


-(UIImageView*)createMiniShine
{
    UIImageView *node =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,50,50)];
    node.image = [UIImage imageNamed:@"ray8"];
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

@end
