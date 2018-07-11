//
//  UIView+Parallax.h
//  Outpost
//
//  Created by Skyriser Media on 2014-01-30.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Parallax)

- (void)addMotionEffects:(CGFloat)depth;
- (void)expandFrame:(CGFloat)size withAnimate:(BOOL)animate;

@end
