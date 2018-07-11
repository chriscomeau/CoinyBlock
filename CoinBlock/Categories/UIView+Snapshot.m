//
//  UIView+Snapshot.m
//  Enjoi
//
//  Created by Benjamin Bourasseau on 23/10/2014.
//  Copyright (c) 2014 Skyriser Media. All rights reserved.
//

#import "UIView+Snapshot.h"

@implementation UIView (Snapshot)

-(UIImage *)takeSnapShotAndBlur:(BOOL)blur{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    
    // old style [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(blur){
        return [image blurImage];
    } else {
        return image;
    }
}

@end
