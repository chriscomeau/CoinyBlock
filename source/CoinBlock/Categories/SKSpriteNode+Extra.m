//
//  SKSpriteNode+Extra.m
//  CoinBlock
//
//  Created by Chris Comeau on 2017-08-12.
//  Copyright © 2017 Skyriser Media. All rights reserved.
//

#import "SKSpriteNode+Extra.h"

@implementation SKSpriteNode (Extra)

-(void)addGlow
{
    [self addGlow:30.0f];
}

-(void)addGlow:(float)radius
{
    //disabled
    return;

#if 0
    //https://stackoverflow.com/questions/40362204/add-glowing-effect-to-an-skspritenode

//    let effectNode = SKEffectNode()
//    effectNode.shouldRasterize = true
//    addChild(effectNode)
//    effectNode.addChild(SKSpriteNode(texture: texture))
//    effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])

    SKEffectNode *effectNode = [SKEffectNode node];
    effectNode.name = @"glow_effect_ignore";
    effectNode.shouldRasterize = YES;
    [self addChild:effectNode];

    SKSpriteNode *newChild = [SKSpriteNode spriteNodeWithTexture:self.texture];
    newChild.name = @"glow_ignore";
    [effectNode addChild:newChild];
    effectNode.filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:@"inputRadius", @(radius), nil];
#endif
}

-(void)removeChildrenNamed:(NSString*)name {

    NSMutableArray *array = [NSMutableArray array];
    for (SKNode* child in self.children){
        if([child.name isEqualToString:name]) {
            [array addObject:child];
        }
    }

    [self removeChildrenInArray:array];
}

@end
