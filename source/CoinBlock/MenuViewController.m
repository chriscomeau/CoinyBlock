//
//  MenuViewController.m
//  Emergency
//
//  Created by Chris Comeau on 2014-05-20.
//  Copyright (c) 2014 Face 3 Media. All rights reserved.
//

#import "TWTSideMenuViewController.h"
#import "MenuViewController.h"
#import "UIButton+BadgeValue.h"

@interface MenuViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

@property (nonatomic, strong) IBOutlet UIButton *resumeButton;
@property (nonatomic, strong) IBOutlet UIButton *storeButton;
@property (nonatomic, strong) IBOutlet UIButton *rateButton;
@property (nonatomic, strong) IBOutlet UIButton *otherButton;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic, strong) IBOutlet UIButton *optionsButton;
@property (nonatomic, strong) IBOutlet UIButton *leaderboardButton;
@property (nonatomic, strong) IBOutlet UIButton *contactButton;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;

- (IBAction)resumeButtonPressed:(id)sender;
- (IBAction)storeButtonPressed:(id)sender;
- (IBAction)rateButtonPressed:(id)sender;
- (IBAction)otherButtonPressed:(id)sender;
- (IBAction)shareButtonPressed:(id)sender;
- (IBAction)optionsButtonPressed:(id)sender;
- (IBAction)leaderboardButtonPressed:(id)sender;
- (IBAction)contactButtonPressed:(id)sender;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //kAppDelegate.menuViewController = self;

    self.menuState = menuStateGame;

    //UIFont *buttonFont = [UIFont fontWithName:@"Super-Mario-Bros.-3" size:14];
    //UIFont *buttonFont2 = [UIFont fontWithName:@"Super-Mario-Bros.-3" size:18];

    UIFont *buttonFont = [UIFont fontWithName:@"SuperMarioGalaxy" size:20];
    UIFont *buttonFont3 = [UIFont fontWithName:@"SuperMarioGalaxy" size:20];
    UIFont *buttonFont2 = [UIFont fontWithName:@"SuperMarioGalaxy" size:20];

    self.view.backgroundColor = [UIColor blackColor];

    //version
    self.versionLabel.text = [NSString stringWithFormat:@"Version %@ (%@)",
                            [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                              [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
    self.versionLabel.text = [self.versionLabel.text lowercaseString];

    //self.versionLabel.font = [UIFont fontWithName:@"Super-Mario-Bros.-3" size:10];
    self.versionLabel.font = [UIFont fontWithName:@"SuperMarioGalaxy" size:12];
    self.versionLabel.textAlignment = NSTextAlignmentLeft;
    self.versionLabel.textColor = kYellowTextColor;
    self.versionLabel.alpha = 0.3f;

    self.resumeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.resumeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.resumeButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.resumeButton setTintColor:kYellowTextColor];
    self.resumeButton.titleLabel.font = buttonFont2;

    self.storeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.storeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.storeButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.storeButton setTintColor:kYellowTextColor];
    self.storeButton.titleLabel.font = buttonFont3;

    self.optionsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.optionsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.optionsButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.optionsButton setTintColor:kYellowTextColor];
    self.optionsButton.titleLabel.font = buttonFont3;

    self.leaderboardButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.leaderboardButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.leaderboardButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.leaderboardButton setTintColor:kYellowTextColor];
    self.leaderboardButton.titleLabel.font = buttonFont3;

    self.rateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.rateButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.rateButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.rateButton setTintColor:kYellowTextColor];
    self.rateButton.titleLabel.font = buttonFont;

    self.otherButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.otherButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.otherButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.otherButton setTintColor:kYellowTextColor];
    self.otherButton.titleLabel.font = buttonFont;

    self.shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.shareButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.shareButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.shareButton setTintColor:kYellowTextColor];
    self.shareButton.titleLabel.font = buttonFont;

    self.contactButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contactButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.contactButton setTitleColor:kYellowTextColor forState:UIControlStateNormal];
    [self.contactButton setTintColor:kYellowTextColor];
    self.contactButton.titleLabel.font = buttonFont;

    int shadowOffset = 2;
    UIColor *shadowColor = RGBA(50,50,50, 0.5f);

    [self.resumeButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    self.resumeButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    [self.optionsButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    self.optionsButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    [self.storeButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    self.storeButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    [self.leaderboardButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    self.leaderboardButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    [self.rateButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    self.rateButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    [self.otherButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    self.otherButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    [self.shareButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    self.shareButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);

    [self.contactButton setTitleShadowColor:shadowColor forState:UIControlStateNormal];
    self.contactButton.titleLabel.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);


    //spacing
    NSString *tempTitle = nil;
    NSMutableAttributedString *attributedString = nil;
    float spacing = 2.0f;

    tempTitle = self.resumeButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.resumeButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.optionsButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.optionsButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.storeButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.storeButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.leaderboardButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.leaderboardButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.rateButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.rateButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.otherButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.otherButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.shareButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.shareButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    tempTitle = self.contactButton.titleLabel.text;
    attributedString = [[NSMutableAttributedString alloc] initWithString:tempTitle];
    [attributedString addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [tempTitle length])];
    [self.contactButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    //swipe
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    //[self.view addGestureRecognizer:gestureRecognizer]; //disabled

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];


    [self updateUI];


}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark - Actions


- (void)updateUI {
    //badge

    //test
    //CGRect tempRect = self.otherButton.frame;
    //self.otherButton.backgroundColor = [UIColor blueColor];

    [self.otherButton setBadgeValue:@"6"];
    //[self.storeButton setBadgeValue:@"1"];

}


- (IBAction)resumeButtonPressed:(id)sender
{

    [kAppDelegate playSound:kClickSound];

    int oldMenuState = self.menuState;
    self.menuState = menuStateGame;

    if(oldMenuState == menuStateGame)
        [self.sideMenuViewController closeMenuAnimated:YES completion:nil]; //resume

    else
        [self.sideMenuViewController setMainViewController:kAppDelegate.gameController animated:YES closeMenu:YES]; //switch


}


- (IBAction)optionsButtonPressed:(id)sender
{

    [kAppDelegate playSound:kClickSound];

    int oldMenuState = self.menuState;
    self.menuState = menuStateSettings;

    if(oldMenuState == menuStateSettings)
        [self.sideMenuViewController closeMenuAnimated:YES completion:nil]; //resume

    else
        [self.sideMenuViewController setMainViewController:kAppDelegate.settingsController animated:YES closeMenu:YES]; //switch



    //[kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];

}

- (IBAction)storeButtonPressed:(id)sender
{
#if 0
    [self.storeButton setBadgeValue:nil];

    [kAppDelegate playSound:kClickSound];

    int oldMenuState = self.menuState;
    self.menuState = menuStateStore;

    if(oldMenuState == menuStateStore)
        [self.sideMenuViewController closeMenuAnimated:YES completion:nil]; //resume

    else
        [self.sideMenuViewController setMainViewController:kAppDelegate.storeController animated:YES closeMenu:YES]; //switch
#endif
}

- (IBAction)rateButtonPressed:(id)sender
{
    [kAppDelegate playSound:kClickSound];

    [kAppDelegate openRatings];
}

- (IBAction)otherButtonPressed:(id)sender
{
    [self.otherButton setBadgeValue:nil];

    [kAppDelegate playSound:kClickSound];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/artist/skyriser-media/id359807334"] options:@{} completionHandler:nil];
}

- (IBAction)shareButtonPressed:(id)sender
{
    [kAppDelegate playSound:kClickSound];

    //[kHelpers showErrorHud:LOCALIZED(@"kStringNotImplemented")];

    //[self.sideMenuViewController closeMenuAnimated:YES completion:nil];

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


- (IBAction)leaderboardButtonPressed:(id)sender
{
    [kAppDelegate playSound:kClickSound];

    [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:[kAppDelegate.rootController currentViewController]];

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

-(void)swipeHandler:(UISwipeGestureRecognizer *)recognizer {
    Log(@"Swipe received.");

    [self resumeButtonPressed:nil];
}


@end
