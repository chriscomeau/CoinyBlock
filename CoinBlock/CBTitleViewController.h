//
//  CBTitleViewController.h
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"

@interface CBTitleViewController : UIViewController <iCarouselDataSource, iCarouselDelegate>


enum {
    menuStateNone = 0,
    
    menuStateGame = 1,
    menuStateSettings = 2,
    menuStateStore = 3,
    menuStateTitle = 4,
    
    menuStateCheat = 5,
    menuStateAbout = 6,
    menuStateWin = 7,
    
    menuStateLoading = 8,
    
    menuStateTransition = 9,
    menuStateVideo = 10,
    menuStateStory = 11,
    
    menuStatePremium = 12,
    menuStateEnding = 13,
};

@property (nonatomic) int menuState;
@property (strong, nonatomic) NSNumber *numApps;

-(void)refillHeartAlert2;
-(void)unlockedSkinReward;
-(void)setNumHearts:(int)many;
-(void)updateTitleCount;
-(void)updateUI;
-(void)resetTimerStory;
-(BOOL)chestReady;
-(BOOL)downloadAvailable;
@end
