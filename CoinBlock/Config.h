//
//  Config.h
//

#import "UAObfuscatedString.h"

//cleanup
//find . -type d -name '.svn' -print0 | xargs -0 rm -rdf
//find . -type d -name 'CoinBlock.xccheckout' -print0 | xargs -0 rm -rdf
//find . -type d -name 'chris.xcuserdatad' -print0 | xargs -0 rm -rdf
//find . -type d -name '.git' -print0 | xargs -0 rm -rdf
//find . -name ".DS_Store" -depth -exec rm {} \;

//login

//facebook
#define kFacebookAppID @"???"
//#define kFacebookAppSecret @"???"

//twitter
#define kTwitterAPIKey @"???"
#define kTwitterAPISecret @"???"

//constants
#define kIAP_NoAds Obfuscate.r.e.m.o.v.e.a.d.s //@"removeads"
#define kIAP_NoAds2 Obfuscate.r.e.m.o.v.e.a.d.s._2 //@"removeads2"
//skins
#define kIAP_SkinMiner @"skinMiner"
#define kIAP_SkinLinked @"skinLinked"
#define kIAP_SkinHacker @"skinHacker"
#define kIAP_SkinEmoji @"skinEmoji"
#define kIAP_SkinEgg @"skinEgg"
#define kIAP_SkinEdgy @"skinEdgy"
#define kIAP_SkinFlappy @"skinFlappy"
#define kIAP_SkinOhBoy @"skinOhBoy"
#define kIAP_SkinTouchArcade @"skinTouchArcade"
#define kIAP_SkinPewDiePie @"skinPewDiePie"
#define kIAP_Coffee @"coffee"

#define kNumDaysPremiumSale 2 //3

//#define kIAP_Doubler Obfuscate.d.o.u.b.l.e.r //@"doubler"
//#define kIAP_SkinAll Obfuscate.s.k.i.n.A.l.l  //@"skinAll"
//#define kIAP_Keys Obfuscate.k.e.y.s  //@"keys"
#define kIAP_sharedSecret @"???"

//#define kIAP_Skin1 @"skin1"
//#define kIAP_Skin2 @"skin2"
//#define kIAP_Skin3 @"skin3"
//#define kIAP_Skin4 @"skin4"
//#define kIAP_Skin5 @"skin5"
//#define kIAP_Skin6 @"skin6"
//#define kIAP_Skin7 @"skin7"
//#define kIAP_Skin8 @"skin8"
//#define kIAP_Skin9 @"skin9"
//#define kIAP_Skin10 @"skin10"
//#define kIAP_Skin11 @"skin11"
//#define kIAP_Skin12 @"skin12"
//#define kIAP_Skin13 @"skin13"
//#define kIAP_Skin14 @"skin14"
//#define kIAP_Skin15 @"skin15"
//#define kIAP_Skin16 @"skin16"
//#define kIAP_Skin17 @"skin17"
//#define kIAP_Skin18 @"skin18"

//whitebar
#define kWhiteBarDuration 8
#define kWhiteBarDistanceExtra 200
#define kWhiteBarDistanceTop -50
#define kWhiteBarAlpha 0.1f
#define kWhiteBarDelayMin 2.0f
#define kWhiteBarDelayMax 3.0f

//database
#define kDatabaseBundle @"database.sqlite"

#define kBitcoinAddress @"???"

//blocks
enum {
    kCoinTypeNone= -1,

    kCoinTypeDefault = 0,
    kCoinTypeMine,
    kCoinTypeBitcoin,
    kCoinTypeYoshi,
    kCoinTypeSonic,
    kCoinTypeGameboy,
    kCoinTypeTA,
    kCoinTypeEmoji,
    kCoinTypeSoccer,
    kCoinTypeValentine,
    kCoinTypePatrick,
    kCoinTypeZelda,
    kCoinTypeFlap,
    kCoinTypePew,

    kCoinTypeMario, //VIP
    kCoinTypeBrain, //11



    //coming soon?
    kCoinTypeMario2, //secret?
    kCoinTypeComingSoon, //VIP

    kNumSkins
};
//#define kCoinTypeVIP kCoinTypeMario
enum {
  //new
  kCoinTypeOlympic,
  kCoinTypeDog,

    //disabled
        //kCoinTypeTrump,
    kCoinTypeZoella = 10000,
    kCoinTypeFlat,
    kCoinTypeMontreal,
    kCoinTypeLaundro,
    kCoinTypeCandy,
    kCoinTypeXmas,
    kCoinTypeFarm,
    kCoinTypeCoookie,
    kCoinType80s,
    kCoinTypeNyan,
    kCoinTypeMac,
    kCoinTypeMega,
    kCoinTypeMetal,
};

//types
//http://wow.gamepedia.com/Uncommon

enum {
    kCoinTypeCommon = 0,
    kCoinTypeUncommon,
    kCoinTypeRare,
    kCoinTypeEpic,
    kCoinTypeLegendary,

    kNumTypes
};

#define kFeedbackType FeedbackType_Impact_Light
/*
 typedef enum {
 FeedbackType_Selection,
 FeedbackType_Impact_Light,
 FeedbackType_Impact_Medium,
 FeedbackType_Impact_Heavy,
 FeedbackType_Notification_Success,
 FeedbackType_Notification_Warning,
 FeedbackType_Notification_Error
 }FeedbackType;
 
 */


#define kConfettiShort 0.2f
#define kConfettiBirthRateGame 150
#define kConfettiBirthRateTitle 50
#define kConfettiThanksDuration 2.0f

#define kCommercialDuration 4
#define kCommercialTag 4726

#define kCommercialName @"commercial1.mp4"

// ****** Achievements ***

//Achievements ready:
#define kAchievement_100coins @"100coins" //Good start!, Obtained 100 Coins.
#define kAchievement_1000coins @"1000coins" //1K, Obtained 1000 Coins.
#define kAchievement_10000coins @"10000coins" //10K, Obtained 10000 Coins.
#define kAchievement_100000coins @"100000coins" //100K, Obtained 100000 Coins.
#define kAchievement_1000000coins @"1000000coins" //1M, Obtained 1000000 Coins.
#define kAchievement_314coins @"314coins" //Hmmm, pie!, Obtained 314 Coins.
#define kAchievement_9000coins @"9000coins" //It's over 9000!!!, Obtained 9000 Coins.

#define kAchievement_vip @"vip" //VIP, Obtained VIP.
#define kAchievement_ending @"ending" //You complete me! Completed the game.
#define kAchievement_cheat @"cheat" //It's a secret to everybody, Viewed Cheats screen.
#define kAchievement_credits @"credits" //Credit check, Viewed Credits screen.
#define kAchievement_coffee @"coffee" //Cup of joe, Bought 1 coffee.
#define kAchievement_coffee2 @"coffee2" //Double Double!, Bought 2 coffees.
#define kAchievement_coffee3 @"coffee3" //Coffee Snob!, Bought 3 coffees.

#define kAchievement_share @"share" //Sharing is caring, Shared the game.
#define kAchievement_social @"social" //Just visiting, Visited social media.
#define kAchievement_rate @"rate" //Best game ever!, Rated the game.

#define kAchievement_combo1 @"combo1" //Master Combo, Achieved a 20-hit combo.
#define kAchievement_combo2 @"combo2" //Killer Combo!, Achieved a 50-hit combo.
#define kAchievement_combo3 @"combo3" //Ultra Combo!, Achieved a 100-hit combo.

#define kAchievement_powerupShield @"powerupShield" //Shields up!, Obtained a Shield Power-up.
#define kAchievement_powerupStar @"powerupStar" //Star Power! Obtained a Star Power-up.
#define kAchievement_powerupBomb @"powerupBomb" //Bombs away!, Obtained a Bomb Power-up.
#define kAchievement_powerupHeart @"powerupHeart" //Follow your heart!, Obtained a Heart Power-up.
#define kAchievement_powerupPotion @"powerupPotion" //Love potion!, Obtained a Potion Power-up.

#define kAchievement_ink @"ink" //Splat!
#define kAchievement_auto @"auto" //
#define kAchievement_shrink @"shrink" //
#define kAchievement_grow @"grow" //
#define kAchievement_weak @"weak" //
#define kAchievement_doubler @"doubler" //

#define kAchievement_weakSpot @"weakSpot" //Bullseye, Tapped on a Weak Spot.
#define kAchievement_toastie @"toastie" //Secret..., Found a Secret.

#define kAchievement_ouchEnemy @"ouchEnemy" //Ouch! Got hurt by an Ememy.
#define kAchievement_ouchSpike @"ouchSpike" //Spiky! Got hurt by a Spike.
#define kAchievement_ouchTime @"ouchTime" //Outta time! Got hurt by a time out.
#define kAchievement_die @"die" //You have died!, Died for the first time.
#define kAchievement_lava @"lava" //You have died!, Died for the first time.




//Achievements to plug in game:
//[kAppDelegate reportAchievement:kName];


//Achievements to add to itunes:


//Achievements: To Do:

//buffs
//#define kAchievement_name @"name" //description!

//more powerups
//each skin unlocked?
//each world finished? kLevelMax 12




// ****** Achievements end ***





#define kGoogleAnalyticsTrackingID @"???"
#define kGoogleAdMobId @"ca-app-???"

//wobble
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)
#define WOBBLE_DEGREES 1
#define WOBBLE_SPEED 0.2 //0.25

#define kCoinAnimRate 0.1f

#define kDefaultVolumeSound 0.5f
#define kDefaultVolumeMusic 0.2f
#define kVoiceEnabled YES
#define kMusicVolumeMultiplier 0.6f
#define kMusicEnabled YES
#define kMusicNameOptions @"musicOptions.mp3"
#define kMusicNameCheat @"musicCheat.mp3"
#define kMusicNameCastle @"musicCastle.mp3"
#define kMusicNameLast @"musicLast.mp3"
#define kMusicNameDefault @"musicDefault.mp3"
#define kMusicNameLoading @"musicLoading.mp3"
#define kMusicNameLevelup @"musicLevelup.mp3"
#define kMusicNameSad @"musicSad.mp3"
#define kMusicNameFever @"musicFever1.mp3"
#define kMusicNameBuff @"musicFever1.mp3"
#define kMusicNameBuffBad @"musicFever2.mp3"

#define kComboFadeIn 0.3f
#define kComboFadeOut 0.5f
#define kComboMinCount 10

#define kComboLevel1 10
#define kComboLevel2 20
#define kComboLevel3 30

#define kPhysicsWorldSpeed 0.9999f //1.0f //1.5f?
#define kChartboostAppID @"???"
#define kChartboostAppSig @"???"

#define zLayerBG 1
#define zLayerUI 1
#define zLayerGame 1

#define kPrefGroup @"group.skyriser.coinblock"
#define kPrefGroupCommon @"group.skyriser.coinblock"

#define kTitleRandomAnimationSpeed 0.15f
#define kGameCenterEnabled YES
#define kKTPlayEnabled NO
#define kHudWaitDuration 1.0f
#define kForcePauseDelay 0.01f
#define kPauseIdleTime 60.0f //in seconds
#define kPauseBlurDuration 0.1f
#define kBlockOffset 80 //60
#define kDefaultCoins 8
#define kIAPNumCoins 8
//#define kIAPNum 4
#define kFadeDelay 0.0f
#define kFadeOutDelay 0.0f //0.1f

//#define kFadeDuration 0.5f
#define kFadeDuration (kAppDelegate.fadingWhite?0.5f:0.5f)
#define kCurtainAnimDuration 0.5f //kFadeDuration
#define kDelayUnlockAfterURL 1.0f

#define kWaitForGameCenterDelay 1.5f
#define kFadeColor RGBA(0,0,0, 0.9f) //RGBA(0,0,0, 1.0f) //RGBA(0,255,0, 1.0f)
#define kYellowTextColor RGB(255,255,255)
#define kGreenTextColor RGB(114,190,137)

//#define kTextColor1 @"#984c05" //orange dark
#define kTextColor1 @"#e0822a" //orange
#define kTextColor2 @"#c60c0c" //red

//#define kRedBlockFlash [UIColor colorWithHex:0xfb27a9] //pink
#define kRedBlockFlash [UIColor colorWithHex:0xfb2727] //red
#define kRedBlockFlash2 [UIColor colorWithHex:0x18f8c1] //turcoise

//#define kYellowTextColor RGB(247,216,1)
#define kRedNintendoColor RGB(236,27,46)
#define kYellowTextColorSelected RGB(170,149,7)
#define kTextShadowColor RGBA(0.0f,0.0f,0.0f, 0.6f)
#define kAlertStyle SIAlertViewTransitionStyleFade //SIAlertViewTransitionStyleDropDown //SIAlertViewTransitionStyleSlideFromTop
#define kTimerDelay 1.0f
#define kScoreMax (999999)
#define kLevelMax 12 //((kCoinTypeBrain * 2) + 1) //(kCoinTypeBrain+1) //12 // (64) //(99) //because alternate potion

#define kStoryLevel1 4
#define kStoryLevel2 8
//#define kStoryLevel3 10

#define kFireBallMax (50) //(99)
#define kLeaderboardID @"topscore"
#define kButtonSelectedAlpha 0.5f
#define kShowWhiteBar YES //YES
#define kShowArrowLevelMax 2
#define kTutoHideDuration 0.3f //0.5f
#define kNumMiniShines 12

#define kStoryboard [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]

#define kVCRDelayIn 0.2f
#define kVCRDelayOut 0.1f
#define kVCRDelayWait 0.05f
#define kVCRAlpha 0.3f
#define kVCRAlphaPaused 0.9f
#define kVCRAnimDuration 0.2f
#define kVCRAnimEnabled NO
#define kVCRAlertEnabled NO
#define kVCREnabled NO //YES

//cheats
#define kPewDebug NO //YES //more click mult
#define kDisableSave NO //NO
#define kCheatOnLoad nil //@"godmode" //nil


#define kResumeNotification @"kResumeNotification"
#define kResumeNotificationSettings @"kResumeNotificationSettings"
#define kResumeNotificationStore @"kResumeNotificationStore"
#define kLoadingDoneNotifications @"kLoadingDoneNotifications"
#define kNotificationLevel 2
#define kReachabilityNotificationOnline @"kReachabilityNotificationOnline"
#define kReachabilityNotificationOffline @"kReachabilityNotificationOffline"


#define kFontSizeRegular 50.0f
#define kMaxLifes 5

#define kPotionStart 3 //5 //0, 5
#define kPotionReward 3 //5 //1

#define kMaxPotions 99
#define kPotionImageName @"potion2"
#define kPotionEmptyImageName @"potion2Empty"
#define kPotionScale 1.0f


#define kRewardScreen @"kRewardDefault"
#define kRewardRefill @"kRewardBoostRefill"
#define kRewardRefillPotions @"kRewardBoostRefillPotions"
#define kRewardUnlockSkinTitle @"kRewardSkinTitle"
#define kRewardUnlockSkinStore @"kRewardSkinStore"
#define kRewardUnlockPowerUp @"kRewardPowerUp"

//#define kBuffDuration 10 //30.0f
//#define kBuffDurationBad 10.0f
#define kBuffDurationMax 60

#define kRewindScale 0.45f

#define kBlockLockedAlpha 0.5f

#define kFontScale 1.7f
#define kFontName @"OrangeKid-Regular"
#define kFontNamePlus @"JoystixMonospace-Regular"
#define kFontNameBlocky  @"Gubblebum-BlacknBlocky"
//#define kFontVCR @"VCROSDMono"

//#define kURLTwitterApp @"twitter:///user?screen_name=CoinBlockApp"
//#define kURLTwitterApp @"twitter://search?query=%23coinblock"
//#define kURLTwitter @"https://twitter.com/hashtag/coinblock"
#define kURLTwitterApp @"twitter://search?query=%23coinyblock"
#define kURLTwitter @"https://twitter.com/hashtag/coinyblock"
//#define kURLMailing @"http://eepurl.com/dhl5nH"
#define kURLMailing @"http://coinyblock.com/mailinglist"
#define kNumAppsDefault 0

//GamegirlClassic
//Super-Mario-Bros.-3
//HelveticaNeue-Thin
//BulkyPixels
//SnareDrum-One-NBP
//JoystixMonospace-Regular
//OrangeKid-Regular

#define kFontNameScene @"font11"

//font9
//font10
//font11

#define kToucheFireballDelay 2.0f
#define kFireballIntervalNeeded 10.0f
#define kSpikeIntervalNeeded 12.0f
#define kNumFireballs 32
#define kNumHearts 3
#define kFlashArrowsInterval 0.25f
#define kIntervalTooSoon (2*60.0f) //seconds, 2 minutes

#define kBatSlowdownMult 0.1f //0.5f
#define kBatSlowdownDuration 5.0f
#define kBatSlowdownTransition 0.3f //1.0f

#define kHeartLose 2 //1
#define kHeartGain 2 //1
#define kHeartFullDefault 6
#define kHeartFull ([kAppDelegate isPremium] ? 8 : 6)
#define kHeartHealTime 5 //5 //15 // minute per heart
#define kHeartScale 0.9f
#define kHeartLevelLose 2
//#define kHeartHideDuration 0.4f //0.3f

#define kiPhoneXScaleX (375.0f/320.0f)
#define kiPhoneXWidthDIff (375.0f-320.0f)
#define kiPhoneXScaleY kiPhoneXScaleX //(812.0f/568.0f)
#define kiPhoneXTopSpace 34
#define kiPhoneXBottomSpace 34

//#define kiPadScaleX (768.0f/320.0f)
#define kiPadScaleX (1024.0f/480.0f)
#define kiPadScaleY kiPadScaleX

#define kFlashColorWhite RGBA(255,255,255, 0.6f) //touched star, touched heart
#define kFlashColorWhiteFull RGBA(255,255,255, 1.0f) //win explosion
#define kFlashColorWhite2 RGBA(255,255,255, 0.1f) //show star, heart
#define kFlashColorRed RGBA(255,0,0, 0.6f) //touch fireball, touch spike
#define kFlashColorYellow RGBA(255,255,0, 0.1f) //show fireball
#define kHeartRedColor [UIColor colorWithHex:0xc62f18]

#define kBarShakePercent 0.9f

#define kStatusBarOffset 20 //0
#define fireWorksSpeed 0.1f //0.1f
#define kRandomSpeedIncrease 10
#define kParticleDelay 0.3f
#define kParticleDistance 10
#define kParticleDuration 0.8f
#define kParticleAutoDelete 3.0f

#define kHidePowerupDelay 8.0f
#define kStartFlashPowerUpDelay 3.0f
#define kPowerupMinDelay 15 //10 //30
#define kHideSquareDelay 10.0f
#define kStartFlashSquareDelay 3.0f

#define kWorldTime 200
#define kWorldTimePerLevel 50
#define kTimeMax 10 //299 //999
#define kWorldTimeLow1 6 //kTimeMax-60
#define kWorldTimeLow2 3 //kTimeMax-30
#define kWorldTimeReset kTimeMax //kTimeMax-30
#define kWorldTimeReset4 kWorldTimeLow2+1 //(kWorldTimeLow2+1) //x-4 faster

#define kWorldTimeInterval 1.0f //0.8f
#define kWorldTimeIntervalFlash 0.25f


#define kStarDistanceTooSmall 100

#define kCloudDuration 20
#define kCloudInterval 10
#define kCheatButtonInterval 2
#define kCloudWidth 240
#define kCloudY 100

#define kCoinAlphaFall 0.3f //0.6f
#define kCoinAlphaUp 0.5f
#define kCoinSpinScaleMin -1.0f //0.2f

#define kCoinSpinScaleDuration 0.4f //0.2f
#define kRewindSpinScaleDuration 0.6f //0.2f

#define kSoundVersion 209

#define kLoopLoadInBg YES

#define kSplashSound @"splash6.caf" //@"splash7.caf"

#define kClickSound @"click5.caf" //@"click4.caf"
#define kCurtainSound @"curtain2.caf"
#define kCurtain2Sound @"curtain.caf"
#define kScreamSound @"WilhelmScream.caf"
#define kRefillSound @"refill.caf"
#define kUnlockSound @"whistle3.caf"
#define kUnlockSound2 @"kiss.caf"
#define kClickSound @"click5.caf" //@"click4.caf"
#define kCountdownSound @"heart_low.caf"
#define kForceLoadSounds NO //NO

#define kCloudName @"cloud4"
#define kCloudAlpha 0.2f
#define kCloudAlphaFront 0.1f

#define kLoadViewsNeeded 9 //numview
#define kLoadForceDoneDelay 15.0f;
#define kLoadForceDoneConvertDelay 60.0f
#define kLoadDelay 3.0f //2.0f  //splash longer
#define kForceLoadDelay 2.0f //2.0f //before switch
#define kMinLoadTime 5.0f //before switch, since launch
#define kForceLoadDelayUpdate 2.0 //fake download update?
#define kWinDelay 4.0f //3.0f
#define kIdleSeconds 60.0f //10.0f

#define kImageSquareAlpha 0.8f

#define kAlertButtonClickDelay 0.5f

//#define kEmptyLeftMin 20
//#define kEmptyRandom 10

#define kBannerEnabled 1
#define kBannerIPadEnabled 1 //1

#define kHeyZapID @"???"
#define kPreloadAds NO //YES

#define kBannerUpdateMin 30 //seconds
#define kCopyrightYear 2018
#define kiRateEnabled NO
#define kPlusRandom 25
#define kPlusDuration 2.0f //1.5f
#define kAppSinceLastMessage 5 //10
#define kShowFPS YES //YES
#define kEnableEmiters YES //NO
#define kBlockGrowDuration 0.5f //0.5f

#define kHideArrowDelay 5.0f

#define kNum1up 128 //64 //100 //200
#define kNum1upIncStart 128 //64 //32 32 //100 //100
#define kNum1upIncInc 128 //64 //32 //100 //50

#define k1upMult 1.5f //1.04f
#define kWaitMinutes 2
#define kRefillTime 10 //60 //1h //10m for each 1/2
#define kShowBigAdOdds 50 //%min
#define kRandomBgOdds 50 //%
#define kEnergyAutoInc 1
#define kLaunchCountAds 0
#define kLaunchDaysAds 0
#define kTimerDelayRandomEvent 5.0f; //10.0f
#define kTimerDelayWeak 0.2f; 1.0f; //10.0f
#define kTimerDelayAuto 0.2f; //10.0f
#define kTimerDelayAdToggle 30.0f
#define kTimerDelayFadeBg 0.5f
#define kBackgroundFadeDuration 2.0f //0.5f
#define kIRatePromptCount 1
#define kFireballAlphaDisabled 0.4f
#define kFireballAlphaDisabled2 0.8f
#define kFireballAlphaTimerInterval 0.2f //0.12f //0.15f
#define kShowHandAgainDelay 3*60.0f //seconds
#define kShowInterstitial YES //YES

#define kNumBackgrounds 38
#define kBackgroundVolcano @"background10"

#define kAppStoreURL @"http://itunes.apple.com/app/id914537554"
#define kAppStoreAppID "914537554"

#define kKVO_Volume @"outputVolume"

#define kNumBlockExplosions 20

#define kComboFailDelay 0.3f //0.4f
#define kActionKeyComboFail @"comboFail"

#define kChestLevel 2
#define kChestIntervalNeeded 30*60 //30m, 15m premium
//#define kChestIntervalNeeded 2*60*60 //2h
