//
//  SKSpriteNode+Extra.m
//  CoinBlock
//
//  Created by Chris Comeau on 2017-08-12.
//  Copyright © 2017 Skyriser Media. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKSpriteNode (Extra)

- (void)addGlow;
- (void)addGlow:(float)radius;
- (void)removeChildrenNamed:(NSString*)name;

@end
