//
//  TodayConfig.h
//

#ifdef DEBUG
#define kNum1up 100
#define k1upMult 1.04f
#else
#define kNum1up 100
#define k1upMult 1.04f
#endif

//blocks
enum {
    kCoinTypeDefault = 0,
    kCoinTypeMine,
    kCoinTypeZelda,
    kCoinTypeBitcoin,
    kCoinTypeEmoji,
    kCoinTypeYoshi,
    kCoinTypeSonic,
    kCoinTypeFlap,
    kCoinTypeGameboy,
    kCoinTypeTA,
    kCoinTypePew,
    kCoinTypeBrain,
    kCoinTypeMario,
    
    kNumSkins
};
enum {
    //disabled
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
