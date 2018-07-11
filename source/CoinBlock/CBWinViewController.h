//
//  CBWinViewController.h
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZCAnimatedLabel.h"
//#import "ZCThrownLabel.h"
//#import "ZCShapeshiftLabel.h"
//#import "ZCDuangLabel.h"
//#import "ZCFallLabel.h"
//#import "ZCTransparencyLabel.h"
//#import "ZCFlyinLabel.h"
//#import "ZCFocusLabel.h"
//#import "ZCRevealLabel.h"
//#import "ZCSpinLabel.h"
//#import "ZCDashLabel.h"

@interface CBWinViewController : UIViewController 

@property (nonatomic) BOOL backToGame;
@property (nonatomic) BOOL backToGameMenu;
@property (nonatomic) BOOL backToTitle;
//@property (nonatomic) int numCheatStars;
-(void)actionInit;
-(void)actionDone;

@end