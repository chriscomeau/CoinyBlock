//
//  UIView+Parallax.m
//  Outpost
//
//  Created by Skyriser Media on 2014-01-30.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "UIView+Parallax.h"
            
@implementation UIView(Parallax)

- (void)addMotionEffects:(CGFloat)depth
{
	UIInterpolatingMotionEffect *effectX;
	UIInterpolatingMotionEffect *effectY;
    effectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x"
                                                              type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    effectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y"
                                                              type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
	
	
	effectX.maximumRelativeValue = @(depth);
	effectX.minimumRelativeValue = @(-depth);
	effectY.maximumRelativeValue = @(depth);
	effectY.minimumRelativeValue = @(-depth);
	
	[self addMotionEffect:effectX];
	[self addMotionEffect:effectY];
}

- (void)expandFrame:(CGFloat)size withAnimate:(BOOL)animate;
{
    CGRect tempFrame = self.frame;
    tempFrame.size.width += size*2;
    tempFrame.size.height += size*2;
    
    tempFrame.origin.x -= size;
    tempFrame.origin.y -= size;

    if(animate)
    {
        
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.frame = tempFrame;
                         }
                         completion:^(BOOL finished){
                         }];
    }
    else {
        self.frame = tempFrame;
    }
}



@end