//
//  BitmapFontNode.h
//  SSBitmapFontLabel
//
//  Created by Mike Daley on 23/10/2013.
//  Copyright (c) 2013 71Squared. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SSBitmapFontLabelNode;

#pragma mark -
#pragma mark NSError codes

enum BitmapFontNodeErrorCodes {
    D_BMFN_SUCCESS = 0,
    
    D_BMFN_FILE_NOT_FOUND,
    D_BMFN_URL_CANNOT_BE_NIL,
    D_BMFN_ATLAS_FILE_NOT_FOUND,
    D_BMFN_CONTROL_FILE_NOT_FOUND,
    
    D_BMFN_BAD_HEADER,
    D_BMFN_BAD_INFO_BLOCK_TYPE,
    D_BMFN_BAD_COMMON_BLOCK_TYPE,
    D_BMFN_BAD_PAGE_BLOCK_TYPE,
    D_BMFN_BAD_CHAR_BLOCK_TYPE,
    D_BMFN_BAD_KERNING_BLOCK_TYPE
};

#pragma mark -
#pragma mark Public Interface

@interface SSBitmapFont : NSObject

#pragma mark -
#pragma mark Properties

/// Size of the original ttf font in points
@property (nonatomic, assign) NSUInteger fontSize;
/// Name of the font
@property (nonatomic, strong) NSString *fontName;
/// Line height of the font
@property (nonatomic, assign) NSUInteger lineHeight;
/// Based for the font
@property (nonatomic, assign) NSUInteger base;
/// Padding used around each glyph image
@property (nonatomic, assign) NSUInteger paddingLeft, paddingTop, paddingRight, paddingBottom;
/// Spacing used between the glyph images on the texture atlas
@property (nonatomic, assign) NSUInteger horizontalSpacing, verticalSpacing;
/// Filename of the texture atlas being used for this font
@property (nonatomic, strong) NSString *atlasFileName;
/// Control filename used to create font
@property (nonatomic, strong) NSString *controlFileName;

#pragma mark -
#pragma mark Public Methods

/** Create a new Bitmap Font Factory using the specified binary control file
 @param     url         The URL that points to the binary control file
 @param     error       The error that occurred should the control file not be processed
 @result    New instance of BitmapFontFactory using the supplied binary control file
 */
- (instancetype)initWithFile:(NSURL *)url error:(NSError **)error;

/** Returns a new instance of SSBitmapFontLabelNode with the specified string as it's text
 @param     string      String to be used to set the text for the label
 @reault    New instance of SSBitmapFontLabelNode
 */
- (SSBitmapFontLabelNode *)nodeFromString:(NSString *)string;

@end
