//
//  CBConfettiView.m
//  CoinBlock
//
//  Created by Chris Comeau on 2015-05-18.
//  Copyright (c) 2015 Skyriser Media. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CBConfettiView.h"

//test

@implementation CBConfettiView {
    __weak CAEmitterLayer *_confettiEmitter;
    CGFloat _decayAmount;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        //[self setup:150];
    }
    
    return self;
}

-(void)setup:(int)birthRate
{
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 0.0f;
    
    [self.layer removeAllAnimations];

    _confettiEmitter = (CAEmitterLayer*)self.layer;
    _confettiEmitter.emitterPosition = CGPointMake(self.bounds.size.width /2, 0);
    _confettiEmitter.emitterSize = self.bounds.size;
    _confettiEmitter.emitterShape = kCAEmitterLayerLine;
    
    CAEmitterCell *confetti = [CAEmitterCell emitterCell];
    confetti.contents = (__bridge id)[[UIImage imageNamed:@"confetti3"] CGImage];
    confetti.name = @"confetti";
    confetti.birthRate = 100; //150;
    confetti.lifetime = 5.0;
    confetti.color = [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor];
    confetti.redRange = 0.8;
    confetti.blueRange = 0.8;
    confetti.greenRange = 0.8;
    
    confetti.velocity = 250;
    confetti.velocityRange = 50;
    confetti.emissionRange = (CGFloat) M_PI_2;
    confetti.emissionLongitude = (CGFloat) M_PI;
    confetti.yAcceleration = 150;
    confetti.scale = 1.0;
    confetti.scaleRange = 0.2;
    confetti.spinRange = 10.0;
    _confettiEmitter.emitterCells = [NSArray arrayWithObject:confetti];

}

+ (Class) layerClass {
    return [CAEmitterLayer class];
}

static NSTimeInterval const kDecayStepInterval = 0.1;
- (void) decayStep {
    _confettiEmitter.birthRate -=_decayAmount;
    if (_confettiEmitter.birthRate < 0) {
        _confettiEmitter.birthRate = 0;
    } else {
        [self performSelector:@selector(decayStep) withObject:nil afterDelay:kDecayStepInterval];
    }
}

- (void) decayOverTime:(NSTimeInterval)interval {
    _decayAmount = (CGFloat) (_confettiEmitter.birthRate /  (interval / kDecayStepInterval));
    [self decayStep];
}

- (void) startEmitting:(int)birthRate {

    [self setup:birthRate];
    //_confettiEmitter.birthRate = 1;

    [_confettiEmitter setValue:@(birthRate) forKeyPath:@"emitterCells.confetti.birthRate"];
    
    //reset
    self.alpha = 0.0f;

    float duration = 0.5f;
    [UIView animateWithDuration:duration delay:0.0 options:0 animations:^{
        
        self.alpha = 0.8f;
        
    }
    completion:^(BOOL finished){
                     }];


}

- (void) stopEmitting:(BOOL)animate {
    //if(animate)
    //    [self decayOverTime:kDecayStepInterval];
    //else
    //    _confettiEmitter.birthRate = 0.0;
    
    [_confettiEmitter setValue:@0 forKeyPath:@"emitterCells.confetti.birthRate"];

    //[dustEmitter setValue:[NSNumber numberWithFloat:0.0]
    //           forKeyPath:@"emitterCells.cloud.emitterCells.dust.birthRate"];
    
    //self.alpha = 0.8f;

    /*if(animate) {
        float duration = 0.5f;
        [UIView animateWithDuration:duration delay:0.0 options:0 animations:^{
            
            self.alpha = 0.0f;
        }
         completion:^(BOOL finished){
         }];
    }*/

}

@end
