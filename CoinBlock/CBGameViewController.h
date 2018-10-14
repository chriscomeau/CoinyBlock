//
//  CBViewController.h
//  CoinBlock
//

//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

#import "GameCenterManager.h"
#import "CBGameScene.h"

//#import <GADBannerView.h>
//#import "GADRequest.h"

@interface CBGameViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *bannerView;

@property (weak, nonatomic) IBOutlet UIButton *closeAdButton;
@property (weak, nonatomic) IBOutlet UIButton *closeAdButton2;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *adSpinner;
@property (weak, nonatomic) IBOutlet UIImageView *darkAdImage;
@property (weak, nonatomic) IBOutlet UIButton *cheatButton;

@property (nonatomic) int lastEnabledSkins;
//@property (strong, nonatomic) SIAlertView *alertView;
//@property (nonatomic) BOOL paused;
@property (nonatomic) BOOL sharing;
@property (strong, nonatomic) NSDate *lastBannerToggle;

@property (nonatomic) BOOL curtainsVisible;
@property (nonatomic) BOOL darkVisible;
@property (nonatomic) BOOL showingKTPlay;
@property (nonatomic) BOOL forceEnding;
- (IBAction)adButtonPressed:(id)sender;
- (BOOL)bannerVisible;
- (BOOL)bannerAvailable;
- (void)receivedBanner:(UIView*)banner;
- (void)toggleBanner;
- (void)showBanner;
- (void)hideBanner;
- (void)wobble;
- (void)shake;
-(void)enableButtons:(BOOL)enable;
-(void)openCurtains;
-(void)closeCurtains;
-(void)showFlash:(UIColor*)color;
-(void)showFlash:(UIColor*)color autoHide:(BOOL)autoHide;
-(void)hideFlash;
-(void)updateBadge;
-(void)updateButtons;

-(void)startConfetti;
-(void)startConfetti2;
-(void)stopConfetti;
-(void)showUnlockBanner;

- (void) actionMenu:(id)sender;
- (void) actionMenu:(id)sender playSound:(BOOL)playSound;
- (void) actionWin:(id)sender;
- (void) actionBack:(id)sender;
- (void) actionRestart:(id)sender;
- (void)blurScene:(BOOL)blur;
-(void)showVCR:(BOOL)show animated:(BOOL)animated;
-(void)flashVCR;
-(void)updateTimeLabel:(BOOL)animated;

//-(void)startFireworks;

@end
