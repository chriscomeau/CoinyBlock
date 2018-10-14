//
//  CBLoadingViewController.h
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBLoadingViewController : UIViewController

-(void)fadeIn;
-(void)fadeOut;
-(void)checkForUpdates;
-(void)hideCheckForUpdates;
-(void)updateProgressBar:(float)pourcentage;
-(void)enableAutoProgress:(BOOL)enable;
@end
