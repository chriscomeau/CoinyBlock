//
//  NSString+Utilities.m
//  CoinBlock
//
//  Created by Skyriser Media on 2014-01-30.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "NSString+Utilities.h"
            
@implementation NSString (Utilities)

- (BOOL) isNumeric {
    //http://stackoverflow.com/questions/2020360/how-to-check-if-nsstring-is-numeric-or-not
    BOOL value = NO;

    //valid numeric id?
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier: @"en_US"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale: locale];
    [formatter setAllowsFloats: NO];
    
    NSNumber* num = [formatter numberFromString:self];
    if(num)
        value = YES;
    
    return value;
}

- (BOOL) contains:(NSString*)toCheck
{
    if(toCheck == nil)
        return NO;
    
    NSRange parametersRange = [self rangeOfString:toCheck];
    if (parametersRange.location == NSNotFound)
        return NO;
    else
        return YES;
}

- (BOOL) isEqualToStringInsensitive:(NSString*)toCheck
{
    if(toCheck == nil)
        return NO;

    return ([self caseInsensitiveCompare:toCheck] == NSOrderedSame);
}


- (NSString *) stringFromTruncateTail:(int)atLength {
    if([self length] > atLength)
    {
        NSString *temp = [self substringToIndex:atLength - 4]; //-1 for lenght-1, and -3 for ...
        temp = [temp stringByAppendingString:@"..."];
        return temp;
    }
    else
    {
        return self;
    }
}

- (NSString *) stringFromRemoveAccents {

    NSString* temp = [[NSString alloc] initWithData: [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES] encoding:NSASCIIStringEncoding];
    //NSString* temp = [[self componentsSeparatedByCharactersInSet:[[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
    return temp;
}

// cut a string by words
- (NSString *)stringCutByWordsToMaxLength:(int)length
{
    __block NSMutableString *newString = [NSMutableString string];
    NSArray *components = [self componentsSeparatedByString:@" "];
    if ([components count] > 0) {
        NSString *lastWord = [components objectAtIndex:[components count]-1];
        
        [components enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if (([obj length]+[newString length] + [lastWord length] + 2) < length) {
                [newString appendFormat:@" %@", obj];
            } else {
                [newString appendString:@"…"];
                //[newString appendFormat:@" %@", lastWord];
                *stop = YES;
            }
        }];
        
    }
    return newString;
}

- (NSString *) stringFromCleanupHTML{
    NSString *newString = self;
    newString = [newString gtm_stringByUnescapingFromHTML];
    //newString = [NSString stringWithUTF8String:[newString cStringUsingEncoding:[NSString defaultCStringEncoding]]];
    
    return newString;
}

- (NSRange)fullRange {
	return (NSRange){0, self.length};
}

@end
