//
//  SKLabelOutlineNode.m
//  CoinBlock
//
//  Created by Chris Comeau on 2017-07-07.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "SKLabelOutlineNode.h"


@interface SKLabelOutlineNode ()

@property(strong, nonatomic) SKLabelNode *labelNode;

@property (nonatomic, strong) SKLabelNode *top;
@property (nonatomic, strong) SKLabelNode *bottom;
@property (nonatomic, strong) SKLabelNode *left;
@property (nonatomic, strong) SKLabelNode *right;
@property (nonatomic, strong) SKLabelNode *drop;
@property (nonatomic) SKLabelOutlineNodeMode mode;

@end

@implementation SKLabelOutlineNode

-(void)setupShadows:(SKLabelOutlineNodeMode)mode offset:(int)offset color:(UIColor*)color fontName:(NSString*)fontName alpha:(float)alpha
{
    int newZ = -1;
    
    self.mode = mode;
    
    if(self.mode == kShadowModeOutline)
    {
        float fontSize = self.fontSize + 1;

        self.top = [SKLabelNode labelNodeWithFontNamed:fontName];
        [self.top setHorizontalAlignmentMode:self.horizontalAlignmentMode];
        [self.top setVerticalAlignmentMode:self.verticalAlignmentMode];
        self.top.name = [NSString stringWithFormat:@"%@_top_ignore", self.name];
        self.top.fontSize = fontSize;
        self.top.fontColor = color;
        self.top.zPosition = newZ--;
        self.top.alpha = alpha;
        self.top.text = self.text;
        self.top.position = CGPointMake(0, offset);
        [self addChild:self.top];
        
        self.bottom = [SKLabelNode labelNodeWithFontNamed:fontName];
        [self.bottom setHorizontalAlignmentMode:self.horizontalAlignmentMode];
        [self.bottom setVerticalAlignmentMode:self.verticalAlignmentMode];
        self.bottom.name = [NSString stringWithFormat:@"%@_bottom_ignore", self.name];
        self.bottom.fontSize = fontSize;
        self.bottom.fontColor = color;
        self.bottom.zPosition = newZ--;
        self.bottom.alpha = alpha;
        self.bottom.text = self.text;
        self.bottom.position = CGPointMake(0, - offset);
        [self addChild:self.bottom];
        
        self.left = [SKLabelNode labelNodeWithFontNamed:fontName];
        [self.left setHorizontalAlignmentMode:self.horizontalAlignmentMode];
        [self.left setVerticalAlignmentMode:self.verticalAlignmentMode];
        self.left.name = [NSString stringWithFormat:@"%@_left_ignore", self.name];
        self.left.fontSize = fontSize;
        self.left.fontColor = color;
        self.left.zPosition = newZ--;
        self.left.alpha = alpha;
        self.left.text = self.text;
        self.left.position = CGPointMake(-offset, 0);
        [self addChild:self.left];
        
        self.right = [SKLabelNode labelNodeWithFontNamed:fontName];
        [self.right setHorizontalAlignmentMode:self.horizontalAlignmentMode];
        [self.right setVerticalAlignmentMode:self.verticalAlignmentMode];
        self.right.name = [NSString stringWithFormat:@"%@_right_ignore", self.name];
        self.right.fontSize = fontSize;
        self.right.fontColor = color;
        self.right.zPosition = newZ--;
        self.right.alpha = alpha;
        self.right.text = self.text;
        self.right.position = CGPointMake(offset, 0);
        [self addChild:self.right];
    }
    
    else if (self.mode == kShadowModeDrop || self.mode == kShadowModeDrop2 )
    {
        float fontSize = self.fontSize;

        self.drop = [SKLabelNode labelNodeWithFontNamed:fontName];
        [self.drop setHorizontalAlignmentMode:self.horizontalAlignmentMode];
        [self.drop setVerticalAlignmentMode:self.verticalAlignmentMode];
        self.drop.name = [NSString stringWithFormat:@"%@_drop_ignore", self.name];
        self.drop.fontSize = fontSize;
        self.drop.fontColor = color;
        self.drop.zPosition = newZ--;
        self.drop.alpha = alpha;
        self.drop.text = self.text;
        
        if(self.mode == kShadowModeDrop)
            self.drop.position = CGPointMake(offset, -offset);
        else if(self.mode == kShadowModeDrop2)
            self.drop.position = CGPointMake(0, -offset);
        
        [self addChild:self.drop];
    }
    else
    {
        if([kHelpers isDebug])
            assert(0);
    }
        
    
}

- (void) setText:(NSString *)text
{
    //override
    [super setText:text];
    
    [self updateText:text];
}

-(void)updateText:(NSString*)newText
{
    if(self.mode == kShadowModeOutline)
    {
        //self.text =
        self.top.text = self.bottom.text = self.left.text = self.right.text = newText;
    }
    
    else if (self.mode == kShadowModeDrop)
    {
        //self.text =
        self.drop.text = newText;
    }
    else
    {
        if([kHelpers isDebug])
            assert(0);
    }

}

@end
