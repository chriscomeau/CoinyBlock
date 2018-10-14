//
//  SSBitmapFontNode.h
//  SSBitmapFontLabel
//
//  Created by Mike Daley on 25/10/2013.
//  Copyright (c) 2013 71Squared. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SSBitmapFont;

typedef NS_ENUM(NSInteger, SSBMFLabelVerticalAlignmentMode) {
    SSBMFLabelVerticalAlignmentModeBaseline    = 0,
    SSBMFLabelVerticalAlignmentModeCenter      = 1,
    SSBMFLabelVerticalAlignmentModeTop         = 2,
    SSBMFLabelVerticalAlignmentModeBottom      = 3,
};

typedef NS_ENUM(NSInteger, SSBMFLabelHorizontalAlignmentMode) {
    SSBMFLabelHorizontalAlignmentModeCenter    = 0,
    SSBMFLabelHorizontalAlignmentModeLeft      = 1,
    SSBMFLabelHorizontalAlignmentModeRight     = 2,
};

@interface SSBitmapFontLabelNode : SKSpriteNode

#pragma mark -
#pragma mark Public Properties

/// Shows the boundary of the label. Handy for debugging
@property (nonatomic, assign) BOOL showOutline;
/// Defines the color of the outline if drawn. Default is red
@property (nonatomic, strong) SKColor *outlineColor;
/// The text to be displayed within the label
@property (nonatomic, strong) NSString *text;
/// Defines the labels verticla alignment mode
@property (nonatomic, assign) SSBMFLabelVerticalAlignmentMode verticalAlignmentMode;
/// Defines the labels horizontal alignment mode
@property (nonatomic, assign) SSBMFLabelHorizontalAlignmentMode horizontalAlignmentMode;

@end
