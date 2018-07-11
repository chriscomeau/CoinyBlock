//
//  CBCheatViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBCheatViewController.h"
//#import "CBSkinCell.h"
#import "CBConfettiView.h"
#import "UAObfuscatedString.h"

@interface CBCheatViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
//@property (strong, nonatomic) IBOutlet ZCAnimatedLabel *descLabel2;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
//@property (strong, nonatomic) IBOutlet ZCAnimatedLabel *resultLabel2;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton2;
@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (nonatomic, strong) IBOutlet UIImageView *backTop;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *shineImageView;
@property (nonatomic, strong) IBOutlet UIImageView *cloud1;
@property (strong, nonatomic) NSTimer *timerCloud;
@property (strong, nonatomic) NSMutableArray *imageArray1;
@property (nonatomic) int selectedSkin;
@property (nonatomic) int leaving;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;

@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;
@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UIImageView *questionMark;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic, strong) IBOutlet UIButton *continueButton;
@property (nonatomic) BOOL sharing;
@property (nonatomic) BOOL boolTimerLabelResult;
@property (nonatomic) BOOL flashTimer;
@property (nonatomic) BOOL correct;
@property (strong, nonatomic) NSTimer *timerLabelResult;

- (IBAction)actionBack:(id)sender;
- (IBAction)actionContinue:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;

@end


@implementation CBCheatViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupFade];
    [self bringSubviewsToFront];

    [kAppDelegate scaleView:self.view];

    [kHelpers loopInBackground];

    //dark keyboard
    [[UITextField appearance] setKeyboardAppearance:UIKeyboardAppearanceDark];


    //corner
    [kAppDelegate cornerView:self.view];

    [UIView setAnimationsEnabled:NO];

    //kAppDelegate.storeController = self;

    //text
    self.textField.delegate = self;
    self.textField.font = [UIFont fontWithName:kFontName size:24];

    self.textField.height += 10;

	self.textField.keyboardType = UIKeyboardTypeDefault;
    self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo; //UITextAutocorrectionTypeDefault;
    //self.textField.tintColor = [UIColor colorWithHex:0x72be89];
    self.textField.textColor = RGB(100.0f,100.0f,100.0f); //RGB(50.0f,50.0f,50.0f); //gray
    self.textField.tintColor = RGB(200.0f,200.0f,200.0f); //light gray
	self.textField.secureTextEntry = NO; //YES; //password

    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.clearButtonMode = UITextFieldViewModeNever;

    self.questionMark.hidden = NO;

    //table
    self.tableView.backgroundColor = [UIColor clearColor];
    //separator
    self.tableView.separatorColor = [UIColor clearColor]; //RGBA(255,255,255, 0.5f);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    //disabled
    self.tableView.hidden = YES;

    //padding
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;
    self.cloud1.image = [UIImage imageNamed:kCloudName];

    //dark
    self.darkImage.alpha = 0;

    //rays
    self.shineImageView.alpha = 0.2f;

    [self setupConfetti];
    [self setupWhiteBar];

    //labels
    self.titleLabel.text = @"Cheat Codes";
    //self.titleLabel.font = [UIFont fontWithName:kFontName size:16*kFontScale]; //20
    self.titleLabel.font = [UIFont fontWithName:kFontNameBlocky size:16*kFontScale]; //20

    self.titleLabel.textColor = kYellowTextColor;


    self.descLabel.text = @"Hello! You found my shop of\nstrange and wonderful things."; //@"It's a secret to\neverybody.";
    self.descLabel.font = [UIFont fontWithName:kFontName size:16*kFontScale]; //20
    self.descLabel.textColor = kYellowTextColor;
    self.descLabel.numberOfLines = 0;
    self.descLabel.alpha = 1.0f;
    self.descLabel.hidden = NO;

    //animated
    /*self.descLabel2 = [[ZCAnimatedLabel alloc] initWithFrame:self.descLabel.frame];
    self.descLabel2.text = self.descLabel.text;
    self.descLabel2.alpha = self.descLabel.alpha;
    self.descLabel2.font = self.descLabel.font;
    self.descLabel2.textColor = self.descLabel.textColor;
    self.descLabel2.hidden = NO;
    [self.view addSubview:self.descLabel2];
    [self.view bringSubviewToFront:self.descLabel2];*/


	//result
    self.resultLabel.text = @""; //LOCALIZED(@"kStringGoodCheat"); //kStringInvalidCheat
    self.resultLabel.font = [UIFont fontWithName:kFontName size:16*kFontScale]; //20
    //self.resultLabel.textColor = [UIColor colorWithHex:0x1eff00]; //green;
    self.resultLabel.numberOfLines = 0;
    self.resultLabel.alpha = 1.0f;
    self.resultLabel.hidden = YES;

    //animated
    /*self.resultLabel2 = [[ZCAnimatedLabel alloc] initWithFrame:self.resultLabel.frame];
    self.resultLabel2.text = self.resultLabel.text;
    self.resultLabel2.alpha = self.resultLabel.alpha;
    self.resultLabel2.font = self.resultLabel.font;
    self.resultLabel2.textColor = self.resultLabel.textColor;
    self.resultLabel2.hidden = NO;
    [self.view addSubview:self.resultLabel2];
    [self.view bringSubviewToFront:self.resultLabel2];*/

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


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];

    [UIView setAnimationsEnabled:YES];

    [kAppDelegate doneNotification:nil];


    [self.textField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];

    //force cheat
    /*
    if([kHelpers isDebug]) {
        [self checkCode:kCheatOnLoad load:YES];
    }
    */


    self.continueButton.hidden = YES;

    [self.continueButton setTitle:@"Back" forState:UIControlStateNormal];

#if 1 //gray button

    int buttonCornerRadius = 10;
    int buttonBorderWidth = 2;
    UIColor *buttonColor = RGBA(0,0,0, 0.3f); //RGBA(255,255,255, 0.1f);
    UIColor *borderColor = kYellowTextColor;

    self.continueButton.titleLabel.font = [UIFont fontWithName:kFontName size:13*kFontScale];

    float inset = 6.0f;

    [self.continueButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];

    [self.continueButton setTintColor:kYellowTextColor];

    [self.continueButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];

    //about
    //[self.continueButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    //self.continueButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.continueButton.clipsToBounds = NO;
    self.continueButton.titleLabel.clipsToBounds = NO;
    self.continueButton.titleLabel.layer.shadowColor = shadowColor.CGColor;
    self.continueButton.titleLabel.layer.shadowOpacity = 1.0f;
    self.continueButton.titleLabel.layer.shadowRadius = 0.0f;
    self.continueButton.titleLabel.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
    self.continueButton.titleLabel.layer.masksToBounds = NO;
    self.continueButton.backgroundColor = buttonColor;

    CALayer * l = nil;
    l = [self.continueButton layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:buttonCornerRadius];
    [l setBorderWidth:buttonBorderWidth];
    [l setBorderColor:[borderColor CGColor]];


    NSString *tempTitle = nil;
    NSMutableAttributedString *attributedString = nil;
    float spacing = 2.0f;

    tempTitle = self.continueButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.continueButton setAttributedTitle:attributedString forState:UIControlStateNormal];

#endif

#if 0 //green button

    //continue
    self.continueButton.titleLabel.font = [UIFont fontWithName:kFontName size:15*kFontScale];



    float inset = 6.0f;
    [self.continueButton setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, inset, 0.0f)];
    //[self.continueButton setTitleColor:[continueColor colorWithAlphaComponent:1.0f] forState:UIControlStateNormal];
    [self.continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    int buttonCornerRadius = 10;
    int buttonBorderWidth = 2;
    //UIColor *buttonColor = RGBA(0,0,0, 0.3f); //RGBA(255,255,255, 0.1f);
    //UIColor *borderColor = kYellowTextColor;

    CALayer * l = nil;

    //UIColor* defaultColor = RGB(180,180,180); //[UIColor whiteColor];
    //UIColor* cancelColor = [UIColor colorWithHex:0xff7900];
    UIColor* continueColor = [UIColor colorWithHex:0x12c312];

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

    //spacing
    NSString *tempTitle = nil;
    NSMutableAttributedString *attributedString = nil;
    float spacing = 2.0f;

    tempTitle = self.continueButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.continueButton setAttributedTitle:attributedString forState:UIControlStateNormal];

#endif


}

-(void)updateUI {

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

    //separators
    // Force your tableview margins (this may be a bad idea)
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }


    if([kHelpers isIphone4Size])
    {
    }
    else if([kHelpers isIphoneX])
    {
        //lower
        self.
        self.backTop.height = 45+kiPhoneXTopSpace; //taller
        self.backButton.y = 11  + kiPhoneXTopSpace;
        self.titleLabel.y = 2 + kiPhoneXTopSpace;
    }
    else
    {
    }


}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

	if(self.sharing)
       return;

	self.flashTimer = NO;
    self.correct = NO;

    //reset
    self.textField.text = @"";
    self.textField.enabled = NO;

    self.descLabel.hidden = NO;
    self.descLabel.alpha = 0.0f;

    self.resultLabel.hidden = NO;
    self.resultLabel.text = @"";
    self.resultLabel.alpha = 0.0f;

    self.continueButton.hidden = YES;

    [self setupFade];

    self.leaving = NO;

    //update time
    [kAppDelegate updateForegroundTime];

    [self enableButtons:YES];

    self.selectedSkin = (int)[kAppDelegate getSkin];

    //state
    kAppDelegate.titleController.menuState = menuStateCheat;

    [kHelpers setupGoogleAnalyticsForView:[[self class] description]];

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });


    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    //music
    if(kAppDelegate.inReview)
        [kAppDelegate playMusic:kMusicNameOptions andRemember:YES];
    else
        [kAppDelegate playMusic:kMusicNameCheat andRemember:YES];

    [self.tableView reloadData]; //reset anim timing

    [self startConfetti];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopConfetti];
    });


    [self updateUI];

    [self showWhiteBar];

    //text
    //[self.textField becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	//achievement
	[kAppDelegate reportAchievement:kAchievement_cheat];

    //doo doo doo
    //[kAppDelegate playSound:@"discover.caf"];

    //rotate
    [self addShineAnimation];

	if(self.sharing)
       return;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kAppDelegate playSound:@"alertchat.caf"];
    });


    //give time to layout
    float secs = 1.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self resetTimer];

        //sound
        //[kAppDelegate playSound:@"gasp1.caf"];

    });

    //state
    kAppDelegate.launchInGame = NO;
    [kAppDelegate saveState];


    //animate desc
    /*NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //style.lineSpacing = 1;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attrsDictionary = @{NSFontAttributeName : self.descLabel2.font, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : self.descLabel2.textColor};
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.descLabel2.text attributes:attrsDictionary];
    [self.descLabel2 setAttributedString:attrString];
    self.descLabel2.frame = self.descLabel.frame;
    self.descLabel2.animationDuration = 2.5f;
    self.descLabel2.animationDelay = 0.04f;
    [self.descLabel2 startAppearAnimation];*/

	//fade in descLabel
	self.descLabel.alpha = 0.0f;
	self.descLabel.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (kCurtainAnimDuration) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        [UIView animateWithDuration:1.0f animations:^{
        //[UIView animateWithDuration:0.3f delay:0.5f options:UIViewAnimationOptionCurveLinear animations:^{

            self.descLabel.alpha = 1.0f;
        }];
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (kCurtainAnimDuration+0.1f+ 0.3f) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self.textField becomeFirstResponder];
    });

}

-(void)showFirstTimeAlert {
    //disabled always
	return;

    if(kAppDelegate.playedIntroCheat)
    {
        [self.textField becomeFirstResponder];
        return;
    }

    kAppDelegate.playedIntroCheat = YES;

    [kAppDelegate saveState];

    //__weak typeof(self) weakSelf = self;

    //<color1>?
    NSString *message =
    @"Hello! You found my shop of strange and wonderful things!";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];
    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Secret!"
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:SIAlertViewButtonTypeDestructive
                                       handler:^(SIAlertView *alert) {
                                           //
                                           [kAppDelegate playSound:kClickSound];
                                           //nothing

                                           kAppDelegate.playedIntroAlert = YES;
                                           [kAppDelegate saveState];

                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    //pause
    //kAppDelegate.gameController.paused = YES;
    //kAppDelegate.gameScene.paused = YES;
    [kAppDelegate.gameScene enablePause:YES];
    [kAppDelegate.gameController blurScene:YES];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //kAppDelegate.gameScene.paused = NO;
        [kAppDelegate.gameScene enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];
        //[weakSelf showVCR:NO animated:YES];

        self.textField.enabled = YES;
        [self.textField becomeFirstResponder];


    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        [self.textField becomeFirstResponder];

        kAppDelegate.playedIntroAlert = YES;
        [kAppDelegate saveState];
    }];

    [kAppDelegate.alertView show:YES];

    //[self showVCR:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    if(self.sharing)
        return;

    [self stopConfetti];

    [self stopWhiteBar];
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

    self.leaving = NO;

    //[self.descLabel2 startDisappearAnimation];

    //reset
    self.textField.text = @"";
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)enableButtons:(BOOL)enable {

    self.backButton.enabled = enable;
    self.backButton2.enabled = enable;

	self.shareButton.enabled = enable;
	self.continueButton.enabled = enable;

	self.textField.enabled = enable;


    self.tableView.userInteractionEnabled = enable;
}

- (void) actionContinue:(id)sender {

    [kAppDelegate animateControl:self.continueButton];

	[self actionBack:sender];
}

- (void) actionBack:(id)sender {

    if(!self.curtainLeft.hidden)
        return;

    if(kAppDelegate.titleController.menuState != menuStateCheat)
    {
        return;
    }

    self.leaving = YES;

    [self.textField resignFirstResponder];

    [kAppDelegate animateControl:self.backButton];
    [kAppDelegate animateControl:self.backButton2];

    [kAppDelegate saveState];

    //[kAppDelegate stopMusic];

    if(sender)
        [kAppDelegate playSound:kClickSound];

    [self enableButtons:NO];

    [self fadeIn];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

			[kAppDelegate setViewController:kAppDelegate.titleController];
    });

	//timers
	[self.timerLabelResult invalidate];
	self.timerLabelResult = nil;
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

    //text
    //[self.textField becomeFirstResponder];

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

                         //text
                         //[self.textField becomeFirstResponder];
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

    [self.tableView reloadData]; //reset anim timing
}

#pragma mark - Table view data source


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = 0;


    return num;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //cell.backgroundColor = RGBA(255.0f/2,255.0f/2,255.0f/2, 0.5f);
    cell.backgroundColor = RGBA(180,180,180, 0.2f);
    //cell.layoutMargins = UIEdgeInsetsZero;

    //separators
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }

    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }

    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }

    //format
    cell.textLabel.font = [UIFont fontWithName:kFontName size:24];
    cell.textLabel.textColor = RGB(50,50,50);

    //text
    NSString *string1 = @"label";
    NSString *string2 = @"value";


    NSString *totalString = [NSString stringWithFormat:@"%@:  %@", string1, string2];

    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:totalString];

    [attributed addAttribute:NSForegroundColorAttributeName
                       value:RGB(50,50,50)
                       range:[totalString rangeOfString:string1]];

    [attributed addAttribute:NSForegroundColorAttributeName
                       value:RGB(255,255,255)
                       range:[totalString rangeOfString:string2]];


    cell.textLabel.attributedText = attributed;

    return cell;
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
    if(kAppDelegate.titleController.menuState != menuStateCheat)
        return;

    //only for iOS7
    //if(kIsIOS8)
    //    return;

    //re-add anim
    [self addShineAnimation];

    [self showWhiteBar];

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

	[self.timerLabelResult invalidate];
    self.timerLabelResult = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self
                                                   selector:@selector(actionTimerLabeResult:) userInfo:@"actionTimerLabeResult" repeats:YES];

}

- (void) actionTimerLabeResult:(NSTimer *)incomingTimer
{
	if(!self.flashTimer)
		return;

    self.boolTimerLabelResult = !self.boolTimerLabelResult;
    if(self.boolTimerLabelResult)
        self.resultLabel.textColor = self.correct ? [UIColor orangeColor] : [UIColor blackColor];
    else
        self.resultLabel.textColor =  self.correct ? [UIColor yellowColor] : [UIColor redColor];
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



#pragma mark - Text Field Delegate


-(void)textFieldDidChange :(UITextField *)theTextField{
    [kAppDelegate playSound:@"hashtag.caf"];
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];

    [kAppDelegate playSound:kClickSound];

    [self checkCode:self.textField.text load:NO];

    //reset
    //textField.text = @"";

    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.resultLabel.hidden = YES;
    self.continueButton.hidden = YES;

}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    self.resultLabel.hidden = NO;
    self.continueButton.hidden = NO;
}

- (void)checkCode:(NSString*)code load:(BOOL)load {

    if(code.length == 0)
	{
		//nothing
        //return;

		//go home
		[self actionBack:nil];
		return;
    }

    BOOL valid = NO;
    BOOL goBack = YES;
    BOOL isWin = NO;
    BOOL isStory = NO;
    BOOL isEnding = NO;
    BOOL showAlert = YES;

    //trim spaces
    code = [code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    BOOL isDebug = ([kHelpers isDebug]);

    //if([code isEqualToString:@"refill"] && isDebug) {
		if([code isEqualToString:Obfuscate.r.e.f.i.l.l] && isDebug) {
        valid = YES;

        kAppDelegate.numHearts = kHeartFull;

    }
    //else if([code isEqualToString:@"die"] && isDebug) {
		else if([code isEqualToString:Obfuscate.d.i.e] && isDebug) {

        valid = YES;

        kAppDelegate.numHearts = 0;

    }

    //else if([code isEqualToString:@"lock"] && isDebug) {
        else if([code isEqualToString:Obfuscate.l.o.c.k] && isDebug) {

            valid = YES;

            [kAppDelegate forceLockAll];
    }


    //else if([code isEqualToString:@"potion"] && isDebug) {
    else if([code isEqualToString:Obfuscate.p.o.t.i.o.n] && isDebug) {

            valid = YES;

        kAppDelegate.numPotions = 19;
    }


    //else if([code isEqualToString:@"unlock"] && isDebug) {
		else if([code isEqualToString:Obfuscate.u.n.l.o.c.k] && isDebug) {

        //time
        kAppDelegate.worldTimeLeft = [CBSkinManager getWorldTime];

        valid = YES;

        [kAppDelegate unlockAllBlocks];
    }

    //else if([code isEqualToString:@"unlock2"] && isDebug) {
        else if([code isEqualToString:Obfuscate.u.n.l.o.c.k._2] && isDebug) {

            //time
            kAppDelegate.worldTimeLeft = [CBSkinManager getWorldTime];

            valid = YES;

            [kAppDelegate unlockAllBlocks];

            //not all
            [kAppDelegate.dicSkinEnabled setObject:@(NO) forKey:[CBSkinManager getSkinKey:kCoinTypeMario]];
            [kAppDelegate.dicSkinEnabled setObject:@(NO) forKey:[CBSkinManager getSkinKey:kCoinTypeBrain]];

            //not new
            [kAppDelegate.dicSkinNew removeAllObjects];
        }

    //max
    else if([code isEqualToString:Obfuscate.m.a.x] && isDebug) {
        valid = YES;
        kAppDelegate.clickCount = kScoreMax;
    }


    //else if([code isEqualToString:@"mult"] && isDebug) {
    else if([code isEqualToString:Obfuscate.m.u.l.t] && isDebug) {
        valid = YES;
        kAppDelegate.cheatMult = 10;
    }

    //else if([code isEqualToString:@"nobanner"] && isDebug) {
    else if([code isEqualToString:Obfuscate.n.o.b.a.n.n.e.r] /*&& isDebug*/) {
        valid = YES;
        kAppDelegate.adBannerEnabledTemp = NO;
    }

    //else if([code isEqualToString:@"alert"] && isDebug) {
    else if([code isEqualToString:Obfuscate.a.l.e.r.t] && isDebug) {

            [kAppDelegate resetWarnings];
            valid = YES;
    }

	//else if([code isEqualToString:@"reset"] ) { //not debug
    else if([code isEqualToString:Obfuscate.r.e.s.e.t]) {
        valid = YES;

        [kAppDelegate resetState];
        [kAppDelegate resetSkins];

        //[kAppDelegate unlockAllBlocks];

        kAppDelegate.level= 1;
        kAppDelegate.subLevel= 1;

        [kAppDelegate updateBlockEnabled];

        //reset
        kAppDelegate.oneUpInc = kNum1upIncStart;
        kAppDelegate.nextOneUp = kNum1up;
        kAppDelegate.lastOneUp = 0;

        kAppDelegate.chestDate = nil;

        Log(@"oneUpInc: %d", (int)kAppDelegate.oneUpInc);
        Log(@"lastOneUp: %d", (int)kAppDelegate.lastOneUp);
        Log(@"nextOneUp: %d", (int)kAppDelegate.nextOneUp);
        Log(@"clickCount: %d", (int)kAppDelegate.clickCount);

        [kAppDelegate setSkin:kCoinTypeDefault];

        kAppDelegate.numHearts = kHeartFull;
        kAppDelegate.fireballVisible = [kAppDelegate getMaxFireballs];
        kAppDelegate.doubleEnabled = NO;
        kAppDelegate.isRandomSkin = NO;

        kAppDelegate.powerupVisibleType = kPowerUpTypeNone;

        kAppDelegate.adBannerEnabled = YES;

        [kAppDelegate resetWarnings];
    }

    //month
    else if([code isEqualToString:Obfuscate.m.o.n.t.h]  && isDebug) {
        valid = YES;

        kAppDelegate.firstLaunchDate = [[NSDate date] dateByAddingDays:30];
        [kAppDelegate saveState];
    }

    else if(([code isEqualToString:Obfuscate.p.o.u.t.i.n.e] || [code isEqualToString:Obfuscate.y.o.u.p.i]) && isDebug) {
            //valid = YES;

        //[kAppDelegate unlockBlock:kCoinTypeMontreal];
        //unhide?
    }

	 //else if([code isEqualToString:@"demo"] && isDebug) {
    else if([code isEqualToString:Obfuscate.d.e.m.o] && isDebug) {
        valid = YES;
        kAppDelegate.demoMode = YES;
        kAppDelegate.noTime = YES;
    }

    //else if([code isEqualToString:@"notime"] && isDebug) {
    else if([code isEqualToString:Obfuscate.n.o.t.i.m.e] && isDebug) {
        valid = YES;
        kAppDelegate.noTime = YES;
    }

    //else if([code isEqualToString:@"easy"] && isDebug) {
    else if([code isEqualToString:Obfuscate.e.a.s.y] && isDebug) {
        valid = YES;
        kAppDelegate.noEnemies = YES;
        kAppDelegate.noTime = YES;
    }

    //UTAGEP
    //make everything jump around

    //NULTKA
    //turn all enemies into toad
    //make everything jump around

   	//always, not just debug
	//else if([code isEqualToString:@"jaredsucks"] || [code isEqualToString:@"jaredsux"]) {
    else if([code isEqualToString:Obfuscate.j.a.r.e.d.s.u.c.k.s] || [code isEqualToString:Obfuscate.j.a.r.e.d.s.u.x]) {
        valid = YES;
		[kAppDelegate unlockBlock:kCoinTypeTA];

		kAppDelegate.numPotions = 9;
    }

    //always, not just debug
    //else if([code isEqualToString:@"valentine"]) {
    else if([code isEqualToString:Obfuscate.v.a.l.e.n.t.i.n.e]) {
        valid = YES;
        [kAppDelegate unlockBlock:kCoinTypeValentine];
    }

    //always, not just debug
    //else if([code isEqualToString:@"patrick"]) {
    else if([code isEqualToString:Obfuscate.p.a.t.r.i.c.k]) {
        valid = YES;
        [kAppDelegate unlockBlock:kCoinTypePatrick];
    }
    
    else if([code isEqualToString:Obfuscate.s.o.c.c.e.r]) {
        valid = YES;
        [kAppDelegate unlockBlock:kCoinTypeSoccer];
    }
    

    //else if([code isEqualToString:@"chest"] && isDebug) {
    else if([code isEqualToString:Obfuscate.c.h.e.s.t] && isDebug) {
        valid = YES;
        kAppDelegate.chestDate = [[NSDate date] dateBySubtractingDays:7]; //1 week earlier
    }

	//else if(([code contains:@"level"] || [code contains:@"world"]) && isDebug) {
    //else if([code contains:Obfuscate.l.e.v.e.l.underscore] && isDebug) {
    else if( ([code contains:Obfuscate.l.e.v.e.l] || [code contains:Obfuscate.w.o.r.l.d]) && isDebug) {

		//find number
        //NSString *levelString = [code stringByReplacingOccurrencesOfString:Obfuscate.l.e.v.e.l.underscore withString:@""];
        NSString *levelString = [code stringByReplacingOccurrencesOfString:Obfuscate.l.e.v.e.l withString:@""];
        levelString = [levelString stringByReplacingOccurrencesOfString:Obfuscate.w.o.r.l.d withString:@""];
		int level = [levelString intValue];

		if(level > 0)
		{
			//apply
			valid = YES;

			//disable ads
			kAppDelegate.cheatAdsDisabled = YES;

			[kAppDelegate resetState];
			[kAppDelegate resetSkins];

			//[kAppDelegate unlockAllBlocks];

			kAppDelegate.level = level;
			kAppDelegate.subLevel = 1;

			kAppDelegate.numPotions = 9;

			[kAppDelegate updateBlockEnabled];
			//unlock a few
			[kAppDelegate unlockBlock:kCoinTypeMine];
			[kAppDelegate unlockBlock:kCoinTypeZelda];
			[kAppDelegate unlockBlock:kCoinTypeBitcoin];
			[kAppDelegate unlockBlock:kCoinTypeEmoji];

			//kAppDelegate.clickCount = [kAppDelegate get1upNumLast];

			kAppDelegate.oneUpInc = kNum1upIncStart;
			kAppDelegate.nextOneUp = kNum1up;
			kAppDelegate.lastOneUp = 0;

			kAppDelegate.numEndings = 0;

			for(int i=0;i<kAppDelegate.level;i++) {

				kAppDelegate.oneUpInc += kNum1upIncInc;
				kAppDelegate.lastOneUp = kAppDelegate.nextOneUp;
				kAppDelegate.nextOneUp += kAppDelegate.oneUpInc;
			}
			//bug x-5?
			kAppDelegate.clickCount = kAppDelegate.lastOneUp+1;

			Log(@"oneUpInc: %d", (int)kAppDelegate.oneUpInc);
			Log(@"lastOneUp: %d", (int)kAppDelegate.lastOneUp);
			Log(@"nextOneUp: %d", (int)kAppDelegate.nextOneUp);
			Log(@"clickCount: %d", (int)kAppDelegate.clickCount);

            [kAppDelegate setSkin:kCoinTypeDefault];

			kAppDelegate.numHearts = kHeartFull;
			kAppDelegate.fireballVisible = [kAppDelegate getMaxFireballs];
			kAppDelegate.doubleEnabled = NO;
			kAppDelegate.isRandomSkin = YES;

			kAppDelegate.powerupVisibleType = kPowerUpTypeNone;

			kAppDelegate.adBannerEnabled = YES;

			[kAppDelegate disableWarnings];

            //chest
            kAppDelegate.chestDate = [[NSDate date] dateBySubtractingDays:7]; //1 week earlier

			//time
			kAppDelegate.worldTimeLeft = [CBSkinManager getWorldTime];
		}

	}

    //else if([code isEqualToString:@"fps"] && isDebug) {
    else if([code isEqualToString:Obfuscate.f.p.s] && isDebug) {
        valid = YES;

        //disable ads
        kAppDelegate.fps = !kAppDelegate.fps;

    }

    //else if([code isEqualToString:@"power"] && isDebug) {
    else if([code isEqualToString:Obfuscate.p.o.w.e.r] && isDebug) {
        valid = YES;

        //disable ads
        kAppDelegate.rainbowCount += 1;

    }

    ///turn on cheat even on release "debug514" -> "bluelamp16"?
    else if([code isEqualToString:Obfuscate.d.e.b.u.g._5._1._4]) {
    //else if([code isEqualToString:Obfuscate.b.l.u.e.l.a.m.p._1._6] && isDebug) {
        valid = YES;

        debugCheat = YES;
    }

    //else if([code isEqualToString:@"fun"] && isDebug) {
    else if([code isEqualToString:Obfuscate.f.u.n] && isDebug) {
        valid = YES;

		//disable ads
		kAppDelegate.cheatAdsDisabled = YES;


        [kAppDelegate resetState];
        [kAppDelegate resetSkins];

        //[kAppDelegate unlockAllBlocks];

        kAppDelegate.level = 4;
        kAppDelegate.subLevel = 1;

        kAppDelegate.numPotions = 9;

        [kAppDelegate updateBlockEnabled];
		//unlock a few
		[kAppDelegate unlockBlock:kCoinTypeMine];
		[kAppDelegate unlockBlock:kCoinTypeZelda];
		[kAppDelegate unlockBlock:kCoinTypeBitcoin];
		[kAppDelegate unlockBlock:kCoinTypeEmoji];

        //kAppDelegate.clickCount = [kAppDelegate get1upNumLast];

        kAppDelegate.oneUpInc = kNum1upIncStart;
        kAppDelegate.nextOneUp = kNum1up;
        kAppDelegate.lastOneUp = 0;

        kAppDelegate.numEndings = 0;

        for(int i=0;i<kAppDelegate.level;i++) {

            kAppDelegate.oneUpInc += kNum1upIncInc;
            kAppDelegate.lastOneUp = kAppDelegate.nextOneUp;
            kAppDelegate.nextOneUp += kAppDelegate.oneUpInc;
        }
		//bug x-5?
        kAppDelegate.clickCount = kAppDelegate.lastOneUp+1;

        Log(@"oneUpInc: %d", (int)kAppDelegate.oneUpInc);
        Log(@"lastOneUp: %d", (int)kAppDelegate.lastOneUp);
        Log(@"nextOneUp: %d", (int)kAppDelegate.nextOneUp);
        Log(@"clickCount: %d", (int)kAppDelegate.clickCount);

        [kAppDelegate setSkin:kCoinTypeDefault];

        kAppDelegate.numHearts = kHeartFull;
        kAppDelegate.fireballVisible = [kAppDelegate getMaxFireballs];
        kAppDelegate.doubleEnabled = NO;
        kAppDelegate.isRandomSkin = YES;

        kAppDelegate.powerupVisibleType = kPowerUpTypeNone;

        kAppDelegate.adBannerEnabled = YES;

        [kAppDelegate disableWarnings];

        //chest
        kAppDelegate.chestDate = [[NSDate date] dateBySubtractingDays:7]; //1 week earlier

        //time
        kAppDelegate.worldTimeLeft = [CBSkinManager getWorldTime];
    }

    //else if([code isEqualToString:@"vip"] && isDebug) { //premium
    else if( ([code isEqualToString:Obfuscate.v.i.p] || [code isEqualToString:Obfuscate.p.r.e.m.i.u.m]) && isDebug) {
        valid = YES;

        //toggle
        //kAppDelegate.adBannerEnabled = !kAppDelegate.adBannerEnabled;
        //kAppDelegate.numHearts = kHeartFull;
        //[kAppDelegate unlockVIPBlocks];
        kAppDelegate.premiumFake = YES;
    }

	//else if([code isEqualToString:@"brain"] && isDebug) {
    else if( [code isEqualToString:Obfuscate.b.r.a.i.n] && isDebug) {
        valid = YES;

		//disable ads
		kAppDelegate.cheatAdsDisabled = YES;

        [kAppDelegate resetState];
        kAppDelegate.launchCount = 2;
        [kAppDelegate resetSkins];

        //[kAppDelegate unlockAllBlocks];

        kAppDelegate.level= kLevelMax;
        kAppDelegate.subLevel= 1;

        kAppDelegate.numEndings = 0;
        kAppDelegate.numPotions = 9;

        //reset
        kAppDelegate.oneUpInc = kNum1upIncStart;
        kAppDelegate.nextOneUp = kNum1up;
        kAppDelegate.lastOneUp = 0;

        for(int i=0;i<kAppDelegate.level;i++) {

            kAppDelegate.oneUpInc += kNum1upIncInc;
            kAppDelegate.lastOneUp = kAppDelegate.nextOneUp;
            kAppDelegate.nextOneUp += kAppDelegate.oneUpInc;
        }
		//bug x-5?
        kAppDelegate.clickCount = kAppDelegate.lastOneUp + 1;

        Log(@"oneUpInc: %d", (int)kAppDelegate.oneUpInc);
        Log(@"lastOneUp: %d", (int)kAppDelegate.lastOneUp);
        Log(@"nextOneUp: %d", (int)kAppDelegate.nextOneUp);
        Log(@"clickCount: %d", (int)kAppDelegate.clickCount);

        [kAppDelegate setSkin:kCoinTypeDefault];

        kAppDelegate.numHearts = kHeartFull;
        kAppDelegate.fireballVisible = [kAppDelegate getMaxFireballs];
        kAppDelegate.doubleEnabled = NO;
        kAppDelegate.isRandomSkin = YES;

        kAppDelegate.powerupVisibleType = kPowerUpTypeNone;

        kAppDelegate.adBannerEnabled = YES;

        [kAppDelegate disableWarnings];

        [kAppDelegate updateBlockEnabled];

		//unlock a few
		[kAppDelegate unlockBlock:kCoinTypeMine];
		[kAppDelegate unlockBlock:kCoinTypeZelda];
		[kAppDelegate unlockBlock:kCoinTypeBitcoin];
		//[kAppDelegate unlockBlock:kCoinTypeEmoji];
    }


    else if(([code isEqualToString:Obfuscate.i.n.v.i.n.c.i.b.l.e] || [code isEqualToString:Obfuscate.i.n.v.i.n.s.i.b.l.e]
             || [code isEqualToString:Obfuscate.g.o.d] || [code isEqualToString:Obfuscate.g.o.d.m.o.d.e])  && isDebug) {
        valid = YES;

        //time
        kAppDelegate.worldTimeLeft = [CBSkinManager getWorldTime];

        kAppDelegate.invincible = YES;

        kAppDelegate.numHearts = kHeartFull;

    }


    else if(([code isEqualToString:Obfuscate.t.i.m.e])  && isDebug) {
        valid = YES;

        kAppDelegate.worldTimeLeft = [CBSkinManager getWorldTime];
    }

    //else if([code isEqualToString:@"win"] && isDebug) {
    else if([code isEqualToString:Obfuscate.w.i.n] && isDebug) {
        valid = YES;
        goBack = NO;

        isWin = YES;

        //fade white
        kAppDelegate.fadingWhite = YES;
    }


    //else if([code isEqualToString:@"story"] && isDebug) {
    else if(([code isEqualToString:Obfuscate.s.t.o.r.y]) && isDebug) {
        valid = YES;
        goBack = NO;

        kAppDelegate.storyController.toTransition = NO;
        isStory = YES;

    }

    //else if([code isEqualToString:@"story2"] && isDebug) {
    else if([code isEqualToString:Obfuscate.s.t.o.r.y._1] && isDebug) {
        valid = YES;
        goBack = NO;

        kAppDelegate.level = kStoryLevel1;
        kAppDelegate.storyController.toTransition = YES;
        isStory = YES;

    }

    //else if([code isEqualToString:@"story3"] && isDebug) {
    else if([code isEqualToString:Obfuscate.s.t.o.r.y._2] && isDebug) {
        valid = YES;
        goBack = NO;

        kAppDelegate.level = kStoryLevel2;
        kAppDelegate.storyController.toTransition = YES;

        isStory = YES;

    }

    //else if([code isEqualToString:@"ending"] && isDebug) {
    else if([code isEqualToString:Obfuscate.e.n.d.i.n.g] && isDebug) {
        valid = YES;
        goBack = NO;

        kAppDelegate.playedLastLevel = YES;

        isEnding = YES;
    }
    else if([code isEqualToString:Obfuscate.a.d._1] && isDebug) {

        valid = YES;
        goBack = NO;
        showAlert = NO;

        [kAppDelegate stopMusic];

        //[kAppDelegate.rootController dismissViewControllerAnimated:NO completion:^{
            [HeyzapAds presentMediationDebugViewController];
        //}];

    }

    else if([code isEqualToString:Obfuscate.a.d._2] && isDebug) {
        valid = YES;
        goBack = NO;
        [kAppDelegate showInterstitial:@"cheat"];
    }

    else if([code isEqualToString:Obfuscate.a.d._3] && isDebug) {
        valid = YES;
        goBack = NO;
        [kAppDelegate showInterstitialVideo:@"cheat"];
    }

    else if([code isEqualToString:Obfuscate.a.d._4] && isDebug) {
        valid = YES;
        goBack = NO;
        [kAppDelegate showRewardedVideo:@"cheat"];
    }

    //else if([code isEqualToString:@"ending2"] && isDebug) {
    else if([code isEqualToString:Obfuscate.e.n.d.i.n.g._2] && isDebug) {
        valid = YES;

        //1 before last

        [kAppDelegate resetState];
        kAppDelegate.launchCount = 2;
        [kAppDelegate resetSkins];

        kAppDelegate.level = kLevelMax;
        kAppDelegate.subLevel= 1;

        //reset
        kAppDelegate.oneUpInc = kNum1upIncStart;
        kAppDelegate.nextOneUp = kNum1up;
        kAppDelegate.lastOneUp = 0;

        for(int i=0;i<kAppDelegate.level;i++) {

            kAppDelegate.oneUpInc += kNum1upIncInc;
            kAppDelegate.lastOneUp = kAppDelegate.nextOneUp;
            kAppDelegate.nextOneUp += kAppDelegate.oneUpInc;

            //skip
            if(i==kCoinTypeMario)
                continue;

            [kAppDelegate unlockBlock:i];
        }
        kAppDelegate.clickCount = kAppDelegate.lastOneUp+1;

        Log(@"oneUpInc: %d", (int)kAppDelegate.oneUpInc);
        Log(@"lastOneUp: %d", (int)kAppDelegate.lastOneUp);
        Log(@"nextOneUp: %d", (int)kAppDelegate.nextOneUp);
        Log(@"clickCount: %d", (int)kAppDelegate.clickCount);

        [kAppDelegate setSkin:kCoinTypeBrain];

        kAppDelegate.numHearts = kHeartFull;
        kAppDelegate.fireballVisible = [kAppDelegate getMaxFireballs];
        kAppDelegate.doubleEnabled = NO;
        kAppDelegate.isRandomSkin = NO; //YES;

        kAppDelegate.powerupVisibleType = kPowerUpTypeNone;

        kAppDelegate.adBannerEnabled = YES;

        [kAppDelegate disableWarnings];

        kAppDelegate.playedLastLevel = YES;

        [kAppDelegate updateBlockEnabled];
    }

    //else if([code isEqualToString:@"ending3"] && isDebug) {
    else if([code isEqualToString:Obfuscate.e.n.d.i.n.g._3] && isDebug) {
        valid = YES;

        //1 before last
        [kAppDelegate resetState];
        kAppDelegate.launchCount = 2;
        [kAppDelegate resetSkins];

        kAppDelegate.level = kLevelMax-1;
        kAppDelegate.subLevel= 1;

        //reset
        kAppDelegate.oneUpInc = kNum1upIncStart;
        kAppDelegate.nextOneUp = kNum1up;
        kAppDelegate.lastOneUp = 0;

        for(int i=0;i<kAppDelegate.level;i++) {

            kAppDelegate.oneUpInc += kNum1upIncInc;
            kAppDelegate.lastOneUp = kAppDelegate.nextOneUp;
            kAppDelegate.nextOneUp += kAppDelegate.oneUpInc;

            //skip
            if(i==kCoinTypeMario)
                continue;

            [kAppDelegate unlockBlock:i];
        }
        kAppDelegate.clickCount = kAppDelegate.lastOneUp+1;

        Log(@"oneUpInc: %d", (int)kAppDelegate.oneUpInc);
        Log(@"lastOneUp: %d", (int)kAppDelegate.lastOneUp);
        Log(@"nextOneUp: %d", (int)kAppDelegate.nextOneUp);
        Log(@"clickCount: %d", (int)kAppDelegate.clickCount);

        [kAppDelegate setSkin:kCoinTypePew];

        kAppDelegate.numHearts = kHeartFull;
        kAppDelegate.fireballVisible = [kAppDelegate getMaxFireballs];
        kAppDelegate.doubleEnabled = NO;
        kAppDelegate.isRandomSkin = NO; //YES;

        kAppDelegate.powerupVisibleType = kPowerUpTypeNone;

        kAppDelegate.adBannerEnabled = YES;

        [kAppDelegate disableWarnings];

        [kAppDelegate updateBlockEnabled];
    }


    //else if([code isEqualToString:@"minus"] && isDebug) {
    else if([code isEqualToString:Obfuscate.m.i.n.u.s] && isDebug) {
        valid = YES;

        //world -1, 1 after last
        [kAppDelegate resetState];
        kAppDelegate.launchCount = 2;
        [kAppDelegate resetSkins];

        kAppDelegate.level = kLevelMax+1;
        kAppDelegate.subLevel= 1;

        //reset
        kAppDelegate.oneUpInc = kNum1upIncStart;
        kAppDelegate.nextOneUp = kNum1up;
        kAppDelegate.lastOneUp = 0;

        for(int i=0;i<kAppDelegate.level;i++) {

            kAppDelegate.oneUpInc += kNum1upIncInc;
            kAppDelegate.lastOneUp = kAppDelegate.nextOneUp;
            kAppDelegate.nextOneUp += kAppDelegate.oneUpInc;

            //skip
            if(i==kCoinTypeMario)
                continue;

            [kAppDelegate unlockBlock:i];
        }
        kAppDelegate.clickCount = kAppDelegate.lastOneUp+1;

        Log(@"oneUpInc: %d", (int)kAppDelegate.oneUpInc);
        Log(@"lastOneUp: %d", (int)kAppDelegate.lastOneUp);
        Log(@"nextOneUp: %d", (int)kAppDelegate.nextOneUp);
        Log(@"clickCount: %d", (int)kAppDelegate.clickCount);

        [kAppDelegate setSkin:kCoinTypePew];

        kAppDelegate.numHearts = kHeartFull;
        kAppDelegate.fireballVisible = [kAppDelegate getMaxFireballs];
        kAppDelegate.doubleEnabled = NO;
        kAppDelegate.isRandomSkin = NO; //YES;

        kAppDelegate.powerupVisibleType = kPowerUpTypeNone;

        kAppDelegate.adBannerEnabled = YES;

        [kAppDelegate disableWarnings];

        [kAppDelegate updateBlockEnabled];
    }



    //else if([code isEqualToString:@"convert"] && isDebug) {
    else if([code isEqualToString:Obfuscate.c.o.n.v.e.r.t] && isDebug) {
        valid = YES;
        goBack = NO;

        kAppDelegate.prefSoundsConverted = NO;
        [kAppDelegate saveState];

        /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kHudWaitDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

					//disabled
					//[kAppDelegate forceCrash:@"Convert cheat"];
					kAppDelegate.forceReload = YES;
					//force reload
					[kAppDelegate.rootController launch];
        });*/

    }

    //force disable for now
    /*if(!isDebug)
    {
        valid = NO;
        goBack = NO;
    }*/

    //only for manual entry
    if(!load) {

        if(valid)
        {
            //sound
            [kAppDelegate playSound:@"aaaahhh.caf"];

            [self startConfetti];
            float secs = 1.0f; //0.5f;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [self stopConfetti];
            });

#if 1
			//hud
			//[kHelpers showSuccessHud:LOCALIZED(@"kStringGoodCheat")];
			self.flashTimer = YES;
            self.correct = YES;

			//animate result
            self.resultLabel.text = LOCALIZED(@"kStringGoodCheat");
            //self.resultLabel.textColor = [UIColor colorWithHex:0x1eff00]; //green
            self.resultLabel.textColor = [UIColor whiteColor]; //white

    		/*self.resultLabel2 = [[ZCAnimatedLabel alloc] initWithFrame:self.resultLabel.frame];
			NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
			style.alignment = NSTextAlignmentCenter;
			NSDictionary *attrsDictionary = @{NSFontAttributeName : self.resultLabel2.font, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : self.resultLabel2.textColor};
			NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.resultLabel2.text attributes:attrsDictionary];
			[self.resultLabel2 setAttributedString:attrString];
			self.resultLabel2.frame = self.resultLabel.frame;
			self.resultLabel2.animationDuration = 2.5f;
			self.resultLabel2.animationDelay = 0.04f;
			[self.resultLabel2 startAppearAnimation];*/

			//fade in descLabel
			self.resultLabel.alpha = 0.0f;
			self.resultLabel.hidden = NO;
            [UIView animateWithDuration:0.3f animations:^{
				self.resultLabel.alpha = 1.0f;
			}];


			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kHudWaitDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				if(showAlert)
				{
					if(isWin)
					{
						dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kHudWaitDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            kAppDelegate.winController.backToGame = YES;
                            kAppDelegate.winController.backToGameMenu = NO;
                            kAppDelegate.winController.backToTitle = NO;
							[kAppDelegate setViewController:kAppDelegate.winController];
						});
					}
					else if(isStory)
					{
						dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kHudWaitDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
							[kAppDelegate setViewController:kAppDelegate.storyController];
						});
					}
					else if(isEnding)
					{
						dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kHudWaitDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
							[kAppDelegate setViewController:kAppDelegate.endingController];
						});
					}
					else
					{
						/*if(goBack)
							[self actionBack:nil];
						else
							[self.textField becomeFirstResponder];*/

						//nothing
						self.shareButton.hidden = NO;

					}
				}
            });
#endif


        }
        else
        {

			//hud
			//[kHelpers showErrorHud:LOCALIZED(@"kStringInvalidCheat")];
            self.flashTimer = YES; //NO;
            self.correct = NO;

			//animate result
            self.resultLabel.text = LOCALIZED(@"kStringInvalidCheat");
            self.resultLabel.textColor = [UIColor blackColor]; //red
            //self.resultLabel.textColor = [UIColor colorWithHex:0xff8000]; //orange
    		/*self.resultLabel2 = [[ZCAnimatedLabel alloc] initWithFrame:self.resultLabel.frame];

			//animate result
			NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
			style.alignment = NSTextAlignmentCenter;
			NSDictionary *attrsDictionary = @{NSFontAttributeName : self.resultLabel2.font, NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : self.resultLabel2.textColor};
			NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.resultLabel2.text attributes:attrsDictionary];
			[self.resultLabel2 setAttributedString:attrString];
			self.resultLabel2.frame = self.resultLabel.frame;
			self.resultLabel2.animationDuration = 2.5f;
			self.resultLabel2.animationDelay = 0.04f;
			[self.resultLabel2 startAppearAnimation];*/

			//fade in descLabel
			self.resultLabel.alpha = 0.0f;
			self.resultLabel.hidden = NO;

            [UIView animateWithDuration:0.3f animations:^{
				self.resultLabel.alpha = 1.0f;
			}];
#if 1
		    [kAppDelegate playSound:@"warning.caf"];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kHudWaitDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                //back
                //[self actionBack:nil];

				//nothing
            });
#endif


        }
    }

}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
    return YES;
}

- (IBAction)shareButtonPressed:(id)sender
{
    [kAppDelegate dbIncShare];

    if(sender)
    {
        [kAppDelegate playSound:kClickSound];
        [kAppDelegate animateControl:self.shareButton];
    }

    NSString *textToShare = LOCALIZED(@"kStringShareMessageCheat");
    NSURL *url = [NSURL URLWithString:kAppStoreURL];
    NSString *subject = LOCALIZED(@"kStringShareSubjectCheat");

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

         if(completed)
         {
			 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kDelayUnlockAfterURL * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

			 	//achievement
				[kAppDelegate reportAchievement:kAchievement_share];

				 //unlock emoji skin
				 [kAppDelegate unlockBlock:kCoinTypeFlap];

				[kAppDelegate playSound:kUnlockSound];
				[kAppDelegate playSound:kUnlockSound2];

				[kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
				[self startConfetti];
				float secs = kConfettiThanksDuration;
				dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
				  [self stopConfetti];
				});

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
@end
