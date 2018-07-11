//
//  CBGameScene.h
//  CoinBlock
//

//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
//#import "CBAppDelegate.h"
#import "CBSkinManager.h"


typedef enum {
    kBuffTypeNone = -1,

    kBuffTypeShield = 0,
    kBuffTypeStar,
    kBuffTypeDoubler,
    kBuffTypeAuto,
    kBuffTypeWeak,
    kBuffTypeGrow,
    kBuffTypeShrink,
    kBuffTypeInk,

    kBuffTypeCount
} BuffType;

@interface CBGameScene : SKScene

@property (strong, nonatomic) NSDate *lastClickDate;
@property (nonatomic, strong) SKSpriteNode *curtainLeft;
@property (nonatomic, strong) SKSpriteNode *curtainRight;
@property (nonatomic) BOOL dying;
@property (nonatomic) BOOL hidingLava;

@property (strong, nonatomic) NSDate *lastToastieDate;
@property (strong, nonatomic) NSDate *lastLavaDate;
@property (nonatomic, strong) SKSpriteNode *lava;

-(void)updateAll;
-(void)resetParticles;
-(void)showMenu;
-(void) repositionAll;
-(void) stopAllSounds;
-(void) setSoundVolume;
-(void)checkHeartTimer;
-(void)rewind;

-(void)hideAllFireballs;
-(void)hidePowerup;
-(SKSpriteNode*)showPowerup:(BOOL)force which:(PowerupType)which;
-(void)showBuff:(BuffType)buffType;
-(void)touchedNavSquare2;
-(void)touchedBlock:(SKSpriteNode*)node;
-(void)setNumHearts:(int)many;
-(void)showImageSquare;
-(void)showImageSquare:(BOOL)force;
-(void)hideImageSquare:(BOOL)removeOldAction;
-(void)showLava;
-(void)hideLava:(BOOL)animated;

-(void)refillHeartAlert2;
-(void)refillPotionsAlert2;

- (UIImage *)getScreenshot;
-(float)getMult;

-(void)resetComboLabel;

-(int)get1upNum;
-(int)get1upNumLast;

-(void)willAppear;
-(void)willDisappear;

-(void)flashFireballs;
-(void)actionTimerWorldTime:(NSTimer *)incomingTimer;
-(void)showArrowBlock;
-(void)hideArrowBlock;
-(void)updateTimeLabel:(BOOL)animated;
-(void)enablePause:(BOOL)pauseValue;
-(void)updateLevelLabel:(BOOL)animate;
-(void)updateArrowImage;
-(void)hideAllClouds:(BOOL)animated;
-(void)resumeNotification:(NSNotification*)notif;

-(void)rewardPowerup;
-(void) touchedPowerup:(SKSpriteNode*)node;

-(void)openCurtains;
-(void)closeCurtains;

-(void)shake;
-(void)shakeTimes:(NSInteger)times;

-(void)showWeakSpot;
-(void)showToastie:(BOOL)animated;
-(void)showToastie:(BOOL)animated force:(BOOL)force;
@end
