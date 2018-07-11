//
//  CBCheatViewController.h
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCAnimatedLabel.h"
#import "ZCRevealLabel.h"

@interface CBCheatViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic) BOOL backToGame;

@end
