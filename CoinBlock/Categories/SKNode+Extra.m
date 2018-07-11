//
//  SKNode+Extra.m
//  CoinBlock
//
//  Created by Chris Comeau on 2017-08-12.
//  Copyright © 2017 Skyriser Media. All rights reserved.
//

#import "SKNode+Extra.h"

@implementation SKNode (Extra)

-(void)enable:(BOOL)value
{
    if(value)
    {
        self.name = [self.name stringByReplacingOccurrencesOfString:@"_ignore" withString:@""];
    }
    else
    {
        self.name = [self.name stringByAppendingString:@"_ignore"];
    }
}

@end
