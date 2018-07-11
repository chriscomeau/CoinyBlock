//
//  MenuViewController.h
//  Emergency
//
//  Created by Chris Comeau on 2014-05-20.
//  Copyright (c) 2014 Face 3 Media. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
enum {
    menuStateGame = 1,
    menuStateSettings = 2,
    menuStateStore = 3,
    menuStateTitle = 3,
};
*/

@interface MenuViewController : UIViewController

@property (nonatomic) int menuState;

- (void)updateUI;


@end
