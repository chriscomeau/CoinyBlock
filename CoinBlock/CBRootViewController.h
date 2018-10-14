//
//  CBRootViewController.h
//  CoinBlock
//
//  Created by Chris Comeau on 2014-11-06.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBRootViewController : UIViewController

-(void)launch;
-(void)hideSplash;
-(UIViewController*)currentViewController;
-(void)setViewController:(UIViewController*)viewController;
@end
