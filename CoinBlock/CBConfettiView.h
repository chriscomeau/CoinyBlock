//
//  CBConfettiView.h
//  CoinBlock
//
//  Created by Chris Comeau on 2015-05-18.
//  Copyright (c) 2015 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBConfettiView : UIView

-(void)setup:(int)birthRate;
- (void) startEmitting:(int)birthRate;
- (void) stopEmitting:(BOOL)animate;

@end
