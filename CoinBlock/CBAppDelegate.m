//
//  CBAppDelegate.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-08-30.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBAppDelegate.h"
#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
//#import <Optimizely/Optimizely.h>

//#import <NotchKit.h>
//#import "Adjust.h"

#import "CPMotionRecognizingWindow.h"
#import "SKProduct+priceAsString.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#include <sys/xattr.h>
#import "NSAttributedString+DDHTML.h"
#import "ExtAudioConverter.h"

#if kKTPlayEnabled
#import "KTPlay.h"
#endif

@interface CBAppDelegate ()
@property (strong, nonatomic) NSString* currentMusic;
//@property (strong, nonatomic) NSArray* musicArray;
@property (retain) NSMutableDictionary* earnedAchievementCache;

@property (strong, nonatomic) FIRRemoteConfig* remoteConfig;
@property (strong, nonatomic) FIRDatabaseReference *firebaseDatabase;

@property (strong, nonatomic) FIRDatabaseReference* fireCoinCount;
@property (strong, nonatomic) FIRDatabaseReference* fireClickCount;
@property (strong, nonatomic) FIRDatabaseReference* firePlayCount;
@property (strong, nonatomic) FIRDatabaseReference* fireDieCount;
@property (strong, nonatomic) FIRDatabaseReference* fireFireCount;
@property (strong, nonatomic) FIRDatabaseReference* fireSpikeCount;
@property (strong, nonatomic) FIRDatabaseReference* fireLaunchCount;
@property (strong, nonatomic) FIRDatabaseReference* fireLevelupCount;
@property (strong, nonatomic) FIRDatabaseReference* firePowerupCount;
@property (strong, nonatomic) FIRDatabaseReference* fireShareCount;
@property (strong, nonatomic) FIRDatabaseReference* fireInstallCount;
@property (strong, nonatomic) FIRDatabaseReference* fireRateCount;
@property (strong, nonatomic) FIRDatabaseReference* fireToastieCount;
@property (strong, nonatomic) FIRDatabaseReference* firePremiumCount;
@property (strong, nonatomic) FIRDatabaseReference* fireEndingCount;
@property (strong, nonatomic) FIRDatabaseReference* firePauseCount;
@property (strong, nonatomic) FIRDatabaseReference* firePotionCount;
@property (strong, nonatomic) FIRDatabaseReference* fireTimeForeground;

@property (strong, nonatomic) AFHTTPRequestOperation *commercialOperation;

@property (strong, nonatomic) NSTimer *timerRefill;
@property (strong, nonatomic) NSString *ipAddress;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSString* gamecenterName;

@property (nonatomic) BOOL stateLoaded;
@property (nonatomic) BOOL hasReward;

//force private
@property (nonatomic) NSInteger currentSkin; //[kAppDelegate getSkin]

@end

@implementation CBAppDelegate

NSRecursiveLock *lock1;


- (CPMotionRecognizingWindow *)window
{
    static CPMotionRecognizingWindow *customWindow = nil;
    if (!customWindow)
        customWindow = [[CPMotionRecognizingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    return customWindow;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    Log(@"application:didFinishLaunchingWithOptions:");
#if TARGET_IPHONE_SIMULATOR
    //afficher chemin des documents du Simulateur
    Log(@"Documents directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
#endif

  if([kHelpers isDebug])
  {
      //force language
      BOOL test1 = [self isEnglish];
      BOOL test2 = [self isFrench];

      //[self forceLanguage:nil];

    //[self forceLanguage:@"en"];
    //[self forceLanguage:@"fr"];

//      BOOL test1 = [self isEnglish];
//      BOOL test2 = [self isFrench];
  }


    //build time
	//NSString *dateStr = [NSString stringWithUTF8String:__DATE__];
	//NSString *timeStr = [NSString stringWithUTF8String:__TIME__];

    //shake, causes black screen
    //self.window = [[CPMotionRecognizingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    lock1 = [[NSRecursiveLock alloc] init];

    //init
    _soundVolume = kDefaultVolumeSound;
    _musicVolume = kDefaultVolumeMusic;
    _credits = 0;
    _parseMult = 1.0f;
    _cheatMult = 0.0f;
    _comboMult = 0.0f;
    _iapPrices = [NSMutableDictionary dictionary];
    _iapProducts = [NSMutableDictionary dictionary];
    self.volumeChangeDate = [NSDate date];

    self.currentMusic = @"";
    self.skinVideoUnlock = kCoinTypeDefault;

    //music
    //[self playMusicForced:kMusicNameLoading];

    //convert splash sound
    [self setupAudioSession];

    //get sound volume
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:kPrefGroup];

    //set defaults
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithFloat:kDefaultVolumeSound], @"soundVolume",
                                 nil];

    [prefs registerDefaults:appDefaults];
    [prefs synchronize];

    CGFloat volume = kDefaultVolumeSound;
    volume = [[prefs objectForKey:@"soundVolume"] floatValue];
    [kAppDelegate setSoundVolume:volume];

    //pre-convert special caf sounds
    [self convertSound:kSplashSound];
    [self convertSound:@"silence.caf"];
    [self convertSound:@"silence.caf"];

    //force play 1st sound
    [kHelpers playSoundCaf:@"silence.caf"];

    //splash sound
    //[kHelpers playSoundCaf:@"splash6.caf"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    });

    //load state
    [self loadState];

    //reset ad date
    //self.interstitialLastDate = [NSDate date];

    //icloud
    //[MKiCloudSync start];

    NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateKeyValuePairs:) name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification object:store];
    // Synchronize Store
    [store synchronize];

    [self updateBlockEnabled];

    //notchkit window
    //window = NotchKitWindow(frame: UIScreen.main.bounds)
    //self.window = [[NotchKitWindow alloc] initWithFreame:UIScreen.main.bounds];

    //load root
    self.rootController = [kStoryboard instantiateViewControllerWithIdentifier:@"root"];
    self.window.rootViewController = self.rootController;
    [self.window makeKeyAndVisible];

    [self.rootController launch];

    [self checkHeartRefill];


    //boot, hard drive
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //[self playMusic:@"boot.mp3" andRemember:NO];
    //});

    //setup, part 2
    float secs = 0.1f; //0.5
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self setup:application withOptions:launchOptions];
    });

    //disable sleep, keep awake
    [UIApplication sharedApplication].idleTimerDisabled = YES;

    return YES;
}

-(void)setupGameCenter {
	[self setupGameCenter:NO];
}

-(void)setupGameCenter:(BOOL)force {
    if([self isGameCenter]) {

        //1 on 1st launch here
        /*if(self.gameCenterAsked)
        {
            [[GameCenterManager sharedManager] setupManager];
            [[GameCenterManager sharedManager] setDelegate:self];
        }
        else*/
        /*{
            //gamecenter alert
            NSString *message = LOCALIZED(@"kStringGamecenterAsk");
            RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:LOCALIZED(@"Cancel") action:^{
                //nothing
            }];

            //RIButtonItem *okItem = [RIButtonItem itemWithLabel:LOCALIZED(@"kStringOK") action:^{
            RIButtonItem *okItem = [RIButtonItem itemWithLabel:LOCALIZED(@"kStringGamecenterAskOK") action:^{
                [[GameCenterManager sharedManager] setupManager];
                [[GameCenterManager sharedManager] setDelegate:self];
                self.gameCenterEnabled = YES;
                self.gameCenterAsked = YES;
                [self saveState];
            }];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALIZED(@"kStringGamecenterAskTitle")
                                                                                                            message:message
                                                                                         cancelButtonItem:cancelItem
                                                                                         otherButtonItems:okItem, nil];
            [alert show];
        }*/
        {
            [[GameCenterManager sharedManager] setupManager];
            [[GameCenterManager sharedManager] setDelegate:self];
            self.gameCenterEnabled = YES;
            self.gameCenterAsked = YES;
            [self saveState];
        }
    }
}

-(NSString*)getPlayerName {

	return @"Hero";

#if 0
	if(self.gamecenterName && self.gamecenterName.length > 0)
	{
		return self.gamecenterName;
	}
	else
	{
    	//return @"Player 1";
    	return @"Hero";
    	//return @"Knight";
	}
#endif
}

-(BOOL)isPremium
{
    BOOL premium = !self.adBannerEnabled;
	return premium;
}

-(BOOL)isPremiumIAPOnSale
{
    BOOL onSale = YES;

    if(self.firstLaunchDate)
    {
        int days = kNumDaysPremiumSale;
        NSTimeInterval interval = [self.firstLaunchDate timeIntervalSinceDate:[NSDate date]];
        if (ABS(interval) > days*60*60*24) {
            onSale = NO;
        }

    }

    return onSale;
}

//init part 2
-(void)setup:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {

    Log(@"setup");

    [self setupAudioSession];

    //boot, hard drive
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    //    [self playMusic:@"boot.mp3" andRemember:NO];
    //});

    //[self playMusic:@"boot2.mp3" andRemember:NO];

    //time
    self.foregroundDate = [NSDate date];
    self.launchDate = [NSDate date];

    //background fetch
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    // Use Firebase library to configure APIs
    [FIRApp configure];

    //push
    [FIRMessaging messaging].delegate = self;

    //offline
    [FIRDatabase database].persistenceEnabled = YES;

    //self.firebaseDatabase = [[FIRDatabase database] referenceWithPath:@"coinCount"];
    self.firebaseDatabase = [[FIRDatabase database] reference];

    self.remoteConfig = [FIRRemoteConfig remoteConfig];

    // Create Remote Config Setting to enable developer mode.
    // Fetching configs from the server is normally limited to 5 requests per hour.
    // Enabling developer mode allows many more requests to be made per hour, so developers
    // can test different config values during development.
    if([kHelpers isDebug])
    {
        FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] initWithDeveloperModeEnabled:YES];
        self.remoteConfig.configSettings = remoteConfigSettings;
    }

    //defaults
    [self.remoteConfig setDefaultsFromPlistFileName:@"RemoteConfigDefaults"];

    //analytics
    // [START custom_event_objc]
    /*[FIRAnalytics logEventWithName:kFIREventSelectContent parameters:@{
                                                                                                                             kFIRParameterContentType:@"cont",
                                                                                                                             kFIRParameterItemID:@"1"
                                                                                                                             }];
    // [END custom_event_objc]

    // [START custom_event_objc]
    [FIRAnalytics logEventWithName:@"share_image"
                                parameters:@{
                                                         @"name": name,
                                                         @"full_text": text
                                                         }];
    // [END custom_event_objc]


    //crash log?
    //@import FirebaseCrash;

    // FIRCrashLog is used here to indicate that the log message
    // will not be shown in the console output. Use FIRCrashNSLog to have the
    // log message show in the console output.
    // [START log_and_crash]
    FIRCrashLog(@"Cause Crash button clicked");
    assert(NO);
    // [END log_and_crash]


    */

    //facebook
    //[PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];

    //twitter
    //[PFTwitterUtils initializeWithConsumerKey:kTwitterAPIKey consumerSecret:kTwitterAPISecret];

    //parse
    [self dbInitObjects];


	#if 0
    //adjust
    NSString *yourAppToken = @"???";
    //NSString *environment = [kHelpers isDebug] ? ADJEnvironmentSandbox : ADJEnvironmentProduction;
    NSString *environment = ADJEnvironmentProduction;
    ADJConfig *adjustConfig = [ADJConfig configWithAppToken:yourAppToken environment:environment];
    [Adjust appDidLaunch:adjustConfig];
    [adjustConfig setLogLevel:ADJLogLevelInfo];    // the default
    //ADJEvent *event = [ADJEvent eventWithEventToken:@"abc123"];
    //[Adjust trackEvent:event];
    //[Adjust setEnabled:NO];
    #endif

    [self updateBlockEnabled];

    //quotes db
    //[self setupDatabase];

    self.launchCount++;

    //shake, causes black screen
    //self.window = [[CPMotionRecognizingWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    //crash
    //[Crashlytics startWithAPIKey:@"85ef4e9599d0568f9d83bf8599a554aa160307d3"];
    [Fabric with:@[[Crashlytics class]]];
    //[Fabric with:@[[Crashlytics class], [GameAnalytics class], [Optimizely class]]];
    //[Optimizely startOptimizelyWithAPIToken:@"AANqYuEBIjJkhoQ7SUScwJi8W1BYg3ZE~10291341055" launchOptions:launchOptions];

    //google analytics
    [GAI sharedInstance].trackUncaughtExceptions = NO;
    [GAI sharedInstance].dispatchInterval = 20;
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelWarning];
    [[GAI sharedInstance] trackerWithTrackingId:kGoogleAnalyticsTrackingID];

    //subscribe to resume updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneNotification:)
                                                 name:kLoadingDoneNotifications
                                               object:nil];

    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationUserDidTakeScreenshotNotification
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *notif) {
                                                      [self screenshotNotification:notif];
                                                  }];
    //time change, anti cheat
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationSignificantTimeChangeNotification
                                                      object:nil
                                                       queue:mainQueue
                                                  usingBlock:^(NSNotification *notif) {
													  //reset chest date if trying to cheat?
                                                      self.chestDate = nil;
                                                      [self saveState];
                                                  }];

#if 1
    //gameanaltics
    // Enable log to output simple details (disable in production)
    [GameAnalytics setEnabledInfoLog:YES];
    // Enable log to output full event JSON (disable in production)
    [GameAnalytics setEnabledVerboseLog:YES];

    // Example: configure available virtual currencies and item types for later use in resource events
    // [GameAnalytics configureAvailableResourceCurrencies:@[@"gems", @"gold"]];
    // [GameAnalytics configureAvailableResourceItemTypes:@[@"boost", @"lives"]];

    // Example: configure available custom dimensions for later use when specifying these
    // [GameAnalytics configureAvailableCustomDimensions01:@[@"ninja", @"samurai"]];
    // [GameAnalytics configureAvailableCustomDimensions02:@[@"whale", @"dolphin"]];
    // [GameAnalytics configureAvailableCustomDimensions03:@[@"horde", @"alliance"]];

    // Configure build version
    [GameAnalytics configureBuild:@"1.0.0"];

    // initialize GameAnalytics - this method will use keys injected by Fabric
    [GameAnalytics initializeWithConfiguredGameKeyAndGameSecret];
    // for manual specification of keys use this method:
    // [GameAnalytics initializeWithGameKey:@"[game_key]" gameSecret:@"[game_secret]"];
#endif

#if kKTPlayEnabled
#if !(TARGET_IPHONE_SIMULATOR)
    [KTPlay startWithAppKey:@"???" appSecret:@"???"];
#endif
#endif

    self.window.backgroundColor = [UIColor blackColor];
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];


    //iap
    if(![IAPShare sharedHelper].iap) {

        //NSSet* dataSet = [[NSSet alloc] initWithObjects:
        NSMutableSet* dataSet = [[NSMutableSet alloc] initWithObjects:
                          kIAP_NoAds,
                          kIAP_NoAds2,
                          kIAP_Coffee,

                          //skins
                          kIAP_SkinMiner,
                          kIAP_SkinLinked,
                          kIAP_SkinHacker,
                          kIAP_SkinEmoji,
                          kIAP_SkinEgg,
                          kIAP_SkinEdgy,
                          kIAP_SkinFlappy,
                          kIAP_SkinOhBoy,
                          kIAP_SkinTouchArcade,
                          kIAP_SkinPewDiePie,

                          //kIAP_Doubler,skins
                          //kIAP_Skin1,
                          //kIAP_SkinAll,

                          nil];

        //add all skins
        for(int i=0;i<kNumSkins;i++)
        {
            [dataSet addObject:[CBSkinManager getSkinKey:i]];
        }

        [IAPShare sharedHelper].iap = [[IAPHelper alloc] initWithProductIdentifiers:dataSet];

        //production
        if([kHelpers isDebug]) {
            [IAPShare sharedHelper].iap.production = NO;
        }
        else {
            [IAPShare sharedHelper].iap.production = YES;
        }
    }

    //airplay
    //[self setupOutputScreen];

    //reachability
    // Allocate a reachability object

    //NSArray *domains = @[@"www.google.com", @"www.apple.com"];
    //Reachability* reach = [Reachability reachabilityWithHostname:[domains randomObject]];
    Reachability *reach = [Reachability reachabilityForInternetConnection];

    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:

        //dispatch_async(dispatch_get_main_queue(), ^{
            Log(@"Reachability: REACHABLE!");

            [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityNotificationOnline object:self userInfo:nil];

            [self dbInitObjects];
            //send notif

            //update parse
            [self getRemoteConfig];

            //gamecenter
            [self setupGameCenter];


            //refresh iap
            [self getIAP];

            [self downloadCommercial:NO];

            [self loadAchievements];

        //});
    };

    reach.unreachableBlock = ^(Reachability*reach)
    {
        Log(@"UReachability: NREACHABLE!");

        [[NSNotificationCenter defaultCenter] postNotificationName:kReachabilityNotificationOffline object:self userInfo:nil];

    };

    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];


    //configure iRate
    if(kiRateEnabled) {
#if 0
        [iRate sharedInstance].appStoreID = kAppStoreAppID;
        [iRate sharedInstance].daysUntilPrompt = 2;
        [iRate sharedInstance].usesUntilPrompt = 3;
        [iRate sharedInstance].delegate = self;

        //events
        [iRate sharedInstance].eventsUntilPrompt = kIRatePromptCount;
        //[[iRate sharedInstance] logEvent:NO];

        [iRate sharedInstance].verboseLogging = NO;
        //[iRate sharedInstance].previewMode = YES; //test
#endif
    }

    #if 1
    //configure GetRated
    /* _optional_ */
    //don't prompt at launch - only set this if you intent to call GetRated to prompt manually
    [getRated sharedInstance].promptAtLaunch = NO;

    //enable preview mode - *** ONLY SET THIS FOR TESTING ONLY ***
    [getRated sharedInstance].previewMode = NO && [kHelpers isDebug];
    [getRated sharedInstance].verboseLogging = NO && [kHelpers isDebug]; //default: NO

    //other configs
    //https://github.com/neilmorton/GetRated

    [getRated sharedInstance].daysUntilFirstPrompt = 2; //default: 10
    [getRated sharedInstance].minimumDaysUntilPromptAfterVersionUpdate = 2; //default: 10
    [getRated sharedInstance].usesUntilPrompt = 3; //default: 10


    /* _required_ */
    //start GetRated - should be called AFTER any optional configuration options (above)
    [[getRated sharedInstance] start];

    //later...
    //[[getRated sharedInstance] promptIfAllCriteriaMet];

    #endif

    //parse
    // Enable Crash Reporting
    //[ParseCrashReporting enable];

    // Setup Parse
    /*[Parse setApplicationId:@"parseAppId" clientKey:@"parseClientKey"];
    [Parse setApplicationId: kParseApplicationID
                  clientKey:kParseClientKey];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    //facebook
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];*/


    //push
    if(self.notifyEnabled && self.notifyAsked /*&& self.notifyAccepted*/)
    {
        [self registerNotifications];
        [self setupNotifications];
    }

     //mario, black/white
    [[SIAlertView appearance] setTitleFont:[UIFont fontWithName:kFontNameBlocky size:20*kFontScale]];

    [[SIAlertView appearance] setMessageFont:[UIFont fontWithName:@"OrangeKid-Regular" size:22]];
    [[SIAlertView appearance] setButtonFont:[UIFont fontWithName:kFontName size:16*kFontScale]];
    [[SIAlertView appearance] setCornerRadius:12];

    [[SIAlertView appearance] setTitleColor:RGB(220,220,220)];
    [[SIAlertView appearance] setMessageColor:RGB(220,220,220)];

    [[SIAlertView appearance] setViewBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];

    //other
    [[SIAlertView appearance] setButtonColor:RGB(180,180,180)]; //[UIColor whiteColor]
    //cancel
    [[SIAlertView appearance] setCancelButtonColor:[UIColor colorWithHex:0xff7900]]; //[UIColor orangeColor]
    //ok:
    [[SIAlertView appearance] setDestructiveButtonColor:[UIColor colorWithHex:0x12c312]]; //[UIColor green]
    [[SIAlertView appearance] setDestructiveButtonColor2:[UIColor colorWithHex:0xff7900]]; //[UIColor orangeColor]

    //create
    self.alertView = [[SIAlertView alloc] initWithTitle:@"" andMessage:@""];

    //ads
#if 1
    if(kPreloadAds)
        [HeyzapAds startWithPublisherID:kHeyZapID andOptions:HZAdOptionsDisableAutomaticIAPRecording];
    else
        [HeyzapAds startWithPublisherID:kHeyZapID andOptions:HZAdOptionsDisableAutomaticIAPRecording | HZAdOptionsDisableAutoPrefetching];


    //[HeyzapAds startWithPublisherID:@"???" andOptions:HZAdOptionsDisableAutomaticIAPRecording | HZAdOptionsDisableAutoPrefetching];

    // setup Heyzap callbacks
    [HZInterstitialAd setDelegate:self];
    [HZVideoAd setDelegate:self];
    [HZIncentivizedAd setDelegate:self];
    [HeyzapAds networkCallbackWithBlock:^(NSString *network, NSString *callback) {
       // Log(@"*****HeyzapAds networkCallbackWithBlock");
    }];
#endif




    //debug
    //[HeyzapAds setDebug:[kHelpers isDebug]];
    //    [HZLog setThirdPartyLoggingEnabled:YES];
    //    [HZLog setDebugLevel:HZDebugLevelVerbose];
    [HeyzapAds setDebug:NO];

    //banner
   [self setupBannerAds];


    //random
    int tempRandom = 0;
    tempRandom = arc4random_uniform(100);


    //status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];


    if(NO && [kHelpers isDebug]) {
        [kHelpers listFonts];
    }

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];

    //launched from push notification
    if (launchOptions) { //launchOptions is not nil
        NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];

        Log(@"From launch notification...");

        if(userInfo) {
            Log(@"From launch notification 2...");
        }
    }

    //gamecenter
    [self setupGameCenter];

    //parse
    [self getRemoteConfig];

    //[self downloadCommercial:YES];

    //ip country
    //[self getIP];
    //[self getCountryLocale];

    //bitcoin
    //[self getBitcoinPrice];

    //iap
    [self getIAP];

    //start loading later

    /*float secs = 0.1f;
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
     //self.gameController = [kStoryboard instantiateViewControllerWithIdentifier:@"game"];
     //self.settingsController = [kStoryboard instantiateViewControllerWithIdentifier:@"settings"];
     });
     */

    //done
    /*[[NSNotificationCenter defaultCenter] postNotificationName:kLoadingDoneNotifications
     object:self
     userInfo:nil];*/
    [self doneNotification:nil];


    //3d touch
    if(launchOptions) {
        UIApplicationShortcutItem *shortcutItem = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
        if(shortcutItem)
            [self handleShortcut:shortcutItem fromLaunch:YES];
    }


    //timers
    [self resetTimer];

    //jailbroken
    //self.jailbroken = isDeviceJailbroken();
    //self.cracked = isAppCracked();
}

-(void)loadViews {

    //fix bug never ends loading
    float secs = kLoadForceDoneDelay;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(self.loadingCount < kLoadViewsNeeded)
            [self switchViews];
    });

    //test swift
    //TestSwiftClass *test = [[TestSwiftClass alloc] init];
    //[test run];

    //side menu

    self.isLoading = YES;

    self.titleController = [kStoryboard instantiateViewControllerWithIdentifier:@"title"];
    self.gameController = [kStoryboard instantiateViewControllerWithIdentifier:@"game"];
    self.settingsController = [kStoryboard instantiateViewControllerWithIdentifier:@"settings"];
    //self.storeController = [kStoryboard instantiateViewControllerWithIdentifier:@"store"];
    //self.skinController = [kStoryboard instantiateViewControllerWithIdentifier:@"skin"];
    //self.statsController = [kStoryboard instantiateViewControllerWithIdentifier:@"stats"];
    self.aboutController = [kStoryboard instantiateViewControllerWithIdentifier:@"about"];
    self.winController = [kStoryboard instantiateViewControllerWithIdentifier:@"win"];
    self.premiumController = [kStoryboard instantiateViewControllerWithIdentifier:@"premium"];
    self.cheatController = [kStoryboard instantiateViewControllerWithIdentifier:@"cheat"];
    self.transitionController = [kStoryboard instantiateViewControllerWithIdentifier:@"transition"];
    self.storyController = [kStoryboard instantiateViewControllerWithIdentifier:@"story"];
    self.endingController = [kStoryboard instantiateViewControllerWithIdentifier:@"ending"];

    //self.videoController = [kStoryboard instantiateViewControllerWithIdentifier:@"video"];

#if 0
    if(kIsIOS9) {
        [self.loadingController loadViewIfNeeded];
        [self.titleController loadViewIfNeeded];
        [self.gameController loadViewIfNeeded];
        [self.settingsController loadViewIfNeeded];
        //[self.storeController loadViewIfNeeded];
        //[self.skinController loadViewIfNeeded];
        //[self.statsController loadViewIfNeeded];
        [self.aboutController loadViewIfNeeded];
        [self.winController loadViewIfNeeded];
        [self.premiumController loadViewIfNeeded];
        [self.cheatController loadViewIfNeeded];
        [self.transitionController loadViewIfNeeded];
        [self.storyController loadViewIfNeeded];
        [self.endingController loadViewIfNeeded];
        //[self.videoController loadViewIfNeeded];
    }
#endif
    //force load
    self.titleController.view.hidden = NO;
    self.titleController.menuState = menuStateLoading;
	self.gameController.view.hidden = NO;
    self.settingsController.view.hidden = NO;
    //self.storeController.view.hidden = NO;
    //self.skinController.view.hidden = NO;
    //self.statsController.view.hidden = NO;
    self.aboutController.view.hidden = NO;
    self.winController.view.hidden = NO;
    self.premiumController.view.hidden = NO;
    self.cheatController.view.hidden = NO;
    self.transitionController.view.hidden = NO;
    self.storyController.view.hidden = NO;
    self.endingController.view.hidden = NO;
    //self.videoController.view.hidden = NO;
}

-(void)setViewController:(UIViewController*)viewController {
	Log(@"setViewController: %@", [viewController class]);

	//[self.rootController setupFade];

  [self.rootController setViewController:viewController];
}

-(void)switchViews {

    //fade
    [self.loadingController fadeIn];

    float secs = kFadeDuration;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //float secs2 = [self isGameCenterNotificationUp] ? kWaitForGameCenterDelay : 0.0f  ;
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            //switch
            BOOL old = NO;
            int oldHours = 24*2;
            if(!self.saveDate) {
                old = YES;
            }
            else if ([[NSDate date] timeIntervalSinceDate:self.saveDate] > oldHours*60*60) {
                old = YES;
            }

            //only of not alert and level 1-1
            if((!self.playedWelcomeAlert && kAppDelegate.level == 1 && kAppDelegate.subLevel == 1 && self.launchCount == 1) || NO )
            {
                self.titleController.menuState = menuStateStory;
                [self setViewController:self.storyController];
            }
            else {
                self.titleController.menuState = menuStateTitle;
				        [self setViewController:self.titleController];
            }

            //unload loading
            self.loadingController = nil;
            self.isLoading = NO;
            //self.forceReload = NO;
        //});
    });
}



-(BOOL)handleShortcut:(UIApplicationShortcutItem *)shortcutItem fromLaunch:(BOOL)fromLaunch {

    //disabled
    return NO;


    Log(@"%@", shortcutItem.type);

    BOOL handled = NO;

    if ([shortcutItem.type isEqualToString:@"quickactions.coinblock.title"]) {
        //home
        handled = YES;

        //todo:go to title
        if(self.titleController.menuState != menuStateTitle) {

            if(fromLaunch) {

            }
            else {

            }
        }


    }
    else if ([shortcutItem.type isEqualToString:@"quickactions.coinblock.game"]) {
        //play
        handled = YES;

        //todo:go to title
        if(self.titleController.menuState != menuStateGame) {
            if(fromLaunch) {

            }
            else {

            }
        }
    }

    else if ([shortcutItem.type isEqualToString:@"quickactions.coinblock.cheats"]) {
        //play
        handled = YES;

        //todo:go to title
        if(self.titleController.menuState != menuStateCheat) {
            if(fromLaunch) {

            }
            else {

            }
        }

    }
    else if ([shortcutItem.type isEqualToString:@"quickactions.coinblock.settings"]) {
        //settings
        handled = YES;

        //todo:go to title
        if(self.titleController.menuState != menuStateSettings) {
            if(fromLaunch) {

            }
            else {

            }
        }
    }

    return handled;

}

//3d touch / force touch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {

    BOOL handled = [self handleShortcut:shortcutItem fromLaunch:NO];

    completionHandler(handled);
}

#if 0
//background fetch
- (void) application:(UIApplication *)application
  performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    Log(@"########### Received Background Fetch ###########");

    [self getRemoteConfig];
    [self dbInitObjects];

    float secs = 1.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        completionHandler(UIBackgroundFetchResultNewData);
    });

}
#endif

-(BOOL)isRegisteredForNotifications {

    BOOL enabled =  YES; //[[UIApplication sharedApplication] isRegisteredForRemoteNotifications];

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        BOOL authorized = settings.authorizationStatus == UNAuthorizationStatusAuthorized;
        Log(@"isRegisteredForNotifications: %@", authorized?@"YES":@"NO");
    }];

    return enabled;
}

-(void)registerNotifications {

    [self cancelNotifications];

    if(YES)
    {

        //iOS10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNAuthorizationOptions options = UNAuthorizationOptionAlert + UNAuthorizationOptionSound + UNAuthorizationOptionBadge;

        [center requestAuthorizationWithOptions:options
                              completionHandler:^(BOOL granted, NSError * _Nullable error) {

                                  self.notifyAccepted = granted;

                                  if (!granted) {
                                      Log(@"registerNotifications: Something went wrong");
                                  }

                                  [self saveState];
                              }];


        self.notifyAsked = YES;

    }


    [self saveState];
}

-(void) screenshotNotification:(NSNotification*)notif {
    Log(@"screenshotNotification");
}

-(void) doneNotification:(NSNotification*)notif {

    [lock1 lock];

    //disabled
    //return;

    //Log(@"kLoadingDoneNotifications: %d", self.loadingCount);

    self.loadingCount++;

    //Log(@"Loaded: %d/%d", self.loadingCount, kLoadViewsNeeded);


    int numLoadsNeeded = kLoadViewsNeeded;
    if(self.loadingCount == numLoadsNeeded)
    {
        //check time since start
        float secs = kForceLoadDelay;

        if(kAppDelegate.loadStartDate)
        {
          NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:kAppDelegate.loadStartDate];
          if(timeInterval < kMinLoadTime)
            secs += (kMinLoadTime - timeInterval);
        }

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            [self.loadingController hideCheckForUpdates];

            [self switchViews];
        });

    }

    [lock1 unlock];

}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    Log(@"***** applicationDidReceiveMemoryWarning");
}

#pragma mark -
#pragma mark Notifications

/*
- (void)application:(UIApplication *)app didReceiveLocalNotification:(UILocalNotification *)notif {
    // Handle the notificaton when the app is running

    Log(@"From local notification...");

    [self processNotification:notif];

    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void) processNotification:(UILocalNotification *)notif {

    if(notif) {
        Log(@"Recieved Notification %@",notif);
    }
}
*/

- (void)cancelNotifications {
    //reset
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];

    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

}

- (void)messaging:(FIRMessaging *)messaging didReceiveRegistrationToken:(NSString *)fcmToken {
    Log(@"FCM registration token: %@", fcmToken);

    // TODO: If necessary send token to application server.
    // Note: This callback is fired at each app startup and whenever a new token is generated.
}

- (void)setupNotifications {

    [self cancelNotifications];

    if(!self.notifyEnabled || ![self isRegisteredForNotifications])
        return; //disabled

    if(self.inReview)
        return;

    //save skin
    //today
    [self saveBlockImage];

    int identCount = 0;

    //get url
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *skinPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"currentSkinImage.png"];
    NSURL *skinURL = [NSURL fileURLWithPath:skinPath];
    //int currentAttachement = 0;
    //disable attachement
    skinURL = nil;

    //NSString *soundName =[CBSkinManager getStartSoundName:(int)[self getSkin]];
    NSString *soundName = @"alertchat2.caf"; //force

    NSString *soundNameChat = @"alertchat2.caf";

    //between 10 and 10
    //int minHour = 10;
    //int maxHour = 21;

    //15m
    /*
    if(NO) {
        int minutes = 15; //kWaitMinutes

        NSDate *nextdDate = [NSDate dateWithMinutesFromNow:minutes];

        UILocalNotification *notif = [[UILocalNotification alloc] init];
        if (notif == nil)
            return;
         notif.fireDate = nextdDate;
         notif.timeZone = [NSTimeZone defaultTimeZone];
         notif.alertBody = message;
         notif.alertAction = LOCALIZED(@"kStringNotificationButton");
         notif.soundName = soundName;
         [[UIApplication sharedApplication] scheduleLocalNotification:notif];



        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        NSString *message = [[CBSkinManager getRandomNotification] randomObject];
        content.title = LOCALIZED(@"kStringNotifTitle");
        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundName];
        //content.badge = @(1);

        NSError *notifError;
         CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
         NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);
         UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
         if(attachement)
         content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
     NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                Log(@"setupNotifications: Something went wrong: %@",error);
            }
        }];
    }*/

    //test 2m
#if 0
    if(NO && [kHelpers isDebug]) {
        int minutes = 2; //kWaitMinutes
        NSDate *nextdDate = [NSDate dateWithMinutesFromNow:minutes];

        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        NSString *message = [[CBSkinManager getRandomNotification] randomObject];
        content.title = LOCALIZED(@"kStringNotifTitle");
        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundName];
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);

        //        NSString *skinPath2 = skinPath;
        //        skinPath2 = [skinPath2 stringByReplacingOccurrencesOfString:@"currentSkinImage.png" withString:[NSString stringWithFormat:@"currentSkinImage%d.png", currentAttachement++]];
        //        skinURL = [NSURL fileURLWithPath:skinPath2];

        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }

    }
#endif

    //refill in 1h
    if(YES && self.numHearts < kHeartFull) {
        float numMissing = (kHeartFull - self.numHearts); //halfs

        int minutes = kRefillTime  * numMissing;
        NSDate *nextdDate = [NSDate dateWithMinutesFromNow:minutes];

        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        //NSString *message = [[CBSkinManager getRandomNotification] randomObject];
        NSString *message = nil;

		/*if([self isPremium])
			message = @"Your hearts have been refilled!\n❤️ ❤️ ❤️ ❤️";
		else
			message = @"Your hearts have been refilled!\n❤️ ❤️ ❤️";
        */

        message = @"Your hearts are refilled ❤️ Let's play!";


        content.title = LOCALIZED(@"kStringNotifTitle");
        content.body = message;
        //content.sound = [UNNotificationSound soundNamed:soundName];
        content.sound = [UNNotificationSound soundNamed:@"refill.caf"];
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);

        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }

    }


    //1h
#if 0
    if(NO) {
        int minutes = 60; //kWaitMinutes
        NSDate *nextdDate = [NSDate dateWithMinutesFromNow:minutes];



        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        NSString *message = [[CBSkinManager getRandomNotification] randomObject];
        content.title = LOCALIZED(@"kStringNotifTitle");
        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundName];
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);

//        NSString *skinPath2 = skinPath;
//        skinPath2 = [skinPath2 stringByReplacingOccurrencesOfString:@"currentSkinImage.png" withString:[NSString stringWithFormat:@"currentSkinImage%d.png", currentAttachement++]];
//        skinURL = [NSURL fileURLWithPath:skinPath2];

        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }

    }
#endif

    //tonight 8pm
    if(YES) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setLocale:[NSLocale currentLocale]];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];

        int minutes = [kHelpers randomInt:30];
        NSDate *nextdDate = [calendar dateBySettingHour:20 minute:minutes second:0 ofDate:[NSDate date] options:0];

        //too late today, add 1 day
        if([components hour] >= 19)
            nextdDate = [nextdDate dateByAddingDays:1];


        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        NSString *message = [[CBSkinManager getRandomNotification] randomObject];
        content.title = LOCALIZED(@"kStringNotifTitle");
        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundNameChat]; //soundName
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);

//        NSString *skinPath2 = skinPath;
//        skinPath2 = [skinPath2 stringByReplacingOccurrencesOfString:@"currentSkinImage.png" withString:[NSString stringWithFormat:@"currentSkinImage%d.png", currentAttachement++]];
//        skinURL = [NSURL fileURLWithPath:skinPath2];

        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }

    }

    //tonight 4pm
#if 0
    if(NO) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setLocale:[NSLocale currentLocale]];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
        NSDate *nextdDate = [calendar dateBySettingHour:16 minute:0 second:0 ofDate:[NSDate date] options:0];
        //too late today, add 1 day
        if([components hour] >= 15)
            nextdDate = [nextdDate dateByAddingDays:1];


        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        NSString *message = [[CBSkinManager getRandomNotification] randomObject];
        content.title = LOCALIZED(@"kStringNotifTitle");
        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundName];
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);

//        NSString *skinPath2 = skinPath;
//        skinPath2 = [skinPath2 stringByReplacingOccurrencesOfString:@"currentSkinImage.png" withString:[NSString stringWithFormat:@"currentSkinImage%d.png", currentAttachement++]];
//        skinURL = [NSURL fileURLWithPath:skinPath2];

        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }

    }
#endif

    //noon 12pm
    if(YES) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setLocale:[NSLocale currentLocale]];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];

        int minutes = [kHelpers randomInt:30];
        NSDate *nextdDate = [calendar dateBySettingHour:12 minute:minutes second:0 ofDate:[NSDate date] options:0];

        //tomorrow
        if([components hour] >= 11)
            nextdDate = [nextdDate dateByAddingDays:1];


        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        NSString *message = [[CBSkinManager getRandomNotification] randomObject];
        content.title = LOCALIZED(@"kStringNotifTitle");
        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundNameChat]; //soundName
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);

//        NSString *skinPath2 = skinPath;
//        skinPath2 = [skinPath2 stringByReplacingOccurrencesOfString:@"currentSkinImage.png" withString:[NSString stringWithFormat:@"currentSkinImage%d.png", currentAttachement++]];
//        skinURL = [NSURL fileURLWithPath:skinPath2];

        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }
    }


    //IAP expires 2 days, 2h before
    if(YES && ![kAppDelegate isPremium] && [kAppDelegate isPremiumIAPOnSale])
    {
        NSDate *dateExpire = [kAppDelegate.firstLaunchDate dateByAddingDays:kNumDaysPremiumSale];
        //NSDate *nextdDate = [dateExpire dateBySubtractingDays:1]; //1 day before
        NSDate *nextdDate = [dateExpire dateBySubtractingHours:2]; //2 hours before

          UNMutableNotificationContent *content = [UNMutableNotificationContent new];
          //NSString *message = [[CBSkinManager getRandomNotification] randomObject];
          content.title = LOCALIZED(@"kStringNotifTitle");
          content.body = @"Hurry, the VIP sale expires in a few hours! 🏃 ⏰ #fomo";
          content.sound = [UNNotificationSound soundNamed:soundNameChat]; //soundName
          //content.badge = @(1);

          NSError *notifError;
          CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
          NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);


          UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
          if(attachement)
              content.attachments = @[attachement];

          NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
          if(timeInterval>0)
          {
              UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
              UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
              NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
              UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

              [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                  if (error != nil) {
                      Log(@"setupNotifications: Something went wrong: %@",error);
                  }
              }];
          }
          else
          {
              Log(@"invalid interval");
          }
    }


    //next week 8pm
    if(YES) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setLocale:[NSLocale currentLocale]];
        //NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
        int minutes = [kHelpers randomInt:30];
        NSDate *nextdDate = [calendar dateBySettingHour:20 minute:minutes second:0 ofDate:[NSDate date] options:0];

        //next week
        nextdDate = [nextdDate dateByAddingDays:7];

        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        NSString *message = [[CBSkinManager getRandomNotification] randomObject];
        content.title = LOCALIZED(@"kStringNotifTitle");
        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundNameChat]; //soundName
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);


        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }

    }

    //3 weeks later, 8:30pm
    if(YES) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setLocale:[NSLocale currentLocale]];
        //NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
        int minutes = [kHelpers randomInt:30];
        NSDate *nextdDate = [calendar dateBySettingHour:20 minute:minutes second:0 ofDate:[NSDate date] options:0];

        //3 weeks
        nextdDate = [nextdDate dateByAddingDays:7*3];

        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        //NSString *message = @"Three weeks later... ⏰ 📅 😴";
        NSString *message = @"Three weeks later... ⏰ 😴";
        content.title = LOCALIZED(@"kStringNotifTitle");
        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundNameChat]; //soundName
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);


        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }

    }

    //3 months, 8:30pm
    if(YES) {
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        [calendar setLocale:[NSLocale currentLocale]];
        //NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
        int minutes = [kHelpers randomInt:30];
        NSDate *nextdDate = [calendar dateBySettingHour:20 minute:minutes second:0 ofDate:[NSDate date] options:0];

        //6 months, 24 weeks
        //nextdDate = [nextdDate dateByAddingDays:7*4*6];
        //6 months, 26 weeks?
        //nextdDate = [nextdDate dateByAddingDays:7*26];
        //6 months, 13 weeks?
        nextdDate = [nextdDate dateByAddingDays:7*13];

        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        //NSString *message = @"Three weeks later... ⏰ 😴";
        NSString *message = @"New phone, who dis? 😕";

        content.title = LOCALIZED(@"kStringNotifTitle");
        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundNameChat]; //soundName
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);


        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }

    }

    //test 1, 10s
#if 0
    if(NO && [kHelpers isDebug]) {

        //NSDate *nextdDate = [[NSDate date] dateByAddingMinutes:1];
        NSDate *nextdDate = [[NSDate date] dateByAddingSeconds:10];

        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        //NSString *message = [[CBSkinManager getRandomNotification] randomObject];
        //NSString *message = @"Three weeks later... ⏰ 📅 😴";
        //NSString *message = @"Three weeks later... ⏰ 😴";
        NSString *message = @"Hurry, the VIP sale expires in 1 day! 🏃 ⏰ #fomo";

        content.title = LOCALIZED(@"kStringNotifTitle");
        //content.subtitle = test;
        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundName];
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);


        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextdDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }

    }
#endif

    //next monday
    /*if(NO)
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorian setLocale:[NSLocale currentLocale]];
        NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];

        //past monday, go to next week
        if([components weekday] >=  DAY_MONDAY)
            [components setWeek: [components week] + 1];

        int hour = 20;
        [components setWeekday:DAY_MONDAY]; //Monday
        [components setHour:hour]; //8pm
        [components setMinute:0];
        [components setSecond:0];

        NSDate *nextdDate = [gregorian dateFromComponents:components];

        UILocalNotification *notif = [[UILocalNotification alloc] init];
        if (notif == nil)
            return;

        NSString *message = [[CBSkinManager getRandomNotification] randomObject];

        notif.fireDate = nextdDate;
        notif.repeatInterval = 0;
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = message;
        notif.alertAction = LOCALIZED(@"kStringNotificationButton");
        //notif.soundName = UILocalNotificationDefaultSoundName;
        notif.soundName = soundName;
        //notif.applicationIconBadgeNumber = 1;

        // Schedule the notification
        //between 10 and 10
        if(hour <= minHour && hour < maxHour)
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
    */

    //next saturday morning
    if(YES)
    {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [gregorian setLocale:[NSLocale currentLocale]];
        NSDateComponents *components = [gregorian components:NSYearCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];

        //past friday, go to next week
        if([components weekday] >=  DAY_SATURDAY)
            [components setWeek: [components week] + 1];

        int hour = 9;
        [components setWeekday:DAY_SATURDAY]; //saturday
        [components setHour:hour];
        [components setMinute:0];
        [components setSecond:0];

        NSDate *nextdDate = [gregorian dateFromComponents:components];

        UILocalNotification *notif = [[UILocalNotification alloc] init];
        if (notif == nil)
            return;

        NSString *message = @"Saturday morning special! Coin Power multiplier 2x until 11am! ⏰ 🔥";

        notif.fireDate = nextdDate;
        notif.repeatInterval = 0;
        notif.timeZone = [NSTimeZone defaultTimeZone];
        notif.alertBody = message;
        notif.alertAction = LOCALIZED(@"kStringNotificationButton");
        notif.soundName = soundName;

        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }


    //heart full

    /*if(NO) {

        int heartsNeeded = kHeartFull - (int)self.numHearts;
        if(heartsNeeded > 0) {

            float heartHealTime = [CBSkinManager getHeartHealTime];
            heartHealTime *= heartsNeeded;


            NSDate *nextdDate = [NSDate date];

            nextdDate = [nextdDate dateByAddingMinutes:heartHealTime/60.0f]; //seconds

            UILocalNotification *notif = [[UILocalNotification alloc] init];
            if (notif == nil)
                return;

            //NSString *message = @"Your hearts are now full!\n\u2764\u2764\u2764";
            NSString *message = @"Your hearts are now full!  \u2764";

            notif.fireDate = nextdDate;
            //notif.repeatInterval = 0;
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.alertBody = message;
            notif.alertAction = LOCALIZED(@"kStringNotificationButton");
            //notif.soundName = UILocalNotificationDefaultSoundName;
            notif.soundName = @"refill.caf"; //soundName;
            //notif.applicationIconBadgeNumber = 1;

            // Schedule the notification
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        }

    }*/

    //heart one, and if empty
    /*if(NO) {

        int heartsNeeded = kHeartFull - (int)self.numHearts;
        if(heartsNeeded == kHeartFull) {

            float heartHealTime = [CBSkinManager getHeartHealTime];

            NSDate *nextdDate = [NSDate date];

            nextdDate = [nextdDate dateByAddingMinutes:heartHealTime/60.0f]; //seconds

            UILocalNotification *notif = [[UILocalNotification alloc] init];
            if (notif == nil)
                return;

            NSString *message = @"You now have enough hearts \nto continue!  \u2764";

            notif.fireDate = nextdDate;
            //notif.repeatInterval = NSWeekCalendarUnit; //repeat every week
            notif.timeZone = [NSTimeZone defaultTimeZone];
            notif.alertBody = message;
            notif.alertAction = LOCALIZED(@"kStringNotificationButton");
            //notif.soundName = UILocalNotificationDefaultSoundName;
            notif.soundName = @"refill.caf"; //soundName;
            //notif.applicationIconBadgeNumber = 1;

            // Schedule the notification
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
        }

    }*/

    //chest
    if(kAppDelegate.level >= kChestLevel && kAppDelegate.chestDate)
    {
        NSTimeInterval intervalNeeded = kChestIntervalNeeded;
        if([kAppDelegate isPremium])
            intervalNeeded /= 2;

        NSDate *nextDate = [kAppDelegate.chestDate dateByAddingTimeInterval:intervalNeeded];

        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
		//🎁 🎉 🔑🗝📦💰 🆓 🎁 🤑 🏆
        //NSString *message = @"A new reward chest is waiting for you! 🎁";
        //NSString *message = @"A new chest is waiting for you!";  //is available? ready?
        NSString *message = @"Your free gift is ready!";  //is available? ready?

        //notif title
        NSMutableArray *titleArray = [@[LOCALIZED(@"kStringNotifTitleReward")] mutableCopy];
        if(self.level > 3)
        {
            [titleArray addObject:LOCALIZED(@"kStringNotifTitleReward2")];
            [titleArray addObject:LOCALIZED(@"kStringNotifTitleReward3")];
        }

        content.title = [titleArray randomObject];

        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundName];
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);

        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }


		//also 24 hours after 1st notif
		nextDate = [nextDate dateByAddingHours:24];
		timeInterval = [nextDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }

    }


    //chest forgot, 30s later
    if([kAppDelegate.titleController chestReady])
    {
        int secs = [kHelpers randomInt:30];
        NSDate *nextDate = [[NSDate date] dateByAddingSeconds:30+secs];
        UNMutableNotificationContent *content = [UNMutableNotificationContent new];
        NSString *message =
            [@[
               @"You forgot to unlock your chest! 😢", //crying
               @"You forgot to unlock your chest! 😭", //loud crying
              ]randomObject];

        //notif title
        NSMutableArray *titleArray = [@[LOCALIZED(@"kStringNotifTitleReward")] mutableCopy];

        content.title = [titleArray randomObject];

        content.body = message;
        content.sound = [UNNotificationSound soundNamed:soundNameChat]; ///soundName
        //content.badge = @(1);

        NSError *notifError;
        CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
        NSDictionary* dict = (__bridge NSDictionary*)CGRectCreateDictionaryRepresentation(rect);

        UNNotificationAttachment *attachement = [UNNotificationAttachment attachmentWithIdentifier:@"skin" URL:skinURL options:@{UNNotificationAttachmentOptionsThumbnailClippingRectKey:dict} error:&notifError];
        if(attachement)
            content.attachments = @[attachement];

        NSTimeInterval timeInterval = [nextDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }


        //also 24 hours after 1st notif
        /*nextDate = [nextDate dateByAddingHours:24];
        timeInterval = [nextDate timeIntervalSinceDate:[NSDate date]];
        if(timeInterval>0)
        {
            UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:timeInterval repeats:NO];
            UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
            NSString *identifier = [NSString stringWithFormat:@"local_notifications_protip_%d_%@", identCount++, [kHelpers randomString:5]];
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier  content:content trigger:trigger];

            [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                if (error != nil) {
                    Log(@"setupNotifications: Something went wrong: %@",error);
                }
            }];
        }
        else
        {
            Log(@"invalid interval");
        }*/

    }

}

#pragma mark -
#pragma mark GameCenter

- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController {
    [[self.rootController currentViewController] presentViewController:gameCenterLoginController animated:YES completion:^{
        Log(@"Finished Presenting Authentication Controller");
    }];
}


- (void)gameCenterManager:(GameCenterManager *)manager availabilityChanged:(NSDictionary *)availabilityInformation {

    NSString *newName = [[GKLocalPlayer localPlayer]alias];
		if(newName) {
					self.gamecenterName = newName;
		}
    //get display name
    /*[[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:^(NSString *leaderboardIdentifier, NSError *error) {

        if (error != nil) {
            Log(@"%@", [error localizedDescription]);
        }
        else{
            self.gamecenterName = leaderboardIdentifier;
        }
    }];*/

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //[[PFFacebookUtils session] close];

    [self saveState:NO];

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    //[kHelpers dismissHud];

    self.appActive = YES;

    //[self.gameScene  enablePause:NO];

    //force pause, auto-unpauses?
    if(self.titleController.menuState == menuStateGame) {
        //self.gameScene.paused = YES;
        [self.gameScene enablePause:YES];
    }

    // resume audio
    //[[AVAudioSession sharedInstance] setActive:YES error:nil];

    //intercept volume change
#if 0
    AVAudioSession* audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil]; // Start Audio Session
    [audioSession addObserver:self  //observer for the audio session
                   forKeyPath:kKVO_Volume
                      options:0
                      context:nil];
#endif
		//allow music from other app at same time
		//[self setupAudioSession];


    //[AVAudioSession sharedInstance].usesAirPlayVideoWhileAirPlayScreenIsActive = NO;


    [[FISoundEngine sharedEngine] setSuspended:NO];
    [self.gameScene setSoundVolume];


    //resume but not during loading, or when paused
    if(self.titleController && self.titleController.menuState != menuStateGame)
        [self resumeMusic];

    //reset particle
    if(self.gameScene) {
        [self.gameScene resetParticles];
    }

    [self loadAchievements];
}

-(void)stopAllAudio {
	[self stopMusic];
	[[SoundManager sharedManager] stopAllSounds];
	[self.gameScene stopAllSounds];

}
- (void)applicationWillResignActive:(UIApplication *)application
{
    //[kHelpers dismissHud];

    self.appActive = NO;

    //siri
    [self stopAllAudio];

    if(self.titleController.menuState != menuStateLoading && self.titleController.menuState != menuStateNone)
    {
        // prevent audio crash
        [[FISoundEngine sharedEngine] setSuspended:YES];
        [[AVAudioSession sharedInstance] setActive:NO error:nil];

//        AVAudioSession* audioSession = [AVAudioSession sharedInstance];
//        [audioSession removeObserver:self forKeyPath:kKVO_Volume];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    self.appActive = NO;

    //save data
    self.dateBackground = [NSDate date];
    self.dateBackground2 = [NSDate date];

	self.dateBackgroundRoot = [NSDate date];

    //save score
    [self reportScore];

    //notif
    if(self.notifyEnabled && self.launchCount >= 1) //after 2nd launch
        [self setupNotifications];

    //time
    [self updateForegroundTime];

    [self saveState:NO];


    //parse
    [self dbSaveObjects];

    //force crash
    //force quit if loading
    if(!self.titleController || self.titleController.menuState == menuStateLoading || self.titleController.menuState == menuStateNone)
    {
        //force reload sounds
        if(self.launchCount == 0) {
            self.prefSoundsConverted = NO;
            [self saveState];
        }

        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //Log(@"Forced crash");
            //exit(0);

            //disabled
            //[self forceCrash:@"Background during load"];
            //self.forceReload = YES;

        //});
    }


    //timers
    [self.timerRefill invalidate];
    self.timerRefill = nil;
}

#if 0
-(void)killApplication {
    // Try to run a system call for kill
    system(KILL);

    // SIGKILL
    [[UIApplication sharedApplication] sendAction:SIGKILL to:[UIApplication sharedApplication] from:self forEvent:nil];

    // Try an infinite while loop to gobble up memory
    int x = 0;
    NSMutableArray *haha = [[NSMutableArray alloc] init];
    while (1) {
        [haha addObject:@"42"];
        x++;
    }

    // If all else fails, close the app
    close(0);
}
#endif

-(void)forceCrash:(NSString*)message {
    message = [NSString stringWithFormat:@"Forced crash: %@", message];
    Log(@"%@", message);
    [NSException raise:message format:@""];
}

- (void)resetTimer{

    //float interval = 1; //kTimerDelayRandomEvent;

    [self.timerRefill invalidate];
    self.timerRefill = nil;
}

- (void) actionTimerRefill:(NSTimer *)incomingTimer
{
    [self checkHeartHeal];
}

-(void)updateForegroundTime {
    NSInteger secondsInScreen = ABS([self.foregroundDate timeIntervalSinceNow]);
    self.timeForeground += secondsInScreen;
    self.foregroundDate = [NSDate date];

    //update firebase
    [self dbIncTimeForeground];

   //[self saveState];
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqual:kKVO_Volume]) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{


            if(self.titleController.menuState != menuStateLoading && self.titleController.menuState != menuStateNone) {

                if(self.titleController.menuState == menuStateTitle)
                {
                    [self.titleController resetTimerStory];
                }

                float time = fabs([self.volumeChangeDate timeIntervalSinceNow]);
                Log(@"interval: %f", time/1.0f);

                if(fabs([self.volumeChangeDate timeIntervalSinceNow]) > 0.3f) {

                    self.volumeChangeDate = [NSDate date];
                    [self playSound:kClickSound];
                }
            }

        });


        Log(@"volume changed!");
    }
}

-(void)resetAchievements
{
    // Clear all locally saved achievement objects.
    self.earnedAchievementCache = nil;

    // Clear all progress saved on Game Center
    [GKAchievement resetAchievementsWithCompletionHandler:^(NSError *error)
     {
         if (error != nil)
         {
             Log(@"resetAchievements: error: %@", error);
         }

     }];

}

-(void)checkAchievements
{
	//achievements

	//count related
    if(self.clickCount >= 100)
        [kAppDelegate reportAchievement:kAchievement_100coins];
    if(self.clickCount >= 1000)
        [kAppDelegate reportAchievement:kAchievement_1000coins];
    if(self.clickCount >= 10000)
        [kAppDelegate reportAchievement:kAchievement_10000coins];
    if(self.clickCount >= 100000)
        [kAppDelegate reportAchievement:kAchievement_100000coins];
    if(self.clickCount >= 1000000)
        [kAppDelegate reportAchievement:kAchievement_1000000coins];

    if(self.clickCount >= 314)
        [kAppDelegate reportAchievement:kAchievement_314coins];
    if(self.clickCount >= 9000)
        [kAppDelegate reportAchievement:kAchievement_9000coins];

	//combo

	if(self.maxCombo >= 20)
        [kAppDelegate reportAchievement:kAchievement_combo1];

	if(self.maxCombo >= 50)
        [kAppDelegate reportAchievement:kAchievement_combo2];

	if(self.maxCombo >= 100)
        [kAppDelegate reportAchievement:kAchievement_combo3];
}

-(void)loadAchievements
{
    if(self.earnedAchievementCache)
        return;

    [GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
     {
         if(error == NULL)
         {
             NSMutableDictionary* tempCache = [NSMutableDictionary dictionaryWithCapacity: [scores count]];
             for (GKAchievement* score in scores)
             {
                 [tempCache setObject: score forKey: score.identifier];
             }
             self.earnedAchievementCache = tempCache;
             //[self reportAchievement:name];
         }
         else
         {
             Log(@"loadAchievementsWithCompletionHandler: %@", error);
         }

     }];
}

-(void)reportAchievement:(NSString*)name {

    //disabled;
    //return;

    if(![self isGameCenter])
        return;

    //too soon
    /*
    if(self.achievementDate == nil)
        self.achievementDate = [NSDate date];
    int seconds = ((int)([self.achievementDate timeIntervalSinceNow]));
    seconds = abs(seconds);
    if(seconds > 10)
    {
        //return;
    }
    self.achievementDate = [NSDate date];
     */

    //delayed
    float secs = 1.0f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(self.earnedAchievementCache == NULL)
        {
            //ignore? or send anyways
            [[GameCenterManager sharedManager] saveAndReportAchievement:name percentComplete:100 shouldDisplayNotification:YES];
        }
        else
        {
            GKAchievement* achievement = [self.earnedAchievementCache objectForKey:name];
            if(achievement)
            {
                //Log(@"**** reportAchievement: already: %@", name);
            }
            else
            {
                [[GameCenterManager sharedManager] saveAndReportAchievement:name percentComplete:100 shouldDisplayNotification:YES];

                //placeholder
                [self.earnedAchievementCache setObject:(@(1)) forKey:name];
            }
        }
    });
}


-(void)reportScore {
    //disabled;
    //return;

    if(![self isGameCenter])
        return;

    int score = (int)self.clickCount;

    if([self isGameCenter]) {

        [[GameCenterManager sharedManager] saveAndReportScore:score leaderboard:kLeaderboardID
                                            sortOrder:GameCenterSortOrderHighToLow];
    }

}

- (BOOL)isGameCenter {
    if(!kGameCenterEnabled)
        return NO;

//    if(!self.gameCenterRemoteEnabled)
//        return NO;

    if(!self.gameCenterEnabled)
        return NO;

    if([kHelpers isSimulator])
        return NO;

    BOOL value = [[GameCenterManager sharedManager] checkGameCenterAvailability:YES];
    //BOOL value = YES;
    return value;
}


- (void)gameCenterManager:(GameCenterManager *)manager reportedAchievement:(GKAchievement *)achievement withError:(NSError *)error {
    if (!error) {
        //Log(@"GCM Reported Achievement: %@", achievement);
    } else {
        Log(@"GCM Error while reporting achievement: %@", error);
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.appActive = YES;

    self.isPlayingVideoAd = NO;

    //reset title sound, if in game or already title
    if(self.titleController.menuState == menuStateGame) {
        self.playedIntroSound = NO;
    }

    if(self.titleController.menuState == menuStateGame)
    {
        self.gameController.darkAdImage.hidden = YES;
    }

    if(self.titleController.menuState == menuStateTitle) {

        self.playedIntroSound = YES;

        float secs = 1.0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //[self playSound:@"intro.caf"];
        });

    }

    //for ad
    [kHelpers dismissHud];

    //gamecenter
    [self reportScore];

    //update parse
    [self getRemoteConfig];

    //parse
    [self dbInitObjects];

    //notif
    //[[UIApplication sharedApplication] cancelAllLocalNotifications];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removeAllPendingNotificationRequests];

    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;


    //time
    self.foregroundDate = [NSDate date];

    //refresh iap
    [self getIAP];

    //check hearts
    //[self checkHeartHeal];
    //timers
    [self resetTimer];


    if(![kHelpers checkOnline]) {
        //offline
        [self setupGameCenter];
    }

    //force reload
    /*if(self.forceReload)
    {
        self.forceReload = NO;
        [self.rootController launch];
    }*/

    [self checkHeartRefill];


    //big ad
	#if 1
    if([kHelpers randomBool100:[self getInterstitialOdds:self.interstitialForegroundOdds]])
    {
        //after delay
        float secs = 0.5f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self showInterstitial:kRewardScreen];
        });
    }
	#endif

	//back to home, after delay, 15m
	if(self.dateBackgroundRoot && (kAppDelegate.titleController.menuState != menuStateTitle) )
	{
		NSTimeInterval interval = [self.dateBackgroundRoot timeIntervalSinceNow];
		interval = ABS(interval);
        //if(self.dateBackgroundRoot && interval > 10) //seconds, 10s debug
        if(self.dateBackgroundRoot && interval > 15*60) //seconds, 15m
		{
            if(self.alertView && self.alertView.visible)
                [self.alertView dismissAnimated:NO];

            //reset buff too
            kAppDelegate.currentBuff = kBuffTypeNone;
            kAppDelegate.buffSecs = 0;

			self.dateBackgroundRoot = nil;
			//kAppDelegate.titleController.menuState = menuStateTitle
			[kAppDelegate setViewController:kAppDelegate.titleController];
		}
	}

}

- (UIStoryboard *)storyboard {
    UIStoryboard *tempStoryboard = nil;

    tempStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    return tempStoryboard;
}


#pragma mark - Sound

-(void)convertSound:(NSString*)soundName {

    //Log(@"convertSound: soundnamed: %@", soundName);
    assert(![soundName containsString:@".wav"]);
    assert([soundName containsString:@".caf"]);

    NSString *soundNameWav = [soundName stringByReplacingOccurrencesOfString:@".caf" withString:@".wav"];
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
    if(!soundPath && [kHelpers isDebug])
    {
        Log(@"***** convertSound missing sound: %@", soundNameWav);
        Log(@"*****");

        assert(soundPath); //catch deleted sounds
    }

    NSString *soundPathNew = [kAppDelegate savePath];

    soundPathNew = [soundPathNew stringByAppendingString:soundNameWav];

    ExtAudioConverter* converter = [[ExtAudioConverter alloc] init];
    converter.inputFile =  soundPath;
    converter.outputFile = soundPathNew;

    converter.outputNumberChannels = 1;
    converter.outputBitDepth = BitDepth_16;
    converter.outputFormatID = kAudioFormatLinearPCM;
    converter.outputFileType = kAudioFileWAVEType;
    [converter convert];
}

-(void)setupAudioSession {
	//audio session
	//allow music from other app at same time, default: AVAudioSessionCategorySoloAmbient
	AVAudioSession* audioSession = [AVAudioSession sharedInstance];
	NSError *error = nil;

	[audioSession setCategory: AVAudioSessionCategoryAmbient error: &error]; //good
    //[audioSession setCategory: AVAudioSessionCategoryPlayback error: &error]; //test

    [audioSession setActive:YES error: &error];
}

- (void)preloadSound:(NSString*)name
{
    [self playSound:name];
}

- (void)stopSound:(NSString*)name
{
    if(kAppDelegate) {
        //https://github.com/nicklockwood/SoundManager

        name = [name stringByReplacingOccurrencesOfString:@".caf" withString:@".wav"];

        //try to hide exception
        @try {
            [[SoundManager sharedManager] stopSound:name fadeOut:NO];
        }
        @catch (NSException *exception) {
            Log(@"%@", exception.reason);
        }
        @finally {
        }
    }
}

- (void)playSound:(NSString*)name
{
    [self playSound:name force:NO];
}

- (void)playSound:(NSString*)name force:(BOOL)force
{
    if(self.isPlayingVideoAd && !force)
        return;

    if ([kHelpers isBackground] && !force)
        return; //background

    NSString *soundName = name;
    //Log(@"CGAppDelegate: playSound: %@", soundName);

    //disable
    //return;

    assert(![name containsString:@".wav"]);
    assert([name containsString:@".caf"]);

    //get local wav instead
    NSString *soundNameWav = [soundName stringByReplacingOccurrencesOfString:@".caf" withString:@".wav"];
    NSString *soundPathNew = [self savePath];
    soundName = [soundPathNew stringByAppendingString:soundNameWav];

    //aiff
    //NSString *soundNameWav = [soundName stringByReplacingOccurrencesOfString:@".caf" withString:@".aiff"];
    //NSString *soundNameWav = [soundName stringByReplacingOccurrencesOfString:@".caf" withString:@".wav"];
    //soundName = [[NSBundle mainBundle] pathForResource:soundNameWav ofType:nil];

    //bundle
    //Log(@"playSound: %@", soundName);

    if(!soundName || soundName.length == 0)
        return;

    if(self.isPlayingVideoAd && !force)
        return;

    if(kAppDelegate) {
        //https://github.com/nicklockwood/SoundManager
       // [[SoundManager sharedManager] playSound:soundName looping:NO];

        //try to hide exception
        @try {
            [[SoundManager sharedManager] playSound:soundName looping:NO];
        }
        @catch (NSException *exception) {
            Log(@"%@", exception.reason);
        }
        @finally {
        }

    }
}


- (void)resumeMusic {

    if(!self.currentMusic || [self.currentMusic isEqualToString:@""])
       [self playMusicRandom]; //no music yet, random
    else
        [self playMusic:self.currentMusic andRemember:YES];
}

- (void)playMusicTheme {
    NSString *name = [CBSkinManager getMusicName];

    if(self.currentBuff != kBuffTypeNone)
    {
       //buff music, good or bad

        if(self.currentBuff == kBuffTypeInk || self.currentBuff == kBuffTypeShrink)
            name = kMusicNameBuffBad;
        else
            name = kMusicNameBuff;
    }
    else if(self.subLevel == 4)
    {
        //castle
        name =  kMusicNameCastle;
    }
    else if(self.level == kLevelMax)
    {
        //castle music for last level

        if(self.inReview)
            name =  kMusicNameCastle;
        else
            name =  kMusicNameLast;
    }

    [self playMusic:name andRemember:YES];
}

- (void)playMusicRandom {

    [self playMusicTheme];

    return;
    /*
    NSMutableArray *musicArray= [@[
        kMusicNameDefault
        ] mutableCopy];

	//remove current
    if(self.currentMusic && ![self.currentMusic isEqualToString:@""])
        [musicArray removeObject:self.currentMusic];

    NSString *newMusic = [musicArray randomObject];

    [self playMusic:newMusic andRemember:YES];*/
}

- (void)playMusicForced:(NSString*)name {

    //try to hide exception
    //[[SoundManager sharedManager] playMusic:name looping:YES];
    @try {
        [[SoundManager sharedManager] playMusic:name looping:YES];
    }
    @catch (NSException *exception) {
        Log(@"%@", exception.reason);
    }
    @finally {
    }

}

- (void)playMusic:(NSString*)name andRemember:(BOOL)remember
{
    [self playMusic:name andRemember:remember looping:YES];
}

- (void)playMusic:(NSString*)name andRemember:(BOOL)remember looping:(BOOL)looping
{
    //disabled
    //return;

    if(!kMusicEnabled)
        return;

    //if(self.isLoading)
    //    return;

    //if(self.titleController.menuState !=

    if(remember)
        self.currentMusic = name;

    //Log(@"playMusic: %@", name);


    //try to hide exception
    //[[SoundManager sharedManager] playMusic:name looping:looping];
    @try {
        [[SoundManager sharedManager] playMusic:name looping:looping];
    }
    @catch (NSException *exception) {
        Log(@"%@", exception.reason);
    }
    @finally {
    }

}

- (void)stopMusic
{
    //self.currentMusic = @"";

    if(!kMusicEnabled)
        return;

    [[SoundManager sharedManager] stopMusic:NO];
}

- (void)setSoundVolume:(double)volume
{
    _soundVolume = volume;
    [[SoundManager sharedManager] setSoundVolume:volume];

    //[self saveState];
}

- (void)setMusicVolume:(double)volume
{
    _musicVolume = volume;

    [[SoundManager sharedManager] setMusicVolume:volume * kMusicVolumeMultiplier];

    //[self saveState];
}

- (void)setCredits:(int)value
{
    _credits = value;

    if(_credits < 0)
        _credits = 0;

    if(_credits >99)
        _credits = 99;

    [self saveState];
}

//icloud
- (void)updateKeyValuePairs:(NSNotification *)notification {

    Log(@"iCloud: updateKeyValuePairs **************************");

    NSDictionary *userInfo = [notification userInfo];
    NSNumber *changeReason = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    NSInteger reason = -1;

    // Is a Reason Specified?
    if (!changeReason) {
        return;

    }
    else {
        reason = [changeReason integerValue];
    }

    // Proceed If Reason Was (1) Changes on Server or (2) Initial Sync
    if ((reason == NSUbiquitousKeyValueStoreServerChange) || (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
        NSArray *changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:kPrefGroup];
        NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];

        if([kHelpers isDebug]) {
            if(self.titleController.menuState != menuStateLoading && self.titleController.menuState != menuStateNone) {
                //[kHelpers showSuccessHud:LOCALIZED(@"iCloud")];

                Log(@"iCloud: NSUbiquitousKeyValueStoreServerChange/NSUbiquitousKeyValueStoreInitialSyncChange **************************");

            }
        }

        //save to current
        for (NSString *key in changedKeys) {

            if ([key isEqualToString:@"saveDate_icloud"]) {
                [prefs setObject:[store objectForKey:key] forKey:@"saveDate_icloud"];
            }
            if ([key isEqualToString:@"clickCount_icloud"]) {
                [prefs setObject:[store objectForKey:key] forKey:@"clickCount_icloud"];
            }
            if ([key isEqualToString:@"level_icloud"]) {
                [prefs setObject:[store objectForKey:key] forKey:@"level_icloud"];
            }
            if ([key isEqualToString:@"subLevel_icloud"]) {
                [prefs setObject:[store objectForKey:key] forKey:@"subLevel_icloud"];
            }
            if ([key isEqualToString:@"maxCombo_icloud"]) {
                [prefs setObject:[store objectForKey:key] forKey:@"maxCombo_icloud"];
            }
			if ([key isEqualToString:@"maxComboLevel_icloud"]) {
                [prefs setObject:[store objectForKey:key] forKey:@"maxComboLevel_icloud"];
            }

        }

        ///
        [self saveState];
    }
}

- (void)loadState {

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:kPrefGroup];

    //set defaults
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:

                                [NSNumber numberWithFloat:kDefaultVolumeSound], @"soundVolume",
                                 [NSNumber numberWithFloat:kDefaultVolumeMusic], @"musicVolume",
                                 [NSNumber numberWithInt:kDefaultCoins], @"credits",
                                 [NSNumber numberWithInteger:0], @"clickCount",
                                 //[NSNumber numberWithInteger:0], @"clickCountReal",
                                 [NSNumber numberWithInteger:0], @"clickCountWorld",
                                 [NSNumber numberWithInteger:kPotionStart], @"numPotions",
                                 [NSNumber numberWithInteger:0], @"oneUpInc",
                                 [NSNumber numberWithInteger:0], @"nextOneUp",
                                 [NSNumber numberWithInteger:0], @"lastOneUp",
                                 [NSNumber numberWithInteger:0], @"rewindClickCount",
                                 [NSNumber numberWithInteger:1], @"level",
                                 [NSNumber numberWithInteger:1], @"subLevel",
                                 [NSNumber numberWithInteger:0], @"starLevelCount",
                                 [NSNumber numberWithInteger:kNumAppsDefault], @"numApps",
                                 [NSNumber numberWithInteger:0], @"currentSkin",
                                 [NSNumber numberWithInteger:kHeartFullDefault], @"numHearts",
                                 [NSNumber numberWithInteger:0], @"currentCastle",
                                 [NSNumber numberWithInteger:[CBSkinManager getWorldTime]], @"worldTimeLeft",
                                 [NSNumber numberWithBool:NO], @"isRandomSkin",
                                 [NSNumber numberWithInteger:1], @"lifes",
                                 [NSNumber numberWithBool:YES], @"inReview", //default yes
                                 [NSNumber numberWithBool:NO], @"showCommercial", //default no
                                 [NSNumber numberWithBool:YES], @"vibrationEnabled",
                                 [NSNumber numberWithBool:NO], @"doubleEnabled",
                                 [NSNumber numberWithBool:NO], @"playedIntroAlert",
                                 [NSNumber numberWithBool:NO], @"playedIntroCheat",
                                 [NSNumber numberWithBool:NO], @"playedWelcomeAlert",
                                 [NSNumber numberWithBool:NO], @"playedLavaAlert",
                                 [NSNumber numberWithBool:NO], @"playedLastLevel",
                                 [NSNumber numberWithBool:NO], @"playedStoreAlert",
                                 [NSNumber numberWithBool:NO], @"playedX4Alert",
                                 [NSNumber numberWithBool:NO], @"playedWeakSpotAlert",
                                 [NSNumber numberWithBool:NO], @"playedLowHeartAlert",
                                 [NSNumber numberWithBool:NO], @"playedRainbowCoinAlert",
                                 [NSNumber numberWithBool:NO], @"playedLowTimeAlert",
                                 [NSNumber numberWithBool:NO], @"playedShieldAlert",
                                 [NSNumber numberWithBool:NO], @"playedDoublerAlert",
                                 [NSNumber numberWithBool:NO], @"playedAutoAlert",
                                 [NSNumber numberWithBool:NO], @"playedGrowAlert",
                                 [NSNumber numberWithBool:NO], @"playedShrinkAlert",
                                 [NSNumber numberWithBool:NO], @"playedInkAlert",

                                 [NSNumber numberWithBool:NO], @"playedWeakAlert",

                                 [NSNumber numberWithBool:NO], @"playedStarAlert",
                                 [NSNumber numberWithBool:NO], @"prefInstallCountSent",

                                 [NSNumber numberWithBool:NO], @"playedHelpPowerupReady",
                                 [NSNumber numberWithBool:NO], @"playedHelpFire",

                                 [NSNumber numberWithBool:NO], @"touchedPremium",

                                 [NSNumber numberWithBool:YES], @"adBannerEnabled",
                                 [NSNumber numberWithBool:YES], @"adBannerEnabledTemp",

                                 [NSNumber numberWithBool:NO], @"tutoArrowClickedTitle",
                                 [NSNumber numberWithBool:NO], @"tutoArrowClickedBlock",
                                 [NSNumber numberWithBool:NO], @"tutoArrowClickedStar",
                                 [NSNumber numberWithBool:NO], @"tutoArrowClickedSquare",


                                 [NSNumber numberWithBool:NO], @"launchInGame",
                                 [NSNumber numberWithBool:YES], @"notifyEnabled",
                                 [NSNumber numberWithBool:NO], @"notifyAsked",
                                 [NSNumber numberWithBool:NO], @"notifyAccepted",

                                 [NSNumber numberWithInteger:0], @"launchCount",

                                 [NSNumber numberWithBool:NO], @"starVisible",
                                 [NSNumber numberWithBool:NO], @"heartVisible",

                                 [NSNumber numberWithBool:YES], @"gameCenterRemoteEnabled",
                                 [NSNumber numberWithBool:YES], @"gameCenterEnabled",
                                 [NSNumber numberWithBool:NO], @"gameCenterAsked",
                                 [NSNumber numberWithBool:NO], @"mailingAsked",

                                 [NSNumber numberWithBool:NO], @"prefOpened",
                                 [NSNumber numberWithInteger:0], @"rainbowCount",
                                 [NSNumber numberWithInteger:0], @"rainbowUsedCount",

                                 [NSNumber numberWithInteger:0], @"timeForeground",
                                 [NSNumber numberWithInteger:0], @"prefNumFireballsTouched",
                                 [NSNumber numberWithInteger:0], @"numRedCoins",
                                 [NSNumber numberWithInteger:0], @"prefLevelNumFireballsTouched",
                                 [NSNumber numberWithInteger:kBuffTypeNone], @"currentBuff",
                                 [NSNumber numberWithInteger:0], @"buffSecs",
                                 [NSNumber numberWithInteger:0], @"powerupCountLocal",

                                 [NSNumber numberWithInteger:0], @"coffeeCount",
                                 [NSNumber numberWithInteger:kPowerUpTypeNone], @"lastPowerup",

                                 [NSNumber numberWithInteger:0], @"numEndings",
                                 [NSNumber numberWithInteger:0], @"deathCount",

                                 [NSNumber numberWithInteger:0], @"maxCombo",
                                 [NSNumber numberWithInteger:0], @"maxComboLevel",

                                 [NSNumber numberWithBool:NO], @"prefSoundsConverted",

                                 [NSNumber numberWithInteger:100], @"interstitialAfterWinOdds",
                                 [NSNumber numberWithInteger:0], @"interstitialTitleOdds",
                                 [NSNumber numberWithInteger:0], @"bannerOdds",
                                 [NSNumber numberWithInteger:0], @"currentVersion",
                                 [NSNumber numberWithInteger:0], @"interstitialForegroundOdds",
                                 [NSNumber numberWithInteger:50], @"navPlusOdds",
                                 [NSNumber numberWithInteger:1], @"powerupClickOdds",
                                 [NSNumber numberWithInteger:30], @"powerupTimerOdds",

                                 [NSNumber numberWithInteger:60], @"interstitialDelayBetween",

                                 [NSNumber numberWithInteger:0], @"toastieMult",

                                 nil];

    [prefs registerDefaults:appDefaults];
    [prefs synchronize];

    _soundVolume = [[prefs objectForKey:@"soundVolume"] floatValue];
    _musicVolume = [[prefs objectForKey:@"musicVolume"] floatValue];

    _credits = [[prefs objectForKey:@"credits"] intValue];
    _clickCount = [[prefs objectForKey:@"clickCount"] doubleValue];
    _clickCountWorld = [[prefs objectForKey:@"clickCountWorld"] doubleValue];

    //_clickCountReal = [[prefs objectForKey:@"clickCountReal"] doubleValue];
    _numPotions = [[prefs objectForKey:@"numPotions"] doubleValue];

    _rewindClickCount = [[prefs objectForKey:@"rewindClickCount"] doubleValue];

    _oneUpInc = [[prefs objectForKey:@"oneUpInc"] doubleValue];
    _nextOneUp = [[prefs objectForKey:@"nextOneUp"] doubleValue];
    _lastOneUp = [[prefs objectForKey:@"lastOneUp"] doubleValue];
    _toastieMult = [[prefs objectForKey:@"toastieMult"] doubleValue];

    _deathCount = [[prefs objectForKey:@"deathCount"] integerValue];
    _numEndings = [[prefs objectForKey:@"numEndings"] integerValue];
    _lastPowerup = [[prefs objectForKey:@"lastPowerup"] integerValue];

    _level = [[prefs objectForKey:@"level"] integerValue];
    _subLevel = [[prefs objectForKey:@"subLevel"] integerValue];
    _starLevelCount = [[prefs objectForKey:@"starLevelCount"] integerValue];
    _numApps = [[prefs objectForKey:@"numApps"] integerValue];
    _currentSkin = [[prefs objectForKey:@"currentSkin"] integerValue];
    if(_currentSkin < kCoinTypeDefault || _currentSkin >= kNumSkins)
        _currentSkin = kCoinTypeDefault;

    _numHearts = [[prefs objectForKey:@"numHearts"] integerValue];
    _currentCastle = [[prefs objectForKey:@"currentCastle"] integerValue];
    _worldTimeLeft = [[prefs objectForKey:@"worldTimeLeft"] integerValue];
    _isRandomSkin = [[prefs objectForKey:@"isRandomSkin"] integerValue];

    _lifes = [[prefs objectForKey:@"lifes"] integerValue];
    if(_lifes > kMaxLifes)
        _lifes = kMaxLifes;


    _launchCount = [[prefs objectForKey:@"launchCount"] integerValue];
    _inReview = [[prefs objectForKey:@"inReview"] boolValue];
    if([kHelpers isDebug]) {
        //force
        //self.inReview = NO;
    }

    _showCommercial = [[prefs objectForKey:@"showCommercial"] boolValue];

    _shouldGetCountry = [[prefs objectForKey:@"shouldGetCountry"] boolValue];
    _shouldGetBitcoin = [[prefs objectForKey:@"shouldGetBitcoin"] boolValue];

    _navPlusOdds = [[prefs objectForKey:@"navPlusOdds"] floatValue];
    _powerupClickOdds = [[prefs objectForKey:@"powerupClickOdds"] floatValue];
    _powerupTimerOdds = [[prefs objectForKey:@"powerupTimerOdds"] floatValue];

    _interstitialAfterWinOdds = [[prefs objectForKey:@"interstitialAfterWinOdds"] floatValue];
    _interstitialTitleOdds = [[prefs objectForKey:@"interstitialTitleOdds"] floatValue];
    _bannerOdds = [[prefs objectForKey:@"bannerOdds"] floatValue];
    _currentVersion = [[prefs objectForKey:@"currentVersion"] floatValue];
    _interstitialForegroundOdds = [[prefs objectForKey:@"interstitialForegroundOdds"] floatValue];
    _interstitialDelayBetween = [[prefs objectForKey:@"interstitialDelayBetween"] floatValue];

    _gameCenterEnabled = [[prefs objectForKey:@"gameCenterEnabled"] boolValue];
    _gameCenterAsked = [[prefs objectForKey:@"gameCenterAsked"] boolValue];
    _gameCenterRemoteEnabled = [[prefs objectForKey:@"gameCenterRemoteEnabled"] boolValue];

    _mailingAsked = [[prefs objectForKey:@"mailingAsked"] boolValue];

    _vibrationEnabled = [[prefs objectForKey:@"vibrationEnabled"] boolValue];
    //_vibrationEnabled = YES; //force

    _adBannerEnabled = [[prefs objectForKey:@"adBannerEnabled"] boolValue];
    _adBannerEnabledTemp = [[prefs objectForKey:@"adBannerEnabledTemp"] boolValue];

    _tutoArrowClickedTitle = [[prefs objectForKey:@"tutoArrowClickedTitle"] boolValue];
    _tutoArrowClickedBlock = [[prefs objectForKey:@"tutoArrowClickedBlock"] boolValue];
    _tutoArrowClickedStar = [[prefs objectForKey:@"tutoArrowClickedStar"] boolValue];
    _tutoArrowClickedSquare = [[prefs objectForKey:@"tutoArrowClickedSquare"] boolValue];

    _doubleEnabled = [[prefs objectForKey:@"doubleEnabled"] boolValue];
    _playedIntroAlert = [[prefs objectForKey:@"playedIntroAlert"] boolValue];
    _playedWelcomeAlert = [[prefs objectForKey:@"playedWelcomeAlert"] boolValue];
    _playedLavaAlert = [[prefs objectForKey:@"playedLavaAlert"] boolValue];
    _playedLastLevel = [[prefs objectForKey:@"playedLastLevel"] boolValue];

    _playedIntroCheat = [[prefs objectForKey:@"playedIntroCheat"] boolValue];
    _playedStoreAlert = [[prefs objectForKey:@"playedStoreAlert"] boolValue];
    _playedX4Alert = [[prefs objectForKey:@"playedX4Alert"] boolValue];
    _playedWeakSpotAlert = [[prefs objectForKey:@"playedWeakSpotAlert"] boolValue];
    _playedLowHeartAlert = [[prefs objectForKey:@"playedLowHeartAlert"] boolValue];
    _playedRainbowCoinAlert = [[prefs objectForKey:@"playedRainbowCoinAlert"] boolValue];
    _playedLowTimeAlert = [[prefs objectForKey:@"playedLowTimeAlert"] boolValue];
    _playedShieldAlert = [[prefs objectForKey:@"playedShieldAlert"] boolValue];
    _playedDoublerAlert = [[prefs objectForKey:@"playedDoublerAlert"] boolValue];
    _playedAutoAlert = [[prefs objectForKey:@"playedAutoAlert"] boolValue];
    _playedShrinkAlert = [[prefs objectForKey:@"playedShrinkAlert"] boolValue];
    _playedInkAlert = [[prefs objectForKey:@"playedInkAlert"] boolValue];

    _playedGrowAlert = [[prefs objectForKey:@"playedGrowAlert"] boolValue];
    _playedWeakAlert = [[prefs objectForKey:@"playedWeakAlert"] boolValue];

    _playedStarAlert = [[prefs objectForKey:@"playedStarAlert"] boolValue];
    _playedHelpPowerupReady = [[prefs objectForKey:@"playedHelpPowerupReady"] boolValue];
    _playedHelpFire = [[prefs objectForKey:@"playedHelpFire"] boolValue];
    //_touchedPremium = [[prefs objectForKey:@"touchedPremium"] boolValue]; //dont remember
    _prefInstallCountSent = [[prefs objectForKey:@"prefInstallCountSent"] boolValue];

    //force
    if([kHelpers isDebug]) {
        //_adBannerEnabled = YES;
    }

    //launch in game

    _launchInGame = [[prefs objectForKey:@"launchInGame"] boolValue];


    _notifyEnabled = [[prefs objectForKey:@"notifyEnabled"] boolValue];
    _notifyAsked = [[prefs objectForKey:@"notifyAsked"] boolValue];
    _notifyAccepted = [[prefs objectForKey:@"notifyAccepted"] boolValue];

    _prefSoundsConverted = [[prefs objectForKey:@"prefSoundsConverted"] boolValue];
    _prefOpened = [[prefs objectForKey:@"prefOpened"] boolValue];

    //don't remember
    //_powerupVisibleType = [[prefs objectForKey:@"powerupVisibleType"] boolValue];
    _powerupVisibleType = kPowerUpTypeNone;

    //_fireballVisible = [[prefs objectForKey:@"fireballVisible"] intValue]; //saved
    _fireballVisible = [self getMaxFireballs]; //max

    _rainbowCount = [[prefs objectForKey:@"rainbowCount"] intValue];
    if([kHelpers isDebug])
    {
        //_rainbowCount = 1.0f; //test
    }

    _rainbowUsedCount = [[prefs objectForKey:@"rainbowUsedCount"] intValue];
    if([kHelpers isDebug])
    {
        //_rainbowUsedCount = 1.0f; //test
    }

    _timeForeground = [[prefs objectForKey:@"timeForeground"] doubleValue];
    _prefNumFireballsTouched = [[prefs objectForKey:@"prefNumFireballsTouched"] intValue];
    _prefLevelNumFireballsTouched = [[prefs objectForKey:@"prefLevelNumFireballsTouched"] intValue];

    //don't remember buff
    //_currentBuff = [[prefs objectForKey:@"currentBuff"] intValue];
    //_buffSecs = [[prefs objectForKey:@"buffSecs"] intValue];
    _currentBuff = kBuffTypeNone;
    _buffSecs = 0;

    _powerupCountLocal = [[prefs objectForKey:@"powerupCountLocal"] intValue];

    _coffeeCount = [[prefs objectForKey:@"coffeeCount"] intValue];
    _buffDate = [prefs objectForKey:@"buffDate"];
    _coffeeDate = [prefs objectForKey:@"coffeeDate"];
    _chestDate = [prefs objectForKey:@"chestDate"];
    _interstitialLastDate = [prefs objectForKey:@"interstitialLastDate"];

    _numRedCoins = [[prefs objectForKey:@"numRedCoins"] intValue];

    _maxCombo = [[prefs objectForKey:@"maxCombo"] intValue];
    _maxComboLevel = [[prefs objectForKey:@"maxComboLevel"] intValue];

    _dicSkinEnabled = [prefs objectForKey:@"dicSkinEnabled"];
    if(_dicSkinEnabled)
        _dicSkinEnabled = [_dicSkinEnabled mutableCopy];
    else
        _dicSkinEnabled = [NSMutableDictionary dictionary];

    _dicSkinNew = [prefs objectForKey:@"dicSkinNew"];
    if(_dicSkinNew)
        _dicSkinNew = [_dicSkinNew mutableCopy];
    else
        _dicSkinNew = [NSMutableDictionary dictionary];

    _arraySkinRemoteEnabled = [prefs objectForKey:@"arraySkinRemoteEnabled"];
    //remote default yes
    if(!_arraySkinRemoteEnabled) {
        self.arraySkinRemoteEnabled = [NSMutableArray array];
        for(int i=0;i<kNumSkins;i++) {
            [self.arraySkinRemoteEnabled addObject:@(YES)];
        }
    }
    else {
        //good make it mutable
        _arraySkinRemoteEnabled = [_arraySkinRemoteEnabled mutableCopy];

        //fill empty
        for(int i=0;i<kNumSkins;i++)
        {
            if(![_arraySkinRemoteEnabled safeObjectAtIndex:i])
                [_arraySkinRemoteEnabled setObject:@(NO) atIndexedSubscript:i];
        }
    }

    //validate current/enabled
    BOOL enabled  = [self isBlockEnabledIndex:(int)[self getSkin]];
    if(!enabled) {
        self.currentSkin = kCoinTypeDefault; //reset
    }

    self.saveDate = [prefs objectForKey:@"saveDate"];
    if([self.saveDate isKindOfClass:[NSNull class]])
        self.saveDate = nil;

    self.lastVideoUnlockDate = [prefs objectForKey:@"lastVideoUnlockDate"];
    if([self.lastVideoUnlockDate isKindOfClass:[NSNull class]])
        self.lastVideoUnlockDate = nil;

    self.healStartDate = [prefs objectForKey:@"healStartDate"];
    if([self.healStartDate isKindOfClass:[NSNull class]])
        self.healStartDate = nil;

    //check hearts
    //[self checkHeartHeal];

    _dateReset = [prefs objectForKey:@"dateReset"];
    if([_dateReset isKindOfClass:[NSNull class]])
        _dateReset = nil;

    _dateBackground = [prefs objectForKey:@"dateBackground"];
    if([_dateBackground isKindOfClass:[NSNull class]])
        _dateBackground = nil;


    _firstLaunchDate = [prefs objectForKey:@"firstLaunchDate"];
    if([_firstLaunchDate isKindOfClass:[NSNull class]])
        _firstLaunchDate = nil;
    if(_firstLaunchDate == nil)
        _firstLaunchDate = [NSDate date];

    _lastRewardDate = [prefs objectForKey:@"lastRewardDate"];
    if([_lastRewardDate isKindOfClass:[NSNull class]])
        _lastRewardDate = nil;
    if(_lastRewardDate == nil)
        _lastRewardDate = [[NSDate date] dateBySubtractingDays:7]; //old

    if(_clickCount > kScoreMax)
        _clickCount = kScoreMax;
    if(_numPotions > kMaxPotions)
        _numPotions = kMaxPotions;

    if(_rewindClickCount > _clickCount)
        _rewindClickCount = _clickCount;

	//cheats
    self.viewedCheats = [prefs objectForKey:@"viewedCheats"];
    if(!self.viewedCheats || [self.viewedCheats isKindOfClass:[NSNull class]])
	{
        self.viewedCheats = [NSMutableArray array];
    }
    else if([self.viewedCheats isKindOfClass:[NSArray class]])
	{
        self.viewedCheats = [self.viewedCheats mutableCopy];
    }

    //force
    if([kHelpers isDebug]) {
        //_firstLaunchDate = [NSDate dateWithDaysBeforeNow:7];
        //_launchCount = 100;
    }

    //counts
    if((int)_nextOneUp <= 0) {
        _oneUpInc = kNum1upIncStart;
        _nextOneUp = kNum1up;
        _lastOneUp = 0;
    }

    //todo:load/save
    self.mult = 1.0f;
    [self updateMult];


	//long date, catchup catch-up
	if(self.saveDate)
	{
		int daysTooLong = 31*3; //months
    	BOOL tooLong = ([[NSDate date] daysAfterDate:self.saveDate] > daysTooLong);

		if(tooLong)
		{
			[self resetWarnings];
		}
	}

    //version
    _prefVersion = [prefs objectForKey:@"prefVersion"];

    NSString *newPrefVersion = [NSString stringWithFormat:@"%@ (%@)",
                                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];

    //ex: "1.0b4 (028)"


    int shortVersion = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] intValue];

    //version logic, check new version
    BOOL shouldReset = NO;
    if(!_prefVersion || ![self.prefVersion isEqualToString:newPrefVersion])
	{
		if(shortVersion <= 64)
		{
            //new sounds
            //self.prefSoundsConverted = NO; //force reload sounds

			//also reset
			shouldReset = YES;
        }

    }
    //save
    self.prefVersion = newPrefVersion;

    self.stateLoaded = YES;

    //need reset, only in debug/beta

    if(shouldReset) {
        [self resetState];
    }

}

- (void)saveState {
    [self saveState:NO];
}

- (void)loadFromIcloud {
    Log(@"loadFromIcloud **************************");
	assert(0);

    NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:kPrefGroup];

    self.saveDate = [prefs objectForKey:@"saveDate_icloud"];
    self.clickCount = [[prefs objectForKey:@"clickCount_icloud"] doubleValue];
    self.level = [[prefs objectForKey:@"level"] integerValue];
    self.subLevel = [[prefs objectForKey:@"subLevel"] integerValue];
    self.maxCombo = [[prefs objectForKey:@"maxCombo"] intValue];
    self.maxComboLevel = [[prefs objectForKey:@"maxComboLevel"] intValue];

    [self saveState:NO];
}

- (void)saveState:(BOOL)iCloud
{
    //Log(@"saveState **************************");
    //disable
    if(kDisableSave)
        return;

    if(!self.stateLoaded) {
        //too soon
        if([kHelpers isDebug])
            assert(0);
        return;
    }

   	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:kPrefGroup];

    if(_clickCount > kScoreMax)
        _clickCount = kScoreMax;

    if(_numPotions > kMaxPotions)
        _numPotions = kMaxPotions;

    //self.prefVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *newPrefVersion = [NSString stringWithFormat:@"%@ (%@)",
                                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];

    self.prefVersion = newPrefVersion;
    [prefs setObject:self.prefVersion forKey:@"prefVersion"];

    [prefs setObject:[NSNumber numberWithFloat:self.soundVolume] forKey:@"soundVolume"];
    [prefs setObject:[NSNumber numberWithFloat:self.musicVolume] forKey:@"musicVolume"];

    [prefs setObject:[NSNumber numberWithInt:self.credits] forKey:@"credits"];
    [prefs setObject:[NSNumber numberWithDouble:self.clickCount] forKey:@"clickCount"];
    [prefs setObject:[NSNumber numberWithDouble:self.clickCountWorld] forKey:@"clickCountWorld"];

    [prefs setObject:[NSNumber numberWithDouble:self.numPotions] forKey:@"numPotions"];
    [prefs setObject:[NSNumber numberWithDouble:self.rewindClickCount] forKey:@"rewindClickCount"];

    [prefs setObject:[NSNumber numberWithDouble:self.oneUpInc] forKey:@"oneUpInc"];
    [prefs setObject:[NSNumber numberWithDouble:self.nextOneUp] forKey:@"nextOneUp"];
    [prefs setObject:[NSNumber numberWithDouble:self.lastOneUp] forKey:@"lastOneUp"];

    [prefs setObject:[NSNumber numberWithDouble:self.toastieMult] forKey:@"toastieMult"];

    [prefs setObject:[NSNumber numberWithInteger:self.numEndings] forKey:@"numEndings"];
    [prefs setObject:[NSNumber numberWithInteger:self.deathCount] forKey:@"deathCount"];

    [prefs setObject:[NSNumber numberWithInteger:self.lastPowerup] forKey:@"lastPowerup"];

    [prefs setObject:[NSNumber numberWithInteger:self.level] forKey:@"level"];
    [prefs setObject:[NSNumber numberWithInteger:self.subLevel] forKey:@"subLevel"];
    [prefs setObject:[NSNumber numberWithInteger:self.starLevelCount] forKey:@"starLevelCount"];
    [prefs setObject:[NSNumber numberWithInteger:self.numApps] forKey:@"numApps"];
    [prefs setObject:[NSNumber numberWithInteger:self.currentSkin] forKey:@"currentSkin"];
    [prefs setObject:[NSNumber numberWithInteger:self.numHearts] forKey:@"numHearts"];
    [prefs setObject:[NSNumber numberWithInteger:self.currentCastle] forKey:@"currentCastle"];
    [prefs setObject:[NSNumber numberWithInteger:self.worldTimeLeft] forKey:@"worldTimeLeft"];

    [prefs setObject:[NSNumber numberWithBool:self.isRandomSkin] forKey:@"isRandomSkin"];
    [prefs setObject:[NSNumber numberWithInteger:self.lifes] forKey:@"lifes"];
    [prefs setObject:[NSNumber numberWithInteger:self.launchCount] forKey:@"launchCount"];

    [prefs setObject:[NSNumber numberWithBool:self.inReview] forKey:@"inReview"];
    [prefs setObject:[NSNumber numberWithBool:self.showCommercial] forKey:@"showCommercial"];

    [prefs setObject:[NSNumber numberWithBool:self.shouldGetCountry] forKey:@"shouldGetCountry"];
    [prefs setObject:[NSNumber numberWithBool:self.shouldGetBitcoin] forKey:@"shouldGetBitcoin"];

    [prefs setObject:[NSNumber numberWithBool:self.interstitialAfterWinOdds] forKey:@"interstitialAfterWinOdds"];
    [prefs setObject:[NSNumber numberWithBool:self.navPlusOdds] forKey:@"navPlusOdds"];
    [prefs setObject:[NSNumber numberWithBool:self.powerupClickOdds] forKey:@"powerupClickOdds"];
    [prefs setObject:[NSNumber numberWithBool:self.powerupTimerOdds] forKey:@"powerupTimerOdds"];

    [prefs setObject:[NSNumber numberWithBool:self.interstitialTitleOdds] forKey:@"interstitialTitleOdds"];
    //[prefs setObject:[NSNumber numberWithBool:self.currentVersion] forKey:@"currentVersion"]; //don't save, '0' or firebase
    [prefs setObject:[NSNumber numberWithBool:self.interstitialForegroundOdds] forKey:@"interstitialForegroundOdds"];
    [prefs setObject:[NSNumber numberWithBool:self.interstitialDelayBetween] forKey:@"interstitialDelayBetween"];

    [prefs setObject:[NSNumber numberWithBool:self.gameCenterRemoteEnabled] forKey:@"gameCenterRemoteEnabled"];
    [prefs setObject:[NSNumber numberWithBool:self.gameCenterEnabled] forKey:@"gameCenterEnabled"];
    [prefs setObject:[NSNumber numberWithBool:self.gameCenterAsked] forKey:@"gameCenterAsked"];
    [prefs setObject:[NSNumber numberWithBool:self.mailingAsked] forKey:@"mailingAsked"];

    [prefs setObject:[NSNumber numberWithBool:self.vibrationEnabled] forKey:@"vibrationEnabled"];
    [prefs setObject:[NSNumber numberWithBool:self.doubleEnabled] forKey:@"doubleEnabled"];
    [prefs setObject:[NSNumber numberWithBool:self.playedIntroAlert] forKey:@"playedIntroAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedIntroCheat] forKey:@"playedIntroCheat"];

    [prefs setObject:[NSNumber numberWithBool:self.playedWelcomeAlert] forKey:@"playedWelcomeAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedLavaAlert] forKey:@"playedLavaAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedLastLevel] forKey:@"playedLastLevel"];

    [prefs setObject:[NSNumber numberWithBool:self.playedStoreAlert] forKey:@"playedStoreAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedX4Alert] forKey:@"playedX4Alert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedWeakSpotAlert] forKey:@"playedWeakSpotAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedLowHeartAlert] forKey:@"playedLowHeartAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedRainbowCoinAlert] forKey:@"playedRainbowCoinAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedLowTimeAlert] forKey:@"playedLowTimeAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedShieldAlert] forKey:@"playedShieldAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedDoublerAlert] forKey:@"playedDoublerAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedAutoAlert] forKey:@"playedAutoAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedShrinkAlert] forKey:@"playedShrinkAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedInkAlert] forKey:@"playedInkAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedGrowAlert] forKey:@"playedGrowAlert"];
    [prefs setObject:[NSNumber numberWithBool:self.playedWeakAlert] forKey:@"playedWeakAlert"];

    [prefs setObject:[NSNumber numberWithBool:self.playedStarAlert] forKey:@"playedStarAlert"];

    [prefs setObject:[NSNumber numberWithBool:self.playedHelpFire] forKey:@"playedHelpFire"];

    [prefs setObject:[NSNumber numberWithBool:self.touchedPremium] forKey:@"touchedPremium"];

    [prefs setObject:[NSNumber numberWithBool:self.playedHelpPowerupReady] forKey:@"playedHelpPowerupReady"];
    [prefs setObject:[NSNumber numberWithBool:self.adBannerEnabled] forKey:@"adBannerEnabled"];
    [prefs setObject:[NSNumber numberWithBool:self.prefInstallCountSent] forKey:@"prefInstallCountSent"];

    //don't save
    //[prefs setObject:[NSNumber numberWithBool:self.adBannerEnabledTemp] forKey:@"adBannerEnabledTemp"];


    //don't remember
    //[prefs setObject:[NSNumber numberWithBool:self.tutoArrowClickedTitle] forKey:@"tutoArrowClickedTitle"];
    //[prefs setObject:[NSNumber numberWithBool:self.tutoArrowClickedBlock] forKey:@"tutoArrowClickedBlock"];
    //[prefs setObject:[NSNumber numberWithBool:self.tutoArrowClickedStar] forKey:@"tutoArrowClickedStar"];
    //[prefs setObject:[NSNumber numberWithBool:self.tutoArrowClickedSquare] forKey:@"tutoArrowClickedSquare"];

    [prefs setObject:[NSNumber numberWithBool:self.launchInGame] forKey:@"launchInGame"];

    [prefs setObject:[NSNumber numberWithBool:self.notifyEnabled] forKey:@"notifyEnabled"];
    [prefs setObject:[NSNumber numberWithBool:self.notifyAsked] forKey:@"notifyAsked"];
    [prefs setObject:[NSNumber numberWithBool:self.notifyAccepted] forKey:@"notifyAccepted"];


    [prefs setObject:[NSNumber numberWithBool:self.powerupVisibleType] forKey:@"powerupVisibleType"];

    [prefs setObject:[NSNumber numberWithBool:self.prefOpened] forKey:@"prefOpened"];
    [prefs setObject:[NSNumber numberWithBool:self.prefSoundsConverted] forKey:@"prefSoundsConverted"];

    [prefs setObject:[NSNumber numberWithInt:self.fireballVisible] forKey:@"fireballVisible"];

    [prefs setObject:[NSNumber numberWithInt:self.rainbowCount] forKey:@"rainbowCount"];
    [prefs setObject:[NSNumber numberWithInt:self.rainbowUsedCount] forKey:@"rainbowUsedCount"];

    [prefs setObject:[_dicSkinEnabled copy] forKey:@"dicSkinEnabled"];
    [prefs setObject:[_dicSkinNew copy] forKey:@"dicSkinNew"];

    [prefs setObject:[_arraySkinRemoteEnabled copy] forKey:@"arraySkinRemoteEnabled"];

    [prefs setObject:[NSNumber numberWithDouble:self.timeForeground] forKey:@"timeForeground"];
    [prefs setObject:[NSNumber numberWithInt:self.prefNumFireballsTouched] forKey:@"prefNumFireballsTouched"];
    [prefs setObject:[NSNumber numberWithInt:self.prefLevelNumFireballsTouched] forKey:@"prefLevelNumFireballsTouched"];
    [prefs setObject:[NSNumber numberWithInt:self.currentBuff] forKey:@"currentBuff"];
    [prefs setObject:[NSNumber numberWithInt:self.buffSecs] forKey:@"buffSecs"];
    [prefs setObject:[NSNumber numberWithInt:self.powerupCountLocal] forKey:@"powerupCountLocal"];

    [prefs setObject:[NSNumber numberWithInt:self.coffeeCount] forKey:@"coffeeCount"];

    [prefs setObject:[NSNumber numberWithInt:self.numRedCoins] forKey:@"numRedCoins"];

    [prefs setObject:[NSNumber numberWithInt:self.maxCombo] forKey:@"maxCombo"];
    [prefs setObject:[NSNumber numberWithInt:self.maxComboLevel] forKey:@"maxComboLevel"];

    //anti hack, heal
    self.saveDate = [NSDate date];
    [prefs setObject:self.saveDate forKey:@"saveDate"];

    [prefs setObject:self.lastVideoUnlockDate forKey:@"lastVideoUnlockDate"];

    [prefs setObject:self.healStartDate forKey:@"healStartDate"];

	//cheats
	[prefs setObject:self.viewedCheats forKey:@"viewedCheats"];

	//buff date
    if(self.buffDate)
        [prefs setObject: self.buffDate  forKey:@"buffDate"];
    else {
        if([prefs objectForKey:@"buffDate"])
            [prefs removeObjectForKey:@"buffDate"];
    }


    //ad dateExpire
  	if(self.interstitialLastDate)
          [prefs setObject: self.interstitialLastDate  forKey:@"interstitialLastDate"];
      else {
          if([prefs objectForKey:@"interstitialLastDate"])
              [prefs removeObjectForKey:@"interstitialLastDate"];
      }

	//chest date
	if(self.chestDate)
        [prefs setObject: self.chestDate  forKey:@"chestDate"];
    else {
        if([prefs objectForKey:@"chestDate"])
            [prefs removeObjectForKey:@"chestDate"];
    }


	//coffee date
    if(self.coffeeDate)
        [prefs setObject: self.coffeeDate  forKey:@"coffeeDate"];
    else {
        if([prefs objectForKey:@"coffeeDate"])
            [prefs removeObjectForKey:@"coffeeDate"];
    }

    //date
    if(self.dateReset)
        [prefs setObject: self.dateReset  forKey:@"dateReset"];
    else {
        if([prefs objectForKey:@"dateReset"])
            [prefs removeObjectForKey:@"dateReset"];
    }

    if(self.firstLaunchDate)
        [prefs setObject:self.firstLaunchDate  forKey:@"firstLaunchDate"];


    if(self.lastRewardDate)
        [prefs setObject:self.lastRewardDate  forKey:@"lastRewardDate"];


    //date background
    NSDate *tempDate = [NSDate date];
    [prefs setObject: tempDate  forKey:@"dateBackground"];

    //save
    [prefs synchronize];


    //icloud
    if(iCloud) {
        // Save To iCloud
        NSUbiquitousKeyValueStore *store = [NSUbiquitousKeyValueStore defaultStore];

        if (store != nil) {
            [store setObject:self.saveDate forKey:@"saveDate_icloud"];
            [prefs setObject:[NSNumber numberWithDouble:self.clickCount] forKey:@"clickCount_icloud"];
            [prefs setObject:[NSNumber numberWithInteger:self.level] forKey:@"level_icloud"];
            [prefs setObject:[NSNumber numberWithInteger:self.subLevel] forKey:@"subLevel_icloud"];
            [prefs setObject:[NSNumber numberWithInt:self.maxCombo] forKey:@"maxCombo_icloud"];
            [prefs setObject:[NSNumber numberWithInt:self.maxComboLevel] forKey:@"maxComboLevel_icloud"];
            [store synchronize];
        }

    }
}

- (void)forceLockAll {

    for(int i=0;i<kNumSkins;i++) {
        [self.dicSkinEnabled setObject:@(i==kCoinTypeDefault) forKey:[CBSkinManager getSkinKey:i]];
    }

    [self saveState];
}

- (void)resetState {
	[self resetState:YES];
}

- (void)resetState:(BOOL)resetSkins {

    //_soundVolume = kDefaultVolumeSound;
    //_musicVolume = kDefaultVolumeMusic;

    _lastRewardDate = [[NSDate date] dateBySubtractingDays:7]; //old

    //debug
    //if([kHelpers isDebug])
    {
        //_doubleEnabled = NO;
        //_adBannerEnabled = NO;
    }

    _adBannerEnabledTemp = YES;

	[self resetWarnings];

    _clickCount = 0;
    _numPotions = kPotionStart;
    _rewindClickCount = 0;
    _level = 1;
    _subLevel = 1;
    _starLevelCount = 0;
    //_numApps = kNumAppsDefault;
    _fireballVisible = 0;
    _rainbowCount = 0;
    _rainbowUsedCount = 0;
    _timeForeground = 0;
    _prefNumFireballsTouched = 0;
    _prefLevelNumFireballsTouched = 0;
    _numRedCoins = 0;
    _currentBuff = kBuffTypeNone;
    _buffSecs = 0;
    _coffeeCount = 0;
    _powerupCountLocal = 0;
	_maxCombo = 0; //remember max
	_maxComboLevel = 0; //remember max
    //_numEndings = 0; //don't reset
  _deathCount = 0;
	_lastPowerup = kPowerUpTypeNone;

    _firstLaunchDate = [NSDate date];

    _invincible = NO;
    _fps = NO;
    _currentCastle = 0;
    _worldTimeLeft = [CBSkinManager getWorldTime];
    _numHearts = kHeartFullDefault;
    _currentSkin = kCoinTypeDefault;
    _isRandomSkin = 0;
    _dateReset = nil;

	_buffDate = nil;
	_chestDate = nil;
	_coffeeDate = nil;

    _prefOpened = NO;
    //_prefSoundsConverted = NO;

    _mult = 1.0f;
    _comboMult = 0.0f;
    _toastieMult = 0.0f;
    _cheatMult = 0.0f;
    _lifes = 1;

    //_launchCount = 0;

    _oneUpInc = kNum1upIncStart;
    _nextOneUp = kNum1up;
    _lastOneUp = 0;

	//cheats
	[self.viewedCheats removeAllObjects];

    ///skins
	if(resetSkins)
		[self resetSkins];

    [self saveState];
}

-(void) resetWarnings {
   	_playedIntroAlert = NO;
    _playedWelcomeAlert = NO;
    _playedLavaAlert = NO;
	_playedLastLevel = NO;
    _playedStoreAlert = NO;
    _playedX4Alert = NO;
	_playedWeakSpotAlert = NO;
  _playedLowHeartAlert = NO;
  _playedRainbowCoinAlert = NO;
    _playedLowTimeAlert = NO;
    _playedShieldAlert = NO;
    _playedDoublerAlert = NO;
    _playedAutoAlert = NO;
    _playedShrinkAlert = NO;
    _playedInkAlert = NO;
    _playedGrowAlert = NO;
    _playedWeakAlert = NO;
    _playedHelpFire = NO;
    _playedHelpPowerupReady = NO;
    _touchedPremium = NO;
	_playedStarAlert = NO;
    _playedIntroCheat = NO;
}

-(void) disableWarnings {
   	_playedIntroAlert = YES;
    _playedWelcomeAlert = YES;
    _playedLavaAlert = YES;
	_playedLastLevel = YES;
    _playedStoreAlert = YES;
    _playedX4Alert = YES;
    _playedWeakSpotAlert = YES;
    _playedLowHeartAlert = YES;
    _playedRainbowCoinAlert = YES;
    _playedLowTimeAlert = NO;
    _playedShieldAlert = YES;
    _playedDoublerAlert = YES;
    _playedAutoAlert = YES;
    _playedGrowAlert = YES;
    _playedShrinkAlert = YES;
    _playedInkAlert = YES;
    _playedWeakAlert = YES;
    _playedHelpFire = YES;
    _playedHelpPowerupReady = YES;
    _touchedPremium = YES;
	_playedStarAlert = YES;
    _playedIntroCheat = YES;
}

-(void) resetSkins {
    //default skin
    [_dicSkinEnabled removeAllObjects];
    [_dicSkinEnabled setObject:@(YES) forKey:[CBSkinManager getSkinKey:kCoinTypeDefault]];

    [_dicSkinNew removeAllObjects];
    [_dicSkinNew setObject:@(NO) forKey:[CBSkinManager getSkinKey:kCoinTypeDefault]];

    [self updateBlockEnabled];
}

- (BOOL)launchedEnough {

    BOOL countEnough = YES; //(self.launchCount > kLaunchCountAds) ;
    BOOL daysEnough = YES; //([[NSDate date] daysAfterDate:self.firstLaunchDate] > kLaunchDaysAds);
    BOOL levelEnough = (self.level > 2);

    return (countEnough && daysEnough && levelEnough);
}

-(void)checkHeartHeal
{
    return; //disabled

#if 0
    if(self.healStartDate) {
        //heal hearts

        if(self.numHearts >= kHeartFull) {
            self.healStartDate = nil;
        }

        int seconds = ((int)([self.healStartDate timeIntervalSinceNow]));
        float heartHealTime = [CBSkinManager getHeartHealTime];
        int newHearts = abs((int)floor(seconds / heartHealTime));

        newHearts = (newHearts / 2)*2; //only mult of 2

        if(newHearts >= 2 ) {

            self.healStartDate = [NSDate date];
            //seconds = 0;
            //got refill
            //self.healStartDate = [NSDate date];

            if(self.numHearts < kHeartFull) {
                self.numHearts += newHearts;

                if(self.titleController.menuState == menuStateGame) {
                    //game

                    [self playSound:@"refill.caf"];

                    //update game
                    [self.gameScene setNumHearts:(int)self.numHearts];
                }

                else if(self.titleController.menuState == menuStateTitle) {
                    //title

                    [self playSound:@"refill.caf"];

                    //update game
                    //[self.gameScene setNumHearts:(int)self.numHearts];
                }

            }

        }
        self.numHearts = [kHelpers clamp:self.numHearts min:0 max:kHeartFull];

        if(self.numHearts >= kHeartFull) {
            self.healStartDate = nil;
            //seconds = 0;
        }

    }
    else {
        //self.healStartDate = [NSDate date];
    }

    //always update

    if(self.titleController.menuState == menuStateTitle) {
        //game
        [self.titleController setNumHearts:(int)self.numHearts];
    }
#endif
}


-(void)updateMult {
    self.mult = 1.0;
}

#pragma mark -
#pragma mark Email


- (void) mailComposeController:(MFMailComposeViewController*)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError*)error
{
    if(result == MFMailComposeResultSent)
    {
        Log(@"mail sent");
    }


    [[self.rootController currentViewController] dismissViewControllerAnimated:YES completion:nil];
}



- (void)sendEmailTo:(NSString *)to withSubject:(NSString *)subject withBody:(NSString *)body withView:(UIViewController*)theView
{

    //todo: test if mail account
    if (![MFMailComposeViewController canSendMail])
    {
        return;
    }

    NSArray *recipients = [[NSArray alloc] initWithObjects:to, nil];
    NSArray *recipientEmpty = [[NSArray alloc] init];


    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:subject];
    [controller setMessageBody:body isHTML:NO];


    if([to  length] == 0)
        [controller setToRecipients: recipientEmpty];
    else
        [controller setToRecipients: recipients];


    //[ self.window.rootViewController presentViewController:controller animated:YES completion:NULL];
    [[self.rootController currentViewController] presentViewController:controller animated:YES completion:NULL];
}


-(void)getIP {

    if(![kHelpers checkOnline])
        return;

    if(self.inReview)
        return;

    if(!self.shouldGetCountry)
        return;

    //self.ipAddress = nil;

    NSString *url = [NSString stringWithFormat:@"https://icanhazip.com/"];
    //NSString *url = [NSString stringWithFormat:@"http://checkip.dyndns.com/"]; //doesn't work with https

    Log(@"url: %@", url);
    NSURL *datasourceURL = [NSURL URLWithString:url];

    NSURLRequest *request_afn = [[NSURLRequest alloc] initWithURL:datasourceURL];


    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request_afn];
    //[httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text

        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        Log(@"Response: %@", string);

        string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];

        //test
        NSURL *testURL = [NSURL URLWithString:string];

        if(string && testURL && [string contains:@"."]) {
            self.ipAddress = string;
            [self getCountry];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"Error: %@", error);
    }];

    operation.allowsInvalidSSLCertificate = YES;

    [operation start];

}

-(void)getCountryLocale {
    if(!self.shouldGetCountry)
        return;

	NSLocale *locale = [NSLocale currentLocale];
	NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];

	//list
	//https://en.wikipedia.org/wiki/ISO_3166-1

	NSString *countryName = [locale displayNameForKey: NSLocaleCountryCode
																							value: countryCode];

	Log(@"countryCode:%@, countryName:%@", countryCode, countryName);

	//pewds, sweden or england
	if([self.countryCode isEqualToStringInsensitive:@"se"] ||
		 [self.countryCode isEqualToStringInsensitive:@"uk"]) {

		[self unlockBlock:kCoinTypePew];
	}

	//montreal, canada
	if([self.countryCode isEqualToStringInsensitive:@"ca"]) {
		[self unlockBlock:kCoinTypeMontreal];
	}
}

-(void)getCountry {

    if(![kHelpers checkOnline])
        return;

    if(self.inReview)
        return;

    if(!self.ipAddress)
        return;

    NSString *key = @"09811b5f54ab5a34c554cf4605fa796871e22e1c6bc13b9cab979d5190894322";
    NSString *ip = self.ipAddress;
    NSString *url = [NSString stringWithFormat:@"https://api.ipinfodb.com/v3/ip-country/?key=%@&ip=%@&format=json", key, ip];
    Log(@"url: %@", url);

    //url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    //Log(@"url: %@", url);

    NSURL *datasourceURL = [NSURL URLWithString:url];


    NSURLRequest *request_afn = [[NSURLRequest alloc] initWithURL:datasourceURL];
    //[AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request_afn
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                         {
                                             //save it
                                             if(JSON) {
                                                 NSDictionary *dict = JSON;

                                                 self.countryCode = [dict objectForKey:@"countryCode"];
                                                 self.countryName = [dict objectForKey:@"countryName"];

                                                 //sweden
                                                 if([self.countryCode isEqualToStringInsensitive:@"se"] ||
                                                    [self.countryCode isEqualToStringInsensitive:@"swe"] ||
                                                    [self.countryCode isEqualToStringInsensitive:@"sweden"]) {

                                                     [self unlockBlock:kCoinTypePew];
                                                 }
                                                 //canada,montreal
                                                 if([self.countryCode isEqualToStringInsensitive:@"ca"] ||
                                                    [self.countryCode isEqualToStringInsensitive:@"can"] ||
                                                    [self.countryCode isEqualToStringInsensitive:@"canada"]) {
                                                     [self unlockBlock:kCoinTypeMontreal];
                                                 }

                                                 /*double value = [[dict objectForKey:@"24h_avg"] doubleValue];

                                                 if(value > 0) {
                                                     self.bitcoinPrice = value;
                                                 }*/
                                             }

                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                         {
                                             Log(@"Request Failed with Error: %@, %@", error, error.userInfo);
                                         }];

    //operation.securityPolicy.allowInvalidCertificates = YES;
    operation.allowsInvalidSSLCertificate = YES;

    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        //timed out
    }];
    [operation start];

}


-(void)getBitcoinPrice {

    //disabled
    return;

 #if 0
    if(![kHelpers checkOnline])
        return;

    if(!self.shouldGetBitcoin)
        return;

    NSURL *datasourceURL = [NSURL URLWithString:@"https://api.bitcoinaverage.com/ticker/global/USD/"];
    //NSURLRequest *request = [NSURLRequest requestWithURL:datasourceURL];
    /*NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url
     cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
     timeoutInterval:20];*/


    NSURLRequest *request_afn = [[NSURLRequest alloc] initWithURL:datasourceURL];
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request_afn
                                                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
             {
                 //save it
                 if(JSON) {
                     NSDictionary *dict = JSON;
                     double value = [[dict objectForKey:@"24h_avg"] doubleValue];

                     if(value > 0) {
                         self.bitcoinPrice = value;
                     }
                 }

                 /*
                  Printing description of JSON:
                  {
                  "24h_avg" = "424.36";
                  ask = "425.06";
                  bid = "424.55";
                  last = "424.83";
                  timestamp = "Tue, 05 Apr 2016 23:58:20 -0000";
                  "volume_btc" = "43629.15";
                  "volume_percent" = "66.22";
                  }

                */
             }
                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
             {
                 Log(@"Request Failed with Error: %@, %@", error, error.userInfo);
             }];

    [operation setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        //timed out
    }];
    [operation start];

#endif
}

-(void)getIAP {

    if(![kHelpers checkOnline])
        return;

    //already got
    //if([self.iapPrices objectForKey:kIAP_Skin1])
    //    return;

    [[IAPShare sharedHelper].iap requestProductsWithCompletion:^(SKProductsRequest* request,SKProductsResponse* response)
     {
         if(response) {
             for(int i=0;i<[IAPShare sharedHelper].iap.products.count;i++) {

                 SKProduct* product =[[IAPShare sharedHelper].iap.products objectAtIndex:i];
                 NSString *productID = product.productIdentifier;
                 NSString *productPrice = product.priceAsString;

                 [self.iapPrices setObject:productPrice forKey:productID];
                 [self.iapProducts setObject:product forKey:productID];
             }

         }
     }];

}

-(void)getFirebaseConfig {
    if(![kHelpers checkOnline])
        return;

    long expirationDuration = 3600;
    // If in developer mode cacheExpiration is set to 0 so each fetch will retrieve values from
    // the server.
    if (self.remoteConfig.configSettings.isDeveloperModeEnabled) {
        expirationDuration = 0;
    }

    // [START fetch_config_with_callback]
    // cacheExpirationSeconds is set to cacheExpiration here, indicating that any previously
    // fetched and cached config would be considered expired because it would have been fetched
    // more than cacheExpiration seconds ago. Thus the next fetch would go to the server unless
    // throttling is in progress. The default expiration duration is 43200 (12 hours).
    [self.remoteConfig fetchWithExpirationDuration:expirationDuration completionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            //self.numApps = [[[self.remoteConfig configValueForKey:@"numApps"] numberValue] intValue];

            /// Applies fetched Config data to Active Config, causing updates to the behavior and appearance of
            /// the app to take effect (depending on how config data is used in the app).
            /// Returns true if FetchedConfig has been applied to RemoteConfig or if there is no FetchedConfig.
            /// Returns false if FetchedConfig is newer than RemoteConfig.
            BOOL good = [self.remoteConfig activateFetched];
            if(!good || error || status == FIRRemoteConfigFetchStatusFailure)
                return;

            if(status == FIRRemoteConfigFetchStatusThrottled)
            {
                Log(@"FIRRemoteConfigFetchStatusThrottled");
            }

            //new
            NSString *requiredVersion = [[self.remoteConfig configValueForKey:@"requiredVersion2"] stringValue];
            NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; //1.0


            if([kHelpers isDebug]) {
                //force
                //requiredVersion = @"200";
            }


            Log(@"currentVersion:%@, requiredVersion:%@", currentVersion, requiredVersion);

            if(!requiredVersion || !currentVersion || requiredVersion.length == 0 || currentVersion.length == 0 )
            {
                //invalid for some reason, ignore?
                //return;
            }
            else {
                //if ([requiredVersion compare:currentVersion options:NSNumericSearch] == NSOrderedDescending)
                if ([requiredVersion floatValue]  > [currentVersion floatValue])
                {

                    Log(@"actualVersion is lower than the requiredVersion");

                    //alert
                    RIButtonItem *cancelItem = [RIButtonItem itemWithLabel:@"OK" action:^{

                        //app store url
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStoreURL] options:@{} completionHandler:nil];


                    }];

                    NSString *title = @"New Version";
                    NSString *message = @"This version is out of date. Please update to the latest version.";

                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                                    message:message
                                                           cancelButtonItem:cancelItem
                                                           otherButtonItems:nil, nil];
                    [alert show];
                }
            }

            //current version
            self.currentVersion = [[[self.remoteConfig configValueForKey:@"currentVersion"] numberValue] floatValue];
            if([kHelpers isDebug]) {
                //force
                //self.currentVersion = 200;
            }

            //review
            self.parseMult = [[[self.remoteConfig configValueForKey:@"mult"] numberValue] floatValue];
            //sanityze
            if(self.parseMult < 1.0f)
                self.parseMult = 1.0f;

            //quotes
            self.showQuotes = NO; //[config[@"showQuotes"] boolValue]

            //review
            self.inReview = [[self.remoteConfig configValueForKey:@"inReview"] boolValue];
            if(YES && [kHelpers isDebug]) {
                //force
                Log(@"***** getFireBaseConfig: inReview = NO");
                self.inReview = NO;
            }

            //commercial
            self.showCommercial = [[self.remoteConfig configValueForKey:@"showCommercial"] boolValue];

            //getCountry
            self.shouldGetCountry = [[self.remoteConfig configValueForKey:@"shouldGetCountry"] boolValue];
            [self getCountryLocale];

            //test
            //self.inReview = YES;

            if(self.inReview)
            {
                Log(@"config: in review");
            }
            else {
                Log(@"config: not in review");
            }

            //skin list, enabled/disabled
            for(int i=0;i<kNumSkins;i++) {
                //BOOL enabled = [config[[NSString stringWithFormat:@"skinEnabled%d", i]] boolValue];
                NSString *key = [CBSkinManager getSkinKey:i];
                BOOL enabled = [[self.remoteConfig configValueForKey:key] boolValue];

                if([self.arraySkinRemoteEnabled safeObjectAtIndex:i])
                {
                    [self.arraySkinRemoteEnabled replaceObjectAtIndex:i withObject:@(enabled)];
                }
                else
                {
                    [self.arraySkinRemoteEnabled setObject:@(enabled) atIndexedSubscript:i];
                }
            }

            [self updateBlockEnabled];

            //self.inReview = [[self.remoteConfig configValueForKey:@"inReview"] boolValue];
            self.numApps = [[[self.remoteConfig configValueForKey:@"numApps"] numberValue] intValue];


            //game center, after config
            self.gameCenterRemoteEnabled = [[[self.remoteConfig configValueForKey:@"gamecenterEnabled"] numberValue] boolValue];
            [self setupGameCenter];

            //bitcoin
            self.shouldGetBitcoin = [[[self.remoteConfig configValueForKey:@"shouldGetBitcoin"] numberValue] boolValue];
            [self getBitcoinPrice];

            //ads
            self.navPlusOdds = [[[self.remoteConfig configValueForKey:@"navPlusOdds"] numberValue] floatValue];
            self.powerupClickOdds = [[[self.remoteConfig configValueForKey:@"powerupClickOdds"] numberValue] floatValue];
            self.powerupTimerOdds = [[[self.remoteConfig configValueForKey:@"powerupTimerOdds"] numberValue] floatValue];

            self.interstitialAfterWinOdds = [[[self.remoteConfig configValueForKey:@"interstitialAfterWinOdds"] numberValue] floatValue];
            self.interstitialTitleOdds = [[[self.remoteConfig configValueForKey:@"interstitialTitleOdds"] numberValue] floatValue];
            self.bannerOdds = [[[self.remoteConfig configValueForKey:@"bannerOdds"] numberValue] floatValue];
            self.interstitialForegroundOdds = [[[self.remoteConfig configValueForKey:@"interstitialForegroundOdds"] numberValue] floatValue];
            self.interstitialDelayBetween = [[[self.remoteConfig configValueForKey:@"interstitialDelayBetween"] numberValue] floatValue];

            [self.titleController updateUI];

            Log(@"done");
        } else {
            Log(@"Firebase; Config not fetched");
            Log(@"Error %@", error.localizedDescription);
        }
    }];


    //[remoteConfig close];
//#endif
}

- (void)getRemoteConfig {

    //firebase
    [self getFirebaseConfig];
}

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {

#if !TARGET_IPHONE_SIMULATOR

    Log(@"Error in registration. Error: %@", error);

#endif
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {

    //firebase
    [FIRMessaging messaging].APNSToken = newDeviceToken;

    NSString* deviceTokenString = [[[[newDeviceToken description]
                                     stringByReplacingOccurrencesOfString: @"<" withString: @""]
                                    stringByReplacingOccurrencesOfString: @">" withString: @""]
                                   stringByReplacingOccurrencesOfString: @" " withString: @""];


    //ce860678889ebeb8079ccf24b1226c23f0620996411c9e6172fbead16c5b95c2
    Log(@"deviceTokenString: %@", deviceTokenString);
}



/*- (BOOL)shouldRequestInterstitialsInFirstSession {
    return NO;
}*/


#pragma mark -
#pragma mark UnityAds

#if 0
- (void)unityAdsReady:(NSString *)placementId{
    Log(@"unityAdsReady");
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message{
    Log(@"unityAdsDidError");
}

- (void)unityAdsDidStart:(NSString *)placementId{
    Log(@"unityAdsDidStart");
}

- (void)unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state{

    Log(@"unityAdsDidFinish");

    if(state == kUnityAdsFinishStateCompleted)
        Log(@"good");
}
#endif

#pragma mark -
#pragma mark Chartboost

//precache, prefetch
-(void) cacheRewardVideos
{
    Log(@"****** cacheRewardVideos *******");
	//disabled, removed HZAdOptionsDisableAutoPrefetching

    if(kPreloadAds)
        return;

    //on main thread
    dispatch_async(dispatch_get_main_queue(), ^{

      // As early as possible, and after showing a video, call fetch
      // if(![HZBannerAd isAvailable])
      //   [HZBannerAd fetch];
      if(![HZVideoAd isAvailable])
        [HZVideoAd fetch];
      if(![HZIncentivizedAd isAvailable])
        [HZIncentivizedAd fetch];
      if(![HZInterstitialAd isAvailable])
        [HZInterstitialAd fetch]; //also interstitial

    });

}


-(void)checkReward:(NSString*)location {

    Log(@"checkReward: %@", location);

    if(!self.hasReward)
        return;

    if(self.titleController.menuState == menuStateTitle)
    {
        [self.titleController resetTimerStory];
    }

    //give reward
    if([location isEqualToString:kRewardScreen]) {
        //generic
        Log(@"didCompleteRewardedVideo generic");
    }
    else if([location isEqualToString:kRewardRefill]) {

        if(self.titleController.menuState == menuStateTitle)
            [self.gameScene refillHeartAlert2];
        else if(self.titleController.menuState == menuStateGame)
            [self.gameScene refillHeartAlert2];
    }
    else if([location isEqualToString:kRewardRefillPotions]) {

        if(self.titleController.menuState == menuStateTitle)
            [self.gameScene refillPotionsAlert2];
        else if(self.titleController.menuState == menuStateGame)
            [self.gameScene refillPotionsAlert2];
    }

    else if([location isEqualToString:kRewardUnlockSkinTitle]) {

        [self.titleController unlockedSkinReward];
    }

    else if([location isEqualToString:kRewardUnlockPowerUp]) {

        //[self.gameScene touchedNavSquare2];

        //after delay, because hidden from updateAll
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.gameScene rewardPowerup];
        });

    }

    self.hasReward = NO;

    float secs = 0.3f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self cacheRewardVideos];
    });

    //reset ad date
    self.interstitialLastDate = [NSDate date];

    //force resume
    [self.gameScene resumeNotification:nil];
}


#pragma mark - HeyZap Callbacks

- (void)didReceiveAdWithTag:(NSString *)tag {
    Log(@"HeyZap: didReceiveAdWithTag: %@", tag);
}
- (void)didShowAdWithTag:(NSString *)tag {
    Log(@"HeyZap: didShowAdWithTag: %@", tag);

    [kHelpers dismissHud];

    //force pause game
    if(self.titleController.menuState == menuStateGame)
    {
        //[self.gameController actionMenu:nil playSound:NO];
        [self.gameScene enablePause:YES];
    }

    //check again
    [self cacheRewardVideos];
}

- (void)didClickAdWithTag:(NSString *)tag {
    Log(@"HeyZap: didClickAdWithTag: %@", tag);
}

- (void)didHideAdWithTag:(NSString *)tag {
    Log(@"didHideAdWithTag: %@", tag);

    if(self.titleController.menuState == menuStateTitle)
    {
        [self.titleController resetTimerStory];
    }

    self.isPlayingVideoAd = NO;

    self.gameScene.lastClickDate = [NSDate date];

    //reset
    [self.gameScene setSoundVolume];


    //force unpause
    //force pause game
    if(self.titleController.menuState == menuStateGame)
    {
        [self.gameScene enablePause:NO];
    }

    //music
    if(self.titleController.menuState == menuStateGame) {
        //music
        if(self.subLevel == 4) {
            [self playMusic:kMusicNameCastle andRemember:YES];
        }
        else {
            [self playMusicRandom];
        }
    }
    else if(self.titleController.menuState == menuStateTitle) {

        //music
        [kAppDelegate playMusic:kMusicNameOptions andRemember:YES];
    }

    [self checkReward:tag];
}

-(void)actionAdFailed:(NSString *)tag
{
    if(self.titleController.menuState == menuStateGame) {

        if([tag isEqualToString:kRewardRefill]) {
            [self.gameScene rewind];
        }
        else if([tag isEqualToString:kRewardUnlockPowerUp]) {
            //nothing

            //force resume
            [self.gameController openCurtains];

            [self.gameScene resumeNotification:nil];
        }
    }

    //check again
    [self cacheRewardVideos];
}

- (void)didFailToReceiveAdWithTag:(NSString *)tag {
    Log(@"HeyZap: didFailToReceiveAdWithTag: %@", tag);

    [self actionAdFailed:tag];
}

- (void)didFailToShowAdWithTag:(NSString *)tag andError:(NSError *)error {
    Log(@"HeyZap: didFailToShowAdWithTag: %@: %@", tag, error);

    [self actionAdFailed:tag];
}

- (void)willStartAudio {
    Log(@"HeyZap: willStartAudio");
}
- (void)didFinishAudio {
    Log(@"HeyZap: didFinishAudio");
}

- (void)didCompleteAdWithTag:(NSString *)tag {
    Log(@"HeyZap: didCompleteAdWithTag: %@", tag);

    //[self cacheRewardVideos];

    if(self.titleController.menuState == menuStateTitle)
    {
        [self.titleController resetTimerStory];
    }

    if(self.titleController.menuState == menuStateGame)
    {
        self.gameController.darkAdImage.hidden = YES;
    }

    self.isPlayingVideoAd = NO;

    self.gameScene.lastClickDate = [NSDate date];

    //reset
    [self.gameScene setSoundVolume];


    //force unpause
    if(self.titleController.menuState == menuStateGame) {
        //self.gameScene.paused = NO;
        //self.gameScene.paused = NO;
        [self.gameScene enablePause:NO];

        //music
        if(self.subLevel == 4) {
            [self playMusic:kMusicNameCastle andRemember:YES];
        }
        else {
            [self playMusicRandom];
        }

    }
    else if(self.titleController.menuState == menuStateTitle) {

        //music
        [kAppDelegate playMusic:kMusicNameOptions andRemember:YES];

    }

    //for later, didCloseRewardedVideo/didDismissRewardedVideo/didClickRewardedVideo
    self.hasReward = YES;

    //check again
    [self cacheRewardVideos];
}

- (void) didFailToCompleteAdWithTag:(NSString *)tag {

    Log(@"HeyZap: didFailToCompleteAdWithTag: %@", tag);

    //check again
    [self cacheRewardVideos];
}

//banner

-(void)setupBannerAds
{
    //banner
#if kBannerEnabled

//on main thread
    dispatch_async(dispatch_get_main_queue(), ^{

      HZBannerAdOptions *options = [[HZBannerAdOptions alloc] init];
      // Optionally set the view controller to present modal views from (this defaults
      // to the root VC of the app)
      options.presentingViewController = kAppDelegate.gameController;

      // Optionally set the maximum amount of time (in seconds) to let the fetch
      // retry when ad networks don't return an ad right away before failing out.
      // The default behavior is to retry until it succeeds.
      options.fetchTimeout = 120; // 120 seconds (2 minutes), for example

      // Optionally set your preferred sizes for each network's banners.
      // These are the default values.
      options.admobBannerSize = HZAdMobBannerSizeFlexibleWidthPortrait;
      options.facebookBannerSize = HZFacebookBannerSizeFlexibleWidthHeight50;

      // Optionally, set a tag for the banner ad to give you control over the banner
      // ad location from our dashboards.
      //options.tag = @"mainMenuBanner";

      [HZBannerAd requestBannerWithOptions:options success:^(HZBannerAd *banner) {

          Log(@"HZBannerAd: requestBannerWithOptions");
          //[self.view addSubview:banner];

          //only in game
          if(self.titleController.menuState == menuStateGame)
          {
              [kAppDelegate.gameController receivedBanner:banner];
          }

      } failure:^(NSError *error) {
          Log(@"HZBannerAd: requestBannerWithOptions Error = %@",error);

          [kAppDelegate.gameController hideBanner];

      }];
    });

#endif

}

- (void)bannerDidReceiveAd:(HZBannerAd *)banner
{
    Log(@"HZBannerAd: bannerDidReceiveAd: %@", banner.mediatedNetwork);
}

- (void)bannerDidFailToReceiveAd:(HZBannerAd *)banner error:(NSError *)error
{
    Log(@"HZBannerAd: bannerDidFailToReceiveAd: %@", error);
}

- (void)bannerWasClicked:(HZBannerAd *)banner
{
    Log(@"HZBannerAd: bannerWasClicked");
}

- (void)bannerWillPresentModalView:(HZBannerAd *)banner
{
    Log(@"HZBannerAd: bannerWillPresentModalView");
}

- (void)bannerDidDismissModalView:(HZBannerAd *)banner
{
    Log(@"HZBannerAd: bannerDidDismissModalView");
}

- (void)bannerWillLeaveApplication:(HZBannerAd *)banner
{
    Log(@"HZBannerAd: bannerWillLeaveApplication");
}

#pragma mark - Ads general
-(void)showInterstitial:(NSString*)name;
{
  //on main thread
  dispatch_async(dispatch_get_main_queue(), ^{

  	   // InterstitialAds are automatically fetched from our server
      HZShowOptions *options = [[HZShowOptions alloc] init];
      options.viewController = [self.rootController currentViewController]; //self; // Only necessary if you're using multiple view controllers in your app
      options.tag = name;

      [HZInterstitialAd showWithOptions:options];

      //date
      self.interstitialLastDate = [NSDate date];
    });
}

-(void)showInterstitialVideo:(NSString*)name;
{
  //on main thread
  dispatch_async(dispatch_get_main_queue(), ^{

    // Later, such as after a level is completed
    HZShowOptions *options = [[HZShowOptions alloc] init];
    options.viewController = [self.rootController currentViewController]; //self; // Only necessary if you're using multiple view controllers in your app
    options.tag = name;

    [HZVideoAd showWithOptions:options];

  });

}

-(BOOL)hasRewardedVideo:(NSString*)name
{
    //name ignored

    //force
    //return NO;

    return [HZIncentivizedAd isAvailable];
}

-(BOOL)showRewardedVideo:(NSString*)name
{

    BOOL hasRewarded = [self hasRewardedVideo:name];

    if(![kHelpers isForeground])
        return hasRewarded;
    if(self.alertView && self.alertView.visible)
        return hasRewarded;

    //always show hud
    [kHelpers showMessageHud:@""];
    //after delay hide
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kHelpers dismissHud];
    });

    [self stopMusic];


    //on main thread
    dispatch_async(dispatch_get_main_queue(), ^{

      // Later, such as after a level is completed
      HZShowOptions *options = [[HZShowOptions alloc] init];
      options.viewController = [self.rootController currentViewController]; //self; // Only necessary if you're using multiple view controllers in your app
      options.tag = name;

      [HZIncentivizedAd showWithOptions:options];

    });


    return hasRewarded;
}

#pragma mark -  notifications


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

#pragma mark - background

/*
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    Log(@"performFetchWithCompletionHandler");

    completionHandler(UIBackgroundFetchResultNoData);

}
*/

/*
- (void)updateDataWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    Log(@"updateDataWithCompletionHandler");

    //loggedin
    if([self isLoggedIn])  {
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    }

    if(![kHelpers checkOnline]) {
        completionHandler(UIBackgroundFetchResultNoData);
        return;
    }

    //set current date
    PFUser *user = [PFUser currentUser];
    NSDate *date = [NSDate date];
    [user setObject:date forKey:@"lastUsed"];
    [user saveEventually];

    completionHandler(UIBackgroundFetchResultNoData);
}
*/

//irate
#pragma mark - background

- (void)iRateDidPromptForRating {

    Log(@"iRateDidPromptForRating");

    [self playSound:@"kiss.caf"];

}

#if 0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([Optimizely handleOpenURL:url]) {
        return YES;
    }
    return NO;
}
#endif

#if 0
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {


#if kKTPlayEnabled

#if !(TARGET_IPHONE_SIMULATOR)
    [KTPlay handleOpenURL:url];
#endif
#endif
    /*return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];*/

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}
#endif


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    // handler code here
    Log(@"handleOpenURL");
#if kKTPlayEnabled
#if !(TARGET_IPHONE_SIMULATOR)
    [KTPlay handleOpenURL:url];
#endif
#endif
    return YES;
}

-(NSString*)getRandomStart:(int)index{

    return [CBSkinManager getRandomStart:index];
}

-(NSString*)getRandomMessage
{
    return [CBSkinManager getRandomMessage];
}


-(NSString*)getRandomOuch {
    return [CBSkinManager getRandomOuch];
}

-(float)getSpeedMultIndex {
    float mult = 1.0f;

    //level based
    mult += (self.level / 30.0f); // 10.0f;

    float max = 3.0f;
    if(mult > max)
        mult = max;

    //Log(@"getSpeedMultIndex: %f", mult);
    return mult;
}

-(NSArray*) getUnlockedSkinsArray {
    NSMutableArray *array = [NSMutableArray array];

    for(int i=0;i<kNumSkins;i++) {
        bool unlocked = [[self.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:i]] boolValue];
        if(unlocked) {
            [array addObject:@(i)];
        }
    }

    return array;
}

-(float)getMultIndex:(int)index {
    float mult = 1.0f;

    int numUnlocked = 0;

    for(int i=0;i<kNumSkins;i++) {
        bool unlocked = [[self.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:i]] boolValue];
        if(unlocked)
            numUnlocked++;
    }

    numUnlocked--; //always 1st unlocked

    mult += numUnlocked / 20.0f; //10.0f;

    //pew mult
    if([kHelpers isDebug] && kPewDebug) {
        if(index == kCoinTypePew) {
            mult = 20.0f;
        }
    }

    return mult;

}

-(NSString*)getPlusOne {

    NSString *tempString = nil;
    return tempString;
}

-(void)saveBlockImage {

    //not disabled, needed for notif?
    //return;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        UIImage *image = [CBSkinManager getBlockImage];
        assert(image);

        image = [kHelpers imageByScalingForSize:CGSizeMake(100,100) withImage:image];

        NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"group.skyriser.coinblock"];

        [prefs setObject:UIImagePNGRepresentation(image) forKey:@"currentSkinImage"];
        [prefs synchronize];
    });


    //file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"currentSkinImage.png"];

    // Save image
    //coin
    NSString *coinName = [CBSkinManager getCoinImageName];
    coinName = [NSString stringWithFormat:@"%@Frame1", coinName];
    UIImage *image = [UIImage imageNamed:coinName];

    float mult = 1.5f;

    // Setup a new context with the correct size
    CGFloat width = image.size.width*mult;
    CGFloat height = image.size.height*mult;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);

    // Now we can draw anything we want into this new context.
    CGPoint origin = CGPointMake((width - image.size.width) / 2.0f,
                                 (height - image.size.height) / 2.0f);
    [image drawAtPoint:origin];

    // Clean up and get the new image.
    UIGraphicsPopContext();
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    int numNotifs = 10;
    for(int i = 0; i<numNotifs; i++ )
    {
        NSString *filePath2 = filePath;
        filePath2 = [filePath2 stringByReplacingOccurrencesOfString:@"currentSkinImage.png" withString:[NSString stringWithFormat:@"currentSkinImage%d.png", i]];

        NSFileManager *fileManager = [[NSFileManager alloc] init];
        if([fileManager fileExistsAtPath:filePath2])
        {
            NSError *error;
            if (![fileManager removeItemAtPath:filePath2 error:&error])
            {
                NSAssert1(0, @"Could not remove old database file with message '%@'.", [error localizedDescription]);
            }
        }

        [UIImagePNGRepresentation(image) writeToFile:filePath2 atomically:YES];
    }
}

-(int)getInterstitialOdds:(int)odds {

    //return 100;

    if(!kShowInterstitial)
        return 0;

    //2 and up
    if(kAppDelegate.level < 2)
        return 0;

    //invalid
    if(odds <= 0)
        return 0;
    if([self isPremium])
        return 0;
    if(self.cheatAdsDisabled)
        return 0;
    if(! [kHelpers checkOnline])
        return 0;
    if(![self launchedEnough])
        return 0;
    if(![kHelpers isForeground])
        return 0;
    if(self.alertView && self.alertView.visible)
        return 0;

    NSTimeInterval interval = 0;

    interval = [self.interstitialLastDate timeIntervalSinceNow];
    interval = ABS(interval);
    //not too soon
    if(self.interstitialLastDate && interval < self.interstitialDelayBetween)
        return 0;

    interval = [self.launchDate timeIntervalSinceNow];
    interval = ABS(interval);
	NSTimeInterval max = 30; //secs
    if(interval < max)
        return 0;

    /*interval = [self.dateBackground2 timeIntervalSinceNow];
    interval = ABS(interval);
    if(self.dateBackground2 && interval < 10)
        return 0;*/

    //levels
    if(self.level < 2) {
        return 0;
    }
    /*if(self.level < 10) {
        odds *= 0.5f; //50;
    }
    else if(self.level < 15) {
        odds *= 1.0f; // = 100;
    }
    else {
        odds *= 1.0; // = 100;
    }*/

    return odds;
}

-(NSString*)getFireballName {

    return [CBSkinManager getFireballName];
}

-(NSString*)getBlockShineImageName {

    NSString *name = @"block_shine";

    int index = (int)[self getSkin];
    if(index == kCoinTypeEmoji)
    {
        name = @"block_shine2";
    }
    else if(index == kCoinTypeNyan)
    {
        name = @"block_shine3";
    }

    else if(index == kCoinTypeBrain)
    {
        name = nil;
    }

    else if(index == kCoinTypeValentine)
    {
        name = nil;
    }

    else if(index == kCoinTypePatrick)
    {
        name = nil;
    }
    else if(index == kCoinTypeSoccer)
    {
        name = nil;
    }

    return name;
}

-(UIColor*)getBlockColor {

    int index = (int)[self getSkin];

    UIColor *color = [UIColor whiteColor];

    if(index == kCoinTypeDefault) {
       //color = [UIColor whiteColor];
    }

    else if(index == kCoinTypeFlat) {
        //color = [UIColor colorWithHex:0x006048];
    }
    else if(index == kCoinTypeMega) {
        //color = [UIColor colorWithHex:0x006048];
    }
    else if(index == kCoinTypeMine) {
        //color = [UIColor colorWithHex:0x006048];
    }
    else if(index == kCoinTypeMetal) {
        //color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypeYoshi) {
        color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypeSonic) {
        //color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypePew) {
        //color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypeZelda) {
        //color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypeBitcoin) {
        //color = [UIColor colorWithHex:0x006048];
    }
    else if(index == kCoinTypeMac) {
        //color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypeFlap) {
        //color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypeMario) {
        //color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypeGameboy) {
        //color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypeZoella) {
        //color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypeMontreal) {
        color = [UIColor colorWithHex:0x093b76];
    }
    else if(index == kCoinTypeTA) {
        //color = [UIColor colorWithHex:0x006048];
    }
    else if(index == kCoinTypeBrain) {
        //color = [UIColor colorWithHex:0x006048];
    }
    else if(index == kCoinTypeNyan) {
        //color = [UIColor colorWithHex:0x006048];
    }
    else if(index == kCoinTypeEmoji) {
        //color = [UIColor colorWithHex:0x006048];
    }

    else if(index == kCoinTypeValentine) {
        //color = [UIColor colorWithHex:0x006048];
    }
    else if(index == kCoinTypePatrick) {
        //color = [UIColor colorWithHex:0x006048];
    }
    else if(index == kCoinTypeSoccer) {
        //color = [UIColor colorWithHex:0x006048];
    }


    else {
        //default
        Log(@"getBlockColor: default");
    }

    return color;
}

-(void)setSkin:(NSInteger)newSkin
{
	bool unlocked = [[self.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:newSkin]] boolValue];
	//if(newSkin == kCoinTypeBrain && !unlocked)
	if(!unlocked)
	{
		//ignore locked
	}
	else
	{
		self.currentSkin = newSkin;
	}
}

-(NSInteger)getSkin
{
	if(self.level == kLevelMax)
	{
		//force brain
		return kCoinTypeBrain;
	}
	else
	{
		return self.currentSkin;
	}
}

-(BOOL)isBlockSpecial:(int)index{

    //if(index == kCoinTypeFlap || index== kCoinTypeMario || index== kCoinTypeGameboy)
   /* if(index== kCoinTypeMario)
        return YES;
    else
        return NO;
    */
    return NO;
}


-(void)unlockDoubler {

    //refill
    self.numHearts = kHeartFull;

    self.doubleEnabled = YES;
    [self saveState];
}

-(void)markAllAsRead {

    for(int i=0;i<kNumSkins;i++) {

        //_dicSkinEnabled
        BOOL isNew = [[self.dicSkinNew safeObjectForKey:[CBSkinManager getSkinKey:i]] boolValue] &&
            [[self.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:i]] boolValue];
        if(isNew) {
            [self.dicSkinNew setObject:@(NO) forKey:[CBSkinManager getSkinKey:i]];
        }
    }

    [self saveState];
}


-(int)unlockRandomBlock {
 return [self unlockRandomBlock:YES];
}

-(int)unlockRandomBlock:(BOOL)shouldUnlock
{
	int which = kCoinTypeNone;

#if 1
//in order
  NSArray *array = @[
    @(kCoinTypeMine),
    @(kCoinTypeBitcoin),
    @(kCoinTypeYoshi),
    @(kCoinTypeSonic),
    @(kCoinTypeGameboy),
    @(kCoinTypeTA),
    @(kCoinTypeEmoji),
    @(kCoinTypeSoccer),
    @(kCoinTypeValentine),
    @(kCoinTypePatrick),
    @(kCoinTypeZelda),
    @(kCoinTypeFlap),
    @(kCoinTypePew),
    @(kCoinTypeBrain),
  ];

  for(NSNumber *num in array)
  {
    int tempWhich = [num intValue];
    bool unlocked = [[self.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:tempWhich]] boolValue];
    if(!unlocked)
    {
      //found next one, done
      which = tempWhich;
      break;
    }
  }

  //random unlock nothing?
  //???

  //none
  if(which == kCoinTypeNone)
    return kCoinTypeNone;

#endif

	bool unlocked = [[self.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:which]] boolValue];
	if(!unlocked)
	{
		//found one, unlock
		if(shouldUnlock)
		{
			[self unlockBlock:which];

			//force new
			[self.dicSkinNew setObject:@(YES)forKey:[CBSkinManager getSkinKey:which]];
		}
		//done
		return which;
	}
	else
	{
	    return kCoinTypeNone;
	}



}

-(void)unlockVIPBlocks
{
//disabled
//return;

#if 1
	[self unlockBlock:kCoinTypeMine];
	[self unlockBlock:kCoinTypeBitcoin];
	[self unlockBlock:kCoinTypeYoshi];
	[self unlockBlock:kCoinTypeGameboy];
    [self unlockBlock:kCoinTypeTA];

    [self unlockBlock:kCoinTypeMario];

	[self saveState];
#endif
}

-(void)unlockAllBlocks {

    //only debug
    if(! [kHelpers isDebug])
        return;

    //even vip
    for(int i=0;i<kNumSkins;i++)
    {
        if(i == kCoinTypeMario2 || i == kCoinTypeComingSoon)
            continue;

        [self unlockBlock:i];
    }
}

-(void)unlockBlock:(int)index {

    if(index == kCoinTypeNone)
        return;

    if(index == kCoinTypeMario2 || index == kCoinTypeComingSoon)
        return;

    else if(index == kCoinTypeMario2)
    {
        //assert(0);
        return;
    }

    //refill
    self.numHearts = kHeartFull;

    //_dicSkinEnabled
    [self.dicSkinEnabled setObject:@(YES) forKey:[CBSkinManager getSkinKey:index]];
    [self.dicSkinNew setObject:@(YES)forKey:[CBSkinManager getSkinKey:index]];  //add new flag

    int numUnlocked = 0;
    for(int i=0;i<kNumSkins;i++) {
        bool unlocked = [[self.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:i]] boolValue];
        if(unlocked)
            numUnlocked++;
    }
    if(numUnlocked)
    {
        //after 1st unlock random
        self.isRandomSkin = YES;
    }


    //also disable ads
    //self.adBannerEnabled = NO;

    //[self saveState];
}

//ios11
- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product
{
    //not used here, check IAPHelper.m
    //all
    return YES;
}

-(void)restoreVIPSuccessful
{
    //vip
    self.adBannerEnabled = NO;

    //also unlock
    [self unlockVIPBlocks];

    //refill
    self.numHearts = kHeartFull;

    //also doubler
    [self unlockDoubler];

    //achievement
    [kAppDelegate reportAchievement:kAchievement_vip];

    [kAppDelegate saveState];
}

-(void)restoreFromPayment:(SKPaymentQueue *)payment
{
    //check with SKPaymentQueue
    for (SKPaymentTransaction *transaction in payment.transactions)
    {
        NSString *purchased = transaction.payment.productIdentifier;
        if([purchased isEqualToString:kIAP_NoAds] || [purchased isEqualToString:kIAP_NoAds2])
        {
            [self restoreVIPSuccessful];
        }
        else
        {
            //skins
            for(int i=0;i<kNumSkins;i++)
            {
                if([purchased isEqualToString:[CBSkinManager getSkinIAP:i]])
                {
                    //not vip
                    if(i != kCoinTypeMario)
                        [self unlockBlock:i];
                }

            }
        }

    }

    [self saveState];
}

-(void)updateBlockEnabled {

    int index = 0;

    //just 1st
    //0
    index = kCoinTypeDefault;

    [self.dicSkinEnabled setObject:@(YES) forKey:[CBSkinManager getSkinKey:index]];
    [self.dicSkinNew setObject:@(NO) forKey:[CBSkinManager getSkinKey:index]];

    //doesn't exist
    for(index=0;index<kNumSkins;index++)
    {
        if(![self.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:index]])
        {
            [self.dicSkinEnabled setObject:@(NO) forKey:[CBSkinManager getSkinKey:index]];
        }
    }

    //check premium
    if(!self.adBannerEnabled) {
        //unlock all
        [self unlockVIPBlocks];
    }
}

-(int)getMaxFireballs {

	//force
	//return 10;

    int num = (int)self.level;

    //special

    if(self.level == 1)
    {
		//1st level

        if(self.subLevel == 1)
            num = 1;
        else if (self.subLevel == 2)
            num = 2;
        else if (self.subLevel == 3 || self.subLevel == 4)
            num = 2;
    }
    else
    {
		//others

        if(self.subLevel == 1)
            num += 0;
        else if (self.subLevel == 2 || self.subLevel == 3)
            num += 1;
        else if (self.subLevel == 4)
            num += 2;
    }

	//max
    num = MIN(num, 32); //32

    return num;
}

-(BOOL)isBlockRemoteEnabledIndex:(int)index {

    return YES;
#if 0
    BOOL enabled =  [[_arraySkinRemoteEnabled safeObjectAtIndex:index] boolValue];

    //disabled
    if(
       index == kCoinTypeFarm ||
       index == kCoinTypeCoookie ||
       index == kCoinTypeCandy ||
       index == kCoinTypeXmas ||
       index == kCoinTypeLaundro
       )
        return NO;

    //NSFW
    if(self.inReview) {
        if(
           index == kCoinTypeYoshi ||
           index == kCoinTypeZelda
           )
            return NO;

    }

    return (enabled);

#endif
}

-(BOOL)isBlockEnabledIndex:(int)index {

    if(index >= kNumSkins || index < 0)
        return NO; //last, random

    NSString *name = [CBSkinManager getBlockImageNameIndex:index];
    BOOL enabled = [[self.dicSkinEnabled safeObjectForKey:[CBSkinManager getSkinKey:index]] boolValue];

    return (name && enabled /*&& enoughLevel*/);
}

-(int)getNumNewSkins {

    int num = 0;

    //go through array, count new
    for(int i=0;i<kNumSkins;i++) {
        if([[self.dicSkinNew safeObjectForKey:[CBSkinManager getSkinKey:i]] boolValue] &&
           [self isBlockEnabledIndex:i] &&
           [self isBlockRemoteEnabledIndex:i])
            num++;
    }

    return num;
}

- (BOOL)isLoggedIn {
    BOOL loggedIn = NO;
    return loggedIn;
}

- (void)logout {
    [self saveState];
}

- (void)logoutFacebook {
    //logout facebook
    //[[PFFacebookUtils facebookLoginManager] logOut];

    //[[PFFacebookUtils session] close];
    //[FBSession.activeSession close];
    //[FBSession.activeSession closeAndClearTokenInformation];
    //[FBSession setActiveSession:nil];
    //[PFFacebookUtils initializeFacebook];

    /*
    FBSDKLoginManager *login = [PFFacebookUtils facebookLoginManager];
    if(login)
        [login logOut];
     */
}

-(void)animateControl:(id)sender {

    //disabled
    //return;

    //http://www.appcoda.com/facebook-pop-framework-intro/

    //force main thread
    //[[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        sprintAnimation.springBounciness = 20.f;
        [sender pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    //}];
}

-(void)scaleView:(UIView*)inView
{
    //return;

    if([kHelpers isIphoneX])
    {
        //inView.y = 50;
        inView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kiPhoneXScaleX, kiPhoneXScaleY);
    }
    else if([kHelpers isIpad])
    {
        //inView.y = 50;
        inView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kiPadScaleX, kiPadScaleY);
    }

}


-(void)cornerView:(UIView*)inView
{
    //disabled
    return;

#if 0
    if(self.inReview) {
        return;
    }

    //float radius = 5.0f;
    float radius = 10.0f;

    //reset
    [inView.layer setCornerRadius:0];

    //set
    inView.layer.backgroundColor = [UIColor blackColor].CGColor;
    [inView.layer setMasksToBounds:YES];
    [inView.layer setCornerRadius:radius]; //5.0f or 8.0f?
    //inView.clipsToBounds = YES;
    //inView.layer.masksToBounds = YES;

    inView.backgroundColor = [UIColor blackColor];

    //parent
    if(inView.superview) {
        //[self cornerView:inView.superview];
    }
#endif
}


#pragma mark - AirPlay and extended display

- (void)setupOutputScreen
{
    //disable
    return;

#if 0
    // Register for screen notifications
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
    [center addObserver:self selector:@selector(screenModeDidChange:) name:UIScreenModeDidChangeNotification object:nil];

    // Setup screen mirroring for an existing screen
    NSArray *connectedScreens = [UIScreen screens];
    if ([connectedScreens count] > 1) {
        UIScreen *mainScreen = [UIScreen mainScreen];
        for (UIScreen *aScreen in connectedScreens) {
            if (aScreen != mainScreen) {
                // We've found an external screen !
                Log(@"setupOutputScreen: found external screen");
                //[self setupMirroringForScreen:aScreen];
                break;
            }
        }
    }
#endif
}

- (void)screenDidConnect:(NSNotification *)aNotification
{
    Log(@"screenDidConnect");
}

- (void)screenDidDisconnect:(NSNotification *)aNotification
{
    Log(@"screenDidDisconnect");

}

- (void)screenModeDidChange:(NSNotification *)aNotification
{
    Log(@"screenModeDidChange");

}

-(void)openRatings
{
    NSString *urlString = nil;

    //http://linkmaker.itunes.apple.com

    if(kIsIOS11_0)
    {
        urlString = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/itunes-u/id%d?action=write-review", kAppStoreAppID];

    }
    else
    {
        urlString = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%d&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", kAppStoreAppID];
    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:nil];

}

- (void)actionHashtag {
    //checks to see if app is available, opening in safari opens the wrong page in the app
    //if( [[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString: kURLTwitterApp]] ) {
    if(YES) {
        [self openExternalURL:kURLTwitterApp];
    }
}


-(void) openExternalURL:(NSString*)url {
    if([self validateURL:url])
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url] options:@{} completionHandler:nil];
    else
        Log(@"invalid url");
}


-(BOOL) validateURL:(NSString*)url {

    if(url == nil || [url isEqual:[NSNull null]] || url.length == 0) {
        Log(@"Invalid URL: %@", url);
        return NO;
    }

    return YES;

}

-(void)firebaseInitObjects {

    if(![kHelpers checkOnline])
        return;


    //if(!self.fireCoinCount)
    {
        self.fireCoinCount = [self.firebaseDatabase child:@"coinCount"];
        [self.fireCoinCount keepSynced:YES];

        /*FIRDatabaseQuery *fireCoinCountQuery = [[self.fireCoinCount queryOrderedByChild:@"key"] queryLimitedToLast:1];

        FIRDatabaseHandle refHandle = [fireCoinCountQuery observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *postDict = snapshot.value;
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
        }];*/

        [self.fireCoinCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        //[self.fireCoinCount observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {
                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.clickCountWorld = [number doubleValue];
                    //Log(@"self.clickCountWorld: %@", [NSNumber numberWithDouble:self.clickCountWorld]);

                    if(self.titleController.menuState == menuStateTitle) {
                        [self.titleController updateTitleCount];
                    }
                }
            }
        }];
    }

    //if(!self.fireLaunchCount)
    {
        self.fireLaunchCount = [self.firebaseDatabase child:@"launchCount"];
        [self.fireLaunchCount keepSynced:YES];

        [self.fireLaunchCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
//                    self.launchCount = [number doubleValue];
//                    Log(@"self.launchCount: %@", [NSNumber numberWithDouble:self.launchCount]);
                }
            }
        }];
    }

    //if(!self.firePlayCount)
    {
        self.firePlayCount = [self.firebaseDatabase child:@"playCount"];
        [self.firePlayCount keepSynced:YES];

        [self.firePlayCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.playCount = [number doubleValue];
                    //Log(@"self.playCount: %@", [NSNumber numberWithDouble:self.playCount]);
                }
            }
        }];
    }

    //if(!self.fireEndingCount)
    {
        self.fireEndingCount = [self.firebaseDatabase child:@"endingCount"];
        [self.fireEndingCount keepSynced:YES];

        [self.fireEndingCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                }
            }
        }];
    }

    //if(!self.firePauseCount)
    {
        self.firePauseCount = [self.firebaseDatabase child:@"pauseCount"];
        [self.firePauseCount keepSynced:YES];

        [self.firePauseCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                }
            }
        }];
    }

    //if(!self.fireTimeForeground)
    {
        self.fireTimeForeground = [self.firebaseDatabase child:@"timeForeground"];
        [self.fireTimeForeground keepSynced:YES];

        [self.fireTimeForeground observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
           //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    //self.playCount = [number doubleValue];
                    //Log(@"self.playCount: %@", [NSNumber numberWithDouble:self.playCount]);
                }
            }
        }];
    }


    //if(!self.fireLevelupCount)
    {
        self.fireLevelupCount = [self.firebaseDatabase child:@"levelupCount"];
        [self.fireLevelupCount keepSynced:YES];

        [self.fireLevelupCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.starLevelCount = [number doubleValue];
                    //Log(@"self.starLevelCount: %@", [NSNumber numberWithDouble:self.starLevelCount]);
                }
            }
        }];
    }


    //if(!self.fireDieCount)
    {
        self.fireDieCount = [self.firebaseDatabase child:@"dieCount"];
        [self.fireDieCount keepSynced:YES];

        [self.fireDieCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.dieCount = [number doubleValue];
                    //Log(@"self.dieCount: %@", [NSNumber numberWithDouble:self.dieCount]);
                }
            }
        }];
    }


    //if(!self.fireFireCount)
    {
        self.fireFireCount = [self.firebaseDatabase child:@"fireCount"];
        [self.fireFireCount keepSynced:YES];

        [self.fireFireCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.fireCount = [number doubleValue];
                    //Log(@"self.fireCount: %@", [NSNumber numberWithDouble:self.fireCount]);
                }
            }
        }];
    }


    //if(!self.fireSpikeCount)
    {
        self.fireSpikeCount = [self.firebaseDatabase child:@"spikeCount"];
        [self.fireSpikeCount keepSynced:YES];

        [self.fireSpikeCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.spikeCount = [number doubleValue];
                    //Log(@"self.spikeCount: %@", [NSNumber numberWithDouble:self.spikeCount]);
                }
            }
        }];
    }




    //if(!self.firePowerupCount)
    {
        self.firePowerupCount = [self.firebaseDatabase child:@"powerupCount"];
        [self.firePowerupCount keepSynced:YES];

        [self.firePowerupCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.powerupCount = [number doubleValue];
                    //Log(@"self.powerupCount: %@", [NSNumber numberWithDouble:self.powerupCount]);
                }
            }
        }];
    }


    //if(!self.fireRateCount)
    {
        self.fireRateCount = [self.firebaseDatabase child:@"rateCount"];
        [self.fireRateCount keepSynced:YES];

        [self.fireRateCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.rateCount = [number doubleValue];
                    //Log(@"self.rateCount: %@", [NSNumber numberWithDouble:self.rateCount]);
                }
            }
        }];
    }



    //if(!self.fireShareCount)
    {
        self.fireShareCount = [self.firebaseDatabase child:@"shareCount"];
        [self.fireShareCount keepSynced:YES];

        [self.fireShareCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.shareCount = [number doubleValue];
                    //Log(@"self.shareCount: %@", [NSNumber numberWithDouble:self.shareCount]);
                }
            }
        }];
    }

    //if(!self.fireInstallCount)
    {
        self.fireInstallCount = [self.firebaseDatabase child:@"installCount"];
        [self.fireInstallCount keepSynced:YES];

        [self.fireInstallCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    //self.installCount = [number doubleValue];
                    //Log(@"self.installCount: %@", [NSNumber numberWithDouble:self.installCount]);
                }
            }
        }];
    }


    //if(!self.firePotionCount)
    {
        self.firePotionCount = [self.firebaseDatabase child:@"potionCount"];
        [self.firePotionCount keepSynced:YES];

        [self.firePotionCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    //self.installCount = [number doubleValue];
                    //Log(@"self.installCount: %@", [NSNumber numberWithDouble:self.installCount]);
                }
            }
        }];
    }



    //if(!self.fireToastieCount)
    {
        self.fireToastieCount = [self.firebaseDatabase child:@"toastieCount"];
        [self.fireToastieCount keepSynced:YES];

        [self.fireToastieCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.toastieCount = [number doubleValue];
                    //Log(@"self.toastieCount: %@", [NSNumber numberWithDouble:self.toastieCount]);
                }
            }
        }];
    }




    //if(!self.firePremiumCount)
    {
        self.firePremiumCount = [self.firebaseDatabase child:@"premiumCount"];
        [self.firePremiumCount keepSynced:YES];

        [self.firePremiumCount observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            //Log(@"key %@ value %@", snapshot.key, snapshot.value);
            if(snapshot) {

                NSNumber *number = snapshot.value;
                if(number && ![number isKindOfClass:[NSNull class]])
                {
                    self.premiumCount = [number doubleValue];
                    //Log(@"self.premiumCount: %@", [NSNumber numberWithDouble:self.premiumCount]);
                }
            }
        }];
    }

}

-(void)dbInitObjects {

    //firebase
    [self firebaseInitObjects];
}

-(void)firebaseSaveObjects
{
}

-(void)dbSaveObjects {

    [self firebaseSaveObjects];
}


-(void)dbIncEnding {

    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireEndingCount) {

        //[self.fireEndingCount setValue:@(1001)];

        //https://firebase.google.com/docs/database/ios/save-data#save_data_as_transactions
        [self.fireEndingCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"dbIncEnding: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }
}


-(void)dbIncTimeForeground {

    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireTimeForeground) {

        //[self.fireTimeForeground setValue:@(1001)];

        //https://firebase.google.com/docs/database/ios/save-data#save_data_as_transactions
        [self.fireTimeForeground runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            double value = [number doubleValue];
            number = [NSNumber numberWithDouble:value + self.timeForeground];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"dbIncTimeForeground: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
            else{
                self.timeForeground = 0;
            }
        }];
    }
}

-(void)dbIncPause {

    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.firePauseCount) {

        //[self.firePauseCount setValue:@(1001)];

        //https://firebase.google.com/docs/database/ios/save-data#save_data_as_transactions
        [self.firePauseCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"dbIncPause: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }
}

-(void)dbIncCoin:(float)inValue {

	//not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
		return;

    if(self.fireCoinCount) {

        //[self.fireCoinCount setValue:@(1001)];

        //https://firebase.google.com/docs/database/ios/save-data#save_data_as_transactions
        [self.fireCoinCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + inValue];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"parseIncCoin: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }
}

-(void)dbIncClick {
}

-(void)dbIncPlay {

    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.firePlayCount) {

        [self.firePlayCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"parseIncPlay: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }

}

-(void)dbIncDie {

    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireDieCount) {

        [self.fireDieCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"fireFireCount: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }
}

-(void)dbIncSpike {

    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireSpikeCount) {

        [self.fireSpikeCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"fireSpikeCount: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }
}

-(void)dbIncRate {
    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireRateCount) {

        [self.fireRateCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"fireRateCount: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }

}

-(void)dbIncShare {
    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireShareCount) {

        [self.fireShareCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"fireShareCount: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }

}

-(void)dbIncInstall {
    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireInstallCount) {

        [self.fireInstallCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"fireInstallCount: %@", number);

            self.prefInstallCountSent = YES;
            [self saveState];

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }

}

-(void)dbIncPotion {
    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.firePotionCount) {

        [self.firePotionCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"firePotionCount: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }
}

-(void)dbIncPowerup {
    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.firePowerupCount) {

        [self.firePowerupCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"firePowerupCount: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }
}

-(void)dbIncToastie {
    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireToastieCount) {

        [self.fireToastieCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"fireToastieCount: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }
}


-(void)dbIncPremium {
    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.firePremiumCount) {

        [self.firePremiumCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"firePremiumCount: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }

}

-(void)dbIncFire {

    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireFireCount) {

        [self.fireFireCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"parseIncFire: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }
}

-(void)dbIncLaunch {

    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireLaunchCount) {

        [self.fireLaunchCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"parseIncLaunch: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }

}

-(void)dbIncLevelup {

    //not online?
    if(![kHelpers checkOnline] || [kHelpers isDebug])
        return;

    if(self.fireLevelupCount) {

        [self.fireLevelupCount runTransactionBlock:^FIRTransactionResult * _Nonnull(FIRMutableData * _Nonnull currentData) {
            NSNumber *number = currentData.value;
            if (!number || [number isEqual:[NSNull null]]) {
                return [FIRTransactionResult successWithValue:currentData];
            }

            int value = [number intValue];
            number = [NSNumber numberWithInt:value + 1];


            // Set value and report transaction success
            [currentData setValue:number];
            //Log(@"parseIncLevelup: %@", number);

            return [FIRTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError * _Nullable error,
                               BOOL committed,
                               FIRDataSnapshot * _Nullable snapshot) {
            // Transaction completed
            if (error) {
                Log(@"%@", error.localizedDescription);
            }
        }];
    }
}

-(void)checkHeartRefill
{
    if(self.dateBackground == nil)
        return;

    NSTimeInterval interval = [self.dateBackground timeIntervalSinceNow];
    interval = ABS(interval);

    int healedHalf = (floor)(interval / kRefillTime);
    self.numHearts += healedHalf;

    if(self.numHearts > kHeartFull)
        self.numHearts = kHeartFull;

    /*float duration = 60 * kRefillTime; //in secs, 1h
    if(interval > duration)
    {
        self.numHearts = kHeartFull;
    }*/

    //reset
    self.dateBackground = nil;

    [self saveState];
}

//downloads, msuic

-(void)checkAssets {
	if(![kHelpers isWifi])
		return;

	//[self checkLocalMusic];
}

-(void)downloadMusic {

	//https://s3.amazonaws.com/coinblock/musicDefault.mp3
}


- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = paths.firstObject;
    return basePath;
}

- (NSString*) savePath
{
    NSString *path = nil;
    NSFileManager *fileManager = [[NSFileManager alloc] init]; //[NSFileManager defaultManager];
    BOOL isDir;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    path = paths.firstObject;
    path = [path stringByAppendingPathComponent:@"Assets"];
    path = [path stringByAppendingPathComponent:@"wav"];
    //create it if not exist
    if(![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        if(![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:NULL]) {
            Log(@"Error: Create folder failed %@", path);
        }
        else {
            //good
            //mark as do not backup
            [self addSkipBackupAttributeToItemAtPath:path];
        }
    }

    path = [path stringByAppendingString:@"/"];

    return path;
}

- (BOOL)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);

    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        Log(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

-(int)numFilesInFolderAtPath:(NSString*)path {
    NSError *error = nil;
    assert(path);
	NSFileManager *fm = [NSFileManager defaultManager];
	NSArray *filelist= [fm contentsOfDirectoryAtPath:path error:&error];
	int filesCount = (int)[filelist count];
	return filesCount;
}

-(int)numSoundsInFolder {
	NSString *path = [self savePath];
    assert(path);
	int filesCount = [self numFilesInFolderAtPath:path];
	return filesCount;
}

-(void)deleteAllSoundFiles {
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *directory = [self savePath];
	NSError *error = nil;
	for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
		BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@%@", directory, file] error:&error];
		if (!success || error) {
				Log(@"deleteAllSoundFiles error");
		}
	}
}

- (int)getFreeSpace {
	long long freeSpace = 0.0f;
	NSError *error = nil;
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];

	if (dictionary) {
		NSNumber *fileSystemFreeSizeInBytes = [dictionary objectForKey: NSFileSystemFreeSize];
		freeSpace = [fileSystemFreeSizeInBytes longLongValue];

		//mb
        freeSpace /= (1024*1024);
        //freeSpace /= (1000000);

	} else {
		//Handle error
		Log(@"getFreeSpace error");
	}
	return (int)freeSpace;
}

-(BOOL)checkDiskSpace {
	//force
	//return NO;
	long long available = [self getFreeSpace];
	long long needed = 50; //mb

	return (available > needed);
}

- (FISound*) soundNamed: (NSString*) soundName maxPolyphony: (NSUInteger) voices error: (NSError**) error
{

    NSString *soundName2 = soundName;
    //on purpose
    if(!soundName2)
        return nil;

    //assert(soundName);
    assert(![soundName containsString:@".wav"]);
    assert([soundName containsString:@".caf"]);

    //wav
    NSString *path = [self savePath];
    soundName2 = [soundName2 stringByReplacingOccurrencesOfString:@".caf" withString:@".wav"];
    path = [path stringByAppendingString:soundName2];

    FISound* sound = [[FISound alloc]
                      initWithPath:path
                      maxPolyphony:voices error:error];

    if(!sound) {
        Log(@"sound nil");
    }
    return sound;
}

-(BOOL)isGameCenterNotificationUp
{
	//disabled
	return NO;
}

- (void)downloadCommercial:(BOOL)shouldDelete {

    //disabled
    return;

#if 0
    if(self.inReview) {
        return;
    }

    if(![kHelpers isWifi]) {
        return;
    }

    NSFileManager *fileManager = [[NSFileManager alloc] init]; //[NSFileManager defaultManager];

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:kCommercialName];

    //skip
    if([fileManager fileExistsAtPath:path]) {
        if(shouldDelete) {

            //force delete
            //NSError* error;
            //[fileManager removeItemAtPath:path error:&error];

            //check date
            NSDictionary* attrs = [fileManager attributesOfItemAtPath:path error:nil];

            if (attrs != nil) {
                NSDate *date = (NSDate*)[attrs objectForKey: NSFileCreationDate];
                Log(@"Date Created: %@", [date description]);

                //older than 7 days
                if([kHelpers daysBetweenDate:date andDate:[NSDate date]] > 7) {
                   NSError* error;
                   [fileManager removeItemAtPath:path error:&error];
                }
                else {
                    return;
                }
            }
            else {
                Log(@"Not found");
            }

        }
        else {
            return;
        }
    }

    if(self.commercialOperation) {
        [self.commercialOperation cancel];

        if([fileManager fileExistsAtPath:path]) {
            NSError* error;
            [fileManager removeItemAtPath:path error:&error];
        }
    }

    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dropbox.com/s/h7grc3driaghpor/commercial1.mp4?dl=1"]]; //big
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dropbox.com/s/lagmn049r1gjaod/commercial1_small.mp4?dl=1"]]; //small

    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://firebasestorage.googleapis.com/v0/b/project-1561245108296536878.appspot.com/o/commercial1_small.mp4?alt=media&token=787b2780-7d9b-48fa-b941-e921f8922179"]]; //firebase small
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://firebasestorage.googleapis.com/v0/b/project-1561245108296536878.appspot.com/o/commercial1_small2.mp4?alt=media&token=82130692-a094-411d-9bdc-75c23071afdc"]]; //firebase small2

    self.commercialOperation = nil;
    self.commercialOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];;

    self.commercialOperation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];

    __weak typeof(self) weakSelf = self;

    [self.commercialOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        Log(@"Successfully downloaded file to %@", path);

        weakSelf.commercialOperation = nil;

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        Log(@"Error: %@", error);

        weakSelf.commercialOperation = nil;

        if([fileManager fileExistsAtPath:path]) {
            NSError* error;
            [fileManager removeItemAtPath:path error:&error];
        }

    }];

    [self.commercialOperation start];
#endif
}

-(void)forceLanguage:(NSString*)language
{
    //language = @"fr";
    //language = @"en";
    //language = nil;

  if(language)
  {
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:language, nil] forKey:@"AppleLanguages"];
  }
  else
  {
    //enlever au lieu d'ajouter une liste vide
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"AppleLanguages"];
  }

  [[NSUserDefaults standardUserDefaults] synchronize];

}

-(BOOL)isEnglish
{
  return [self isLanguage:@"en"];
}

-(BOOL)isFrench
{
  return [self isLanguage:@"fr"];
}

-(BOOL)isSpanish
{
  return [self isLanguage:@"es"];
}

-(BOOL)isLanguage:(NSString*)language
{
  assert(language && language.length);

  if(!language || language.length == 0)
    return NO;

//   NSArray *currentLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//   NSString *currentLanguage = [currentLanguages firstObject];

  NSArray *currentLanguages2 = [NSLocale preferredLanguages];
  NSString * currentLanguage2 = [currentLanguages2 firstObject];

  //https://developer.apple.com/library/content/technotes/tn2418/_index.html#//apple_ref/doc/uid/DTS40016588-CH1-LANGUAGE_IDENTIFIERS_IN_IOS__MACOS__WATCHOS__AND_TVOS
  //... language set to English and region set to India, Locale.preferredLanguages() will
  //now return [ "en-IN" ], instead of [ "en" ]. This allows for smarter language fallbacks; for this user, if an app doesn’t support en-IN as a localization, but does support en-GB, the fallback mechanism will select en-GB instead of en.

  //https://www.ibabbleon.com/iOS-Language-Codes-ISO-639.html
  // English (U.S.)	en
  // English (British)	en-GB
  // English (Australian)	en-AU
  // English (Canadian)	en-CA
  // English (Indian)

  //if([currentLanguage2 containsString:[NSString stringWithFormat:@"%@-", language]])
  if([currentLanguage2 containsString:[NSString stringWithFormat:@"%@", language]])
    return YES;
  else
    return NO;
}


@end
