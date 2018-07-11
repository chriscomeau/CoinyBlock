//
//  CBAboutViewController.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBAboutViewController.h"
#import "CBConfettiView.h"

@interface CBAboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton2;
@property (weak, nonatomic) IBOutlet UIImageView *darkImage;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIImageView *shineImageView;
@property (nonatomic, strong) IBOutlet UIImageView *cloud1;
@property (strong, nonatomic) NSTimer *timerCloud;
@property (strong, nonatomic) NSMutableArray *imageArray1;
@property (nonatomic) int selectedSkin;
@property (nonatomic, strong) IBOutlet UIImageView *scanline;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableTop;

@property (nonatomic, strong) IBOutlet CBConfettiView *confettiView;
@property (weak, nonatomic) IBOutlet UIImageView *curtainLeft;
@property (weak, nonatomic) IBOutlet UIImageView *curtainRight;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBar;
@property (nonatomic, strong) IBOutlet UIImageView *backTop;

- (IBAction)actionBack:(id)sender;

@end


@implementation CBAboutViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupFade];
    [self bringSubviewsToFront];

    [kHelpers loopInBackground];

    [kAppDelegate scaleView:self.view];

    //corner
    [kAppDelegate cornerView:self.view];

    [UIView setAnimationsEnabled:NO];

    //kAppDelegate.storeController = self;

    //table
    self.tableView.backgroundColor = [UIColor clearColor];
    //separator
    self.tableView.separatorColor = [UIColor clearColor]; //RGBA(255,255,255, 0.5f);
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

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
    self.titleLabel.text = @"Credits";
    //self.titleLabel.font = [UIFont fontWithName:kFontName size:16*kFontScale]; //20
    self.titleLabel.font = [UIFont fontWithName:kFontNameBlocky size:16*kFontScale]; //20

    self.titleLabel.textColor = kYellowTextColor;

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

        self.backTop.height = 45+kiPhoneXTopSpace; //taller
        self.backButton.y = 11  + kiPhoneXTopSpace;
        self.titleLabel.y = 2 + kiPhoneXTopSpace;

        self.tableTop.constant = 30;
        //self.tableView.y = 10 + kiPhoneXTopSpace;
    }
    else
    {
    }


}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [self setupFade];

    //scroll to top
    [self.tableView setContentOffset:CGPointZero animated:NO];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notifyForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];


    //update time
    [kAppDelegate updateForegroundTime];


    [self enableButtons:YES];

    self.selectedSkin = (int)[kAppDelegate getSkin];

    //state
    kAppDelegate.titleController.menuState = menuStateAbout;

    [kHelpers setupGoogleAnalyticsForView:[[self class] description]];

    //to fix broken animation sometimes
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kFadeOutDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self fadeOut];
    });

    //cloud
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;

    //music
    [kAppDelegate playMusic:kMusicNameOptions andRemember:YES];

    [self.tableView reloadData]; //reset anim timing

    /*[self startConfetti];
    float secs = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopConfetti];
    });*/


    [self updateUI];

    [self showWhiteBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	//achievement
	[kAppDelegate reportAchievement:kAchievement_credits];

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


- (void)viewWillDisappear:(BOOL)animated {
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

    [self.shineImageView.layer removeAllAnimations];

    [self.cloud1.layer removeAllAnimations];
    self.cloud1.alpha = 0.0f;
    self.cloud1.x = -kCloudWidth;
    self.cloud1.y = -100;
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

    self.tableView.userInteractionEnabled = enable;
}


- (IBAction)actionHideAds:(id)sender {

#if 0
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

        kAppDelegate.adBannerEnabled = NO;
        [kAppDelegate saveState];

        [kAppDelegate playSound:kUnlockSound];
        [kAppDelegate playSound:kUnlockSound2];

        [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
        [self startConfetti];

        float secs = kConfettiThanksDuration;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self stopConfetti];
        });


        [self.tableView reloadData];

        [self updateUI];


        //[kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];
    });
#endif
}

- (IBAction)actionViewStore:(id)sender {
    //pressed


    //disabled
    return;
#if 0
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

        [self unlockVIPBlocks];
        [kAppDelegate playSound:kUnlockSound];
        [kAppDelegate playSound:kUnlockSound2];

        [kHelpers showSuccessHud:LOCALIZED(@"kStringThanks")];
        [self startConfetti];

        float secs = kConfettiThanksDuration;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self stopConfetti];
        });


        [self.tableView reloadData];

        [self updateUI];


        //[kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];
    });
#endif

}

- (void) actionBack:(id)sender {

    if(!self.curtainLeft.hidden)
        return;

    [kAppDelegate animateControl:self.backButton];
    [kAppDelegate animateControl:self.backButton2];

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

-(void)bringSubviewsToFront
{
    [self.view bringSubviewToFront:self.curtainLeft];
    [self.view bringSubviewToFront:self.curtainRight];
    [self.view bringSubviewToFront:self.confettiView];
    [self.view bringSubviewToFront:self.whiteBar];
    [self.view bringSubviewToFront:self.darkImage];
    [self.view bringSubviewToFront:self.scanline];
}


-(void)fadeIn {

    [self setupFade];

    //top
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

    switch(indexPath.row) {

        case 1:
            //string2 = [NSString stringWithFormat:@"Skyriser Media, %d", year];
            [kAppDelegate playSound:kClickSound];

            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://skyriser.com/"] options:@{} completionHandler:nil];

            break;

        case 3:
        case 4:
            //string2 = @"Chris Comeau";
            [self contactButtonPressed:nil];
            break;

        case 19:
            [kAppDelegate playSound:kClickSound];

            [kAppDelegate openExternalURL:@"http://coinyblock.com/"];
            break;


        default:
            break;

    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    float height = 0;

    switch(indexPath.row) {

        case 0:
        case 2:
        case 5:
        case 11:
        case 16:
        case 18:
            //spacing
            height = 20;
            break;


        case 17:
            //permission
            height = 100;
            break;

        default:
            //regular
            height = 30;
            break;

    }

    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = 20;

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
    NSString *string1 = @"";

    //NSDate *date = [NSDate date];
    //NSUInteger componentFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    //NSDateComponents *components = [[NSCalendar currentCalendar] components:componentFlags fromDate:date];
    int year = kCopyrightYear; //(int)[components year];

    BOOL isTitle = NO;

    switch(indexPath.row) {

        case 0:
            string1 = @"";
            break;

        case 1:
            string1 = [NSString stringWithFormat:@"Skyriser Media, %d", year];
            break;

        case 2:
            string1 = @"";
            break;


        case 3:
            isTitle = YES;
            string1 = @"Developer:";
            break;

        case 4:
            string1 = @"• Chris Comeau";
            break;

        case 5:
            string1 = @"";
            break;

        case 6:
            isTitle = YES;
            string1 = @"Special Thanks: ";
            break;

        case 7:
            string1 = @"• Melissa Maclean";
            break;

        case 8:
            string1 = @"• Philip Clement";
            break;

        case 9:
            string1 = @"• Leon Mwotia";
            break;

        case 10:
            string1 = @"• Christine Herr";
            break;



        case 11:
            string1 = @"";
            break;

        case 12:
            isTitle = YES;
            string1 = @"Testers:"; //credits: "skyler", "discoveringmypath", "noah gray" (?)
            break;

        case 13:
            string1 = @"• skyler";
            break;

        case 14:
            string1 = @"• discoveringmypath";
            break;
        case 15:
            string1 = @"• Jamie Gray"; //@"• jayg2015";
            break;


        case 16:
            string1 = @"";
            break;

        case 17:
            isTitle = YES;
            string1 = @"You have our full permission to record, stream and post any videos of this game!";
            break;

        case 18:
            string1 = @"";
            break;

        case 19:
            isTitle = YES;
            string1 = @"http://coinyblock.com/";
            break;

        default:
            break;

    }

    NSString *totalString = [NSString stringWithFormat:@"%@", string1];

    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:totalString];

    [attributed addAttribute:NSForegroundColorAttributeName
                       //value: !isTitle ? RGB(50,50,50) : [UIColor whiteColor]
                       value: !isTitle ? RGB(20,20,20) : [UIColor whiteColor]
                       range:[totalString rangeOfString:string1]];

   /* if(indexPath.row == 14) //link
        [attributed addAttribute:NSForegroundColorAttributeName
                       value:[UIColor whiteColor]
                       range:[totalString rangeOfString:string2]];
    else
        [attributed addAttribute:NSForegroundColorAttributeName
                           value:[UIColor whiteColor]
                           range:[totalString rangeOfString:string2]];*/

    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
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
    if(kAppDelegate.titleController.menuState != menuStateAbout)
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

@end
