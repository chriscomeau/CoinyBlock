//
//  CBGameScene.m
//  CoinBlock
//
//  Created by Chris Comeau on 2014-08-30.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "CBGameScene.h"
#import "GPUImage.h"
#import "SKLabelOutlineNode.h"
#import "SKNode+Extra.h"
#import "SKSpriteNode+Extra.h"
#import "UAObfuscatedString.h"

#define kPowerUpNameHeart @"powerup_heartAppear"
#define kPowerUpNameStar @"powerup_starAppear"
#define kPowerUpNameBomb @"powerup_bombAppear"
#define kPowerUpNamePotion @"powerup_potionAppear"
#define kPowerUpNameDoubler @"powerup_doublerAppear"
#define kPowerUpNameAuto @"powerup_autoAppear"
#define kPowerUpNameWeak @"powerup_weakAppear"
#define kPowerUpNameShield @"powerup_shieldAppear"
#define kPowerUpNameGrow @"powerup_growAppear"
#define kPowerUpNameShrink @"powerup_shrinkAppear"
#define kPowerUpNameInk @"powerup_inkAppear"

typedef enum {
    ePowerupPositionNone = -1,
    ePowerupPositionBottomLeft = 0,
    ePowerupPositionBottomRight = 1,
    ePowerupPositionTopLeft = 2,
    ePowerupPositionTopRight = 3,

    ePowerupPositionBottomCenter = 4,
} PowerupDirection;

@interface CBGameScene ()
@property (nonatomic, strong) SKSpriteNode *block;
//@property (nonatomic, strong) SKSpriteNode *door;
@property (nonatomic, strong) SKSpriteNode *menuButton;

@property (nonatomic) BOOL squareImageReady;
@property (nonatomic) BOOL bgFadeState;
@property (nonatomic) double beforeRewindClickCount;
@property (nonatomic) BOOL winning;
@property (nonatomic) double weakSpotMult;
@property (nonatomic) BOOL skipTime;
@property (nonatomic) BOOL clickedDoor;
@property (nonatomic) BOOL colorizeBlockToggle;
@property (nonatomic) BOOL sharing;
@property (nonatomic) BOOL navPlusAlternate;

@property (nonatomic) BOOL flashFireballFlag;
@property (nonatomic) BOOL hurtLavaVisible;

@property (nonatomic) double lastTick;
@property (nonatomic) int lastSkin;
@property (nonatomic) int spikePosition;
@property (nonatomic) int lastToastie;
@property (nonatomic) int comboCount;
//@property (nonatomic) int currentPowerUp;
@property (nonatomic) int currentBlockFrame;
@property (nonatomic) int cloudCount;
@property (nonatomic) BOOL comboRecord;
@property (nonatomic) BOOL blockDisabled;
@property (nonatomic) int countSinceLastSecond;
@property (nonatomic) CGPoint lastClickPosition;
@property (nonatomic) CGFloat blockScale;

@property (nonatomic, strong) NSMutableArray *clickArray;
@property (nonatomic, strong) NSMutableArray *bgArray;
@property (nonatomic, strong) NSMutableArray *bgArray2;
@property (nonatomic, strong) SKTexture *bgCastle;
@property (nonatomic, strong) SKTexture *bgCastle2;
@property (nonatomic, strong) SKTexture *bgSpecial;
@property (nonatomic, strong) SKTexture *lastBGTexture;
@property (nonatomic, strong) SKLabelOutlineNode *countlabel;

@property (nonatomic, strong) SKLabelOutlineNode *countlabelX;
@property (nonatomic, strong) SKSpriteNode *countCoin;

@property (nonatomic, strong) SKLabelOutlineNode *levelLabel;
@property (nonatomic, strong) SKLabelOutlineNode *speedLabel;
@property (nonatomic, strong) SKLabelOutlineNode *multLabel;
@property (nonatomic, strong) SKLabelOutlineNode *comboLabel;
@property (nonatomic, strong) SKLabelOutlineNode *comboLabelScore;
@property (nonatomic, strong) SKLabelOutlineNode *worldNameLabel;
@property (nonatomic, strong) SKLabelOutlineNode *timeLabel;
@property (nonatomic, strong) SKLabelOutlineNode *numFireballLabel;
@property (nonatomic, strong) SKLabelOutlineNode *barLabel;

@property (nonatomic, strong) SKSpriteNode *backTop;
@property (nonatomic, strong) SKSpriteNode *backBottom;

@property (nonatomic, strong) SKSpriteNode *bar;
@property (nonatomic, strong) SKSpriteNode *barFill;
@property (nonatomic, strong) SKSpriteNode *barBack;
@property (nonatomic, strong) SKSpriteNode *barPill;
@property (nonatomic, strong) SKSpriteNode *barIcon;
@property (nonatomic, strong) SKSpriteNode *barIconRewind;
@property (nonatomic, strong) SKSpriteNode *barHelp;
@property (nonatomic, strong) SKSpriteNode *barCastle;
@property (nonatomic, strong) SKSpriteNode *tutoArrow;
@property (nonatomic, strong) SKSpriteNode *tutoArrowSquare;
@property (nonatomic, strong) SKSpriteNode *tutoArrowPotion;
@property (nonatomic, strong) SKSpriteNode *redArrow;
@property (nonatomic, strong) SKSpriteNode *toastie;
@property (nonatomic, strong) SKSpriteNode *clock;
@property (nonatomic, strong) SKSpriteNode *rec;
@property (nonatomic, strong) SKSpriteNode *comboArrow1;
@property (nonatomic, strong) SKSpriteNode *comboArrow2;
@property (nonatomic, strong) SKSpriteNode *comboArrow3;
@property (nonatomic, strong) SKSpriteNode *winKey;
@property (nonatomic, strong) SKSpriteNode *winKeyShine;
@property (nonatomic, strong) SKSpriteNode *rainbow;

@property (nonatomic, strong) SKSpriteNode *navSquare;
@property (nonatomic, strong) SKSpriteNode *imageSquare;
@property (nonatomic, strong) SKSpriteNode *navPlus;
@property (nonatomic, strong) SKSpriteNode *navOverlay;
@property (nonatomic, strong) SKSpriteNode *navLock;
@property (nonatomic, strong) SKSpriteNode *heartPlus;

@property (nonatomic, strong) SKSpriteNode *potion;
@property (nonatomic, strong) SKLabelOutlineNode *potionLabel;
@property (nonatomic, strong) SKSpriteNode *potionFall;
@property (nonatomic, strong) SKSpriteNode *potionHeart1;
@property (nonatomic, strong) SKSpriteNode *potionPlus;
@property (nonatomic, strong) SKSpriteNode *weakSpot;
@property (nonatomic, strong) SKSpriteNode *weakSpotExplosion;

@property (nonatomic, strong) SKSpriteNode *heart1;
@property (nonatomic, strong) SKSpriteNode *heart2;
@property (nonatomic, strong) SKSpriteNode *heart3;
@property (nonatomic, strong) SKSpriteNode *heart4;
@property (nonatomic, strong) SKSpriteNode *heartFall;
@property (nonatomic, strong) SKSpriteNode *bombExplosion;

@property (nonatomic, strong) SKSpriteNode *buff;
@property (nonatomic, strong) SKSpriteNode *buffSquare;
@property (nonatomic, strong) SKSpriteNode *buffShine;
@property (nonatomic, strong) SKLabelOutlineNode *buffLabelTimer;
@property (nonatomic, strong) SKLabelOutlineNode *buffLabelName;
@property (nonatomic, strong) SKSpriteNode *buffBorder;
@property (nonatomic, strong) SKSpriteNode *buffBg;

/*@property (nonatomic, strong) SKSpriteNode *redCoin1;
@property (nonatomic, strong) SKSpriteNode *redCoin2;
@property (nonatomic, strong) SKSpriteNode *redCoin3;
@property (nonatomic, strong) SKSpriteNode *redCoin4;
@property (nonatomic, strong) SKSpriteNode *redCoin5;*/

@property (nonatomic, strong) SKLightNode* light;

@property (nonatomic, strong) NSMutableArray *powerupArray;
@property (nonatomic, strong) NSMutableArray *miniShineArray;
@property (nonatomic, strong) NSMutableArray *fireballAppearArray;
@property (nonatomic, strong) NSMutableArray *cloudArray;

@property (nonatomic, strong) SKSpriteNode *touch;
@property (nonatomic, strong) SKSpriteNode *touchCombo;
@property (nonatomic, strong) SKSpriteNode *touchFireball;
@property (nonatomic, strong) SKSpriteNode *touchStar;
@property (nonatomic, strong) SKSpriteNode *fireballX;

@property (nonatomic, strong) SKSpriteNode *bgOverlay;
@property (nonatomic, strong) SKSpriteNode *bgImage;
@property (nonatomic, strong) SKSpriteNode *bgImage2;
@property (nonatomic, strong) SKSpriteNode *ray1;
//@property (nonatomic, strong) SKSpriteNode *ray2;
//@property (nonatomic, strong) SKSpriteNode *ray3;
//@property (nonatomic, strong) SKSpriteNode *ray4;
@property (nonatomic, strong) SKSpriteNode *rayCombo; //comboshine
@property (nonatomic, strong) SKSpriteNode *fireworks1;
@property (nonatomic, strong) SKSpriteNode *fireworks2;
@property (nonatomic, strong) SKSpriteNode *fireworks3;
@property (nonatomic, strong) NSMutableArray *explosionsArray;
@property (nonatomic, strong) SKSpriteNode *warning;
@property (nonatomic, strong) SKSpriteNode *ink;
@property (nonatomic, strong) SKSpriteNode *spike;
@property (nonatomic, strong) SKSpriteNode *spikeSmall;
@property (nonatomic, strong) SKLabelNode *bigLevelLabel2;
@property (nonatomic, strong) SKLabelNode *bigLevelLabel2Shadow;

@property (nonatomic, strong) SKSpriteNode *flash;
@property (nonatomic, strong) SKSpriteNode *flash2;

@property (nonatomic, strong) SKSpriteNode *scanline;
@property (nonatomic, strong) SKSpriteNode *whiteBar;

@property (strong, nonatomic) NSTimer *timerRandomEvent;
@property (strong, nonatomic) NSTimer *timerHelpBubble;
@property (strong, nonatomic) NSTimer *timerLowHealth;
@property (strong, nonatomic) NSTimer *timerBgFade;

@property (strong, nonatomic) NSDate *lastClickFireballDate;
@property (strong, nonatomic) NSDate *lastPowerupDate;
@property (strong, nonatomic) NSDate *lastSquareDate;

@property (nonatomic) double lastPowerupDateCount;
@property (strong, nonatomic) NSDate *lastFireballDate;
@property (strong, nonatomic) NSDate *lastSpikeDate;

@property (strong, nonatomic) FISound *soundCoin;
@property (strong, nonatomic) FISound *soundCoin2;
@property (strong, nonatomic) FISound *soundCoin3;
@property (strong, nonatomic) FISound *soundBump;
@property (strong, nonatomic) FISound *soundHelp;
@property (strong, nonatomic) FISound *sound1up;
@property (strong, nonatomic) FISound *soundClap;
@property (strong, nonatomic) FISound *soundTada;
@property (strong, nonatomic) FISound *soundExplosion1;
@property (strong, nonatomic) FISound *soundExplosion2;
@property (strong, nonatomic) FISound *soundWhistle;
@property (strong, nonatomic) FISound *soundStarAppear;
@property (strong, nonatomic) FISound *soundStarClick;
@property (strong, nonatomic) FISound *soundStarClick2;
@property (strong, nonatomic) FISound *soundSpikeAppear;
@property (strong, nonatomic) FISound *soundSpikeAppearPew;
@property (strong, nonatomic) FISound *soundSpikeAppearMega;
@property (strong, nonatomic) FISound *soundSpikeAppearSword;
@property (strong, nonatomic) FISound *soundSpikeAppearChain;
@property (strong, nonatomic) FISound *soundSpikeAppearGradius;
@property (strong, nonatomic) FISound *soundSpikeAppear2Mega;
@property (strong, nonatomic) FISound *soundFireballAppear;
@property (strong, nonatomic) FISound *soundFireballHide;
@property (strong, nonatomic) FISound *soundFireballClick;
@property (strong, nonatomic) FISound *soundFireballClick2;
@property (strong, nonatomic) FISound *soundWrong;
@property (strong, nonatomic) FISound *soundGasp;
@property (strong, nonatomic) FISound *soundLowBeep;
@property (strong, nonatomic) FISound *soundHashtag;
@property (strong, nonatomic) FISound *soundFireworks;
@property (strong, nonatomic) FISound *soundChorus;
@property (strong, nonatomic) FISound *soundSpin;
@property (strong, nonatomic) FISound *soundWarning;
@property (strong, nonatomic) FISound *soundRewind;
@property (strong, nonatomic) FISound *soundLowHeart;
@property (strong, nonatomic) FISound *soundHurt;
@property (strong, nonatomic) FISound *soundDeath;
@property (strong, nonatomic) FISound *soundRefill;
@property (strong, nonatomic) FISound *soundPotion;
@property (strong, nonatomic) FISound *soundPotion2;
@property (strong, nonatomic) FISound *soundSigh;
@property (strong, nonatomic) FISound *soundClock;
@property (strong, nonatomic) FISound *soundClick;
@property (strong, nonatomic) FISound *soundToastieClick;
@property (strong, nonatomic) FISound *soundPan1;
@property (strong, nonatomic) FISound *soundPan2;
@property (strong, nonatomic) FISound *soundPan3;
@property (strong, nonatomic) FISound *soundToastie;
@property (strong, nonatomic) FISound *soundToastieEagle;
@property (strong, nonatomic) FISound *soundToastiePew;
@property (strong, nonatomic) FISound *soundToastiePortal;
@property (strong, nonatomic) FISound *soundToastieTrump;
@property (strong, nonatomic) FISound *soundComboRise;
@property (strong, nonatomic) FISound *soundBell;
@property (strong, nonatomic) FISound *soundBossHit;
@property (strong, nonatomic) FISound *soundBossDie;
@property (strong, nonatomic) FISound *soundWeakSpot;
@property (strong, nonatomic) FISound *soundWeakSpot2;
@property (strong, nonatomic) FISound *soundWeakSpotFinish;
@property (strong, nonatomic) FISound *soundBuffShield;
@property (strong, nonatomic) FISound *soundBuffGrow;
@property (strong, nonatomic) FISound *soundBuffShrink;
@property (strong, nonatomic) FISound *soundBuffInk;
@property (strong, nonatomic) FISound *soundBuffStar;
@property (strong, nonatomic) FISound *soundBuffDoubler;
@property (strong, nonatomic) FISound *soundBuffAuto;
//@property (strong, nonatomic) FISound *soundSecret;
@property (strong, nonatomic) FISound *soundKey1;
@property (strong, nonatomic) FISound *buffRepeatSound;
@property (strong, nonatomic) FISound *soundRubber;
@property (strong, nonatomic) FISound *soundLava;

@property (strong, nonatomic) FISound *soundAmazing;
@property (strong, nonatomic) FISound *soundWow;
@property (strong, nonatomic) FISound *soundPowerupAuto;
@property (strong, nonatomic) FISound *soundPowerupBomb;
@property (strong, nonatomic) FISound *soundPowerupGrow;
@property (strong, nonatomic) FISound *soundPowerupShrink;
@property (strong, nonatomic) FISound *soundPowerupStar;
@property (strong, nonatomic) FISound *soundPowerupInk;

@property (strong, nonatomic) FISound *soundPowerupPotion;
@property (strong, nonatomic) FISound *soundPowerupShield;
@property (strong, nonatomic) FISound *soundPowerupDoubler;
@property (strong, nonatomic) FISound *soundPowerupWeak;
@property (strong, nonatomic) FISound *soundPowerupHeart;

@property (strong, nonatomic) NSMutableArray *soundArray;

@property (strong, nonatomic) SKSpriteNode *pauseView;

@end


@implementation CBGameScene

static const uint8_t ballCategory = 1;
static const uint8_t wallCategory = 2;
//static const uint8_t cloudCategory = 2;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [self startGame];
    }

    return self;
}

-(void)startGame {

    [self removeAllChildren];

    //__weak typeof(self) weakSelf = self;

    self.lastSkin = -1;
    self.lastToastie = -1;
    self.weakSpotMult = 1.0f;

    self.blockScale = [kHelpers isIphone4Size] ? 0.7f : 1.0f;

    self.navPlusAlternate = NO;

    NSDate *startDate = [NSDate date];
    int interval = ([startDate timeIntervalSinceNow]) * 1000.0f;
    interval = abs(interval);

    //startDate = [NSDate date];
    //Log(@"CBGameScene: interval 1: %d", interval);

    //last click, skip for auto buff?
    //if(kAppDelegate.currentBuff != kBuffTypeAuto)
      self.lastTick = [[NSDate date] timeIntervalSince1970];;

    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = wallCategory;

    //test
    //self.alpha = 0.5f;

    self.backgroundColor = RGB(0,0,0);
    self.clickArray = [NSMutableArray array];
    self.bgArray = [NSMutableArray array];
    self.bgArray2 = [NSMutableArray array];
    self.lastClickDate = [NSDate date];

    //sounds
    [self loadSounds];

    //blur, disable
    /*CIFilter *pixellateFilter;
    pixellateFilter = [CIFilter filterWithName:@"CIPixellate"];
    [pixellateFilter setDefaults];
    //[pixellateFilter setValue:[NSNumber numberWithDouble:10.0f] forKey:@"inputScale"];
    [self setShouldCenterFilter:YES];
    //[self setFilter:pixellateFilter];*/

    //enable effects
    [self setShouldEnableEffects:NO]; //NO

    ///UIImage *blur = [self getBluredScreenshot];
    //self.pauseView = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:blur]];
    //self.pauseView.alpha = 0.0f;
    //[self addChild:self.pauseView];

    interval = ([startDate timeIntervalSinceNow]) * 1000.0f;
    interval = abs(interval);
    //startDate = [NSDate date];
    //Log(@"CBGameScene: interval 2: %d", interval);


    //preload assets
    SKAction *tempAnim  =nil;
    SKLabelNode *tempLabel  =nil;

    [self updateBackgrounds];

    NSString *coinName = [CBSkinManager getCoinImageName];

    tempAnim = [SKAction animateWithTextures:@[
                                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]],
                                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame2", coinName]],
                                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame3", coinName]],
                                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame4", coinName]],
                                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]]]
                                timePerFrame:0.1];

    //preload fonts
    tempLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];
    tempLabel = [SKLabelNode labelNodeWithFontNamed:kFontNamePlus];

    //notify
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];


    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationEnteredBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];


    //bg
    //NSString *bgName = nil;
    SKTexture *bgTexture = nil;
    if(kAppDelegate.subLevel == 4) {
        //bgName = kBackgroundVolcano;
        bgTexture = self.bgCastle;
    }
    else {
        bgTexture = [self getRandomBackground];
    }

    //force
    if((int)kAppDelegate.clickCount == 0) {
        //first time
        //bgName = @"background1";
        bgTexture = [self.bgArray firstObject];;

    }

    CGFloat bgIPadScale = 1.2f; //1.2f
    //self.lastBgName = bgName;
    self.lastBGTexture = nil;
    self.bgImage = [SKSpriteNode spriteNodeWithTexture:bgTexture];
    self.bgImage.name = @"background";
    self.bgImage.zPosition = 1;
    self.bgImage.alpha = 1.0f;
    if([kHelpers isIphoneX])
    {
        self.bgImage.xScale = 1.0f;
        self.bgImage.yScale = (812.0f/568.0f);
    }
    else if([kHelpers isIpad])
    {
        self.bgImage.xScale = bgIPadScale;
        self.bgImage.yScale = bgIPadScale;
    }

    //self.bgImage.2shadowCastBitMask = 1;
    //self.bgImage.lightingBitMask = 1;
    [self addChild:self.bgImage];

    self.bgImage2 = [SKSpriteNode spriteNodeWithTexture:bgTexture];
    self.bgImage2.name = @"background";
    self.bgImage2.zPosition = 2;
    self.bgImage2.alpha = 0.0f;
    if([kHelpers isIphoneX])
    {
        self.bgImage2.xScale = 1.0f;
        self.bgImage2.yScale = (812.0f/568.0f);
    }
    else if([kHelpers isIpad])
    {
        self.bgImage2.xScale = bgIPadScale;
        self.bgImage2.yScale = bgIPadScale;
    }

    //self.bgImage2.shadowCastBitMask = 1;
    //self.bgImage2.lightingBitMask = 1;
    [self addChild:self.bgImage2];

    //overlay
    self.bgOverlay = [SKSpriteNode spriteNodeWithImageNamed:@"background_overlay"];
    self.bgOverlay.name = @"background";
    self.bgOverlay.zPosition = 3;
    self.bgOverlay.alpha = 0.5f;
    if([kHelpers isIpad])
    {
        self.bgOverlay.xScale = kiPadScaleX;
        self.bgOverlay.yScale = kiPadScaleY;
    }
    else
    {
        self.bgOverlay.scale = 1.1f;
    }

    [self addChild:self.bgOverlay];

    //flash
    self.flash = [SKSpriteNode spriteNodeWithImageNamed:@"flash2"];
    self.flash.name = @"flash_ignore";
    self.flash.position = CGPointMake(0,0);
    self.flash.zPosition = self.bgOverlay.zPosition + 1;
    self.flash.alpha = 0.0f;
    self.flash.hidden = YES;
    self.flash.scale = 1.0f;
    [self addChild:self.flash];

    //flash
    self.flash2 = [SKSpriteNode spriteNodeWithImageNamed:@"flash2"];
    self.flash2.name = @"flash2_ignore";
    self.flash2.position = CGPointMake(0,0);
    self.flash2.zPosition = self.flash.zPosition + 1;
    self.flash2.alpha = 0.0f;
    self.flash2.hidden = YES;
    self.flash2.scale = 1.0f;
    [self addChild:self.flash2];

    ///scanline
    self.scanline = [SKSpriteNode spriteNodeWithImageNamed:@"scanline"];
    self.scanline.name = @"scanline_ignore";
    self.scanline.position = CGPointMake(0,0);
    self.scanline.zPosition = 2000;
    self.scanline.alpha = 0.0f;
    self.scanline.hidden = NO;
    self.scanline.scale = 1.0f;
    [self addChild:self.scanline];

    //whitebar
    self.whiteBar = [SKSpriteNode spriteNodeWithImageNamed:@"whiteBar"];
    self.whiteBar.name = @"whiteBar_ignore";
    self.whiteBar.position = CGPointMake(0,0);
    self.whiteBar.zPosition = self.scanline.zPosition + 1;
    self.whiteBar.alpha = 1.0f;
    self.whiteBar.hidden = NO;
    self.whiteBar.scale = kWhiteBarAlpha;
    //[self addChild:self.whiteBar];


    //buff border
    self.buffBorder = [SKSpriteNode spriteNodeWithImageNamed:@"flashBorder"];
    self.buffBorder.name = @"buffBorder_ignore";
    self.buffBorder.position = CGPointMake(0,0);
    self.buffBorder.zPosition = self.flash.zPosition;
    self.buffBorder.hidden = NO;
    self.buffBorder.alpha = 0.0f;
    self.buffBorder.scale = 1.0f;
    if([kHelpers isIpad])
    {
        self.buffBorder.xScale = 1.2f;
        self.buffBorder.yScale = 1.0f;
    }
    else if([kHelpers isIphone4Size]) {
        self.buffBorder.yScale = 0.9f;
    }
    else if([kHelpers isIphoneX]) {
        //self.buffBorder.yScale = 0.9f;
    }

    [self addChild:self.buffBorder];

    //buff bg
    self.buffBg = [SKSpriteNode spriteNodeWithImageNamed:@"buffBg"];
    self.buffBg.name = @"buffBg_ignore";
    self.buffBg.position = CGPointMake(0,0);
    self.buffBg.zPosition = self.flash.zPosition -1; //behind border
    self.buffBg.hidden = YES;

    /*
     SKBlendModeAlpha        = 0,    // Blends the source and destination colors by multiplying the source alpha value.
     SKBlendModeAdd          = 1,    // Blends the source and destination colors by adding them up.
     SKBlendModeSubtract     = 2,    // Blends the source and destination colors by subtracting the source from the destination.
     SKBlendModeMultiply     = 3,    // Blends the source and destination colors by multiplying them.
     SKBlendModeMultiplyX2   = 4,    // Blends the source and destination colors by multiplying them and doubling the result.
     SKBlendModeScreen       = 5,    // Blends the source and destination colors by multiplying one minus the source with the destination and adding the source.
     SKBlendModeReplace      = 6     // Replaces the destination with the source (ignores alpha).
     */
    //self.buffBg.blendMode = SKBlendModeAdd;

    self.buffBg.alpha = 0.0f;
    self.buffBg.scale = 1.0f;
    if([kHelpers isIpad])
    {
        self.buffBg.xScale = 1.2f;
        self.buffBg.yScale = 1.0f;
    }

    [self addChild:self.buffBg];

    //curtains
    self.curtainLeft = [SKSpriteNode spriteNodeWithImageNamed:@"curtain_left"];
    self.curtainLeft.name = @"curtainLeft";
    self.curtainLeft.position = CGPointMake(0,0);
    self.curtainLeft.zPosition = self.whiteBar.zPosition + 1;
    self.curtainLeft.alpha = 1.0f;
    self.curtainLeft.hidden = NO;
    self.curtainLeft.scale = 1.0;
    //[self addChild:self.curtainLeft];

    self.curtainRight = [SKSpriteNode spriteNodeWithImageNamed:@"curtain_right"];
    self.curtainRight.name = @"curtainRight";
    self.curtainRight.position = CGPointMake(0,0);
    self.curtainRight.zPosition = self.whiteBar.zPosition + 1;
    self.curtainRight.alpha = 1.0f;
    self.curtainRight.hidden = NO;
    self.curtainRight.scale = 1.0;
    //[self addChild:self.curtainRight];

    //move curtains
    /*
    self.curtainLeft.hidden = NO;
    self.curtainLeft.alpha = 1.0f;
    self.curtainRight.hidden = NO;
    self.curtainRight.alpha = 1.0f;
    float curtainWidth = self.curtainLeft.frame.size.width;
    //start
    self.curtainLeft.position = CGPointMake(curtainWidth/2, self.view.bounds.size.height - self.curtainLeft.frame.size.height/2);
    self.curtainRight.position = CGPointMake(self.view.bounds.size.width - curtainWidth/2, self.view.bounds.size.height - self.curtainRight.frame.size.height/2);
    */

    //block
    ////STControlSprite
    self.block = [SKSpriteNode spriteNodeWithImageNamed:[CBSkinManager getBlockImageName]];
    self.block.name = [NSString stringWithFormat:@"block"];
    self.block.zPosition = 20;
    self.block.color = [UIColor whiteColor];
    self.block.colorBlendFactor = 0.0f;
    //self.block.shadowCastBitMask = 1;
    //self.block.lightingBitMask = 1;
    [self resetBlockAnim:NO];


    //warning
    self.warning = [SKSpriteNode spriteNodeWithImageNamed:@"warning"];
    self.warning.name = @"warning_ignore";
    self.warning.position = CGPointMake(100, 100);
    self.warning.zPosition = 900;
    self.warning.scale = 2.4f;
    self.warning.hidden = YES;
    self.warning.alpha = 0.0f;
    [self addChild:self.warning];

    //rainbow
    self.rainbow = [SKSpriteNode spriteNodeWithImageNamed:@"rainbow"];
    self.rainbow.name = @"rainbow_ignore";
    self.rainbow.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 + 100); //center
    self.rainbow.zPosition = 10;
    self.rainbow.scale = 1.0;
    self.rainbow.hidden = YES;
    self.rainbow.alpha = 0.0f;
    [self addChild:self.rainbow];

    //spike
    self.spike = [SKSpriteNode spriteNodeWithImageNamed:@"spike"];
    self.spike.name = @"spike";
    self.spike.position = CGPointMake(100, 100);
    //self.spike.zPosition = 850-1; //under fireballs
    self.spike.zPosition = 850+1; //above fireballs
    self.spike.scale = 1.0f;
    self.spike.hidden = YES;
    self.spike.alpha = 1.0f;
    [self addChild:self.spike];

    //spike small
    /*self.spikeSmall = [SKSpriteNode spriteNodeWithImageNamed:@"spikeSmall"];
    self.spikeSmall.name = @"spikeSmall";
    self.spikeSmall.position = CGPointMake(100, 100);
    self.spikeSmall.zPosition = self.spike.zPosition;
    self.spikeSmall.scale = 1.0f;
    self.spikeSmall.hidden = YES;
    self.spikeSmall.alpha = 1.0f;
    [self addChild:self.spikeSmall];*/

    //big level
    self.bigLevelLabel2 = [SKLabelNode labelNodeWithFontNamed:kFontName];
    self.bigLevelLabel2.name = @"bigLevelLabel2_ignore";
    self.bigLevelLabel2.alpha = 0.0f;
    self.bigLevelLabel2.scale = 1.0f;
    self.bigLevelLabel2.fontSize = 160.0f;
    self.bigLevelLabel2.fontColor = [UIColor whiteColor];
    self.bigLevelLabel2.zPosition = 901;
    [self.bigLevelLabel2 setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    self.bigLevelLabel2.text = @"1-1";
    [self addChild:self.bigLevelLabel2];

    self.bigLevelLabel2Shadow = [SKLabelNode labelNodeWithFontNamed:kFontName];
    self.bigLevelLabel2Shadow.name = @"bigLevelLabel2Shadow_ignore";
    self.bigLevelLabel2Shadow.alpha = 0.0f;
    self.bigLevelLabel2Shadow.scale = 1.0f;
    self.bigLevelLabel2Shadow.fontSize = self.bigLevelLabel2.fontSize;
    self.bigLevelLabel2Shadow.fontColor = [UIColor blackColor];
    self.bigLevelLabel2Shadow.zPosition = self.bigLevelLabel2.zPosition-1;
    [self.bigLevelLabel2Shadow setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    self.bigLevelLabel2Shadow.text = self.bigLevelLabel2.text;
    [self addChild:self.bigLevelLabel2Shadow];


    //count
    self.countlabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.countlabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.countlabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.countlabel.name =  @"countlabel_ignore";
    self.countlabel.text = [NSString stringWithFormat:@"%d", (int)kAppDelegate.clickCount];
    self.countlabel.fontSize = 60; //80;
    self.countlabel.fontColor = [UIColor whiteColor];
    self.countlabel.xScale = 1;
    self.countlabel.yScale = self.countlabel.xScale;
    self.countlabel.zPosition = 200;
    self.countlabel.alpha = 1;
    [self.countlabel setupShadows:kShadowModeDrop offset:3 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];

    [self addChild:self.countlabel];

    //count x
    /*self.countlabel = [BMGlyphLabel labelWithText:@"" font:bitmapFont2];
     [self.countlabel setVerticalAlignment:BMGlyphVerticalAlignmentMiddle];
     [self.countlabel setHorizontalAlignment:BMGlyphHorizontalAlignmentCentered];*/
    self.countlabelX = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.countlabelX setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.countlabelX setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.countlabelX.name =  @"countlabelX_ignore";
    self.countlabelX.text = @"X";
    self.countlabelX.fontSize = 35; //40
    self.countlabelX.fontColor = [UIColor whiteColor];
    self.countlabelX.xScale = 1; //1
    self.countlabelX.yScale = self.countlabelX.xScale;
    self.countlabelX.zPosition = 200;
    [self addChild:self.countlabelX];
    self.countlabelX.alpha = 0.8f;

    [self.countlabelX setupShadows:kShadowModeDrop offset:3 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];

    //count coin
    self.countCoin = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@Frame1", [CBSkinManager getCoinBarImageName]]];
    self.countCoin.name = @"countCoin_ignore";
    self.countCoin.zPosition = 200;
    self.countCoin.alpha = self.countlabelX.alpha;
    self.countCoin.scale = 1.0f; //1.0;
    [self addChild:self.countCoin];

    //combo
    self.comboLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.comboLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.comboLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.comboLabel.name =  @"comboLabel_ignore";
    //self.comboLabel.text = [NSString stringWithFormat:@"%d-combo", self.comboCount];
    self.comboLabel.text = [NSString stringWithFormat:@"Combo %d", self.comboCount];
    self.comboLabel.fontSize = 50; //22;
    self.comboLabel.fontColor = [UIColor whiteColor];
    self.comboLabel.xScale = 1;
    self.comboLabel.yScale = self.comboLabel.xScale;
    self.comboLabel.zPosition = self.countlabel.zPosition;
    [self addChild:self.comboLabel];
    self.comboLabel.alpha = 0;

    [self.comboLabel setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontName alpha:0.4f];

    //combo angle
    //float angle = RADIANS(8);
    //[self.comboLabel runAction:[SKAction rotateByAngle:angle duration:0.0f]];
    //[self.comboLabelShadow runAction:[SKAction rotateByAngle:angle duration:0.0f]];

    //combo color
    //SKAction *actionColor1 = [SKAction colorizeWithColor:[UIColor yellowColor] colorBlendFactor:1.0 duration:0.0f];
    //SKAction *actionColor2 = [SKAction colorizeWithColor:[UIColor orangeColor] colorBlendFactor:1.0 duration:0.0f];
    SKAction *actionColorWait = [SKAction waitForDuration:0.15f];
    SKAction *actionColor3 = [SKAction runBlock:^{
        //self.comboLabel.fontColor = [UIColor yellowColor];
        self.comboLabel.fontColor =  [UIColor colorWithHex:0xfdfd51]; //yellow

    }];
    SKAction *actionColor4 = [SKAction runBlock:^{
        //self.comboLabel.fontColor = [UIColor orangeColor];
        self.comboLabel.fontColor = [UIColor colorWithHex:0xff8000]; //orange

    }];

    [self.comboLabel runActionsSequenceForever:@[actionColor3,actionColorWait,actionColor4, actionColorWait]];

    //combo rays
    if(YES) {
        //NSString *rayName = @"ray4_combo"; //red badge
        NSString *rayName = @"ray4_combo3"; //small shine
       // NSString *rayName = @"ray4";
        float rayScale = 1.1f; //0.8f;
        //rays, shine
        self.rayCombo = [SKSpriteNode spriteNodeWithImageNamed:rayName];
        self.rayCombo.name = @"rayCombo_ignore";
        self.rayCombo.zPosition = self.comboLabel.zPosition-2;
        self.rayCombo.alpha = 0.0;
        self.rayCombo.zRotation = 0;

        //self.rayCombo.scale = rayScale;
        self.rayCombo.xScale = rayScale;
        self.rayCombo.yScale = rayScale; ///2.0f;

        //SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration: 12]; //12
        SKAction *oneRevolution = [SKAction rotateByAngle:M_PI*2 duration: 12]; //12
        SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
        [self.rayCombo runAction:repeat];

        [self addChild:self.rayCombo];
    }

    //world name
    self.worldNameLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.worldNameLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.worldNameLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.worldNameLabel.name =  @"worldNameLabel_ignore";
    //self.worldNameLabel.fontSize = 22;
    self.worldNameLabel.fontColor = [UIColor whiteColor];
    self.worldNameLabel.xScale = 0.7f;
    self.worldNameLabel.yScale = self.worldNameLabel.xScale;
    self.worldNameLabel.zPosition = self.countlabel.zPosition;
    [self addChild:self.worldNameLabel];
    self.worldNameLabel.alpha = 0.8f;

    [self.worldNameLabel setupShadows:kShadowModeDrop offset:2 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];


    [self updateWorldName];

    //combo highscore
    self.comboLabelScore = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.comboLabelScore setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeRight];
    [self.comboLabelScore setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.comboLabelScore.name =  @"comboLabelScore_ignore";
    //self.comboLabelScore.text = [NSString stringWithFormat:@"%d", self.comboCount];
    self.comboLabelScore.scale = 1.0f;
    self.comboLabelScore.fontSize = 16.0f; //22.0f;
    self.comboLabelScore.fontColor = [UIColor whiteColor];
    //self.comboLabelScore.xScale = 0.4f;
    //self.comboLabelScore.yScale = self.comboLabelScore.xScale;
    self.comboLabelScore.zPosition = self.countlabel.zPosition;
    [self addChild:self.comboLabelScore];
    self.comboLabelScore.alpha = 0.0f;
    [self.comboLabelScore setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];
    [self updateComboHighScoreLabel];


    //level
    self.levelLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.levelLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.levelLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.levelLabel.name = @"levelLabel_ignore";
    self.levelLabel.xScale = 1.0;
    self.levelLabel.yScale = self.levelLabel.xScale;
    self.levelLabel.zPosition = 200;
    [self addChild:self.levelLabel];
    self.levelLabel.alpha = 1;

    [self.levelLabel setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];

    [self updateLevelLabel:NO];



    //num fire
    self.numFireballLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.numFireballLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeLeft];
    [self.numFireballLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.numFireballLabel.name = @"numFireballLabel_ignore";
    self.numFireballLabel.xScale = 1.0;
    self.numFireballLabel.yScale = self.numFireballLabel.xScale;
    self.numFireballLabel.zPosition = 200;
    [self addChild:self.numFireballLabel];
    self.numFireballLabel.alpha = 1.0f; //hide

    [self.numFireballLabel setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];

    [self updateNumFireballLabel:NO];


    //backTop
    self.backTop = [SKSpriteNode spriteNodeWithImageNamed:@"backTop"];
    self.backTop.position = CGPointMake(0,self.frame.size.height - [self getIPhoneXTop]);
    //self.backTop.position = CGPointMake(0,self.frame.size.height);
    self.backTop.anchorPoint = CGPointMake(0, 1);
    self.backTop.name = @"backTop_ignore";
    self.backTop.zPosition = 2000; //above fire //190;
    self.backTop.alpha = 0.5f;
    if([kHelpers isIphoneX])
    {
        self.backTop.scale = 1.4f;
    }
    else if([kHelpers isIpad])
    {
        self.backTop.xScale = 1.2f;
        self.backTop.yScale = 1.0f;
    }
    else
        self.backTop.scale = 1.0f;

    [self addChild:self.backTop];


    //time
    self.timeLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.timeLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.timeLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.timeLabel.name = @"timeLabel_ignore";
    self.timeLabel.xScale = 0.8;
    self.timeLabel.yScale = self.timeLabel.xScale;
    self.timeLabel.zPosition = self.backTop.zPosition+1;
    [self addChild:self.timeLabel];
    self.timeLabel.alpha = 1.0f; //hide

    [self.timeLabel setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];

    [self updateTimeLabel:NO];

    //speed
    self.speedLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.speedLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.speedLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.speedLabel.name = @"speedLabel_ignore";
    self.speedLabel.fontSize = 22;
    self.speedLabel.xScale = 1.0f;
    self.speedLabel.yScale = self.speedLabel.xScale;
    self.speedLabel.zPosition = 200;
    [self addChild:self.speedLabel];
    self.speedLabel.alpha = 1.0f; //hide

    [self.speedLabel setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];

    [self updateSpeed];

    //multiplier
    self.multLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.multLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.multLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.multLabel.name = @"multLabel_ignore";

    //self.multLabel.xScale = 0.5f;
    self.multLabel.fontSize = 22;
    self.multLabel.xScale = 1.0f;

    self.multLabel.yScale = self.multLabel.xScale;
    self.multLabel.zPosition = 200;
    [self addChild:self.multLabel];
    self.multLabel.alpha = 1.0f;

    [self.multLabel setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];

    [self updateMult:NO];


    //backBottom
    self.backBottom = [SKSpriteNode spriteNodeWithImageNamed:@"backBottom"];
    self.backBottom.anchorPoint = CGPointMake(0, 0);
    self.backBottom.name = @"backBottom_ignore";
    self.backBottom.zPosition = self.backTop.zPosition;
    self.backBottom.alpha = self.backTop.alpha;
    self.backBottom.scale = 1.0f;
    self.backBottom.alpha = 0.0f; //1.0f;
    [self addChild:self.backBottom];

    //bar
    CGFloat barScale = 1.0f;
    if([kHelpers isIpad])
    {
        barScale = 1.15f;
    }
    else if([kHelpers isIphoneX])
    {
        barScale = 1.0f;
    }

    self.bar = [SKSpriteNode spriteNodeWithImageNamed:@"barWorld3"];
    self.bar.name = @"bar_ignore";
    self.bar.zPosition = 200;
    self.bar.alpha = 0.6f;
    self.bar.scale = barScale;
    self.bar.anchorPoint = CGPointMake(0, 0.5);
    [self addChild:self.bar];

    //bar fill
    self.barFill = [SKSpriteNode spriteNodeWithImageNamed:@"barWorldFill3"];
    self.barFill.name = @"bar_ignore";
    self.barFill.zPosition = self.bar.zPosition+1;
    //self.barFill.alpha = 1.0f;
    self.barFill.alpha = 0.5f; //1.0f;
    self.barFill.scale = barScale;

    self.barFill.anchorPoint = CGPointMake(0, 0.5);

    //fade in/out
    SKAction *barFadeIn = [SKAction fadeAlphaTo:1.0f duration:0.5f];
    SKAction *barFadeWait = [SKAction waitForDuration:0.3f];
    SKAction *barFadeOut = [SKAction fadeAlphaTo:0.6f duration:0.3f];
    SKAction *barSequence = [SKAction sequence:@[barFadeOut,barFadeIn, barFadeWait]];
    barSequence = [SKAction repeatActionForever:barSequence];
    [self.barFill runAction:barSequence];

    //bar level
    self.barLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    self.barLabel.scale = 1.0f;
    self.barLabel.name = @"barLabel_ignore";
    self.barLabel.fontSize = 16.0f; //14.0f;
    self.barLabel.fontColor = [UIColor whiteColor];
    self.barLabel.zPosition = self.barFill.zPosition + 2;
    [self.barLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
	[self.barLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [self addChild:self.barLabel];
    [self.barLabel setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];


    //align
    [self addChild:self.barFill];
    [self updateLevelBar:NO];

    //bar icon
    self.barIcon = [SKSpriteNode spriteNodeWithImageNamed:@"profile_placeholder"];

    UIImage *image = [UIImage imageNamed:@"profile_placeholder"];
    //image = [kHelpers circularScaleAndCropImage:image frame:CGRectMake(0,0,image.size.width, image.size.height )];
    //image = [kHelpers imageWithBorderFromImage:image];
    self.barIcon = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];

    self.barIcon.name = @"bar";
    self.barIcon.zPosition = self.bar.zPosition+2;
    self.barIcon.alpha = 1.0f;
    self.barIcon.scale = 1.0; //0.4f;
    [self addChild:self.barIcon];

    //bar back
    self.barBack = [SKSpriteNode spriteNodeWithImageNamed:@"barBack"];
    self.barBack.name = @"barBack_ignore";
    self.barBack.zPosition = self.bar.zPosition-1;
    self.barBack.alpha = 0.6f;
    self.barBack.scale = 1.5f;
    //self.barBack.anchorPoint = CGPointMake(0, 0.5);
    [self addChild:self.barBack];


    //help bubble
    self.barHelp = [SKSpriteNode spriteNodeWithImageNamed:@"help_bubble"];
    //self.barHelp.name = @"barHelp__ignore";
    self.barHelp.name = @"barHelp";
    self.barHelp.zPosition = self.barFill.zPosition+1;
    self.barHelp.alpha = 1.0f;
    self.barHelp.scale = 1.0f;
    [self addChild:self.barHelp];

    //help castle
    self.barCastle = [SKSpriteNode spriteNodeWithImageNamed:@"help_castle1"];
    self.barCastle.name = @"barCastle";
    self.barCastle.zPosition = self.barHelp.zPosition-1;
    self.barCastle.alpha = 1.0f;
    self.barCastle.scale = 0.6f; //0.8f
    [self addChild:self.barCastle];


    //bar icon rewind
    self.barIconRewind = [SKSpriteNode spriteNodeWithImageNamed:@"profile_placeholder"];

    image = [UIImage imageNamed:@"star2"];
    //image = [kHelpers circularScaleAndCropImage:image frame:CGRectMake(0,0,image.size.width, image.size.height )];
    //image = [kHelpers imageWithBorderFromImage:image];
    self.barIconRewind = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:image]];


    self.barIconRewind.name = @"barIconRewind";
    self.barIconRewind.zPosition = self.bar.zPosition+1;
    self.barIconRewind.alpha = 0.8f;
    self.barIconRewind.scale = kRewindScale;
    //disabled
    //[self addChild:self.barIconRewind];


    //clock
    self.clock = [SKSpriteNode spriteNodeWithImageNamed:@"menu_icon_clock"];
    self.clock.name = @"clock_ignore";
    self.clock.zPosition = self.timeLabel.zPosition;
    self.clock.alpha = 1.0f;
    self.clock.scale = 1.0;
    [self addChild:self.clock];


    int heartX = 117;
    if([kHelpers isIpad])
    {
        heartX += 30;
    }
    else if([kHelpers isIphoneX])
    {
        //heartX += 20;
    }

    int heartY = self.backTop.position.y - 24 - 0; //-8 //offset for top title
    //hearts 1
    self.heart1 = [SKSpriteNode spriteNodeWithImageNamed:@"heart_full"];
    self.heart1.name = @"heartTop1";
    self.heart1.zPosition = self.backTop.zPosition+1;
    self.heart1.alpha = 1.0f;
    self.heart1.scale = kHeartScale;
    self.heart1.position = CGPointMake(heartX, heartY);
    //self.heart1.lightingBitMask = 1;
    [self addChild:self.heart1];

    //hearts 2
    self.heart2 = [SKSpriteNode spriteNodeWithImageNamed:@"heart_half"];
    self.heart2.name = @"heartTop2";
    self.heart2.zPosition = self.backTop.zPosition+1;
    self.heart2.alpha = 1.0f;
    self.heart2.scale = kHeartScale;
    self.heart2.position = CGPointMake(heartX+30, heartY);
    //self.heart2.lightingBitMask = 1;
    [self addChild:self.heart2];

    //hearts 3
    self.heart3 = [SKSpriteNode spriteNodeWithImageNamed:@"heart_half"];
    self.heart3.name = @"heartTop3";
    self.heart3.zPosition = self.backTop.zPosition+1;
    self.heart3.alpha = 1.0f;
    self.heart3.scale = kHeartScale;
    self.heart3.position = CGPointMake(heartX+60, heartY);
    //self.heart3.lightingBitMask = 1;
    [self addChild:self.heart3];

    //hearts 4
    self.heart4 = [SKSpriteNode spriteNodeWithImageNamed:@"heart_half"];
    self.heart4.name = @"heartTop4";
    self.heart4.zPosition = self.backTop.zPosition+1;
    self.heart4.alpha = 1.0f;
    self.heart4.scale = kHeartScale;
    self.heart4.position = CGPointMake(heartX+90, heartY);
    //self.heart4.lightingBitMask = 1;
    [self addChild:self.heart4];

    //heart fall
    self.heartFall = [SKSpriteNode spriteNodeWithImageNamed:@"heart_half"]; //heart_full
    self.heartFall.name = @"heartFall_ignore";
    self.heartFall.zPosition = self.backTop.zPosition+1;
    self.heartFall.alpha = 1.0;
    self.heartFall.scale = kHeartScale;
    self.heartFall.position = CGPointMake(heartX+60, heartY);
    self.heartFall.hidden = YES;
    [self addChild:self.heartFall];

    //bomb explision
    self.bombExplosion = [SKSpriteNode spriteNodeWithImageNamed:@"bomb_explosion"];
    self.bombExplosion.name = @"bombExplosion_ignore";
    self.bombExplosion.alpha = 1.0;
    self.bombExplosion.scale = 1.0f;
    self.bombExplosion.hidden = YES;
    [self addChild:self.bombExplosion];


    //rec, live
    self.rec = [SKSpriteNode spriteNodeWithImageNamed:@"rec"];
    self.rec.name = @"rec_ignore";
    self.rec.zPosition = 900-1;
    self.rec.alpha = 1.0f; //0.5f;
    self.rec.scale = 1.1f;
    //self.rec.position = CGPointMake(self.frame.size.width - self.rec.size.width/2 - 6, self.backTop.position.y - 54); //right
    self.rec.position = CGPointMake(self.frame.size.width - self.rec.size.width/2 - 6, self.backTop.position.y - 74); //right

    //disabled
    [self addChild:self.rec];
    //self.rec.hidden = YES;

    //combo arrows square
    float comboArrowScale = 0.5f;
    self.comboArrow1 = [SKSpriteNode spriteNodeWithImageNamed:@"comboArrowEmpty"];
    self.comboArrow1.name = @"comboArrow_ignore";
    self.comboArrow1.alpha = 1.0f; //0.5f;
    self.comboArrow1.scale = comboArrowScale;
    [self addChild:self.comboArrow1];

    self.comboArrow2 = [SKSpriteNode spriteNodeWithImageNamed:@"comboArrowEmpty"];
    self.comboArrow2.name = @"comboArrow_ignore";
    self.comboArrow2.zPosition = 900-1;
    self.comboArrow2.alpha = self.comboArrow1.alpha;
    self.comboArrow2.scale = comboArrowScale;
    [self addChild:self.comboArrow2];

    self.comboArrow3 = [SKSpriteNode spriteNodeWithImageNamed:@"comboArrowEmpty"];
    self.comboArrow3.name = @"comboArrow_ignore";
    self.comboArrow3.alpha = self.comboArrow1.alpha;
    self.comboArrow3.scale = comboArrowScale;
    [self addChild:self.comboArrow3];


    //potion
    self.potion = [SKSpriteNode spriteNodeWithImageNamed:kPotionImageName];
    self.potion.name = @"potion";
    self.potion.zPosition = self.backTop.zPosition+1; //900-1;
    self.potion.alpha = 1.0f;
    self.potion.scale = kPotionScale;
    //self.potion.position = CGPointMake(self.frame.size.width-36, self.backTop.position.y - 90); //old
    self.potion.position = CGPointMake(self.frame.size.width-36, self.backTop.position.y - 24); //new, higher
    [self addChild:self.potion];

    self.potionLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    [self.potionLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.potionLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    self.potionLabel.name =  @"potionLabel_ignore";
    self.potionLabel.text = [NSString stringWithFormat:@"%d", 99];
    self.potionLabel.fontSize = 60; //80;
    self.potionLabel.fontColor = [UIColor whiteColor];
    self.potionLabel.xScale = 0.4f;
    self.potionLabel.yScale = self.potionLabel.xScale;
    self.potionLabel.zPosition = 10; //self.potion.zPosition + 2;
    self.potionLabel.alpha = 1;
    self.potionLabel.position = CGPointMake(10, -16);
    [self.potion addChild:self.potionLabel];
    [self.potionLabel setupShadows:kShadowModeOutline offset:5 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];

    //potion fall
    self.potionFall = [SKSpriteNode spriteNodeWithImageNamed:kPotionEmptyImageName];
    self.potionFall.name = @"potionFall_ignore";
    self.potionFall.zPosition = self.potion.zPosition-1;
    self.potionFall.alpha = 1.0;
    self.potionFall.scale = kPotionScale;
    self.potionFall.position = self.potion.position;
    self.potionFall.hidden = YES;
    [self addChild:self.potionFall];

    //potion heart
    self.potionHeart1 = [SKSpriteNode spriteNodeWithImageNamed:kPotionImageName];
    self.potionHeart1.name = @"potionHeart1_ignore";
    self.potionHeart1.zPosition = self.potion.zPosition-1;
    self.potionFall.alpha = 1.0f;
    self.potionHeart1.scale = kPotionScale;
    self.potionHeart1.position = self.potion.position;
    self.potionHeart1.hidden = YES;
    [self addChild:self.potionHeart1];

	//potion plus
	self.potionPlus = [SKSpriteNode spriteNodeWithImageNamed:@"menu_icon_movie"]; // button_plus_energy
    self.potionPlus.name = @"potionPlus";
    self.potionPlus.zPosition = self.potion.zPosition + 1;
    self.potionPlus.alpha = 1.0f;
	self.potionPlus.hidden = YES;
    self.potionPlus.scale = 0.9f;
    self.potionPlus.position = CGPointMake(self.potion.position.x - 13, self.potion.position.y - 18);
    //self.potionPlus.hidden = YES;
    //[self.potion addChild:self.potionPlus];
    [self addChild:self.potionPlus];

	//weak spot
	self.weakSpot = [SKSpriteNode spriteNodeWithImageNamed:@"weakSpot"];
    self.weakSpot.name = @"weakSpot";
    self.weakSpot.zPosition = self.block.zPosition + 1;
    self.weakSpot.alpha = 1.0f;
	self.weakSpot.hidden = YES;
    self.weakSpot.scale = 1.0f;
    self.weakSpot.position = CGPointMake(self.block.position.x, self.block.position.y);
    self.weakSpot.hidden = YES;
    [self addChild:self.weakSpot];

	//weak spot explosions
	self.weakSpotExplosion = [SKSpriteNode spriteNodeWithImageNamed:@"explosion1Frame1"];
	self.weakSpotExplosion.name = @"weakSpotExplosion_IGNORE";
	self.weakSpotExplosion.zPosition = self.block.zPosition+1000;
	self.weakSpotExplosion.alpha = 0.0f;
	self.weakSpotExplosion.scale = 1.0f;
	[self addChild:self.weakSpotExplosion];

    //nav square
    self.navSquare = [SKSpriteNode spriteNodeWithImageNamed:@"nav_square"];
    self.navSquare.name = @"navSquare";
    self.navSquare.zPosition = 900-1;
    self.navSquare.alpha = 1.0f; //0.5f;
    self.navSquare.scale = 1.0f;
    //right
    //self.navSquare.position = CGPointMake(self.frame.size.width-36, self.backTop.position.y - 90);
    //left
    self.navSquare.position = CGPointMake(46, self.backTop.position.y -92);
    [self addChild:self.navSquare];

    //lava
    self.lava = [SKSpriteNode spriteNodeWithImageNamed:@"lava_1"];
    self.lava.name = @"lava";
    self.lava.zPosition = self.backBottom.zPosition + 1; //850+5; //above fireballs // self.block.position;
    //self.lava.zPosition = self.block.zPosition + 1; //above block
    self.lava.alpha = 0.0f;
    self.lava.hidden = YES;

    if([kHelpers isIpad])
    {
        self.lava.xScale = 1.2f;
        self.lava.yScale = 1.0f;
    }
    else
    {
        self.lava.scale = 1.0f;
    }

    //shader
    //SKShader* shaderLava = [SKShader shaderWithFileNamed:@"ShaderLava.fsh"];
    //SKShader* shaderLava = [SKShader shaderWithFileNamed:@"ShaderLava.fsh"];

    //disabled
    //self.lava.shader = shaderLava;

    [self addChild:self.lava];



    //ink
    self.ink = [SKSpriteNode spriteNodeWithImageNamed:@"ink1"];
    self.ink.name = @"ink_ignore";
    self.ink.position = self.block.position;
    //self.ink.zPosition = self.block.zPosition+2; //above block
    //self.ink.zPosition = self.scanline.zPosition-2; //above cloud
    self.ink.zPosition = self.lava.zPosition+1; //above lava
    //self.ink.zPosition = self.lava.zPosition + 100;
    //self.ink.zPosition = self.backBottom.zPosition + 2; //ab0ve lava

    self.ink.scale = 1.0f;
    self.ink.hidden = YES;
    self.ink.alpha = 0.0f;
    [self addChild:self.ink];




	//buffsquare
    CGFloat buffOffsetX = -2.0f;
    CGFloat buffOffsetY = 0.0f; //2.0f

	self.buffSquare = [SKSpriteNode spriteNodeWithImageNamed:@"nav_square2"];
    self.buffSquare.name = @"buffSquare";
    //self.buffSquare.zPosition = 900-1; //over spikes, like nav
    self.buffSquare.zPosition = self.block.zPosition +1;
    self.buffSquare.alpha = 1.0f;
    self.buffSquare.scale = 1.0f;
    self.buffSquare.position = CGPointMake(32, 105 + [self getIPhoneXBottom]); //(30, 105)
    //disabled
    //[self addChild:self.buffSquare];

	//buff
	self.buff = [SKSpriteNode spriteNodeWithImageNamed:@"power_up_shield"];  //button_plus_energy
    self.buff.name = @"buff";
    self.buff.zPosition = self.buffSquare.zPosition;
    self.buff.hidden = NO;
    self.buff.alpha = 1.0f;
    self.buff.scale = 1.0f;
    self.buff.position = CGPointMake(self.buffSquare.position.x+buffOffsetX, self.buffSquare.position.y+buffOffsetY);
    [self.buff addGlow]; //glow
    [self addChild:self.buff];

    CGFloat buffDistance = 26.0f;
    //buff label timer
    self.buffLabelTimer = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    self.buffLabelTimer.name = @"buffLabelTimer_ignore";
    self.buffLabelTimer.scale = 1.0f;
    self.buffLabelTimer.fontSize = 18.0f;
    self.buffLabelTimer.fontColor = [UIColor whiteColor];
    self.buffLabelTimer.zPosition = self.buff.zPosition;
    self.buffLabelTimer.position = CGPointMake(self.buffSquare.position.x+buffOffsetX, self.buffSquare.position.y - buffDistance +buffOffsetY);
    [self.buffLabelTimer setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.buffLabelTimer setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [self addChild:self.buffLabelTimer];
    [self.buffLabelTimer setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];
    self.buffLabelTimer.text = @"10s";

    //buff label name
    self.buffLabelName = [SKLabelOutlineNode labelNodeWithFontNamed:kFontName];
    self.buffLabelName.name = @"buffLabelName_ignore";
    self.buffLabelName.scale = 1.0f;
    self.buffLabelName.fontSize = 18.0f;
    self.buffLabelName.fontColor = [UIColor whiteColor];
    self.buffLabelName.zPosition = self.buff.zPosition;
    self.buffLabelName.position = CGPointMake(self.buffSquare.position.x+buffOffsetX, self.buffSquare.position.y + buffDistance +buffOffsetY);
    [self.buffLabelName setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [self.buffLabelName setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    [self addChild:self.buffLabelName];
    [self.buffLabelName setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontName alpha:0.8f];
    self.buffLabelName.text = @"buff";

	//nav plus
	self.navPlus = [SKSpriteNode spriteNodeWithImageNamed:@"menu_icon_movie"];  //button_plus_energy
    self.navPlus.name = @"navPlus";
    self.navPlus.zPosition = self.navSquare.zPosition + 2;
	self.navPlus.hidden = YES;
    self.navPlus.alpha = 1.0f;
    self.navPlus.scale = 1.4f;
    self.navPlus.position = CGPointMake(self.navSquare.position.x + 20, self.navSquare.position.y - 24); //corner
    //self.navPlus.position = CGPointMake(self.navSquare.position.x - 2, self.navSquare.position.y - 0); //center
    [self addChild:self.navPlus];

    //nav lock
    self.navLock = [SKSpriteNode spriteNodeWithImageNamed:@"lock"];  //button_plus_energy
    self.navLock.name = @"navLock_ignore";
    self.navLock.zPosition = self.navSquare.zPosition + 2;
    self.navLock.hidden = YES;
    self.navLock.alpha = 0.5f;
    self.navLock.scale = 0.3f;
    self.navLock.position = CGPointMake(self.navSquare.position.x + 0, self.navSquare.position.y - 0); //corner
    [self addChild:self.navLock];


	//buff shine
	self.buffShine = [SKSpriteNode spriteNodeWithImageNamed:@"ray4_combo4"]; //ray5
    self.buffShine.name = @"buffShine_ignore";
    self.buffShine.zPosition = self.buff.zPosition -1;
    self.buffShine.alpha = 0.7f;
    self.buffShine.scale = 0.4f;
    self.buffShine.position = self.buff.position;
    [self addChild:self.buffShine];

	//nav overlay, spinOverlay
	self.navOverlay = [SKSpriteNode spriteNodeWithImageNamed:@"navOverlay"];
    self.navOverlay.name = @"navOverlay_ignore";
    self.navOverlay.zPosition = self.navSquare.zPosition - 2; //behind square and spin image
	self.navOverlay.hidden = NO;
    self.navOverlay.alpha = 0.0f;
    self.navOverlay.scale = 1.6f; //self.navSquare.xScale; //same scale
    self.navOverlay.position = CGPointMake(self.navSquare.position.x, self.navSquare.position.y);
    //[self addChild:self.navOverlay]; //disabled

    //heart plus
    self.heartPlus = [SKSpriteNode spriteNodeWithImageNamed:@"button_plus_energy"];  //button_plus_energy
    self.heartPlus.name = @"heartPlus";
    self.heartPlus.zPosition = self.heart3.zPosition + 1;
    self.heartPlus.hidden = NO;
    self.heartPlus.alpha = 0.8f;
    self.heartPlus.scale = 0.5f;
    self.heartPlus.position = CGPointMake(self.heart4.position.x + 10, self.heart4.position.y - 10);
    [self addChild:self.heartPlus];
    //scale
    CGFloat plusAlphaIn = 1.0f;
    CGFloat plusAlphaOut = 0.8f;
    CGFloat plusFadeDuration = 0.2f;
    CGFloat plusScale = self.heartPlus.xScale;
    CGFloat plusScaleOld = self.heartPlus.xScale*0.8f;
    CGFloat waitDuration = 1.0f;
    //pulse forever?
    SKAction *fadeIn = [SKAction fadeAlphaTo:plusAlphaIn duration:plusFadeDuration];
    SKAction *fadeOut = [SKAction fadeAlphaTo:plusAlphaOut duration:plusFadeDuration];
    SKAction *scaleIn = [SKAction scaleTo:plusScale duration:plusFadeDuration];
    SKAction *scaleOut = [SKAction scaleTo:plusScaleOld duration:plusFadeDuration];
    SKAction *wait = [SKAction waitForDuration:waitDuration];
    SKAction * sequenceFade = [SKAction sequence:@[wait, fadeIn, fadeOut]];
    SKAction * sequenceScale = [SKAction sequence:@[wait, scaleIn, scaleOut]];
    SKAction *group = [SKAction group:@[sequenceFade, sequenceScale]];
    [self.heartPlus runAction:[SKAction repeatActionForever:group] withKey:@"heartPlusPulse"];


    //powerup
    self.imageSquare = [SKSpriteNode spriteNodeWithImageNamed:@"power_up_star"];
    self.imageSquare.name = @"imageSquare";
    self.imageSquare.zPosition = self.navSquare.zPosition-1;
    self.imageSquare.scale = 1.0f;
    float squareOffset = 1.0f; //0.5f;
    self.imageSquare.position = CGPointMake(self.navSquare.position.x-squareOffset, self.navSquare.position.y+squareOffset);
    //self.imageSquare.hidden = YES;
    self.imageSquare.alpha = 0.0f;
    [self addChild:self.imageSquare];
    //remove texture
    //self.imageSquare.texture  = nil;


    //[self hideImageSquare:NO];

    self.fireballAppearArray = [NSMutableArray array];
    self.powerupArray = [NSMutableArray array];
    self.cloudArray = [NSMutableArray array];
    self.miniShineArray = [NSMutableArray array];

    //touch
    //self.touch = [SKSpriteNode spriteNodeWithImageNamed:@"touch"];
    //self.touch = [SKSpriteNode spriteNodeWithImageNamed:@"touch3"];
    self.touch = [SKSpriteNode spriteNodeWithImageNamed:@"touch4Frame1"];

    self.touch.scale = 2.0f;
    self.touch.name = [NSString stringWithFormat:@"touch_ignore"];
    self.touch.alpha = 0.0f;
    self.touch.zPosition = 1000;
    [self addChild:self.touch];

    //touch
    self.touchFireball = [SKSpriteNode spriteNodeWithImageNamed:@"touch2"];
    self.touchFireball.scale = 2.0f;
    self.touchFireball.name = [NSString stringWithFormat:@"touchFireball_ignore"];
    self.touchFireball.alpha = 0.0f;
    self.touchFireball.zPosition = 800;
    self.touchFireball.hidden = YES;
    [self addChild:self.touchFireball];

    self.touchStar = [SKSpriteNode spriteNodeWithImageNamed:@"touch2"];
    self.touchStar.scale = 2.0f;
    self.touchStar.name = [NSString stringWithFormat:@"touchStar_ignore"];
    self.touchStar.alpha = 0.0f;
    self.touchStar.zPosition = 800;
    self.touchStar.hidden = YES;
    [self addChild:self.touchStar];

    self.touchCombo = [SKSpriteNode spriteNodeWithImageNamed:@"touch2"];
    self.touchCombo.scale = 2.0f;
    self.touchCombo.name = [NSString stringWithFormat:@"touchCombo_ignore"];
    self.touchCombo.alpha = 0.0f;
    self.touchCombo.zPosition = 800;
    self.touchCombo.hidden = YES;
    [self addChild:self.touchCombo];


    self.fireballX = [SKSpriteNode spriteNodeWithImageNamed:@"fireball_X"];
    self.fireballX.scale = 2.0f;
    self.fireballX.name = [NSString stringWithFormat:@"fireballX_ignore"];
    self.fireballX.alpha = 0.0f;
    self.fireballX.zPosition = 800;
    self.fireballX.hidden = YES;
    [self addChild:self.fireballX];


    //door
#if 0
    self.door = [SKSpriteNode spriteNodeWithImageNamed:@"door"];
    self.door.name = [NSString stringWithFormat:@"door"];
    self.door.zPosition = self.block.zPosition - 1; //behind block
    self.door.position = self.block.position;
    self.door.xScale = 2.0f;
    self.door.yScale = self.door.xScale;
    self.door.alpha = 0.0f;
    [self addChild:self.door];
#endif

    //minishine
    for(int i=0; i<kNumMiniShines; i++)
    {
        [self createMiniShine];
    }

    //hand

    self.tutoArrow = [SKSpriteNode spriteNodeWithImageNamed:[CBSkinManager getTutoArrowImageName]];
    self.tutoArrow.name = @"tutoArrowBlock";
    self.tutoArrow.zPosition = self.block.zPosition+1;
    self.tutoArrow.alpha = 1.0f;
    self.tutoArrow.scale = 0.6f;
    self.tutoArrow.position = CGPointMake(self.block.position.x, self.block.position.x);
    self.tutoArrow.hidden = YES;
    [self addChild:self.tutoArrow];

    self.tutoArrowSquare = [SKSpriteNode spriteNodeWithImageNamed:[CBSkinManager getTutoArrowImageName]];
    self.tutoArrowSquare.name = @"tutoArrowSquare"; //@"tutoArrowSquare_ignore";
    self.tutoArrowSquare.zPosition = self.imageSquare.zPosition+3;
    self.tutoArrowSquare.alpha = 0.0f;
    self.tutoArrowSquare.scale = 0.6f;
    self.tutoArrowSquare.position = CGPointMake(self.block.position.x, self.block.position.x);
    self.tutoArrowSquare.hidden = YES;
    [self addChild:self.tutoArrowSquare];

    self.tutoArrowPotion = [SKSpriteNode spriteNodeWithImageNamed:[CBSkinManager getTutoArrowImageName]];
    self.tutoArrowPotion.name = @"tutoArrowPotion"; //@"tutoArrowPotion_ignore";
    self.tutoArrowPotion.zPosition = self.potion.zPosition+2;
    self.tutoArrowPotion.alpha = 0.0f;
    self.tutoArrowPotion.scale = 0.6f;
    self.tutoArrowPotion.position = CGPointMake(self.potion.position.x, self.potion.position.x);
    self.tutoArrowPotion.hidden = YES;
    [self addChild:self.tutoArrowPotion];


    self.redArrow = [SKSpriteNode spriteNodeWithImageNamed:@"title_arrow"];
    self.redArrow.name = @"redArrow_ignore";
    self.redArrow.zPosition = self.block.zPosition+1;
    self.redArrow.alpha = 0.0f;
    self.redArrow.scale = 1.0;
    //self.redArrow.position = CGPointMake(self.block.position.x, self.block.position.x);
    [self addChild:self.redArrow];


    //toastie
    self.toastie = [SKSpriteNode spriteNodeWithImageNamed:@"toastie10"];
    self.toastie.name = @"toastie";
    self.toastie.zPosition = 900+1; //above powerup // 2001; //self.bar.zPosition+1; //above bar //self.backTop.zPosition
    self.toastie.alpha = 0.0f;
    self.toastie.scale = 0.75f;
    self.toastie.hidden = YES;
    [self addChild:self.toastie];

    NSString *rayName = @"ray4"; //@"ray3";
    float rayScale = 1.0f;
    float rayAlpha = 0.2f;

    //key
    self.winKey = [SKSpriteNode spriteNodeWithImageNamed:@"key3"];
    self.winKey.name = @"winKey";
    self.winKey.zPosition = self.block.zPosition+1000+1000;
    //self.winKey.zPosition = self.bgOverlay.zPosition + 100;

    self.winKey.alpha = 0.0f;
    self.winKey.scale = 1.4f;
    self.winKey.hidden = YES;
    [self.winKey addGlow]; //glow
    [self addChild:self.winKey];

	//key shine
#if 1
	self.winKeyShine = [SKSpriteNode spriteNodeWithImageNamed:@"ray5"];
    self.winKeyShine.name = @"winKeyShine_ignore";
    self.winKeyShine.zPosition = -1; //under
    self.winKeyShine.alpha = 1.0f; //rayAlpha;
    self.winKeyShine.scale = 1.2f; //rayScale;
    self.winKeyShine.hidden = NO;
    //[self.winKeyShine addGlow]; //glow
    [self.winKey addChild:self.winKeyShine];

	//rotate
    SKAction *oneRevolutionKey = [SKAction rotateByAngle:-M_PI*2 duration: 32];
    SKAction *repeatKey = [SKAction repeatActionForever:oneRevolutionKey];
    [self.winKeyShine runAction:repeatKey];
#endif

    //Setup a LightNode
    /* self.light = [[SKLightNode alloc] init];
     self.light.categoryBitMask = 1;
     self.light.falloff = 1;
     self.light.ambientColor = [UIColor whiteColor];
     self.light.lightColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:0.0 alpha:0.5];
     self.light.shadowColor = [[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
     //[self.block addChild:self.light];*/

    [self addChild:self.block];



    //rays, shine
    self.ray1 = [SKSpriteNode spriteNodeWithImageNamed:rayName];
    self.ray1.name = @"ray1_ignore";
    self.ray1.zPosition = 4;
    self.ray1.alpha = rayAlpha;
    self.ray1.scale = rayScale;
    self.ray1.zRotation = 0;
    //rotate
    SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration: 16];
    oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration: 32];
    SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
    [self.ray1 runAction:repeat];

    //slow
    //if(![kHelpers isSlowDevice])
    {
      //disabled
      //[self addChild:self.ray1];
    }

    //subscribe to resume updates
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumeNotification:)
                                                 name:kResumeNotification
                                               object:nil];


    self.explosionsArray = [NSMutableArray array];
    for(int i=0;i<kNumBlockExplosions;i++) {

        SKNode *tempExplosion = [SKSpriteNode spriteNodeWithImageNamed:@"explosion1Frame1"];
        tempExplosion.name = @"tempExplosion_ignore";
        tempExplosion.zPosition = self.block.zPosition+1000;
        tempExplosion.alpha = 0.0f;
        tempExplosion.scale = 0.25f;
        [self.explosionsArray addObject:tempExplosion];
        [self.block addChild:tempExplosion];
    }

    //fireworks
    self.fireworks1 = [SKSpriteNode spriteNodeWithImageNamed:@"fireworks1Frame1"];
    self.fireworks1.name = @"fireworks1_ignore";
    self.fireworks1.zPosition = self.barFill.zPosition+1;
    self.fireworks1.alpha = 0.0f;
    self.fireworks1.scale = 0.25f;
    //[self addChild:self.fireworks1];

    self.fireworks2 = [SKSpriteNode spriteNodeWithImageNamed:@"fireworks2Frame1"];
    self.fireworks2.name = @"fireworks2_ignore";
    self.fireworks2.zPosition = self.barFill.zPosition+1;
    self.fireworks2.alpha = 0.0f;
    self.fireworks2.scale = 0.25f;
    //[self addChild:self.fireworks2];

    self.fireworks3 = [SKSpriteNode spriteNodeWithImageNamed:@"fireworks3Frame1"];
    self.fireworks3.name = @"fireworks3_ignore";
    self.fireworks3.zPosition = self.barFill.zPosition+1;
    self.fireworks3.alpha = 0.0f;
    self.fireworks3.scale = 0.25f;
    //[self addChild:self.fireworks3];

    //done
    /*[[NSNotificationCenter defaultCenter] postNotificationName:kLoadingDoneNotifications
     object:self
     userInfo:nil];*/
    [kAppDelegate doneNotification:nil];


    interval = ([startDate timeIntervalSinceNow]) * 1000.0f;
    interval = abs(interval);
    //Log(@"CBGameScene: interval done: %d", interval);


    //test cloud
    [self showCloud];

    //profile
    [self resetCoinAnim:YES];


    //force pause
    [self enablePause:YES];
}

-(void) repositionAll {

    Log(@"***** receivedBanner");

    int bannerOffset = [self getBannerOffset];
    int x = self.frame.size.width/2;
    int y = [self getBlockY];

    self.block.position = CGPointMake(x, y);

    self.menuButton.position = CGPointMake(25, self.size.height - 40);

    CGPoint center = CGPointMake(self.size.width/2, self.size.height/2);
    self.bgImage.position = center;
    self.bgImage2.position = center;
    self.bgOverlay.position = center;
    self.buffBorder.position = center;
    self.buffBg.position = center;

    //curtains
    //move curtains
    //self.curtainLeft.hidden = NO;
    //self.curtainLeft.alpha = 1.0f;
    //self.curtainRight.hidden = NO;
    //self.curtainRight.alpha = 1.0f;
    float curtainWidth = self.curtainLeft.frame.size.width;
    //start
    self.curtainLeft.position = CGPointMake(curtainWidth/2, self.view.bounds.size.height - self.curtainLeft.frame.size.height/2);
    self.curtainRight.position = CGPointMake(self.view.bounds.size.width - curtainWidth/2, self.view.bounds.size.height - self.curtainRight.frame.size.height/2);


    //count
    [self repositionCount];

    //count coin
    BOOL shouldSpin = YES;

    NSString *coinName = [CBSkinManager getCoinBarImageName];

    //test frame 2?
    UIImage *testImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame2", coinName]];
    if (testImage) {
        shouldSpin = NO;
    }

    [self.countCoin removeAllActions];
    float coinScale = 0.6f; //0.5f
    self.countCoin.xScale = self.countCoin.yScale = coinScale;
    SKAction *coinAnim = nil;

    if(shouldSpin) {
        //set 1st frame
        coinAnim = [SKAction setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]]];
        [self.countCoin runAction:coinAnim];

        //spin scale
        SKAction* actionSpin1 = [SKAction scaleXTo:coinScale duration:kCoinSpinScaleDuration];
        SKAction* actionSpin2 = [SKAction scaleXTo:-coinScale duration:kCoinSpinScaleDuration];
        coinAnim = [SKAction sequence:@[actionSpin1, actionSpin2]];

        //loop
        coinAnim = [SKAction repeatActionForever:coinAnim];
        [self.countCoin runAction:coinAnim];
    }
    else {

        //NSString *coinName = [CBSkinManager getCoinImageName];

        float coinAnimRate = kCoinAnimRate;

        coinAnim = [SKAction animateWithTextures:@[
                                                   [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]],
                                                   [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame2", coinName]],
                                                   [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame3", coinName]],
                                                   [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame4", coinName]],
                                                   [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]]]
                                    timePerFrame:coinAnimRate];

        //loop
        coinAnim = [SKAction repeatActionForever:coinAnim];

        [self.countCoin runAction:coinAnim];

    }



    [self repositionComboLabel];

    float shadowOffset;

    self.levelLabel.position = CGPointMake(self.frame.size.width/2, 68 + bannerOffset + [self getIPhoneXBottom]);
    shadowOffset = 1;


    self.worldNameLabel.position = CGPointMake(self.levelLabel.position.x, self.levelLabel.position.y + 32);



    //offset for square on left
    self.speedLabel.position = CGPointMake(self.countlabel.position.x - 38 , self.countlabel.position.y -
                                           ([kHelpers isIphone4Size]?44:54));
    shadowOffset = 1;

    self.numFireballLabel.position = CGPointMake(10, 16);
    shadowOffset = 1;


    //self.timeLabel.position = CGPointMake(self.frame.size.width-66, self.frame.size.height-22);
    self.timeLabel.position = CGPointMake(self.frame.size.width-36, self.frame.size.height-22);
    shadowOffset = 1;

    self.clock.position = CGPointMake(self.timeLabel.position.x - 27, self.timeLabel.position.y - 1);

    //combo mult
    self.multLabel.position = CGPointMake(self.speedLabel.position.x - 38, self.speedLabel.position.y - 24); //33
    shadowOffset = 1;

    //combo arrows
    self.comboArrow1.zPosition = self.multLabel.zPosition;
    self.comboArrow2.zPosition = self.comboArrow1.zPosition;
    self.comboArrow3.zPosition = self.comboArrow1.zPosition;
    self.comboArrow1.position = CGPointMake(self.multLabel.position.x+50, self.multLabel.position.y-1); //62, 65
    self.comboArrow2.position = CGPointMake(self.comboArrow1.position.x+18, self.comboArrow1.position.y);
    self.comboArrow3.position = CGPointMake(self.comboArrow2.position.x+18, self.comboArrow1.position.y);

    //center
    self.warning.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);

    //self.bigLevelLabel2.position = CGPointMake(self.frame.size.width/2 - 10, self.frame.size.height/2 - 80);

    self.backBottom.position = CGPointMake(0,bannerOffset + [self getIPhoneXBottom]);
    //self.bar.position = CGPointMake(self.frame.size.width/2, 26 + bannerOffset + [self getIPhoneXBottom]); //???
    //self.bar.position = CGPointMake([kHelpers getScreenRect].size.width/2, 26 + bannerOffset + [self getIPhoneXBottom]);
    self.bar.position = CGPointMake(0, 26 + bannerOffset + [self getIPhoneXBottom]);

    //self.barBack.position = self.bar.position;
    self.barBack.position = CGPointMake([kHelpers getScreenRect].size.width/2, self.bar.position.y);

    //self.backTop.position = CGPointMake(0,self.frame.size.height + kStatusBarOffset - [self getIPhoneXTop]);
    self.backTop.position = CGPointMake(0,self.frame.size.height + kStatusBarOffset);

    float insideOffset = 0;
    self.barFill.position = CGPointMake(0, self.bar.position.y);

    insideOffset = 1;

    self.barIcon.position = CGPointMake(self.barFill.position.x + self.barFill.size.width, self.barFill.position.y);


    self.barHelp.position = CGPointMake(3 + [kHelpers getScreenRect].size.width - 20, self.bar.position.y + 20);
    self.barCastle.position = CGPointMake(3 + [kHelpers getScreenRect].size.width - 35, self.bar.position.y + 2);

    //labels

    //label under bar
    //self.barLabel.position = CGPointMake(self.bar.position.x, self.bar.position.y - 32); //-24
    self.barLabel.position = CGPointMake([kHelpers getScreenRect].size.width/2, self.bar.position.y - 32); //-24

    //bottom right
    //self.comboLabelScore.position = CGPointMake(self.frame.size.width - 10, self.numFireballLabel.position.y);
    self.comboLabelScore.position = CGPointMake(self.frame.size.width - 10, self.barLabel.position.y);

    shadowOffset = 1;


    self.ray1.position = CGPointMake(self.block.position.x, self.block.position.y);

    //walls
    /*if(NO) {
        CGRect physicsRect = self.frame;
        physicsRect.size.height -= 45; //self.backTop.frame.size.height;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:physicsRect];
    }*/

    //door
    //self.door.position = self.block.position;

    //force
    [self updateLevelBar:NO];
}

-(void)repositionCount {

    //self.countlabel.position = CGPointMake(self.frame.size.width/2 + 10, self.frame.size.height - 94);
    self.countlabel.position = CGPointMake(self.frame.size.width/2 + 40, self.frame.size.height - 94 - [self getIPhoneXTop]);

    //int shadowOffset = 3; //2;

    // X

    float countOffset = 0.0f;
    if((int)kAppDelegate.clickCount >= 1000)
        countOffset = 4.0f; //offset for ","

    //right
    //self.countlabelX.position = CGPointMake(self.countlabel.position.x + self.countlabel.frame.size.width/2 + 20, self.countlabel.position.y + countOffset);

    //left
    self.countlabelX.position = CGPointMake(self.countlabel.position.x - self.countlabel.frame.size.width/2 - 20, self.countlabel.position.y + countOffset);


    //X coin
    //[self.countCoin removeAllActions];
    //self.countCoin.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", [CBSkinManager getCoinBarImageName]]];

    //right
    //self.countCoin.position = CGPointMake(self.countlabelX.position.x + self.countlabelX.frame.size.width/2 + 22, self.countlabelX.position.y);

    //left
    self.countCoin.position = CGPointMake(self.countlabelX.position.x - self.countlabelX.frame.size.width/2 - 22, self.countlabelX.position.y);

}

-(void)repositionComboLabel
{
    //[self.comboLabel removeAllActions];
    //[self.comboLabelShadow removeAllActions];

    //top left of block
    //self.comboLabel.position = CGPointMake(52, self.frame.size.height - 178);

    //under block
    int x = self.frame.size.width/2;
    int y = [self getBlockY];
    y -= 80;

    //top left
    //int x = 80;
    //int y = self.frame.size.height - 230;
    //int y = [self getBlockY];

    self.comboLabel.position = CGPointMake(x, y + 10); //center



    /*NSArray *positionArray = @[
                               [NSValue valueWithCGPoint:CGPointMake(64, self.frame.size.height - 124)],
                               ];
    self.comboLabel.position = [[positionArray randomObject] CGPointValue];
    */

    self.rayCombo.position = self.comboLabel.position;
    self.touchCombo.position = self.comboLabel.position;
}


- (void)showBanner {

    [kAppDelegate.gameController showBanner];
}

- (void)hideBanner {

    [kAppDelegate.gameController hideBanner];
}

- (void)toggleBanner {

    [kAppDelegate.gameController toggleBanner];
}

- (void)resetCoinAnim:(BOOL)animate {

    //UIImage *imageBorder = [UIImage imageNamed:@"profile_border"];
    UIImage *image = nil;

    //profile
    UIImage *imageProfile = kAppDelegate.profileImage;
    if(imageProfile) {
        //custom
    }
    else {
        //placeholder
        //imageProfile = [UIImage imageNamed:@"profile_placeholder"];
        //coin
        imageProfile = [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame1", [CBSkinManager getCoinBarImageName]]];
    }

    int imageSize = 40;// imageProfile.size.width;

    //circle
    //UIImage *image = [kHelpers circularScaleAndCropImage:imageProfile frame:CGRectMake(0,0,imageSize, imageSize )];
    image = [kHelpers imageByScalingForSize:CGSizeMake(imageSize, imageSize) withImage:imageProfile];

    //border
    //image = [UIImage mergeImage:image withImage:imageBorder];
    //border under
    //image = [UIImage mergeImage:imageBorder withImage:image];

    self.barIcon.texture = [SKTexture textureWithImage:image];
    //self.barIconRewind.texture = [SKTexture textureWithImage:image];


    //animate bar icon

    //NSString *coinName = [CBSkinManager getCoinImageName];
    NSString *coinName = [CBSkinManager getCoinBarImageName]; //first

    BOOL shouldSpin = YES;
    //test frame 2?
    UIImage *testImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame2", coinName]];
    if (testImage) {
        shouldSpin = NO;
    }

    SKAction *coinAnim = nil;


    //all
    [self.barIcon removeAllActions];

    self.barIcon.xScale = self.barIcon.yScale = 1.0f;

    if(shouldSpin) {
        //set 1st frame
        coinAnim = [SKAction setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]]];
        [self.barIcon runAction:coinAnim];

        //spin scale
        SKAction* actionSpin1 = [SKAction scaleXTo:1.0f duration:kCoinSpinScaleDuration];
        SKAction* actionSpin2 = [SKAction scaleXTo:kCoinSpinScaleMin duration:kCoinSpinScaleDuration];
        coinAnim = [SKAction sequence:@[actionSpin1, actionSpin2]];

        //loop
        coinAnim = [SKAction repeatActionForever:coinAnim];
        [self.barIcon runAction:coinAnim];

    }
    else {

        //NSString *coinName = [CBSkinManager getCoinImageName];

        float coinAnimRate = kCoinAnimRate;

        coinAnim = [SKAction animateWithTextures:@[
                                                   [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]],
                                                   [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame2", coinName]],
                                                   [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame3", coinName]],
                                                   [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame4", coinName]],
                                                   [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]]]
                                    timePerFrame:coinAnimRate];

        //loop
        coinAnim = [SKAction repeatActionForever:coinAnim];

        [self.barIcon runAction:coinAnim];

    }



    //star anim
    [self.barIconRewind removeAllActions];

    //spin scale
    SKAction* actionSpin1 = [SKAction scaleXTo:kRewindScale duration:kRewindSpinScaleDuration];
    SKAction* actionSpin2 = [SKAction scaleXTo:-kRewindScale duration:kRewindSpinScaleDuration];
    coinAnim = [SKAction sequence:@[actionSpin1, actionSpin2]];

    //loop
    coinAnim = [SKAction repeatActionForever:coinAnim];
    [self.barIconRewind runAction:coinAnim];
}

- (void)updateBlockAnim
{
    NSString *blockName = [CBSkinManager getBlockImageName];
    if([blockName isEqualToString:@"block14Frame1"])
    {
        //only hacker
        NSArray *textures =  @[
                              [SKTexture textureWithImageNamed:@"block14Frame1"],
                              [SKTexture textureWithImageNamed:@"block14Frame2"],
                              [SKTexture textureWithImageNamed:@"block14Frame3"],
                              [SKTexture textureWithImageNamed:@"block14Frame4"],
                              ];

        //SKTexture  *texture = [textures randomObject]; //random
        SKTexture  *texture = [textures objectAtIndex:self.currentBlockFrame]; //next

        [self.block removeActionForKey:@"animationFrames"];

        //next
        [self.block setTexture:texture];

        self.currentBlockFrame++;
        if(self.currentBlockFrame >= textures.count)
            self.currentBlockFrame = 0;
    }
}

- (void)resetBlockAnim:(BOOL)animate {

    float blockAnimRate = 0.1f;

    NSString *blockName = [CBSkinManager getBlockImageName];
    UIImage *blockImage = [UIImage imageNamed:blockName];

    //shine
    NSString *shineName = [kAppDelegate getBlockShineImageName];

    //disable for emoticon, circle
    //disable for hacker, more block frames
    if([shineName isEqualToString:@"block_shine2"] || [blockName isEqualToString:@"block14Frame1"])
    {
        shineName = nil;
        //return;
    }

    UIImage *frame1 = [UIImage mergeImage:blockImage withImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Frame1", shineName]]];
    UIImage *frame2 = [UIImage mergeImage:blockImage withImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Frame2", shineName]]];
    UIImage *frame3 = [UIImage mergeImage:blockImage withImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Frame3", shineName]]];
    UIImage *frame4 = [UIImage mergeImage:blockImage withImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Frame4", shineName]]];

    SKAction *blockAnim = [SKAction animateWithTextures:@[
                                                [SKTexture textureWithImage:frame1],
                                                [SKTexture textureWithImage:frame2],
                                                [SKTexture textureWithImage:frame3],
                                                [SKTexture textureWithImage:frame4],
                                                [SKTexture textureWithImage:frame1]]
                                                     timePerFrame:blockAnimRate];

    /*SKAction *blockAnim = [SKAction animateWithTextures:@[
                                                [SKTexture textureWithImageNamed:[CBSkinManager getBlockImageName]],
                                                [SKTexture textureWithImageNamed:[CBSkinManager getBlockImageName]],
                                                [SKTexture textureWithImageNamed:[CBSkinManager getBlockImageName]],
                                                [SKTexture textureWithImageNamed:[CBSkinManager getBlockImageName]],
                                                [SKTexture textureWithImageNamed:[CBSkinManager getBlockImageName]]]
                                           timePerFrame:blockAnimRate];*/

    float waitBetweenShines = 2.0f; //1.0f;
    SKAction *blockWait = [SKAction waitForDuration:waitBetweenShines];
    SKAction *blockSequence = [SKAction sequence:@[blockWait, blockAnim]];

    //force 1st frame
    [self.block setTexture:[SKTexture textureWithImage:frame1]]; //first frame


    [self.block removeActionForKey:@"animationFrames"];

    //hacker
    /*if([blockName isEqualToString:@"block14Frame1"])
    {
        blockAnim = [SKAction animateWithTextures:@[
                                                        [SKTexture textureWithImageNamed:@"block14Frame1"],
//                                                        [SKTexture textureWithImageNamed:@"block14Frame2"],
//                                                        [SKTexture textureWithImageNamed:@"block14Frame3"],
//                                                        [SKTexture textureWithImageNamed:@"block14Frame4"],
                                                        ]
                                               timePerFrame:blockAnimRate];

        blockSequence = [SKAction sequence:@[blockAnim]];

    }*/

    if(animate)
        [self.block runAction:[SKAction repeatActionForever:blockSequence] withKey:@"animationFrames"];

    //reset
    self.block.alpha = 1.0f;
    CGFloat scale = [kHelpers isIphone4Size] ? 0.7f : 1.0f;
    //buff grow/shrink
    self.block.scale = scale * self.blockScale;
}


-(void)applicationEnteredBackground:(NSNotification *)notification {
	//force
	[self stopAllSounds];

    [self.soundClock stop];
    //[self.soundSad stop];

	[self.soundSpin stop];
	[self.soundComboRise stop];
}

- (void)applicationEnteredForeground:(NSNotification *)notification {
    Log(@"Application Entered Foreground");

    self.lastClickDate = [NSDate date];

    //force close alert
    if(kAppDelegate.alertView) {
    //    [kAppDelegate.alertView  dismissAnimated:YES];
    }

    //menu open, ignore
    //if([kAppDelegate.sideMenuViewController isOpen])
    //    return;

    //if(kAppDelegate.titleController.menuState != menuStateGame)
    //    return;

    [self setAllFireballsAlpha:1.0f  animated:NO];

    //show add
    //[self updateAll];

    [self checkHeartTimer];

    //update hearts
    [self setNumHearts:(int)kAppDelegate.numHearts];

    //out of lives
    if(kAppDelegate.numHearts <= 0) {
        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            [kAppDelegate.alertView dismissAnimated:NO];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [kAppDelegate.gameController actionBack:nil];
        });
    }


    [self resetComboLabel];
    [self updateMult:NO];

    //sounds
    [self loadSounds];

	//force
	[self stopAllSounds];
}

-(void) resetParticles {
    //disable
    //return;

    //reset fireball/star particles
    for(SKNode* child in self.children) {
        if([child.name isEqualToString:@"particle"])
            [self removeChildrenInArray:@[child]];
    }
}

-(void)updateBackgrounds
{
    //reset
    self.bgArray = [NSMutableArray array];


    //update available backgrounds
    int max = 5; //start at 5

    //1 new bg per level
    max += kAppDelegate.level;

    if(max > kNumBackgrounds)
        max = kNumBackgrounds;


    for(int i = 1; i<=max; i++)
    {
        if(i==10)
        {
            //ignore castle
        }
        else
        {
            BOOL premium = [kAppDelegate isPremium];
            if(!premium &&
               (
                   i == 4 //aurora
                || i == 11 //water beige sky
                || i == 16 //sf bridge
                || i == 21 //blur date
                || i == 28 //rain
                || i == 32 //tron1
                || i == 33 //tron2
                )
               )
            {
                //skip
                continue;
            }

            NSString *bgName = [NSString stringWithFormat:@"background%d", i];
            SKTexture *texture = [SKTexture textureWithImageNamed:bgName];

            [self.bgArray addObject:texture];
        }
    }

    //castle
    NSString *bgName = [NSString stringWithFormat:@"background%d", 10];
    SKTexture *texture = [SKTexture textureWithImageNamed:bgName];
    self.bgCastle = texture;
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"background10-2"];
    self.bgCastle2 = texture2;

	//bgCastle3, mario dungeon?
	//https://www.spriters-resource.com/snes/supermariobros3/sheet/65545/
}

-(void)hideRainbow
{
    if(self.rainbow.hidden)
        return;

    [self.rainbow runAction:[SKAction fadeOutWithDuration:2.0f] completion:^{ //0.1f
        self.rainbow.hidden = YES;
    }]; //fade
}

-(void)updateRainbow
{
    //if(kAppDelegate.subLevel == 4 || kAppDelegate.level <= 1)
    if(kAppDelegate.subLevel == 4)
    {
        //no rainbow in x-4
        [self hideRainbow];
        return;
    }

    [self.rainbow removeAllActions];
    self.rainbow.hidden = NO;

    CGFloat alpha = 0.0f;

    CGFloat maxCount = 50; //100
    //CGFloat maxCount = (kAppDelegate.level * 10)-1;
    alpha = self.comboCount/maxCount;
    CGFloat maxApha = 0.8f;
    if(alpha > maxApha)
        alpha = maxApha;

    //force
    //alpha = maxApha;

    [self.rainbow runAction:[SKAction fadeAlphaTo:alpha duration:0.1f] completion:^{
    }]; //fade

    //self.rainbow.alpha = alpha;
}

-(void) updateAll {

    Log(@"***** updateAll");
   // if(self.sharing)
    //    return;

    //self.blockScale = [kHelpers isIphone4Size] ? 0.7f : 1.0f;
    //self.block.scale = self.blockScale;
    //[self.block runAction:[SKAction scaleTo:self.blockScale duration:kBlockGrowDuration]];

    self.dying = NO;
    self.hidingLava = NO;

    [self hidePowerup];

	[self hideKey];

    [self updateRainbow];

    [self hideInk];

	[self hideWeakSpot:NO];

    [self hideLava:NO];


    //buff
    if(kAppDelegate.currentBuff == kBuffTypeNone)
    {
        [self hideBuff];
    }
    else
    {
        [self showBuff:kAppDelegate.currentBuff resetTime:NO];
    }

    [self hideWeakSpot:NO];


    //nav lock
    //self.navLock.hidden = (kAppDelegate.level > 1);

    //bar bg
    if(kAppDelegate.level > kLevelMax)
        self.barBack.texture = [SKTexture textureWithImageNamed:@"barBack2"]; //minus
    else
        self.barBack.texture = [SKTexture textureWithImageNamed:@"barBack"]; //regular

    //combo arrows

    if (kAppDelegate.level <= 1)
    {
      //hide a bit
      self.comboArrow1.alpha = self.comboArrow2.alpha = self.comboArrow3.alpha = 0.3f;
    }
    else
    {
      //normal
      self.comboArrow1.alpha = self.comboArrow2.alpha = self.comboArrow3.alpha = 1.0f;
    }

	//re-enable square
    [self.navSquare enable:YES];
    [self.imageSquare enable:YES];

    //hide touch
    [self.touch removeAllActions];
    self.touch.hidden = YES;

    self.heartPlus.hidden = [kAppDelegate isPremium];

	self.weakSpotMult = 1.0f;

    //self.winning = NO;
    self.blockDisabled = NO;

    [self updateBackgrounds];

    //square, hide at level 1
    self.navSquare.hidden = NO; //kAppDelegate.level <= 1;

    kAppDelegate.adBannerEnabledTemp = YES;

    [self resetComboLabel];
    [self updateMult:NO];

    [self updatePotion:NO];

    //self.winning = NO;

    //mark as read
    [kAppDelegate.dicSkinNew setObject:@(NO)forKey:[CBSkinManager getSkinKey:(int)[kAppDelegate getSkin]]];

    self.lastClickDate = [NSDate date];

    [self.physicsWorld setSpeed:kPhysicsWorldSpeed]; //1.5f;

    [kAppDelegate.gameController updateButtons];

    [self setSoundVolume];

    [self resetParticles];
    [self resetTimer];

    [self updateLevelBar:NO];
    [self updateLevelLabel:NO];
    [self updateCountLabel:NO];
    [self updateWorldName];

    //always
    [self updateWorldName];

#if 0
    //castle
    NSMutableArray *castleArray = [@[
                             @(1), //disney
                             @(2), //house
                             ] mutableCopy];

    NSArray *castleArray2 = @[
                             @(5), //mario
                             @(6), //red door
                             @(9), //dr wily skull
                             ];

    if(kAppDelegate.inReview && kAppDelegate.level >= kStoryLevel1) //after level 4
    {
        [castleArray addObjectsFromArray:castleArray2];
    }


    int oldCastle = (int)kAppDelegate.currentCastle;

    kAppDelegate.currentCastle = [[castleArray randomObject] intValue];

    if(kAppDelegate.currentCastle == oldCastle) {
        //same? random again
        kAppDelegate.currentCastle = [[castleArray randomObject] intValue];
    }

    //force
    if(kAppDelegate.level <= 1) {
        kAppDelegate.currentCastle = 1;
    }

    //test
    //kAppDelegate.currentCastle = 9;

    self.barCastle.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"help_castle%d", (int)kAppDelegate.currentCastle]];
#endif

    //castle chest, animated
    SKAction *keyAnim = [SKAction animateWithTextures:@[
                                                        //[SKTexture textureWithImageNamed:@"chest"],
                                                        [SKTexture textureWithImageNamed:@"chest2"],
                                                        [SKTexture textureWithImageNamed:@"chest3"],
                                                        ] //chest
                                         timePerFrame:0.1f];
    keyAnim = [SKAction repeatActionForever:keyAnim];
    [self.barCastle runAction:keyAnim];


    //show star, fireball
    int numFireballs = kAppDelegate.fireballVisible; //last count
    //int numFireballs = [kAppDelegate getMaxFireballs]; //max

    //freeze fire
    [self freezeAllFireballs];

    //hide all fire
    [self hideAllFireballs:NO];


    SKAction *showFireballAction = [SKAction runBlock:^{

        //only 1 sound
        //if(kAppDelegate.titleController.menuState == menuStateGame)
        //    [self playSound:self.soundFireballAppear];

        //kAppDelegate.fireballVisible = 0;
        for(int i=0;i<numFireballs;i++) {
            float secs = i * 0.1f;
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
             //   [self showFireball:YES];
            //});

            SKAction *tempAction = [SKAction runBlock:^{
                [self showFireball:YES];
            }];

            //no delay
            //secs = 0;
            [self runAction:tempAction afterDelay:secs];
        }

    }];
    [self runAction:showFireballAction afterDelay:0.3f];


    kAppDelegate.fireballVisible = 0;


    //hide square
    [self hideImageSquare]; //breaks reward

    //plus
    /*if(kAppDelegate.level > 1)
    {
        //don't show if powerup is visible
        if(kAppDelegate.powerupVisibleType == kPowerUpTypeNone)
            [self showNavPlus];
    }*/

    //fireballs
    [self setAllFireballsAlpha:1.0f animated:NO];


    //touch anims
    [self.touch removeAllActions];
    //self.touch.hidden = YES;
    [self.touchStar removeAllActions];
    //self.touchStar.hidden = YES;
    [self.touchFireball removeAllActions];
    //self.touchFireball.hidden = YES;

    //hearts

    //if([kHelpers isDebug])  //debug reset
    //    kAppDelegate.numHearts = kHeartFull;
    [self setNumHearts:(int)kAppDelegate.numHearts];
    [self checkHeartTimer];

    //bg
    NSString *bgName = [CBSkinManager getSkinBackground:YES]; //random
    if(kAppDelegate.level == kLevelMax)
    {
        //force last level bg
        bgName = [CBSkinManager getSkinBackgroundIndex:kCoinTypeBrain];
    }

    if(bgName) {
        self.bgSpecial = [SKTexture textureWithImageNamed:bgName];

        self.bgArray2 = [NSMutableArray array];

        int bgAdd = 10;
        for(int i=0; i< bgAdd; i++) {
            [self.bgArray2 addObject:self.bgSpecial];
        }
    }
    else {
        self.bgArray2 = [NSMutableArray array];
        self.bgSpecial = nil;
    }

    //help bubble
    [self updateHelpButton];

    //bg
    if((int)kAppDelegate.clickCount == 0) {
        //first time
        //NSString *bgName = @"background1";
        //self.bgImage.texture = [SKTexture textureWithImageNamed:bgName];
        self.bgImage.texture = [self.bgArray firstObject];

    }
    else {
        //force skin image on appear, but not if castle
        if(kAppDelegate.subLevel == 4) {
            self.bgImage.texture = self.bgCastle;
        }
        else {
            NSString *bgName = [CBSkinManager getSkinBackground:YES]; //random

            if(kAppDelegate.level == kLevelMax)
            {
                //force last level bg
                bgName = [CBSkinManager getSkinBackgroundIndex:kCoinTypeBrain];
            }

            if(bgName)
                self.bgImage.texture = [SKTexture textureWithImageNamed:bgName];
            else
                self.bgImage.texture = [self getRandomBackground];
        }
    }

    [self repositionAll];

    self.block.colorBlendFactor = 0.0f;

    [self resetBlockAnim:YES];

    [self resetCoinAnim:YES];

    //stars
    //self.lastStarDate = [NSDate date];

    [self loadCustomSounds];

    //profile
    [self resetCoinAnim:YES];


    //rec
    if([kAppDelegate getSkin] == kCoinTypePew)
        self.rec.hidden = NO;
    else
        self.rec.hidden = YES;
}

-(SKTexture*)getRandomBackground {

    //Log(@"getRandomBackground");

    SKTexture *bgTexture  = nil;
    if(kAppDelegate.level == kLevelMax)
    {
        //force last level bg
        bgTexture = [SKTexture textureWithImageNamed:[CBSkinManager getSkinBackgroundIndex:kCoinTypeBrain]];
    }
    else
    {
        bgTexture = [[self.bgArray arrayByAddingObjectsFromArray:self.bgArray2] randomObject];
    }

    return bgTexture;
}

-(void) loadCustomSounds
{
    if(self.lastSkin == [kAppDelegate getSkin])
        return;

    self.lastSkin = (int)[kAppDelegate getSkin];

    //reset coin sound

    int maxPolyphony = 5;
    if([kHelpers isSlowDevice])
        maxPolyphony = 2;

    NSError *error = nil;
    //FISoundEngine *engine = [FISoundEngine sharedEngine];
    CBAppDelegate *engine = kAppDelegate;

    NSString *soundName =[CBSkinManager getCoinSoundNameIndex:(int)[kAppDelegate getSkin] which:0];
    self.soundCoin = [engine soundNamed:soundName maxPolyphony:maxPolyphony error:&error];
    if (!self.soundCoin) {
        Log(@"Failed to load sound: %@", error);
    }

    soundName =[CBSkinManager getCoinSoundNameIndex:(int)[kAppDelegate getSkin] which:1];
    self.soundCoin2 = [engine soundNamed:soundName maxPolyphony:maxPolyphony error:&error];
    /*if (!self.soundCoin2) {
        Log(@"Failed to load sound: %@", error);
    }*/

    soundName =[CBSkinManager getCoinSoundNameIndex:(int)[kAppDelegate getSkin] which:2];
    self.soundCoin3 = [engine soundNamed:soundName maxPolyphony:maxPolyphony error:&error];
    /*if (!self.soundCoin3) {
        Log(@"Failed to load sound: %@", error);
    }*/

    soundName = [CBSkinManager getFireClickSoundName:0];
    self.soundFireballClick = [engine soundNamed:soundName maxPolyphony:maxPolyphony error:&error];
    if (!self.soundFireballClick) {
        Log(@"Failed to load sound: %@", error);
    }

    soundName = [CBSkinManager getFireClickSoundName:1];
    self.soundFireballClick2 = [engine soundNamed:soundName maxPolyphony:maxPolyphony error:&error];
    if (!self.soundFireballClick2) {
        Log(@"Failed to load sound: %@", error);

    }

    soundName = [CBSkinManager getStarClickSoundName];
    self.soundStarClick2 = [engine soundNamed:soundName maxPolyphony:maxPolyphony error:&error];
    if (!self.soundStarClick2) {
        //Log(@"Failed to load sound: %@", error);
    }


    [self setSoundVolume];

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    //Log(@"touchBegan");
    BOOL showTouch = YES;
    CGPoint point = [[touches anyObject] locationInNode:self];

    self.lastClickPosition  = point;

    SKNode* tempNode = [self nodeAtPoint:point];
    if(!tempNode) {
        //Log(@"touchBegan: return");
        return;
    }

    //Log(@"touchBegan: check");

    if([tempNode.name isEqualToString:@"weakSpot"]) {
        [self touchedWeakSpot];
    }
    else if([tempNode.name isEqualToString:@"block"] || [tempNode.name isEqualToString:@"tutoArrowBlock"]) {
        [self touchedBlock:(SKSpriteNode*)tempNode];
    }
    else if([tempNode.name contains:@"toastie"]) {
        [self touchedToastie];
    }
    else if([tempNode.name contains:@"key"]) {
        [self touchedKey];
    }

    else if([tempNode.name isEqualToString:@"navSquare"] || [tempNode.name isEqualToString:@"navPlus"] || [tempNode.name isEqualToString:@"tutoArrowSquare"]) {
        //showTouch = NO;
        [self touchedNavSquare];
    }

    else if([tempNode.name isEqualToString:@"potion"] || [tempNode.name isEqualToString:@"potionPlus"] || [tempNode.name isEqualToString:@"tutoArrowPotion"]) {
        [self touchedPotion];
    }

    //powerups
    /*else if([tempNode.name isEqualToString:kPowerUpNameStar]) {
        [self touchedPowerup:tempNode];
    }
	else if([tempNode.name isEqualToString:kPowerUpNameBomb]) {
        [self touchedPowerup:tempNode];
    }
    else if([tempNode.name isEqualToString:kPowerUpNameHeart]) {
        [self touchedPowerup:tempNode];
    }
    else if([tempNode.name isEqualToString:kPowerUpNamePotion]) {
        [self touchedPowerup:tempNode];
    }
    else if([tempNode.name isEqualToString:kPowerUpNameShield]) {
        [self touchedPowerup:tempNode];
    }
    else if([tempNode.name isEqualToString:kPowerUpNameDoubler]) {
        [self touchedPowerup:tempNode];
    }*/
    else if([tempNode.name contains:@"powerup_"]) {
        [self touchedPowerup:(SKSpriteNode*)tempNode];
    }

    else if([tempNode.name isEqualToString:@"lava"]) {
        [self touchedLava];
    }

    else if([tempNode.name isEqualToString:@"buff"] || [tempNode.name isEqualToString:@"buffSquare"]) {
        [self touchedBuff];
    }

    else if([tempNode.name contains:@"spike"]) {
        [self touchedSpike:(SKSpriteNode*)tempNode];
    }

    else if([tempNode.name isEqualToString:@"door"]) {
        [self touchedDoor];
    }
    else if([tempNode.name isEqualToString:@"barHelp"]) {
        [self touchedBarHelp];
    }
    else if([tempNode.name isEqualToString:@"barCastle"]) {
        [self touchedBarHelp];
    }
    else if([tempNode.name contains:@"fireballAppear"]) {
        int which = [[tempNode.userData objectForKey:@"which"] intValue];

        [self touchedFireball:which node:(SKSpriteNode*)tempNode];
    }

    else if([tempNode.name contains:@"heartTop4"] || [tempNode.name contains:@"heartPlus"]) {

		if(![kAppDelegate isPremium])
    	    [self touchedHeartTopVIP];
    }
    else if([tempNode.name contains:@"heart"]) {
        [self touchedHeartTop];
    }
    /*else if([tempNode.name isEqualToString:@"ink"]) {
        [self touchedInk];
    }*/
    else if([tempNode.name contains:@"background"]) {

        [self touchedBackground];
    }
    else
    {
        Log(@"touchesBegan: %@", tempNode.name);
    }

    //show position
    if(showTouch) {
        //Log(@"showTouch");

        CGPoint touchPoint = point;
        //random offset
        float randomOffsetVal = 10.0f;
        float randomOffset = -randomOffsetVal + arc4random_uniform(randomOffsetVal*2);
        touchPoint.x += randomOffset;
        randomOffset = -randomOffsetVal + arc4random_uniform(randomOffsetVal*2);
        touchPoint.y += randomOffset;

        [self.touch removeAllActions];
        self.touch.hidden = NO;
        self.touch.alpha = 0.6f;
        self.touch.scale = 1.0f;
        self.touch.position = touchPoint;
        self.touch.zPosition = self.scanline.zPosition-1;

        float duration = 0.6f;
        [self.touch runAction:[SKAction fadeOutWithDuration:duration]]; //fade
        [self.touch runAction:[SKAction scaleBy:2.0f duration:duration]]; //scale
    }
}

- (SKNode *)nodeAtPoint:(CGPoint)p {

    SKNode *node =  [self nodeAtPointWithUserInteractionEnabledAlgorithm2:p];
    return node;
}

//overwrite?
- (SKNode *)nodeAtPointWithUserInteractionEnabledAlgorithm2:(CGPoint)p
{
    NSArray* nodesAtPoint = [self nodesAtPoint:p];

    //filter out no interfaction
    NSMutableArray *tempArray = [NSMutableArray array];
    for(SKNode *tempNode in nodesAtPoint) {

        NSString *name = tempNode.name;

        if(![name contains:@"_ignore"]) {

            //fireball, but timer, ignore
            if([name contains:@"fireball"]) {

                //delay click
                float interval = kToucheFireballDelay;
                if(self.lastClickFireballDate && [[NSDate date] timeIntervalSinceDate:self.lastClickFireballDate] <  interval) {
                    //skip
                    continue;
                }
            }
            [tempArray addObject:tempNode];
        }
        else {
            //Log(@"sprite '%@' ignored", name);
        }
    }

    //replace
    nodesAtPoint = tempArray.copy;
    nodesAtPoint = [nodesAtPoint sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

        SKNode* n1 = obj1;
        SKNode* n2 = obj2;

        if (n1.userInteractionEnabled && !n2.userInteractionEnabled)
        {
            return NSOrderedAscending;
        }
        else if (!n1.userInteractionEnabled && n2.userInteractionEnabled)
        {
            return NSOrderedDescending;
        }
        else
        {
            CGFloat n1ZPosition = [n1 calculateAccumulatedZPosition];
            CGFloat n2ZPosition = [n2 calculateAccumulatedZPosition];

            if (n1ZPosition > n2ZPosition)
            {
                return NSOrderedAscending;
            }
            else if (n1ZPosition < n2ZPosition)
            {
                return NSOrderedDescending;
            }
            else
            {
                if ([n1 inParentHierarchy:n2])
                {
                    return NSOrderedAscending;
                }
                else if ([n2 inParentHierarchy:n1])
                {
                    return NSOrderedDescending;
                }
                else
                {
                    SKNode* parent = n1.parent;
                    if (n2.parent != parent)
                    {
                        return NSOrderedSame;
                    }
                    else
                    {
                        NSArray* parentChildren = parent.children;

                        NSInteger n1Idx = [parentChildren indexOfObject:n1];
                        NSInteger n2Idx = [parentChildren indexOfObject:n2];

                        if (n2Idx == NSNotFound)
                        {
                            return NSOrderedAscending;
                        }
                        else if (n1Idx == NSNotFound)
                        {
                            return NSOrderedDescending;
                        }
                        else
                        {
                            if (n1Idx < n2Idx)
                            {
                                return NSOrderedDescending;
                            }
                            else if (n1Idx > n2Idx)
                            {
                                return NSOrderedAscending;
                            }
                            else
                            {
                                return NSOrderedSame;
                            }
                        }
                    }
                }
            }
        }
    }];

    return [nodesAtPoint firstObject] ?: self;
}


-(void)update:(CFTimeInterval)currentTime {
}

/*-(uint64_t) getTickCount
{
    static mach_timebase_info_data_t sTimebaseInfo;
    uint64_t machTime = mach_absolute_time();

    // Convert to nanoseconds - if this is the first time we've run, get the timebase.
    if (sTimebaseInfo.denom == 0 )
    {
        (void) mach_timebase_info(&sTimebaseInfo);
    }

    // Convert the mach time to milliseconds
    uint64_t millis = ((machTime / 1000000) * sTimebaseInfo.numer) / sTimebaseInfo.denom;
    return millis;
}*/


- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    //NSInteger hours = (ti / 3600);

    //NSString *format = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
    NSString *format = [NSString stringWithFormat:@"%d minutes\n%d seconds", (int)minutes, (int)seconds];

    return format;
}


-(void)showPotionPlus
{
    if(![kHelpers checkOnline])
        return;

	[self.potionPlus removeAllActions];

	self.potionPlus.hidden = NO;
	CGFloat plusAlphaIn = 1.0f;
	CGFloat plusAlphaOut = 0.8f;
	CGFloat plusFadeDuration = 0.2f;
	CGFloat plusScale = 1.2f;
	CGFloat plusScaleOld = 0.9f;
	CGFloat waitDuration = 1.0f;

	[self.potionPlus runAction:[SKAction fadeAlphaTo:plusAlphaIn duration:plusFadeDuration] completion:^{
		//pulse forever?
		SKAction *fadeIn = [SKAction fadeAlphaTo:plusAlphaIn duration:plusFadeDuration];
		SKAction *fadeOut = [SKAction fadeAlphaTo:plusAlphaOut duration:plusFadeDuration];

		SKAction *scaleIn = [SKAction scaleTo:plusScale duration:plusFadeDuration];
		SKAction *scaleOut = [SKAction scaleTo:plusScaleOld duration:plusFadeDuration];

		SKAction *wait = [SKAction waitForDuration:waitDuration];

		SKAction * sequenceFade = [SKAction sequence:@[wait, fadeIn, fadeOut]];
		SKAction * sequenceScale = [SKAction sequence:@[wait, scaleIn, scaleOut]];

        SKAction *group = [SKAction group:@[sequenceFade, sequenceScale]];
        [self.potionPlus runAction:[SKAction repeatActionForever:group] withKey:@"potionPlusPulse"];
	}];
}

-(void)hidePotionPlus
{
	[self.potionPlus removeAllActions];

	[self.potionPlus runAction:[SKAction fadeOutWithDuration:0.1f] completion:^{
		self.potionPlus.hidden = YES;
	}];
}

-(void)updatePotion:(BOOL)animate{

    [self.potion removeAllActions];

    if(kAppDelegate.numPotions > kMaxPotions)
        kAppDelegate.numPotions = kMaxPotions;

    self.potionLabel.text = [NSString stringWithFormat:@"%d", (int)kAppDelegate.numPotions];

    self.potion.xScale = self.potion.yScale = 1.0f;
    if(animate) {
        //scale text
        float oldScale = self.potionLabel.xScale;
        float newScale = self.potionLabel.xScale * 1.2f; //1.06f;
        float duration = 0.1f;

        //scale icon
        oldScale = self.potion.xScale;
        newScale = self.potion.xScale * 1.2f; //1.06f;
        duration = 0.1f;
        [self.potion removeAllActions];
        SKAction *actionfade0 = [SKAction scaleTo:newScale duration:duration];//in
        SKAction *actionfade1 = [SKAction waitForDuration:0.0f];
        SKAction *actionfade2 = [SKAction scaleTo:oldScale duration:duration];//out
        SKAction *fadeSequence = [SKAction sequence:@[actionfade0,actionfade1,actionfade2]];
        [self.potion runAction:fadeSequence];
    }

    //image empty or full??
    if(kAppDelegate.numPotions > 0)
    {
        [self.potion runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:kPotionImageName]]];

		if(kAppDelegate.level > 1)
		{
			//plus
			[self hidePotionPlus];
		}
    }
    else
    {
        [self.potion runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:kPotionEmptyImageName]]];


		if(kAppDelegate.level > 1)
        {
			//plus
			[self showPotionPlus];
        }
    }

}

-(void)updateCountLabel:(BOOL)animate{

	double newCount = kAppDelegate.clickCount;

    //force
    //newCount = 999999999;
    //newCount = 9;


    float fontSize = 1.0;
    if(newCount >=99999999)
        fontSize *= 0.4f;
    else if(newCount >=9999999)
        fontSize *= 0.5f;
    else if(newCount > 999999)
        fontSize *= 0.6f;
    else if(newCount > 99999)
        fontSize *= 0.7f;
    else if(newCount > 9999)
        fontSize *= 0.8f;
    else if(newCount > 999)
        fontSize *= 0.9f;
    else if(newCount > 99)
        fontSize *= 1.0f;
    else if(newCount > 9)
        fontSize *= 1.1f;
    else
        fontSize *= 1.1f;

    //reset
    self.countlabel.xScale = fontSize;
    self.countlabel.yScale = self.countlabel.xScale;

    NSNumber *count = @(floor(newCount));
    NSString *countString = [NSString localizedStringWithFormat:@"%@", count];

    self.countlabel.text = countString;

    //disable animation
    //animate = NO;

    if(animate) {
        //scale
        float oldScale = self.countlabel.xScale;
        float newScale = self.countlabel.xScale * 1.2f; //1.06f;
        float duration = 0.1f; //0.1f
        [self.countlabel removeAllActions];
        SKAction *actionfade0 = [SKAction scaleTo:newScale duration:duration];//in
        SKAction *actionfade1 = [SKAction waitForDuration:0.0f];
        SKAction *actionfade2 = [SKAction scaleTo:oldScale duration:duration];//out
        SKAction *fadeSequence = [SKAction sequence:@[actionfade0,actionfade1,actionfade2]];
        [self.countlabel runAction:fadeSequence];
    }

    //always reposition
    [self repositionCount];
}

-(int)get1upNum{

    return kAppDelegate.nextOneUp;

    //disabled
    /*
    int level = (int)kAppDelegate.level;
    int lastLevel = level-1;
    if(lastLevel <0)
        lastLevel = 0;

    //int tempNum = (int)((kNum1up * level) * pow(k1upMult, level));
    int tempNum = (int)((kNum1up * level) * pow(k1upMult, level));
    //int tempNum = (int)((kNum1up * level) + (kNum1up * lastLevel) );

    //Log(@"get1upNum: %d", tempNum);
    return (tempNum);*/
}


-(int)get1upNumLast{

    return kAppDelegate.lastOneUp;

    //disabled
/*
    int level = (int)kAppDelegate.level - 1;
    int lastLevel = level-1;
    if(lastLevel <0)
        lastLevel = 0;

    //int tempNum = (int)((kNum1up * level) * pow(k1upMult, level));
    int tempNum = (int)((kNum1up * level) + (kNum1up * lastLevel) );

    //Log(@"get1upNumLast: %d", tempNum);
    return (tempNum);
*/
}




-(void)updateComboArrows {

    SKAction *black = [SKAction setTexture:[SKTexture textureWithImageNamed:@"comboArrowEmpty"]];
    SKAction *white = [SKAction setTexture:[SKTexture textureWithImageNamed:@"comboArrowFull"]];

    //scale
    float arrowScale = 0.5f;
    SKAction *actionScale0 = [SKAction scaleTo:arrowScale+0.2f duration:0.2f];//in
    SKAction *actionScale1 = [SKAction waitForDuration:0.1f];
    SKAction *actionScale2 = [SKAction scaleTo:arrowScale duration:0.2f];//out

    if(self.comboCount == kComboLevel3) {
        [self.comboArrow1 removeAllActions];
        //[self.comboArrow1 runActionsSequenceForever:flashAray];
        [self.comboArrow1 runAction:white];
        [self.comboArrow2 removeAllActions];
        //[self.comboArrow2 runActionsSequenceForever:flashAray];
        [self.comboArrow2 runAction:white];
        [self.comboArrow3 removeAllActions];
        [self.comboArrow3 runAction:white];


        [self.multLabel removeAllActions];
        SKAction *actionColorWait = [SKAction waitForDuration:0.15f];
        SKAction *actionColor3 = [SKAction runBlock:^{
            //self.multLabel.fontColor = [UIColor yellowColor];
            self.multLabel.fontColor =  [UIColor colorWithHex:0xfdfd51]; //yellow

        }];
        SKAction *actionColor4 = [SKAction runBlock:^{
           //self.multLabel.fontColor = [UIColor orangeColor];
            self.multLabel.fontColor = [UIColor colorWithHex:0xff8000]; //orange

        }];

        [self.multLabel runActionsSequenceForever:@[actionColor3,actionColorWait,actionColor4, actionColorWait]];


        self.comboArrow1.scale = arrowScale;
        self.comboArrow2.scale = arrowScale;
        self.comboArrow3.scale = arrowScale;

        //scale arrows
        [self.comboArrow1 runActionsSequenceForever:@[actionScale0,actionScale1,actionScale2,actionScale1]];
        [self.comboArrow2 runActionsSequenceForever:@[actionScale0,actionScale1,actionScale2,actionScale1]];
        [self.comboArrow3 runActionsSequenceForever:@[actionScale0,actionScale1,actionScale2,actionScale1]];


    }
    else if(self.comboCount == kComboLevel2) {
        [self.comboArrow1 removeAllActions];
        //[self.comboArrow1 runActionsSequenceForever:flashAray];
        [self.comboArrow1 runAction:white];

        [self.comboArrow2 removeAllActions];
        //[self.comboArrow2 runActionsSequenceForever:flashAray];
        [self.comboArrow2 runAction:white];

        [self.multLabel removeAllActions];
        self.multLabel.fontColor = [UIColor orangeColor];

        self.comboArrow1.scale = arrowScale;
        self.comboArrow2.scale = arrowScale;
        self.comboArrow3.scale = arrowScale;

        //scale arrows
        [self.comboArrow1 runActionsSequenceForever:@[actionScale0,actionScale1,actionScale2,actionScale1]];
        [self.comboArrow2 runActionsSequenceForever:@[actionScale0,actionScale1,actionScale2,actionScale1]];

    }
    else if(self.comboCount == kComboLevel1) {
        [self.comboArrow1 removeAllActions];
        //[self.comboArrow1 runActionsSequenceForever:flashAray];
        [self.comboArrow1 runAction:white];

        [self.multLabel removeAllActions];
        self.multLabel.fontColor = [UIColor yellowColor];

        self.comboArrow1.scale = arrowScale;
        self.comboArrow2.scale = arrowScale;
        self.comboArrow3.scale = arrowScale;

        //scale arrows
        [self.comboArrow1 runActionsSequenceForever:@[actionScale0,actionScale1,actionScale2,actionScale1]];

    }
    else if(self.comboCount == 0) {

        [self.comboArrow1 removeAllActions];
        [self.comboArrow2 removeAllActions];
        [self.comboArrow3 removeAllActions];

        [self.comboArrow1 runAction:black];
        [self.comboArrow2 runAction:black];
        [self.comboArrow3 runAction:black];

        [self.multLabel removeAllActions];
        self.multLabel.fontColor = [UIColor whiteColor];


    }
    else {
//        [self.comboArrow1 removeAllActions];
//        [self.comboArrow2 removeAllActions];
//        [self.comboArrow2 removeAllActions];

    }

    //sounds
    if(self.comboCount == kComboLevel1) {
        [self.soundPan1 play];
    }
    if(self.comboCount == kComboLevel2) {
        [self.soundPan2 play];
    }
    if(self.comboCount == kComboLevel3) {
        [self.soundPan3 play];
    }
}

-(void)updateComboHighScoreLabel {

    [self.comboLabelScore removeAllActions];

    float alphaShow = 1.0f;
    self.comboLabelScore.alpha = alphaShow;
    self.comboLabelScore.hidden = NO;

    //if(kAppDelegate.maxComboLevel > 0) {
        self.comboLabelScore.text = [NSString stringWithFormat:@"Best Combo: %d", (int)kAppDelegate.maxComboLevel];
    /*}
    else {
        self.comboLabelScore.text = @"";
    }*/

    if(self.view.showsFPS && [kHelpers isDebug])
        self.comboLabelScore.hidden = YES;
}

-(void)updateComboLabel {

    if(kAppDelegate.currentBuff == kBuffTypeAuto)
    {
        //disable for auto buff
        return;
    }
    float scaleMult = 1.0f;

    int bigDivider = 20; //50;
    if(kAppDelegate.level >= 10) {
        bigDivider = 40;
    }
    if(kAppDelegate.level >= 20) {
        bigDivider = 50;
    }
    if(kAppDelegate.level >= 30) {
        bigDivider = 60;
    }
    if(kAppDelegate.level >= 30) {
        bigDivider = 70;
    }
    if(kAppDelegate.level >= 40) {
        bigDivider = 80;
    }
    if(kAppDelegate.level >= 50) {
        bigDivider = 90;
    }
    if(kAppDelegate.level >= 60) {
        bigDivider = 100;
    }

    //too high
    int maxCombo = 999;
    //if(kAppDelegate.level == 1)
    {
        maxCombo = (kAppDelegate.level * 10)-1;
    }

    if(self.comboCount >= maxCombo)
    {
        //fail combo
        [self actionTimerCombo];
        return;
    }

    //combo
    self.comboCount++;

    [self updateRainbow];

    //combo rise smashtv
    if(self.comboCount == 10)
    {
        [self.soundComboRise stop];
        [self playSound:self.soundComboRise looping:YES];
    }

    //save stat
    if(self.comboCount > kAppDelegate.maxCombo) {

        kAppDelegate.maxCombo = self.comboCount;
        self.comboRecord = YES;
    }
    if(self.comboCount > kAppDelegate.maxComboLevel) {

        kAppDelegate.maxComboLevel = self.comboCount;
        self.comboRecord = YES;
    }

	if(self.comboRecord)
	{
	    [self showTouchCombo];
        [self updateComboHighScoreLabel];
	}

    //show
    if(self.comboCount >= kComboMinCount && kAppDelegate.level >= 1) {

        //first show
        if(self.comboCount == kComboMinCount)
            [self showTouchCombo];

        NSString *exclamation = @"!";

        scaleMult = 0.5f;
        if(self.comboCount >= kComboLevel3) {
            kAppDelegate.comboMult = 1.0;
            exclamation = @"!!!";
            scaleMult = 1.1f;
        }
        else if(self.comboCount >= kComboLevel2) {
            kAppDelegate.comboMult = 0.5;
            exclamation = @"!!";
            scaleMult = 0.9f;
        }
        else if(self.comboCount >= kComboLevel1) {
            kAppDelegate.comboMult = 0.2;
            exclamation = @"!";
            scaleMult = 0.7f;
        }

        self.comboLabel.text = [NSString stringWithFormat:@"%d Combo%@", self.comboCount, exclamation];

        [self repositionComboLabel];

        float alpha = 0.8f;
        [self.comboLabel runAction:[SKAction fadeAlphaTo:alpha duration:(kComboFadeIn)]]; //1.0

        [self.rayCombo runAction:[SKAction fadeAlphaTo:1.0f duration:(kComboFadeIn)]];


        //sound
        if((self.comboCount % bigDivider) == 0 && [kHelpers randomBool100:50]) {
            //[self.soundGasp play];
        }
    }

    //bounce
    //combo scale
    NSString *scaleKey = @"comboScale";
    [self.comboLabel removeActionForKey:scaleKey];

    float oldScale = 1.2f * scaleMult;
    self.comboLabel.xScale = oldScale;
    self.comboLabel.yScale = self.comboLabel.xScale;

    float newScale = 1.3f * scaleMult; //1.8f; //
    SKAction *actionScale0 = [SKAction scaleTo:newScale duration:0.1f];//in
    SKAction *actionScale1 = [SKAction waitForDuration:0.0f];
    SKAction *actionScale2 = [SKAction scaleTo:oldScale duration:0.1f];//out
    SKAction *scaleSequence = [SKAction sequence:@[actionScale0,actionScale1,actionScale2]];

    [self.comboLabel runAction:scaleSequence withKey:scaleKey];

    //fail combo timer
    [self removeActionForKey:kActionKeyComboFail];

    SKAction *wait = [SKAction waitForDuration:kComboFailDelay];
    SKAction *reset = [SKAction runBlock:^{
        [self actionTimerCombo];
    }];
    SKAction *sequence = [SKAction sequence:@[wait,reset]];
    [self runAction:sequence withKey:kActionKeyComboFail];


    [self updateComboHighScoreLabel];

    [self updateComboArrows];
}

//fail
- (void) actionTimerCombo {
    //fail, combo fail, fail combo, failcombo, combofail

    [self resetComboLabel];
    [self updateMult:NO];

    //stop combo rise smashtv
    [self.soundComboRise stop];

    self.comboCount = 0;
    self.comboLabel.text = @"";

    [self hideRainbow];

    //[self resetComboLabel];

    //[self.comboLabel removeAllActions];
    //[self.comboLabel runAction:[SKAction fadeOutWithDuration:kComboFadeOut]];
}

-(float)getMult {

    //mult
    float mult = kAppDelegate.mult;

    //skin mult
//    float multIndex = [kAppDelegate getMultIndex:(int)[kAppDelegate getSkin]];
//    mult *= multIndex;

    //combo mult
    float comboMult = kAppDelegate.comboMult;
    mult += comboMult;

    //rainbow coin mult
    mult += kAppDelegate.rainbowUsedCount/10.0f;

    //full heart
//    float fullHeartBonus = (kAppDelegate.numHearts == kHeartFull)? 0.2f : 0.0f;
//    mult += fullHeartBonus;

    //doubler
    if(kAppDelegate.doubleEnabled)
        mult*=2;

    //doubler buff
    if(kAppDelegate.currentBuff == kBuffTypeDoubler)
        mult*=2;

    //parse
//    float parseMult = kAppDelegate.parseMult;
//        mult *= parseMult;

    //toastie
    //float toastieMult = kAppDelegate.toastieMult;
    //mult *= toastieMult;

    //cheat
    float cheatMult = kAppDelegate.cheatMult;
    mult += cheatMult;

	//critital/weakspot
	mult *= self.weakSpotMult;

    //Log(@"***** getMult: %.1f", mult);

    //saturday morning
    if([kHelpers isSaturday] && [kHelpers isMorning])
    {
        mult *= 2.0f;
    }

    return mult;
}

-(void)resetComboLabel {

    //beat record
    if(self.comboRecord && self.comboCount > 30 && kAppDelegate.level >= 3) {
        [self.soundHashtag play];

        //confetti
        [kAppDelegate.gameController startConfetti2];
        //confetti stop
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [kAppDelegate.gameController stopConfetti];
        });
    }

    self.comboRecord = NO;
    self.comboCount = 0;

    self.comboLabel.xScale = self.comboLabel.yScale;
    self.comboLabel.fontColor = [CBSkinManager getMessageOuchColor];

    [self.comboLabel runAction:[SKAction fadeOutWithDuration:kComboFadeOut] completion:^{
        [self updateComboHighScoreLabel];
    }];

    [self.rayCombo runAction:[SKAction fadeOutWithDuration:kComboFadeOut]];

    //fall
    float distance = 0; //-20;
    [self.comboLabel runAction:[SKAction moveByX:0 y:distance duration:kComboFadeOut]];

    kAppDelegate.comboMult = 0.0;

    [self updateComboArrows];
}

-(void)touchedBlock:(SKSpriteNode*)node{

    //Log(@"touchedBlock");

    __weak typeof(self) weakSelf = self;
    __weak SKSpriteNode *weakblock = self.block;

    //block click block

    //ignore
    if(weakSelf.paused) {
        Log(@"touchedBlock: paused");
        return;
    }

    if(weakSelf.blockDisabled) {
        Log(@"touchedBlock: blockDisabled");
        return;
    }

    //curtain visible
    if(kAppDelegate.gameController.curtainsVisible && !kAppDelegate.gameController.darkVisible) {
        Log(@"touchedBlock: curtainsVisible");
        return;
    }

    if(kAppDelegate.numHearts <= 0) {
        [self refillHeartAlert:YES];
        return;
    }

    if(kAppDelegate.currentBuff == kBuffTypeAuto &&
       node != nil)
    {
        //disable real clicks
        return;
    }

    if(self.hurtLavaVisible)
    {
        [self hideLava:YES];
    }

    NSString *coinName = [CBSkinManager getCoinImageName];

    float duration = 0.1f;

    double newTick = [[NSDate date] timeIntervalSince1970];
    double diff = newTick - weakSelf.lastTick;

    //idle
    weakSelf.lastClickDate = [NSDate date];

    //reset
    //[weakSelf.block removeAllActions];
    [weakSelf.block removeActionForKey:@"animationBounce"];

    //arrow
    [weakSelf hideArrowBlock:YES];

    //arrow
    kAppDelegate.tutoArrowClickedBlock = YES;
    //[kAppDelegate saveState];
    //self.tutoArrow.hidden = YES;


    //[kHelpers sendGoogleAnalyticsEventWithCategory:@"game" andAction:@"tap" andLabel:@"block"];

    //inc speed no limit
    weakSelf.countSinceLastSecond++;

    //limit speed, but ignore auto buff
    //if(diff > 0.1f || kAppDelegate.currentBuff == kBuffTypeAuto)
    if(diff > 0.1f)
    {
        //count
        //kAppDelegate.clickCount++;

        
        //[kHelpers haptic1];
        [kHelpers haptic2];

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

        float mult = [self getMult];

        kAppDelegate.clickCount += mult;
        kAppDelegate.clickCount = [kHelpers clamp:kAppDelegate.clickCount min:0 max:kScoreMax];

        //combo
        [self updateComboLabel];

        //+1
        SKLabelOutlineNode *plusLabel = nil;
        plusLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontNamePlus];
        plusLabel.name = @"plusLabel_ignore";
        plusLabel.fontColor = RGB(255,255,255);
        plusLabel.userInteractionEnabled = NO;


        if(!HAS_DECIMALS(mult)) {
            plusLabel.text = [NSString stringWithFormat:@"+%d", (int)mult];
            //plusLabel.fontSize = 25;
        }
        else {
            plusLabel.text = [NSString stringWithFormat:@"+%.1f", mult];
            //plusLabel.fontSize = 25;
        }


        //parse
        [kAppDelegate dbIncClick];
        [kAppDelegate dbIncCoin:mult];

        //custom?
        NSString *tempPlusOne = [kAppDelegate getPlusOne];
        if(tempPlusOne) {
            plusLabel.text = tempPlusOne;
        }

        plusLabel.position = weakblock.position; //center

        weakSelf.lastTick  = newTick;

        //test
        //if(![kHelpers isSlowDevice]) {

        //[kAppDelegate playSound:@"smb3_bump.caf"];
        [weakSelf playSound:weakSelf.soundBump];

        //}


        float coinScale = 2.0f;
        if([kHelpers isIphone4Size])
            coinScale = 2.0 * 0.7f;

        BOOL is1up = NO;
        BOOL isMessage = NO;

        //sound
        {

            //test
            //if(![kHelpers isSlowDevice]) {

            //random
            int min = 0;
            int max = 1;

            if(weakSelf.soundCoin2)
                max = 2;
            if(weakSelf.soundCoin3)
                max = 3;

            int random =  min + arc4random_uniform(max); //0-1

            if(random == 0)
                [weakSelf playSound:weakSelf.soundCoin];
            else if(random == 1)
                [weakSelf playSound:weakSelf.soundCoin2];
            else
                [weakSelf playSound:weakSelf.soundCoin3];


            //update label
            //[weakSelf updateLevelLabel:NO];


            //http://gamua.com/blog/2010/06/sound-on-ios-best-practices/
            //}


            isMessage = NO;

            //right on it, or bigger
            if((int)kAppDelegate.clickCount % [weakSelf get1upNum] == 0 || (int)kAppDelegate.clickCount > [weakSelf get1upNum]) {

                is1up = YES;
                plusLabel.fontSize = 25;

                /*if(kAppDelegate.level == 1)
                {
                    plusLabel.text = @"Tutorial Complete";
                    plusLabel.fontSize = 20;
                }
                else*/
                {
                    if([kHelpers randomBool100:50])
                        plusLabel.text = @"World Complete";
                    else
                        plusLabel.text = @"World Clear";

                    //disabled hidden by chest
                    plusLabel.text = @"";
                }

                plusLabel.fontColor = [CBSkinManager getMessageColor];

                kAppDelegate.sinceLastMessage = 0;

                //hide banner
                [self hideBanner];

                //reset stars
                [kAppDelegate updateMult];
                [weakSelf updateMult:NO];

                //[kAppDelegate saveState];


                //hide all
                [weakSelf hidePowerup];
                [weakSelf hideAllFireballs:YES];
                [weakSelf hideSpike:NO];
                [self hideImageSquare];
            }
            else {

                //random fireball

                BOOL showFireball = [kHelpers randomBool100:25]; // 10%
                if(kAppDelegate.subLevel == 4)
                    showFireball = [kHelpers randomBool100:75];

                if(showFireball) {
                    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastFireballDate];
                    int intervalNeeded = 1; //secs

                    if(!kAppDelegate.gameController.curtainsVisible && !kAppDelegate.gameController.darkVisible && interval >= intervalNeeded) {

                        [weakSelf showFireball:NO];
                    }
                }

                //size
                plusLabel.fontSize = 25;

                if(HAS_DECIMALS(mult)) {
                    plusLabel.fontSize = 20;
                }

                //force for crit
                if([kHelpers randomBool100:kPlusRandom] || self.weakSpotMult > 1.0f)
                {
                    if(kAppDelegate.sinceLastMessage >= kAppSinceLastMessage || self.weakSpotMult > 1.0f)
                    {
                        kAppDelegate.sinceLastMessage = 0;

                        isMessage = YES;

                        //http://www.inthe80s.com/glossary.shtml

                        NSString * message = nil;

               			//force for crit
						if(self.weakSpotMult > 1.0f)
						{
							//crital, weak spot
							//https://en.wikipedia.org/wiki/Critical_hit
							/*
							Many games call critical hits by other names. For example, in Chrono Trigger, a double hit is a normal attack in which a player
							character strikes an enemy twice in the same turn. The EarthBound series refers to critical hits as a smash hit (known in-game as "SMAAAASH!!").
							The American NES release of Dragon Warrior II referred to an enemy's critical hits as "heroic attacks." Gamers frequently use the abbreviation crit
							or critical for "critical hit". In the fighting games Super Smash Bros. Brawl, Super Smash Bros. for Nintendo 3DS and Wii U,
							Marth's and Lucina's Final Smash is called Critical Hit in reference to the concept's use in the Fire Emblem series, the games from which Marth and Lucina originate.
							*/
							/*
							A Critical Hit (クリティカルヒット, Kuriteikaru Hitto?), also known as a Critical Strike, Mighty Blow, and Mortal Blow, or simply as Critical,
							is the term given to a physical attack that is somewhat stronger than the attack's normal version, and is a common element in several RPG's with the
							Final Fantasy series being no exception. Critical hits have a chance of occurring when the Attack command is used.
							They commonly deal double the normal damage, but cannot break the damage limit.
							*/
							NSMutableArray *critArray = [NSMutableArray array];
							[critArray addObjectsFromArray:@[
										@"critical",
										@"double hit",
                                        @"smash hit",
                                        @"max damage",
										@"crit",
										@"mini-crit",
										@"headshot",
										@"smaaaash",
										@"super effective",
										@"overkill",
										//@"boom",
										]];

        					if(!kAppDelegate.inReview)
							{
									[critArray addObjectsFromArray:@[
										@"nut shot",
										]];
							}

							message = [critArray randomObject];
							//add +5x
							message = [message stringByAppendingString:[NSString stringWithFormat:@" +%.0fx", self.weakSpotMult]];

                            //sound weak spot
							[self playSound:self.soundWeakSpot2];
                            //sound boss hit
                            [self playSound:self.soundBossHit];


                            plusLabel.fontColor = [UIColor colorWithHex:0xfdfd51]; //yellow

                            //bigger
                            plusLabel.fontSize += 2;

							//anim color
							SKAction *color1 = [SKAction runBlock:^{
								plusLabel.fontColor = [UIColor colorWithHex:0xfdfd51]; //yellow
							}];
							SKAction *color2 = [SKAction runBlock:^{
                                plusLabel.fontColor = [UIColor colorWithHex:0xff8000]; //orange
							}];

							SKAction *wait = [SKAction waitForDuration:0.1f];
           					SKAction *sequence = [SKAction sequence:@[color1,wait, color2, wait]];

                			[plusLabel runAction:[SKAction repeatActionForever:sequence]];
						}
						else
						{
							//normal
							message = [kAppDelegate getRandomMessage];
              plusLabel.fontColor = [CBSkinManager getMessageColor];
						}

                        assert(message);
                        plusLabel.text = [NSString stringWithFormat:@" %@", message];
                    }
                    else {

                        //keep counting
                        //kAppDelegate.sinceLastMessage++;
                    }

                }

                //update skin , hacker
                [self updateBlockAnim];

                //keep counting
                kAppDelegate.sinceLastMessage++;

                int maxPlus = 80;
                if(self.weakSpotMult > 1.0f)
                    maxPlus = 0; //center for crit

                int minPlus = -maxPlus;

                int randomPlus =  minPlus + arc4random_uniform(maxPlus*2);
                int xPlus  = weakblock.position.x + randomPlus;

                randomPlus =  minPlus + arc4random_uniform(maxPlus*2);
                int yPlus =  weakblock.position.y + randomPlus;

                plusLabel.position = CGPointMake(xPlus, yPlus);


            }

            plusLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
            plusLabel.zPosition = 200;
            plusLabel.alpha = 1; //hide

            //scale
            if(isMessage) {
                if(plusLabel.text.length > 10)
                    plusLabel.fontSize = 18;
                else if(plusLabel.text.length > 5)
                    plusLabel.fontSize = 20;
                else if(plusLabel.text.length > 2)
                    plusLabel.fontSize = 22;
            }


            //anim
            float plusDuration = 1.0f;
            if(isMessage) //message
                plusDuration *= 2;

            float distance = 80;
            if(isMessage) //message
                distance *= 2.5f; //2
            else if(is1up) //message
                plusDuration *= 3;


            //shadow, wait after font size
            //+1 shadow
            /*if(NO)
            {
                [plusLabel setupShadows:kShadowModeDrop2 offset:4 color:[UIColor blackColor] fontName:kFontNamePlus alpha:0.3f]; //0.8f
            }*/

            SKAction *actionMovePlus = [SKAction moveBy:CGVectorMake(0,distance) duration:plusDuration];
            [plusLabel runAction:actionMovePlus];
            SKAction *actionFadePlus = [SKAction fadeAlphaTo:0.0f duration:plusDuration];
            [plusLabel runAction:actionFadePlus];
            //delete
            SKAction *deleteAction1Plus = [SKAction waitForDuration:plusDuration];
            SKAction *deleteAction2Plus = [SKAction runBlock:^{
                [plusLabel removeFromParent];
            }];

            SKAction *deleteSequencePlus = [SKAction sequence:@[deleteAction1Plus,deleteAction2Plus]];
            [plusLabel runAction:deleteSequencePlus];


            //slow
            //if(![kHelpers isSlowDevice]) {
            [weakSelf addChild:plusLabel];
            //}

            //right on it, or bigger
            if(is1up)
            {
                //winning
                //winner

                [weakSelf repositionAll];

                //sounds
                [self.soundSpin stop];
                [self.soundComboRise stop];

                //hide plus
                [self hideNavPlus];
                [self hidePotionPlus];
                [self hideWeakSpot:NO];

                //hide buff
                [self hideBuff];

                self.winning = YES;

                [self hideClouds];

                //flash
                [kAppDelegate.gameController showFlash:kFlashColorWhite];

                coinScale = 3.0f;
                if([kHelpers isIphone4Size])
                    coinScale = 3.0 * 0.7f;

                //[weakSelf.sound1up play];

                float secs = 0.3f;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [weakSelf playSound:weakSelf.soundChorus];
                });

                //update count, inc
                Log(@"kAppDelegate.oneUpInc: %.1f", kAppDelegate.oneUpInc);
                Log(@"kAppDelegate.lastOneUp: %.1f", kAppDelegate.lastOneUp);
                Log(@"kAppDelegate.nextOneUp: %.1f", kAppDelegate.oneUpInc);

                kAppDelegate.oneUpInc += kNum1upIncInc;
                kAppDelegate.lastOneUp = kAppDelegate.nextOneUp;
                kAppDelegate.nextOneUp += kAppDelegate.oneUpInc;

                Log(@"kAppDelegate.oneUpInc: %.1f", kAppDelegate.oneUpInc);
                Log(@"kAppDelegate.lastOneUp: %.1f", kAppDelegate.lastOneUp);
                Log(@"kAppDelegate.nextOneUp: %.1f", kAppDelegate.oneUpInc);


                //fade block hide block
                float disapearDuration = kWinDelay;
                [weakblock runAction:[SKAction fadeAlphaTo:0.0f duration:disapearDuration]];
                [weakblock runAction:[SKAction moveByX:0 y:-100 duration:disapearDuration]];


                [self colorizeNode:weakblock color:kRedBlockFlash duration:1.0f back:NO colorBlendFactor:0.5f]; //pink

                //explosions
                [self showWinExplosion];

                //key
                [self showKey];

                //help heart
                [self updateHelpButton];

                [kAppDelegate stopMusic];

                kAppDelegate.lifes++;
                kAppDelegate.lifes = [kHelpers clamp:kAppDelegate.lifes min:0 max:kMaxLifes];

                //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                //    [kAppDelegate playSound:@"ko.caf"];
                //});


                [kAppDelegate.gameController updateButtons];

                //if(kAppDelegate.vibrationEnabled)
                //    [kHelpers vibrate];

                //help bubble
                [self updateHelpButton];

                //new bg
                if(!self.winning && !self.dying) {
                    float fadeDuration = kBackgroundFadeDuration;
                    //NSString *bgName = nil;
                    SKTexture *bgTexture = nil;

                    if(kAppDelegate.subLevel == 4) {
                        //bgName = kBackgroundVolcano;
                        bgTexture = self.bgCastle;
                    }
                    else {
                        //make sure it's different
                        bgTexture = [self getRandomBackground];
                    }

                    //new old
                    weakSelf.lastBGTexture = bgTexture;

                    //old image, fade out

                    secs = 0.5f;
					SKAction *actionBlock = [SKAction runBlock:^{
                        //fade
                        SKAction *bgFade = [SKAction fadeAlphaTo:0.0f duration:fadeDuration];
                        SKAction *bgWait = [SKAction waitForDuration:0.5f];
                        SKAction *bgSequence = [SKAction sequence:@[bgWait, bgFade]];

                        weakSelf.bgImage2.texture = weakSelf.bgImage.texture;
                        weakSelf.bgImage2.alpha = 1.0f;

                        [weakSelf.bgImage2 runAction:bgSequence];
                        weakSelf.bgImage.texture = bgTexture;
					}];
					[self runAction:actionBlock afterDelay:secs];
                }

                //level up
                kAppDelegate.level++;

                //don't clamp
                kAppDelegate.subLevel = 1;

                [weakSelf updateLevelLabel:YES];

                //refill heart for free

                //change it, but don't update hearts yet
                kAppDelegate.numHearts = kHeartFull;


                [self checkHeartTimer];

                //level up?

                //win screen, delay
                float secs2 = kWinDelay + 0.0f;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    if(!self.clickedDoor) {
                        self.clickedDoor = YES;
                        [kAppDelegate.gameController actionWin:nil];
                    }
                });

                [kAppDelegate.gameController enableButtons:NO];

                //confetti
                [kAppDelegate.gameController startConfetti];
                //confetti stop

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [kAppDelegate.gameController stopConfetti];
                });

                //curtains
                kAppDelegate.gameController.curtainsVisible = YES;
            }

            int percent = 1; //20 //1
            //force
            if([kHelpers isDebug])
            {
//                percent = 20;
//                self.lastToastieDate = nil;
            }

            if([kHelpers randomBool100:percent])
            {
                [self showToastie:YES];
            }

            //percent = 1;
            percent = kAppDelegate.powerupClickOdds;
            if([kAppDelegate isPremium])
              percent *= 2.0f; //more in premium

            if([kHelpers randomBool100:percent])
            {
                [self showImageSquare];
            }

            [weakSelf updateMult:NO];

            //label
            [weakSelf updateCountLabel:YES];

            if(!is1up)
                [weakSelf updateLevelBar:YES];
        }

        [self colorizeNode:self.block color:kRedBlockFlash]; //pink

        //move
        int bounceHeight = 20;

        int x = weakSelf.frame.size.width/2;
        int y = [weakSelf getBlockY];

        //[weakSelf.block removeAllActions];
        SKAction *actionslide0 = [SKAction moveTo:CGPointMake(x, y) duration:0.0f];//out
        SKAction *actionslide1 = [SKAction moveTo:CGPointMake(x, y + bounceHeight) duration:duration]; //in
        SKAction *actionslide3 = [SKAction moveTo:CGPointMake(x, y) duration:duration]; //out
        SKAction *slideSequence = [SKAction sequence:@[actionslide0,actionslide1,actionslide3]];

        [weakSelf.block runAction:slideSequence withKey:@"animationBounce"];

        //reset time
        [self resetTime];


		if(YES)
        {
			//coin for weakSpot
			if(self.weakSpotMult > 1.0f)
			{
				coinName = @"coinWeakSpot";
            }

            //coin up
            float coinDuration = 0.5f;

            SKSpriteNode *coin = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]];
            coin.name = @"coin";
            coin.zPosition = 5;
            coin.scale = coinScale;

            //Log(@"coin.xScale: %f", coin.xScale);
            //Log(@"coinScale: %f", coinScale);

            int offset = 10;
            coin.position = CGPointMake(weakSelf.block.position.x,
                                        weakSelf.block.position.y + weakSelf.block.size.height/2 - coin.size.height/2 - offset);
            SKAction *actionMove = [SKAction moveBy:CGVectorMake(0,400) duration:coinDuration];
            [coin runAction:actionMove];

            SKAction *actionFade = [SKAction fadeAlphaTo:kCoinAlphaUp duration:coinDuration];
            [coin runAction:actionFade];

            //delete
            SKAction *deleteAction1 = [SKAction waitForDuration:coinDuration];
            SKAction *deleteAction2 = [SKAction runBlock:^{
                [coin removeFromParent];
            }];

            SKAction *deleteSequence = [SKAction sequence:@[deleteAction1,deleteAction2]];
            [coin runAction:deleteSequence];


            float coinAnimRate = kCoinAnimRate;
            SKAction *coinAnim = nil;


            if([kHelpers isSlowDevice]) {

                //slow
                coinAnim = [SKAction setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]]];
            }

            else {
                //normal

                BOOL shouldSpin = YES;
                //test frame 2?
                UIImage *testImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame2", coinName]];
                if (testImage) {
                    shouldSpin = NO;
                }

                if(shouldSpin) {
                    //set 1st frame
                    coinAnim = [SKAction setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]]];
                    [coin runAction:coinAnim];

                    //spin scale
                    //SKAction* actionSpin1 = [SKAction scaleXTo:1.0 duration:0.4f];
                    //SKAction* actionSpin2 = [SKAction scaleXTo:-1.0 duration:0.4f];
                    SKAction* actionSpin1 = [SKAction scaleXTo:1.0f duration:kCoinSpinScaleDuration];
                    SKAction* actionSpin2 = [SKAction scaleXTo:kCoinSpinScaleMin duration:kCoinSpinScaleDuration];
                    coinAnim = [SKAction sequence:@[actionSpin1, actionSpin2]];

                }
                else {

                    //NSString *coinName = [CBSkinManager getCoinImageName];

                     coinAnim = [SKAction animateWithTextures:@[
                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]],
                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame2", coinName]],
                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame3", coinName]],
                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame4", coinName]],
                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]]]
                     timePerFrame:coinAnimRate];

                }


            }

            SKAction *coinWait = [SKAction waitForDuration:0.0f];
            SKAction *coinSequence = nil;
            coinSequence = [SKAction sequence:@[coinWait, coinAnim]];


            //slow
            if(![kHelpers isSlowDevice]) {
                //[coin runAction:[SKAction repeatActionForever:coinSequence]];
            }

            [weakSelf addChild:coin];


            //coin fall
#if 1
            float fallDuration = 3.0f;
            float fallWait = coinDuration + 0.3f;

            int min = 0;
            int max = weakSelf.size.width;
            int random =  min + arc4random_uniform(max);

            //SKSpriteNode *coinFall = [SKSpriteNode spriteNodeWithImageNamed:coinName];
            SKSpriteNode *coinFall = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"%@Frame1", coinName]];
            coinFall.name = @"coinFall";
            coinFall.zPosition = 2;
            coinFall.scale = coinScale/2;
            //Log(@"coinFall.scale: %f", coinFall.xScale);
            //Log(@"coinScale/2: %f", coinScale/2);

            //fall
            coinFall.alpha = kCoinAlphaFall;

            coinFall.position = CGPointMake(random,
                                            weakSelf.size.height+coinFall.size.height/2);

            SKAction *actionMoveWait = [SKAction waitForDuration:fallWait];
            SKAction *actionMoveFall = [SKAction moveBy:CGVectorMake(0,
                                                                     -(weakSelf.size.height+coinFall.size.height/2))
                                                                        duration:fallDuration];
            [coinFall runAction:[SKAction sequence:@[actionMoveWait,actionMoveFall]]];

            //fade also
            SKAction *actionFadeOut = [SKAction fadeOutWithDuration:2.0f];
            [coinFall runAction:[SKAction sequence:@[actionMoveWait,actionFadeOut]]];

            
            //delete
            SKAction *deleteAction1Fall = [SKAction waitForDuration:fallDuration+fallWait];
            SKAction *deleteAction2Fall = [SKAction runBlock:^{
                [coinFall removeFromParent];
            }];

            SKAction *deleteSequenceFall = [SKAction sequence:@[deleteAction1Fall,deleteAction2Fall]];
            [coinFall runAction:deleteSequenceFall];
            

            [coinFall runAction:[SKAction repeatActionForever:coinSequence]];

            //max children
            if([kHelpers isSlowDevice])
            {

                int nodeCount = (int)weakSelf.children.count;

                //max nodes
                int maxNodes = 50;
                if(nodeCount < maxNodes) {
                    [weakSelf addChild:coinFall];
                }

            }
            else {
                [weakSelf addChild:coinFall];
            }
#endif
            
        }


        //update label
        [weakSelf updateLevelLabel:NO];


        [kAppDelegate checkAchievements];
    }
    else {
        Log(@"touchedBlock: skipped");
    }

}

-(void)colorizeNode:(SKNode*)node color:(UIColor*)color
{
    [self colorizeNode:node color:color duration:0.05f back:YES colorBlendFactor:0.5f];
}

-(void)colorizeNode:(SKNode*)node color:(UIColor*)color colorBlendFactor:(CGFloat)colorBlendFactor
{
    [self colorizeNode:node color:color duration:0.05f back:YES colorBlendFactor:colorBlendFactor];
}

-(void)colorizeNode:(SKNode*)node color:(UIColor*)color duration:(float)duration back:(BOOL)back colorBlendFactor:(CGFloat)colorBlendFactor
{
    SKColor *pulseColor = [SKColor colorWithCGColor:color.CGColor];

    //UIImage *oldImage = (UIImage*)(node.texture.CGImage)

    //return [self filledImageFrom:inputImage withColor:[[UIColor blackColor] colorWithAlphaComponent:0.8f]];


    self.block.color = pulseColor;

    SKAction *changeColorAction = [SKAction colorizeWithColor:color colorBlendFactor:colorBlendFactor duration:duration];

    SKAction *waitAction = [SKAction waitForDuration:0.01];
    SKAction *changeColorBackAction = [SKAction colorizeWithColor:color colorBlendFactor:0.0f duration:duration];
    SKAction *sequence = [SKAction sequence:@[changeColorAction, waitAction, changeColorBackAction]];

    if(back)
        [node runAction:sequence];
    else
        [node runAction:changeColorAction];
}


-(void)pauseEffect {

    [self pauseEffect:0.0f duration:0.0f];

}

-(void)pauseEffect:(float)delay duration:(float)duration{
    //disabled
    return;
#if 0
    //pause effect

    if(delay < 0.0001f)
        delay = 0.0f;

    if(duration < 0.0001f)
        duration = 0.4f;


    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //self.paused = YES;
        [self.physicsWorld setSpeed:0.2f];

        //[self setShouldEnableEffects:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            //self.paused = NO;
            [self.physicsWorld setSpeed:kPhysicsWorldSpeed]; //reset

           //[self setShouldEnableEffects:NO];

        });
    });

#endif
}

-(void)checkHeartTimer {

    if(kAppDelegate.numHearts <= 2) {

        [self.timerLowHealth invalidate];
        self.timerLowHealth = nil;

        float interval2 = 1.0f;
        self.timerLowHealth = [NSTimer scheduledTimerWithTimeInterval:interval2 target:self
                                                             selector:@selector(actionTimerLowHealth:) userInfo:@"actionTimerLowHealth" repeats:YES];
    }
    else {
        [self.timerLowHealth invalidate];
        self.timerLowHealth = nil;
    }

}

-(void)setNumHearts:(int)many{
    //flash hearts

    float oldScale = kHeartScale;
    float newScale = kHeartScale * 1.15f; //1.2;

    [self.heart1 removeActionForKey:@"heartScale"];
    [self.heart2 removeActionForKey:@"heartScale"];
    [self.heart3 removeActionForKey:@"heartScale"];
    [self.heart4 removeActionForKey:@"heartScale"];

    SKAction *actionfade0 = [SKAction scaleTo:newScale duration:0.2f];//in
    SKAction *actionfade1 = [SKAction waitForDuration:0.1f];
    SKAction *actionfade2 = [SKAction scaleTo:oldScale duration:0.2f];//out
    SKAction * fadeSequence = [SKAction sequence:@[actionfade0,actionfade1,actionfade2]];

    switch(many) {
        case 0:
            [self.heart1 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
            [self.heart2 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
            [self.heart3 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
            [self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			if([kAppDelegate isPremium])
				[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			else
            	[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_outline"]]];
            break;

        case 1:
            [self.heart1 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_half"]]];
            [self.heart2 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
            [self.heart3 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			if([kAppDelegate isPremium])
				[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			else
            	[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_outline"]]];
            break;

        case 2:
            [self.heart1 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart2 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
            [self.heart3 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			if([kAppDelegate isPremium])
				[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			else
            	[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_outline"]]];

            [self.heart1 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];

            break;

        case 3:
            [self.heart1 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart2 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_half"]]];
            [self.heart3 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			if([kAppDelegate isPremium])
				[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			else
            	[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_outline"]]];

            [self.heart1 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
            [self.heart2 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];

            break;

        case 4:
            [self.heart1 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart2 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart3 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			if([kAppDelegate isPremium])
				[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			else
            	[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_outline"]]];

            [self.heart1 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
            [self.heart2 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];

            break;

        case 5:
            [self.heart1 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart2 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart3 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_half"]]];
			if([kAppDelegate isPremium])
				[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			else
            	[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_outline"]]];

            [self.heart1 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
            [self.heart2 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];

			if([kAppDelegate isPremium])
            	[self.heart4 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];

            break;

        case 6:
            [self.heart1 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart2 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart3 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
			if([kAppDelegate isPremium])
				[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
			else
            	[self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_outline"]]];

            [self.heart1 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
            [self.heart2 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
            [self.heart3 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];

            break;

        case 7:
            [self.heart1 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart2 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart3 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_half"]]];

			[self.heart1 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
            [self.heart2 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
            [self.heart3 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
			if([kAppDelegate isPremium])
            	[self.heart4 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];

            break;

        case 8:
            [self.heart1 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart2 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart3 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];
            [self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];

			[self.heart1 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
            [self.heart2 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
            [self.heart3 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];
			if([kAppDelegate isPremium])
            	[self.heart4 runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"heartScale"];

            break;


        default:
            [self.heart1 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
            [self.heart2 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
            [self.heart3 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];
            [self.heart4 runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_empty"]]];

            break;
    }

    [kAppDelegate saveState];
}

-(void)showRainbowCoinAlert {

    //disabled;
    //return;

    if(kAppDelegate.playedRainbowCoinAlert)
        return;

    kAppDelegate.playedRainbowCoinAlert = YES;

    // NSString *title = @"Power Coins";
    NSString *message = @"Collect secret <color1>Power Coins</color1> to upgrade your coin <color1>Power</color1> multiplier.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
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
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];

    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

  //after delay
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

    //pause
    [self enablePause:YES];
    [kAppDelegate.gameController blurScene:YES];

    [kAppDelegate.alertView show:YES];
    [kAppDelegate.gameController showVCR:YES animated:YES];
    });

}

-(void)showHeartLowAlert {

    //disabled;
    //return;

    if(kAppDelegate.playedLowHeartAlert)
        return;

    kAppDelegate.playedLowHeartAlert = YES;
    //[kAppDelegate saveState];

    NSString *message = @"Careful, almost out of <color1>hearts</color1>...\nUse one of your <color1>potions</color1>!";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
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
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];

    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

	//after delay
 	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

		//pause
		[self enablePause:YES];
		[kAppDelegate.gameController blurScene:YES];

		[kAppDelegate.alertView show:YES];
		[kAppDelegate.gameController showVCR:YES animated:YES];
    });
}

-(void)showLowTimeAlert {

    if(kAppDelegate.playedLowTimeAlert)
        return;

    kAppDelegate.playedLowTimeAlert = YES;

    NSString *message = @"Careful, running out of <color1>time</color1> will make you lose a <color1>heart</color1>. Keep on tapping!";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                             type:kAlertButtonGreen
                          handler:^(SIAlertView *alert) {
                              //
                              [kAppDelegate playSound:kClickSound];

                          }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    //pause
    [self enablePause:YES];
    [kAppDelegate.gameController blurScene:YES];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];

    }];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    [kAppDelegate.alertView show:YES];
    [kAppDelegate.gameController showVCR:YES animated:YES];
}

-(void) touchedBarHelp {
    //[self playSound:self.soundHelp];
}


-(void) touchedDoor {

    if(!self.clickedDoor) {
        self.clickedDoor = YES;
        [kAppDelegate.gameController actionWin:nil];
    }
}

-(void) touchedSpike:(SKSpriteNode*)node {

    __weak typeof(self) weakSelf = self;

    //invincible
    if(kAppDelegate.currentBuff == kBuffTypeStar) {
      [self playSound:weakSelf.soundBump];
        return;
    }

    if(kAppDelegate.numHearts <= 0) {
        [self refillHeartAlert:YES];
        return;
    }

    //delay click
    float interval = kToucheFireballDelay;
    if(self.lastClickFireballDate && [[NSDate date] timeIntervalSinceDate:self.lastClickFireballDate] <  interval) {
        //skip
        [self playSound:weakSelf.soundBump];
        return;
    }

    //flash after delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        [kAppDelegate.gameController flashVCR];
    });


    //reset timer
    self.lastClickDate = [NSDate date];

    [kAppDelegate dbIncSpike];

    [self touchedOuch:-2];

    //show X
    [self showFireballX:self.spike isFireball:NO];

    //report
    [kAppDelegate reportScore];

    //[kAppDelegate saveState];
}

-(void)shake
{
    [self shakeTimes:6]; //6
}

-(void)shakeTimes:(NSInteger)times
{
    ///return;

    //http://stackoverflow.com/questions/20889860/a-camera-shake-effect-for-spritekit

    NSMutableArray *arrayNodes = [NSMutableArray array];
    NSMutableArray *arrayInitialPoint = [NSMutableArray array];

    [arrayNodes addObject:self.heart1];
    [arrayNodes addObject:self.heart2];
    [arrayNodes addObject:self.heart3];
    [arrayNodes addObject:self.heart4];
    [arrayNodes addObject:self.heartPlus];

    [arrayNodes addObject:self.worldNameLabel];

    [arrayNodes addObject:self.barHelp];
    [arrayNodes addObject:self.barCastle];

    [arrayNodes addObject:self.barBack];
    [arrayNodes addObject:self.barFill];

    [arrayNodes addObject:self.navSquare];
    [arrayNodes addObject:self.navPlus];
    [arrayNodes addObject:self.imageSquare];

    [arrayNodes addObject:self.potion];
    [arrayNodes addObject:self.potionPlus];

    [arrayNodes addObject:self.buff];
    [arrayNodes addObject:self.buffLabelTimer];
    [arrayNodes addObject:self.buffLabelName];
    [arrayNodes addObject:self.buffSquare];


    for(SKNode *node in arrayNodes)
    {
        //positions
        [arrayInitialPoint addObject:[NSValue valueWithCGPoint:node.position]];
    }

    CGFloat amplitude = 8; //20; //32;
    //NSInteger amplitudeX = 0; //amplitude;
    //CGFloat amplitudeY = amplitude; //2;
    NSMutableArray * randomActions = [NSMutableArray array];

    //SKAction *wait = [SKAction waitForDuration:0.02f];

    int direction = 1;
    for (int i=0; i<times; i++) {

        //NSInteger randX = 0.0f; //self.position.x+arc4random() % amplitudeX - amplitudeX/2;
        //NSInteger randY = self.position.y+arc4random() % amplitudeY - amplitudeY/2;

        CGFloat randX = 0;
        CGFloat randY = direction * amplitude/2.0f;

        //Log(@"shake: %.2f, %.2f ******", randX, randY);

        SKAction *action = [SKAction moveBy:CGVectorMake(randX, randY) duration:0.1f];
        [randomActions addObject:action];

        //up/down
        direction *= -1;
    }

    SKAction *rep = [SKAction sequence:randomActions];

    int i = 0;
    for(SKNode *node in arrayNodes)
    {
        //run action on all nodes
        [node runAction:rep completion:^{
            node.position = [[arrayInitialPoint objectAtIndex:i] CGPointValue];
        }];

        i++;
    }

}


-(void)touchedOuch:(int)which
{
    //Log(@"***** touchedOuch");

    __weak typeof(self) weakSelf = self;
    __weak SKSpriteNode *weakFireball = nil; //self.fireballAppear;
    if(which >= 0)
        weakFireball = [self.fireballAppearArray safeObjectAtIndex:which];

    //fail combo
    [self actionTimerCombo];

    int heartLose = [self heartLose];

    int numHeartsBefore = (int)kAppDelegate.numHearts;

    //count
    kAppDelegate.prefLevelNumFireballsTouched++;

    //only after level 1
    //if(kAppDelegate.level >= kHeartLevelLose)
    {

        kAppDelegate.numHearts -= heartLose;
        kAppDelegate.numHearts = [kHelpers clamp:kAppDelegate.numHearts min:0 max:kHeartFull];
        if(!kAppDelegate.healStartDate)
            kAppDelegate.healStartDate = [NSDate date];
        //kAppDelegate.healStartDate = [[NSDate date] dateByAddingTimeInterval:[CBSkinManager getHeartHealTime]];

        [self setNumHearts:(int)kAppDelegate.numHearts];

        if(kAppDelegate.numHearts <= 0)
            [self refillHeartAlert:YES];
    }

    //hand potion
    if(kAppDelegate.numHearts == 2)
        [self showArrowPotion:YES];

    [self checkHeartTimer];

    //fall heart
    if(numHeartsBefore > 0) {
        self.heartFall.hidden = NO;

        if(numHeartsBefore == 0 || numHeartsBefore == 1 || numHeartsBefore == 2) {

            self.heartFall.position = self.heart1.position;
        }
        else if(numHeartsBefore == 3 || numHeartsBefore == 4) {

            self.heartFall.position = self.heart2.position;
        }
        else if(numHeartsBefore == 5 || numHeartsBefore == 6) {

            self.heartFall.position = self.heart3.position;
        }

        //lower
        self.heartFall.position = CGPointMake(self.heartFall.position.x, self.heartFall.position.y - 5);

        self.heartFall.alpha = 0.9f;
        //self.heartFall.zRotation = RADIANS(180); //rotate

        //self.heartFall.yScale = -kHeartScale * 1.0f; //flip

        if(numHeartsBefore == 2 || numHeartsBefore == 4 || numHeartsBefore == 6)
            self.heartFall.xScale = kHeartScale * -1.0f; //flip half
        else
            self.heartFall.xScale = kHeartScale * 1.0f; //no flip

        float fallDuration = 1.5f;

        [self.heartFall removeAllActions];

        if(heartLose == 1)
            [self.heartFall runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_half"]]];
        else
            [self.heartFall runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"heart_full"]]];

        SKAction *moveFall = [SKAction moveBy:CGVectorMake(0, -(200)) duration:fallDuration];
        moveFall.timingMode = SKActionTimingEaseIn;

        [self.heartFall runAction:moveFall];
        [self.heartFall runAction:[SKAction fadeAlphaTo:0.0f duration:fallDuration] completion:^{
            self.heartFall.hidden = YES;
        }];


        self.heartFall.zPosition = self.countlabel.zPosition + 2;
    }

    if(kAppDelegate.numHearts <= 2)
    {
        [self showHeartLowAlert];
    }

    kAppDelegate.prefNumFireballsTouched++;

    self.lastClickFireballDate = [NSDate date];


    //alert
    if(!kAppDelegate.playedHelpFire) {

        kAppDelegate.playedHelpFire = YES;

        NSString *message = LOCALIZED(@"kStringOuch");

        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            [kAppDelegate.alertView dismissAnimated:NO];

        kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                         andMessage:message];

        [kAppDelegate.alertView addButtonWithTitle: LOCALIZED(@"kStringGotIt")//[CBSkinManager getRandomOKButton]
                                              type:kAlertButtonGreen
                                           handler:^(SIAlertView *alert) {
                                               //
                                               [kAppDelegate playSound:kClickSound];

                                           }];

        kAppDelegate.alertView.transitionStyle = kAlertStyle;

        [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
            //nothing
        }];


        //close, unpause
        [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
            [self enablePause:NO];
            [kAppDelegate.gameController blurScene:NO];

            [kAppDelegate.gameController showVCR:NO animated:YES];

        }];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            //pause
            [self enablePause:YES];
            [kAppDelegate.gameController blurScene:YES];

            [kAppDelegate.alertView show:YES];
            [kAppDelegate.gameController showVCR:YES animated:YES];

        });
    }

    //vibrate
    if(kAppDelegate.vibrationEnabled)
        [kHelpers vibrate];

    //flash fireballs
    [self flashFireballs];

    //if(!self.hurtLavaVisible)
    [self hideLava:YES];

    //[self hideInk];
    if(kAppDelegate.currentBuff == kBuffTypeInk) {
        [self hideBuff];
    }

    //pause effect
    [self pauseEffect];

    weakSelf.lastFireballDate = [NSDate date];

    //smoke particles
    if( ![kHelpers isSlowDevice]) {
        //particle
        SKEmitterNode *myParticle = [SKEmitterNode emitterWithResourceNamed:@"smoke2"];
        assert(myParticle);
        myParticle.zPosition = weakFireball.zPosition-1;
        myParticle.name = @"smoke_2_ignore";
        myParticle.numParticlesToEmit = 20;
        myParticle.position = weakFireball.position;
        [self removeChildrenNamed:myParticle.name];
        if(kEnableEmiters)
            [weakSelf addChild:myParticle];

        //delete
        [myParticle runAction:[SKAction removeFromParent] afterDelay:kParticleAutoDelete];
    }

    //random
    int min = 0;
    int max = 5; //2;
    int random =  min + arc4random_uniform(max); //0-1

    if(random == 0)
        [weakSelf playSound:weakSelf.soundFireballClick];
    else
        [weakSelf playSound:weakSelf.soundFireballClick2];

    [self playSound:self.soundHurt];

    //shield
    if(kAppDelegate.currentBuff == kBuffTypeShield) {
        [self playSound:self.soundBuffShield];
    }

    [kAppDelegate.gameController showFlash:kFlashColorRed];

    //flash after delay
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        [kAppDelegate.gameController flashVCR];
    });

    //count

    [weakSelf updateCountLabel:YES];
    [weakSelf updateLevelBar:YES];
    [weakSelf updateLevelLabel:YES];

    [kAppDelegate updateMult];
    [weakSelf updateMult:NO];


    //share
    [self shake];

    //+1 ouch
    SKLabelOutlineNode *plusLabel = nil;
    plusLabel = [SKLabelOutlineNode labelNodeWithFontNamed:kFontNamePlus];
    plusLabel.scale = 1.0f;
    plusLabel.fontSize = 18.0f;
    [plusLabel setHorizontalAlignmentMode:SKLabelHorizontalAlignmentModeCenter];
    [plusLabel setVerticalAlignmentMode:SKLabelVerticalAlignmentModeCenter];
    plusLabel.name = @"plusLabel_ignore";
    plusLabel.fontColor = [CBSkinManager getMessageOuchColor];
    //shadow
    [plusLabel setupShadows:kShadowModeDrop offset:1 color:[UIColor blackColor] fontName:kFontNamePlus alpha:0.8f];

    //achievement
	if(which == -2)
	{
		//spike
		[kAppDelegate reportAchievement:kAchievement_ouchSpike];
	}
    else  if(which == -1)
    {
        //time
        [kAppDelegate reportAchievement:kAchievement_ouchTime];
    }
    else  if(which == -3)
    {

        //disable lava
        [self.lava enable:NO];

        //lava
        [kAppDelegate reportAchievement:kAchievement_ouchTime];
    }
	else
	{
		//enemy
		[kAppDelegate reportAchievement:kAchievement_ouchEnemy];
	}

    //ouch
    if(which >= 0 || which == -2) //-2 for spike
    {
        NSString * message = [kAppDelegate getRandomOuch];
        plusLabel.text = message;
    }
    else
    {
        //times up
        plusLabel.text = @"time's up";
    }

    /*if(plusLabel.text.length > 10)
        plusLabel.fontSize = 18;
    else if(plusLabel.text.length > 5)
        plusLabel.fontSize = 20;
    else if(plusLabel.text.length > 2)
        plusLabel.fontSize = 22;*/

    int xPlus  = 0;
    int yPlus  = 0;

    if(which == -2)
    {
        //spike
        //xPlus = self.spike.position.x;
        //yPlus =  self.spike.position.y;
        xPlus = self.lastClickPosition.x;
        yPlus =  self.lastClickPosition.y;
    }
    else if(which == -1)
    {
        //time
        xPlus = self.block.position.x;
        yPlus =  self.block.position.y;
    }
    else
    {
        //normal fireball
        xPlus = weakFireball.position.x;
        yPlus =  weakFireball.position.y;
    }




    plusLabel.position = CGPointMake(xPlus, yPlus);
    plusLabel.zPosition = 200;
    plusLabel.alpha = 1; //hide


    float plusDuration = 1.0f;
    float distance = 80;
    SKAction *actionMovePlus = [SKAction moveBy:CGVectorMake(0,distance) duration:plusDuration];
    [plusLabel runAction:actionMovePlus];
    SKAction *actionFadePlus = [SKAction fadeAlphaTo:0.0f duration:plusDuration];
    [plusLabel runAction:actionFadePlus];
    //delete
    SKAction *deleteAction1Plus = [SKAction waitForDuration:plusDuration];
    SKAction *deleteAction2Plus = [SKAction runBlock:^{
        [plusLabel removeFromParent];
    }];

    SKAction *deleteSequencePlus = [SKAction sequence:@[deleteAction1Plus,deleteAction2Plus]];
    [plusLabel runAction:deleteSequencePlus];

    [weakSelf addChild:plusLabel];

    //report
    [kAppDelegate reportScore];

    //also hide powerup image
    [self hideImageSquare:YES];

    //remove looped sound
    [self.soundSpin stop];
}

-(void)touchedFireball:(int)which node:(SKSpriteNode*)node{

    __weak typeof(self) weakSelf = self;
    __weak SKSpriteNode *weakFireball = node; //self.fireballAppear;

    //if(which >= kNumFireballs)
    if(node == nil || which >= kNumFireballs)
    {
        if([kHelpers isDebug])
            if([kHelpers isDebug])
                assert(0);
        return;
    }

    //invincible
    if(kAppDelegate.currentBuff == kBuffTypeStar) {
      [self playSound:weakSelf.soundBump];
        return;
    }

    //delay click
    float interval = kToucheFireballDelay;
    if(self.lastClickFireballDate && [[NSDate date] timeIntervalSinceDate:self.lastClickFireballDate] <  interval) {
        //skip
        [self playSound:weakSelf.soundBump];
        return;
    }

    [kAppDelegate dbIncFire];

    [self touchedOuch:which];

    //show X
    if(which >= 0)
        [self showFireballX:weakFireball isFireball:YES];

    //hide fire
    if(which >= 0)
        [weakSelf hideFireball:which all:NO];
}

-(SKSpriteNode*)createCloud
{
    //cloud
    SKSpriteNode* node = nil;

	NSMutableArray *cloudNames = [@[
			//regular
//            kCloudName,
//            kCloudName,
//            kCloudName,
//            kCloudName,
//            kCloudName,

            @"cloud5", //icloud

            @"cloud7", //birds

            @"cloud6", //twitter,


			//brain?
	] mutableCopy];

    //cloudSpecialDate
    if(kAppDelegate.inReview || kAppDelegate.level <= 2)
    {
        [cloudNames removeObject:@"cloud5"]; //icloud
        [cloudNames removeObject:@"cloud6"]; //twitter
    }

    NSString *cloudName = nil;

    if(self.cloudCount++ > 10) {
        //special
        cloudName = [cloudNames randomObject];
        self.cloudCount = 0;
    }
    else {
        //normal
        cloudName = kCloudName;
    }

    //level x-4
    if (kAppDelegate.subLevel == 4)
    {
        cloudName = kCloudName;
    }

    //force
    if([kHelpers isDebug])  //debug
    {
       //cloudName = @"cloud6"; //twitter
    }

	node = [SKSpriteNode spriteNodeWithImageNamed:cloudName];


    //node.name = @"cloud1_ignore";
    node.name = [NSString stringWithFormat:@"%@_ignore", cloudName];
    node.position = CGPointMake(-100, -100);
    node.zPosition = self.bgOverlay.zPosition + 1;
    node.alpha = 0.0f;
    node.scale = 1.0f;
    node.hidden = YES;

    //array
    [self.cloudArray addObject:node];
    [self addChild:node];
    return node;
}

-(SKSpriteNode*)createFireball
{
    //fireball appear
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"fireball3Frame1"];
    node.hidden = YES;

    node.userData = [[NSMutableDictionary alloc] init];

    //reset
    [node.userData setObject:@(NO) forKey:@"slow"];
    node.speed = 1.0f;

    //node.name = @"fireballAppear";
    int i = 0;
    node.name = [NSString stringWithFormat:@"fireballAppear%d", i];
    node.zPosition = 850;

    node.alpha = 0.0f;
    node.scale = 1.0f;
    node.position = CGPointMake(30,440);

    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
    node.position = CGPointMake(10.0,10.0);
    node.physicsBody.dynamic = YES;
    node.physicsBody.affectedByGravity = NO;

    node.physicsBody.categoryBitMask = ballCategory;
    node.physicsBody.collisionBitMask = wallCategory;

    node.physicsBody.restitution = 1.0;
    node.physicsBody.friction = 0.0;
    node.physicsBody.linearDamping = 0.0;
    node.physicsBody.angularDamping = 0.0;

    i = self.fireballAppearArray.count; //last
    [node.userData setObject:@(i) forKey:@"which"];

    //array
    [self.fireballAppearArray addObject:node];

    [self addChild:node];

    return node;
}

/*
-(SKSpriteNode*)createHeart
{
    //heart appear
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"power_up_heart"];
    node.name = kPowerUpNameHeart;
    node.zPosition = 900; //self.block.zPosition+1;
    node.alpha = 0.0f;
    node.scale = 1.4f;
    node.position = CGPointMake(30,440);

    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
    node.position = CGPointMake(10.0,10.0);
    node.physicsBody.dynamic = YES;
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.categoryBitMask = ballCategory;
    node.physicsBody.collisionBitMask = wallCategory;
    node.physicsBody.restitution = 1.0;
    node.physicsBody.friction = 0.0;
    node.physicsBody.linearDamping = 0.0;
    node.physicsBody.angularDamping = 0.0;

    //array
    [self.powerupArray addObject:node];

    [self addChild:node];

    return node;
}*/

-(void) showMiniShines
{
    for(SKSpriteNode *node in self.miniShineArray)
    {
        [node removeAllActions];
        node.hidden = NO;
        node.alpha = 0.0f;

        CGFloat margin = 20;

        //new position every fade out
        SKAction *positionAction = [SKAction runBlock:^{
            node.position = CGPointMake(margin + arc4random_uniform(self.frame.size.width - margin*2),
                                        margin + arc4random_uniform(self.frame.size.height - margin*2));
        }];

        CGFloat durationIn = 0.3f + arc4random_uniform(5)/10.f ;//0.5f;
        CGFloat durationOut = 0.3f + arc4random_uniform(5)/10.f ;//0.5f;

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

        CGFloat newScale = 1.4f;
        CGFloat oldScale = 0.6f;

        //scale
        SKAction *action0 = [SKAction scaleTo:newScale duration:durationIn];//in
        SKAction *action1 = [SKAction waitForDuration:0.1f];
        SKAction *action2 = [SKAction scaleTo:oldScale duration:durationOut];//out
        SKAction * actionSequence = [SKAction sequence:@[action0,action1,action2]];
        [node runAction:[SKAction repeatActionForever:actionSequence] withKey:@"miniShineScale"];

    }
}

-(void)hideMiniShines
{
    for(SKSpriteNode *node in self.miniShineArray)
    {
        [node runAction:[SKAction fadeAlphaTo:0.5f duration:0.3f] completion:^{
            [node removeAllActions];
            node.hidden = YES;
        }];
    }

}

-(SKSpriteNode*)createMiniShine
{
    //SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"ray4_combo3"];
    //SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"ray6"];
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"ray8"];
    node.name = @"miniShine_ignore";
    node.zPosition = 900;
    node.alpha = 0.0f;
    node.scale = 0.5f;
    node.position = CGPointMake(0,0);
    //array
    [self.miniShineArray addObject:node];

    [self addChild:node];

    return node;
}

-(SKSpriteNode*)createPowerUp:(PowerupType)which
{
	NSString *imageName = nil;
	NSString *nodeName = nil;
	CGFloat scale = 1.0f;

    switch(which)
    {
        case kPowerUpTypeStar:
            imageName = @"power_up_star";
            nodeName = kPowerUpNameStar;
			//scale = 1.0f;
            break;
        case kPowerUpTypeBomb:
            imageName = @"power_up_bomb";
            nodeName = kPowerUpNameBomb;
			//scale = 1.0f;
            break;
        case kPowerUpTypeHeart:
            imageName = @"power_up_heart";
            nodeName = kPowerUpNameHeart;
			//scale = 1.0f;
            break;
        case kPowerUpTypePotion:
            imageName = @"power_up_potion";
            nodeName = kPowerUpNamePotion;
            //scale = 1.0;
            break;
        case kPowerUpTypeDoubler:
            imageName = @"power_up_doubler";
            nodeName = kPowerUpNameDoubler;
            //scale = 1.0;
            break;
        case kPowerUpTypeAuto:
            imageName = @"power_up_auto";
            nodeName = kPowerUpNameAuto;
            //scale = 1.0;
            break;
        case kPowerUpTypeWeak:
            imageName = @"power_up_weak";
            nodeName = kPowerUpNameWeak;
            //scale = 1.0;
            break;
        case kPowerUpTypeShield:
            imageName = @"power_up_shield";
            nodeName = kPowerUpNameShield;
            //scale = 1.0f;
            break;

        case kPowerUpTypeGrow:
            imageName = @"power_up_grow";
            nodeName = kPowerUpNameGrow;
            //scale = 1.0f;
            break;

        case kPowerUpTypeShrink:
            imageName = @"power_up_shrink";
            nodeName = kPowerUpNameShrink;
            //scale = 1.0f;
            break;

        case kPowerUpTypeInk:
            imageName = @"power_up_ink";
            nodeName = kPowerUpNameInk;
            //scale = 1.0f;
            break;


        default:
            if([kHelpers isDebug])
                assert(0);
            break;
    }

	SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    node.name = nodeName;
    node.zPosition = 900; //above spike and fireballs: 850, 850+1
    node.alpha = 0.0f;
    node.scale = scale;
    node.position = CGPointMake(30,440);

    node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:15];
    node.position = CGPointMake(10.0,10.0);
    node.physicsBody.dynamic = YES;
    node.physicsBody.affectedByGravity = NO;
    node.physicsBody.categoryBitMask = ballCategory;
    node.physicsBody.collisionBitMask = wallCategory;
    node.physicsBody.restitution = 1.0;
    node.physicsBody.friction = 0.0;
    node.physicsBody.linearDamping = 0.0;
    node.physicsBody.angularDamping = 0.0;

	//powerup shine
	SKSpriteNode* powerupShine = [SKSpriteNode spriteNodeWithImageNamed:@"ray5"];
    powerupShine.name = @"powerupShine_ignore";
    powerupShine.userInteractionEnabled = false;
    powerupShine.zPosition = -1;
    powerupShine.alpha = 0.8f;
    powerupShine.scale = 0.5f;
    //powerupShine.position = self.buff.position;

    //[node addGlow]; //glow
    [node addChild:powerupShine];

	//rotate shine
    SKAction *oneRevolutionKey = [SKAction rotateByAngle:-M_PI*2 duration: 8];
    SKAction *repeatKey = [SKAction repeatActionForever:oneRevolutionKey];
    [powerupShine runAction:repeatKey];

    [node addGlow]; //glow

    //array
    [self.powerupArray addObject:node];

    [self addChild:node];

    return node;
}

-(void)showFireball:(BOOL)all{

    //fireball appear, show fireball

    if(kAppDelegate.noEnemies)
        return;

    if(self.winning || self.dying)
        return;

    if(kAppDelegate.gameController.showingKTPlay)
        return;

    if(self.flashFireballFlag)
        return;

    if(kAppDelegate.fireballVisible >= [kAppDelegate getMaxFireballs]) {
        return;
    }

    int demoModeMaxFireballs = 5;
    if(kAppDelegate.demoMode && (kAppDelegate.fireballVisible >= demoModeMaxFireballs)) {
        return;
    }

	//invincible
	if(kAppDelegate.currentBuff == kBuffTypeStar) {
       return;
    }

    //Log(@"showFireball");

    SKSpriteNode *newFireball = nil;

    //reset timer
    self.lastClickDate = [NSDate date];

    //create new
    newFireball = [self createFireball];


    if(!newFireball)
    {
        //can't find
        //assert(0);
        Log(@"can't create fireball");
        return;
    }

    //newFireball.shadowCastBitMask = 1;
    //newFireball.lightingBitMask = 1;

    //remove
    [newFireball removeAllActions];

    self.lastFireballDate = [NSDate date];

    kAppDelegate.fireballVisible++;
    kAppDelegate.fireballVisible = [kHelpers clamp:kAppDelegate.fireballVisible min:0 max:[kAppDelegate getMaxFireballs]];

    if(!all) {
        if(kAppDelegate.titleController.menuState == menuStateGame)
            [self playSound:self.soundFireballAppear];
    }

    if(!all)
        newFireball.hidden = NO;

    //random position
    int offset = 20; //make sure they don't go offscreen
    int random = arc4random_uniform(4);
    if(random == 0) {
        //bottom left
        newFireball.position = CGPointMake(50+offset, 110+offset);
    }
    else if(random == 1) {
        //bottom right
        newFireball.position = CGPointMake(self.frame.size.width - 50-offset, 110+offset);
    }
    else if(random == 2) {
        //top left
        newFireball.position = CGPointMake(50+offset, self.frame.size.height - 90-offset);
    }
    else if(random == 3) {
        //top right
        newFireball.position = CGPointMake(self.frame.size.width - 50-offset, self.frame.size.height - 90-offset);
    }

    NSString *fireballName = [kAppDelegate getFireballName];
    //force bat
    //fireballName = @"fireball10";

    [newFireball.userData setObject:fireballName forKey:@"fireballName"];

    float speedx = 1.5;
    float speedy = 1.5f;

    //random speed
    float randomSpeed = 0.0f;
    randomSpeed = arc4random_uniform(kRandomSpeedIncrease);
    speedx += (randomSpeed/10.0) * 1.0f;
    randomSpeed = arc4random_uniform(kRandomSpeedIncrease);
    speedy += (randomSpeed/10.0) * 1.0f;

    //random direction
    random = arc4random_uniform(2);
    if(random == 0)
        speedx *= -1;
    random = arc4random_uniform(2);
    if(random == 0)
        speedy *= -1;


    //force straight speed for invaders
    if([fireballName isEqualToString:@"fireball16"] || [fireballName isEqualToString:@"fireball17"] || [fireballName isEqualToString:@"fireball21"])
    {
        if([kHelpers randomBool])
        {
            speedx = 0.0f;
        }
        else
        {
            speedy = 0.0f;
        }
    }

    NSString *particleName = @"fire2";

    BOOL isBigger = NO;
    BOOL isRotate = NO;
    BOOL isRotateFaster = NO;
    BOOL isCanon = NO;
    BOOL isBat = NO;
    BOOL isSmaller = NO;
    BOOL isTiny = NO;
    BOOL isScale = NO;
    //BOOL isFade = NO;

    //blue faster
    if([fireballName isEqualToString:@"fireball4"])
    {
        //speedx *= 1.6f;
        //speedy *= 2.0;

        //level speed increase
        speedx *= [kAppDelegate getSpeedMultIndex];
        speedy *= [kAppDelegate getSpeedMultIndex];

        particleName = @"fire3";

        isScale = YES;

    }
    //zelda ball blue/red
    else if([fireballName isEqualToString:@"fireball8"])
    {
        //level speed increase
        speedx *= [kAppDelegate getSpeedMultIndex];
        speedy *= [kAppDelegate getSpeedMultIndex];

        isSmaller = YES;
        isScale = YES;

    }
    //mario slower
    else if([fireballName isEqualToString:@"fireball1"])
    {
        //speedx *= 0.9f;
        //speedy *= 0.3f;

        //level speed increase
        if(YES)
        {
            speedx /= [kAppDelegate getSpeedMultIndex];
            speedy /= [kAppDelegate getSpeedMultIndex];
        }

    }
    //canon
    else if([fireballName isEqualToString:@"fireball5"])
    {
        //speedx *= 0.8f;
        //speedy *= 0.8f;

        //level speed increase
        if(YES)
        {
            speedx /= [kAppDelegate getSpeedMultIndex];
            //speedy /= [kAppDelegate getSpeedMultIndex];
            //speedy = (speedy < 0)? -0.3f : 0.3f;
            speedy = (speedy < 0)? -0.5f : 0.5f;
        }

        isCanon = YES;

        particleName = nil;
        isScale = YES;

    }
    //spin
    else if([fireballName isEqualToString:@"fireball6"])
    {
        speedx *= 1.4;
        speedy *= 1.4f;

        //level speed increase
        if(YES)
        {
            speedx *= [kAppDelegate getSpeedMultIndex];
            speedy *= [kAppDelegate getSpeedMultIndex];
        }

        isSmaller = YES;

        particleName = nil;

    }
    //asteroid
    else if([fireballName isEqualToString:@"fireball7"])
    {
        //speedx *= 0.8f;
        //speedy *= 0.8f;

        //level speed increase
        if(YES)
        {
            //slower
            speedx /= [kAppDelegate getSpeedMultIndex] * 0.7;
            speedy /= [kAppDelegate getSpeedMultIndex] * 0.7;
        }

        particleName = nil;

        isBigger = YES;
        isRotate = YES;

    }

    //boulder
    else if([fireballName isEqualToString:@"fireball12"])
    {
        //speedx *= 0.8f;
        //speedy *= 0.8f;

        //level speed increase
        if(YES)
        {
            //slower
            speedx /= [kAppDelegate getSpeedMultIndex] * 0.7;
            speedy /= [kAppDelegate getSpeedMultIndex] * 0.7;
        }

        particleName = nil;

        isBigger = NO;
        isRotate = YES;
    }


    //orange seed -> green turtle
    else if([fireballName isEqualToString:@"fireball18"])
    {
        //speedx *= 0.8f;
        //speedy *= 0.8f;

        //level speed increase
        if(YES)
        {
            //slower/afster
            speedx *= [kAppDelegate getSpeedMultIndex] * 1.1f;
            speedy *= [kAppDelegate getSpeedMultIndex] * 0.5;
        }

        particleName = nil;

        isSmaller = NO;
        isTiny = NO;
        isRotate = NO;
        isRotateFaster = NO;
        isScale = NO;
    }
	//red turtle
    else if([fireballName isEqualToString:@"fireball20"])
    {
		//level speed increase
        if(YES)
        {
            //faster
            speedx *= [kAppDelegate getSpeedMultIndex] * 1.6f;
            speedy = (speedy < 0)? -0.5f : 0.5f;
        }

        particleName = nil;

        isSmaller = NO;
        isTiny = NO;
        isRotate = NO;
        isRotateFaster = NO;
        isScale = NO;

    }


    //illuminati
    else if([fireballName isEqualToString:@"fireball22"])
    {
        isScale = YES;

        particleName = nil;
    }

    //barrel
    else if([fireballName isEqualToString:@"fireball23"])
    {
        isRotate = YES;

        particleName = nil;
    }

    //cactus
    else if([fireballName isEqualToString:@"fireball24"])
    {
        isRotate = YES;
        isScale = YES;
        isSmaller = YES;

        particleName = nil;
    }

    //white spike
    else if([fireballName isEqualToString:@"fireball19"])
    {
        //speedx *= 0.8f;
        //speedy *= 0.8f;

        //level speed increase
        if(YES)
        {
            speedx /= [kAppDelegate getSpeedMultIndex];
            //speedy /= [kAppDelegate getSpeedMultIndex];
            //speedy = (speedy < 0)? -0.3f : 0.3f;
            speedy = (speedy < 0)? -0.5f : 0.5f;
        }

        isCanon = YES;
        isScale = YES;

        particleName = nil;
    }

    //ninja
    else if([fireballName isEqualToString:@"fireball13"]) //fireball14
    {
        //speedx *= 0.8f;
        //speedy *= 0.8f;

        //level speed increase
        if(YES)
        {
            //slower/afster
            speedx *= [kAppDelegate getSpeedMultIndex] * 1.1f;
            speedy *= [kAppDelegate getSpeedMultIndex] * 0.5;
        }

        particleName = nil;

        isSmaller = NO;
        isTiny = YES;
        isRotate = YES;
        isRotateFaster = YES;
    }

    //saw blade
    else if([fireballName isEqualToString:@"fireball15"])     {

        //level speed increase
        if(YES)
        {
            //slower/afster
            speedx *= [kAppDelegate getSpeedMultIndex] * 1.1f;
            speedy *= [kAppDelegate getSpeedMultIndex] * 0.5;
        }

        particleName = nil;

        isSmaller = NO;
        isTiny = NO;
        isRotate = YES;
        isRotateFaster = YES;
    }

    //mega man 2
    else if([fireballName isEqualToString:@"fireball9"])
    {
        //speedx *= 0.8f;
        //speedy *= 0.8f;

        //level speed increase
        if(YES)
        {
            //slower
            speedx *= [kAppDelegate getSpeedMultIndex] * 0.4;
            speedy *= [kAppDelegate getSpeedMultIndex] * 0.4;
        }

        particleName = nil;

        isBigger = NO;
        isScale = YES;
    }

    //bat
    else if([fireballName isEqualToString:@"fireball10"])
    {
        //speedx *= 0.8f;
        //speedy *= 0.8f;

        //level speed increase
        if(YES)
        {
            //little faster
            speedx *= [kAppDelegate getSpeedMultIndex] * 0.8f;
            //speedy *= [kAppDelegate getSpeedMultIndex] * 0.1f; //0.8f
            speedy = (speedy < 0)? -0.5f : 0.5f;

        }

        particleName = nil;

        isBigger = NO;
        isBat = YES;
    }

    //bat red
    else if([fireballName isEqualToString:@"fireball11"])
    {
        //level speed increase
        if(YES)
        {
            //faster
            speedx *= [kAppDelegate getSpeedMultIndex] * 1.6f;
            speedy = (speedy < 0)? -0.5f : 0.5f;
        }

        particleName = nil;

        isBigger = NO;
        isBat = YES;
    }

    //invaders
    else if([fireballName isEqualToString:@"fireball16"] || [fireballName isEqualToString:@"fireball17"] || [fireballName isEqualToString:@"fireball21"])
    {
        //speedx *= 1.4;
        //speedy *= 1.4f;

        //level speed increase
        if(YES)
        {
            speedx *= [kAppDelegate getSpeedMultIndex];
            speedy *= [kAppDelegate getSpeedMultIndex];
        }

        isSmaller = YES;
        particleName = nil;

        isScale = YES;

    }

    else {
        //regular
        //level speed increase
        if(YES)
        {
            speedx *= [kAppDelegate getSpeedMultIndex];
            speedy *= [kAppDelegate getSpeedMultIndex];
        }

        //isScale = YES;
    }



    //min/max

    float speedMin = 1.0f;
    float speedMax = 8.0f;

    if(speedx > 0.0f) {
        if(speedx > speedMax)
            speedx = speedMax;

        if(speedx < speedMin)
            speedx = speedMin;
    }
    if(speedy > 0.0f) {
        if(!isCanon && !isBat) {
            if(speedy > speedMax)
                speedy = speedMax;

            if(speedy < speedMin)
                speedy = speedMin;
        }
    }

    if(speedx < 0.0f) {
        if(-speedx > speedMax)
            speedx = -speedMax;

        if(-speedx < speedMin)
            speedx = -speedMin;
    }
    if(speedy < 0.0f) {
        if(!isCanon && !isBat) {
            if(-speedy > speedMax)
                speedy = -speedMax;

            if(-speedy < speedMin)
                speedy = -speedMin;
        }
    }

    //force test
    //speedx = speedy = 2.0f;


    //Log(@"fireball speed (%@): %.2f, %.2f", fireballName, speedx, speedy);

    //reset speed
    //[newFireball.physicsBody setVelocity:CGVectorMake(0,0)];

    //reset rotation
    newFireball.zRotation = 0;

    //action
    SKAction *actionImpulse = [SKAction applyImpulse:CGVectorMake(speedx,speedy) duration:0.1f];
    [newFireball runAction:actionImpulse afterDelay:0.0f];

    //newFireball.xScale = 1.1;
    //random size
    float sizeOffset = arc4random_uniform(5)/10.0f;

    float size = 1.0 + sizeOffset;

    if(isBigger) {
        size *= 1.5f; //1.7 //bigger
    }
    if(isSmaller) {
        size *= 0.8f; //smaller
    }
    if(isTiny) {
        size *= 0.6f; //smaller
    }


    newFireball.xScale = size;
    newFireball.yScale = newFireball.xScale;

    float oldScale = newFireball.xScale;
    float newScale = newFireball.xScale * 1.2;

    //fade
    SKAction *fadeAction = [SKAction fadeAlphaTo:1.0f duration:0.3f];
    [newFireball runAction:fadeAction];

    if(isScale)
    {
        //scale
        SKAction *action0 = [SKAction scaleTo:newScale duration:0.2f];//in
        SKAction *action1 = [SKAction waitForDuration:0.1f];
        SKAction *action2 = [SKAction scaleTo:oldScale duration:0.2f];//out
        SKAction * actionSequence = [SKAction sequence:@[action0,action1,action2]];
        [newFireball runAction:[SKAction repeatActionForever:actionSequence] withKey:@"fireballAppear1_scale"];
    }

    if(isRotate)
    {
        //spin
        BOOL counterClockwise = [kHelpers randomBool];
        float durationOffset = arc4random_uniform(3)/10.0f; //+0.3f
        SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 * (counterClockwise?-1:1) duration: (isRotateFaster ? 0.3f : 3.0f)+durationOffset];
        SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
        [newFireball runAction:repeat withKey:@"fireballAppear1_rotate"];
    }

    //fade
    /*SKAction *action0 = [SKAction fadeAlphaTo:0.8f duration:0.2f];//in
    SKAction *action1 = [SKAction waitForDuration:0.1f];
    SKAction *action2 = [SKAction fadeAlphaTo:0.5f duration:0.2f];//in
    SKAction *actionSequence = [SKAction sequence:@[fadeAction,action0,action1,action2]];
    */

    //frames

    float timePerFrame = 0.1f;
    //faster blue
    if([fireballName isEqualToString:@"fireball4"]) {
        timePerFrame *= 0.6f;
    }
    //mario slower
    else if([fireballName isEqualToString:@"fireball"])
    {
        timePerFrame *= 2.0f;
    }


    NSMutableArray *fireballFrames = [NSMutableArray array];
    UIImage *tempImage = nil;
    SKTexture* tempTexture = nil;

    tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame1", fireballName]];
    if(tempImage)
        tempTexture = [SKTexture textureWithImage:tempImage];

    if(tempTexture && tempImage) {
        [fireballFrames addObject:tempTexture];
    }

    tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame2", fireballName]];
    if(tempImage)
        tempTexture = [SKTexture textureWithImage:tempImage];

    if(tempTexture && tempImage) {
        [fireballFrames addObject:tempTexture];
    }

    tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame3", fireballName]];
    if(tempImage)
        tempTexture = [SKTexture textureWithImage:tempImage];

    if(tempTexture && tempImage) {
        [fireballFrames addObject:tempTexture];
    }


    tempImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@Frame4", fireballName]];
    if(tempImage)
        tempTexture = [SKTexture textureWithImage:tempImage];

    if(tempTexture && tempImage) {
        [fireballFrames addObject:tempTexture];
    }


    SKAction *tempAnim = [SKAction animateWithTextures:fireballFrames
                                          timePerFrame:timePerFrame];

    /*
    SKAction *tempAnim = [SKAction animateWithTextures:@[
                                                         [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame1", fireballName]],
                                                         [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame2", fireballName]],
                                                         [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame3", fireballName]],
                                                         [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@Frame4", fireballName]]]
                                          timePerFrame:timePerFrame];
*/

    float secs = 0.0f;
    if(all) {
        //delay when all
        secs = 0.1f + arc4random_uniform(5)/10.0f;
    }
    [newFireball runAction:[SKAction repeatActionForever:tempAnim] withKey:@"fireballAppear3"];

    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        newFireball.hidden = NO;
    //});



    //auto hide
    /*
    int min = 10;
    int max = 20;
    int randomDelay =  min + arc4random_uniform(max);
    [newFireball runAction:[SKAction removeFromParent] afterDelay:randomDelay];
     */


    //fire particles

    [newFireball removeAllChildren];

    /*
    if( ![kHelpers isSlowDevice] && particleName) {
        //particle

        SKEmitterNode *myParticle = [SKEmitterNode emitterWithResourceNamed:particleName];
     assert(myParticle);
        myParticle.zPosition = newFireball.zPosition+1;
        myParticle.name = @"fire_ignore";
        //myParticle.numParticlesToEmit = 20;
        //myParticle.position = self.lastClickPosition;

        //myParticle.position = myParticle.position;
        //myParticle.targetNode = self.scene;
        //myParticle.targetNode = newFireball;
        //myParticle.position = CGPointMake(0,0);
        //myParticle.particleAction = move; // TODO iOS9 compatibility issues!

        [newFireball addChild:myParticle];
        //[self addChild:myParticle];

        //delete
        //[myParticle runAction:[SKAction removeFromParent] afterDelay:kParticleAutoDelete];
    }
     */

    //particle
    /*[self.timerFireballParticle invalidate];
    self.timerFireballParticle = nil;
    self.timerFireballParticle = [NSTimer scheduledTimerWithTimeInterval:kParticleDelay target:self
                                                        selector:@selector(actionTimerFireballParticle:) userInfo:@"actionTimerFireballParticle" repeats:NO];
     */



    //speed
    //[self.timerFireball invalidate];
    //self.timerFireball = nil;

    //don't hide, disabled
    /*
    float interval = 60;
    self.timerFireball = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                 selector:@selector(actionTimerFireball:) userInfo:@"actionFireballStar" repeats:NO];
    */


    if(!all) {
        //[kAppDelegate saveState];

        //flash
        [kAppDelegate.gameController showFlash:kFlashColorYellow];

        //show touch anim
        [self showTouchAnim:newFireball];
    }

    //label
    [self updateNumFireballLabel:YES];
}

- (void) actionTimerWorldTime:(NSTimer *)incomingTimer {

    //disabled, lower
    //return;

    //Log(@"***** actionTimerWorldTime: %d", (int)(kAppDelegate.worldTimeLeft));

    if(self.winning || self.dying)
        return;

    if(kAppDelegate.isPlayingVideoAd)
        return;

    //buff
    if(kAppDelegate.currentBuff != kBuffTypeNone)
    {
        kAppDelegate.buffSecs--;

        [self updateBuffLabel:YES];

        if(kAppDelegate.buffSecs <= 0)
        {
            kAppDelegate.buffSecs = 0;
            [self hideBuff];

            //[self.soundGasp play];
        }

    }

    if(self.skipTime)
    {
        self.skipTime = NO;
        return;
    }

    //vip, unlimited
    //∞
    //BOOL premium = [kAppDelegate isPremium];
    if(kAppDelegate.noTime)
    {
        kAppDelegate.worldTimeLeft = kTimeMax;
        [self updateTimeLabel:NO];
        return;
    }

    if(kAppDelegate.worldTimeLeft == 0) {

        [self updateTimeLabel:NO];
        return;
    }


    //wait for lava
    if(self.hidingLava)
        return;

    //disabled here, don't break buff time, but still update time
    //return;

    kAppDelegate.worldTimeLeft--; //++

    if(kAppDelegate.worldTimeLeft < 0)
        kAppDelegate.worldTimeLeft = 0;

    if(kAppDelegate.worldTimeLeft > kTimeMax)
        kAppDelegate.worldTimeLeft = kTimeMax;

    if(kAppDelegate.worldTimeLeft <= kWorldTimeLow2) {
        //low
        [self.soundLowBeep play];
    }

    if(kAppDelegate.worldTimeLeft == kWorldTimeLow2)
    {
        //show laval and hand
        self.lastClickDate = nil;
        [self showArrowBlockWithLava:YES]; //NO
    }

#if 0
    //get hurt at time 0
    if(kAppDelegate.worldTimeLeft == 0 && timeBefore >0)
    {
        //ouch
        [self touchedFireball:-1 node:self.clock];

        //reset time
        [self resetTime];
    }
#endif

    [self updateTimeLabel:YES];
}

- (void) actionTimerFireballsAlpha:(NSTimer *)incomingTimer
{
    //toggle
    [self setAllFireballsAlpha:self.flashFireballFlag? kFireballAlphaDisabled2 : kFireballAlphaDisabled  animated:YES];

    self.flashFireballFlag = !self.flashFireballFlag;
}

-(void)setAllFireballsAlpha:(float)alpha animated:(BOOL)animated{

    //Log(@"setAllFireballsAlpha: %f", alpha);

    float interval = animated ? 0.1f: 0.0f;

    for(int i=0;i<kNumFireballs; i++) {

        SKSpriteNode *newFireball = [self.fireballAppearArray safeObjectAtIndex:i];
        if(newFireball && !newFireball.hidden) {
            //newFireball.alpha = alpha;
            [newFireball runAction:[SKAction fadeAlphaTo:alpha duration:interval]];
        }
    }

    if(!self.spike.hidden) {
        [self.spike runAction:[SKAction fadeAlphaTo:alpha duration:interval]];
    }
}

-(void)hideAllFireballs{
    [self hideAllFireballs:NO];
}



-(void)freezeAllFireballs{

    //Log(@"freezeAllFireballs");

    for(int i=0;i<kNumFireballs; i++) {

        SKSpriteNode *newFireball = [self.fireballAppearArray safeObjectAtIndex:i];
        //if(newFireball.hidden)
        //if(newFireball && !newFireball.hidden)
        if(newFireball)
        {
            //newFireball.speed = 0;
            //CGVector impulse = CGVectorMake(0,0);
            //[newFireball.physicsBody applyImpulse:impulse];
            newFireball.physicsBody.velocity = CGVectorMake(0, 0);
            newFireball.physicsBody.angularVelocity = 0.0f;


            newFireball.physicsBody.dynamic = NO;
            newFireball.physicsBody.dynamic = YES;
        }
    }
}

-(void)randomFireballSpeed
{
    for(int i=0;i<self.fireballAppearArray.count; i++)
    {
        NSArray *randomArray = [self.fireballAppearArray shuffledArray];
        SKSpriteNode *newFireball = [randomArray safeObjectAtIndex:i];

        if(newFireball && !newFireball.hidden)
        {
            NSString *fireballName = [newFireball.userData objectForKey:@"fireballName"];

            //bats, random slowdown
            if(([fireballName isEqualToString:@"fireball10"] || [fireballName isEqualToString:@"fireball11"])
               && ![[newFireball.userData objectForKey:@"slow"] boolValue])
            {
                [newFireball.userData setObject:@(YES) forKey:@"slow"];

                //new velocity
                CGVector velocityBefore = newFireball.physicsBody.velocity;
                CGVector velocity = velocityBefore;
                velocity.dx *= kBatSlowdownMult;
                velocity.dy *= kBatSlowdownMult;
                [newFireball.physicsBody setVelocity:velocity];

                //reset after delay
                SKAction *wait = [SKAction waitForDuration:kBatSlowdownDuration];
                SKAction *reset = [SKAction runBlock:^{
                    //velocity
//                    CGVector velocity2 = newFireball.physicsBody.velocity;
//                    velocity2.dx /= kBatSlowdownMult;
//                    velocity2.dy /= kBatSlowdownMult;

                    CGVector velocity2 = velocityBefore;

                    //speed
                    newFireball.speed = 1.0f;

                    [newFireball.physicsBody setVelocity:velocity2];

                    [newFireball.userData setObject:@(NO) forKey:@"slow"];
                }];

                [newFireball runActionsSequence:@[wait, reset]];

                //found one, done
                return;
            }
        }
        else {
            //keep looking
        }
    }
}
-(void)hideAllFireballs:(BOOL)animated
{
    [self hideAllFireballs:animated explode:NO];
}

-(void)hideAllFireballs:(BOOL)animated explode:(BOOL)explode
{

    int j=0;
    for(int i=0;i<kNumFireballs; i++) {

        SKSpriteNode *newFireball = [self.fireballAppearArray safeObjectAtIndex:i];
        //if(newFireball.hidden)
        if(newFireball && !newFireball.hidden)
        {
            //good

            //delayed hide
            //float secs = j * 0.05f;
            float secs = j * 0.02f;

            if(animated) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self hideFireball:i all:animated explode:explode];
                });
            }
            else {
                [self hideFireball:i all:!animated explode:explode];
            }

            j++;
        }
        else {
            //keep looking
        }

    }

    //[kAppDelegate saveState];

    //reset array
    if(!animated) {
        [self deleteAllFireballs];
    }
}

-(void) deleteAllFireballs {

    for(int i=0;i<kNumFireballs; i++) {

        SKSpriteNode *newFireball = [self.fireballAppearArray safeObjectAtIndex:i];
        newFireball.hidden = YES;
        [newFireball removeFromParent];
    }

    [self.fireballAppearArray removeAllObjects];

}

-(void)hideFireball:(int)which all:(BOOL)all
{
    [self hideFireball:which all:all explode:NO];
}

-(void)hideFireball:(int)which all:(BOOL)all explode:(BOOL)explode
{
    //disabled
    explode = NO;

    __weak typeof(self) weakSelf = self;
    __weak SKSpriteNode *weakFireball = nil; //self.fireballAppear;

    if(which >= kNumFireballs) {
        //assert(0);
        Log(@"invalid hide fireballs");
        return;
    }

    weakFireball = [self.fireballAppearArray safeObjectAtIndex:which];

    if(!weakFireball)
    {
        //assert(0);
        Log(@"invalid hide fireballs 2");
        return;
    }

    kAppDelegate.fireballVisible--;
    if(kAppDelegate.fireballVisible <= 0) {
        kAppDelegate.fireballVisible = 0;
        self.lastFireballDate = nil;
    }

    [weakFireball removeActionForKey:@"fireballAppear1"];
    [weakFireball removeActionForKey:@"fireballAppear2"];
    [weakFireball removeActionForKey:@"fireballAppear3"];


    //speed
    [weakFireball.physicsBody setVelocity:CGVectorMake(0,0)];


    if(explode)
    {
        [self showExplosion:weakFireball];
    }

    float fadeDuration = 0.2f;

    float scaleOut = 0.3f;

    if(!all) {
        //fade
        SKAction *fadeAction = [SKAction fadeOutWithDuration:fadeDuration];
        [weakFireball runAction:fadeAction completion:^{
            weakFireball.hidden = YES;
        }];

        //scale
        SKAction *scaleAction = [SKAction scaleTo:scaleOut duration:fadeDuration];
        [weakFireball runAction:scaleAction completion:^{
        }];


        //fireball hide
        [weakSelf playSound:weakSelf.soundFireballHide];

        //[kAppDelegate saveState];
    }
    else {
        //no fade
        //weakFireball.hidden = YES;

        //fade
        weakFireball.alpha = 0.9f;
        SKAction *fadeAction = [SKAction fadeOutWithDuration:fadeDuration];
        [weakFireball runAction:fadeAction completion:^{
            weakFireball.hidden = YES;
        }];

        //scale
        SKAction *scaleAction = [SKAction scaleTo:scaleOut duration:fadeDuration];
        [weakFireball runAction:scaleAction completion:^{
        }];


        //fireball hide
        //[weakSelf playSound:weakSelf.soundFireballHide];

        //smoke particles
        if( ![kHelpers isSlowDevice]) {
            //particle
            SKEmitterNode *myParticle = [SKEmitterNode emitterWithResourceNamed:@"smoke2"];
            assert(myParticle);
            myParticle.zPosition = weakFireball.zPosition-1;
            myParticle.name = @"smoke_3_ignore";
            myParticle.numParticlesToEmit = 20;
            myParticle.position = weakFireball.position;
            [self removeChildrenNamed:myParticle.name];
            if(kEnableEmiters)
                [weakSelf addChild:myParticle];

            //delete
            [myParticle runAction:[SKAction removeFromParent] afterDelay:kParticleAutoDelete];
        }
    }

    //label
    [self updateNumFireballLabel:YES];

}

-(void)showExplosionFlash:(SKSpriteNode*)sprite{
    //explosion / bomb
    self.flash.position = sprite.position;
    self.flash.zPosition = 1000; //sprite.zPosition + 1;
    self.flash.alpha = 0.9f;
    self.flash.hidden = NO;
    self.flash.xScale = self.flash.yScale = 0.1f; //0.05f;

    [self.flash removeAllActions];

    float duration = 1.2; //0.6f;
    float scaleSize = 5.0f; //2.4f; //2.0f;
    SKAction *fadeIn = [SKAction fadeAlphaTo:0.1f duration:duration];
    SKAction *scale = [SKAction scaleTo:scaleSize duration:duration];
    scale.timingMode = SKActionTimingEaseOut; //SKActionTimingEaseIn;

    SKAction *hide = [SKAction fadeOutWithDuration:0.2f];

    [self.flash runAction:[SKAction sequence:@[scale, hide]] completion:^{
        [self.flash removeAllActions];
        self.flash.alpha = 0;;
    }];

    [self.flash runAction:fadeIn];

    //fast flash show/hide
//    SKAction *fastIn = [SKAction fadeInWithDuration:0.0f];
//    SKAction *fastOut = [SKAction fadeOutWithDuration:0.0f];
//    SKAction *fastWait = [SKAction waitForDuration:0.001f];
//    [self.flash runActionsSequenceForever:@[fastIn, fastWait, fastOut, fastWait]];

    //2

    if(YES) {
        //explosion / bomb
        self.flash2.position = sprite.position;
        self.flash2.zPosition = self.flash.zPosition -1;
        self.flash2.alpha = 0.3f;
        self.flash2.hidden = NO;
        self.flash2.xScale = self.flash.yScale = 0.1f; //0.05f;

        //rotate sideways
        self.flash2.zRotation = RADIANS(90);

        [self.flash2 removeAllActions];

        duration = 2.0f;
        scaleSize = 5.0f;
        fadeIn = [SKAction fadeAlphaTo:0.1f duration:duration];
        scale = [SKAction scaleTo:scaleSize duration:duration];
        scale.timingMode = SKActionTimingEaseOut; //SKActionTimingEaseIn;
        hide = [SKAction fadeOutWithDuration:0.2f];
        [self.flash2 runAction:[SKAction sequence:@[scale, hide]] completion:^{
            [self.flash2 removeAllActions];
            self.flash2.alpha = 0;;
        }];
        [self.flash2 runAction:fadeIn];

        //fast flash show/hide
        //[self.flash2 runActionsSequenceForever:@[fastIn, fastWait, fastOut, fastWait]];
    }


    //also flash
    float secs = 0.1f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [kAppDelegate.gameController showFlash:kFlashColorWhiteFull autoHide:NO];
    });


    //flash toggle
    /*SKAction *toggle = [SKAction runBlock:^{
        self.flash.hidden = self.flash.hidden;
    }];
    SKAction *toggleDelay = [SKAction waitForDuration:0.1f];
    [self.flash runActionsSequenceForever:@[toggleDelay, toggle]];
    */

    //images
    /*SKAction *textureAction = [SKAction animateWithTextures:
                         @[[SKTexture textureWithImageNamed:@"flash2"],
                           [SKTexture textureWithImageNamed:@"flash2_2"]] timePerFrame:0.2f];
    [self.flash runActionsSequence:@[[SKAction repeatActionForever:textureAction]]];*/
}

-(void)hideAllClouds:(BOOL)animated
{
    return;

    Log(@"hideAllClouds **************************");

    //int j=0;
    for(int i=0;i<self.cloudArray.count; i++)
    {

        SKSpriteNode *cloud = [self.cloudArray safeObjectAtIndex:i];
        if(cloud && !cloud.hidden)
        {
            [cloud removeAllActions];

            SKAction *hideAction = [SKAction runBlock:^{
                cloud.hidden = YES;
                [cloud removeFromParent];
            }];


            if(animated)
            {
                [cloud runAction:[SKAction fadeOutWithDuration:0.5f] completion:^{
                    [cloud runAction:hideAction];
                }];
            }
            else
            {
                [cloud runAction:[SKAction fadeOutWithDuration:0.0f] completion:^{
                    [cloud runAction:hideAction];
                }];
            }

            //[self.cloudArray removeObject:cloud];
        }
    }

     [self.cloudArray removeAllObjects];
}

-(void)showInk
{
    CGFloat buffDuration = [self getBuffDuration:kBuffTypeInk];

    [self.ink removeAllActions];

    CGFloat offsetVal = 100;
    CGFloat offsetX = -offsetVal/2 + arc4random_uniform(offsetVal);
    CGFloat offsetY = -offsetVal/2 + arc4random_uniform(offsetVal);

    self.ink.position = CGPointMake(self.block.position.x + offsetX, self.block.position.y + offsetY);
    self.ink.zRotation = 0;

    self.ink.hidden = NO;

    //scale
    CGFloat scale = 2.0f ; //+ -5 + arc4random_uniform(10);
    [self.ink runAction:[SKAction scaleTo:scale duration:0.0f]];

    //fade
    SKAction *fadeIn =  [SKAction fadeAlphaTo:1.0f duration:0.3];

    //rotate
//    int randomAngle = arc4random_uniform(360);
//    SKAction *rotate = [SKAction rotateByAngle:randomAngle duration:0.0f];
//    [self.ink runAction:rotate];

    //SKAction *fadeOutSlow = [SKAction fadeAlphaTo:0.9f duration:duration];
    SKAction *moveSlow = [SKAction moveByX:0.0f y:-200.0f duration:buffDuration];

    SKAction *slowGroup = [SKAction group:@[/*fadeOutSlow,*/moveSlow]];
    SKAction *sequence = [SKAction sequence:@[fadeIn,slowGroup]];

    [self.ink runAction:sequence];

}

-(void)hideInk
{
    if(self.ink.hidden)
        return;

    //[self.ink removeAllActions];

    //self.ink.hidden = YES;
    //self.ink.alpha = 0.0f;

    [self.ink runAction:[SKAction fadeOutWithDuration:0.3] completion:^{

        [self.ink removeAllActions];
        self.ink.hidden = YES;
    }];


}

-(void)showLavaAlert {
    //normal
    if(kAppDelegate.playedLavaAlert)
       return;

    kAppDelegate.playedLavaAlert = YES;
    //[kAppDelegate saveState];

    //NSString *message = @"Watch out for the rising <color1>Lava</color1>! 🌋";
    //NSString *message = @"Watch out for the rising <color1>Lava</color1>!";
    NSString *message = @"Watch out for the rising <color1>Lava</color1>!\nKeep tapping the Block to hide it.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                             type:kAlertButtonGreen
                          handler:^(SIAlertView *alert) {
                              //
                              [kAppDelegate playSound:kClickSound];
                              //nothing
                          }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    //pause
    [self enablePause:YES];
    [kAppDelegate.gameController blurScene:YES];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];

    }];

    [kAppDelegate.alertView show:YES];
    [kAppDelegate.gameController showVCR:YES animated:YES];
}


//showlaval
-(void)showLava {
    [self showLavaHurt:NO];
}

-(void)showLavaHurt:(BOOL)hurt {

    //disabled
    if([kHelpers isDebug])
    {
        //return;
    }

//    if(!self.lava.hidden)
//        return;

    //Log(@"***** showLavaHurt");

    if(kAppDelegate.currentBuff != kBuffTypeNone)
    {
        //not during buff
        //return;
    }

	if(self.lastLavaDate && !hurt)
    {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastLavaDate];
        if(interval < 20.0f) //30
        {
            return;
        }
    }
    self.lastLavaDate = [NSDate date];

	//alert
	[self showLavaAlert];

    //hide cheat button
    if([kHelpers isDebug])
    {
        //kAppDelegate.gameController.cheatButton.alpha = 0.0f;
    }

    //red arrows
    if(YES)
    {
        //arrow warning
        [self.redArrow removeAllActions];
        self.redArrow.alpha = 1.0f;

        float scale = 1.4f; //1.0f;

        {
            //from bottom
            int bannerOffset = [self getBannerOffset]; //18

            self.redArrow.position = CGPointMake(self.frame.size.width/2, bannerOffset + [self getIPhoneXBottom]);
            self.redArrow.xScale = scale;
            self.redArrow.yScale = -scale;
            self.redArrow.zRotation = RADIANS(90);
        }

        self.redArrow.zPosition = self.lava.zPosition + 100;

        //fade in/out
        SKAction *actionArrowFadeIn = [SKAction fadeInWithDuration:0.0f];
        SKAction *actionArrowFadeOut = [SKAction fadeOutWithDuration:0.0f];
        SKAction *actionArrowWait = [SKAction waitForDuration:0.1f];

        SKAction* sequenceArrow = [SKAction sequence:@[actionArrowFadeIn, actionArrowWait, actionArrowFadeOut, actionArrowWait]];
        [self.redArrow runAction:[SKAction repeatActionForever:sequenceArrow]];

        //and stop
        SKAction* actionResetRedArrow = [SKAction runBlock:^{
            [self.redArrow removeAllActions];
            [self.redArrow runAction:[SKAction fadeOutWithDuration:0.1f]];
        }];
        [self runAction:actionResetRedArrow afterDelay:1.5f];

    }


    //sound
    [self.soundLava stop];
    [self playSound:self.soundLava];

    [self.lava enable:YES];

    //reset
    [self.lava removeAllActions];

    //animate
    SKAction *tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"lava_1"],
                                                         [SKTexture textureWithImageNamed:@"lava_2"],
                                                         [SKTexture textureWithImageNamed:@"lava_3"],
                                                         [SKTexture textureWithImageNamed:@"lava_4"],
                                                         ]
                                          timePerFrame:0.2f];
    [self.lava runAction:[SKAction repeatActionForever:tempAnim]];


    self.lava.position = CGPointMake(self.frame.size.width/2, -self.lava.size.height/2);
    self.lava.alpha = 1.0f;
    self.lava.hidden = NO;

	CGFloat showLavaDuration = 5.0f;
    //faster in x-4
    if(kAppDelegate.subLevel == 4)
        showLavaDuration *= 0.9f; //3
    //move
    CGFloat move = 300.0f;

    self.hurtLavaVisible = NO;

    if(hurt)
    {
        self.hurtLavaVisible = YES;
        move = (self.lava.size.height) - ([kHelpers isIphone4Size] ? (568 - 480) : 0); //fill almost full screen
    }

    [self.lava runAction:[SKAction moveByX:0 y:move duration:showLavaDuration] completion:^{
        //[self hideLava:YES];
    }];

	//hide after delayed
    SKAction *actionHide = [SKAction runBlock:^{

        //Log(@"***** actionHide");

        if(hurt && self.hurtLavaVisible)
        {
            //Log(@"***** actionHide hurt");

            //force
            self.lastClickDate = [NSDate date];

            //hide hand
            [self hideArrowBlock:YES];

            //ouch
            [self touchedFireball:-1 node:self.clock];

            //reset time
            [self resetTime];
        }

        [self hideLava:YES];

    }];

	CGFloat lavaHideDelay = showLavaDuration;
	/*if(kAppDelegate.level <= 2)
	{
		//sooner
		lavaHideDelay = 3.0f;
	}
	else if(kAppDelegate.level <= 5)
	{
		//sooner
		lavaHideDelay = 5.0f;
	}
	else*/
	{
		lavaHideDelay = 10.0f;
	}

    //hurt full
    if(hurt)
    {
        lavaHideDelay = showLavaDuration;
    }

    //[self runAction:actionHide afterDelay:lavaHideDelay];
    SKAction *wait = [SKAction waitForDuration:lavaHideDelay];
    SKAction *sequenceHide = [SKAction sequence:@[wait,actionHide]];
    [self runAction:sequenceHide withKey:@"actionHideLava"];


    //alpha
//    CGFloat fadeDuration = 0.6f;
//    SKAction *fadeOut = [SKAction fadeAlphaTo:0.85f duration:fadeDuration];
//    SKAction *fadeIn = [SKAction fadeAlphaTo:0.9f duration:fadeDuration];
//    SKAction* sequence = [SKAction sequence:@[fadeOut, fadeIn]];
//    [self.lava runAction:[SKAction repeatActionForever:sequence]];

    SKAction *fadeIn = [SKAction fadeAlphaTo:0.9f duration:0.0f];
    [self.lava runAction:fadeIn];

#if 0
    //emitters
    NSString *emitterName =  @"smoke_4_ignore";
    [self.lava removeChildrenNamed:emitterName];

    int num = 3;
    for(int i=0;i<num;i++)
    {
        //emiter
        SKEmitterNode *myParticle = [SKEmitterNode emitterWithResourceNamed:@"smoke2"];
        assert(myParticle);
        myParticle.zPosition = -1;

        myParticle.name = emitterName;

        //disable touch
        myParticle.targetNode = self.scene;

        myParticle.position = CGPointMake(i*(self.frame.size.width/num) + 50 - self.frame.size.width/2,( self.lava.size.height/2)-50);

        if(kEnableEmiters)
            [self.lava addChild:myParticle];
    }
#endif
}

-(void)hideLava:(BOOL)animated {

    //Log(@"***** hideLava");

    self.hurtLavaVisible = NO;

    if(self.lava.hidden)
        return;

    //remove hide anim
    [self.lava removeActionForKey:@"actionHideLava"];
    [self removeActionForKey:@"actionHideLava"];

    if(animated) {

        //arrow
        [self hideArrowBlock:YES];

        self.hidingLava = YES;

        //remove before
        //[self.lava removeChildrenNamed:@"smoke_4_ignore"];

        //stop emiting
        for (SKEmitterNode* child in self.lava.children){
            if([child isKindOfClass:[SKEmitterNode class]]) {
                child.particleBirthRate = 0;
            }
        }

        CGFloat showLavaDuration = 5.0f; //duration based on distance left?
        //faster in x-4
        if(kAppDelegate.subLevel == 4)
           showLavaDuration *= 0.9f; //3

        //based on distance
        CGFloat factor = -((self.lava.position.y + self.lava.size.height/2) / (self.lava.size.height) );
        factor = ABS(factor);
        showLavaDuration *= factor;

        //move
        [self.lava runAction:[SKAction moveToY:-((self.lava.size.height/2.0f)+0) duration:showLavaDuration]
         completion:^{
            self.hidingLava = NO;

            self.lava.alpha = 0.0f;
            self.lava.hidden = YES;

            [self.soundLava stop];

            [self.lava removeChildrenNamed:@"smoke_4_ignore"];

            [self.lava removeAllActions];
        }];

        //stop sound sooner
        /*SKAction *actionBlockHide = [SKAction runBlock:^{
            [self.soundLava stop];
        }];
        [self runAction:actionBlockHide afterDelay:(duration - 2.0f)];
        */
    }
    else {

        [self.soundLava stop];

        self.lava.alpha = 0.0f;
        self.lava.hidden = YES;
        [self.soundLava stop];
        [self.lava removeChildrenNamed:@"smoke_4_ignore"];
    }

}

-(void)showCloud {

    //disabled
    return;

    if(self.winning || self.dying)
        return;

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return;
    if(self.paused)
        return;


    //Log(@"showCloud **************************");


    SKSpriteNode *cloud = [self createCloud];

    //if(!self.cloud1.hidden)
    //    return;

    CGRect tempRect = cloud.frame;

    //still on screen
    //if(cloud.position.x < self.frame.size.width && cloud.position.x > 0 && cloud.alpha >= 0.01f)
    //    return;


    //if(cloud.position.x < self.frame.size.width)
    //    return;


    [cloud removeAllActions];
    //[cloud removeActionForKey:@"cloud1"];


    BOOL front  = [kHelpers randomBool100: (kAppDelegate.subLevel == 4) ? 80 : 25 ];

    if([cloud.name contains:@"cloud6"] || [cloud.name contains:@"cloud7"])
    {
        //bird or twitter always behind
        front = NO;
    }

    if(front) {
        cloud.alpha = (kAppDelegate.subLevel == 4) ? 0.4f : 0.2f;
        cloud.zPosition = self.scanline.zPosition-3;
        cloud.xScale = 1.4f;
        cloud.yScale = cloud.xScale;
    }
    else {
        //back, normal
        cloud.alpha = (kAppDelegate.subLevel == 4) ? 0.8f : 0.4f;
        cloud.zPosition = self.bgOverlay.zPosition + 1;
        cloud.xScale = 1.0f;
        cloud.yScale = cloud.xScale;
    }

    float cloudWidth = cloud.size.width;

    //cloud.position= CGPointMake(offset + arc4random_uniform(self.frame.size.width-offset*2),
    //                                  offset + arc4random_uniform(self.frame.size.height-offset*2));

    /*cloud.position= CGPointMake(-kCloudWidth,
                                      self.frame.size.height-kCloudY*2 +
                                      arc4random_uniform(kCloudY*2));*/

    //cloud.alpha  = 0.8f;
    cloud.hidden = NO;

    float cloudX = -cloudWidth;

    //random x
    cloudX = -cloudWidth + arc4random_uniform(self.frame.size.width);


    float yOffset = 100;

    //higer for birds or twitter
    if([cloud.name contains:@"cloud6"] || [cloud.name contains:@"cloud7"])
    {
        yOffset = self.frame.size.height/2;
    }

    float cloudY = yOffset + arc4random_uniform(self.frame.size.height - yOffset*2);
    //cloudY = 400;
    cloud.position = CGPointMake(cloudX, cloudY);

    //Log(@"showCloud: position: %d, %d", (int)cloudX, (int)cloudY);

    tempRect = cloud.frame;


    SKAction *hideAction = [SKAction runBlock:^{
        cloud.hidden = YES;
        [cloud removeFromParent];
    }];

    //random duration
    float durationOffset = 5;
    //float duration = durationOffset + arc4random_uniform(kCloudDuration - durationOffset*2);
    float duration = kCloudDuration - durationOffset + arc4random_uniform(durationOffset*2);
    duration -= (front?2:0); //faster in front

    //Log(@"showCloud: duration: %d", (int)duration);

    SKAction *cloudMoveAction = [SKAction moveByX:self.frame.size.width + cloudWidth*2 y:0 duration:duration];

    if([cloud.name contains:@"cloud7"])
    {
        //also y for birds
        SKAction *cloudMoveY = [SKAction moveByX:0 y:100 duration:duration];
        [cloud runAction:cloudMoveY];
    }

    if([cloud.name contains:@"cloud6"])
    {
        //twitter go up and down
        CGFloat moveY = 8;
        CGFloat duration = 0.3f;
        SKAction *cloudMoveY1 = [SKAction moveByX:0 y:moveY duration:duration];
        SKAction *cloudMoveY2 = [SKAction moveByX:0 y:-moveY duration:duration];
        SKAction *sequence = [SKAction sequence:@[cloudMoveY1,cloudMoveY2]];
        [cloud runAction:[SKAction repeatActionForever:sequence]];
    }


    SKAction *sequence = [SKAction sequence:@[cloudMoveAction,hideAction]];
    [cloud runAction:sequence withKey:@"cloud1"];

    //fade in
    float alphaBefore = cloud.alpha;
    cloud.alpha = 0.0f;
    [cloud runAction: [SKAction fadeAlphaTo:alphaBefore duration:2.0f]];
}

-(void)hideClouds
{
    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.3f];

    for(SKNode *node in self.cloudArray)
    {
        [node removeAllActions];

        [node runAction:fadeOut completion:^{

        }];
    }
}

//touchedImageSquare
-(void) touchedNavSquare
{
    if(self.winning || self.dying)
        return;

    if(kAppDelegate.numHearts <= 0) {
        [self refillHeartAlert:YES];
        return;
    }

    //fail combo
    [self actionTimerCombo];

	//if(kAppDelegate.level == 1)
	if(NO)
    {
        //just return;
//        [self playSound:self.soundBump];
//        return;
#if 1
		//disabled for 1st level
        [self playSound:self.soundBump];

		 //alert
        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            [kAppDelegate.alertView dismissAnimated:NO];

        kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Locked" andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringFeatureLocked")]];

        [kAppDelegate.alertView addButtonWithTitle:@"OK"
                                 type:kAlertButtonGreen
                              handler:^(SIAlertView *alert) {
                                  [kAppDelegate playSound:kClickSound];
                              }];

        kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
        kAppDelegate.alertView.transitionStyle = kAlertStyle;

        //pause
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
            //nothing
        }];

        //close, unpause
        [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
            [self enablePause:NO];
            [kAppDelegate.gameController blurScene:NO];

            [kAppDelegate.gameController showVCR:NO animated:YES];

        }];

        [kAppDelegate.alertView show:YES];
        [kAppDelegate.gameController showVCR:YES animated:YES];

		return;
#endif
	}

    __weak typeof(self) weakSelf = self;

    //random position
    //int random = arc4random_uniform(2);

    //arrow
    kAppDelegate.tutoArrowClickedStar = YES;
    kAppDelegate.tutoArrowClickedSquare = YES;

    [self hideArrowSquare:NO];

    if(!self.squareImageReady)
    {

        //not offline
        if(![kHelpers checkOnline]) {
            [kHelpers showErrorHud:LOCALIZED(@"kStringOffline")];
            return;
        }

        //fail combo
        [self actionTimerCombo];

        [self playSound:self.soundBump];


#if 1
        //alert
        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            [kAppDelegate.alertView dismissAnimated:NO];

        kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Power-up"
                                  //andMessage:[NSString stringWithFormat:@"There are no Powerups\navailable yet."]];
            andMessage:[NSString stringWithFormat:@"Unlock a Power-up <color1>now</color1> by watching a short video?"]];


        [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringWatchAd")
                                              type:kAlertButtonGreen
                                           handler:^(SIAlertView *alert) {

                                               [kAppDelegate playSound:kClickSound];

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

                                               [weakSelf hideImageSquare];

                                               //date
                                               kAppDelegate.lastRewardDate = [NSDate date];

                                               float secs = 1.0f;
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                                   //video
                                                   if([kAppDelegate hasRewardedVideo:kRewardUnlockPowerUp]) {

                                                       //hud
                                                       [kHelpers showMessageHud:@"Connecting..."];

                                                       //force ad back
                                                       //kAppDelegate.gameController.darkAdImage.hidden = NO;

                                                       //delayed
                                                       //pause
                                                       /*CGFloat alertDelay = 1.0f; //0.5f;
                                                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, alertDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                           [self enablePause:YES];
                                                           [kAppDelegate.gameController blurScene:YES];
                                                           [kAppDelegate.gameController showVCR:YES animated:YES];
                                                       });*/

                                                       [kAppDelegate showRewardedVideo:kRewardUnlockPowerUp];
                                                   }
                                                   else {
                                                       [kHelpers dismissHud];

                                                       [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorNoVideo")];

                                                       //un-pause
                                                       [self enablePause:NO];
                                                       [kAppDelegate.gameController blurScene:NO];
                                                       [kAppDelegate.gameController showVCR:NO animated:YES];
                                                   }
                                               });

                                               //after delay, in case
                                               secs = 5.0f;
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [kHelpers dismissHud];
                                               });

                                           }];


        kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
        kAppDelegate.alertView.transitionStyle = kAlertStyle;


        [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
            //kAppDelegate.gameController.paused = NO;
            //self.paused = NO;
            [self enablePause:NO];
            [kAppDelegate.gameController blurScene:NO];

            [kAppDelegate.gameController showVCR:NO animated:YES];
        }];

        //close, unpause
        [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
            //also hide
            [self hideImageSquare];
        }];

        if(!self.navPlus.hidden)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                //pause
                [self enablePause:YES];
                [kAppDelegate.gameController blurScene:YES];

                [kAppDelegate.alertView show:YES];
                [kAppDelegate.gameController showVCR:YES animated:YES];
            });
        }


        return;
#endif
    }

    //reset time
    [self resetTime];

    [kAppDelegate playSound:kClickSound];


    //combo
    [self updateComboLabel];

    //just show
    [self touchedNavSquare2];

    //hide lava
    [self hideLava:YES];

    return;

#if 0
    /*if(![kAppDelegate isPremium]) {

        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            [kAppDelegate.alertView dismissAnimated:NO];

        NSString *message = nil;

        if(premium)
            message = [NSString stringWithFormat:@"Unlock a <color1>Powerup</color1> instantly?\n(<color1>Thanks VIP!</color1>)\n"];
        else
            message = [NSString stringWithFormat:@"Unlock a <color1>Powerup</color1> by watching a short video?"];

        kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Power-up"
                                                         andMessage:message];*/

        /*
        [kAppDelegate.alertView addButtonWithTitle:@"No Thanks"

                                 type:kAlertButtonOrange
                              handler:^(SIAlertView *alert) {

                                  [kAppDelegate playSound:kClickSound];

                              }];

        */

        //always reward ad

        /*if(premium)
            [kAppDelegate.alertView addButtonWithTitle:@"Unlock!"
                                      type:kAlertButtonGreen
                                   handler:^(SIAlertView *alert) {

                                       [kAppDelegate playSound:kClickSound];

                                       [weakSelf hideImageSquare];

                                       [weakSelf touchedNavSquare2];

                                   }];

        if(!premium)*/
            [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringWatchAd")
                                                  type:kAlertButtonGreen
                                               handler:^(SIAlertView *alert) {

                                                   [kAppDelegate playSound:kClickSound];

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

                                                   [weakSelf hideImageSquare];

                                                   //date
                                                   kAppDelegate.lastRewardDate = [NSDate date];
                                                   //[kAppDelegate saveState];

                                                   //sharing
//                                                   kAppDelegate.gameController.sharing = YES;
//                                                   self.sharing = YES;

                                                   //[kHelpers showMessageHud:@""];

                                                   float secs = 1.0f;
                                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                                       //video
                                                       if([kAppDelegate hasRewardedVideo:kRewardUnlockPowerUp]) {

                                                           //force ad back
                                                           //kAppDelegate.gameController.darkAdImage.hidden = NO;

                                                           [kAppDelegate showRewardedVideo:kRewardUnlockPowerUp];
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




        kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
        kAppDelegate.alertView.transitionStyle = kAlertStyle;

        //pause
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        //close x
        [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {

        }];

        //close, unpause
        [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
            //kAppDelegate.gameController.paused = NO;
            //self.paused = NO;
            [self enablePause:NO];
            [kAppDelegate.gameController blurScene:NO];

            [kAppDelegate.gameController showVCR:NO animated:YES];

        }];


        [kAppDelegate.alertView show:YES];

        [kAppDelegate.gameController showVCR:YES animated:YES];

    }
    else
    {
        //just show
        [self touchedNavSquare2];
    }

#endif

}


-(void) touchedNavSquare2
{
    Log(@"touchedNavSquare2");

    //arrow
    kAppDelegate.tutoArrowClickedStar = YES;

    NSMutableArray *array = [NSMutableArray array];
    NSArray *availablePowerupsArray = [CBSkinManager getAvailablePowerups];

    //for(int i=0;i<kPowerUpTypeCount;i++)
	for(NSNumber *num in availablePowerupsArray)
    {
		int odds = 0;
		switch([num intValue])
		{
			case kPowerUpTypeHeart:
				if(kAppDelegate.numHearts >= kHeartFull)
					odds =  0;
				else if(kAppDelegate.numHearts <= 2) //1 heart left
					odds =  5;
				else
					odds = 3;

			break;

			case kPowerUpTypeStar:
                odds = 2;
			break;

			case kPowerUpTypeBomb:
                odds = 4; //1;
			break;

            case kPowerUpTypePotion:
                if(kAppDelegate.numPotions <= 1)
					odds =  5;
				else
					odds = 1;

                break;

            case kPowerUpTypeDoubler:
                odds = 1;
                break;

            case kPowerUpTypeAuto:
                odds = 1;
                break;

            case kPowerUpTypeWeak:
                odds = 1;
                break;

            case kPowerUpTypeShield:
                odds = 2;
                break;

            case kPowerUpTypeGrow:
                odds = 1;
                break;

            case kPowerUpTypeShrink:
				//don't show negative if low health
				if(kAppDelegate.numHearts <= 2 && kAppDelegate.level >= 2) //1 heart left
					odds =  0;
				else
	                odds = 1;
                break;

            case kPowerUpTypeInk:
				//don't show negative if low health
				if(kAppDelegate.numHearts <= 2 && kAppDelegate.level >= 2) //1 heart left
					odds =  0;
				else
	                odds = 1;
                break;

			default:
			assert(0);
			break;
		}

		for(int j = 0; j<odds; j++)
       	 [array addObject:num];
    }

    //remove bads
    if(kAppDelegate.lastPowerup == kPowerUpTypeInk ||
       kAppDelegate.lastPowerup == kPowerUpTypeShrink)
    {
        [array removeObject:@(kPowerUpTypeInk)];
        [array removeObject:@(kPowerUpTypeShrink)];
    }

    //remove last
    if(kAppDelegate.lastPowerup != kPowerUpTypeNone)
        [array removeObject:@(kAppDelegate.lastPowerup)];



    PowerupType which = kPowerUpTypeNone;
    which = [[array randomObject] intValue];

    /*
	//not the same as old
    int max = 0;
    do
    {
      which = [[array randomObject] intValue];
    } while(which == kAppDelegate.lastPowerup && (max++ < 10));*/

    //force for 1st time, star/heart?
    if(kAppDelegate.powerupCountLocal == 0)
    {
        //which = kPowerUpTypeStar;
        which = kPowerUpTypeHeart;
    }

    assert(which != kPowerUpTypeNone);

    BOOL negative = [self isPowerUpNegative:which];

    SKAction *powerupAction = [SKAction runBlock:^{
        [self.soundSpin stop];

        SKAction *actionSoundBell = [SKAction runBlock:^{
            if(!negative)
                [self playSound:self.soundBell];
            else
                [self playSound:self.soundWrong];

        }];

        if(!negative)
        {
            CGFloat soundDelay = 0.0f;
            [self runAction:actionSoundBell afterDelay:soundDelay];
            soundDelay += 0.3f;
            [self runAction:actionSoundBell afterDelay:soundDelay];
            soundDelay += 0.3f;
            [self runAction:actionSoundBell afterDelay:soundDelay];
        }
        else
        {
            //wrong, play once
            CGFloat soundDelay = 0.0f;
            [self runAction:actionSoundBell afterDelay:soundDelay];
//            soundDelay += 0.3f;
//            [self runAction:actionSoundBell afterDelay:soundDelay];
//            soundDelay += 0.3f;
//            [self runAction:actionSoundBell afterDelay:soundDelay];
        }


		[self.imageSquare removeAllActions];

		//new image
		SKTexture *texture = [CBSkinManager getPowerupSquareImageTexture:which];
        [self.imageSquare runAction:[SKAction setTexture:texture]];

		//also flash
		CGFloat fadeDuration = 0.1f;
		SKAction *fadeOut = [SKAction fadeOutWithDuration:fadeDuration];
		SKAction *fadeIn = [SKAction fadeInWithDuration:fadeDuration];
   	 	SKAction* sequence = [SKAction sequence:@[fadeOut, fadeIn]];
    	[self.imageSquare runAction:[SKAction repeatActionForever:sequence]];

		//stop scaling square too, reset alpha/scale
		[self.navSquare removeAllActions];
		float oldScale = 1.6f;
		[self.navSquare runAction:[SKAction scaleTo:oldScale duration:0.1f]];
    	[self.navSquare runAction:[SKAction fadeAlphaTo:0.8 duration:0.1f]];
    }];

    SKAction *powerupAction2 = [SKAction runBlock:^{

		[self.navSquare removeAllActions];

        [self hideImageSquare];

        [self showPowerup:YES which:which];
    }];

    SKAction *powerupAction3 = [SKAction runBlock:^{
		//enable square, after delay
        [self.navSquare enable:YES];
        [self.imageSquare enable:YES];
    }];

    //disable
    [self.navSquare enable:NO];
    [self.imageSquare enable:NO];

    CGFloat delay1 = 0.3f;
    CGFloat delay2 = delay1 + 0.8f; //flash longer
    CGFloat delay3 = delay2 + 1.0f; //wait before re-enable

    [self runAction:powerupAction afterDelay:delay1];
    [self runAction:powerupAction2 afterDelay:delay2];
    [self runAction:powerupAction3 afterDelay:delay3];
}


-(void) touchedBackground
{
    //[self playSound:self.soundBump];

    //fail combo
    [self actionTimerCombo];
}

-(CGFloat)getBuffDuration:(BuffType)buffType {
    CGFloat duration = 0;
    CGFloat mult = [kAppDelegate isPremium] ? 2.0f : 1.0f; //longer

    switch(buffType)
    {
        case kBuffTypeShield:
        {
            duration = 30  * mult;
        }
            break;

        case kBuffTypeGrow:
        {
            duration = 30 * mult;
        }
            break;

        case kBuffTypeShrink:
        {
            //bad
            duration = 30 / mult;
        }
            break;

        case kBuffTypeInk:
        {
            //bad
            duration = 10 / mult;
        }
            break;

        case kBuffTypeDoubler:
        {
            duration = 10 * mult;
        }
            break;
        case kBuffTypeAuto:
        {
            duration = 15 * mult;
        }
            break;

        case kBuffTypeWeak:
        {
            duration = 10 * mult;
        }
            break;

        case kBuffTypeStar:
        {
            duration = 10 * mult;
        }
            break;

        default:
            if([kHelpers isDebug])
                assert(0);
            break;
    }

    //force
    //duration = 10;

    return duration;
}

-(BOOL)isPowerUpNegative:(PowerupType)type
{
    BOOL negative = (type == kPowerUpTypeInk || type == kPowerUpTypeShrink);
    return negative;
}
-(BOOL)isBuffNegative:(BuffType)type
{
    BOOL negative = (type == kBuffTypeInk || type == kBuffTypeShrink);
    return negative;
}

-(void)showBuff:(BuffType)buffType
{
    [self showBuff:buffType resetTime:YES];
}

-(void)showBuff:(BuffType)buffType resetTime:(BOOL)resetTime
{
    NSString *buffName = nil;
    PowerupType powerUpType = kPowerUpTypeNone;

    if(buffType == kBuffTypeNone)
    {
        if([kHelpers isDebug])
            assert(0);
    }

    //hide banner
    [self hideBanner];

    BOOL negative = [self isBuffNegative:buffType];
    if(!negative)
       [self showMiniShines];

    kAppDelegate.currentBuff = buffType;

    //reset show powerup date
    //self.lastSquareDate = [NSDate date];

    CGFloat buffDuration = [self getBuffDuration:buffType];

	switch(buffType)
	{
        case kBuffTypeShield:
        {
            //alert
            [self showShieldAlert];

            buffName = @"shield";
            powerUpType = kPowerUpTypeShield;
        }
        break;

        case kBuffTypeGrow:
        {
            //alert
            [self showGrowAlert];

            buffName = @"grow";
            powerUpType = kPowerUpTypeGrow;

            //grow
            self.blockScale = [kHelpers isIphone4Size] ? 1.3f : 1.4f;

            //self.block.scale = self.blockScale;
            [self.block runAction:[SKAction scaleTo:self.blockScale duration:kBlockGrowDuration]];

        }
            break;

        case kBuffTypeShrink:
        {
            //alert
            [self showShrinkAlert];

            buffName = @"shrink";
            powerUpType = kPowerUpTypeShrink;

            //grow
            self.blockScale = [kHelpers isIphone4Size] ? 0.4f : 0.5f;

            //self.block.scale = self.blockScale;
            [self.block runAction:[SKAction scaleTo:self.blockScale duration:kBlockGrowDuration]];

        }
            break;

        case kBuffTypeInk:
        {
            //alert
            [self showInkAlert];

            buffName = @"ink";
            powerUpType = kPowerUpTypeInk;

            [self showInk];

        }
            break;

        case kBuffTypeDoubler:
        {

            //alert
            [self showDoublerAlert];

            buffName = @"doubler";
            powerUpType = kPowerUpTypeDoubler;
        }
            break;

        case kBuffTypeAuto:
        {

            //alert
            [self showAutoAlert];

            buffName = @"auto";
            powerUpType = kPowerUpTypeAuto;
        }
            break;

        case kBuffTypeWeak:
        {
            //alert
            [self showWeakAlert];

            buffName = @"weak";
            powerUpType = kPowerUpTypeWeak;
        }
            break;

		case kBuffTypeStar:
		{
            //alert
            [self showStarAlert];

			buffName = @"star";
            powerUpType = kPowerUpTypeStar;

			//flash fireballs
   			[self flashFireballs];
		}
		break;

		default:
		assert(0);
		break;
	}


    //border
    [self.buffBorder removeAllActions];
    self.buffBorder.alpha = 0;
    self.buffBorder.hidden = NO;
    //fade in/out
    SKAction *borderFadeIn = [SKAction fadeAlphaTo:0.6f duration:0.5f];
    SKAction *borderFadeOut = [SKAction fadeAlphaTo:0.1f duration:0.5f];
    SKAction *borderSequence = [SKAction sequence:@[borderFadeIn,borderFadeOut]];
    [self.buffBorder runAction:[SKAction repeatActionForever:borderSequence]];

    //color
    if(negative)
    {
        //green, bad
        self.buffBorder.texture = [SKTexture textureWithImageNamed:@"flashBorder2"];

    }
    else
    {
        //yellow, good
        self.buffBorder.texture = [SKTexture textureWithImageNamed:@"flashBorder"];

        //good also hide lava
        [self hideLava:YES];
    }

    //bg
    [self.buffBg removeAllActions];
    self.buffBg.alpha = 0;
    self.buffBg.hidden = NO;

    //fade in/out
    SKAction *bgFadeIn = [SKAction fadeAlphaTo:0.3f duration:0.3f];
    [self.buffBg runAction:bgFadeIn];

    //color
    //SKAction *colorize1 = [SKAction colorizeWithColor:[UIColor greenColor] colorBlendFactor:1.0f duration:0.0f];
    //[self.buffBg runAction:colorize1];

    //https://www.youtube.com/watch?v=lsrQYVanGO0
    NSArray *colorArray = nil;

    if(!negative)
    {
      colorArray = @[ [UIColor colorWithHex:0xFFFFFF], //white
                            [UIColor colorWithHex:0xb8e5f5], //blue white
                            [UIColor colorWithHex:0x6dc0f8], //blue
                            [UIColor colorWithHex:0xe9826f], //pink
                            [UIColor colorWithHex:0x6ae34a], //green
                            ];
    }
    else
    {
      //negative
      /*colorArray = @[ [UIColor colorWithHex:0xFFFFFF], //white
                            [UIColor colorWithHex:0xCCCCCC], //light grey
                            [UIColor colorWithHex:0xAAAAAA], //grey
                            [UIColor colorWithHex:0x555555], //grey
                            [UIColor colorWithHex:0x111111], //dark grey
                            ];*/

        colorArray = @[
                       //[UIColor blueColor],
                       [UIColor purpleColor],
                        //[UIColor blackColor],
                        [UIColor clearColor],
                        //[UIColor greenColor],
                        ];
    }


    NSMutableArray *colorActionArray = [NSMutableArray array];
    SKAction *colorWaitAction = [SKAction waitForDuration:0.1f];

    for(UIColor *color in colorArray) {
        SKAction *colorize = [SKAction colorizeWithColor:color colorBlendFactor:1.0f duration:0.3f];
        [colorActionArray addObject:colorize];
        [colorActionArray addObject:colorWaitAction];
    }
    SKAction *sequenceColor = [SKAction sequence:colorActionArray];
    [self.buffBg runAction:[SKAction repeatActionForever:sequenceColor]];



	//anim
	[self.buff removeAllActions];
    [self.buffLabelTimer removeAllActions];
    [self.buffLabelName removeAllActions];
	[self.buffSquare removeAllActions];
	[self.buffShine removeAllActions];

    //reset
    self.buff.zRotation = M_PI*0.0f ;

	//texture
	self.buff.texture = [CBSkinManager getPowerupSquareImageTexture:powerUpType];

	self.buff.hidden = NO;
    self.buffLabelTimer.hidden = NO;
    self.buffLabelName.hidden = NO;
	self.buffSquare.hidden = NO;
	self.buffShine.hidden = NO; //NO
    self.buffLabelTimer.alpha = 0.0f;
    self.buffLabelName.alpha = 0.0f;

	CGFloat duration = 0.3f;
	CGFloat alpha = 0.9f;
	[self.buff runAction:[SKAction fadeAlphaTo:alpha duration:0.0f]]; //no fadde
    [self.buffLabelTimer runAction:[SKAction fadeAlphaTo:alpha duration:duration]];
    [self.buffLabelName runAction:[SKAction fadeAlphaTo:0.7f duration:duration]];
	[self.buffSquare runAction:[SKAction fadeAlphaTo:0.0f duration:duration]]; //0.3f //hidden
	[self.buffShine runAction:[SKAction fadeAlphaTo:alpha duration:duration]];

	//rotate shine
    SKAction *oneRevolutionKey = [SKAction rotateByAngle:-M_PI*2 duration: 16];
    SKAction *repeatKey = [SKAction repeatActionForever:oneRevolutionKey];
    [self.buffShine runAction:repeatKey];

    //flash color
    SKAction *color1 = [SKAction runBlock:^{
        self.buffLabelName.fontColor = [UIColor colorWithHex:0xfdfd51]; //yellow
    }];
    SKAction *color2 = [SKAction runBlock:^{
        self.buffLabelName.fontColor = [UIColor colorWithHex:0xff8000]; //orange
    }];

    SKAction *wait = [SKAction waitForDuration:0.1f];
    SKAction *sequence = [SKAction sequence:@[color1,wait, color2, wait]];

    [self.buffLabelName runAction:[SKAction repeatActionForever:sequence]];


    //scale
    if(YES)
    {
        SKAction *actionIn = [SKAction scaleBy:1.2f duration:0.3f];
        SKAction *actionOut = [SKAction scaleTo:1.1f duration:0.3f];
        sequence = [SKAction sequence:@[actionIn, actionOut]];
        [self.buff runAction:[SKAction repeatActionForever:sequence]];
    }
	//also spin
    if(buffType == kBuffTypeAuto)
    {
#if 1
        //rotate
        SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration: 1];
        SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
        [self.buff runAction:repeat];

        //also hide weak spot
        [self hideWeakSpot:NO];
#endif
    }

	//duration
    if(resetTime)
    {
        kAppDelegate.buffSecs = buffDuration;
    }
    else
    {
        //give a few seconds, in case
        kAppDelegate.buffSecs++;
        if(kAppDelegate.buffSecs > kBuffDurationMax)
            kAppDelegate.buffSecs = kBuffDurationMax;

        int min = 2;
        if(kAppDelegate.buffSecs < min)
        {
            kAppDelegate.buffSecs = min;
        }
    }

    [self updateBuffLabel:YES];

    [kAppDelegate saveState];

    //update music fever
    if(kAppDelegate.titleController.menuState == menuStateGame) {
        [kAppDelegate playMusicRandom];
    }

	//show +1
	if(NO)
	{
		//+1
		SKLabelNode *plusLabel = nil;
		plusLabel = [SKLabelNode labelNodeWithFontNamed:kFontNamePlus];
		plusLabel.name = @"buffLabelTimer_ignore";
		plusLabel.fontColor = RGB(255,255,255);
		plusLabel.userInteractionEnabled = NO;

		//add
        [self addChild:plusLabel];

		plusLabel.text = buffName;

		plusLabel.fontSize = 25;

		//anim color
		SKAction *color1 = [SKAction runBlock:^{
			plusLabel.fontColor = [UIColor colorWithHex:0xfdfd51]; //yellow
		}];
		SKAction *color2 = [SKAction runBlock:^{
			plusLabel.fontColor = [UIColor colorWithHex:0xff8000]; //orange
		}];

		SKAction *wait = [SKAction waitForDuration:0.1f];
		SKAction *sequence = [SKAction sequence:@[color1,wait, color2, wait]];

		[plusLabel runAction:[SKAction repeatActionForever:sequence]];

		plusLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
		plusLabel.zPosition = self.toastie.zPosition + 1;
		plusLabel.alpha = 1.0f;


        //offset
        plusLabel.position = CGPointMake(self.buff.position.x-10, self.buff.position.y+35);

		//scale
			if(plusLabel.text.length > 10)
				plusLabel.fontSize = 18;
			else if(plusLabel.text.length > 5)
				plusLabel.fontSize = 20;
			else if(plusLabel.text.length > 2)
				plusLabel.fontSize = 22;

		//anim
		float plusDuration = 2.0f;
		float distance = 50;

		SKAction *actionMovePlus = [SKAction moveBy:CGVectorMake(0,distance) duration:plusDuration];
		[plusLabel runAction:actionMovePlus];
		SKAction *actionFadePlus = [SKAction fadeAlphaTo:0.0f duration:plusDuration];
		[plusLabel runAction:actionFadePlus];
		//delete
		SKAction *deleteAction1Plus = [SKAction waitForDuration:plusDuration];
		SKAction *deleteAction2Plus = [SKAction runBlock:^{
			[plusLabel removeFromParent];
		}];

		SKAction *deleteSequencePlus = [SKAction sequence:@[deleteAction1Plus,deleteAction2Plus]];
		[plusLabel runAction:deleteSequencePlus];
	}
}

-(void)updateBuffLabel:(BOOL)animated
{
//    int minutes = floor(kAppDelegate.buffSecs / 60.0f);
//    int seconds = kAppDelegate.buffSecs % 60;

    //force
    //minutes = 2;
    //seconds = 3;

    //name

    NSString *name = @"";
    switch(kAppDelegate.currentBuff)
    {
        case kBuffTypeShield:
        {
            name = @"Shield";
        }
            break;

        case kBuffTypeStar:
        {
            name = @"Star";
        }
        break;

        case kBuffTypeDoubler:
        {
            name = @"Doubler";
        }
            break;

        case kBuffTypeAuto:
        {
            name = @"Auto";
        }
            break;

        case kBuffTypeWeak:
        {
            name = @"Weak Spot";
            //name = @"Weak";
        }
            break;

        case kBuffTypeGrow:
        {
            //name = @"Grow";
            name = @"Huge";
        }
            break;

        case kBuffTypeShrink:
        {
            //name = @"Shrink";
            name = @"Tiny";
        }
            break;

        case kBuffTypeInk:
        {
            //name = @"Shrink";
            name = @"Ink";
        }
            break;

        default:
            if([kHelpers isDebug])
                assert(0);
            break;
    }

    self.buffLabelName.text = name;

    //timer
    //self.buffLabelTimer.text = [NSString stringWithFormat:@"%d:%02d", minutes, seconds]; //0:10
    self.buffLabelTimer.text = [NSString stringWithFormat:@"%ds", kAppDelegate.buffSecs]; //10s

    CGFloat scaleBig = 0.0f;
    if(kAppDelegate.buffSecs <= 3) {
        //self.buffLabelTimer.fontColor = [UIColor redColor];
        self.buffLabelTimer.fontColor = [UIColor colorWithHex:0xff8000]; //orange
        scaleBig = 1.3f;
    }
    else {
        self.buffLabelTimer.fontColor = [UIColor whiteColor];
        scaleBig = 1.1f;
    }

    if(animated)
    {
        SKAction *actionIn = [SKAction scaleBy:scaleBig duration:0.1f];
        SKAction *actionOut = [SKAction scaleTo:1.0f duration:0.1f];
        SKAction *sequence = [SKAction sequence:@[actionIn, actionOut]];

        [self.buffLabelTimer runAction:sequence];
    }
}

-(void)hideBuff
{
	//if(kAppDelegate.currentBuff == kBuffTypeNone)
	//	return;

    //reset show powerup date
    //self.lastSquareDate = [NSDate date];

    BuffType currentBuff = kAppDelegate.currentBuff;

    [self hideMiniShines];

    [self.buff removeAllActions];

    self.buff.hidden = NO;
    self.buffLabelTimer.hidden = NO;
    self.buffLabelName.hidden = NO;
    self.buffSquare.hidden = NO;
    self.buffShine.hidden = NO;

    CGFloat duration = 0.3f;
    //CGFloat alpha = 0.3f;

    [self.buff runAction:[SKAction fadeAlphaTo:0.0f duration:duration] completion:^{
        self.buff.hidden = YES;
    }];
    [self.buffLabelTimer runAction:[SKAction fadeAlphaTo:0.0f duration:duration] completion:^{
        self.buffLabelTimer.hidden = YES;
    }];
    [self.buffLabelName runAction:[SKAction fadeAlphaTo:0.0f duration:duration] completion:^{
        self.buffLabelName.hidden = YES;
    }];
    [self.buffSquare runAction:[SKAction fadeAlphaTo:0.0f duration:duration] completion:^{
        self.buffSquare.hidden = YES;
    }];
    [self.buffShine runAction:[SKAction fadeAlphaTo:0.0f duration:duration] completion:^{
        self.buffShine.hidden = YES;
    }];

    kAppDelegate.buffSecs = 0;
    kAppDelegate.currentBuff = kBuffTypeNone;

    [kAppDelegate saveState];

    //update music normal
    if(kAppDelegate.titleController.menuState == menuStateGame) {
        [kAppDelegate playMusicRandom];
    }

    //hide border
    [self.buffBorder removeAllActions];
    [self.buffBorder runAction:[SKAction fadeAlphaTo:0.0f duration:0.5f] completion:^{
        self.buffBorder.hidden = YES;
    }];

    //hide bg
    [self.buffBg removeAllActions];
    [self.buffBg runAction:[SKAction fadeAlphaTo:0.0f duration:0.5f] completion:^{
        self.buffBg.hidden = YES;
    }];

    //cleanup?
    switch(currentBuff)
    {
        case kBuffTypeNone:
        {
            //nothing
            //force shrink back
            self.blockScale = [kHelpers isIphone4Size] ? 0.7f : 1.0f;
            [self.block runAction:[SKAction scaleTo:self.blockScale duration:0.0f]];

        }
            break;

        case kBuffTypeShield:
        {
            //nothing
        }
            break;

        case kBuffTypeStar:
        {
            //nothing
        }
            break;

        case kBuffTypeWeak:
        {
            [self hideWeakSpot:NO];
        }
            break;

        case kBuffTypeGrow:
        {
            //sound?
            //            [self playSound:self.soundBuffGrow];
            //            [self playSound:self.soundBuffShrink];

            [self playSound:self.soundRubber];

            //shrink back
            self.blockScale = [kHelpers isIphone4Size] ? 0.7f : 1.0f;
            //self.block.scale = self.blockScale;
            [self.block runAction:[SKAction scaleTo:self.blockScale duration:kBlockGrowDuration]];

        }
            break;

        case kBuffTypeShrink:
        {
            //sound?
            //            [self playSound:self.soundBuffGrow];
            //            [self playSound:self.soundBuffShrink];

            [self playSound:self.soundRubber];

            //shrink back
            self.blockScale = [kHelpers isIphone4Size] ? 0.7f : 1.0f;
            //self.block.scale = self.blockScale;
            [self.block runAction:[SKAction scaleTo:self.blockScale duration:kBlockGrowDuration]];

        }

            break;

        case kBuffTypeInk:
        {
            [self hideInk];
        }
            break;

        case kBuffTypeDoubler:
        {
            //force update mult
            [self updateMult:YES];
        }
            break;

        case kBuffTypeAuto:
        {
        }
        break;


        default:
            if([kHelpers isDebug])
                assert(0);
            break;
    }

}

-(void)showWeakSpot
{
    BOOL premium = [kAppDelegate isPremium];

    //crosshairs
    //bull's eye

    if(kAppDelegate.level <= 2 && !premium)
        return;

	if(!self.weakSpot.hidden)
		return;

    if(self.winning || self.dying)
        return;

    //not during shrink or auto
    //if(kAppDelegate.currentBuff == kBuffTypeShrink || kAppDelegate.currentBuff == kBuffTypeAuto)
    if(kAppDelegate.currentBuff == kBuffTypeShrink)
        return;

	//show alert
    [self showWeakSpotAlert];

    //enable
    [self.weakSpot enable:YES];

    //show
    self.weakSpot.zPosition = self.block.zPosition + 1;

    CGFloat offset = [CBSkinManager getSkinWeakspotOffset:(int)[kAppDelegate getSkin]];
    CGFloat offsetX = -offset + arc4random_uniform(offset);
    CGFloat offsetY = -offset + arc4random_uniform(offset);
    self.weakSpot.position = CGPointMake(self.block.position.x + offsetX, self.block.position.y + offsetY);

	[self.weakSpot removeAllActions];
	self.weakSpot.hidden = NO;
    [self.weakSpot runAction:[SKAction fadeAlphaTo:0.0f duration:0.0f]];

    SKAction* show = [SKAction fadeInWithDuration:0.3f];

    //hide delay
    CGFloat hideDelay = 0.0f;
    if(kAppDelegate.currentBuff == kBuffTypeWeak)
    {
        //powerup
        hideDelay = 2.0f;
    }
    else
    {
        //regular
        hideDelay = 1.5f;
    }

    SKAction* wait = [SKAction waitForDuration:hideDelay];



    SKAction* sequence = [SKAction sequence:@[show, wait]];
     [self.weakSpot runAction:sequence completion:^{
         [self hideWeakSpot:NO];
        //[self playSound:self.soundGasp];
    }];

    [self playSound:self.soundWeakSpot]; //ding

    //animate

    SKAction *tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"weakSpot"],
                                               [SKTexture textureWithImageNamed:@"weakSpot2"]]
                                timePerFrame:0.1f];
    [self.weakSpot runAction:[SKAction repeatActionForever:tempAnim]];


    //scale
    CGFloat scaleDuration = 0.2f;
    SKAction *scaleIn = [SKAction scaleTo:0.8f duration:scaleDuration];
    SKAction *scaleOut = [SKAction scaleTo:1.0f duration:scaleDuration];
    //SKAction * sequenceFade = [SKAction sequence:@[wait, fadeIn, fadeOut]];
    SKAction * sequenceScale = [SKAction sequence:@[scaleIn, scaleOut]];
    [self.weakSpot runAction:[SKAction repeatActionForever:sequenceScale]];

    //rotate
    [self.weakSpot runAction:[SKAction rotateByAngle:RADIANS(-360) duration:5.0f]];
}


-(void)hideWeakSpot:(BOOL)scale
{
    if(kAppDelegate.level <= 2)
        return;

    //disable
    [self.weakSpot enable:NO];

	//reset
	self.weakSpotMult = 1.0f;

	if(self.weakSpot.hidden)
		return;

	//[self.weakSpot removeAllActions];

    CGFloat duration = 0.3f;
    if(scale)
    {
        duration = 0.5f; //longer
        SKAction *scaleOut = [SKAction scaleTo:3.0f duration:duration];
        [self.weakSpot runAction:scaleOut];

    }

	[self.weakSpot runAction:[SKAction fadeOutWithDuration:duration] completion:^{

                [self.weakSpot removeAllActions];
                self.weakSpot.alpha = 0.0f;
				self.weakSpot.hidden = YES;
			}];
}

-(void)showWeakSpotAlert {
    //normal
    if(kAppDelegate.playedWeakSpotAlert)
       return;

    kAppDelegate.playedWeakSpotAlert = YES;
    //[kAppDelegate saveState];

    //NSString *message = @"Attack its <color1>Weak Point</color1> for massive damage! 👊 🦀";
    NSString *message = @"Attack its <color1>Weak Point</color1> for massive damage! 🤜💥";


    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                             type:kAlertButtonGreen
                          handler:^(SIAlertView *alert) {
                              //
                              [kAppDelegate playSound:kClickSound];
                              //nothing
                          }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    //pause
    [self enablePause:YES];
    [kAppDelegate.gameController blurScene:YES];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];

    }];

    [kAppDelegate.alertView show:YES];
    [kAppDelegate.gameController showVCR:YES animated:YES];
}

-(void)touchedWeakSpot
{
    //disable
    [self.weakSpot enable:NO];

	//sound
    //[self playSound:self.soundWeakSpot2]; //instead play in touchedBlock

	//mult, next hit
	self.weakSpotMult = 10.0f;

	//also touch block
    [self touchedBlock:nil];

	//result mult
	self.weakSpotMult = 1.0f;

	//hide
    [self hideWeakSpot:YES];

	//flash fireballs
	[self flashFireballs];

    //flash
    [kAppDelegate.gameController showFlash:kFlashColorWhite];

	//disable bounce
	[self.weakSpot removeActionForKey:@"animationWobble"];

	//achievement
	[kAppDelegate reportAchievement:kAchievement_weakSpot];

	//explosion weakspot
	if(YES)
	{
		//sound
		//[self playSound:self.soundExplosion1];

		[self.weakSpotExplosion removeAllActions];
        self.weakSpotExplosion.hidden = NO;

        self.weakSpotExplosion.xScale = self.weakSpotExplosion.yScale = 0.9f;

		//texture
        float animRate = 0.07f; //0.1f;
		int fireworksID = 1;
        int numFrames = 10;
        SKAction *explosionAnim = nil;

        //if([kHelpers randomBool])
        if(YES)
             //color
                explosionAnim = [SKAction animateWithTextures:@[
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame1", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame2", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame3", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame4", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame5", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame6", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame7", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame8", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame9", fireworksID]]]
                                      timePerFrame:animRate];
        else
            //gray
            explosionAnim = [SKAction animateWithTextures:@[
                                                      [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame1", fireworksID]]]],
                                                      [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame2", fireworksID]]]],
                                                      [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame3", fireworksID]]]],
                                                      [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame4", fireworksID]]]],
                                                      [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame5", fireworksID]]]],
                                                      [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame6", fireworksID]]]],
                                                      [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame7", fireworksID]]]],
                                                      [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame8", fireworksID]]]],
                                                      [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame9", fireworksID]]]]]
                                       timePerFrame:animRate];


        [self.weakSpotExplosion runAction:explosionAnim];

		//move
		self.weakSpotExplosion.position = self.weakSpot.position;

        //fade in
        [self.weakSpotExplosion runAction:[SKAction fadeAlphaTo:0.5f duration:0.1]];

        CGFloat duration = animRate * numFrames; //0.8f;
        CGFloat delayFade = duration/2;

        //fade out
        [self.weakSpotExplosion runAction:[SKAction fadeOutWithDuration:duration-delayFade] afterDelay:delayFade];

        //move
		[self.weakSpotExplosion runAction:[SKAction moveBy:CGVectorMake(0, 50) duration:duration] completion:^{
			//[self.weakSpotExplosion runAction:[SKAction fadeOutWithDuration:0.1f]];
            //self.weakSpotExplosion.hidden = YES;
		}];
	}

}

-(void)touchedPotion
{
    if(self.winning || self.dying)
        return;

    //fail combo
    [self actionTimerCombo];

    //disable if already showing
    if((kAppDelegate.powerupVisibleType != kPowerUpTypeNone) && (kAppDelegate.numPotions == 0))
        return;

    if(kAppDelegate.numPotions <= 0)
    {
        //fail combo
        [self actionTimerCombo];

        if(kAppDelegate.level == 1)
        {
            //disabled for 1st level
            [self playSound:self.soundBump];

            //alert
            if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
                [kAppDelegate.alertView dismissAnimated:NO];

            kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Locked" andMessage:[NSString stringWithFormat:LOCALIZED(@"kStringFeatureLocked")]];

            [kAppDelegate.alertView addButtonWithTitle:[CBSkinManager getRandomOKButton]
                                                  type:kAlertButtonGreen
                                               handler:^(SIAlertView *alert) {
                                                   [kAppDelegate playSound:kClickSound];
                                               }];

            kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical
            kAppDelegate.alertView.transitionStyle = kAlertStyle;

            //pause
            [self enablePause:YES];
            [kAppDelegate.gameController blurScene:YES];

            [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
                //nothing
            }];

            //close, unpause
            [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
                [self enablePause:NO];
                [kAppDelegate.gameController blurScene:NO];

                [kAppDelegate.gameController showVCR:NO animated:YES];

            }];

            [kAppDelegate.alertView show:YES];
            [kAppDelegate.gameController showVCR:YES animated:YES];

            return;
        }

        //combo
        [self updateComboLabel];

        [self playSound:self.soundBump];
        [self updatePotion:YES];

        //show alert
        [self refillPotionsAlert];

        return;
    }

    if(kAppDelegate.numHearts >= kHeartFull)
    {
        //fail combo
        [self actionTimerCombo];

        [self updatePotion:YES];

        [self playSound:self.soundBump];
        //alert? ad?
        return;
    }

    if(kAppDelegate.numHearts < kHeartFull)
    {
        //hide banner
        [self hideBanner];

        kAppDelegate.numPotions -= 1;
        if(kAppDelegate.numPotions < 0)
            kAppDelegate.numPotions = 0;

        [self updatePotion:YES];

        //sounds, delayed
        [self playSound:self.soundPotion2]; //glass

        [self runAction:[SKAction runBlock:^{
            [self playSound:self.soundPotion]; //gulp
        }] afterDelay:0.3f];


        //inc
        [kAppDelegate dbIncPotion];

        //hide lava
        [self hideLava:YES];

		//flash fireballs
        [self flashFireballs];

        [self hideArrowPotion:YES];

		//move potion
		if(YES)
		{
            [self.potionHeart1 removeAllActions];

            //reset
			self.potionHeart1.position = self.potion.position; //1st potion?
            self.potionHeart1.hidden = NO;
            self.potionHeart1.alpha = 1.0f;
            self.potionHeart1.xScale = self.potionHeart1.yScale = kPotionScale;

			float fallDuration = 1.0f; //0.6f;
			float distance = distanceBetweenPoints(self.potionHeart1.position, self.heart3.position);
			fallDuration *= (distance / self.size.height);

			if(fallDuration < 0.5f)
				fallDuration = 0.5f;

			if(fallDuration > 1.0f)
				fallDuration = 1.0f;

			CGPoint position = self.heart1.position;

			if(kAppDelegate.numHearts == 0 || kAppDelegate.numHearts == 1)
				position = self.heart1.position;
			else if(kAppDelegate.numHearts == 2 || kAppDelegate.numHearts == 3)
				position = self.heart2.position;
			else if(kAppDelegate.numHearts == 4 || kAppDelegate.numHearts == 5)
				position = self.heart3.position;
			else if(kAppDelegate.numHearts == 6 || kAppDelegate.numHearts == 7 || kAppDelegate.numHearts == 8)
			{
				if([kAppDelegate isPremium])
                    position = self.heart4.position;
				else
					position = self.heart3.position;
			}

			self.potionHeart1.zPosition = self.heart1.zPosition-1;


			SKAction *move = [SKAction moveTo:position duration:fallDuration];
			move.timingMode = SKActionTimingEaseIn;

			[self.potionHeart1 runAction:move completion:^{
				//stop
				[self.potionHeart1.physicsBody setVelocity:CGVectorMake(0,0)];

				//hide
                [self.potionHeart1 runAction:[SKAction fadeOutWithDuration:0.3f] completion:^{
						self.potionHeart1.hidden = YES;

                        [self playSound:self.soundRefill]; //refill
					}];


				kAppDelegate.numHearts = kHeartFull;
				[self setNumHearts:(int)kAppDelegate.numHearts];

				[self checkHeartTimer];

			}];

			//scale
			[self.potionHeart1 runAction:[SKAction scaleTo:(kPotionScale * 0.5f) duration:fallDuration] ];
		}

    }

    //add ignore
    self.potion.name = [NSString stringWithFormat:@"%@_ignore", self.potion.name];
    SKAction* reEnable = [SKAction runBlock:^{
        //remove ignore
        [self.potion enable:YES];

    }];
    [self runAction:reEnable afterDelay:0.5f];

#if 0
	if(NO)
	{
		//fall potion
		self.potionFall.hidden = NO;

		//lower
		self.potionFall.position = CGPointMake(self.potion.position.x, self.potion.position.y - 5);

		self.potionFall.alpha = 0.9f;
		self.potionFall.xScale = kPotionScale;
		self.potionFall.yScale = kPotionScale;

		float fallDuration = 0.5f;

		[self.potionFall removeAllActions];

		SKAction *moveFall = [SKAction moveBy:CGVectorMake(0, -(50)) duration:fallDuration];
		moveFall.timingMode = SKActionTimingEaseIn;

		[self.potionFall runAction:moveFall];
		[self.potionFall runAction:[SKAction fadeAlphaTo:0.0f duration:fallDuration] completion:^{
			self.potionFall.hidden = YES;
		}];
	}
#endif
}

-(void)touchedKey
{
    //nothing
}

-(void)touchedToastie
{
    //disabled
    //return;

    if(self.toastie.hidden)
        return;
    if(self.toastie.alpha < 1.0f)
        return;


    [kAppDelegate dbIncToastie];

    //reset time
    [self resetTime];

    //hide lava
    [self hideLava:YES];

	//sounds
	[kAppDelegate playSound:@"weakSpot2.caf"];
	[kAppDelegate playSound:@"aaaahhh.caf"];

    //fail combo
    [self actionTimerCombo];

    //hide banner
    [self hideBanner];

	[self.toastie enable:NO];

	//achievement
	[kAppDelegate reportAchievement:kAchievement_toastie];

    //powerup, delay
    SKAction *actionPowerup = [SKAction runBlock:^{
        [self showImageSquare:YES];
    }];
    [self runAction:actionPowerup afterDelay:0.6f];

    //also refill, delay
    SKAction *actionRefill = [SKAction runBlock:^{
        [self playSound:self.soundRefill]; //refill
        kAppDelegate.numHearts = kHeartFull;
        [self setNumHearts:(int)kAppDelegate.numHearts];
        [self checkHeartTimer];
    }];
    [self runAction:actionRefill afterDelay:0.3f];


    //mult?
    //kAppDelegate.toastieMult ?

    //random cheat, disabled
    if(NO)
    {
        NSArray *array = @[
                           Obfuscate.question_mark.question_mark.question_mark.question_mark.question_mark.question_mark, //@"??????"
                           ];
        NSString *cheat = [array randomObject];
        //upper
        cheat = [cheat uppercaseString];

        if(![kAppDelegate.viewedCheats containsObject:cheat])
        {
            [kAppDelegate.viewedCheats addObject:cheat];
        }

        //show +1
        if(YES)
        {
            //+1
            SKLabelNode *plusLabel = nil;
            plusLabel = [SKLabelNode labelNodeWithFontNamed:kFontNamePlus];
            plusLabel.name = @"toastieLabel_ignore";
            plusLabel.fontColor = RGB(255,255,255);
            plusLabel.userInteractionEnabled = NO;

            //add
            [self addChild:plusLabel];

            plusLabel.text = cheat;

            plusLabel.fontSize = 25;

            //anim color
            SKAction *color1 = [SKAction runBlock:^{
                plusLabel.fontColor = [UIColor colorWithHex:0xfdfd51]; //yellow
            }];
            SKAction *color2 = [SKAction runBlock:^{
                plusLabel.fontColor = [UIColor colorWithHex:0xff8000]; //orange
            }];

            SKAction *wait = [SKAction waitForDuration:0.1f];
            SKAction *sequence = [SKAction sequence:@[color1,wait, color2, wait]];

            [plusLabel runAction:[SKAction repeatActionForever:sequence]];

            plusLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
            plusLabel.zPosition = self.toastie.zPosition + 1;
            plusLabel.alpha = 1.0f;


            //same position
            //plusLabel.position = self.toastie.position;
            //offset
            plusLabel.position = CGPointMake(self.toastie.position.x, self.toastie.position.y+5);

            //scale
            if(plusLabel.text.length > 10)
                plusLabel.fontSize = 18;
            else if(plusLabel.text.length > 5)
                plusLabel.fontSize = 20;
            else if(plusLabel.text.length > 2)
                plusLabel.fontSize = 22;


            //anim
            float plusDuration = 2.0f;
            float distance = 50;

            SKAction *actionMovePlus = [SKAction moveBy:CGVectorMake(0,distance) duration:plusDuration];
            [plusLabel runAction:actionMovePlus];
            SKAction *actionFadePlus = [SKAction fadeAlphaTo:0.0f duration:plusDuration];
            [plusLabel runAction:actionFadePlus];
            //delete
            SKAction *deleteAction1Plus = [SKAction waitForDuration:plusDuration];
            SKAction *deleteAction2Plus = [SKAction runBlock:^{
                [plusLabel removeFromParent];
            }];

            SKAction *deleteSequencePlus = [SKAction sequence:@[deleteAction1Plus,deleteAction2Plus]];
            [plusLabel runAction:deleteSequencePlus];
        }


    }

    //show alert
#if 0
	if(NO)
	{
        NSString *message = [NSString stringWithFormat:@"It's a <color1>secret</color1> to everybody.\n\n%@", cheat];

		if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
			[kAppDelegate.alertView dismissAnimated:NO];

		kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"Secret!"
														 andMessage:message];

		[kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
								 type:kAlertButtonGreen
							  handler:^(SIAlertView *alert) {
								  //
								  [kAppDelegate playSound:kClickSound];
								  //nothing
							  }];

		kAppDelegate.alertView.transitionStyle = kAlertStyle;


		[kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
			//nothing
		}];

		//close, unpause
		[kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
			[kAppDelegate saveState];

			//kAppDelegate.gameController.paused = NO;
			//self.paused = NO;
			[self enablePause:NO];
			[kAppDelegate.gameController blurScene:NO];

			[kAppDelegate.gameController showVCR:NO animated:YES];


		}];


        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

            //pause
            [self enablePause:YES];
            [kAppDelegate.gameController blurScene:YES];

            //[kAppDelegate playSound:@"secret.caf"]; //self.soundSecret
            [kAppDelegate.alertView show:YES];
            [kAppDelegate.gameController showVCR:YES animated:YES];
        });


	}
#endif

    [self hideToastie:YES];
}

-(void) touchedHeartTopVIP {

    if(![kAppDelegate isPremium])
    {
        //alert
        //__weak typeof(self) weakSelf = self;

        NSString *message = LOCALIZED(@"kStringPremiumHeartAsk");

        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            [kAppDelegate.alertView dismissAnimated:NO];

        kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:@"VIP"
                                                         andMessage:message];

        [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringPremiumButton")
                                              type:kAlertButtonGreen
                                           handler:^(SIAlertView *alert) {

                                               [kAppDelegate playSound:kClickSound];

                                               float secs = 0.5f;
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{


                                                   [kAppDelegate.gameController adButtonPressed:nil];
                                               });

                                           }];

        [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {

            [kAppDelegate.gameController showVCR:NO animated:YES];

        }];

        [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
            //nothing

            [self enablePause:NO];
            [kAppDelegate.gameController blurScene:NO];

        }];

        //close, unpause
        [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
//            [self enablePause:NO];
//            [kAppDelegate.gameController blurScene:NO];

            [kAppDelegate.gameController showVCR:NO animated:YES];

        }];

        kAppDelegate.alertView.transitionStyle = kAlertStyle;


        //delayed
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self enablePause:YES];
            [kAppDelegate.gameController blurScene:YES];

            [kAppDelegate.alertView show:YES];
            [kAppDelegate.gameController showVCR:YES animated:YES];
        });

    }
}


-(void) touchedInk {
    //[self playSound:self.soundBuffInk];
}

-(void) touchedHeartTop {

    //disabled
    return;

    //test
    //[self hideAllClouds:YES];
#if 0
    if(self.winning || self.dying)
        return;

    if(kAppDelegate.numHearts <= 0) {
        [self refillHeartAlert:YES];
        return;
    }


    if(kAppDelegate.level >= kHeartLevelLose && kAppDelegate.numHearts < kHeartFull) {

        [kAppDelegate playSound:kClickSound];

        [self refillHeartAlert:NO];

        //[self hideHeart];
    }
    else {
        [kAppDelegate playSound:kClickSound];
        [self playSound:self.soundBump];
    }
#endif
}



-(void) touchedRedCoin:(SKSpriteNode*)node {
}

-(void)flashFireballs {
    //flash fireball

    //if(kAppDelegate.numHearts>0)
    //    [self playSound:self.soundClock];

    self.flashFireballFlag = YES;

    //remove
    [self removeActionForKey:@"flashFireBallsLoop"];
    [self removeActionForKey:@"flashFireBallsDone"];

    float interval = kFireballAlphaTimerInterval;
    SKAction* wait = [SKAction waitForDuration:interval];
    SKAction* run = [SKAction runBlock:^{
        [self actionTimerFireballsAlpha:nil];
    }];

    SKAction* sequence = [SKAction sequence:@[wait, run]];
    SKAction* loop = [SKAction repeatActionForever:sequence];

    //show
    [self runAction:loop withKey:@"flashFireBallsLoop"];

    SKAction *doneFlashAction = [SKAction runBlock:^{
        //remove
        [self removeActionForKey:@"flashFireBallsLoop"];

        self.flashFireballFlag = NO;

        [self.soundClock stop];

        //flash fireballs
        [self setAllFireballsAlpha:1.0f animated:YES];
    }];

    SKAction *waitFlash = nil;
    if(kAppDelegate.currentBuff == kBuffTypeStar)
    {
        CGFloat buffDuration = [self getBuffDuration:kBuffTypeStar];

        waitFlash = [SKAction waitForDuration:buffDuration]; //longer for invincible
    }
    else
        waitFlash = [SKAction waitForDuration:kToucheFireballDelay];

    SKAction *doneSequence = [SKAction sequence:@[waitFlash, doneFlashAction]];
    [self runAction:doneSequence withKey:@"waitFlash"];

	self.lastClickFireballDate = [NSDate date];
}

-(PowerupType)powerupTypeFromName:(NSString*)name
{
    PowerupType which = kPowerUpTypeNone;

    if([name contains:@"heart"])
    {
        which = kPowerUpTypeHeart;
    }
    else if([name contains:@"star"])
    {
        which = kPowerUpTypeStar;
    }
	else if([name contains:@"bomb"])
    {
        which = kPowerUpTypeBomb;
    }
    else if([name contains:@"potion"])
    {
        which = kPowerUpTypePotion;
    }
    else if([name contains:@"doubler"])
    {
        which = kPowerUpTypeDoubler;
    }
    else if([name contains:@"auto"])
    {
        which = kPowerUpTypeAuto;
    }
    else if([name contains:@"weak"])
    {
        which = kPowerUpTypeWeak;
    }
    else if([name contains:@"shield"])
    {
        which = kPowerUpTypeShield;
    }
    else if([name contains:@"grow"])
    {
        which = kPowerUpTypeGrow;
    }
    else if([name contains:@"shrink"])
    {
        which = kPowerUpTypeShrink;
    }
    else if([name contains:@"ink"])
    {
        which = kPowerUpTypeInk;
    }
    else
    {
        if([kHelpers isDebug])
            assert(0);
    }

    return which;

}

-(void)touchedLava
{
    //invincible
    if(kAppDelegate.currentBuff == kBuffTypeStar) {
        [self playSound:self.soundBump];
        return;
    }

    [self touchedOuch:-3];

    [self hideLava:YES];
}

-(void)touchedBuff
{
    //[self.soundGasp play];

    //[self hideBuff];
}

-(void) touchedPowerup:(SKSpriteNode*)node {

    __weak SKSpriteNode *weakNode = node;
    __weak typeof(self) weakSelf = self;

    if(self.winning || self.dying)
        return;

    PowerupType which = [self powerupTypeFromName:node.name];

    if(kAppDelegate.powerupVisibleType != kPowerUpTypeNone)
    {
        //hide banner
        [self hideBanner];

        //fail combo
        [self actionTimerCombo];

        //hide lava
        [self hideLava:YES];

        //reset time
        //[self resetTime];

        //arrow
        //[self hideArrowBlock:YES];

        //kAppDelegate.powerupVisibleType = kPowerUpTypeNone;

        weakSelf.lastPowerupDate = [NSDate date];

        //to delay new fireballs
        weakSelf.lastFireballDate = [NSDate date];

        //to not click fireball right away
        weakSelf.lastClickFireballDate = [NSDate date];

        //pause effect
        [self pauseEffect];

        //confetti
        [kAppDelegate.gameController startConfetti2];
        //confetti stop
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kConfettiShort * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [kAppDelegate.gameController stopConfetti];
        });

        //move rewind
        [weakSelf updateLevelBar:YES];

        //[kAppDelegate saveState];

        [weakNode removeActionForKey:@"powerupAppear1"];
        [weakNode removeActionForKey:@"powerupAppear2"];
        [weakNode removeActionForKey:@"powerupAppear3"];

        //star fireworks
        float fireworksAnimRate = fireWorksSpeed;

        weakSelf.fireworks1.position = node.position;
        weakSelf.fireworks1.zPosition = 1000; //self.barFill.zPosition+1;
        weakSelf.fireworks1.alpha = 1.0f;
        weakSelf.fireworks1.scale = 0.25f;


        int fireworksID = 1 + arc4random_uniform(3);

        weakSelf.fireworks1.zPosition = weakNode.zPosition - 1;

        weakSelf.fireworks1.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame1", fireworksID]];
        SKAction *fireworksAnim = [SKAction animateWithTextures:@[
                                                                  [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame1", fireworksID]],
                                                                  [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame2", fireworksID]],
                                                                  [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame3", fireworksID]],
                                                                  [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame4", fireworksID]]]
                                                   timePerFrame:fireworksAnimRate];


        SKAction *fireworksWait = [SKAction waitForDuration:0.0f];
        SKAction *fireworksFadeOut = [SKAction fadeOutWithDuration:0.3f];
        SKAction *fireworksSequence = [SKAction sequence:@[fireworksWait, fireworksAnim, fireworksFadeOut]];

        [weakSelf.fireworks1 removeActionForKey:@"fireworksFrames"];
        [weakSelf.fireworks1 runAction:fireworksSequence withKey:@"fireworksFrames"];

        //hide shine
        SKNode *powerupShine = [node childNodeWithName:@"powerupShine_ignore"];
        powerupShine.alpha = 0.0f;

        //specific action

        if(kAppDelegate.numHearts <= 0) {
            [self refillHeartAlert:YES];
            return;
        }

        switch(which)
        {
            case kPowerUpTypeHeart:
            {
				//achievement
				[kAppDelegate reportAchievement:kAchievement_powerupHeart];

                [node removeAllActions];

                if(kAppDelegate.numHearts <= 0) {
                    [self refillHeartAlert:YES];
                    return;
                }

                [self playSound:self.soundClick];

                //pause effect
                [self pauseEffect];

                //flash
                //[kAppDelegate.gameController showFlash:kFlashColorWhite];

                self.lastClickFireballDate = [NSDate date];

                //force red
                [node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"power_up_heart"]]];

                //move
                float fallDuration = 1.0f; //0.6f;
                float distance = distanceBetweenPoints(node.position, self.heart2.position);
                fallDuration *= (distance / self.size.height);

                if(fallDuration < 0.5f)
                    fallDuration = 0.5f;

                if(fallDuration > 1.0f)
                    fallDuration = 1.0f;

                CGPoint position = self.heart1.position;

                if(kAppDelegate.numHearts == 0 || kAppDelegate.numHearts == 1)
                    position = self.heart1.position;
                else if(kAppDelegate.numHearts == 2 || kAppDelegate.numHearts == 3)
                    position = self.heart2.position;
                else if(kAppDelegate.numHearts == 4 || kAppDelegate.numHearts == 5)
                    position = self.heart3.position;
				else if(kAppDelegate.numHearts == 6 || kAppDelegate.numHearts == 7 || kAppDelegate.numHearts == 8)
				{
					if([kAppDelegate isPremium])
						position = self.heart4.position;
					else
						position = self.heart3.position;
				}

                node.zPosition = self.heart1.zPosition-1;

                SKAction *move = [SKAction moveTo:position duration:fallDuration];
                move.timingMode = SKActionTimingEaseIn;

                [node runAction:move completion:^{
                    //stop
                    [node.physicsBody setVelocity:CGVectorMake(0,0)];

                    [self hidePowerup];

                    int heartGain = kHeartGain; //1
                    //int numHeartsBefore = (int)kAppDelegate.numHearts;
                    kAppDelegate.numHearts += heartGain;
                    kAppDelegate.numHearts = [kHelpers clamp:kAppDelegate.numHearts min:0 max:kHeartFull];
                    [self setNumHearts:(int)kAppDelegate.numHearts];
                    [self checkHeartTimer];

                    //heart refill sound, if needed
                    //if(numHeartsBefore < kAppDelegate.numHearts)
                    [self playSound:self.soundRefill];

                }];

                //scale
                [node runAction:[SKAction scaleTo:kHeartScale duration:fallDuration] ];

            }
            break;

            case kPowerUpTypeBomb:
            {
				//achievement
				[kAppDelegate reportAchievement:kAchievement_powerupBomb];

				[node removeAllActions];

                [kAppDelegate updateMult];
                [weakSelf updateMult:NO];

                //bomb
                [self showExplosionFlash:node];

                //sound
				[weakSelf playSound:weakSelf.soundExplosion1];

                //flash
                [kAppDelegate.gameController showFlash:kFlashColorWhite];

                //freeze fire
                [weakSelf freezeAllFireballs];

                //also hide fire
                [weakSelf hideAllFireballs:YES explode:YES];

                //hide spike
                [weakSelf hideSpike:YES fast:YES];

                //hide lava
                [self hideLava:YES];

                //show explosion mario2 BOMB
                //if(!kAppDelegate.inReview)
                if(NO)
                {
                    [self.bombExplosion removeAllActions];

                    //self.touch.zPosition = self.scanline.zPosition-1;

                    self.bombExplosion.zPosition = self.touch.zPosition + 1; //self.flash.zPosition + 1;  //node.zPosition + 1;
                    self.bombExplosion.position = node.position;

                    self.bombExplosion.alpha = 0.0f;
                    self.bombExplosion.hidden = NO;

                    self.bombExplosion.xScale = 0.1f;
                    self.bombExplosion.yScale = 0.1f;

                    SKAction *fadeIn = [SKAction fadeAlphaTo:0.3f duration:0.3f]; //0.7
                    SKAction *scale = [SKAction scaleTo:0.4f duration:0.1f]; //0.5

                    SKAction *fadeOut = [SKAction fadeAlphaTo:0.0f duration:0.4f];

                    [self.bombExplosion runAction:scale];
                    [self.bombExplosion runAction:fadeIn];

                    [self.bombExplosion runAction:fadeOut afterDelay:0.8f];

                }

            }
            break;
            case kPowerUpTypeStar:
            {
				//achievement
				[kAppDelegate reportAchievement:kAchievement_powerupStar];

				[node removeAllActions];

                [kAppDelegate updateMult];
                [weakSelf updateMult:NO];

				//hide previous
				[self hideBuff];

				//sound
                [self playSound:self.soundClick];


				//flash
                [kAppDelegate.gameController showFlash:kFlashColorWhite];

                //pause effect
                [self pauseEffect];

                self.lastClickFireballDate = [NSDate date];

                //move
                float fallDuration = 1.0f;
                float distance = distanceBetweenPoints(node.position, self.buffSquare.position);
                fallDuration *= (distance / self.size.height);

                if(fallDuration < 0.5f)
                    fallDuration = 0.5f;

                if(fallDuration > 1.0f)
                    fallDuration = 1.0f;

                CGPoint position = self.buff.position;

                node.zPosition = self.buffSquare.zPosition+1;

                SKAction *move = [SKAction moveTo:position duration:fallDuration];
                move.timingMode = SKActionTimingEaseIn;

                [node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"power_up_star"]]];

                [node runAction:move completion:^{
                    //stop
                    [node.physicsBody setVelocity:CGVectorMake(0,0)];

                    [self hidePowerup];

					//sound
                    [self playSound:self.soundBuffStar];
                    //play for any
                    [self playSound:self.soundBuffDoubler];


					[self showBuff:kBuffTypeStar];

                    [kAppDelegate saveState];
                }];

                //scale
                [node runAction:[SKAction scaleTo:0.5f duration:fallDuration] ];

            }
            break;

            case kPowerUpTypeShield:
            {
                //achievement
                [kAppDelegate reportAchievement:kAchievement_powerupShield];

                [node removeAllActions];

                //hide previous
                [self hideBuff];

                [self playSound:self.soundClick];

                //pause effect
                [self pauseEffect];

                self.lastClickFireballDate = [NSDate date];

                //move
                float fallDuration = 1.0f; //0.6f;
                float distance = distanceBetweenPoints(node.position, self.buffSquare.position);
                fallDuration *= (distance / self.size.height);

                if(fallDuration < 0.5f)
                    fallDuration = 0.5f;

                if(fallDuration > 1.0f)
                    fallDuration = 1.0f;

                CGPoint position = self.buff.position;

                node.zPosition = self.buffSquare.zPosition+1;

                SKAction *move = [SKAction moveTo:position duration:fallDuration];
                move.timingMode = SKActionTimingEaseIn;


                [node runAction:move completion:^{
                    //stop
                    [node.physicsBody setVelocity:CGVectorMake(0,0)];

                    [self hidePowerup];

                    //sound
                    [self playSound:self.soundBuffShield];

                    //play for any
                    [self playSound:self.soundBuffDoubler];




                    [self showBuff:kBuffTypeShield];

                    [kAppDelegate saveState];
                }];

                //scale
                [node runAction:[SKAction scaleTo:self.buff.xScale duration:fallDuration] ];
            }
                break;

            case kPowerUpTypeGrow:
            {
                //achievement
                [kAppDelegate reportAchievement:kAchievement_grow];

                [node removeAllActions];

                //force red
                [node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"power_up_grow"]]];

                //hide previous
                [self hideBuff];

                [self playSound:self.soundClick];

                //pause effect
                [self pauseEffect];

                self.lastClickFireballDate = [NSDate date];

                //move
                float fallDuration = 1.0f; //0.6f;
                float distance = distanceBetweenPoints(node.position, self.buffSquare.position);
                fallDuration *= (distance / self.size.height);

                if(fallDuration < 0.5f)
                    fallDuration = 0.5f;

                if(fallDuration > 1.0f)
                    fallDuration = 1.0f;

                CGPoint position = self.buff.position;

                node.zPosition = self.buffSquare.zPosition+1;

                SKAction *move = [SKAction moveTo:position duration:fallDuration];
                move.timingMode = SKActionTimingEaseIn;


                [node runAction:move completion:^{
                    //stop
                    [node.physicsBody setVelocity:CGVectorMake(0,0)];

                    [self hidePowerup];

                    //sound
                    [self playSound:self.soundBuffGrow];
                    [self playSound:self.soundRubber];

                    //play for any
                    [self playSound:self.soundBuffDoubler];

                    [self showBuff:kBuffTypeGrow];

                    [kAppDelegate saveState];
                }];

                //scale
                [node runAction:[SKAction scaleTo:self.buff.xScale duration:fallDuration] ];
            }
                break;

            case kPowerUpTypeShrink:
            {
                //achievement
                [kAppDelegate reportAchievement:kAchievement_shrink];

                [node removeAllActions];

                //force red
                [node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"power_up_shrink"]]];

                //hide previous
                [self hideBuff];

                [self playSound:self.soundClick];

                //pause effect
                [self pauseEffect];

                self.lastClickFireballDate = [NSDate date];

                //move
                float fallDuration = 1.0f; //0.6f;
                float distance = distanceBetweenPoints(node.position, self.buffSquare.position);
                fallDuration *= (distance / self.size.height);

                if(fallDuration < 0.5f)
                    fallDuration = 0.5f;

                if(fallDuration > 1.0f)
                    fallDuration = 1.0f;

                CGPoint position = self.buff.position;

                node.zPosition = self.buffSquare.zPosition+1;

                SKAction *move = [SKAction moveTo:position duration:fallDuration];
                move.timingMode = SKActionTimingEaseIn;


                [node runAction:move completion:^{
                    //stop
                    [node.physicsBody setVelocity:CGVectorMake(0,0)];

                    [self hidePowerup];

                    //sound
                    [self playSound:self.soundBuffShrink];
                    [self playSound:self.soundRubber];

                    //play for any
                    [self playSound:self.soundBuffDoubler];

                    [self showBuff:kBuffTypeShrink];

                    [kAppDelegate saveState];
                }];

                //scale
                [node runAction:[SKAction scaleTo:self.buff.xScale duration:fallDuration] ];
            }
                break;

            case kPowerUpTypeInk:
            {
                //achievement
                [kAppDelegate reportAchievement:kAchievement_ink];

                [node removeAllActions];

                //force red
                [node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"power_up_ink"]]];

                //hide previous
                [self hideBuff];

                [self playSound:self.soundClick];

                //pause effect
                [self pauseEffect];

                self.lastClickFireballDate = [NSDate date];

                //move
                float fallDuration = 1.0f; //0.6f;
                float distance = distanceBetweenPoints(node.position, self.buffSquare.position);
                fallDuration *= (distance / self.size.height);

                if(fallDuration < 0.5f)
                    fallDuration = 0.5f;

                if(fallDuration > 1.0f)
                    fallDuration = 1.0f;

                CGPoint position = self.buff.position;

                node.zPosition = self.buffSquare.zPosition+1;

                SKAction *move = [SKAction moveTo:position duration:fallDuration];
                move.timingMode = SKActionTimingEaseIn;


                [node runAction:move completion:^{
                    //stop
                    [node.physicsBody setVelocity:CGVectorMake(0,0)];

                    [self hidePowerup];

                    //sound
                    [self playSound:self.soundBuffInk];
                    //play for any
                    [self playSound:self.soundBuffDoubler];

                    [self showBuff:kBuffTypeInk];

                    [kAppDelegate saveState];
                }];

                //scale
                [node runAction:[SKAction scaleTo:self.buff.xScale duration:fallDuration] ];
            }
                break;


            case kPowerUpTypePotion:
            {
				//achievement
				[kAppDelegate reportAchievement:kAchievement_powerupPotion];

                [node removeAllActions];

                if(kAppDelegate.numHearts <= 0) {
                    [self refillHeartAlert:YES];
                    return;
                }

                [self playSound:self.soundClick];
                //[self playSound:self.soundPotion2]; //glass

                //pause effect
                [self pauseEffect];

                //flash
                //[kAppDelegate.gameController showFlash:kFlashColorWhite];

                self.lastClickFireballDate = [NSDate date];

                //force red
                [node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"power_up_potion"]]];

                //move
                float fallDuration = 1.0f; //0.6f;
                float distance = distanceBetweenPoints(node.position, self.potion.position);
                fallDuration *= (distance / self.size.height);

                if(fallDuration < 0.5f)
                    fallDuration = 0.5f;

                if(fallDuration > 1.0f)
                    fallDuration = 1.0f;

                CGPoint position = self.potion.position;

                node.zPosition = self.potion.zPosition-1;

                SKAction *move = [SKAction moveTo:position duration:fallDuration];
                move.timingMode = SKActionTimingEaseIn;

                [node runAction:move completion:^{
                    //stop
                    [node.physicsBody setVelocity:CGVectorMake(0,0)];

                    [self hidePowerup];

                    [self playSound:self.soundPotion2]; //glass

                    kAppDelegate.numPotions += 1;

                    if(kAppDelegate.numPotions > kMaxPotions)
                        kAppDelegate.numPotions = kMaxPotions;

                    [self updatePotion:YES];

                    [kAppDelegate saveState];
                }];

                //scale
                [node runAction:[SKAction scaleTo:kHeartScale duration:fallDuration] ];

            }
            break;

            case kPowerUpTypeDoubler:
            {
                //achievement
                [kAppDelegate reportAchievement:kAchievement_doubler];

                //touchedShield
                [node removeAllActions];

                //force yellow
                [node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"power_up_doubler"]]];

                //hide previous
                [self hideBuff];

                [self playSound:self.soundClick];

                //pause effect
                [self pauseEffect];

                self.lastClickFireballDate = [NSDate date];

                //move
                float fallDuration = 1.0f; //0.6f;
                float distance = distanceBetweenPoints(node.position, self.buffSquare.position);
                fallDuration *= (distance / self.size.height);

                if(fallDuration < 0.5f)
                    fallDuration = 0.5f;

                if(fallDuration > 1.0f)
                    fallDuration = 1.0f;

                CGPoint position = self.buff.position;

                node.zPosition = self.buffSquare.zPosition+1;

                SKAction *move = [SKAction moveTo:position duration:fallDuration];
                move.timingMode = SKActionTimingEaseIn;


                [node runAction:move completion:^{
                    //stop
                    [node.physicsBody setVelocity:CGVectorMake(0,0)];

                    [self hidePowerup];

                    //sound
                    //[self playSound:self.soundBuffShield];
                    //play for any
                    [self playSound:self.soundBuffDoubler];


                    [self showBuff:kBuffTypeDoubler];

                    //force update mult
                    [self updateMult:YES];

                    [kAppDelegate saveState];
                }];

                //scale
                [node runAction:[SKAction scaleTo:self.buff.xScale duration:fallDuration] ];
            }
                break;

            case kPowerUpTypeAuto:
            {
                //achievement
                [kAppDelegate reportAchievement:kAchievement_auto];

                //touchedShield
                [node removeAllActions];

                //force yellow
                [node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"power_up_auto"]]];

                //hide previous
                [self hideBuff];

                [self playSound:self.soundClick];

                //pause effect
                [self pauseEffect];

                self.lastClickFireballDate = [NSDate date];

                //move
                float fallDuration = 1.0f; //0.6f;
                float distance = distanceBetweenPoints(node.position, self.buffSquare.position);
                fallDuration *= (distance / self.size.height);

                if(fallDuration < 0.5f)
                    fallDuration = 0.5f;

                if(fallDuration > 1.0f)
                    fallDuration = 1.0f;

                CGPoint position = self.buff.position;

                node.zPosition = self.buffSquare.zPosition+1;

                SKAction *move = [SKAction moveTo:position duration:fallDuration];
                move.timingMode = SKActionTimingEaseIn;


                [node runAction:move completion:^{
                    //stop
                    [node.physicsBody setVelocity:CGVectorMake(0,0)];

                    [self hidePowerup];

                    //sound
                    //[self playSound:self.soundBuffShield];
                    //play for any
                    [self playSound:self.soundBuffAuto];


                    [self showBuff:kBuffTypeAuto];

                    //force update mult
                    [self updateMult:YES];

                    [kAppDelegate saveState];
                }];

                //scale
                [node runAction:[SKAction scaleTo:self.buff.xScale duration:fallDuration] ];
            }
                break;


            case kPowerUpTypeWeak:
            {
                //achievement
                [kAppDelegate reportAchievement:kAchievement_weak];

                //touchedShield
                [node removeAllActions];

                //force yellow
                [node runAction:[SKAction setTexture:[SKTexture textureWithImageNamed:@"power_up_weak"]]];

                //hide previous
                [self hideBuff];

                [self playSound:self.soundClick];

                //pause effect
                [self pauseEffect];

                self.lastClickFireballDate = [NSDate date];

                //move
                float fallDuration = 1.0f; //0.6f;
                float distance = distanceBetweenPoints(node.position, self.buffSquare.position);
                fallDuration *= (distance / self.size.height);

                if(fallDuration < 0.5f)
                    fallDuration = 0.5f;

                if(fallDuration > 1.0f)
                    fallDuration = 1.0f;

                CGPoint position = self.buff.position;

                node.zPosition = self.buffSquare.zPosition+1;

                SKAction *move = [SKAction moveTo:position duration:fallDuration];
                move.timingMode = SKActionTimingEaseIn;


                [node runAction:move completion:^{
                    //stop
                    [node.physicsBody setVelocity:CGVectorMake(0,0)];

                    [self hidePowerup];

                    //sound
                    //[self playSound:self.soundWeakSpot];
                    [self playSound:self.soundWeakSpot2];
                    //play for any
                    [self playSound:self.soundBuffDoubler];


                    [self showBuff:kBuffTypeWeak];

                    //force update mult
                    [self updateMult:YES];

                    [kAppDelegate saveState];
                }];

                //scale
                [node runAction:[SKAction scaleTo:self.buff.xScale duration:fallDuration] ];
            }
                break;



            default:
                if([kHelpers isDebug])
                    assert(0);
                break;
        }


        //if(kVoiceEnabled)
        //    [kAppDelegate playSound:@"voice_powerup.caf"];

        //hide powerup, but not heart/potions, and buffs
        if(which != kPowerUpTypeHeart &&
           which != kPowerUpTypePotion &&
           which != kPowerUpTypeDoubler &&
           which != kPowerUpTypeAuto &&
           which != kPowerUpTypeShield &&
           which != kPowerUpTypeGrow &&
           which != kPowerUpTypeShrink &&
           which != kPowerUpTypeInk &&
           which != kPowerUpTypeWeak &&
           which != kPowerUpTypeStar)
            [weakSelf hidePowerup];


        //http://www.ioscreator.com/tutorials/moving-sprites-path-sprite-kit
        /*
         CGMutablePathRef path = CGPathCreateMutable();
         CGPathMoveToPoint(path, NULL, 0, 0);
         CGPathAddLineToPoint(path, NULL, 50, 100);
         SKAction *followline = [SKAction followPath:path asOffset:YES orientToPath:NO duration:3.0];
         UIBezierPath *square = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
         SKAction *followSquare = [SKAction followPath:square.CGPath asOffset:YES orientToPath:NO duration:5.0];
         */

        //+1 star
        SKLabelNode *plusLabel = nil;
        //plusLabel = [SKLabelNode labelNodeWithFontNamed:kFontNamePlus];
        plusLabel = [SKLabelNode labelNodeWithFontNamed:kFontName];

        plusLabel.scale = 1.0f;
        plusLabel.fontSize = 160.0f;
        //plusLabel.fontSize = 20;

        plusLabel.name = @"plusLabel_ignore";
        plusLabel.fontColor = [CBSkinManager getMessageColor];

        //NSString *name = nil;
        switch(which)
        {
            case kPowerUpTypeStar:
                plusLabel.text = @"star";
                plusLabel.fontSize = 140.0f;
                break;
			case kPowerUpTypeBomb:
                plusLabel.text = @"bomb";
                plusLabel.fontSize = 140.0f;
                break;
            case kPowerUpTypeHeart:
                plusLabel.text = @"heart";
                plusLabel.fontSize = 130.0f;
                break;
            case kPowerUpTypePotion:
                plusLabel.text = @"potion";
                plusLabel.fontSize = 120.0f;
                break;
            case kPowerUpTypeShield:
                plusLabel.text = @"shield";
                plusLabel.fontSize = 120.0f;
                break;
            case kPowerUpTypeGrow:
                //plusLabel.text = @"grow";
                plusLabel.text = @"huge";
                plusLabel.fontSize = 140.0f;
                break;
            case kPowerUpTypeShrink:
                //plusLabel.text = @"shrink";
                plusLabel.text = @"tiny";
                plusLabel.fontSize = 140.0f;
                break;
            case kPowerUpTypeInk:
                //plusLabel.text = @"shrink";
                plusLabel.text = @"ink";
                plusLabel.fontSize = 140.0f;
                break;
            case kPowerUpTypeDoubler:
                plusLabel.text = @"doubler";
                plusLabel.fontSize = 90.0f;
                break;
            case kPowerUpTypeAuto:
                plusLabel.text = @"auto";
                plusLabel.fontSize = 140.0f;
                break;
            case kPowerUpTypeWeak:
                plusLabel.text = @"weak spot";
                plusLabel.fontSize = 70.0f;
                break;
            default:
                if([kHelpers isDebug])
                    assert(0);
                break;
        }

        //upper
        plusLabel.text = [plusLabel.text uppercaseString];

        //on powerup
//        int xPlus  = weakNode.position.x;
//        int yPlus =  weakNode.position.y;

        //center
        int xPlus  = self.frame.size.width/2;
        int yPlus =  self.frame.size.height/2 - 80;

        plusLabel.position = CGPointMake(xPlus, yPlus);
        plusLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        plusLabel.zPosition = 200;
        plusLabel.alpha = 1; //hide

        float plusDuration = 1.5f; //1.0f;
        float distance = 120; //80;
        SKAction *actionMovePlus = [SKAction moveBy:CGVectorMake(0,distance) duration:plusDuration];
        [plusLabel runAction:actionMovePlus];
        SKAction *actionFadePlus = [SKAction fadeAlphaTo:0.0f duration:plusDuration];
        [plusLabel runAction:actionFadePlus];
        //delete
        SKAction *deleteAction1Plus = [SKAction waitForDuration:plusDuration];
        SKAction *deleteAction2Plus = [SKAction runBlock:^{
            [plusLabel removeFromParent];
        }];

        SKAction *deleteSequencePlus = [SKAction sequence:@[deleteAction1Plus,deleteAction2Plus]];
        [plusLabel runAction:deleteSequencePlus];

        //flash color
        SKAction *actionColorWait = [SKAction waitForDuration:0.15f]; //0.15f
        SKAction *actionColor3 = [SKAction runBlock:^{
            //self.comboLabel.fontColor = [UIColor yellowColor];
            plusLabel.fontColor =  [UIColor colorWithHex:0xfdfd51]; //yellow

        }];
        SKAction *actionColor4 = [SKAction runBlock:^{
            //plusLabel.fontColor = [UIColor orangeColor];
            plusLabel.fontColor = [UIColor colorWithHex:0xff8000]; //orange

        }];

        [plusLabel runActionsSequenceForever:@[actionColor3,actionColorWait,actionColor4, actionColorWait]];


        [weakSelf addChild:plusLabel];

        //move up
        NSString *fallName = [CBSkinManager getPowerupSquareImageName:which];

        float coinScale = 3.0f;

        float coinDuration = 0.5f;
        SKSpriteNode *fall = [SKSpriteNode spriteNodeWithImageNamed:fallName];
        fall.name = @"fall";
        fall.zPosition = 5;
        fall.scale = coinScale;

        fall.position = CGPointMake(weakSelf.block.position.x,
                                    weakSelf.block.position.x + weakSelf.block.size.height/2 - fall.size.height/2);


        //move
        SKAction *actionMove = [SKAction moveBy:CGVectorMake(0,400) duration:coinDuration];
        [fall runAction:actionMove];

        SKAction *actionFade = [SKAction fadeAlphaTo:0.0f duration:coinDuration];
        [fall runAction:actionFade];

        //delete
        SKAction *deleteAction1 = [SKAction waitForDuration:coinDuration];
        SKAction *deleteAction2 = [SKAction runBlock:^{
            [fall removeFromParent];
        }];

        SKAction *deleteSequence = [SKAction sequence:@[deleteAction1,deleteAction2]];
        [fall runAction:deleteSequence];


        [weakSelf addChild:fall];


        //fall

        float fallDuration = 3.0f;
        float fallWait = coinDuration + 0.3f;

        int min = 0;
        int max = weakSelf.size.width;
        //int random =  min + arc4random() % (max-min);
        int random =  min + arc4random_uniform(max);

        SKSpriteNode *powerupFall = [SKSpriteNode spriteNodeWithImageNamed:fallName];
        powerupFall.name = @"powerupFall";
        powerupFall.zPosition = 2;
        powerupFall.scale = coinScale/2;
        powerupFall.alpha = 0.3f;


        powerupFall.position = CGPointMake(random,
                                        weakSelf.size.height+powerupFall.size.height/2);

        SKAction *actionMoveWait = [SKAction waitForDuration:fallWait];
        SKAction *actionMoveFall = [SKAction moveBy:CGVectorMake(0,
                                                                 -(weakSelf.size.height+powerupFall.size.height/2)) duration:fallDuration];
        [powerupFall runAction:[SKAction sequence:@[actionMoveWait,actionMoveFall]]];

        //spin scale
        SKAction* actionSpin1 = [SKAction scaleXTo:1.0f duration:kCoinSpinScaleDuration];
        SKAction* actionSpin2 = [SKAction scaleXTo:kCoinSpinScaleMin duration:kCoinSpinScaleDuration];

        SKAction *actionSpin = [SKAction sequence:@[actionSpin1, actionSpin2]];
        [powerupFall runAction:[SKAction repeatActionForever:actionSpin]];

        //delete
        SKAction *deleteAction1Fall = [SKAction waitForDuration:fallDuration+fallWait];
        SKAction *deleteAction2Fall = [SKAction runBlock:^{
            [powerupFall removeFromParent];
        }];

        SKAction *deleteSequenceFall = [SKAction sequence:@[deleteAction1Fall,deleteAction2Fall]];
        [powerupFall runAction:deleteSequenceFall];

        [weakSelf addChild:powerupFall];

        //combo
        [self updateComboLabel];

        //report
        [kAppDelegate reportScore];

        [self showTouchAnim:node];

        //flash fireballs
        [self flashFireballs];
    }

    //disable for fast click
    [node enable:NO];

}

//[self setShouldEnableEffects:NO];

-(void)showImageSquare {
    [self showImageSquare:NO];
}

//shownavimage, showsquareimage, showpowerupsquare
-(void)showImageSquare:(BOOL)force
{
    //BOOL premium = [kAppDelegate isPremium];
	BOOL shouldShowPlus = NO;
	 if(!force)
    {
        //premium and after level 3
        if(![kAppDelegate isPremium] && kAppDelegate.level >= 3)
        {
            if([kHelpers randomBool100:kAppDelegate.navPlusOdds]) //odds
            //if(self.navPlusAlternate) //alternate
            //if(self.navPlusAlternate && [kHelpers randomBool100:kAppDelegate.navPlusOdds]) //both
            {
				shouldShowPlus = YES;
            }
        }
    }


    //level
//    if((int)kAppDelegate.level <= 1) {
//        return;
//    }

    if(kAppDelegate.currentBuff != kBuffTypeNone)
    {
        //not during buff
        ///return;
    }

    if(!force)
    {
        //already
        if(kAppDelegate.powerupVisibleType != kPowerUpTypeNone)
            return;

        if(self.squareImageReady)
            return;

        if(self.winning || self.dying)
            return;


        if(self.lastSquareDate)
        {
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastSquareDate];
            if(interval < kPowerupMinDelay)
            {
                return;
            }
        }
    }

    //reset
    [self hideImageSquare:YES];
    [self hideNavPlus];

    //enable square
    [self.navSquare enable:YES];
    [self.imageSquare enable:YES];

    self.navSquare.hidden = NO;

    self.lastSquareDate = [NSDate date];

    //overlay
    [self.navOverlay removeAllActions];
    [self.navOverlay runAction:[SKAction fadeAlphaTo:0.5 duration:0.5f]];
    SKAction *animOverlay = [SKAction animateWithTextures:@[
                                                          [SKTexture textureWithImageNamed:@"navOverlay"],
                                                          [SKTexture textureWithImageNamed:@"navOverlay2"]
                                                          ]
                                                        timePerFrame:0.1f];
    [self.navOverlay runAction:[SKAction repeatActionForever:animOverlay] withKey:@"navOverlayAnim"];


    [self.navSquare removeAllActions];

    //self.navSquare.alpha = 0.0f;
    [self.navSquare runAction:[SKAction fadeAlphaTo:0.8 duration:0.5f]];


    //scale
    float oldScale = 1.6f; //1.8f;
    float newScale = 1.7f; //1.8f;
    SKAction *actionScale0 = [SKAction scaleTo:newScale duration:0.2f];//in
    SKAction *actionScale1 = [SKAction waitForDuration:0.1f];
    SKAction *actionScale2 = [SKAction scaleTo:oldScale duration:0.2f];//out
    SKAction * fadeSequence = [SKAction sequence:@[actionScale0,actionScale1,actionScale2]];
    [self.navSquare runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"navSquareScale"];

    //show
    if(kAppDelegate.titleController.menuState == menuStateGame) {

        //play spinning sound
		SKAction *actionSoundSpin = [SKAction runBlock:^{
            [self.soundSpin stop];
            [self playSound:self.soundSpin looping:YES]; //loop
    	}];

        [self runAction:actionSoundSpin];

        //show touch anim
        [self showTouchAnim:self.imageSquare];
    }

    self.imageSquare.alpha = kImageSquareAlpha;

    //random image

    [self.imageSquare removeAllActions];

    NSMutableArray *powerUpImageArray = [NSMutableArray array];
    NSArray *availablePowerupsArray = [CBSkinManager getAvailablePowerups];

    for(NSNumber *num in availablePowerupsArray)
    {
        if(force || shouldShowPlus)
        {
            BOOL negative = [self isPowerUpNegative:[num intValue]];

            //skip negatives
            if(negative)
                continue;
        }

        //add it, if not skipped
        [powerUpImageArray addObject:[CBSkinManager getPowerupSquareImageTexture:[num intValue] blur:NO]];
    }

    //hide after delay
    CGFloat interval = kHideSquareDelay;
    SKAction* wait = [SKAction waitForDuration:interval];
    SKAction* run = [SKAction runBlock:^{
        //[self playSound:self.soundSigh];
        //[self playSound:self.soundGasp];

        [self playSound:self.soundWrong];

        [self hideImageSquare:NO];

    }];

    SKAction* sequence = [SKAction sequence:@[wait, run]];

    //show
    [self runAction:sequence withKey:@"hideImageSquare"];

    //flash before timeout
    SKAction *actionFlash1 = [SKAction fadeAlphaTo:0.0f duration:0.2f];
    SKAction *actionFlash2 = [SKAction fadeAlphaTo:1.0f duration:0.2f];
    SKAction *actionFlashSound = [SKAction runBlock:^{
        //[self playSound:self.soundClock];
    }];
    SKAction *actionFlash3 = [SKAction sequence:@[actionFlash1, actionFlash2]];
    SKAction *actionFlash4 = [SKAction repeatActionForever:actionFlash3];
    SKAction *actionFlashGroup = [SKAction group:@[actionFlash4,actionFlashSound]];

    [self.imageSquare runAction:actionFlashGroup afterDelay: (interval - kStartFlashSquareDelay)];
    [self.navSquare runAction:actionFlashGroup afterDelay: (interval - kStartFlashSquareDelay)];

    //loop array
    SKAction *tempAnim2 = [SKAction animateWithTextures:powerUpImageArray timePerFrame:0.15f];
    [self.imageSquare runAction:[SKAction repeatActionForever:tempAnim2] withKey:@"imageSquare"];

    //scale
    oldScale = 1.3f; //0.5f; //0.4f;
    newScale = 1.1f; //0.6f; //0.5f;
    actionScale0 = [SKAction scaleTo:newScale duration:0.2f];//in
    actionScale1 = [SKAction waitForDuration:0.1f];
    actionScale2 = [SKAction scaleTo:oldScale duration:0.2f];//out
    fadeSequence = [SKAction sequence:@[actionScale0,actionScale1,actionScale2]];

    [self.imageSquare runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"navSquareScale"];

    self.squareImageReady = YES;

	//plus
	if(shouldShowPlus)
	{
	      [self showNavPlus];
	}

	self.navPlusAlternate = !self.navPlusAlternate; //alternate


    //force nav plus
    if([kHelpers isDebug]) {
        //[self showNavPlus];
    }

    [self showArrowSquare:YES];

	/*if(kAppDelegate.level > 1)
	{
		//plus

		[self hideNavPlus];
	}*/

	//alert
    if(!kAppDelegate.playedHelpPowerupReady)
    {
        kAppDelegate.playedHelpPowerupReady = YES;
        //[kAppDelegate saveState];

        NSString *message = @"Use the <color1>Power-ups</color1> to defeat the enemies.";

        if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
            [kAppDelegate.alertView dismissAnimated:NO];

        kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                         andMessage:message];

        [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                              type:kAlertButtonGreen
                                           handler:^(SIAlertView *alert) {
                                               //
                                               [kAppDelegate playSound:kClickSound];

                                           }];

        kAppDelegate.alertView.transitionStyle = kAlertStyle;

        [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
            //nothing
        }];

        //close, unpause
        [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
            //kAppDelegate.gameController.paused = NO;
            //self.paused = NO;
            [self enablePause:NO];
            [kAppDelegate.gameController blurScene:NO];

            [kAppDelegate.gameController showVCR:NO animated:YES];

        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            //pause
            [self enablePause:YES];
            [kAppDelegate.gameController blurScene:YES];

            [kAppDelegate.alertView show:YES];
            [kAppDelegate.gameController showVCR:YES animated:YES];

        });
    }
}

-(void)hideImageSquare
{
    [self hideImageSquare:YES];
}

-(void)showNavPlus
{
    //if(self.squareImageReady)
    //    return;

    if(![kHelpers checkOnline])
        return;

	[self.navPlus removeAllActions];

	self.navPlus.hidden = NO;
    CGFloat plusAlphaIn = 1.0f;
    CGFloat plusAlphaOut = 1.0f; //0.7f;
	CGFloat plusFadeDuration = 0.2f;
	CGFloat plusScale = 1.6f; //1.8f
	CGFloat plusScaleOld = 1.4f;
	CGFloat waitDuration = 1.0f;

    self.squareImageReady = NO;

	[self.navPlus runAction:[SKAction fadeAlphaTo:plusAlphaIn duration:plusFadeDuration] completion:^{
		//pulse forever?
		SKAction *fadeIn = [SKAction fadeAlphaTo:plusAlphaIn duration:plusFadeDuration];
		SKAction *fadeOut = [SKAction fadeAlphaTo:plusAlphaOut duration:plusFadeDuration];

		SKAction *scaleIn = [SKAction scaleTo:plusScale duration:plusFadeDuration];
		SKAction *scaleOut = [SKAction scaleTo:plusScaleOld duration:plusFadeDuration];

		SKAction *wait = [SKAction waitForDuration:waitDuration];

		SKAction * sequenceFade = [SKAction sequence:@[wait, fadeIn, fadeOut]];
		SKAction * sequenceScale = [SKAction sequence:@[wait, scaleIn, scaleOut]];

        SKAction *group = [SKAction group:@[sequenceFade, sequenceScale]];
        [self.navPlus runAction:[SKAction repeatActionForever:group] withKey:@"navPlusPulse"];
	}];
}

-(void)hideNavPlus
{
	[self.navPlus removeAllActions];

	[self.navPlus runAction:[SKAction fadeOutWithDuration:0.1f] completion:^{
		self.navPlus.hidden = YES;
	}];
}

//hidenav
-(void)hideImageSquare:(BOOL)removeOldAction
{
    //overlay
    [self.navOverlay removeAllActions];
    [self.navOverlay runAction:[SKAction fadeOutWithDuration:0.1f]];

    [self.imageSquare removeAllActions];

    if(removeOldAction)
        [self removeActionForKey:@"hideImageSquare"];

    [self.imageSquare runAction:[SKAction fadeOutWithDuration:0.1f]];

    self.squareImageReady = NO;

    //reset square
    [self.navSquare removeAllActions];

    self.navSquare.alpha = 0.3f; //0.0f;

	float oldScale = 1.6f;
    [self.navSquare runAction: [SKAction scaleTo:oldScale duration:0.1f]];

    [self hideArrowSquare:YES];

    [self hideNavPlus];

    //remove looped sound
    [self.soundSpin stop];
}

-(void)showTouchCombo {

    //for fireball, star, heart...
    SKNode *node = nil;
    node = self.touchCombo;

    if(!node.hidden)
        return;

    [node removeAllActions];
    node.alpha = 1.0f;
    node.scale = 0.5f;
   // node.position = position;
    node.hidden = NO;
    float duration = 0.6f;
    float duration2 = 0.1f;

    [node runAction:[SKAction scaleTo:3.6f duration:duration]];
    [node runAction:[SKAction fadeAlphaTo:0.3f duration:duration] completion:^{

        [node runAction:[SKAction fadeAlphaTo:0.0f duration:duration2] completion:^{
            node.hidden = YES;
        }];

    }];
}

-(void)showFireballX:(SKNode*)touchedNode isFireball:(BOOL)isFireball{
    //for fireball, star, heart...
    SKNode *node = self.fireballX;

    if(!node.hidden)
        return;

    [node removeAllActions];
    node.alpha = 1.0f;
    node.scale = 0.6f;
    node.position = isFireball ? touchedNode.position : self.lastClickPosition;
    node.hidden = NO;
    node.zPosition = touchedNode.zPosition + 1;

    //float durationIn = 0.1f;
    //float durationWait = 0.0f;
    float durationOut = 0.8f;

    //SKAction* fadeIn = [SKAction fadeAlphaTo:0.8f duration:durationIn];
    //SKAction* scaleIn = [SKAction scaleTo:0.4f duration:durationIn];

    SKAction* fadeOut = [SKAction fadeOutWithDuration:durationOut];
    SKAction* scaleOut = [SKAction scaleTo:1.2f duration:durationOut];

    //SKAction *groupIn = [SKAction group:@[fadeIn, scaleIn]];
    SKAction *groupOut = [SKAction group:@[fadeOut, scaleOut]];
    //SKAction *wait = [SKAction waitForDuration:durationWait];

    //SKAction * fadeSequence = [SKAction sequence:@[groupIn, wait, groupOut]];
    SKAction * fadeSequence = [SKAction sequence:@[groupOut]];

    [node runAction:fadeSequence completion:^{
        node.hidden = YES;
    }];

}

-(void)showTouchAnim:(SKSpriteNode*)node {

    if(!node.hidden)
        return;

    [node removeAllActions];
    node.alpha = 1.0f;
    node.scale = 0.5f;
    node.position = node.position;
    node.hidden = NO;
    float duration = 0.6f;
    float duration2 = 0.1f;

    [node runAction:[SKAction scaleTo:3.6f duration:duration]];
    [node runAction:[SKAction fadeAlphaTo:0.3f duration:duration] completion:^{

        [node runAction:[SKAction fadeAlphaTo:0.0f duration:duration2] completion:^{
            node.hidden = YES;
        }];

    }];

}

-(SKSpriteNode*)showPowerup:(BOOL)force which:(PowerupType)which
{
    return [self showPowerup:force which:which direction:ePowerupPositionNone];
}

-(SKSpriteNode*)showPowerup:(BOOL)force which:(PowerupType)which direction:(PowerupDirection)direction {

    BOOL negative = [self isPowerUpNegative:which];

    if(self.winning || self.dying)
        return nil;

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return nil;

    if((kAppDelegate.powerupVisibleType != kPowerUpTypeNone)  && !force)
        return nil;

    if((kAppDelegate.powerupVisibleType != kPowerUpTypeNone)  && force) {
        [self hidePowerup];
    }

    if(kAppDelegate.currentBuff != kBuffTypeNone)
    {
        //not during buff
        //return nil;
    }

    //hide buff, if already
    if(kAppDelegate.currentBuff == kBuffTypeNone)
    {
        [self hideBuff];
    }

    [kAppDelegate dbIncPowerup];
    kAppDelegate.powerupCountLocal++;

    kAppDelegate.gameController.sharing = NO;
    self.sharing = NO;

    //remove looped sound
    [self.soundSpin stop];

    SKNode *node = nil;

    CGFloat tempScale = 1.5f;

    NSString *name = nil;
    FISound *voice = nil;

    switch(which)
    {
        case kPowerUpTypeStar:
            name = kPowerUpNameStar;
            voice = self.soundPowerupStar;
            break;
        case kPowerUpTypeBomb:
            name = kPowerUpNameBomb;
            voice = self.soundPowerupBomb;
            break;
        case kPowerUpTypeHeart:
            name = kPowerUpNameHeart;
            voice = self.soundPowerupHeart;
            break;
        case kPowerUpTypePotion:
            name = kPowerUpNamePotion;
            voice = self.soundPowerupPotion;
            break;
        case kPowerUpTypeShield:
            name = kPowerUpNameShield;
            voice = self.soundPowerupShield;
            break;
        case kPowerUpTypeGrow:
            name = kPowerUpNameGrow;
            voice = self.soundPowerupGrow;
            break;
        case kPowerUpTypeShrink:
            name = kPowerUpNameShrink;
            voice = self.soundPowerupShrink;
            break;
        case kPowerUpTypeInk:
            name = kPowerUpNameInk;
            voice = self.soundPowerupInk;
            break;
        case kPowerUpTypeDoubler:
            name = kPowerUpNameDoubler;
            voice = self.soundPowerupDoubler;
            break;
        case kPowerUpTypeAuto:
            name = kPowerUpNameAuto;
            voice = self.soundPowerupAuto;
            break;
        case kPowerUpTypeWeak:
            name = kPowerUpNameWeak;
            voice = self.soundPowerupWeak;
            break;

        default:
            if([kHelpers isDebug])
                assert(0);
            break;
    }

    //find
    for(SKNode *tempNode in self.powerupArray) {
        if([tempNode.name isEqualToString:name]) {
            node = tempNode;
            break;
        }
    }

    //create
    if(!node) {
		node = [self createPowerUp:which];
    }

    //remove
    [node removeAllActions];

    self.lastPowerupDate = [NSDate date];

    kAppDelegate.powerupVisibleType = which;

    node.hidden = NO;
    if(kAppDelegate.titleController.menuState == menuStateGame &&
            !kAppDelegate.gameController.curtainsVisible && !kAppDelegate.gameController.darkVisible) {
        ///[self playSound:self.soundStarAppear];
        [self playSound:self.soundChorus];

        //also voice
        if(voice && kVoiceEnabled)
            [self playSound:voice];
    }

    //show shine
    SKNode *powerupShine = [node childNodeWithName:@"powerupShine_ignore"];
    powerupShine.alpha = 0.8f;

    //pause effect
    [self pauseEffect];

    float speedx = 3.0f;
    float speedy = 1.0f;

    //random speed
    float randomSpeed = arc4random_uniform(kRandomSpeedIncrease);
    speedx += (randomSpeed/10.0) * 1.0f;
    randomSpeed = arc4random_uniform(kRandomSpeedIncrease);
    speedy += (randomSpeed/10.0) * 1.0f;


    //always go down
    if(negative)
        direction = ePowerupPositionTopLeft;

    //random position
    PowerupDirection random = ePowerupPositionNone;
    if(direction == ePowerupPositionNone)
    {
        //random
        //arc4random_uniform(4);

        //force
        //random = ePowerupPositionTopRight;
        random = direction = ePowerupPositionTopLeft;

    }
    else
        random = direction;

    if(random == ePowerupPositionBottomLeft) {
        //bottom left
        node.position = CGPointMake(50, 110);

        speedx *= 1;
        speedy *= 1;
    }
    else if(random == ePowerupPositionBottomRight) {
        //bottom right
        node.position = CGPointMake(self.frame.size.width - 50, 110);

        speedx *= -1;
        speedy *= 1;
    }
    else if(random == ePowerupPositionTopLeft) {
        //top left
        node.position = CGPointMake(50, self.frame.size.height - 90);

        speedx *= [kHelpers randomBool] ? 1 : -1;
        speedy *= -1;
    }
    else if(random == ePowerupPositionTopRight) {
        //top right
        node.position = CGPointMake(self.frame.size.width - 50, self.frame.size.height - 90);

        speedx *= -1;
        speedy *= -1;
    }

    else if(random == ePowerupPositionBottomCenter) {
        //top right
        node.position = CGPointMake(self.frame.size.width/2, 110);

        speedx *= -1;
        speedy *= 1;
    }

    //force from square
    //node.position = self.imageSquare.position;

    //reset speed
    [node.physicsBody setVelocity:CGVectorMake(0,0)];


    //random direction
    if(direction == ePowerupPositionNone)
    {
        random = arc4random_uniform(2);
        if(random == 0)
            speedx *= -1;
        random = arc4random_uniform(2);
        if(random == 0)
            speedy *= -1;
    }


    Log(@"powerup speed: %.2f, %.2f", speedx, speedy);

    //action
    SKAction *actionImpulse = [SKAction applyImpulse:CGVectorMake(speedx,speedy) duration:0.1f];
    [node runAction:actionImpulse afterDelay:0.1f];

    node.xScale = tempScale;
    node.yScale = node.xScale;

    float oldScale = node.xScale;
    float newScale = node.xScale * 1.2;

    [node removeActionForKey:@"powerupAppear1"];
    [node removeActionForKey:@"powerupAppear2"];
    [node removeActionForKey:@"powerupAppear3"];

    node.zPosition = 900; //self.block.zPosition+1;

    //scale
    SKAction *fadeAction = [SKAction fadeAlphaTo:1.0 duration:0.3f];

    SKAction *actionfade0 = [SKAction scaleTo:newScale duration:0.2f];//in
    SKAction *actionfade1 = [SKAction waitForDuration:0.1f];
    SKAction *actionfade2 = [SKAction scaleTo:oldScale duration:0.2f];//out
    SKAction * fadeSequence = [SKAction sequence:@[/*fadeAction,*/actionfade0,actionfade1,actionfade2]];
    [node runAction:fadeAction];
    [node runAction:[SKAction repeatActionForever:fadeSequence] withKey:@"powerupAppear1"];


    //frames
    SKAction *tempAnim = nil;


    switch(which)
    {
        case kPowerUpTypeStar:
        {

            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_star"],
                                                                 [SKTexture textureWithImageNamed:@"power_up_star2"]]
                                                  timePerFrame:0.1f];
        }
        break;

		case kPowerUpTypeBomb:
        {

            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_bomb"],
                                                                 [SKTexture textureWithImageNamed:@"power_up_bomb2"]]
                                                  timePerFrame:0.1f];
        }
        break;

        case kPowerUpTypeHeart:
        {

            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_heart"],
                                                       [SKTexture textureWithImageNamed:@"power_up_heart2"]]
                                        timePerFrame:0.1f];
        }
        break;

        case kPowerUpTypePotion:
        {
            //no anim, blue?
            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_potion"],
                                                       [SKTexture textureWithImageNamed:@"power_up_potion2"]]
                                        timePerFrame:0.1f];
        }
        break;

        case kPowerUpTypeShield:
        {

            //no anim, blue?
            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_shield"],
                                                       [SKTexture textureWithImageNamed:@"power_up_shield"]]
                                        timePerFrame:0.1f];
        }
            break;

        case kPowerUpTypeGrow:
        {

            //no anim, blue?
            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_grow"],
                                                       [SKTexture textureWithImageNamed:@"power_up_grow2"]]
                                        timePerFrame:0.1f];
        }
            break;
        case kPowerUpTypeShrink:
        {

            //no anim, blue?
            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_shrink"],
                                                       [SKTexture textureWithImageNamed:@"power_up_shrink"]]
                                        timePerFrame:0.1f];
        }
            break;

        case kPowerUpTypeInk:
        {

            //no anim, blue?
            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_ink"],
                                                       [SKTexture textureWithImageNamed:@"power_up_ink"]]
                                        timePerFrame:0.1f];
        }
            break;

        case kPowerUpTypeDoubler:
        {

            //no anim, blue?
            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_doubler"],
                                                       [SKTexture textureWithImageNamed:@"power_up_doubler2"]]
                                        timePerFrame:0.1f];
        }
            break;
        case kPowerUpTypeAuto:
        {

            //no anim, blue?
            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_auto"],
                                                       [SKTexture textureWithImageNamed:@"power_up_auto2"]]
                                        timePerFrame:0.1f];

            //rotate
            SKAction *oneRevolution = [SKAction rotateByAngle:-M_PI*2 duration: 1];
            SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
            [node runAction:repeat];

        }
            break;
        case kPowerUpTypeWeak:
        {

            //no anim, blue?
            tempAnim = [SKAction animateWithTextures:@[[SKTexture textureWithImageNamed:@"power_up_weak"],
                                                       [SKTexture textureWithImageNamed:@"power_up_weak2"]]
                                        timePerFrame:0.1f];
        }
            break;

        default:
            if([kHelpers isDebug])
                assert(0);
            break;
    }


    [node runAction:[SKAction repeatActionForever:tempAnim] withKey:@"powerupAppear3"];


    float interval = kHidePowerupDelay;
    //if(force)
     //   interval = kHidePowerupDelayLong;

    //hide after timeout
    SKAction *actionBlockHide = [SKAction runBlock:^{

        //sound?
       // [self playSound:self.soundGasp];

        //[self playSound:self.soundWrong];

        [self hidePowerup];
    }];
    [self runAction:actionBlockHide afterDelay:kHidePowerupDelay];

    //auto touch negative
    if(negative)
    {
        SKAction *actionNegative = [SKAction runBlock:^{
            [self touchedPowerup:(SKSpriteNode*)node];
        }];
        [self runAction:actionNegative afterDelay:0.3f];
    }

    //flash before timeout
    SKAction *actionFlash1 = [SKAction fadeAlphaTo:0.0f duration:0.2f];
    SKAction *actionFlash2 = [SKAction fadeAlphaTo:1.0f duration:0.2f];
    SKAction *actionFlashSound = [SKAction runBlock:^{
        //[self playSound:self.soundClock];
    }];
    SKAction *actionFlash3 = [SKAction sequence:@[actionFlash1, actionFlash2]];
    SKAction *actionFlash4 = [SKAction repeatActionForever:actionFlash3];
    SKAction *actionFlashGroup = [SKAction group:@[actionFlash4,actionFlashSound]];

    [node runAction:actionFlashGroup afterDelay: (interval - kStartFlashPowerUpDelay)];

    [kAppDelegate.gameController showFlash:kFlashColorWhite2];


    //ticks instead
    self.lastPowerupDateCount = interval * 1000; //milliseconds


    //show touch anim
    [self showTouchAnim:(SKSpriteNode*)node];

    //remember last
	kAppDelegate.lastPowerup = which;

	//disable for short timeout
    [node enable:NO];

	//re-enable after delay
    SKAction* enable = [SKAction runBlock:^{
        [node enable:YES];

    }];
    [node runAction:enable afterDelay:0.3f];

	//plus
	/*if(kAppDelegate.level > 1)
	{
		//plus
		[self showNavPlus];
	}*/

    return (SKSpriteNode*)node;
}

-(void)hidePowerup {

    //disabled
    //return;

    if(kAppDelegate.powerupVisibleType == kPowerUpTypeNone)
        return;

    [self.soundClock stop];

    //PowerupType which = kAppDelegate.powerupVisibleType;
    kAppDelegate.powerupVisibleType = kPowerUpTypeNone;

    self.lastPowerupDate = [NSDate date];

    for(SKNode *node in self.powerupArray) {

        //validate
        if(!node) {
            return;
        }

        [node removeActionForKey:@"powerupAppear1"];
        [node removeActionForKey:@"powerupAppear2"];
        [node removeActionForKey:@"powerupAppear3"];

        SKAction *fadeAction = [SKAction fadeOutWithDuration:0.3f];

        [node runAction:fadeAction completion:^{
            node.hidden = YES;

            //speed
            [node.physicsBody setVelocity:CGVectorMake(0,0)];
        }];
    }

}

-(void)showExplosion:(SKNode*)node
{
    assert(node);
    if(!node)
        return;

    SKNode *tempExplosion = [SKSpriteNode spriteNodeWithImageNamed:@"explosion1Frame1"];
    tempExplosion.name = @"tempExplosion_ignore";
    tempExplosion.zPosition = node.zPosition + 1; //on top
    tempExplosion.position = node.position;
    tempExplosion.alpha = 1.0f;
    tempExplosion.scale = 0.25f;


    float animRate = 0.01f; //0.1f;
    float baseScale = 0.9f + (arc4random_uniform(6)/10.0f); //0.8-1.4, reg 1.3
    float alpha = 1.0f - (arc4random_uniform(5)/10.0f); //0.5-1.0
    int fireworksID = 1;

    tempExplosion.alpha = alpha;

    //regular
    SKAction *explosionAnim = [SKAction animateWithTextures:@[
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame1", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame2", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame3", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame4", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame5", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame6", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame7", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame8", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame9", fireworksID]]]
                                               timePerFrame:animRate];

    //gray
    SKAction *explosionGrayAnim = [SKAction animateWithTextures:@[
                                                                  [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame1", fireworksID]]]],
                                                                  [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame2", fireworksID]]]],
                                                                  [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame3", fireworksID]]]],
                                                                  [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame4", fireworksID]]]],
                                                                  [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame5", fireworksID]]]],
                                                                  [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame6", fireworksID]]]],
                                                                  [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame7", fireworksID]]]],
                                                                  [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame8", fireworksID]]]],
                                                                  [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame9", fireworksID]]]]]
                                                   timePerFrame:animRate];


    [self addChild:tempExplosion];


    //random color
    SKAction *explosionAnimRandom = nil;

    if([kHelpers randomBool]) {
        explosionAnimRandom = explosionAnim;
    }
    else {
        explosionAnimRandom = explosionGrayAnim;
    }

    tempExplosion.alpha = 0.0f; //alpha
    tempExplosion.scale = baseScale;

    SKAction *fade = [SKAction fadeInWithDuration:0.0f];
    SKAction *wait = [SKAction waitForDuration:0.0f + (arc4random_uniform(3)/10.0f)];
    SKAction *sequence = [SKAction sequence:@[wait, fade, explosionAnimRandom]];
    [tempExplosion runAction:sequence completion:^{
        [tempExplosion removeFromParent];
    }];


}

-(void)showWinExplosion {

    //explosion
    float animRate = 0.1f;
    float randomScaleMult = 1.0f;
    float max = 200; //100;
    float min = -max/2; //-50;
    float baseScale = 0.9f + (arc4random_uniform(6)/10.0f); //0.8-1.4, reg 1.3
    float alpha = 1.0f - (arc4random_uniform(5)/10.0f); //0.5-1.0
    int fireworksID = 1;

    //regular
    SKAction *explosionAnim = [SKAction animateWithTextures:@[
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame1", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame2", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame3", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame4", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame5", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame6", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame7", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame8", fireworksID]],
                                                     [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"explosion%dFrame9", fireworksID]]]
                                      timePerFrame:animRate];

    //gray
    SKAction *explosionGrayAnim = [SKAction animateWithTextures:@[
                                                        [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame1", fireworksID]]]],
                                                     [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame2", fireworksID]]]],
                                                     [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame3", fireworksID]]]],
                                                     [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame4", fireworksID]]]],
                                                     [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame5", fireworksID]]]],
                                                     [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame6", fireworksID]]]],
                                                     [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame7", fireworksID]]]],
                                                     [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame8", fireworksID]]]],
                                                     [SKTexture textureWithImage:[kHelpers getGrayImage:[UIImage imageNamed:[NSString stringWithFormat:@"explosion%dFrame9", fireworksID]]]]]
                                      timePerFrame:animRate];

    //long sound
    [self playSound:self.soundExplosion2];

    //sound boss hit
    [self playSound:self.soundBossDie];

    SKAction *actionSound = [SKAction runBlock:^{
        //short sound
        //[self playSound:self.soundExplosion1];
    }];

    SKAction *fadeOut = [SKAction fadeOutWithDuration:0.1f];
    SKAction *resetAlpha = [SKAction fadeAlphaTo:alpha duration:0.0f];

    //explosions
    float delay = 0.2f;
    float wait = 0.0f;

    for(int i=0;i<kNumBlockExplosions;i++) {

        int randomOdds =  arc4random_uniform(100);

        SKNode *tempExplosion = [self.explosionsArray objectAtIndex:i];

        //assert(tempExplosion);
        [tempExplosion removeAllActions];

        tempExplosion.alpha = 0.0f;
        randomScaleMult = 1 + arc4random_uniform(5)/10.0f;
        tempExplosion.scale = baseScale * randomScaleMult;

        //random color
        SKAction *explosionAnimRandom = nil;

        if(randomOdds >= 50) {
            explosionAnimRandom = explosionAnim;
        }
        else {
            explosionAnimRandom = explosionGrayAnim;
        }

        //random
        float randomX =  min + arc4random_uniform(max);
        float randomY =  min + arc4random_uniform(max);
        CGPoint position = CGPointMake(randomX, randomY);
        tempExplosion.position = position;
        SKAction *fireworksWait = [SKAction waitForDuration:wait];
        SKAction *fireworksSequence = [SKAction sequence:@[fireworksWait, resetAlpha, actionSound, explosionAnimRandom, fadeOut]];

        SKAction *shakeAction = [SKAction runBlock:^{
            //[self shake];
        }];

        SKAction *shakeSequence = [SKAction sequence:@[fireworksWait, shakeAction]];
        [self runAction:shakeSequence];

        [tempExplosion removeActionForKey:@"explosionFrames"];
        [tempExplosion runAction:fireworksSequence withKey:@"explosionFrames"];

        wait+=delay;
    }


    //star explosion

    if(YES) {
        SKAction *flash = [SKAction runBlock:^{
            [self showExplosionFlash:self.block];

            [self shake];

        }];

        //CGFloat delay = 1.5f;
        CGFloat delay = 2.5f;

        [self runAction:flash afterDelay:delay];
    }

    //particles

    //particle 1
    /*randomX =  min + arc4random_uniform(max);
    randomY =  min + arc4random_uniform(max);
    position = CGPointMake(self.block.position.x + randomX, self.block.position.y + randomY);
    SKEmitterNode *myParticle = [SKEmitterNode emitterWithResourceNamed:@"smoke2"];
     assert(myParticle);
    myParticle.zPosition = self.explosion1.zPosition;
    myParticle.name = @"smoke_ignore";
    myParticle.numParticlesToEmit = 20;
    myParticle.position = position;
    //[self addChild:myParticle];
    //delete
    [myParticle runAction:[SKAction removeFromParent] afterDelay:kParticleAutoDelete];*/


    //door, mario 3
#if 0
    //https://www.youtube.com/watch?v=lsrQYVanGO0
    NSArray *colorArray = @[ [UIColor colorWithHex:0xFFFFFF], //white
                            [UIColor colorWithHex:0xb8e5f5], //blue white
                            [UIColor colorWithHex:0x6dc0f8], //blue
                            [UIColor colorWithHex:0xe9826f], //pink
                            [UIColor colorWithHex:0x6ae34a], //green
                            ];

    [self.door removeAllActions];
    self.door.alpha = 0.0f;

    NSMutableArray *colorActionArray = [NSMutableArray array];
    SKAction *colorWaitAction = [SKAction waitForDuration:0.1f];

    for(UIColor *color in colorArray) {
        SKAction *colorize = [SKAction colorizeWithColor:color colorBlendFactor:1.0f duration:0.0f];
        [colorActionArray addObject:colorize];
        [colorActionArray addObject:colorWaitAction];
    }
    SKAction *sequence = [SKAction sequence:colorActionArray];
    [self.door runAction:[SKAction repeatActionForever:sequence]];
#endif
}

-(void)showFireworks {

    //disabled
    return;
#if 0
    CGPoint particlePosition = CGPointMake(self.block.position.x, self.block.position.y);

    //sound
    [self playSound:self.soundWhistle];

    //fireworks
    float fireworksAnimRate = fireWorksSpeed;

    self.fireworks1.position = particlePosition;
    self.fireworks1.zPosition = 1000; //self.barFill.zPosition+1;
    self.fireworks1.alpha = 1.0f;
    self.fireworks1.scale = 0.1f;


    int fireworksID = 1 + arc4random_uniform(3);
    self.fireworks1.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame1", fireworksID]];
    SKAction *fireworksAnim = [SKAction animateWithTextures:@[
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame1", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame2", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame3", fireworksID]],
                                                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame4", fireworksID]]]
                                               timePerFrame:fireworksAnimRate];


    SKAction *fireworksWait = [SKAction waitForDuration:0.0f];
    SKAction *fireworksFadeOut = [SKAction fadeOutWithDuration:0.3f];
    SKAction *fireworksSequence = [SKAction sequence:@[fireworksWait, fireworksAnim, fireworksFadeOut]];


    [self.fireworks1 removeActionForKey:@"fireworksFrames"];
    [self.fireworks1 runAction:fireworksSequence withKey:@"fireworksFrames"];

#endif
}

-(void)hideExplosions {
    //Log(@"hideExplosions");
}

-(void)hideCoins {
	[self removeChildrenNamed:@"coinFall"];
}

-(void)showSpike:(BOOL)show
{
    [self showSpike:show fast:NO];
}

-(void)showSpike:(BOOL)show fast:(BOOL)fast
{
    //Log(@"showSpike: %d", show);

    if(kAppDelegate.noEnemies)
        return;

    if(self.winning || self.dying)
        return;

    if(kAppDelegate.gameController.showingKTPlay)
        return;

    if(self.flashFireballFlag && show)
        return;

    //not same time as lava
    if(!self.lava.hidden && show)
        return;

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return;

    //if(kAppDelegate.subLevel != 4)
    //    return;

    //if(kAppDelegate.subLevel == 1)
     //   return;

    if(kAppDelegate.level <= 3)
        return;

    //already visible
    if(!self.spike.hidden && self.spike.alpha >= 0  && show) {
        [self updateNumFireballLabel:NO];
        return;
    }

	//invincible
	if(kAppDelegate.currentBuff == kBuffTypeStar) {
       return;
    }

    [self.spike removeAllActions];

    BOOL flash = NO;
    BOOL bigger = NO;

    NSString *spikeName = nil;
    if(show) {

        NSArray *spikeArray = [CBSkinManager getSpikeArrayWithLevel:(int)(kAppDelegate.level) all:NO];
        spikeName = [spikeArray randomObject];

        //force
        if([kHelpers isDebug])
        {
            //spikeName = @"spike11"; //chain
        }

        assert(spikeName);

        //special features
        if([spikeName isEqualToString:@"spike4"] || [spikeName isEqualToString:@"spike10"])
        {
            flash = YES;
        }
        if([spikeName isEqualToString:@"spike8"])
        {
            bigger = YES;
        }


        self.spike.texture = [SKTexture textureWithImageNamed:spikeName];
        self.spike.xScale = self.spike.yScale = 1.4f;
        self.spike.alpha = 1.0;
        self.spike.hidden = NO;
        self.spike.name = spikeName;
    }

    if(show)
        [self updateNumFireballLabel:YES];

    float durationIn = 1.0f;
    //float durationOut = 1.5f;
    float durationPause = 2.0f;

    if([spikeName isEqualToString:@"spike4"] || [spikeName isEqualToString:@"spike10"] || [spikeName isEqualToString:@"spike3"])
    {
        //shorter, faster
        durationPause = 1.0f;
        durationIn = 0.5f;
    }

    float spikeTip = 36;
    CGPoint smokePosition = CGPointMake(0.0f, 0.0f);

    float width = MAX(self.spike.size.width, self.spike.size.height);
    float widthMove = width;

    float distanceX = 0;
    float distanceY = 0;

    int min = 0;
    int max = 4;


    //if hide reuse
    if(show)
        self.spikePosition =  min + arc4random_uniform(max);

    if([kHelpers isDebug])
    {
        //force top
        //self.spikePosition  = 2;
    }

    if(bigger)
    {
        self.xScale =  self.yScale = 2.4f; //1.4f
        widthMove *= 1.2f;
    }
    //force
    //random = 3;
    int particleOffset = 5;

    //random offset
    float randomOffsetVal = 100;
    float randomOffset = -randomOffsetVal + arc4random_uniform(randomOffsetVal*2);
    if((int)kAppDelegate.level <= 2)
    {
        randomOffset = 0; //not spike offset early
    }



    //flip
    BOOL flipX = NO;
    BOOL flipY = NO;

    {
        //move
        if(self.spikePosition == 0) {
            //from left

            //shorter
            widthMove -= widthMove/3;

            distanceX = widthMove-spikeTip*2;
            distanceY = 0;
            if(show) {
                self.spike.zRotation = RADIANS(90); //90
                self.spike.position = CGPointMake(-width/2, self.block.position.y + randomOffset);
            }

            smokePosition = CGPointMake(0+particleOffset, self.spike.position.y);

            //flip
            if([spikeName contains:@"spike9"])
            {
                //flip = YES;
            }
        }
        else if (self.spikePosition == 1) {

            //from right

            //shorter
            widthMove -= widthMove/3;

            distanceX = -(widthMove-spikeTip*2);
            distanceY = 0;
            if(show) {
                self.spike.zRotation = RADIANS(270); //270
                self.spike.position = CGPointMake(self.frame.size.width + width/2, self.block.position.y + randomOffset);
            }
            smokePosition = CGPointMake(self.frame.size.width-particleOffset, self.spike.position.y);

            //flip
            if([spikeName contains:@"spike9"])
            {
                flipX = YES;
            }
        }
        else if (self.spikePosition == 2) {
            //from top

            //shorter
            widthMove -= widthMove/8;

            distanceX = 0;
            distanceY = -(widthMove-spikeTip);
            if([kHelpers isIphoneX])
            {
                distanceY -= 60;
            }

            if(show) {
                self.spike.zRotation = RADIANS(0); //180
                self.spike.position = CGPointMake(self.block.position.x + randomOffset, self.frame.size.height + width/2);
            }
            smokePosition = CGPointMake(self.spike.position.x, self.frame.size.height-particleOffset*2);

            //flip
            if([spikeName contains:@"spike9"])
            {
                flipX = YES;
            }

        }
        else if (self.spikePosition == 3) {

            //from bottom

            //shorter
            //widthMove -= 20;
            widthMove -= widthMove/8;

            distanceX = 0;
            distanceY = (widthMove-spikeTip);
            if([kHelpers isIphoneX])
            {
                distanceY += 40;
            }

            if(show) {
                self.spike.zRotation = RADIANS(180); //0
                self.spike.position = CGPointMake(self.block.position.x + randomOffset, -width/2);
            }

            //if(!kAppDelegate.gameController bannerAvailable)
                smokePosition = CGPointMake(self.spike.position.x, particleOffset);
            //else
            //    smokePosition = CGPointMake(self.spike.position.x, particleOffset + kAppDelegate.gameController.bannerView.height); //offset
        }



    }

    //flip
    if(flipX)
    {
        self.spike.xScale = -self.spike.xScale;
    }
    if(flipY)
    {
        self.spike.yScale = -self.spike.yScale;
    }


    //flash
    //[kAppDelegate.gameController showFlash:kFlashColorRed];

    SKAction *actionMove1 = [SKAction moveByX:distanceX y:distanceY duration:durationIn];
    actionMove1.timingMode = SKActionTimingEaseIn;

    SKAction *actionMove2 = [SKAction moveByX:-distanceX y:-distanceY duration: fast?0.3f:durationIn];
    actionMove2.timingMode = SKActionTimingEaseIn;

    SKAction *actionSmoke = [SKAction runBlock:^{
        //smoke particles
        if( ![kHelpers isSlowDevice]) {
            //particle
            SKEmitterNode *myParticle = [SKEmitterNode emitterWithResourceNamed:@"smoke2"];
            assert(myParticle);
            myParticle.zPosition = self.spike.zPosition+1;
            myParticle.name = @"smoke_4_ignore";
            myParticle.numParticlesToEmit = 20;
            myParticle.position = smokePosition;
            [self removeChildrenNamed:myParticle.name];
            if(kEnableEmiters)
                [self addChild:myParticle];
            //delete
            [myParticle runAction:[SKAction removeFromParent] afterDelay:kParticleAutoDelete];

            //down
            SKEmitterNode *myParticle2 = [SKEmitterNode emitterWithResourceNamed:@"smoke2_inv"];
            assert(myParticle);
            myParticle2.zPosition = self.spike.zPosition+1;
            myParticle2.name = @"smoke_5_ignore";
            myParticle2.numParticlesToEmit = 20;
            myParticle2.position = smokePosition;
            [self removeChildrenNamed:myParticle2.name];
            if(kEnableEmiters)
                [self addChild:myParticle2 ];
            //delete
            [myParticle2 runAction:[SKAction removeFromParent] afterDelay:kParticleAutoDelete];
        }

    }];

    //sound
    //[self playSound:self.soundSpikeAppear];
    //SKAction *actionSound = [SKAction playSoundFileNamed:@"spikeAppear.caf" waitForCompletion:nil];
    SKAction *actionSound = [SKAction runBlock:^{
        if(!self.winning && !self.dying)
        {
            if([spikeName isEqualToString:@"spike4"] || [spikeName contains:@"spike9"])
            {
                //mega man or pipe or gradius
                [self playSound:self.soundSpikeAppearMega];
            }
            else if([spikeName isEqualToString:@"spike10"])
            {
                //gradius
                [self playSound:self.soundSpikeAppearGradius];
            }
            else if([spikeName isEqualToString:@"spike7"])
            {
                //sword
                [self playSound:self.soundSpikeAppearSword];
            }
            else if([spikeName isEqualToString:@"spike11"])
            {
                //sonic
                [self playSound:self.soundSpikeAppearChain];
            }
            else
            {
                //same sound for others
                [self playSound:self.soundSpikeAppear];
            }

            if([kAppDelegate getSkin] == kCoinTypePew) {
                [self playSound:self.soundSpikeAppearPew];
            }

        }
    }];

    //back, hide
    SKAction *actionSound2 = [SKAction runBlock:^{
        if(!self.winning && !self.dying)
        {
            if([spikeName isEqualToString:@"spike4"] || [spikeName contains:@"spike9"])
            {
                //mega man or spike
                [self playSound:self.soundSpikeAppear2Mega];
            }
            else if([spikeName isEqualToString:@"spike10"] )
            {
                //gradius
                //[self playSound:self.soundSpikeAppearGradius];
            }

            else if([spikeName isEqualToString:@"spike7"])
            {
                //sword
                [self playSound:self.soundSpikeAppearSword];
            }
            else if([spikeName isEqualToString:@"spike11"])
            {
                //sonic
                [self playSound:self.soundSpikeAppearChain];
            }
            else
            {
                //same sound for others
                [self playSound:self.soundSpikeAppear];

            }

            if([kAppDelegate getSkin] == kCoinTypePew) {
                [self playSound:self.soundSpikeAppearPew];
            }

        }
    }];


    SKAction *actionWaitBefore = [SKAction waitForDuration:1.0f];
    SKAction *actionWaitBetween = [SKAction waitForDuration:durationPause];

    actionMove1 = [SKAction group:@[actionMove1, actionSound, actionSmoke]];
    actionMove2 = [SKAction group:@[actionMove2, actionSound2, actionSmoke]];

    SKAction *sequence = nil;
    if(show)
        sequence = [SKAction sequence:@[actionWaitBefore, actionMove1, actionWaitBetween, actionMove2]];
    else
        sequence = [SKAction sequence:@[actionMove2]];

    [self.spike runAction:sequence completion:^{

        [self.spike runAction:[SKAction fadeOutWithDuration:0.3f] completion:^{
            self.spike.hidden = YES;

            [self updateNumFireballLabel:YES];
         }];
    }];

    //smoke now
    [self.spike runAction:actionSmoke];

    //flash spike4
    if(flash)
    {
        //flash alpha
        //SKAction *actionFlash1 = [SKAction fadeAlphaTo:0.5f duration:0.2f];
        //SKAction *actionFlash2 = [SKAction fadeAlphaTo:1.0f duration:0.2f];
        //SKAction *actionFlash = [SKAction sequence:@[actionFlash1, actionFlash2]];
        //[self.spike runAction:[SKAction repeatActionForever:actionFlash]];

        //animate
        SKAction *wait = [SKAction waitForDuration:0.1f];
        SKAction *actionFlash1 = [SKAction setTexture:[SKTexture textureWithImageNamed:spikeName]];
        SKAction *actionFlash2 = [SKAction setTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@_2", spikeName]]];
        SKAction *actionFlash = [SKAction sequence:@[actionFlash1, wait, actionFlash2, wait]];
        [self.spike runAction:[SKAction repeatActionForever:actionFlash]];
    }

    //arrow warning
    [self.redArrow removeAllActions];
    self.redArrow.alpha = 1.0f;

    float scale = 1.4f; //1.0f;

    if(self.spikePosition == 0) {
        //from left
        self.redArrow.position = CGPointMake(20 , self.spike.position.y); //cancel out offset
        self.redArrow.xScale = scale;
        self.redArrow.yScale = scale;
        self.redArrow.zRotation = RADIANS(0);
    }
    else if(self.spikePosition == 1) {
        //from right
        self.redArrow.position = CGPointMake(self.frame.size.width - 20, self.spike.position.y);
        self.redArrow.xScale = -scale;
        self.redArrow.yScale = scale;
        self.redArrow.zRotation = RADIANS(0);
    }
    else if(self.spikePosition == 2) {
        //from top
        self.redArrow.position = CGPointMake(self.spike.position.x, self.frame.size.height - 52 - [self getIPhoneXTop]);
        self.redArrow.xScale = scale;
        self.redArrow.yScale = scale;
        self.redArrow.zRotation = RADIANS(90);
    }
    else if(self.spikePosition == 3) {
        //from bottom
        int bannerOffset = [self getBannerOffset]; //18
        self.redArrow.position = CGPointMake(self.spike.position.x, bannerOffset + [self getIPhoneXBottom]);
        self.redArrow.xScale = scale;
        self.redArrow.yScale = -scale;
        self.redArrow.zRotation = RADIANS(90);
    }

    self.redArrow.zPosition = self.spike.zPosition + 100;


    //fade in/out
    SKAction *actionArrowFadeIn = [SKAction fadeInWithDuration:0.0f];
    SKAction *actionArrowFadeOut = [SKAction fadeOutWithDuration:0.0f];
    SKAction *actionArrowWait = [SKAction waitForDuration:0.1f];

    SKAction* sequenceArrow = [SKAction sequence:@[actionArrowFadeIn, actionArrowWait, actionArrowFadeOut, actionArrowWait]];
    [self.redArrow runAction:[SKAction repeatActionForever:sequenceArrow]];

    //and stop
    SKAction* actionResetRedArrow = [SKAction runBlock:^{
        [self.redArrow removeAllActions];
        [self.redArrow runAction:[SKAction fadeOutWithDuration:0.1f]];
    }];
    [self runAction:actionResetRedArrow afterDelay:1.5f];

}


-(void)hideSpike:(BOOL)animated
{
    [self hideSpike:animated fast:NO];
}

-(void)hideSpike:(BOOL)animated fast:(BOOL)fast
{
    [self.spike removeAllActions];
    [self.redArrow removeAllActions];

    if(animated) {
        if(!self.spike.hidden) {

            [self.redArrow runAction:[SKAction fadeOutWithDuration:0.1f]];

            [self showSpike:NO fast:fast];
            //[self updateNumFireballLabel:YES];
            return;


            /*[self.spike runAction:[SKAction fadeOutWithDuration:0.3f] completion:^{
                self.spike.hidden = YES;
            }];*/
        }
    }
    else {
        self.spike.alpha = 0.0f;
        self.spike.hidden = YES;
        self.redArrow.alpha = 0.0f;
    }

}

-(void)updateLevelBar:(BOOL)animate {

    if(self.winning || self.dying)
        return;

    //bar
    self.barFill.hidden = NO;

    int rewindClickCount = kAppDelegate.rewindClickCount;

    int numlast = [self get1upNumLast];
    int sinceLast = (int)kAppDelegate.clickCount - numlast;
    int total =  [self get1upNum] - numlast;
    float percent = (sinceLast / (float)total);
    //float percentRewind = ((kAppDelegate.rewindClickCount - numlast)/ (float)total);
    float percentRewind = ((rewindClickCount - numlast)/ (float)total);

    //force
    if(YES && [kHelpers isDebug]) {
       //percent = 0.5f; //0.5f
    }

    //don't have 0 width
    if(percent < 0.01f) {
        percent = 0.01f;
    }
    else if (percent > 1.0f) {
        percent = 1.0f;
    }

    //Log(@"percent: %f", percent);

    //label
    self.barLabel.text = [NSString stringWithFormat:@"%d / %d", sinceLast, total];
    //disabled
    //self.barLabel.hidden = YES;

    self.barFill.position = CGPointMake(0, self.bar.position.y);

    //reset alpha
    self.barFill.alpha = 1.0f;

    UIImage *croppedImage = [UIImage imageNamed:@"barWorldFill3"];
    CGSize oldSize = croppedImage.size;

    //int originalWidth = 260;
    int originalWidth = 260;
    int forcedOffset = 30; //30

    oldSize.width = originalWidth;

    //percent
    oldSize.width *= percent;

    oldSize.width += forcedOffset;

    oldSize.width = ceil(oldSize.width);

    croppedImage = [croppedImage cropToSize:oldSize];


    //cropped
    self.barFill.texture = [SKTexture textureWithImage:croppedImage];

    //force resize
    CGFloat barScale = self.bar.xScale;

    oldSize.width *= barScale;
    oldSize.height *= barScale;

    [self.barFill setSize:CGSizeMake(oldSize.width, oldSize.height)];

    //rewind icon
    int rewindX = self.barFill.position.x + forcedOffset + originalWidth * percentRewind;
    rewindX -= 10; //offset

    //show hide rewind
    if((rewindClickCount - numlast) > 2)
        self.barIconRewind.hidden = NO;
    else
        self.barIconRewind.hidden = YES;

    int x = self.barFill.position.x + self.barFill.size.width;
    int y = self.barFill.position.y;

    //move icon/profile
    if(animate) {
        float moveDurationStart = 0.3f;
        float moveDuration = moveDurationStart;

        //duration depends on sublevel
        //moveDuration *= kAppDelegate.subLevel;


        /*int xDiff = fabs(self.barFill.position.x - x);
        float percentageDuration = xDiff / 40.0f; //40px in 0.1s
        moveDuration *= percentageDuration;
        if(moveDuration < moveDurationStart)
            moveDuration = moveDurationStart;*/

        //[self.barIcon runAction:[SKAction moveTo:CGPointMake(x, y) duration:moveDuration]];
        [self.barIcon runAction:[SKAction moveToX:x duration:moveDuration]];
        //[self.barIconRewind runAction:[SKAction moveTo:CGPointMake(x, y) duration:moveDuration]];

        [self.barIconRewind runAction:[SKAction moveTo:CGPointMake(rewindX, y) duration:moveDuration]];



        //reset
        [self.barIcon removeActionForKey:@"fadeSequence"];
        [self.barIcon runAction:[SKAction moveToY:y duration:0]];

        //just bounce
        //int oldY = self.barFill.position.y;
        float wiggleOffset = 5;
        float wiggleTimeEach = 0.1f;
        SKAction* bounce = [
                            SKAction sequence:@[[SKAction moveByX:0 y:wiggleOffset duration:wiggleTimeEach],
                                                [SKAction moveByX:0 y:-wiggleOffset duration:wiggleTimeEach],
                                                //[SKAction moveByX:0 y:wiggleOffset duration:wiggleTimeEach],
                                                //[SKAction moveByX:0 y:wiggleOffset/2 duration:wiggleTimeEach],
                                                //[SKAction moveByX:0 y:-wiggleOffset/2 duration:wiggleTimeEach],
                                                //[SKAction waitForDuration:0.0f]
                                                ]];

        [self.barIcon runAction:bounce withKey:@"fadeSequence"];


    }
    else {
        self.barIcon.position = CGPointMake(x, y);

        self.barIconRewind.position = CGPointMake(rewindX, self.barFill.position.y);

    }


    //wobble bars
    if(percent >= kBarShakePercent && ![kHelpers isSlowDevice]) {

        //shake bar
        /*float wiggleOffset = 1.0f;
        float wiggleTimeEach = 0.1f;
        SKAction* bounce = [SKAction sequence:@[[SKAction moveByX:0 y:wiggleOffset duration:wiggleTimeEach],
                                                [SKAction moveByX:0 y:-wiggleOffset duration:wiggleTimeEach],
                                                //[SKAction moveByX:0 y:wiggleOffset/2 duration:wiggleTimeEach],
                                                //[SKAction moveByX:0 y:-wiggleOffset/2 duration:wiggleTimeEach],
                                                //[SKAction waitForDuration:0.0f]
                                                ]];
         */

        float wiggleTimeEach = 0.2f;
        SKAction* bounce = [SKAction sequence:@[[SKAction fadeAlphaTo:1.0f duration:wiggleTimeEach],
                                                [SKAction fadeAlphaTo:0.4f duration:wiggleTimeEach],
                                                ]];

        [self.barFill runAction:[SKAction repeatActionForever:bounce]];

    }
}

-(void)showLastLevelAlert {

   //if(kAppDelegate.playedLastLevel)
   //     return;

    kAppDelegate.playedLastLevel = YES;
    //[kAppDelegate saveState];

    NSString *message = @"Hero, this is the <color1>Final World</color1>.\n\nGood luck defeating <color1>Nega-Brain</color1>!";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           //
                                           [kAppDelegate playSound:kClickSound];
                                           //nothing
                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    //pause
    [self enablePause:YES];
    [kAppDelegate.gameController blurScene:YES];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];

    }];

    [kAppDelegate.alertView show:YES];

    [kAppDelegate.gameController showVCR:YES animated:YES];

}

-(void)showFirstTimeAlert {

    if(kAppDelegate.playedX4Alert)
       return;

    kAppDelegate.playedX4Alert = YES;
    //[kAppDelegate saveState];

    NSString *message = @"Almost completed this World but watch out for <color1>Enemies</color1> and <color1>Spikes</color1>!";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                             type:kAlertButtonGreen
                          handler:^(SIAlertView *alert) {
                              //
                              [kAppDelegate playSound:kClickSound];
                              //nothing


                          }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    //pause
    [self enablePause:YES];
    [kAppDelegate.gameController blurScene:YES];

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];

    }];

    [kAppDelegate.alertView show:YES];
    [kAppDelegate.gameController showVCR:YES animated:YES];
}



-(void)showShieldAlert {

    if(kAppDelegate.playedShieldAlert)
     return;

    kAppDelegate.playedShieldAlert = YES;
    //[kAppDelegate saveState];

    NSString *message = @"The <color1>Shield</color1> power-up gives you half damage from enemies for a limited time.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];
                                           //nothing
                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];
    }];

	//delay for buff animation to finish
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //pause
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        [kAppDelegate.alertView show:YES];
        [kAppDelegate.gameController showVCR:YES animated:YES];
    });

}

-(void)showAutoAlert {

    if(kAppDelegate.playedAutoAlert)
        return;

    kAppDelegate.playedAutoAlert = YES;
    //[kAppDelegate saveState];

    NSString *message = @"The <color1>Auto</color1> power-up taps the Block automatically for a limited time.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];
                                           //nothing
                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];
    }];

    //delay for buff animation to finish
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //pause
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        [kAppDelegate.alertView show:YES];
        [kAppDelegate.gameController showVCR:YES animated:YES];
    });

}

-(void)showDoublerAlert {

    if(kAppDelegate.playedDoublerAlert)
        return;

    kAppDelegate.playedDoublerAlert = YES;
    //[kAppDelegate saveState];

    NSString *message = @"The <color1>Doubler</color1> power-up gives you double coin <color1>Power</color1> multiplier for a limited time.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];
                                           //nothing
                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];
    }];

    //delay for buff animation to finish
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //pause
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        [kAppDelegate.alertView show:YES];
        [kAppDelegate.gameController showVCR:YES animated:YES];
    });

}

-(void)showGrowAlert {

    if(kAppDelegate.playedGrowAlert)
        return;

    kAppDelegate.playedGrowAlert = YES;
    //[kAppDelegate saveState];

    //NSString *message = @"The <color1>Grow</color1> power-up makes your Block huge for a limited time.";
    NSString *message = @"The <color1>Huge</color1> power-up makes your Block bigger for a limited time.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];
                                           //nothing
                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];
    }];

    //delay for buff animation to finish
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //pause
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        [kAppDelegate.alertView show:YES];
        [kAppDelegate.gameController showVCR:YES animated:YES];
    });

}

-(void)showShrinkAlert {

    if(kAppDelegate.playedShrinkAlert)
        return;

    kAppDelegate.playedShrinkAlert = YES;
    //[kAppDelegate saveState];

    //NSString *message = @"The <color1>Shrink</color1> power-up makes your Block tiny for a limited time.";
    NSString *message = @"Oops! The <color1>Tiny</color1> power-up makes your Block smaller for a limited time.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];
                                           //nothing
                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];
    }];

    //delay for buff animation to finish
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //pause
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        [kAppDelegate.alertView show:YES];
        [kAppDelegate.gameController showVCR:YES animated:YES];
    });

}

-(void)showInkAlert {

    if(kAppDelegate.playedInkAlert)
        return;

    kAppDelegate.playedInkAlert = YES;
    //[kAppDelegate saveState];

    //NSString *message = @"The <color1>Shrink</color1> power-up makes your Block tiny for a limited time.";
    NSString *message = @"Oops! The <color1>Ink</color1> power-up hides your Block for a limited time.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];
                                           //nothing
                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];
    }];

    //delay for buff animation to finish
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //pause
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        [kAppDelegate.alertView show:YES];
        [kAppDelegate.gameController showVCR:YES animated:YES];
    });

}


-(void)showWeakAlert {
    //buff
    if(kAppDelegate.playedWeakAlert)
        return;

    kAppDelegate.playedWeakAlert = YES;
    //[kAppDelegate saveState];

    NSString *message = @"The <color1>Weak Spot</color1> power-up gives you multiple Weak Spots for a limited time.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];
                                           //nothing
                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];
    }];

    //delay for buff animation to finish
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //pause
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        [kAppDelegate.alertView show:YES];
        [kAppDelegate.gameController showVCR:YES animated:YES];
    });

}


-(void)showStarAlert {

    if(kAppDelegate.playedStarAlert)
     return;

    kAppDelegate.playedStarAlert = YES;

    NSString *message = @"The <color1>Star</color1> power-up makes you invincible for a limited time.";

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringHowToPlay")
                                                     andMessage:message];

    [kAppDelegate.alertView addButtonWithTitle:LOCALIZED(@"kStringGotIt") //[CBSkinManager getRandomOKButton]
                                          type:kAlertButtonGreen
                                       handler:^(SIAlertView *alert) {
                                           [kAppDelegate playSound:kClickSound];
                                           //nothing
                                       }];

    kAppDelegate.alertView.transitionStyle = kAlertStyle;

    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
    }];

    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];
    }];

	//delay for buff animation to finish
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

        //pause
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        [kAppDelegate.alertView show:YES];
        [kAppDelegate.gameController showVCR:YES animated:YES];
    });

}

-(void)refillHeartAlert2 {
    [self hideAllFireballs:YES];

    kAppDelegate.gameController.sharing = YES;
    self.sharing = YES;

    int numHeartsBefore = (int)kAppDelegate.numHearts;
    kAppDelegate.numHearts = kHeartFull;
    [self setNumHearts:(int)kAppDelegate.numHearts];

    [self checkHeartTimer];

    //heart refill sound, if needed
    if(numHeartsBefore < kAppDelegate.numHearts)
        [self playSound:self.soundRefill];

    //credit coin
    //[kAppDelegate playSound:@"credit1.caf"];

    //un-rewind
    //kAppDelegate.clickCount = self.beforeRewindClickCount;

    //star click
    //[self playSound:self.soundStarAppear];
    //[self playSound:self.soundStarClick2];

    //[kAppDelegate saveState];

    //check music/bg?
    [self updateLevelLabel:YES];
    [self updateLevelBar:YES];
    [self updateCountLabel:YES];

    //curtains, zelda

    SKAction *actionResetSharing = [SKAction runBlock:^{
        [kAppDelegate.gameController openCurtains];

        kAppDelegate.gameController.sharing = NO;
        self.sharing = NO;
    }];
    [self runAction:actionResetSharing afterDelay:1.0f];
}

-(void)refillPotionsAlert {

    __weak typeof(self) weakSelf = self;

    //sounds
    [self.soundClock stop];

    //BOOL premium = [kAppDelegate isPremium];

    //offline
    if(![kHelpers checkOnline] /*&& !premium*/) {

        NSString *message = @"Potions are not available offline.";

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

        kAppDelegate.alertView.transitionStyle = kAlertStyle;


        [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
            //back
            [kAppDelegate.gameController actionBack:nil];

        }];

        //close, unpause
        [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
            //kAppDelegate.gameController.paused = NO;
            //self.paused = NO;
            [self enablePause:NO];
            [kAppDelegate.gameController blurScene:NO];

            [kAppDelegate.gameController showVCR:NO animated:YES];

        }];


        //delayed
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self enablePause:YES];
            [kAppDelegate.gameController blurScene:YES];

            [kAppDelegate.alertView show:YES];
            [kAppDelegate.gameController showVCR:YES animated:YES];

        });


        return;
    }

    //not full hearts OR empty bottles
    if((kAppDelegate.numHearts >= kHeartFull) && (kAppDelegate.numPotions > 0))
        return;

    NSString *message =  nil;

    /*if(premium)
    {
        message = @"Get a <color1>potion</color1> instantly for free?\n(<color1>Thanks VIP!</color1>!)\n";
    }
    else*/
    {
        message = [NSString stringWithFormat:@"Get %d <color1>potion%@</color1> for free by watching a short video?", kPotionReward, (kPotionReward>1)?@"s":@""];
    }

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringRefillPotions") //"Refill"
                                                         andMessage:message];


    //if(!premium)
    if(YES)
        [kAppDelegate.alertView addButtonWithTitle:
         LOCALIZED(@"kStringWatchAd")
                                              type:kAlertButtonGreen
                                           handler:^(SIAlertView *alert) {

                                               [kAppDelegate playSound:kClickSound];

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

                                               //[kHelpers showMessageHud:@""];

                                               //force
                                               weakSelf.lastClickDate = [NSDate date];

                                               float secs = 1.0f;
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                                   //video
                                                   if([kAppDelegate hasRewardedVideo:kRewardRefillPotions]) {

                                                       [kAppDelegate stopMusic];

                                                       [kAppDelegate showRewardedVideo:kRewardRefillPotions];
                                                   }
                                                   else {
                                                       [kHelpers dismissHud];

                                                       [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorNoVideo")];

                                                       //un-pause
                                                       [self enablePause:NO];
                                                       [kAppDelegate.gameController blurScene:NO];
                                                       [kAppDelegate.gameController showVCR:NO animated:YES];
                                                   }


                                               });

                                               //after delay, in case
                                               secs = 5.0f;
                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [kHelpers dismissHud];
                                               });

                                           }];

#if 0
    if(premium)
        [kAppDelegate.alertView addButtonWithTitle:
         LOCALIZED(@"kStringContinue") //[CBSkinManager getRandomOKButton]
                                              type:kAlertButtonGreen
                                           handler:^(SIAlertView *alert) {
                                               //
                                               [kAppDelegate playSound:kClickSound];
                                               //nothing

                                               //force
                                               weakSelf.lastClickDate = [NSDate date];

                                               //refill
                                               [self refillPotionsAlert2];
                                           }];
#endif

    //close x
    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {
        //nothing
        [self enablePause:NO];

        [kAppDelegate.gameController blurScene:NO];
        [kAppDelegate.gameController showVCR:NO animated:YES];

    }];

    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical

    kAppDelegate.alertView.transitionStyle = kAlertStyle;


    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
            //nothing

    }];

    //delayed
    //pause
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        [kAppDelegate.alertView show:YES];
        [kAppDelegate.gameController showVCR:YES animated:YES];
    });

}

-(void)rewardPowerup
{
    //hide banner
    [self hideBanner];

    kAppDelegate.gameController.sharing = YES;
    self.sharing = YES;

    [self hideImageSquare:YES];
    [self showImageSquare:YES];

    SKAction *actionResetSharing = [SKAction runBlock:^{
        //[kAppDelegate.gameController openCurtains];

        kAppDelegate.gameController.sharing = NO;
        self.sharing = NO;
    }];
    [self runAction:actionResetSharing afterDelay:1.0f];
}

-(void)refillPotionsAlert2 {

    //hide banner
    [self hideBanner];

    //un-pause
    [self enablePause:NO];
    [kAppDelegate.gameController blurScene:NO];
    [kAppDelegate.gameController showVCR:NO animated:YES];

    [self playSound:self.soundPotion2]; //glass

    kAppDelegate.numPotions += kPotionReward;
    if(kAppDelegate.numPotions > kMaxPotions)
        kAppDelegate.numPotions = kMaxPotions;

    [self updatePotion:YES];

    [kAppDelegate saveState];
}

-(void)refillHeartAlert:(BOOL)rewind {

    __weak typeof(self) weakSelf = self;

    self.dying = YES;
	  kAppDelegate.fromDie = YES;


    //inc death
    kAppDelegate.deathCount++;

    [kAppDelegate dbIncDie];

    [self hidePowerup];

    [kAppDelegate saveState];

    //curtains, with delay
    CGFloat alertDelay = 0.5f;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, alertDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if(rewind) {
            [kAppDelegate.gameController closeCurtains];
        }
    });

    //sounds
    [self.soundClock stop];

    if(rewind)
    {
		//achievement
		[kAppDelegate reportAchievement:kAchievement_die];

        if([kAppDelegate getSkin] == kCoinTypePew)
        {

            [kAppDelegate playMusic:@"musicRoundabout.mp3" andRemember:NO looping:YES];
        }
        else
        {
            [kAppDelegate playMusic:kMusicNameSad andRemember:NO looping:NO];
        }


        if(kAppDelegate.level == kLevelMax || [kAppDelegate getSkin] == kCoinTypeBrain)
        {
            //sound, a bit later
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                //if(!kAppDelegate.inReview)
                if(NO)
                {
                    NSString* soundName = [@[
                                             @"sinistar1.caf", //beware i live
                                             @"sinistar2.caf", //run
                                             //@"sinistar3.caf", //rarrrrrr
                                             @"sinistar4.caf", //i hunger
                                             ] randomObject];

                    [kAppDelegate playSound:soundName];
                }
            });

        }

    }

    //BOOL premium = [kAppDelegate isPremium];

    if(kAppDelegate.numHearts >= kHeartFull)
        return;

    NSString *message =  nil;

    if(rewind)
    {

        if(![kHelpers checkOnline])
        {
            //offline
            message = @"Out of hearts!\nBut Continue is not available <color1>offline</color1>.\n\n<color1>Give up</color1> and <color1>Restart</color1> the current World.";
        }
        else
        {
            message = @"Out of hearts! <color1>Continue</color1> for free by watching a short video?\n\nOr <color1>Give up</color1> and <color1>Restart</color1> the current World." ;
        }
    }
    else
    {

        /*if(premium)
        {
            message = @"Refill your hearts instantly for free?\n(<color1>Thanks VIP!</color1>!)\n";
        }
        else*/
        {
            message = @"Refill your hearts for free by watching a short video?";
        }

    }

    //sound
    //if(rewind)
    //    [self.soundDeath play];

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    if(rewind)
        kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringGameOver") //"Refill"
                                                     andMessage:message];

    else
        kAppDelegate.alertView = [[SIAlertView alloc] initWithTitle:LOCALIZED(@"kStringRefill") //"Refill"
                                                         andMessage:message];



    if(rewind) {
        [kAppDelegate.alertView addButtonWithTitle:
         LOCALIZED(@"kStringRestartButton")
                                      type:kAlertButtonOrange
                                   handler:^(SIAlertView *alert) {

                                       kAppDelegate.fromDie = YES;

                                       [kAppDelegate playSound:kClickSound];

                                       if(rewind) {

                                           [self rewind];
                                       }
                                   }];

    }


    //if(!premium)
	//if(YES)
    if ([kHelpers checkOnline]) //only if online
        [kAppDelegate.alertView addButtonWithTitle:
                        LOCALIZED(@"kStringWatchAd")
                             type:kAlertButtonGreen
                          handler:^(SIAlertView *alert) {
                              //
                              [kAppDelegate playSound:kClickSound];
                              //nothing

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

                              //[kHelpers showMessageHud:@""];

                              //no ad when refill
                              kAppDelegate.fromDie = NO;

                              //force
                              weakSelf.lastClickDate = [NSDate date];

                              float secs = 1.0f;
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                                  //video
                                  if([kAppDelegate hasRewardedVideo:kRewardRefill]) {
                                      //self.sharing = YES;
                                      BOOL hasReward = [kAppDelegate showRewardedVideo:kRewardRefill];

                                      if(!hasReward)
                                      {
                                          Log(@"no reward");
                                      }
                                  }
                                  else {
                                      [kHelpers dismissHud];

                                      [kHelpers showAlertWithTitle:LOCALIZED(@"kStringError") andMessage:LOCALIZED(@"kStringErrorNoVideo")];

                                      //rewind
                                      if(rewind) {
                                          [self rewind];

                                          kAppDelegate.transitionController.wait = YES;
                                      }

                                  }


                              });

                              //after delay, in case
                              secs = 5.0f;
                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                  [kHelpers dismissHud];

                              });

                          }];

#if 0
    if(premium)
        [kAppDelegate.alertView addButtonWithTitle:
         LOCALIZED(@"kStringContinue") //[CBSkinManager getRandomOKButton]
                                              type:kAlertButtonGreen
                                           handler:^(SIAlertView *alert) {
                                               //
                                               [kAppDelegate playSound:kClickSound];
                                               //nothing

                                               //force
                                               weakSelf.lastClickDate = [NSDate date];

                                                //refill
                                               [self refillHeartAlert2];

                                           }];
#endif

    //close x
    [kAppDelegate.alertView setDidCloseHandler:^(SIAlertView *alert) {

        //[kAppDelegate playSound:kClickSound];

        if(rewind) {
            [self rewind];

            kAppDelegate.transitionController.wait = YES;
        }
     }];

    kAppDelegate.alertView.buttonsListStyle = SIAlertViewButtonsListStyleRows; //force vertical

    kAppDelegate.alertView.transitionStyle = kAlertStyle;



    //close, unpause
    [kAppDelegate.alertView setDidDismissHandler:^(SIAlertView *alert) {
        //kAppDelegate.gameController.paused = NO;
        //self.paused = NO;
        [self enablePause:NO];
        [kAppDelegate.gameController blurScene:NO];

        [kAppDelegate.gameController showVCR:NO animated:YES];

    }];


    //delayed
    //pause
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, alertDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self enablePause:YES];
        [kAppDelegate.gameController blurScene:YES];

        //continue only if online and rewind
        //[kAppDelegate.alertView show:YES showContinue:rewind && [kHelpers checkOnline]];
        [kAppDelegate.alertView show:YES showContinue:rewind];
        [kAppDelegate.gameController showVCR:YES animated:YES];

    });

}


-(void)rewind
{
    //reset time
    [self resetTime];

    //rewind
    //[kAppDelegate playSound:@"credit1.caf"];

    //rewind
    [kAppDelegate playSound:@"rewind.caf"];

    //reset combo
    kAppDelegate.maxComboLevel = 0;
    self.comboRecord = NO;

    kAppDelegate.numHearts = kHeartFull;
    kAppDelegate.clickCount = [self get1upNumLast];
    [self updateLevelLabel:NO];
    [kAppDelegate saveState];

    //reload game
    [kAppDelegate.gameController actionRestart:nil];
}

-(void)updateLevelLabel:(BOOL)animate{

    //if(self.winning || self.dying)
    if(self.winning) //still update when dying
        return;

    float secs = 0;

    int level = (int)kAppDelegate.level;

    int sinceLast = (int)kAppDelegate.clickCount - [self get1upNumLast];
    int total =  [self get1upNum] - [self get1upNumLast];
    float percent = (sinceLast / (float)total);
    percent = [kHelpers clamp:percent min:0 max:1.0f];

    int subLevelMax = 4;
    int newSubLevel = 1 + floor(percent * subLevelMax);
    int oldSublevel = (int)kAppDelegate.subLevel;

    //save rewind
    if(newSubLevel != oldSublevel && newSubLevel == 1) {
        kAppDelegate.rewindClickCount = kAppDelegate.clickCount;
    }

    kAppDelegate.subLevel = newSubLevel;
    //[kAppDelegate saveState];

    if(newSubLevel != oldSublevel) {

        //also hide banner
        [self hideBanner];

        //report
        [kAppDelegate reportScore];

        [self updateWorldName];

        //brain
        if(kAppDelegate.level == kLevelMax || [kAppDelegate getSkin] == kCoinTypeBrain)
        {
            //if(!kAppDelegate.inReview)
            if(NO)
            {

                NSString* soundName = [@[@"sinistar1.caf", //beware i live
                        @"sinistar2.caf", //run
                        @"sinistar3.caf", //rarrrrrr
                        @"sinistar4.caf", //i hunger
                          ] randomObject];

                [kAppDelegate playSound:soundName];
            }
            else
            {
              NSString* soundName = @"sinistar3.caf"; //rarrrrrr

              [kAppDelegate playSound:soundName];

            }
        }
    }

    //rewind music?
    if(newSubLevel != oldSublevel && newSubLevel < oldSublevel && oldSublevel == 4) {
        [kAppDelegate playMusicRandom];
    }

    //new sublevel, but not 1-1
    if(newSubLevel != oldSublevel && newSubLevel > 1 && newSubLevel < 5) {


        //1/2 way, free heart/powerup
        //if(newSubLevel == 3)
        //every level
        {
            //heart
            //[self showPowerup:YES which:kPowerUpTypeHeart direction:ePowerupPositionBottomCenter];

            //show powerup square
            [self showImageSquare:NO]; //YES
        }

        //force animation
        animate = YES;

        //sound
        [self playSound:self.soundWhistle];

        //particles?

        //vibrate
        //if(kAppDelegate.vibrationEnabled)
        //    [kHelpers vibrate];

        //particle, sublevel
        if(![kHelpers isSlowDevice]) {

            CGPoint particlePosition = CGPointMake(self.barFill.position.x + self.barFill.size.width, self.barFill.position.y);

            //fireworks
            float fireworksAnimRate = fireWorksSpeed;

            self.fireworks1.position = particlePosition;
            self.fireworks1.zPosition = 1000; //self.barFill.zPosition+1;
            self.fireworks1.alpha = 1.0f;
            self.fireworks1.scale = 0.25f;

            int fireworksID = 1 + arc4random_uniform(3);
            self.fireworks1.texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame1", fireworksID]];
            SKAction *fireworksAnim = [SKAction animateWithTextures:@[
            	[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame1", fireworksID]],
            	[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame2", fireworksID]],
            	[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame3", fireworksID]],
            	[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"fireworks%dFrame4", fireworksID]]]
                                                       timePerFrame:fireworksAnimRate];

            SKAction *fireworksWait = [SKAction waitForDuration:0.0f];
            SKAction *fireworksFadeOut = [SKAction fadeOutWithDuration:0.3f];
            SKAction *fireworksSequence = [SKAction sequence:@[fireworksWait, fireworksAnim, fireworksFadeOut]];


            [self.fireworks1 removeActionForKey:@"fireworksFrames"];
            [self.fireworks1 runAction:fireworksSequence withKey:@"fireworksFrames"];

            //star?
            if((kAppDelegate.powerupVisibleType == kPowerUpTypeNone)  && !kAppDelegate.gameController.curtainsVisible && !kAppDelegate.gameController.darkVisible) {

                //only 1/2 way
                if(newSubLevel == 3) {

                }

                [self resetTimer];
            }

            if(!kAppDelegate.gameController.curtainsVisible && !kAppDelegate.gameController.darkVisible) {

                //show all fireballs
                if(newSubLevel == 4) {

                    //only 1 sound
                    if(kAppDelegate.titleController.menuState == menuStateGame)
                        [self playSound:self.soundFireballAppear];

                    for(int i=0;i<[kAppDelegate getMaxFireballs];i++) {

                        //delay
                        float secs = i * 0.1f;
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self showFireball:YES];
                        });

                    }
                    //[kAppDelegate saveState];

                }
                else  {
                    [self showFireball:NO];
                }
            }

            //new bg
            float fadeDuration = kBackgroundFadeDuration;
            //NSString *bgName = nil;
            SKTexture *bgTexture = nil;

            //big level
            //move
            self.bigLevelLabel2.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 80);
            self.bigLevelLabel2.text = [NSString stringWithFormat:@"%d-%d", (int)kAppDelegate.level, (int)kAppDelegate.subLevel];
            self.bigLevelLabel2.hidden = NO;
            self.bigLevelLabel2.alpha = 0.0f;

            float shadowOffset = 2;
            self.bigLevelLabel2Shadow.position = CGPointMake(self.bigLevelLabel2.position.x + shadowOffset, self.bigLevelLabel2.position.y - shadowOffset);
            self.bigLevelLabel2Shadow.text = self.bigLevelLabel2.text;
            self.bigLevelLabel2Shadow.hidden = NO;
            self.bigLevelLabel2Shadow.alpha = 0.0f;

            SKAction *bigLevelFadeIn = [SKAction fadeAlphaTo:1.0f duration:0.4f];
            SKAction *bigLevelFadeIn2 = [SKAction fadeAlphaTo:0.2f duration:0.4f];
            SKAction *bigLevelWait = [SKAction waitForDuration:1.0f];
            SKAction *bigLevelFadeOut = [SKAction fadeAlphaTo:0.0f duration:0.4f];
            SKAction *bigLevelSequence = [SKAction sequence:@[bigLevelFadeIn, bigLevelWait, bigLevelFadeOut]];
            SKAction *bigLevelSequence2 = [SKAction sequence:@[bigLevelFadeIn2, bigLevelWait, bigLevelFadeOut]];

            //move
            SKAction *bigLevelMove = [SKAction moveByX:0.0f y:100.0f duration:1.8f];
            [self.bigLevelLabel2 runAction:bigLevelMove];
            [self.bigLevelLabel2 runAction:bigLevelSequence];

            [self.bigLevelLabel2Shadow runAction:bigLevelMove];
            [self.bigLevelLabel2Shadow runAction:bigLevelSequence2];

            //move?

            if(kAppDelegate.subLevel == 4) {

                //lava
                //[self showLava];

                //bg
                //bgName = kBackgroundVolcano;
                bgTexture = self.bgCastle;

                //music
                [kAppDelegate playMusic:kMusicNameCastle andRemember:YES];
                //[kAppDelegate playMusic:[kAppDelegate getMusicName] andRemember:YES];

                //warning, disabled
#if 0
                self.warning.hidden = NO;
                self.warning.alpha = 0.0f;
                self.warning.scale = 2.4f  * 2; //2x size

                SKAction *warningScale = [SKAction scaleTo:2.4f duration:0.4f];
                warningScale.timingMode = SKActionTimingEaseIn;
                [self.warning runAction:warningScale];

                if(!kAppDelegate.playedX4Alert)
                {
                    //disable block
                    //self.blockDisabled = YES;
                }

                SKAction *warningFadeIn = [SKAction fadeAlphaTo:0.9f duration:0.4f];
                SKAction *warningWait = [SKAction waitForDuration:1.0f];
                SKAction *warningFadeOut = [SKAction fadeAlphaTo:0.0f duration:0.4f];
                SKAction *warningSequence = [SKAction sequence:@[warningFadeIn, warningWait, warningFadeOut]];
                [self.warning runAction:warningSequence completion:^{

                    //almost
                    [self showFirstTimeAlert];

                    if(kAppDelegate.level == kLevelMax) {
                        [self showLastLevelAlert];
                    }

                }];


#endif

#if 1
                //disable if re-enable warning
                if(!kAppDelegate.playedX4Alert)
                {
                    //disable block
                    //self.blockDisabled = YES;
                }

                SKAction *actionBlock2 = [SKAction runBlock:^{

                    //almost
                    [self showFirstTimeAlert];

                    if(kAppDelegate.level == kLevelMax) {
                        [self showLastLevelAlert];
                    }
                }];
                [self runAction:actionBlock2 afterDelay:1.5f];
#endif




                //sound
                [self playSound:self.soundWarning];

                if(kVoiceEnabled)
                {
                    SKAction *actionBlock = [SKAction runBlock:^{
                        [kAppDelegate playSound:@"voice_warning.caf"];
                    }];
                    [self runAction:actionBlock afterDelay:0.5f];

                }


                //clouds
                int numClouds = 10;
                for(int i = 0;i<numClouds;i++) {

                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i * 0.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showCloud];
                    });
                }

                [self pauseEffect];

            }
            else {
                bgTexture = [self getRandomBackground];

                //music
                //[kAppDelegate playMusicRandom];
            }

            //new old
            //self.lastBgName = bgName;
            self.lastBGTexture = bgTexture;

            //old image, fade out

            SKAction *bgFade = [SKAction fadeAlphaTo:0.0f duration:fadeDuration];
            SKAction *bgWait = [SKAction waitForDuration:0.1f];
            SKAction *bgSequence = [SKAction sequence:@[bgWait, bgFade]];

            secs = 0.1f;
			SKAction *actionBlock = [SKAction runBlock:^{
            //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs * NSEC_PER_SEC), dispatch_get_main_queue(), ^{

                //fade
                self.bgImage2.texture = [self.bgImage.texture copy];
                self.bgImage2.alpha = 1.0f;

                [self.bgImage2 runAction:bgSequence];

                //new image
                self.bgImage.texture = bgTexture;
            //});
            }];
			[self runAction:actionBlock afterDelay:secs];
        }

    }

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
	{
        //self.levelLabel.text = [NSString stringWithFormat:@"World  -%d", levelTemp];
		self.levelLabel.text = [NSString stringWithFormat:@"World Minus %d-%d", levelTemp, newSubLevel];
	}

    else
        self.levelLabel.text = [NSString stringWithFormat:@"World %d-%d", levelTemp, newSubLevel];

    self.levelLabel.xScale = 1.0f;
    self.levelLabel.yScale = self.levelLabel.xScale;

    if(animate) {
        //scale
        float oldScale = self.levelLabel.xScale;
        float newScale = self.levelLabel.xScale * 1.2;

        [self.levelLabel removeAllActions];
        SKAction *actionfade0 = [SKAction scaleTo:newScale duration:0.2f];//in
        SKAction *actionfade1 = [SKAction waitForDuration:0.1f];
        SKAction *actionfade2 = [SKAction scaleTo:oldScale duration:0.2f];//out
        SKAction *fadeSequence = [SKAction sequence:@[actionfade0,actionfade1,actionfade2]];
        [self.levelLabel runAction:fadeSequence];
    }
}


- (void)showMenu {

    /*
    //idle
    self.lastClickDate = [NSDate date];

    //report
    [kAppDelegate reportScore];

    [kAppDelegate.sideMenuViewController openMenuAnimated:YES completion:nil];

    [self pause:YES];*/
}


-(void)updateHelpButton {

    NSArray *nameArray =
        @[
          //@"help_bubble", //?
          //@"help_bubble2", //!#
          @"help_bubble3", //@!
          //@"help_bubble4", //tap
          @"help_bubble5", //sad face
          @"help_bubble6", //help
          //@"help_bubble7", //hey
          //@"help_bubble8" //omg


          @"help_bubble6", //help
          @"help_bubble6", //help
          @"help_bubble6", //help
          @"help_bubble6", //help
          @"help_bubble6", //help
          ];

    NSString *name = [nameArray randomObject];

    //level
    if(kAppDelegate.level <= 1) {
        name = @"help_bubble6"; //help
    }

    //force
    if(YES && [kHelpers isDebug]) {
        //name = @"help_bubble6"; //help
    }

    //force red
    name = @"help_bubble6_2"; //help


    if(self.winning || self.dying)
    {
        name = @"help_bubble_heart";
        self.barHelp.hidden = YES;
    }
    else
    {
        self.barHelp.hidden = NO;
    }

    SKTexture *texture = [SKTexture textureWithImageNamed:name];
    self.barHelp.texture = texture;
}

-(void)updateMult:(BOOL)animate{

    float mult = [self getMult];

    NSString *oldText = self.multLabel.text;
    //self.multLabel.text = [NSString stringWithFormat:@"%.1fx POW",  mult];
    self.multLabel.text = [NSString stringWithFormat:@"%.1fx Power",  mult];
    //self.multLabel.text = [NSString stringWithFormat:@"%.1fx damage",  mult];
    //self.multLabel.text = [NSString stringWithFormat:@"%.1fx multiplier",  mult];
    //self.multLabel.text = [NSString stringWithFormat:@"%.1fx mult",  mult];
    //Log(@"**** updateMult: %@", self.multLabel.text);

    animate = NO; //disabled

    //color?
    if(kAppDelegate.comboMult > 0.0f) {
        //not the same?
        //animate

        if(![self.multLabel.text isEqualToString:oldText])
            animate = YES;

        //self.multLabel.fontColor = [CBSkinManager getMessageColor];


    }
    else {
        //self.multLabel.fontColor = [UIColor whiteColor];
    }

    //animated?

    self.multLabel.xScale = 1.0f; //0.5f;
    self.multLabel.yScale = self.multLabel.xScale;

    if(animate) {
        //scale
        float oldScale = self.multLabel.xScale;
        float newScale = self.multLabel.xScale * 1.2;

        //[self.multLabel removeAllActions];
        //[self.multLabelShadow removeAllActions];
        SKAction *actionfade0 = [SKAction scaleTo:newScale duration:0.2f];//in
        SKAction *actionfade1 = [SKAction waitForDuration:0.1f];
        SKAction *actionfade2 = [SKAction scaleTo:oldScale duration:0.2f];//out
        SKAction *fadeSequence = [SKAction sequence:@[actionfade0,actionfade1,actionfade2]];
        [self.multLabel runAction:fadeSequence];
    }

}

-(void)updateSpeed
{
    [self.clickArray addObject:[NSNumber numberWithInt:self.countSinceLastSecond]];

    self.countSinceLastSecond = 0;

    if(self.clickArray.count > 3)
    {
        [self.clickArray removeObjectAtIndex:0];
    }

    float speed = 0.0f;
    float total = 0.0f;

    for(NSNumber *num in self.clickArray) {

        int tempInt = [num intValue];
        total += tempInt;
    }

    speed = total/self.clickArray.count;

    //mult
    //float mult = [self getMult];

    self.speedLabel.text = [NSString stringWithFormat:@"%.1f coins/second", speed];
}

- (void) actionTimer:(NSTimer *)incomingTimer
{
    if(self.paused)
        return;

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return;

    [self updateSpeed];

    //[self updateMult:NO];
}

- (void) actionTimerPowerup:(NSTimer *)incomingTimer {

    if(self.paused)
        return;

    //not yet
    if(kAppDelegate.titleController.menuState != menuStateGame)
        return;

    if(kAppDelegate.powerupVisibleType != kPowerUpTypeNone)
    {
        //sound?
        //[self playSound:self.soundGasp];

        //hide
        [self hidePowerup];
    }
}

- (void) actionTimerHeartbeat:(NSTimer *)incomingTimer
{

    //rec, pew
    if([kAppDelegate getSkin] == kCoinTypePew) {
        self.rec.hidden = !self.rec.hidden;
    }

}

- (void) actionTimerHeartbeat2:(NSTimer *)incomingTimer
{

    //buff sound, cowbell
    if(kAppDelegate.currentBuff != kBuffTypeNone)
    {
        //[self playSound:self.buffRepeatSound];
        //disabled
    }

    //heartbeat sound for x-4?
    /*if(clicks left < 0 && !winning && !dying)
     {
     [self playSound:];
     }*/
}


- (void) actionTimerWeakSpot:(NSTimer *)incomingTimer
{
    if(kAppDelegate.currentBuff == kBuffTypeWeak)
    {
        //buff, every time
        [self showWeakSpot];
    }

}

- (void) actionTimerAutoClick:(NSTimer *)incomingTimer
{
    if(kAppDelegate.currentBuff == kBuffTypeAuto)
    {
        //buff, every time
        [self touchedBlock:nil];
    }

}

- (void) actionTimerRandomEvent:(NSTimer *)incomingTimer
{
    if(self.paused)
        return;

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return;

    if(self.winning || self.dying)
        return;

    if(kAppDelegate.gameController.showingKTPlay)
        return;


    [kAppDelegate dbSaveObjects];


    //show hand again
    if(self.lastClickDate && [[NSDate date] timeIntervalSinceDate:self.lastClickDate] > kShowHandAgainDelay) {
        self.lastClickDate = nil;

        [self showArrowBlockWithLava:YES];

    }

    //test always
    if([kHelpers isDebug])
    {
        //[self showWeakSpot];
        //[self showToastie:YES];
    }

    //buff
    if(kAppDelegate.currentBuff == kBuffTypeWeak)
    {
        //buff, every time
        //[self showWeakSpot];

        //actionTimerWeakSpot instead
    }
	else if([kHelpers randomBool100:50])
	{
        //normal, odds
		[self showWeakSpot];
	}

    //show lava on x-4
    if(kAppDelegate.subLevel == 4 && [kHelpers randomBool100:80] && kAppDelegate.level >= 2) {

        //lava
        //[self showLava];
    }

    //sound brain
    if([kAppDelegate getSkin]  == kCoinTypeBrain)
    {
        SKAction *actionSound = [SKAction runBlock:^{

          NSString *soundName = nil;
          if(NO) //if(kAppDelegate.inReview)
          {
            soundName = [@[@"sinistar1.caf", //beware i live
                      @"sinistar2.caf", //run
                      @"sinistar3.caf", //rarrrrrr
                      @"sinistar4.caf", //i hunger
                      ] randomObject];
          }
          else
          {
            soundName = @"sinistar3.caf"; //rarrrrrr
          }

          [kAppDelegate playSound:soundName];

        }];
        [self runAction:actionSound];
    }


    //banner
    if([kHelpers randomBool100:50])
    {
        [self actionTimerAdToggle:nil];
    }

    //cats
    if([kAppDelegate getSkin]  == kCoinTypeTA && [kHelpers randomBool100:10])
    {
        SKAction *actionSound = [SKAction runBlock:^{

            NSString *soundName = [@[@"cat1.caf",
                                     @"cat2.caf",
                                     @"cat3.caf",
                                     ] randomObject];

            [kAppDelegate playSound:soundName];
        }];
        [self runAction:actionSound];

    }

	//powerup, more often in premium
  int powerUpOdds = kAppDelegate.powerupTimerOdds;
  if([kAppDelegate isPremium])
    powerUpOdds *= 1.5f; //more in premium

	if([kHelpers randomBool100:powerUpOdds])
	{
		//random powerup
		[self showImageSquare];
	}

    if([kHelpers randomBool100:50])
    {
        //[kAppDelegate cacheRewardVideos];
    }

    if([kHelpers randomBool100:50])
    {
        //random change help bubble
        [self updateHelpButton];
    }

    //spike

    //more, at x-4
    float spikeInterval = kSpikeIntervalNeeded;
    if(kAppDelegate.subLevel == 4)
        spikeInterval *= 0.5f;


	//more level, 1 less every every N
	//int times =  (int)(kAppDelegate.level / 5.0f);
	int times =  (int)kAppDelegate.level - 1;
	for(int i=0;i<times;i++)
	{
		//spikeInterval *= 0.5f; //mult
		spikeInterval -= 1.0f; //subs
	}

    //more, level
    /*if(kAppDelegate.level > 10)
        spikeInterval *= 0.5f;*/


    spikeInterval *= [CBSkinManager getFireballTimerMult];

	CGFloat maxSpikeInterval = 3.0f;
    if(spikeInterval < maxSpikeInterval)
        spikeInterval = maxSpikeInterval;


    if(!self.lastSpikeDate)
        self.lastSpikeDate = [NSDate date];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastSpikeDate];
    if(!self.winning && !self.dying && !kAppDelegate.gameController.curtainsVisible && !kAppDelegate.gameController.darkVisible && interval >= spikeInterval) {
        [self showSpike:YES];
    }

    //show fireball
    if(YES) {
        if(!self.lastFireballDate)
            self.lastFireballDate = [NSDate date];

        float fireInterval = kFireballIntervalNeeded;
        if(kAppDelegate.subLevel == 4)
            fireInterval *= 0.5f;

        fireInterval *= [CBSkinManager getFireballTimerMult];

        if(fireInterval < 1.0f)
            fireInterval = 1.0f;

        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastFireballDate];
        if(!self.winning && !self.dying && !kAppDelegate.gameController.curtainsVisible && !kAppDelegate.gameController.darkVisible && interval >= fireInterval) {

            [self showFireball:NO];
        }

    }

    //shake block
    [self bounceBlock];


    //change speed
    [self randomFireballSpeed];
}


-(void)bounceBlock
{
    //shake block
    float wiggleOffset = 4.0f;
    float wiggleTimeEach = 0.1f;
    SKAction* bounce = [SKAction sequence:@[[SKAction moveByX:0 y:wiggleOffset duration:wiggleTimeEach],
                                            [SKAction moveByX:0 y:-wiggleOffset duration:wiggleTimeEach],
                                            [SKAction moveByX:0 y:wiggleOffset/2 duration:wiggleTimeEach],
                                            [SKAction moveByX:0 y:-wiggleOffset/2 duration:wiggleTimeEach],
                                            [SKAction waitForDuration:2.0f]]]; //3.0f
    [self.block removeActionForKey:@"animationWobble"];
    [self.block runAction:[SKAction repeatActionForever:bounce] withKey:@"animationWobble"];

	//also weak spot
    [self.weakSpot removeActionForKey:@"animationWobble"];
    [self.weakSpot runAction:[SKAction repeatActionForever:bounce] withKey:@"animationWobble"];
}

- (void) actionTimerBgFade:(NSTimer *)incomingTimer {

    if(self.paused)
        return;

    if(kAppDelegate.subLevel != 4)
        return;

    if(kAppDelegate.subLevel != 4)
        return;

    self.bgFadeState = !self.bgFadeState;

    //Log(@"actionTimerBgFade");

    SKTexture *bgTexture = nil;

    if(self.bgFadeState) {
        bgTexture = self.bgCastle;
    }
    else {
        bgTexture = self.bgCastle2;
    }

    //new old
    self.lastBGTexture = bgTexture;

    //old image, fade out
    float fadeDuration = kBackgroundFadeDuration; //0.4f;

	SKAction *bgFade = [SKAction fadeAlphaTo:0.0f duration:fadeDuration];
	//SKAction *bgWait = [SKAction waitForDuration:0.5f];
	SKAction *bgSequence = [SKAction sequence:@[/*bgWait, */bgFade]];

	self.bgImage2.texture = self.bgImage.texture;
	self.bgImage2.alpha = 1.0f;

	[self.bgImage2 runAction:bgSequence];

	//new image
	self.bgImage.texture = bgTexture;

}

- (void) actionTimerHelpBubble:(NSTimer *)incomingTimer {

    if(self.paused)
        return;

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return;

    //self.barHelp.hidden = !self.barHelp.hidden;

    self.barHelp.hidden = NO;

    if(self.barHelp.alpha > 0.0f) {
        [self.barHelp runAction:[SKAction fadeOutWithDuration:0.1f]];
    }
    else {
        [self.barHelp runAction:[SKAction fadeInWithDuration:0.1f]];
    }

}

- (void) actionTimerLowHealth:(NSTimer *)incomingTimer {

    if(self.paused)
        return;

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return;

    if(kAppDelegate.gameController.curtainsVisible)
        return;

    [self playSound:self.soundLowHeart];
}

- (void) actionTimerAdToggle:(NSTimer *)incomingTimer
{
    if(self.paused)
        return;

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return;

    //not too fast
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:kAppDelegate.gameController.lastBannerToggle];
    if(interval < 10.0f) //30
    {
        return;
    }

    //toggle ad
    [self toggleBanner];
}

- (void)resetTime
{
    //Log(@"***** resetTime");

    //reset time
    kAppDelegate.worldTimeLeft = kWorldTimeReset;
    if(kAppDelegate.subLevel == 4)
    {
        //world x-4 lava arrive faster, not auto

        kAppDelegate.worldTimeLeft = kWorldTimeReset4;
    }

    self.skipTime = YES;

    [self updateTimeLabel:NO];
}

- (void)resetTimer{

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return;

    float interval = kTimerDelay;
    SKAction* wait = [SKAction waitForDuration:interval];
    SKAction* run = [SKAction runBlock:^{
        [self actionTimer:nil];
    }];
    SKAction* sequence = [SKAction sequence:@[wait, run]];
    SKAction* loop = [SKAction repeatActionForever:sequence];

    [self removeActionForKey:@"timerTimerLoop"];
    [self runAction:loop withKey:@"timerTimerLoop"];


    //random event
    [self.timerRandomEvent invalidate];
    self.timerRandomEvent = nil;
    interval = kTimerDelayRandomEvent;
    /*self.timerRandomEvent = [NSTimer scheduledTimerWithTimeInterval:interval target:self
                                                selector:@selector(actionTimerRandomEvent:) userInfo:@"actionTimerRandomEvent" repeats:YES];
    */
    //random event
    wait = [SKAction waitForDuration:interval];
    run = [SKAction runBlock:^{
        [self actionTimerRandomEvent:nil];
    }];
    sequence = [SKAction sequence:@[wait, run]];
    loop = [SKAction repeatActionForever:sequence];

    [self removeActionForKey:@"actionTimerRandomEvent"];
    [self runAction:loop withKey:@"actionTimerRandomEvent"];

    //weak spot
    interval = kTimerDelayWeak;
    wait = [SKAction waitForDuration:interval];
    run = [SKAction runBlock:^{
        [self actionTimerWeakSpot:nil];
    }];
    sequence = [SKAction sequence:@[wait, run]];
    loop = [SKAction repeatActionForever:sequence];

    [self removeActionForKey:@"actionTimerWeakSpot"];
    [self runAction:loop withKey:@"actionTimerWeakSpot"];

    //auto click
    interval = kTimerDelayAuto;
    wait = [SKAction waitForDuration:interval];
    run = [SKAction runBlock:^{
        [self actionTimerAutoClick:nil];
    }];
    sequence = [SKAction sequence:@[wait, run]];
    loop = [SKAction repeatActionForever:sequence];

    [self removeActionForKey:@"actionTimerAutoClick"];
    [self runAction:loop withKey:@"actionTimerAutoClick"];


    //clouds
    interval = 1.0f;
    wait = [SKAction waitForDuration:interval];
    run = [SKAction runBlock:^{
        //by level?
        if([kHelpers randomBool100: (kAppDelegate.subLevel == 4) ? 100 : 30 ])
            [self showCloud];
    }];
    sequence = [SKAction sequence:@[wait, run]];
    loop = [SKAction repeatActionForever:sequence];

    [self removeActionForKey:@"actionShowCloud"];
    [self runAction:loop withKey:@"actionShowCloud"];

    //pew
    //bubble
    interval = 0.5f;

    //time
    wait = [SKAction waitForDuration:interval];
    run = [SKAction runBlock:^{
        [self actionTimerHeartbeat:nil]; //pew, also for buff cowbell sound
    }];
    sequence = [SKAction sequence:@[wait, run]];
    loop = [SKAction repeatActionForever:sequence];

    [self removeActionForKey:@"timerActionHeartbeat"];
    [self runAction:loop withKey:@"timerActionHeartbeat"];


    //time 2
    interval = 1.0f;

    //time
    wait = [SKAction waitForDuration:interval];
    run = [SKAction runBlock:^{
        [self actionTimerHeartbeat2:nil]; //snaps buff
    }];
    sequence = [SKAction sequence:@[wait, run]];
    loop = [SKAction repeatActionForever:sequence];

    [self removeActionForKey:@"timerActionHeartbeat2"];
    [self runAction:loop withKey:@"timerActionHeartbeat2"];


    //bubble
    interval = 0.25f;

    //time
    wait = [SKAction waitForDuration:interval];
    run = [SKAction runBlock:^{
        [self actionTimerHelpBubble:nil];
    }];
    sequence = [SKAction sequence:@[wait, run]];
    loop = [SKAction repeatActionForever:sequence];

    [self removeActionForKey:@"timerHelpBubbleLoop"];
    [self runAction:loop withKey:@"timerHelpBubbleLoop"];


    //bg fade

    [self.timerBgFade invalidate];
    self.timerBgFade = nil;

    [self removeActionForKey:kActionKeyComboFail];
}


-(void) resumeNotification:(NSNotification*)notif
{

    if(kAppDelegate.titleController.menuState != menuStateGame)
        return; //wrong screen

    [self setSoundVolume];

    [self pause:NO];
    [self updateAll];
}

-(void)pause:(BOOL)pause
{

    //disabled
    //return;

    //already
    if(self.scene.paused  && pause)
        return;

    if(pause) {
        //nothing
    }
    else {

        [kAppDelegate resumeMusic];

        //[self flashFireballs];
    }
}

- (int)getBannerOffset {

	int offset = 20; //30;

    if(!kAppDelegate.gameController.bannerView.hidden)
    {
        offset += kAppDelegate.gameController.bannerView.height;
    }
    return offset;
}

- (int)getWallOffset {


    int bannerOffset = 55;
    int noOffset = 0;

    //return bannerOffset; //   always

    if([kAppDelegate isPremium])
        bannerOffset = noOffset;
    else if (![kHelpers checkOnline])
        bannerOffset = noOffset;
    else if (![kAppDelegate launchedEnough])
        bannerOffset = noOffset;
    else if (kAppDelegate.gameController.bannerView.hidden)
        bannerOffset = noOffset;
    else if ([kHelpers isSimulator])
        bannerOffset = noOffset;


    return bannerOffset;
}


- (UIImage *)getScreenshot {

    //get image
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 1);
    [self.view drawViewHierarchyInRect:self.view.frame afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    if(!image) {
        image = [UIImage imageNamed:@"background10"];
    }

    return image;
}


#pragma mark -
#pragma mark Helper Methods

#if 0
- (SSBitmapFont *)bitmapFontForFile:(NSString *)filename
{
    //https://71squared.zendesk.com/hc/en-us/articles/200037472-Using-Glyph-Designer-1-8-with-Sprite-Kit

    // Generate a path to the font file
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"skf"];

    NSAssert(path, @"Could not find font file");

    // Create a new instance of SSBitmapFont using the font file a  nd check for errors
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:path];
    SSBitmapFont *bitmapFont = [[SSBitmapFont alloc] initWithFile:url error:&error];

    NSAssert(!error, @"%@: %@", error.domain, error.localizedDescription);

    return bitmapFont;
}
#endif

-(int)getBlockY
{
    int smallScreenOffset = 0;
    if([kHelpers isIphone4Size]) {
        //smallScreenOffset = (568 - 480)/2; //88/2 //44
        smallScreenOffset = 6;
    }
    int y = self.frame.size.height/2 - kBlockOffset + 55 + smallScreenOffset;
    return y;
}

-(void)loadSounds {

    //sounds tests
    int maxPolyphony = 5;
    if([kHelpers isSlowDevice])
        maxPolyphony = 2;

    if(!self.soundArray)
        self.soundArray = [NSMutableArray array];

    //already loaded
    if([self.soundArray count] > 0)
        return;

    NSError *error = nil;
    //FISoundEngine *engine = [FISoundEngine sharedEngine];
    CBAppDelegate *engine = kAppDelegate;

    int index = (int)[kAppDelegate getSkin];
    NSString *soundName =[CBSkinManager getCoinSoundNameIndex:index which:0];
    self.soundCoin = [engine soundNamed:soundName maxPolyphony:maxPolyphony error:&error];
    if (!self.soundCoin) {
        Log(@"Failed to load sound: %@", error);
    }
    //[self.soundArray addObject:self.soundCoin];

    soundName = [CBSkinManager getCoinSoundNameIndex:(int)[kAppDelegate getSkin] which:1];
    self.soundCoin2 = [engine soundNamed:soundName maxPolyphony:maxPolyphony error:&error];
    //if (!self.soundCoin2) {
    //    Log(@"Failed to load sound: %@", error);
    //}
    //[self.soundArray addObject:self.soundCoin2];

    soundName =[CBSkinManager getCoinSoundNameIndex:(int)[kAppDelegate getSkin] which:2];
    self.soundCoin3 = [engine soundNamed:soundName maxPolyphony:maxPolyphony error:&error];
    //if (!self.soundCoin3) {
    //    Log(@"Failed to load sound: %@", error);
    //}
    //[self.soundArray addObject:self.soundCoin3];


    self.soundBump = [engine soundNamed:@"smb3_bump.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBump) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBump];

    self.soundHelp = [engine soundNamed:@"help.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundHelp) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundHelp];


    //self.sound1up = [engine soundNamed:@"smb3_1-up2.caf" maxPolyphony:maxPolyphony error:&error];
    /*self.sound1up = [engine soundNamed:@"smb3_1-up2.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.sound1up) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.sound1up];
     */


    self.soundClap = [engine soundNamed:@"whistle3.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundClap) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundClap];



    self.soundTada = [engine soundNamed:@"whistle4.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundTada) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundTada];

    //self.soundWhistle = [engine soundNamed:@"whistle_low.caf" maxPolyphony:maxPolyphony error:&error];
    //self.soundWhistle = [engine soundNamed:@"whistle.caf" maxPolyphony:maxPolyphony error:&error];
    self.soundWhistle = [engine soundNamed:@"whistle5.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundWhistle) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundWhistle];

    self.soundWrong = [engine soundNamed:@"wrong3.caf" maxPolyphony:maxPolyphony error:&error]; //wrong2.caf
    if (!self.soundWrong) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundWrong];

    self.soundExplosion1 = [engine soundNamed:@"explosion1.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundExplosion1) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundExplosion1];

    self.soundExplosion2 = [engine soundNamed:@"explosion2.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundExplosion2) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundExplosion2];

    self.soundLowBeep = [engine soundNamed:@"low_beep.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundLowBeep) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundLowBeep];


    self.soundGasp = [engine soundNamed:@"gasp1.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundGasp) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundGasp];

    self.soundHashtag = [engine soundNamed:@"hashtag.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundHashtag) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundHashtag];



    self.soundDeath = [engine soundNamed:@"death.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundDeath) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundDeath];



    self.soundStarAppear = [engine soundNamed:@"starAppear2.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundStarAppear) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundStarAppear];

    //self.soundStarClick = [engine soundNamed:@"starClick.caf" maxPolyphony:maxPolyphony error:&error];
    self.soundStarClick = [engine soundNamed:@"starClick3.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundStarClick) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundStarClick];

    /*
    self.soundStarClick2 = [engine soundNamed:@"starClick3.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundStarClick2) {
        Log(@"Failed to load sound: %@", error);
    }
    [self.soundArray addObject:self.soundStarClick];
    */

    self.soundSpikeAppear = [engine soundNamed:@"spikeAppear.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundSpikeAppear) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundSpikeAppear];

    self.soundSpikeAppearPew = [engine soundNamed:@"coin_piew2.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundSpikeAppearPew) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundSpikeAppearPew];

    self.soundSpikeAppearMega = [engine soundNamed:@"spikeAppearMega.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundSpikeAppearMega) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundSpikeAppearMega];

    self.soundSpikeAppearSword = [engine soundNamed:@"spikeAppearSword.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundSpikeAppearSword) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundSpikeAppearSword];

    self.soundSpikeAppearChain = [engine soundNamed:@"spikeAppearChain.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundSpikeAppearChain) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundSpikeAppearChain];

    self.soundSpikeAppearGradius = [engine soundNamed:@"spikeAppearGradius.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundSpikeAppearGradius) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundSpikeAppearGradius];


    self.soundSpikeAppear2Mega = [engine soundNamed:@"spikeAppear2Mega.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundSpikeAppear2Mega) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundSpikeAppear2Mega];

    self.soundFireballAppear = [engine soundNamed:@"fireball2.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundFireballAppear) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundFireballAppear];

    self.soundFireballHide = [engine soundNamed:@"fireball.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundFireballHide) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundFireballHide];



    self.soundFireworks = [engine soundNamed:@"fireworks.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundFireworks) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundFireworks];


    self.soundChorus = [engine soundNamed:@"aaaahhh.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundChorus) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundChorus];

    self.soundSpin = [engine soundNamed:@"spin1.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundSpin) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundSpin];

    self.soundWarning = [engine soundNamed:@"warning.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundWarning) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundWarning];


    self.soundRewind = [engine soundNamed:@"rewind.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundRewind) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundRewind];

    self.soundLowHeart = [engine soundNamed:@"heart_low.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundLowHeart) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundLowHeart];

    self.soundHurt = [engine soundNamed:@"hurt.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundHurt) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundHurt];

    self.soundRefill = [engine soundNamed:@"refill.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundRefill) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundRefill];

    self.soundPotion = [engine soundNamed:@"potion.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPotion) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPotion];

    self.soundPotion2 = [engine soundNamed:@"potion2.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPotion2) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPotion2];

    self.soundSigh = [engine soundNamed:@"sigh.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundSigh) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundSigh];


    self.soundClock = [engine soundNamed:@"clock.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundClock) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundClock];


    self.soundClick = [engine soundNamed:@"click5.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundClick) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundClick];


    self.soundToastieClick = [engine soundNamed:@"coin_piew.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundToastieClick) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundToastieClick];

    self.soundPan1 = [engine soundNamed:@"pan1.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPan1) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPan1];


    self.soundPan2 = [engine soundNamed:@"pan2.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPan2) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPan2];


    self.soundPan3 = [engine soundNamed:@"pan3.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPan3) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPan3];

    self.soundComboRise = [engine soundNamed:@"comboRise.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundComboRise) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundComboRise];

    self.soundBell = [engine soundNamed:@"smashBell.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBell) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBell];


    self.soundBossHit = [engine soundNamed:@"boss_hit.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBossHit) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBossHit];

    self.soundBossDie = [engine soundNamed:@"boss_die.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBossDie) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBossDie];

    self.soundWeakSpot = [engine soundNamed:@"weakSpot.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundWeakSpot) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundWeakSpot];

    self.soundWeakSpot2 = [engine soundNamed:@"weakSpot2.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundWeakSpot2) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundWeakSpot2];

    self.soundBuffShield = [engine soundNamed:@"buffShield.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBuffShield) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBuffShield];

    self.soundBuffGrow = [engine soundNamed:@"buffGrow.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBuffGrow) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBuffGrow];


    self.soundBuffShrink = [engine soundNamed:@"buffShrink.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBuffShrink) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBuffShrink];

    self.soundBuffInk = [engine soundNamed:@"buffInk.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBuffInk) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBuffInk];

    self.soundRubber = [engine soundNamed:@"rubber.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundRubber) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundRubber];


    self.soundLava = [engine soundNamed:@"lava.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundLava) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundLava];




    self.soundBuffDoubler = [engine soundNamed:@"buffDoubler.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBuffDoubler) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBuffDoubler];


    self.soundBuffAuto = [engine soundNamed:@"buffAuto.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBuffAuto) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBuffAuto];



    self.soundBuffStar = [engine soundNamed:@"starClick3.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundBuffStar) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundBuffStar];

    /*self.soundSecret = [engine soundNamed:@"secret.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundSecret) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundSecret];*/

	self.soundKey1 = [engine soundNamed:@"key1.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundKey1) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundKey1];

	self.buffRepeatSound = [engine soundNamed:@"buff_repeat.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.buffRepeatSound) {
        Log(@"buffRepeatSound to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.buffRepeatSound];


    self.soundToastie = [engine soundNamed:@"toastie.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundToastie) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundToastie];

    self.soundToastieEagle = [engine soundNamed:@"eagle.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundToastieEagle) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundToastieEagle];


    self.soundToastiePew = [engine soundNamed:@"coin_piew2.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundToastiePew) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundToastiePew];

    self.soundToastiePortal = [engine soundNamed:@"toastie_portal.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundToastiePortal) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundToastiePortal];

    self.soundToastieTrump = [engine soundNamed:@"toastie_trump.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundToastieTrump) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundToastieTrump];


    self.soundAmazing = [engine soundNamed:@"voice_amazing.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundAmazing) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundAmazing];


    self.soundWow = [engine soundNamed:@"voice_wow.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundWow) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundWow];


    self.soundPowerupAuto = [engine soundNamed:@"voice_auto.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupAuto) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupAuto];


    self.soundPowerupBomb = [engine soundNamed:@"voice_bomb.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupBomb) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupBomb];


    self.soundPowerupGrow = [engine soundNamed:@"voice_grow.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupGrow) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupGrow];


    self.soundPowerupShrink = [engine soundNamed:@"voice_shrink.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupShrink) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupShrink];


    self.soundPowerupStar = [engine soundNamed:@"voice_star.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupStar) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupStar];


    self.soundPowerupInk = [engine soundNamed:@"voice_ink.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupInk) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupInk];

    self.soundPowerupPotion = [engine soundNamed:@"voice_potion.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupPotion) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupPotion];

    self.soundPowerupShield = [engine soundNamed:@"voice_shield.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupShield) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupShield];

    self.soundPowerupDoubler = [engine soundNamed:@"voice_doubler.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupDoubler) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupDoubler];

    self.soundPowerupWeak = [engine soundNamed:@"voice_weak.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupWeak) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupWeak];

    self.soundPowerupHeart = [engine soundNamed:@"voice_heart.caf" maxPolyphony:maxPolyphony error:&error];
    if (!self.soundPowerupHeart) {
        Log(@"Failed to load sound: %@", error);
    }
    else
        [self.soundArray addObject:self.soundPowerupHeart];

    [self loadCustomSounds];

    //volume
    [self setSoundVolume];

}

-(void)playSound:(FISound *)sound {
    [self playSound:sound looping:NO];
}

-(void)playSound:(FISound *)sound looping:(BOOL)looping{

    sound.loop = looping;

    if(kAppDelegate.isLoading)
        return;

    if(kAppDelegate.isPlayingVideoAd)
        return;

    if(self.paused)
        return;

    if(kAppDelegate.gameController.curtainsVisible)
        return;

	if(kAppDelegate.titleController.menuState != menuStateGame)
        return; //wrong screen

	if ([kHelpers isBackground])
		return; //background

    //alert, don't play certain sounds
    if(kAppDelegate.alertView && kAppDelegate.alertView.visible) {
        if(sound == self.soundSpikeAppear ||
           sound == self.soundSpikeAppearPew ||
           sound == self.soundSpikeAppearMega ||
           sound == self.soundSpikeAppearSword ||
           sound == self.soundSpikeAppearGradius ||
           sound == self.soundFireballAppear ||
           sound == self.soundFireballHide
           )
        return;
    }

    if(sound)
    {
        //Log(@"CGGameScene: playsound: %@", sound);
        [sound play];
    }
}

-(void)stopAllSounds
{
    //disabled
    //return;

    //Log(@"stopAllSounds");

    float volume = 0;

    for(FISound *sound in self.soundArray) {

        [sound stop];

        sound.gain = volume;
    }

    //also coin
    self.soundCoin.gain = volume;
    [self.soundCoin stop];
    if(self.soundCoin2) {
        self.soundCoin2.gain = volume;
        [self.soundCoin2 stop];
    }
    if(self.soundCoin3) {
        self.soundCoin3.gain = volume;
        [self.soundCoin3 stop];
    }

    self.soundFireballClick.gain = volume;
    self.soundFireballClick2.gain = volume;
    if(self.soundStarClick2) {
        self.soundStarClick2.gain = volume;
        [self.soundStarClick2 stop];
    }

}

-(void)setSoundVolume
{
    float volume = kAppDelegate.soundVolume;

    for(FISound *sound in self.soundArray) {
        sound.gain = volume;
    }

    //also coin
    self.soundCoin.gain = volume;
    if(self.soundCoin2)
        self.soundCoin2.gain = volume;
    if(self.soundCoin3)
        self.soundCoin3.gain = volume;

    self.soundFireballClick.gain = volume;
    self.soundFireballClick2.gain = volume;

    if(self.soundStarClick2)
        self.soundStarClick2.gain = volume;
}


- (float) distanceBetween : (CGPoint) p1 and: (CGPoint)p2
{
    float distance = sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));;

    distance = fabs(distance);

    return distance;
}

- (CIFilter *)blurFilter
{
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setDefaults];
    [filter setValue:[NSNumber numberWithFloat:20] forKey:@"inputRadius"];
    return filter;
}

CGFloat distanceBetweenPoints(CGPoint first, CGPoint second) {
    return hypotf(second.x - first.x, second.y - first.y);
}

-(void)willAppear {
    //if(self.sharing)
    //    return;

    self.winning = NO;
    self.clickedDoor = NO;

    //reset time
    [self resetTime];

    //after reset
    if(kAppDelegate.clickCount <= 0)
    {
        [self hideAllClouds:NO];
    }

    //always
    [self updateWorldName];

    [self loadSounds];

    [self hideExplosions];

    [self hideCoins];

    [self hideSpike:NO];

    [self hideToastie:NO];

    [self updateComboHighScoreLabel];

    //curtains
    //move curtains
    /*self.curtainLeft.hidden = NO;
    self.curtainLeft.alpha = 1.0f;
    self.curtainRight.hidden = NO;
    self.curtainRight.alpha = 1.0f;
    float curtainWidth = self.curtainLeft.frame.size.width;
    //start
    self.curtainLeft.position = CGPointMake(curtainWidth/2, self.view.bounds.size.height - self.curtainLeft.frame.size.height/2);
    self.curtainRight.position = CGPointMake(self.view.bounds.size.width - curtainWidth/2, self.view.bounds.size.height - self.curtainRight.frame.size.height/2);
    */

    //time
    SKAction* wait = [SKAction waitForDuration:kWorldTimeInterval];
    SKAction* run = [SKAction runBlock:^{
        [self actionTimerWorldTime:nil];
    }];
    SKAction* sequence = [SKAction sequence:@[wait, run]];
    SKAction* loop = [SKAction repeatActionForever:sequence];

    [self removeActionForKey:@"actionTimerWorldTime"];
    [self runAction:loop withKey:@"actionTimerWorldTime"];

    //time flash
    SKAction* wait2 = [SKAction waitForDuration:0.2f]; //kWorldTimeIntervalFlash
    SKAction* run2 = [SKAction runBlock:^{
        if(kAppDelegate.worldTimeLeft < kWorldTimeLow2 && kAppDelegate.worldTimeLeft > 0)
        {
            self.timeLabel.hidden = !self.timeLabel.hidden;
            self.clock.hidden = self.timeLabel.hidden;
        }
        else
        {
            self.timeLabel.hidden = self.clock.hidden = NO;

        }
    }];
    SKAction* sequence2 = [SKAction sequence:@[wait2, run2]];
    SKAction* loop2 = [SKAction repeatActionForever:sequence2];

    [self removeActionForKey:@"actionTimerWorldTime2"];
    [self runAction:loop2 withKey:@"actionTimerWorldTime2"];

}

-(void)willDisappear {

    //if(self.sharing)
    //    return;

    self.clickedDoor = YES;

    [self hideExplosions];

    [self hideAllClouds:NO];

    [self hideToastie:NO];

    if(kAppDelegate.alertView && kAppDelegate.alertView.visible)
        [kAppDelegate.alertView dismissAnimated:NO];

    //remove
    [self removeActionForKey:@"flashFireBallsLoop"];
    [self removeActionForKey:@"timerHelpBubbleLoop"];
    [self removeActionForKey:@"timerTimerLoop"];
    [self removeActionForKey:@"timerActionHeartbeat"];
    [self removeActionForKey:@"timerActionHeartbeat2"];
    [self removeActionForKey:@"actionTimerRandomEvent"];
    [self removeActionForKey:@"actionTimerWeakSpot"];
    [self removeActionForKey:@"actionShowCloud"];

    //[self.door removeAllActions];

    self.flashFireballFlag = NO;

    //timers
    [self.timerLowHealth invalidate];
    self.timerLowHealth = nil;

    [self resetComboLabel];
    [self updateMult:NO];

    [self.soundClock stop];

    //time
	  [self removeActionForKey:@"actionTimerWorldTime"];

    //sounds
    [self.soundSpin stop];

    //hide square
    [self hideImageSquare]; //breaks reward

	[self hideWeakSpot:NO];

}

-(void)removeChildrenNamed:(NSString*)name {

    NSMutableArray *array = [NSMutableArray array];
    for (SKNode* child in self.children){
        if([child.name isEqualToString:name]) {
            [array addObject:child];
        }
    }

    [self removeChildrenInArray:array];

}

-(void)updateArrowImage
{
    UIImage *image = [CBSkinManager getTutoArrowImage];

    self.tutoArrow.texture = [SKTexture textureWithImage:image];
    self.tutoArrowSquare.texture = [SKTexture textureWithImage:image];
}

-(void)hideKey
{
	[self.winKey removeAllActions];
	self.winKey.hidden = YES;
	self.winKey.alpha = 0.0f;
}

//showchest
-(void)showKey
{
    if(kAppDelegate.level == kLevelMax)
    {
        //last stage, don't show
        return;
    }

	[self.winKey removeAllActions];

	self.winKey.hidden = NO;
	self.winKey.alpha = 0.0f;

	self.winKey.position = CGPointMake(self.block.position.x, self.block.position.y+20);

    CGFloat durationMove = 1.5f;
    CGFloat delayStart = 0.0f;

    //images
    float animRate = 0.1f;

	//key
	#if 0
    SKAction *keyAnim = [SKAction animateWithTextures:@[
                                               [SKTexture textureWithImageNamed:@"key2"], //gold
                                               [SKTexture textureWithImageNamed:@"key3"]] //silver
                                timePerFrame:animRate];
    #elseif 0
    //just silver
    SKAction *keyAnim = [SKAction animateWithTextures:@[
                                                        [SKTexture textureWithImageNamed:@"key3"]] //silver
                                         timePerFrame:animRate];
    #else
    //just silver
    SKAction *keyAnim = [SKAction animateWithTextures:@[
                                                        //[SKTexture textureWithImageNamed:@"chest"],
                                                        [SKTexture textureWithImageNamed:@"chest2"],
                                                        [SKTexture textureWithImageNamed:@"chest3"],
                                                        ] //chest
                                         timePerFrame:animRate];
	#endif

    //loop
    keyAnim = [SKAction repeatActionForever:keyAnim];
    [self.winKey runAction:keyAnim];


	//fade in
	[self.winKey runAction:[SKAction fadeAlphaTo:1.0f duration:0.5f] afterDelay:delayStart];

	//move up
    CGFloat moveUpDistance = 20.0f; //50.0f;
    SKAction *move = [SKAction moveBy:CGVectorMake(0, moveUpDistance) duration:durationMove]; //70
    move.timingMode = SKActionTimingEaseOut; //slower at end
	[self.winKey runAction:move afterDelay:delayStart];

	//playsound
	SKAction *actionSound = [SKAction runBlock:^{
        //[self playSound:self.soundKey1]; //not too long or curtains close
        [kAppDelegate playSound:@"key1.caf"];
    }];
    //[self runAction:actionSound afterDelay:delayStart + (durationMove)];
    [self runAction:actionSound afterDelay:delayStart + durationMove]; //0.6f
}

-(void)showToastie:(BOOL)animated
{
    [self showToastie:animated force:NO];
}

-(void)showToastie:(BOOL)animated force:(BOOL)force
{
    //[self playSound:self.soundToastie];
    //return;

    //https://www.youtube.com/watch?v=8bwDmXfdsSY

	//disabled for 1st level
    if(kAppDelegate.level == 1)
        return;

    //only show for powerups
    //if(!self.imageSquare.hidden)
    if(self.squareImageReady)
        return;

    if(!self.toastie.hidden)
        return;

    if(self.winning || self.dying)
        return;

    if(kAppDelegate.gameController.showingKTPlay)
        return;

    if(kAppDelegate.powerupVisibleType != kPowerUpTypeNone)
        return;

//    if(kAppDelegate.currentBuff != kBuffTypeNone)
//        return;

    if(self.squareImageReady)
        return;


    if(!self.lastToastieDate)
    {
        //1st time
        self.lastToastieDate = [NSDate date];
        return;
    }

    if(self.lastToastieDate && !force)
    {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.lastToastieDate];
        if(interval < 60.0f) //30
        {
            return;
        }
    }
    self.lastToastieDate = [NSDate date];


    BOOL flip = ([kHelpers randomBool]);
    BOOL rotate = NO;

    //reset
    [self.toastie removeAllActions];
    self.toastie.zRotation = 0;
	[self.toastie enable:YES];

    int random = 0;
    NSMutableArray *randomArray = nil;

    if([kAppDelegate getSkin] == kCoinTypePew)
    {
        //only pewds
        randomArray = [@[
                     @(3), //pew1
                     @(4), //pew2
                     @(5), //danny

                     @(8), //eagle
                     @(8), //eagle
                     @(8), //eagle

                     @(9), //pew, black

                     @(10), //chris

					 @(12),	//brain
					 @(12),	//brain

                     @(14),    //doge

                    // @(13),	//reggie

                     //@(15),    //portal
                     @(16),    //trump

                     ] mutableCopy];
    }
    else
    {
        randomArray = [@[
                     //@(1), //mk
                     //@(2), //mk
                     @(3), //pew1
                     //@(4), //pew2
                     //@(5), //danny
                     //@(6), //moof
                     //@(7), //bad
                     @(8), //eagle
                     //@(9), //pew, black

                     @(10), //chris
                     @(10), //chris
                     @(10), //chris
                     //@(10), //chris
                     //@(10), //chris

                    // @(11), //duck dog
                    // @(11), //duck dog

					 @(12),	//brain
					 @(12),	//brain

                     @(14),    //doge

                    // @(13),	//reggie
                    // @(13),	//reggie

                     //@(15),    //portal
                     @(16),    //trump


                     ] mutableCopy];


        //later
        if(kAppDelegate.level >= 3)
        {
            [randomArray addObjectsFromArray:@[
                                           ]];
        }

    }

    if(kAppDelegate.inReview)
    {
        //remove nintendo
        [randomArray removeObject:@(11)]; //duck dog
        [randomArray removeObject:@(7)]; //bad
        [randomArray removeObject:@(13)]; //reggie
        [randomArray removeObject:@(16)]; //trump

    }

    random = [[randomArray randomObject] intValue];

    int max = 0;
    while(random == self.lastToastie && max < 5)
    {
        //again
        random = [[randomArray randomObject] intValue];
        max++;
    }

    //force
    if([kHelpers isDebug])
    {
        //random = 15; //portal
        //random = 16; //trump

//        if([kHelpers randomBool100:50])
//           random = 15; //portal
//       else
//           random = 10; //chris
    }

    self.lastToastie = random;


    NSString *imageName = [NSString stringWithFormat:@"toastie%d", random];

    self.toastie.texture = [SKTexture textureWithImageNamed:imageName];
    self.toastie.hidden = NO;
    self.toastie.alpha = 0.0f;

    if([imageName contains:@"toastie15"])
    {
        //portal
        rotate = YES;
    }

    //right
    int xFrom = self.frame.size.width + self.toastie.size.width/2;
    int yFrom = self.toastie.size.height/2;

    int xTo = self.frame.size.width - self.toastie.size.width/2;
    int yTo = self.toastie.size.height/2;

    if(flip)
    {
    }

    self.toastie.position = CGPointMake(xFrom, yFrom);

    float duration = animated ? 0.2f : 0.0f; //0.3f
    SKAction *actionMove = [SKAction moveTo:CGPointMake(xTo, yTo) duration:duration];
    SKAction *actionFade = [SKAction fadeInWithDuration:duration];

    if(rotate)
    {
        SKAction *oneRevolution = [SKAction rotateByAngle:M_PI*2 duration: 3];
        SKAction *repeat = [SKAction repeatActionForever:oneRevolution];
        [self.toastie runAction:repeat];
    }

    [self.toastie runAction:actionMove];
    [self.toastie runAction:actionFade];

    SKAction *actionSound = [SKAction runBlock:^{
        if(random == 8) //eagle
            [self playSound:self.soundToastieEagle];
        else if(random == 3 || random == 4) //pew
            [self playSound:self.soundToastiePew];
        if(random == 15) //portal
            [self playSound:self.soundToastiePortal];
        if(random == 16) //portal
            [self playSound:self.soundToastieTrump];
        else
            [self playSound:self.soundToastie];
    }];
    [self runAction:actionSound afterDelay:duration];


    //timer hide
    CGFloat hideDelay = 0.8f; //0.6f; //1.2f;
    SKAction *actionHide = [SKAction runBlock:^{
        [self hideToastie:YES];
    }];
    [self runAction:actionHide afterDelay:hideDelay];
}

-(void)hideToastie:(BOOL)animated
{
    //Log(@"hideToastie");

    if(self.toastie.hidden)
        return;

    //[self.toastie removeAllActions];

    //bottom
    //int xTo = self.frame.size.width - self.toastie.size.width/2;
    //int yTo = -self.toastie.size.height/2;

    //BOOL flip = NO;

    //right
    int xTo = self.frame.size.width + self.toastie.size.width/2;
    int yTo = self.toastie.size.height/2;

    float duration = animated ? 0.3f : 0.0f;
    SKAction *actionMove = [SKAction moveTo:CGPointMake(xTo, yTo) duration:duration];
    SKAction *actionFade = [SKAction fadeOutWithDuration:duration];

	[self.toastie enable:NO];

    [self.toastie runAction:actionMove completion:^{
        self.toastie.hidden = YES;
    }];
    [self.toastie runAction:actionFade];
}

//showArrowPowerup
-(void)showArrowSquare:(BOOL)animated
{
    //only show once
    //if(kAppDelegate.tutoArrowClickedSquare)
    //    return;

    //not for plus
    if(!self.navPlus.hidden)
    {
        self.tutoArrowSquare.alpha = 0.0f; //1.0f;
        return;
    }

    [self.tutoArrowSquare removeAllActions];

    self.tutoArrowSquare.alpha = 0.8f; //1.0f;

    [self updateArrowImage];

    int offsetX = self.navPlus.hidden ? 25 : -25; //10, -12
    int offsetY = 35;
    self.tutoArrowSquare.position = CGPointMake(self.navSquare.position.x + offsetX, self.navSquare.position.y - offsetY);

    float scaleOrig = 0.6f; //0.4f;
    float scale2 = 1.2f; //0.8f
    self.tutoArrowSquare.scale = scaleOrig;
    float duration = 0.2f;
    [self.tutoArrowSquare runActionsSequenceForever:@[[SKAction scaleBy:scale2 duration:duration], [SKAction scaleTo:scaleOrig duration:duration]]];

    self.tutoArrowSquare.hidden = NO;
    [self.tutoArrowSquare runAction:[SKAction fadeInWithDuration:animated? 0.3f: 0.0f] completion:^{
    }];

    SKAction *hide = [SKAction runBlock:^{
        //hide after delay
        [self hideArrowSquare:YES];
    }];
    [self runAction:hide afterDelay:kHideArrowDelay];
}

-(void)showArrowPotion:(BOOL)animated
{
    [self.tutoArrowPotion removeAllActions];

    [self updateArrowImage];

    int offsetX = -14 ; //10;
    int offsetY = 36; //20;
    self.tutoArrowPotion.position = CGPointMake(self.potion.position.x + offsetX, self.potion.position.y - offsetY);

    //self.tutoArrowPotion.alpha = 0.8f;
    self.tutoArrowPotion.alpha = 0.8f; //1.0f;

    float scaleOrig = 0.6f; //0.4f
    float scale2 = 1.2f; //16f
    self.tutoArrowPotion.scale = scaleOrig;
    float duration = 0.2f;
    [self.tutoArrowPotion runActionsSequenceForever:@[[SKAction scaleBy:scale2 duration:duration], [SKAction scaleTo:scaleOrig duration:duration]]];

    self.tutoArrowPotion.hidden = NO;
    [self.tutoArrowPotion runAction:[SKAction fadeInWithDuration:animated? 0.3f: 0.0f] completion:^{
    }];

    SKAction *hide = [SKAction runBlock:^{
        //hide after delay
        [self hideArrowPotion:YES];
    }];
    [self runAction:hide afterDelay:kHideArrowDelay];
}


-(void)showArrowBlock
{
    [self showArrowBlockWithLava:NO];
}

-(void)showArrowBlockWithLava:(BOOL)lava
{
    //Log(@"***** showArrowBlockWithLava");

//    if(!self.tutoArrow.hidden)
//        return;

    //reset
    [self.tutoArrow removeAllActions];

    [self updateArrowImage];


    int offset = 20;
    if([kHelpers isIphone4Size])
    {
        self.tutoArrow.position = CGPointMake(170+offset, self.frame.size.height - 280 - offset);
    }
    else if([kHelpers isIphoneX])
    {
        self.tutoArrow.position = CGPointMake(170+offset, self.frame.size.height - 360 - offset);
    }
    else
    {
        self.tutoArrow.position = CGPointMake(170+offset, self.frame.size.height - 320 - offset);
    }

    /*self.tutoArrow.position = CGPointMake(self.block.position.x + self.block.size.width/2 - offset,
                                          self.block.position.y  - self.block.size.height/2 + offset);*/
    self.tutoArrow.alpha = 0.8f;
    self.tutoArrow.hidden = NO;

    float scaleOrig = 0.8f; //0.6f //0.4f
    float scale2 = 1.4f; //1.2f //1.6f
    self.tutoArrow.scale = scaleOrig;
    float duration = 0.2f;
    [self.tutoArrow runActionsSequenceForever:@[[SKAction scaleBy:scale2 duration:duration], [SKAction scaleTo:scaleOrig duration:duration]]];

    //also lava
    if(lava && kAppDelegate.level >= 2)
    {
        [self showLavaHurt:YES];
    }
}

-(void)hideArrowBlock {
    [self hideArrowBlock:NO];
}

-(void)hideArrowBlock:(BOOL)animated
{
    if(self.tutoArrow.hidden && self.tutoArrow.alpha < 1.0f)
        return;

    [self.tutoArrow removeAllActions];


    if(animated)
    {
        [self.tutoArrow runAction:[SKAction fadeOutWithDuration:kTutoHideDuration] completion:^{
            self.tutoArrow.hidden = YES;
        }];
    }
    else
    {
        self.tutoArrow.alpha = 0.0f;
        self.tutoArrow.hidden = YES;
    }
}

-(void)hideArrowSquare:(BOOL)animated
{

    if(self.tutoArrowSquare.hidden && self.tutoArrowSquare.alpha < 1.0f)
        return;

    [self.tutoArrowSquare removeAllActions];

    if(animated)
    {
        [self.tutoArrowSquare runAction:[SKAction fadeOutWithDuration:kTutoHideDuration] completion:^{
            self.tutoArrowSquare.hidden = YES;
        }];
    }
    else
    {
        self.tutoArrowSquare.alpha = 0.0f;
        self.tutoArrowSquare.hidden = YES;
    }
}

-(void)hideArrowPotion:(BOOL)animated
{
    if(self.tutoArrowPotion.hidden && self.tutoArrowPotion.alpha < 1.0f)
        return;

    [self.tutoArrowPotion removeAllActions];

    if(animated)
    {
        [self.tutoArrowPotion runAction:[SKAction fadeOutWithDuration:kTutoHideDuration] completion:^{
            self.tutoArrowPotion.hidden = YES;
        }];
    }
    else
    {
        self.tutoArrowPotion.alpha = 0.0f;
        self.tutoArrowPotion.hidden = YES;
    }
}

-(void)updateNumFireballLabel:(BOOL)animated {

    //disabled
    self.numFireballLabel.text = @"";
    self.numFireballLabel.hidden = YES;
    return;

#if 0
    [self.numFireballLabel removeAllActions];

    self.numFireballLabel.alpha = 0.9f;
    self.numFireballLabel.fontColor = [UIColor whiteColor];

    int num = (int)kAppDelegate.fireballVisible;

    //count spkes
    if(!self.spike.hidden)
        num++;

    self.numFireballLabel.text = [NSString stringWithFormat:@"Enemies: %d", num];

    Log(@"updateNumFireballLabel: %@", self.numFireballLabel.text);


    float scaleOld = 0.6f;

    self.numFireballLabel.xScale = scaleOld;
    self.numFireballLabel.yScale = self.numFireballLabel.xScale;

    //animate
    if(animated) {
        SKAction *actionIn = [SKAction scaleBy:1.1f duration:0.1f];
        SKAction *actionOut = [SKAction scaleTo:scaleOld duration:0.1f];
        SKAction *sequence = [SKAction sequence:@[actionIn, actionOut]];

        [self.numFireballLabel runAction:sequence];
    }
  #endif
}

-(void)updateTimeLabel:(BOOL)animated {

    //Log(@"***** updateTimeLabel");

    //disabled
    self.timeLabel.alpha = 0.0f;
    self.timeLabel.hidden = YES;

    self.clock.alpha = 0.0f;
    self.clock.hidden = YES;

    return;


    [self.timeLabel removeAllActions];

    if(kAppDelegate.worldTimeLeft < 0)
        kAppDelegate.worldTimeLeft = 0;
    if(kAppDelegate.worldTimeLeft > kTimeMax)
        kAppDelegate.worldTimeLeft = kTimeMax;

    //color
    if((int)kAppDelegate.worldTimeLeft == 0) {
    }
    else if((int)kAppDelegate.worldTimeLeft <= kWorldTimeLow2) {
        self.timeLabel.alpha = self.clock.alpha = 1.0f;
        self.timeLabel.fontColor = [UIColor whiteColor];
    }
    else if((int)kAppDelegate.worldTimeLeft <= kWorldTimeLow1) {
        self.timeLabel.alpha = self.clock.alpha = 1.0f;
        self.timeLabel.fontColor = [UIColor whiteColor];
    }
    else {
        self.timeLabel.alpha = self.clock.alpha =  1.0f;
        self.timeLabel.fontColor = [UIColor whiteColor];
    }

    //force color
    //self.timeLabel.fontColor = [UIColor whiteColor];

    float scaleOld = 0.0f;


    //vip, unlimited
    //∞
    //BOOL premium = [kAppDelegate isPremium];
    if(kAppDelegate.noTime)
    {
        self.timeLabel.text = [NSString stringWithFormat:@"∞"];
        scaleOld = 1.0f;
    }
    else
    {
        self.timeLabel.text = [NSString stringWithFormat:@"%03d", (int)kAppDelegate.worldTimeLeft];
        scaleOld = 0.8f;
    }



    self.timeLabel.xScale = scaleOld;
    self.timeLabel.yScale = self.timeLabel.xScale;

    //animate
    if(animated) {
        SKAction *actionIn = [SKAction scaleBy:1.1f duration:0.1f];
        SKAction *actionOut = [SKAction scaleTo:scaleOld duration:0.1f];
        SKAction *sequence = [SKAction sequence:@[actionIn, actionOut]];

        [self.timeLabel runAction:sequence];
    }
}

-(void)enablePause:(BOOL)pauseValue {

    //force
    if([kHelpers isDebug])
    {
        //pauseValue = YES;
    }

    //Log(@"enablePause: %d", pauseValue);

    //disabled
    //return;

    //hide/show random
    /*if(pauseValue) {
        self.imageSquare.alpha = 0.0f;
    }
    else {
        if(self.squareImageReady)
            self.imageSquare.alpha = kImageSquareAlpha;
        else
            self.imageSquare.alpha = 0.0f;
    }*/

    //stop sounds
    [self.soundSpin stop];
    [self.soundComboRise stop];

    dispatch_async(dispatch_get_main_queue(), ^{
        self.paused = pauseValue;


        //sounds
        if(!pauseValue)
        {
            //spin resume
            if(self.squareImageReady)
            {
                [self playSound:self.soundSpin looping:YES]; //loop
            }
        }
        else
        {
        }

    });



    /*if(pauseValue) {
        [self stopAllSounds];
    }
    else {
        [self set]
    }*/

}

-(void)updateWorldName {

    if(self.winning || self.dying)
        return;

    NSString *name = [CBSkinManager getRandomWorldName];

    if(kAppDelegate.subLevel == 4)
        self.worldNameLabel.text = [NSString stringWithFormat:@"\"%@ (Castle)\"", name];
    else
        self.worldNameLabel.text = [NSString stringWithFormat:@"\"%@\"", name];

}


-(void)openCurtains {

//    self.curtainLeft.userInteractionEnabled = YES;
//    self.curtainRight.userInteractionEnabled = YES;

    //disabled
    self.curtainLeft.hidden = NO;
    self.curtainRight.hidden = NO;
    return;

#if 0
    [self.curtainLeft removeAllActions];
    [self.curtainRight removeAllActions];

    self.curtainLeft.hidden = NO;
    self.curtainLeft.alpha = 1.0f;

    self.curtainRight.hidden = NO;
    self.curtainRight.alpha = 1.0f;

    self.curtainLeft.zPosition = self.whiteBar.zPosition + 1;
    self.curtainRight.zPosition = self.whiteBar.zPosition + 1;

    float curtainWidth = self.curtainLeft.frame.size.width;

    //start
    self.curtainLeft.position = CGPointMake(curtainWidth/2, self.view.bounds.size.height - self.curtainLeft.frame.size.height/2);
    self.curtainRight.position = CGPointMake(self.view.bounds.size.width - curtainWidth/2, self.view.bounds.size.height - self.curtainRight.frame.size.height/2);


    float duration = kCurtainAnimDuration;

    SKAction *moveLeft = [SKAction moveBy:CGVectorMake(-curtainWidth, 0) duration:duration];
    SKAction *moveRight = [SKAction moveBy:CGVectorMake(curtainWidth, 0) duration:duration];

    moveLeft.timingMode = SKActionTimingEaseInEaseOut;
    moveRight.timingMode = SKActionTimingEaseInEaseOut;

    //action delay
    SKAction *openCurtainAction = [SKAction runBlock:^{

        [kAppDelegate playSound:kCurtain2Sound];

        [self.curtainLeft runAction:moveLeft completion:^{
            self.curtainLeft.hidden = YES;
        }];

        [self.curtainRight runAction:moveRight completion:^{
            self.curtainRight.hidden = YES;
        }];

    }];

    [self runAction:openCurtainAction];
    //[self runAction:openCurtainAction];


    //finish
    //self.curtainLeft.position = CGPointMake(-curtainWidth/2, self.view.bounds.size.height - self.curtainLeft.frame.size.height/2);
    //self.curtainRight.position = CGPointMake(self.view.bounds.size.width + curtainWidth/2, self.view.bounds.size.height - self.curtainRight.frame.size.height/2);

#endif
}

-(void)closeCurtains {

    //disabled
    self.curtainLeft.hidden = NO;
    self.curtainRight.hidden = NO;
    return;

#if 0
    self.curtainLeft.hidden = NO;
    self.curtainLeft.alpha = 1.0f;

    self.curtainRight.hidden = NO;
    self.curtainRight.alpha = 1.0f;

    [self.curtainLeft removeAllActions];
    [self.curtainRight removeAllActions];

    float curtainWidth = self.curtainLeft.frame.size.width;

    //start
    self.curtainLeft.position = CGPointMake(-curtainWidth/2, self.view.bounds.size.height - self.curtainLeft.frame.size.height/2);
    self.curtainRight.position = CGPointMake(self.view.bounds.size.width + curtainWidth/2, self.view.bounds.size.height - self.curtainRight.frame.size.height/2);

    SKAction *moveLeft = [SKAction moveBy:CGVectorMake(curtainWidth, 0) duration:kCurtainAnimDuration];
    SKAction *moveRight = [SKAction moveBy:CGVectorMake(-curtainWidth, 0) duration:kCurtainAnimDuration];

    moveLeft.timingMode = SKActionTimingEaseInEaseOut;
    moveRight.timingMode = SKActionTimingEaseInEaseOut;

    //finish

    [self.curtainLeft runAction:moveLeft completion:^{
        //self.curtainLeft.hidden = YES;
    }];

    [self.curtainRight runAction:moveRight completion:^{
        //self.curtainRight.hidden = YES;
    }];

    //self.curtainLeft.position = CGPointMake(curtainWidth/2, self.view.bounds.size.height - self.curtainLeft.frame.size.height/2);
    //self.curtainRight.position = CGPointMake(self.view.bounds.size.width - curtainWidth/2, self.view.bounds.size.height - self.curtainRight.frame.size.height/2);
#endif
}


-(int)heartLose
{
    int lose = 0;

    if(!kAppDelegate.invincible)
    {
        lose = kHeartLose;
        if(kAppDelegate.currentBuff == kBuffTypeShield)
        {
            lose = kHeartLose/2;
        }


        //BOOL premium = [kAppDelegate isPremium];
        //if(premium)
        //    heartLose /= 2;

    }

    return lose;
}

-(CGFloat)getIPhoneXTop
{
    if([kHelpers isIphoneX])
        return 30.0f;
    return 0.0f;
}

-(CGFloat)getIPhoneXBottom
{
    if([kHelpers isIphoneX])
        return 30.0f;

    return 0.0f;
}

@end
