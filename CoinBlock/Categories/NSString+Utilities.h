//
//  NSString+Utilities.h
//  CoinBlock
//
//  Created by Skyriser Media on 2014-01-30.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GTMNSString+HTML.h"

@interface NSString (Utilities)
- (BOOL) isNumeric;
- (BOOL) contains:(NSString*)toCheck;
- (BOOL) isEqualToStringInsensitive:(NSString*)toCheck;
- (NSString *) stringFromTruncateTail:(int)atLength;
- (NSString *) stringFromRemoveAccents;
- (NSString *)stringCutByWordsToMaxLength:(int)lenght;
- (NSString *) stringFromCleanupHTML;
- (NSRange)fullRange;
@end