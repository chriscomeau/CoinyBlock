//
//  CBSkinManager.h
//  CoinBlock
//
//  Created by Chris Comeau on 2016-04-07.
//  Copyright © 2016 Skyriser Media. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum PowerUpType{
    kPowerUpTypeNone = -1,

    kPowerUpTypeStar = 0,
    kPowerUpTypeHeart,
    kPowerUpTypePotion,
    kPowerUpTypeShield,
    kPowerUpTypeGrow,
    kPowerUpTypeShrink,
    kPowerUpTypeInk,
    kPowerUpTypeBomb,
    kPowerUpTypeDoubler,
    kPowerUpTypeWeak,
    kPowerUpTypeAuto,

    kPowerUpTypeCount,




    //soon
    kPowerUpTypeCoins,
    kPowerUpTypeIce,

    //nope
    kPowerUpTypeBanana,
    kPowerUpTypeNut,
    kPowerUpTypeRedCoin,
    //kPowerUpTypeVideo,
    kPowerUpTypeClock,
    kPowerUpTypePow,
    kPowerUpTypeFeather,

} PowerupType;

@interface CBSkinManager : NSObject

+(NSString*)getRandomStart:(int)index;
+(NSString*)getRandomMessage;
+(NSString*)getRandomOuch;
+(NSString*)getRandomOKButton;
+(NSString*)getRandomOKButton2;
+(NSString *)getRandomTip;
+(NSString *)getRandomWinMessage;
+(NSString *)getRandomReady;
+(NSArray *)getRandomLongMessage;
+(NSArray *)getRandomNotification;
+(float)getHeartHealTime;
+(float)getFireballTimerMult;

+(NSString*)getLevelupMusicName;
+(NSString*)getMusicName;
+(NSString*)getStarClickSoundName;
+(NSString*)getStarClickSoundNameIndex:(int)index;
+(NSString*)getFireClickSoundNameIndex:(int)index which:(int)which;
+(NSString*)getSkinKey:(int)index;
+(NSString*)getSkinIAP:(int)index;
+(CGFloat)getSkinWeakspotOffset:(int)index;
+(int)getSkinIAPIndex:(NSString*)name;
+(BOOL)isSkinPremium:(int)index;
+(NSString*)getFireClickSoundName:(int)which;
+(NSString*)getFireballName;
+(NSArray*)getFireballArrayWithLevel:(int)level all:(BOOL)all;
+(NSArray*)getSpikeArrayWithLevel:(int)level all:(BOOL)all;
+(NSString*)getCoinSoundNameIndex:(int)index;
+(NSString*)getCoinSoundNameIndex:(int)index which:(int)which;
+(NSString*)getStartSoundName:(int)index;
+(NSString*)getBlockDisplayNameIndex:(int)index;
+(NSString*)getBlockDisplayNameIndex:(int)index multiLine:(BOOL)multiline;
+(NSString*)getBlockDescIndex:(int)index;
+(NSString*)getBlockWebsite:(int)index;
+(NSString*)getBlockTwitterUser:(int)index;
+(NSString*)getBlockHashtag:(int)index;
+(int)getRandomOdds:(int)index;
+(UIColor*)getMessageColor;
+(UIColor*)getMessageOuchColor;
+(NSInteger)getWorldTime;
+(NSString *)getRandomWorldName;
+(NSString*)getCoinBarImageName;
+(UIImage*)getBlockImage;
+(NSString*)getTutoArrowImageName;
+(UIImage*)getTutoArrowImage;
+(UIImage*)getTutoArrowImage:(int)index;
+(NSString*)getBlockImageName;
+(NSString*)getBlockImageNameIndex:(int)index;
+(int)getBlockUnlockLevel:(int)index;
+(int)getBlockType:(int)index;
+(NSString*)getBlockTypeName:(int)index;
+(UIColor*)getBlockTypeColor:(int)index;



+(NSString*)getCoinImageName;
+(NSString*)getCoinImageName:(BOOL)random;
+(NSString*)getCoinImageNameIndex:(int)index random:(BOOL)random;
+(NSString *)getSkinBackground;
+(NSString *)getSkinBackground:(BOOL)random;
+(NSString *)getSkinBackgroundIndex:(int)index;
+(NSString *)getSkinBackgroundIndex:(int)index random:(BOOL)random;

+(UIImage*)getPowerupSquareImage:(PowerupType)type;
+(SKTexture*)getPowerupSquareImageTexture:(PowerupType)type;
+(SKTexture*)getPowerupSquareImageTexture:(PowerupType)type blur:(BOOL)blur;
+(UIImage*)getPowerupSquareImage:(PowerupType)type blur:(BOOL)blur;
+(NSString*)getPowerupSquareImageName:(PowerupType)type;
+(NSArray*)getAvailablePowerups;
+(NSArray*)getAvailablePowerupsWithLevel:(int)level;
@end
