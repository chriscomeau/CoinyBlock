//
//  SKLabelOutlineNode.h
//  CoinBlock
//
//  Created by Chris Comeau on 2017-07-07.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SKLabelOutlineNode : SKLabelNode

typedef enum {
    kShadowModeNone = -1,
    kShadowModeOutline = 0,
    kShadowModeDrop = 1,
    kShadowModeDrop2 = 2,
} SKLabelOutlineNodeMode;

-(void)setupShadows:(SKLabelOutlineNodeMode)mode offset:(int)offset color:(UIColor*)color fontName:(NSString*)fontName alpha:(float)alpha;

@end
