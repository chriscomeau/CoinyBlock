//
//  CBAppDelegate.h
//  CoinBlock
//
//  Created by Chris Comeau on 2014-08-30.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameCenterManager.h"
#import <MessageUI/MessageUI.h>
//#import "TWTSideMenuViewController.h"
//import "MKiCloudSync.h"
//#import "iRate.h"
#import <GameAnalytics/GameAnalytics.h>
#import <HeyzapAds/HeyzapAds.h>
#import <GetRated/getRated.h>
#import "HapticHelper.h"

#import "CBGameViewController.h"
#import "CBGameScene.h"
#import "CBSettingsViewController.h"
#import "CBLoadingViewController.h"
#import "CBTitleViewController.h"
#import "CBAboutViewController.h"
#import "CBWinViewController.h"
#import "CBPremiumViewController.h"
#import "CBCheatViewController.h"
#import "CBRootViewController.h"
#import "CBTransitionViewController.h"
#import "CBStoryViewController.h"
#import "CBEndingViewController.h"
#import "CBVideoPlayerViewController.h"
#import "CBSkinManager.h"


//#import <Firebase/Firebase.h>
@import Firebase;
@import FirebaseMessaging;

@import UserNotifications;
//#import <UNUserNotificationCenter.h>

//#import "MenuViewController.h"

//notification
enum {
    DAY_SUNDAY = 1,
    DAY_MONDAY = 2,
    DAY_TUESDAY = 3,
    DAY_WEDNESDAY = 4,
    DAY_THURSDAY = 5,
    DAY_FRIDAY = 6,
    DAY_SATURDAY = 7,
};

/*
enum {
    kRewardTypeNone = 0,
    kRewardTypeChartboost,
    kRewardTypeAdColony,
    kRewardTypeUnity,

    kRewardTypeNum,
};*/

@interface CBAppDelegate : UIResponder <UIApplicationDelegate, GameCenterManagerDelegate, /*TWTSideMenuViewControllerDelegate,*/ MFMailComposeViewControllerDelegate, /*ChartboostDelegate,*/ UNUserNotificationCenterDelegate, HZAdsDelegate, HZIncentivizedAdDelegate/*, UnityAdsDelegate*/, FIRMessagingDelegate>
//@interface CBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) double soundVolume;
@property (nonatomic) double musicVolume;
@property (nonatomic) BOOL vibrationEnabled;
@property (nonatomic) BOOL launchInGame;
@property (nonatomic) BOOL gameCenterEnabled;
@property (nonatomic) BOOL gameCenterAsked;
@property (nonatomic) BOOL gameCenterRemoteEnabled;
@property (nonatomic) BOOL mailingAsked;
//@property (nonatomic) BOOL jailbroken;
//@property (nonatomic) BOOL cracked;
@property (nonatomic) BOOL notifyEnabled;
@property (nonatomic) BOOL notifyAccepted;
@property (nonatomic) BOOL notifyAsked;
@property (nonatomic) BOOL adBannerEnabled;
@property (nonatomic) BOOL adBannerEnabledTemp;
@property (nonatomic) PowerupType powerupVisibleType;
@property (nonatomic) PowerupType lastPowerup;
@property (nonatomic) BOOL doubleEnabled;
@property (nonatomic) BOOL cheatAdsDisabled;
@property (nonatomic) BOOL playedIntroAlert;
@property (nonatomic) BOOL playedIntroCheat;
@property (nonatomic) BOOL playedLastLevel;
@property (nonatomic) BOOL playedWelcomeAlert;
@property (nonatomic) BOOL playedStoreAlert;
@property (nonatomic) BOOL playedX4Alert;
@property (nonatomic) BOOL playedWeakSpotAlert;
@property (nonatomic) BOOL playedLowHeartAlert;
@property (nonatomic) BOOL playedRainbowCoinAlert;
@property (nonatomic) BOOL playedLowTimeAlert;
@property (nonatomic) BOOL playedHelpPowerupReady;
@property (nonatomic) BOOL playedHelpFire;
@property (nonatomic) BOOL playedShieldAlert;
@property (nonatomic) BOOL playedDoublerAlert;
@property (nonatomic) BOOL playedAutoAlert;
@property (nonatomic) BOOL playedShrinkAlert;
@property (nonatomic) BOOL playedInkAlert;
@property (nonatomic) BOOL playedGrowAlert;
@property (nonatomic) BOOL playedWeakAlert;
@property (nonatomic) BOOL playedStarAlert;
@property (nonatomic) BOOL playedLavaAlert;
@property (nonatomic) BOOL noEnemies;
@property (nonatomic) BOOL noTime;
@property (nonatomic) BOOL demoMode;
@property (nonatomic) BOOL touchedPremium;
@property (nonatomic) BOOL tutoArrowClickedTitle;
@property (nonatomic) BOOL tutoArrowClickedBlock;
@property (nonatomic) BOOL tutoArrowClickedStar;
@property (nonatomic) BOOL tutoArrowClickedSquare;
@property (nonatomic) BOOL isPlayingVideoAd;
@property (nonatomic) int skinVideoUnlock;
@property (nonatomic) int fireballVisible;
@property (nonatomic) int rainbowCount;
@property (nonatomic) int rainbowUsedCount;
@property (nonatomic) int credits;
@property (nonatomic) int sinceLastMessage;
@property (nonatomic) int prefNumFireballsTouched;
@property (nonatomic) int numRedCoins;
@property (nonatomic) int prefLevelNumFireballsTouched;
@property (nonatomic) BuffType currentBuff;
@property (nonatomic) int buffSecs;

@property (nonatomic) BOOL premiumFake;
@property (nonatomic) BOOL invincible;
@property (nonatomic) BOOL fps;
@property (nonatomic) double maxCombo;
@property (nonatomic) double maxComboLevel;
@property (nonatomic) double numPotions;
@property (nonatomic) double clickCount;
@property (nonatomic) double clickCountWorld;
//@property (nonatomic) double clickCountReal;
@property (nonatomic) double starLevelCount;
@property (nonatomic) double dieCount; //firebase
@property (nonatomic) double deathCount; //local
@property (nonatomic) double rateCount;
@property (nonatomic) double shareCount;
@property (nonatomic) double powerupCount;
@property (nonatomic) double powerupCountLocal;
@property (nonatomic) double premiumCount;
@property (nonatomic) double toastieCount;
@property (nonatomic) double fireCount;
@property (nonatomic) double spikeCount;
@property (nonatomic) double oneUpInc;
@property (nonatomic) double nextOneUp;
@property (nonatomic) double lastOneUp;
@property (nonatomic) double rewindClickCount;
@property (nonatomic) double timeForeground;
@property (nonatomic) double bitcoinPrice;
@property (nonatomic) BOOL appActive;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger numEndings;
@property (nonatomic) NSInteger subLevel;
@property (nonatomic) NSInteger lifes;
@property (nonatomic) NSInteger launchCount;
@property (nonatomic) NSInteger playCount;
@property (nonatomic) NSInteger numApps;
//@property (nonatomic) NSInteger currentSkin;
@property (nonatomic) NSInteger numHearts;
@property (nonatomic) NSInteger currentCastle;
@property (nonatomic) NSInteger worldTimeLeft;
@property (nonatomic) BOOL isRandomSkin;
@property (nonatomic) BOOL prefOpened;
@property (nonatomic) BOOL prefInstallCountSent;
@property (nonatomic) BOOL prefSoundsConverted;
@property (nonatomic) BOOL playedIntroSound;
@property (nonatomic) double parseMult;
@property (nonatomic) double cheatMult;
@property (nonatomic) double comboMult;
@property (nonatomic) double toastieMult;
@property (nonatomic) BOOL fadingWhite;
@property (strong, nonatomic) NSDate* foregroundDate;
@property (strong, nonatomic) NSDate* launchDate;
@property (strong, nonatomic) NSDate* interstitialLastDate;
@property (strong, nonatomic) NSDate* saveDate;
@property (strong, nonatomic) NSDate* lastVideoUnlockDate;
@property (strong, nonatomic) NSDate* healStartDate;
@property (strong, nonatomic) NSDate* volumeChangeDate;
@property (strong, nonatomic) NSDate* achievementDate;
@property (strong, nonatomic) NSDate* buffDate;
@property (strong, nonatomic) NSDate* coffeeDate;
@property (strong, nonatomic) NSDate* chestDate;
@property (strong, nonatomic) NSDate* loadStartDate;
@property (nonatomic) int coffeeCount;

@property (nonatomic, retain) NSMutableArray *arraySkinRemoteEnabled;
@property (nonatomic, retain) NSMutableDictionary *dicSkinEnabled;
@property (nonatomic, retain) NSMutableDictionary *dicSkinNew;
@property (nonatomic, retain) NSMutableArray *viewedCheats;

@property (nonatomic, strong) UIImage *profileImage;

@property (nonatomic) float mult;
@property (nonatomic) BOOL inReview;
@property (nonatomic) BOOL showCommercial;

@property (nonatomic) BOOL forceReload;
@property (nonatomic) BOOL shouldGetCountry;
@property (nonatomic) BOOL shouldGetBitcoin;

@property (nonatomic) float interstitialAfterWinOdds;
@property (nonatomic) float interstitialTitleOdds;
@property (nonatomic) float bannerOdds;
@property (nonatomic) float currentVersion;
@property (nonatomic) float interstitialForegroundOdds;
@property (nonatomic) float interstitialDelayBetween;
@property (nonatomic) float navPlusOdds;
@property (nonatomic) float powerupClickOdds;
@property (nonatomic) float powerupTimerOdds;

@property (nonatomic) BOOL showQuotes;
@property (nonatomic) BOOL fromWin;
@property (nonatomic) BOOL fromDie;
//@property (nonatomic, strong) TWTSideMenuViewController *sideMenuViewController;
@property (nonatomic, retain) NSString *prefVersion;
@property (nonatomic, retain) NSDate *firstLaunchDate;
@property (nonatomic, retain) NSDate *lastRewardDate;
@property (nonatomic) int loadingCount;
@property (nonatomic) BOOL isLoading;

@property (strong, nonatomic) CBGameScene *gameScene;
@property (strong, nonatomic) CBGameViewController *gameController;
@property (strong, nonatomic) CBTitleViewController *titleController;
@property (strong, nonatomic) CBLoadingViewController *loadingController;
@property (strong, nonatomic) CBSettingsViewController *settingsController;
@property (strong, nonatomic) CBAboutViewController *aboutController;
@property (strong, nonatomic) CBWinViewController *winController;
@property (strong, nonatomic) CBWinViewController *premiumController;
@property (strong, nonatomic) CBCheatViewController *cheatController;
@property (strong, nonatomic) CBStoryViewController *storyController;
@property (strong, nonatomic) CBEndingViewController *endingController;
@property (strong, nonatomic) CBTransitionViewController *transitionController;
@property (strong, nonatomic) CBRootViewController *rootController;
@property (strong, nonatomic) CBVideoPlayerViewController *videoController;

@property (strong, nonatomic) SIAlertView *alertView;

@property (nonatomic, strong) NSDate *dateReset;
@property (nonatomic, strong) NSDate *dateBackground;
@property (nonatomic, strong) NSDate *dateBackground2;
@property (nonatomic, strong) NSDate *dateBackgroundRoot;

@property (strong, nonatomic) NSMutableDictionary* iapPrices;
@property (strong, nonatomic) NSMutableDictionary* iapProducts;

//@property (strong, nonatomic) FMDatabase *database;

//@property (strong, nonatomic) MenuViewController *menuViewController;

- (UIStoryboard *)storyboard;

//banner
-(void)setupBannerAds;

//sound
-(void)convertSound:(NSString*)soundName;
- (void)setupAudioSession;
- (void)preloadSound:(NSString*)name;
- (void)playSound:(NSString*)name;
- (void)playSound:(NSString*)name force:(BOOL)force;
- (void)stopSound:(NSString*)name;
- (void)resumeMusic;
- (void)playMusicForced:(NSString*)name;
- (void)playMusicRandom;
- (void)playMusic:(NSString*)name andRemember:(BOOL)remember;
- (void)playMusic:(NSString*)name andRemember:(BOOL)remember looping:(BOOL)looping;
- (void)stopMusic;
- (void)setSoundVolume:(double)volume;
- (void)setMusicVolume:(double)volume;
- (void)setCredits:(int)value;

-(void)stopAllAudio;
- (void)saveState;
- (void)saveState:(BOOL)iCloud;
- (void)loadFromIcloud;
- (void)forceLockAll;
- (void)loadState;
- (void)resetState;
- (void)resetState:(BOOL)resetSkins;
- (void)resetWarnings;
- (void)disableWarnings;

-(void) resetSkins;
-(void)checkHeartHeal;

- (BOOL)launchedEnough;
- (void)loadViews;
-(void)cornerView:(UIView*)inView;
-(void)scaleView:(UIView*)inView;

-(void)updateMult;
-(void)updateForegroundTime;

//gamecenter
- (BOOL)isGameCenter;
-(void)reportScore;

-(void)resetAchievements;
-(void)checkAchievements;
-(void)reportAchievement:(NSString*)name;
-(void)loadAchievements;

//email
- (void)sendEmailTo:(NSString *)to withSubject:(NSString *)subject withBody:(NSString *)body withView:(UIViewController*)theView;

//notifications
- (void)cancelNotifications;
- (void)setupNotifications;
-(void)registerNotifications;
-(BOOL)isRegisteredForNotifications;

//animation
-(void)animateControl:(id)sender;


//skinmanager
-(NSString*)getRandomStart:(int)index;
-(NSString*)getRandomMessage;
-(NSString*)getRandomOuch;

//blocks
-(NSInteger)getSkin;
-(void)setSkin:(NSInteger)newSkin;

-(BOOL)isBlockSpecial:(int)index;
-(UIColor*)getBlockColor;
-(NSString*)getFireballName;
-(NSString*)getBlockShineImageName;
-(void)saveBlockImage;
-(NSString*)getPlusOne;
-(NSArray*) getUnlockedSkinsArray;
-(float)getMultIndex:(int)index;
-(float)getSpeedMultIndex;
-(int)getMaxFireballs;
-(BOOL)isBlockEnabledIndex:(int)index;
-(BOOL)isBlockRemoteEnabledIndex:(int)index;
-(int)getInterstitialOdds:(int)odds;
-(void)updateBlockEnabled;
-(int)unlockRandomBlock;
-(int)unlockRandomBlock:(BOOL)shouldUnlock;
-(void)unlockAllBlocks;
-(void)unlockVIPBlocks;
-(void)unlockBlock:(int)index;
-(void)unlockDoubler;
-(void)markAllAsRead;
-(void)restoreFromPayment:(SKPaymentQueue *)payment;
-(void)restoreVIPSuccessful;

-(int)getNumNewSkins;

- (void)actionHashtag;
-(void) openExternalURL:(NSString*)url;
-(BOOL) validateURL:(NSString*)url;
-(void)openRatings;

//quote
//-(NSString *)randomQuote;

//user
- (BOOL)isLoggedIn;
- (void)logout;
- (void)logoutFacebook;

//load
-(void) doneNotification:(NSNotification*)notif;

//parse
-(void)dbIncEnding;
-(void)dbIncPause;
-(void)dbIncCoin:(float)inValue;
-(void)dbIncClick;
-(void)dbIncPlay;
-(void)dbIncDie;
-(void)dbIncFire;
-(void)dbIncSpike;
-(void)dbIncLaunch;
-(void)dbIncLevelup;
-(void)dbIncShare;
-(void)dbIncPotion;
-(void)dbIncInstall;
-(void)dbIncRate;
-(void)dbIncPowerup;
-(void)dbIncToastie;
-(void)dbIncPremium;

-(void)dbSaveObjects;
-(void)dbInitObjects;

//-(void)firebaseSaveObjects;

-(void)getIAP;
-(BOOL)isGameCenterNotificationUp;
-(void)setupGameCenter;
-(void)setupGameCenter:(BOOL)force;
-(NSString*)getPlayerName;
-(BOOL)isPremium;
-(BOOL)isPremiumIAPOnSale;

//downloads
-(void)checkAssets;
- (NSString *)applicationDocumentsDirectory;
- (NSString*) savePath;
- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString;
-(int)numFilesInFolderAtPath:(NSString*)path;
-(int)numSoundsInFolder;
-(void)deleteAllSoundFiles;
-(BOOL)checkDiskSpace;
- (FISound*) soundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices error: (NSError**) error;
-(void)forceCrash:(NSString*)message;
//-(void)killApplication;
-(void)setViewController:(UIViewController*)viewController;

//ads
-(void)showInterstitial:(NSString*)name;
-(void)showInterstitialVideo:(NSString*)name;
-(BOOL)hasRewardedVideo:(NSString*)name;
-(BOOL)showRewardedVideo:(NSString*)name;

-(void)cacheRewardVideos;

#if 0
-(void)adColonyShowInterstitial;
-(void)adColonyRequestInterstitial;
#endif

- (void)downloadCommercial:(BOOL)shouldDelete;

//languages
-(void)forceLanguage:(NSString*)language;
-(BOOL)isLanguage:(NSString*)language;
-(BOOL)isEnglish;
-(BOOL)isFrench;
-(BOOL)isSpanish;

@end
