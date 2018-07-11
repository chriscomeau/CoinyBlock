//
//  NSError+Utilities.m
//  CoinBLock
//
//  Created by Chris Comeau on 2015-01-05.
//  Copyright (c) 2015 Skyriser Media. All rights reserved.
//

#import "NSError+Utilities.h"
            
@implementation NSError (Utilities)

- (NSString *) errorString{
    
    NSString *newString = nil;
    
    newString = [self.userInfo objectForKey:@"error"];
    
    if(!newString)
        newString = self.localizedDescription;
    
    return newString;
}

@end
